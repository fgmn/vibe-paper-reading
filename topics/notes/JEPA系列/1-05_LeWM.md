---
id: "1-05"
org: 专题·JEPA系列
short: "LeWM"
title: "LeWorldModel: Stable End-to-End Joint-Embedding Predictive Architecture from Pixels"
aliases: ["LeWM", "LeWorldModel"]
date: 2026-03-13
category: "JEPA 世界模型与规划"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "Mila & Université de Montréal；NYU；Samsung SAIL；Brown University"
partners: []
authors: ["Lucas Maes", "Quentin Le Lidec", "Damien Scieur", "Yann LeCun", "Randall Balestriero"]
arxiv: "2603.19312"
pdf: "[[topics/papers/JEPA系列/1-05_2603.19312_LeWM.pdf]]"
code: ""
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "latent-planning", "sigreg", "anti-collapse", "end-to-end", "cem-mpc"]
---

# LeWorldModel: Stable End-to-End Joint-Embedding Predictive Architecture from Pixels

> [!info] 论文信息
> arXiv [2603.19312](https://arxiv.org/abs/2603.19312) · v3 2026-06-03（v1 2026-03-13）· 28 页（正文 9 页 + 附录）· PDF 标注 "Preprint"
> PDF 首页有 "Website" 和 "Code" 两个超链接，但正文没有写出 URL，所以 `code` / `project` 留空。
> PDF：[[topics/papers/JEPA系列/1-05_2603.19312_LeWM.pdf|本地 PDF]]
> 作者：Lucas Maes\*（Mila & Université de Montréal）、Quentin Le Lidec\*（NYU）、Damien Scieur（Mila、Samsung SAIL）、Yann LeCun（NYU）、Randall Balestriero（Brown）。\* 共同一作
> 专题：[[topics/JEPA系列#一、JEPA 世界模型与规划|JEPA系列 · 一]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录 A–I 的 SIGReg 定义、基线设置、探针表、消融表）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 现有方法的脆弱性："existing methods remain fragile, relying on complex multi-term losses, exponential moving averages, pre-trained encoders, or auxiliary supervision to avoid representation collapse."（Abstract，p.1）
> - 核心主张："we introduce LeWorldModel (LeWM), the first JEPA that trains stably end-to-end from raw pixels using only two loss terms"（Abstract，p.1）
> - 超参数从 6 个降到 1 个："This reduces tunable loss hyperparameters from six to one compared to the only existing end-to-end alternative."（Abstract，p.1）
> - 规模与速度："With 15M parameters trainable on a single GPU in a few hours, LeWM plans up to 48× faster than foundation-model-based world models"（Abstract，p.1）
> - 为什么要 BN 投影："This step is necessary because the final ViT layer applies a Layer Normalization [36], which prevents our anti-collapse objective from being optimized effectively."（§3.1，p.4）
> - 不用任何启发式："We do not employ stop-gradient, exponential moving averages, or additional stabilization heuristics."（§3.1，p.5）
> - Two-Room 上反而差："LeWM performs worse on the simplest environment, Two-Room."（§4.2，p.7）
> - 对 Two-Room 的解释："the low diversity and low intrinsic dimensionality of this dataset make it difficult for the encoder to match the isotropic Gaussian prior enforced by SIGReg in a high-dimensional latent space"（§4.2，p.7）
> - 涌现的时间拉直："LeWM achieves higher temporal straightness than PLDM, despite PLDM employing a dedicated temporal smoothness regularization term."（§5.1，p.9）
> - 局限："Planning remains restricted to short horizons, motivating hierarchical world modeling for long-horizon reasoning."（§6，p.9）

## 一句话总结

**LeWM** 是一个从像素端到端训练的 JEPA 世界模型：ViT-Tiny 编码器取 [CLS] 经 BatchNorm 投影得到 192 维潜变量，Transformer 预测器用 AdaLN 注入动作、自回归预测下一帧潜变量；损失只有两项——**下一帧嵌入的 MSE + SIGReg**（沿随机方向用 Epps–Pulley 检验把潜分布推向各向同性高斯），不用 stop-gradient、EMA、预训练编码器或辅助监督，实际只需调一个超参 λ。15M 参数、单卡几小时训完；规划用 CEM，因为每帧只有 1 个 token（DINO-WM 约 200 个），**一次完整规划 0.98 s vs DINO-WM 47 s（约 48 倍）**。PushT 上 96% 好于 PLDM 的 78% 和 DINO-WM 的 92%；但 OGBench-Cube 略逊于 DINO-WM，最简单的 Two-Room 上反而不如 PLDM 和 DINO-WM。

## 要解决什么问题

- JEPA 世界模型的核心难题是**表征坍塌**：编码器把所有输入映射成常数就能让预测损失为零。
- 现有补救都有代价（图 2）：
  - **冻结预训练编码器**（DINO-WM）：不会坍塌，但不能端到端学习，表达能力受限于预训练知识；
  - **端到端 + 多项正则**（PLDM）：VICReg 派生的多项损失（作者数为 7 项、6 个可调权重），训练不稳定、调参是 O(n⁶) 的网格搜索、没有防坍塌保证；
  - **EMA + stop-gradient**（I-JEPA、V-JEPA 一系）：不对应一个良定义的目标函数，理论理解有限；
  - **任务相关方法**（Dreamer、TD-MPC）：需要奖励或特权状态，或依赖像素重建。
- 目标：一个端到端、与任务无关、基于像素、无重建、无奖励、只有一个超参并且防坍塌"可证明"的方法。

## 方法

### 架构（§3.1，附录 D）

| 组件 | 做法 |
|---|---|
| 编码器 | ViT-Tiny（patch 14、12 层、3 头、隐维 192，约 5M 参数），输入 224×224；取最后一层 [CLS]，再过**一层带 BatchNorm 的 MLP 投影**。必须加这一步：ViT 最后的 LayerNorm 会让 SIGReg 无法有效优化 |
| 预测器 | Transformer（正文写 6 层、16 头、10% dropout，约 10M；附录写 ViT-S 骨干 + 可学习位置编码），时间因果掩码，历史 3 帧（Two-Room 为 1 帧）；动作通过每层的 **AdaLN** 注入，AdaLN 参数零初始化让动作条件逐步起作用；输出后同样接 BN 投影 |
| 训练数据组织 | frameskip 5（5 个连续动作合成一个动作块），batch 128，子轨迹长 4 帧 |

### 损失（§3.1，附录 A）

L_LeWM = L_pred + λ·SIGReg(Z)

- L_pred = ‖ẑ_{t+1} − z_{t+1}‖²（teacher forcing），**梯度穿过两侧**，没有 SG。
- SIGReg：把所有时间步、批内的潜变量 Z 投影到 M 个随机单位方向 h^(m) = Z u^(m)，对每个一维投影算 Epps–Pulley 统计量（经验特征函数与标准正态特征函数之差的加权积分，用梯形积分在 [0.2, 4] 上取节点），再平均。由 Cramér–Wold 定理，所有一维边缘匹配 ⇔ 联合分布匹配 N(0, I)。
- 默认 M = 1024、λ = 0.1。M 和积分节点数基本不影响结果，所以实际只调 λ，可用二分搜索（O(log n)）。

### 规划（§3.2，附录 D）

- 代价只看终态：C = ‖ẑ_H − z_g‖²。
- CEM：每次 300 条候选、保留 top-30，PushT 最多 30 轮、其他环境 10 轮；规划时域 5（=25 环境步）；MPC 执行整段 5 步动作后再重规划（沿用 DINO-WM 设置）。

## 实验与关键数字

环境（图 5，附录 E）：Two-Room（PLDM 的环境；10,000 条、平均 92 步，噪声启发式策略）、Reacher（DMC，要求关节姿态对齐；10,000 条 × 200 步，SAC 策略采）、PushT（沿用 DINO-WM 的 20,000 条专家数据，只训 10 个 epoch）、OGBench-Cube（单方块 3D 抓放；10,000 条 × 200 步）。评估：从数据集轨迹里取起点，目标是同一轨迹 25 步后的状态，动作预算 50 步，50 条轨迹。

基线：DINO-WM（默认**去掉本体感受**以示公平，另报 DINO-WM+prop）、PLDM（作者在 PushT 上对 6 个损失系数做 256 组网格搜索后固定）、GCBC、GCIQL、GCIVL（后三者用 DINOv2 patch 嵌入）。每个方法所有环境用同一组超参。

### 1. 规划成功率（图 6 + 附录表 5/10）

| 来源 | 设置 | LeWM | DINO-WM | PLDM |
|---|---|---|---|---|
| 表 5（3 个训练种子） | PushT | **96.0±2.83** | 92.0±1.63 | 78.0±5.0 |
| 表 10（CEM） | PushT | 96.0±2.83 | – | 78.0±5.0 |

- 正文：PushT 上比 PLDM 高 18 个点；**只用像素的 LeWM 也超过带本体感受的 DINO-WM**；Reacher 上 LeWM 也领先 PLDM 和 DINO-WM。
- OGBench-Cube：DINO-WM 略好于 LeWM，作者归因于 3D、视觉更复杂、编码器从零学更难。
- Two-Room：PLDM 和 DINO-WM 好于 LeWM。作者解释：数据多样性低、本征维度低，难以在高维潜空间匹配各向同性高斯先验——**SIGReg 在极简单环境里的局限**。
- 图 6 每个环境各柱的具体数值在 PDF 抽取文本里与方法名对不上（柱状图标签顺序混乱），这里没有逐格抄录，需对照原图核对。表 5 的 DINO-WM 92.0 是否带本体感受也没写明，需核对。

### 2. 规划速度（图 3）

| | 完整规划耗时 |
|---|---|
| DINO-WM | 47 s |
| LeWM | 0.98 s |

- 原因：LeWM 每帧编码成 1 个向量，token 数比 DINO-WM 少约 200 倍；速度与 PLDM 相当。
- 固定 FLOPs 预算下，LeWM 在 PushT 和 OGBench-Cube 上都明显好于 DINO-WM（图 3 中、右，只有柱状图）。
- 摘要说"up to 48×"，图 3 说明文字说"up to ∼50×"，是同一个量级的两种说法。

### 3. 物理量探针（表 1，PushT；线性 / MLP 探针，MSE↓ 和 Pearson r↑）

| 量 | 模型 | 线性 MSE | 线性 r | MLP MSE | MLP r |
|---|---|---|---|---|---|
| 智能体位置 | DINO-WM | 1.888 | 0.977 | 0.003 | 0.999 |
| | PLDM | 0.090 | 0.955 | 0.014 | 0.993 |
| | LeWM | 0.052 | 0.974 | 0.004 | 0.998 |
| 方块位置 | DINO-WM | 0.006 | 0.997 | 0.002 | 0.999 |
| | PLDM | 0.122 | 0.938 | 0.011 | 0.994 |
| | LeWM | 0.029 | 0.986 | 0.001 | 0.999 |
| 方块角度 | DINO-WM | 0.050 | 0.979 | 0.009 | 0.995 |
| | PLDM | 0.446 | 0.745 | 0.056 | 0.972 |
| | LeWM | 0.187 | 0.902 | 0.021 | 0.990 |

- LeWM 一致好于 PLDM，和 DINO-WM 互有胜负（DINOv2 预训练数据约 1.24 亿张图，多两个数量级）。
- Two-Room（表 3）：LeWM 和 PLDM 的位置探针几乎一样（线性 MSE 都是 0.008，r=0.996），都远好于 DINO-WM 的线性探针（0.488）——作者据此认为 Two-Room 的规划差距**不是表征信息不够**，而是动力学模型或规划过程的问题。
- OGBench-Cube（表 4）：位置类量（方块位置线性 MSE 0.007、末端位置 0.018）LeWM 最好；关节速度、末端偏航角 DINO-WM 明显更好；**三种方法都读不出方块朝向**（四元数、偏航角 r ≤ 0.31）。综合线性 r：DINO-WM 0.725、PLDM 0.464、LeWM 0.477。

### 4. 违背预期（VoE）测试（§5.2，图 8）

- 两种扰动：颜色突变（视觉）、物体瞬移到随机位置（物理）。以预测误差为"惊讶度"。
- 瞬移在三个环境都引起显著尖峰（配对 t 检验 p<0.01）；颜色变化的惊讶度较弱且不显著——对物理扰动比视觉扰动更敏感。
- 附录 F.3 / 图 12、14 给了 PLDM 和 DINO-WM 的同样测试：它们在 OGBench-Cube 上惊讶度增幅较弱，其中一个模型在 Cube 上两种扰动都不显著（抽取文本里图注被截断，具体是哪一个需对照原图核对）。

### 5. 涌现的时间拉直（§5.1，附录 H，图 17）

- 训练过程中 PushT 上相邻潜速度的平均余弦相似度持续上升，没有任何显式正则；而且**比带时间平滑项的 PLDM 更直**。
- 作者假设：SIGReg 对每个时间步单独施加、不约束时间维，编码器于是趋向一种"时间坍塌"，相邻嵌入沿越来越线性的路径演化，这个偏置反而有利于规划。

### 6. 消融（附录 G，全部在 PushT 上，成功率 %）

| 消融 | 结果 |
|---|---|
| 预测器大小（表 6） | tiny 80.67±6.54 / **small 96.0±2.83** / base 86.7±3.06 |
| 加重建损失（表 7） | 不加 96.0±2.83 / 加解码器损失 86.0±7.54 |
| 编码器（表 8） | ViT 96.0±2.83 / ResNet-18 94.0±3.27 |
| 预测器 dropout（表 9） | 0.0: 78±6.54 / **0.1: 96.0±2.83** / 0.2: 85.33±5.74 / 0.5: 66.67±4.11 |
| 规划器（表 10，LeWM / PLDM） | CEM 96.0 / 78.0；SGD 26 / 4.67；RMSProp 67.33 / 49.33；Adam 84 / 80 |
| λ（图 16） | λ∈[0.01, 0.2] 都 >80%，峰值约 0.09；λ=0.5 时急剧下降 |
| 嵌入维度（图 15） | 低于约 184 时下降，再大就饱和 |
| 投影数 M、积分节点数（图 15） | 基本无影响 |

- 预测器 dropout 影响很大（0 → 0.1 提升 18 个点），实际上是另一个需要选的超参。

## 局限 / 存疑

> 论文 §6 自述：规划只限短时域（需要分层世界模型）；依赖覆盖充分的离线数据，数据多样性低时 SIGReg 在简单低维环境里变弱；依赖动作标签（可考虑逆动力学）。下面其余条目是 Claude 的推断，请核对。

- **"只有一个超参"要打折扣**：损失层面确实只剩 λ，但预测器 dropout（0 vs 0.1 差 18 点）、预测器大小、嵌入维度、BN 投影头都显著影响结果。
- **潜空间很小（192 维单向量）**，在 OGBench-Cube 上丢掉了末端偏航角、方块朝向等细节（图 7 解码可见、表 4 探针也低）。[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 提到 Karmann et al. 2026 报告 LeWM 在 Pong 里把球"压掉"，是同一类"无 SG 丢内容"现象。
- **"可证明防坍塌"**指的是 SIGReg → 0 ⇔ 分布趋于 N(0, I) 的渐近结论；这保证不完全坍塌，但不保证任务相关因子被保留（Two-Room 的规划差距、Cube 的朝向信息都说明这一点）。
- **评测偏简单**：目标都在 25 步内、来自同一条数据轨迹；没有长时域、换布局或真机实验。
- **基线公平性**：PLDM 只在 PushT 上调参后固定用于所有环境，而 PLDM 原文是逐数据集调的；作者用了 PLDM 开源代码里的 time-var / time-cov 项，并指出这两项原论文没写。DINO-WM 默认去掉了本体感受。
- 图 6 主结果只给柱状图，抽取文本无法可靠对应数值，需核对。

## 与其他论文的关系

- **端到端 vs 冻结编码器**：相对 [[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]]（冻结 DINOv2 patch 特征、CEM 一次 47 s），LeWM 端到端学一个 token 的紧凑潜变量，规划快约 48 倍；规划协议（frameskip 5、时域 5、CEM、终态 MSE）直接沿用 DINO-WM。
- **防坍塌方式的替换**：相对 [[topics/notes/JEPA系列/1-03_PLDM|PLDM]]（VICReg 多项 + 时间平滑 + IDM），LeWM 用 SIGReg 一项替代；SIGReg 来自 [[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]]（Balestriero & LeCun）。
- **潜几何**：LeWM 的"涌现拉直"呼应 [[topics/notes/JEPA系列/1-04_TemporalStraightening|Temporal Straightening]]（引用为 Wang et al.）的显式曲率正则；[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 的 SIGReg-BN 基线就是复刻 LeWM（编码器后接 BN MLP 投影 + SIGReg），并指出分布正则是为 i.i.d. 多视图设计的、对时间相关轨迹未必合适。
- **后续 / 分析**：[[topics/notes/JEPA系列/3-02_WhenLeJEPAWorldModel|When LeJEPA World Model]]、[[topics/notes/JEPA系列/3-03_BeyondGaussianWorlds|Beyond Gaussian Worlds]] 从标题看是在讨论 SIGReg / 高斯先验在世界模型里何时成立，可与本文 Two-Room 上的失败对照阅读。
- **违背预期评测**：思路与 [[topics/notes/JEPA系列/2-02_V-JEPA|V-JEPA]] 系列的直觉物理 surprise 评测一致。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Joint Embedding Predictive Architectures (JEPAs) offer a compelling framework for learning world models in compact latent spaces, yet existing methods remain fragile, relying on complex multi-term losses, exponential moving averages, pre-trained encoders, or auxiliary supervision to avoid representation collapse. In this work, we introduce LeWorldModel (LeWM), the first JEPA that trains stably end-to-end from raw pixels using only two loss terms: a next-embedding prediction loss and a regularizer enforcing Gaussian-distributed latent embeddings. This reduces tunable loss hyperparameters from six to one compared to the only existing end-to-end alternative. With 15M parameters trainable on a single GPU in a few hours, LeWM plans up to 48× faster than foundation-model-based world models while remaining competitive across diverse 2D and 3D control tasks. Beyond control, we show that LeWM's latent space encodes meaningful physical structure through probing of physical quantities. Surprise evaluation confirms that the model reliably detects physically implausible events. Code available here.
