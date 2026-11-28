---
id: "4-01"
org: 专题·JEPA系列
short: "InJePA"
title: "InJepa: Intention-First Latent Planning with Coupled JEPA World Models for Visual Navigation"
aliases: ["InJePA", "InJepa", "Intention-First Latent Planning"]
date: 2026-09-28
category: "导航、驾驶与机器人应用"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "电子科技大学；西安建筑科技大学"
partners: []
authors: ["Siming Zhou", "Bowen Ma", "Ruiran Du", "Pengcheng Zheng", "Sheng Zheng", "Dongshen Han", "Zhijie Li", "Wei Dong", "Fan Mo", "Chaoning Zhang"]
arxiv: "2610.23896"
pdf: "[[topics/papers/JEPA系列/4-01_2610.23896_InJePA.pdf]]"
code: "https://github.com/zhuxun132/InJepa"
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "visual-navigation", "image-goal-navigation", "latent-planning", "habitat"]
---

# InJepa: Intention-First Latent Planning with Coupled JEPA World Models for Visual Navigation

> [!info] 论文信息
> arXiv [2610.23896](https://arxiv.org/abs/2610.23896) · v1 2026-09-28 · 26 页（正文 10 页 + 附录 A–F）
> [代码](https://github.com/zhuxun132/InJepa)
> PDF：[[topics/papers/JEPA系列/4-01_2610.23896_InJePA.pdf|本地 PDF]]
> 作者：Siming Zhou、Bowen Ma、Ruiran Du、Pengcheng Zheng、Sheng Zheng、Dongshen Han、Fan Mo、Chaoning Zhang\*（电子科技大学）；Zhijie Li、Wei Dong（西安建筑科技大学）。\* 通讯作者
> 专题：[[topics/JEPA系列#四、导航、驾驶与机器人应用|JEPA系列 · 四]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录 A–F 的实现、基线复现和延迟表）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 现有范式："Representative navigation world model methods propose complete action candidates before predicting consequences for selection or search updates."（Abstract，p.1）
> - 动作优先的局限："Although consequence evaluation can guide subsequent search, the current candidate's actions are fixed before prediction."（§1，p.2）
> - 意图的定义："We define an intention as a candidate desired latent state conditioned on the goal"（§1，p.2）
> - 构造顺序："Intention first planning thus specifies the order of plan construction at each step, without fixing an entire intention trajectory in advance."（§3.2，p.4）
> - 没有意图标签："Offline trajectories provide no explicit intention labels."（§3.5，p.5）
> - LWM-CroCo 最强："LWM-CroCo performs best but declines noticeably with V-JEPA 2.1"（§4.2.1，p.7–8）
> - 动作优先版更差："Action-first InJepa generates actions directly from the final goal and retains F for consequence feedback and candidate selection, yet its SR and SPL are lower even than Post hoc F"（§4.3.1，p.9）
> - 规划步长："With K = 16, navigation improves up to H = 4 but declines at H = 8"（§4.3.2，p.9）
> - 三个种子只变评估采样："The three navigation seeds vary evaluation sampling, not training initialization."（附录 D.2，p.17）
> - 预算不等："These budgets preserve the respective deployment procedures and do not constitute an equal compute comparison."（附录 E.2，p.23）

## 一句话总结

现有导航世界模型（NWM、RAE-NWM、LWM）是"动作优先"：先由策略或优化器提出完整的动作序列，世界模型只负责事后评估。InJepa 改成"**意图优先**"：在冻结 V-JEPA 2.1 特征的共享潜空间里，一个目标条件的 **Proposal JEPA**（CVAE 式先验采样）提出下一步想到达的潜状态（意图），动作模型 G 把"意图 − 当前状态"翻译成离散动作，动作条件的 **Forward JEPA** 预测执行后的潜状态，再把预测结果喂回下一步的意图和动作——每个候选内部形成"意图 → 动作 → 后果"闭环；最后按终点离目标的距离 + 意图实现误差选候选，只执行第一步。Habitat MP3D 图像目标导航（Clean150，150 个未见场景任务）上 SR 65.33% / SPL 0.6147，高于 NoMaD、RAE-NWM 和同编码器的 LWM-VJEPA（42.44%），但低于用 CroCo 的 LWM（70.22%）。

## 要解决什么问题

- **图像目标导航**：从当前观测出发，只给一张目标图，在离散动作（前进 / 左转 / 右转 / 停）下走到目标 1 m 以内。
- 现有学习方法：要么目标条件策略直接出动作（ViNT、NoMaD），要么世界模型预测未来图像 / 潜状态 / 后果–目标兼容度来比较候选（NWM、RAE-NWM、LWM 等）。
- 作者指出"动作优先"的构造顺序限制了世界模型的作用：想要的状态变化只能通过动作候选**间接**确定；每个候选的动作在预测前就定死了，预测只评估、不参与该候选后续动作的逐步生成。
- 问：能不能让世界模型**主导**计划的逐步构造——先提出想要的变化，再联合推理意图和后果？

## 方法

### 问题设定（§3.1）

- 冻结视觉编码器 Y（默认 V-JEPA 2.1 ViT-B，从 ViT-G 蒸馏，384 分辨率）把当前观测和目标图映射成空间特征网格 z_t, z_g ∈ R^{S×D}（V-JEPA 2.1 为 24×24 token、D=768）。
- 规划时从当前状态展开 K 个候选、每个 H 步（默认 K=8、H=4）。

### 三个模块（§3.2–3.4，图 2）

| 模块 | 输入 → 输出 | 作用 |
|---|---|---|
| **Proposal JEPA Q**（参数 φ，含记忆与先验） | 记忆编码器 m_t = M_φ(c_t, z_g)（最近 4 帧网格 + 历史动作嵌入 + 目标网格）；候选变量 ξ^k ~ N(μ_φ(m_t), diag σ²_φ(m_t))（L=128 维，整个候选内固定）；每步 p^k_h = Q_φ(f^k_{h−1}, m_t, ξ^k) | 提出意图：候选想到达的下一个潜状态。第 1 步输入真实状态 z_t，之后输入 F 的预测 |
| **动作模型 G**（θ） | a^k_h = argmax_{a ∈ A_move} π_θ(a \| f^k_{h−1}, p^k_h − f^k_{h−1}, a^k_{h−1}) | 把"意图 − 当前（预测）状态"的差翻译成动作；沿用 INTACT 的结构 |
| **Forward JEPA F**（ψ） | f^k_h = F_ψ(C^k_{h−1}, U^k_h)：滚动的 4 帧观测/预测状态上下文 + 对齐的出发动作 | 预测执行动作后的潜状态，喂回 Q 和 G |

**候选打分（式 6–7）**：d₁(x,y) = ‖x−y‖₁/(SD)。相对意图实现误差 r^k_h = d₁(p^k_h, f^k_h) / d̄₁(p^k_h, f^k_{h−1})（请求的变化可忽略时下限为 1）。

J^k = d₁(f^k_H, z_g) / d̄₁(z_t, z_g) + λ_c · max_h r^k_h

选 J 最小的候选，**只执行第一步动作**，然后用新的真实观测重新规划（MPC 式）。默认 λ_c = 1。候选只含移动动作；停止由到达判定（离目标 < 1 m）处理。

### 训练（§3.5）

离线轨迹没有意图标签，用记录的下一帧 z_{t+1} 监督 Q 和 F、记录的动作监督 G：

| 损失 | 定义 | 监督谁 |
|---|---|---|
| L_Q（式 8） | CVAE：后验 R_η(ξ \| c_t, z_g, z_{t+1}) 采样得训练意图 p，Laplace NLL 重建 z_{t+1}（b = 1/√2）+ β=0.05 的归一化 KL 把后验拉向只看上下文和目标的先验 | Q 及其先验 / 后验；推理只用先验 |
| L_F（式 9） | 预测 z_{t+1} 的 MSE（目标冻结、stop-gradient） | F |
| L_G,local / L_G,goal（式 10） | INTACT 的双分支：相邻真实状态差 → 动作；轨迹终点状态差 → 动作（终点处零差 → STOP） | G |
| L_QG（式 11） | 用后验意图 sg(p) − z_t 预测记录动作，梯度在 p 处截断 | 只训 G，让它学会解读意图 |

总损失 L = L_Q + L_F + 0.1·L_G,local + 0.05·L_G,goal + 0.1·L_QG（表 8）。视觉编码器冻结，其余模块从零训练，可训练参数约 1.35 亿；AdamW、全局 batch 128、BF16，学习率按 30 epoch 余弦计划但取第 12 epoch 的 checkpoint（约 6 万步）。

## 实验与关键数字

**设置**：训练用 StreamVLN 公开的 R2R/RxR RGB + 动作轨迹（Habitat MP3D；50 栋楼 8,004 条训练轨迹，11 栋楼 2,265 条验证轨迹，不用语言指令）。评测 Clean150：11 个训练和验证都没见过的场景里 150 个固定任务，平均初始测地距离 7.93 m，每任务最多 200 步，到目标 1 m 内算成功。指标 Reach SR（%）和 ReachSPL。三个种子**只改变评估采样，不改训练初始化**。

### 1. 闭环导航（表 1，3 个种子均值 ± SD）

| 方法 | SR ↑ | SPL ↑ |
|---|---|---|
| NoMaD（官方权重，去掉拓扑地图） | 28.22±1.39 | 0.1895±0.0159 |
| RAE-NWM（同数据复现，Euler 10 点） | 13.33±2.00 | 0.0534±0.0070 |
| **LWM-CroCo**（官方实现，CroCo-v2） | **70.22±1.02** | **0.6780±0.0075** |
| LWM-VJEPA（只换成 V-JEPA 2.1） | 42.44±0.77 | 0.3798±0.0242 |
| InJepa-DINOv3 | 53.11±3.01 | 0.4861±0.0317 |
| InJepa-CroCo | 61.78±0.38 | 0.5670±0.0127 |
| **InJepa-VJEPA**（默认） | 65.33±2.67 | 0.6147±0.0203 |

- 三个 InJepa 变体都超过 NoMaD、RAE-NWM、LWM-VJEPA；**最强的是 LWM-CroCo**。作者解释 LWM 的优势和 CroCo 表征与"兼容度评估"的契合有关（可能还得益于专门为候选打分训练），换成 V-JEPA 2.1 就掉到 42.44%；同用 V-JEPA 时 InJepa 高 22.9 个点。
- 换编码器时沿用 V-JEPA 的超参，没有逐编码器调优。
- 图 3 定性例子：同一任务（初始 8.38 m）InJepa 39 步到达，LWM-CroCo 33 步到达，LWM-VJEPA、NoMaD、RAE-NWM 都用完 200 步没到；RAE-NWM 走了 34.52 m 却仍在起点 1.74 m 内打转。

### 2. 规划机制消融（表 2、表 3，同一套权重）

| 部署方式 | SR ↑ | SPL ↑ | Q 未来对齐误差（均值）↓ | 意图实现误差（均值）↓ |
|---|---|---|---|---|
| Proposal only（不用 F） | 31.78±3.42 | 0.2526±0.0217 | 0.5346 | 0.3384 |
| Post hoc F（F 只用于打分） | 56.00±1.76 | 0.5126±0.0220 | 0.5346 | 0.3090 |
| F → G（后果反馈给 G） | 59.56±3.01 | 0.5425±0.0289 | 0.5346 | 0.3022 |
| **F → Q+G（完整）** | **65.33±2.67** | **0.6147±0.0203** | **0.5282** | **0.2222** |
| Action-first InJepa（去掉 Q，G 直接用最终目标，保留 F 反馈和打分） | 42.89±5.00 | 0.3581±0.0428 | — | — |

- 前三种不改变 Q 的输入，所以 Q 对齐误差相同；只有完整反馈让 Q 基于预测后继状态提意图。
- Action-first 版比 Post hoc F 还差 → 作者据此认为"先提局部意图、再翻译成动作"比"直接朝最终目标出动作"更好。
- 意图实现误差随 h 增大（完整版 h=1 0.1450 → h=4 0.2916）。

### 3. 规划配置（图 4，附录 A 表 4–6，多为 seed 0）

- K=16 时 H 增到 4 导航变好，H=8 下降；H=4 时多候选好于单候选，但 K 再大不一定更好（K 增大只提高参考未来的覆盖，候选间平均距离基本不变）。
- K=4、H=4 完整反馈三种子 63.78±3.67 / 0.6098，略低于 K=8 的 65.33。
- λ_c = 1 好于 0（不罚实现误差）和更大权重。

### 4. 训练监督消融（图 5）

- 去掉 L_G,local：G Local 准确率下降、导航降幅最大；
- 去掉 L_QG：G Local 基本不变，但实现误差上升、导航下降 → 从真实转移学到的动作推断替代不了"读意图"的监督；
- 去掉 L_G,goal：G Goal 准确率明显下降，闭环导航只略变；F 预测误差在各配置下相近。

### 5. 规划延迟（附录 E.4 表 15，单个任务、单张 RTX 3090，毫秒）

| 方法 | 均值 | P95 |
|---|---|---|
| NoMaD | 106.13 | 107.54 |
| LWM-CroCo | 413.12 | 655.63 |
| LWM-VJEPA | 611.55 | 921.40 |
| RAE-NWM（Euler10） | 28,357.95 | 28,383.00 |
| InJepa-CroCo | 527.60 | 545.02 |
| InJepa-DINOv3 | 568.38 | 584.16 |
| InJepa-VJEPA | 1,421.23 | 1,456.28 |

（只在 Clean150 第 0 个任务上测，作者说明不代表跨场景平均。）

## 局限 / 存疑

> 结论里作者只提了"长时域预测误差累积"和"动态环境"两个未来方向；下面多数是 Claude 的推断，请核对。

- **不是 SOTA**：最强基线 LWM-CroCo（70.22% / 0.6780）仍高于 InJepa 所有变体；"意图优先优于动作优先"的论据主要来自同编码器比较（vs LWM-VJEPA）和内部消融。
- **方差来源有限**：三个"种子"只改变评估采样，没有重训；Clean150 只有 150 个任务、11 个场景，SR 一个任务约 0.67 个百分点。
- **基线复现的公平性**：RAE-NWM 为了降成本把 Euler 积分从 50 点降到 10 点（原设置部分评测 7 个任务里只成功 1 个，样本太少）；NoMaD 用官方权重、没在 StreamVLN 上重训且去掉了拓扑地图模块；各方法动作接口不同（InJepa 离散前进/转向，RAE-NWM/LWM 连续控制，NoMaD 走 PD 控制器）、规划预算不同（InJepa 8×4，RAE-NWM 120×8，LWM 32×最多 63），作者明说不是等算力比较。
- **延迟**：默认的 InJepa-VJEPA 每次规划约 1.4 s，是 LWM-CroCo 的 3 倍多；而且只在一个任务上测。
- **只在静态室内仿真**：Habitat MP3D 静态场景、离散动作，没有真机、没有动态障碍。
- **意图只监督一步**：Q 只用下一帧当目标训练（supervised horizon 1），多步意图靠递归展开，H=8 时性能下降和实现误差随 h 增长一致，说明误差累积是实际瓶颈。
- **附录 A 的部分 K/H 配置只有 seed 0、且不完整**（表 5 说"incomplete evaluations are excluded"）。
- 语言指令在训练数据里有但没用——这是图像目标导航，不是 VLN。

## 与其他论文的关系

- **编码器**：[[topics/notes/JEPA系列/2-03_V-JEPA2|V-JEPA 2]] 一系（本文用 V-JEPA 2.1 ViT-B）；Forward JEPA 的滚动上下文写法引自 V-JEPA 2 的动作条件预测器，MPC 式"只执行第一步再重规划"也沿用 V-JEPA 2 的做法。对比编码器还有 DINOv3、CroCo-v2。
- **导航世界模型基线**：NWM（生成式视频预测）、RAE-NWM（DINOv2 特征上的潜空间流匹配 + CEM）、LWM（学后果–目标兼容度做候选选择）；目标条件策略 NoMaD / ViNT。
- **状态空间规划 / 意图到动作**：INTACT（由目标与当前状态之差推断动作，G 的结构和双分支监督直接来自它）、FF-JEPA（预测潜子目标再用 CEM 实现）、HWM、LDP。
- 与本系列世界模型篇的区别：[[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]]、[[topics/notes/JEPA系列/1-05_LeWM|LeWM]]、[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 都是"CEM 采样动作 → 世界模型评估"的动作优先范式；InJepa 把规划对象换成潜状态意图。
- 导航专题：[[topics/视觉语言导航VLN|视觉语言导航VLN]]（训练数据来自 StreamVLN 的 R2R/RxR 轨迹，但本文不用语言）；同系列导航应用还有 [[topics/notes/JEPA系列/4-02_JEPTERA|JEPTERA]]（无人机）、[[topics/notes/JEPA系列/4-03_Auto-JEPA|Auto-JEPA]]（自动驾驶）。
- 系列总览：[[topics/JEPA系列]]。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Visual navigation requires goal directed planning informed by predictions of environment dynamics. Representative navigation world model methods propose complete action candidates before predicting consequences for selection or search updates. For each candidate, predictions primarily evaluate proposed actions rather than guide its stepwise construction. To this end, we propose InJepa, an intention first planning paradigm centered on latent states. A goal conditioned JEPA proposes latent intentions, and an action conditioned JEPA continually predicts future latent states. Both operate in a shared latent space to align their predictive representations. Within each candidate, predicted consequences feed into the next intention proposal and action inference, forming a closed loop of intention, action, and consequence. This extends the world model's role beyond evaluation to leading candidate construction through latent intentions. We evaluate InJepa through closed loop image goal navigation in Habitat MP3D. The results show effective multistep navigation through intention guided action generation and consequence feedback. Experiments across encoders further support applicability across visual representations. These findings support latent intentions as the central planning object and show that world models can directly guide plan construction through coordinated reasoning about intentions and consequences. Code is available at https://github.com/zhuxun132/InJepa.
