---
id: "1-07"
org: 专题·JEPA系列
short: "AdaJEPA"
title: "AdaJEPA: An Adaptive Latent World Model"
aliases: ["AdaJEPA", "An Adaptive Latent World Model"]
date: 2026-06-30
category: "JEPA 世界模型与规划"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "New York University；AMI Labs"
partners: []
authors: ["Ying Wang", "Oumayma Bounou", "Yann LeCun", "Mengye Ren"]
arxiv: "2606.32026"
pdf: "[[topics/papers/JEPA系列/1-07_2606.32026_AdaJEPA.pdf]]"
code: ""
project: "https://agenticlearning.ai/adajepa"
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "test-time-adaptation", "mpc", "latent-planning", "distribution-shift"]
---

# AdaJEPA: An Adaptive Latent World Model

> [!info] 论文信息
> arXiv [2606.32026](https://arxiv.org/abs/2606.32026) · v1 2026-06-30 · 19 页（正文 11 页 + 附录）
> [项目页](https://agenticlearning.ai/adajepa)
> PDF：[[topics/papers/JEPA系列/1-07_2606.32026_AdaJEPA.pdf|本地 PDF]]
> 作者：Ying Wang（NYU、AMI Labs）、Oumayma Bounou（NYU）、Yann LeCun\*（NYU、AMI Labs）、Mengye Ren\*（NYU）。\* 共同指导
> 论文没给代码链接。
> 专题：[[topics/JEPA系列#一、JEPA 世界模型与规划|JEPA系列 · 一]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录 A–C）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 动机：世界模型部署后冻结："Yet, the world model used for planning is typically frozen after training."（§1，p.1）
> - 方法核心："AdaJEPA uses the transition observed after each executed action as a self-supervised signal to adapt the world model before the next replan"（§1，p.2）
> - 首个在规划中适配 JEPA 世界模型的工作："To the best of our knowledge, we are the first to adapt a JEPA world model during planning."（§2，p.3）
> - 每个回合独立："Note that each episode starts from the same pretrained model and maintains its own copy and buffer throughout the episode."（§3.2，p.4）
> - 去掉 stop-gradient 也行："Removing stop-gradient while updating only the last layers of the encoder and predictor for one step gives similar planning performance"（§3.2，p.4）
> - 默认设置："Each update consists of a single gradient step using the same learning rates as training"（§4.1，p.6）
> - 分布内无害："test-time adaptation is safe to apply in-distribution: it yields large gains when the frozen model is suboptimal and does no harm when it is already near-optimal."（§4.2，p.6）
> - 颜色偏移收益小："gains are modest under the red-anchor and red-block shifts, likely because the model relies on color to distinguish the fixed anchor from the manipulated object"（§4.2，p.6）
> - 只改预测器不够："For visual and layout shifts, updating only the predictor is less effective, as the mismatch enters through the observation representation"（§4.3，p.8）
> - 局限：受预训练表征覆盖范围限制："when the test environment requires features absent from training, adaptation can improve planning but may not fully close the gap."（§4.4，p.10）

## 一句话总结

JEPA 世界模型 + MPC 规划时，模型通常训练完就冻结，测试分布一偏（形状、画面、物理、迷宫布局变了）预测就错、规划就失败。AdaJEPA 把**测试时适配**塞进 MPC 闭环：每执行一个动作块，就把刚观察到的转移 (o_t, a_t, o_{t+1}) 放进一个小缓冲区（默认最近 5 条），用和预训练一样的潜空间预测损失对编码器最后一级 + 预测器最后一块做**一步梯度更新**，再用更新后的模型重新规划。不需要奖励、专家示范或额外采集阶段，每次重规划只多 0.01–0.03 s；在 PushObj 未见形状上成功率接近翻倍，低数据时 1k 条轨迹 + 适配（60.8%）胜过 16 倍数据的冻结模型（43.5%）。

## 要解决什么问题

- JEPA 世界模型（DINO-WM、PLDM、Temporal Straightening、LeWM 等）都是离线训练、测试时冻结。预测不准时 MPC 优化的是错的目标：潜空间里看起来有效的动作在真实动力学下失败，单步误差还会沿规划时域累积。
- **测试时分布偏移**会放大这个问题：噪声、光照、背景让编码器失准；摩擦、质量、接触动力学变化让预测器失准。
- 已有的"适配世界模型"工作（AdaWorld、AdaWM、latent-state dynamics residuals、self-improving loops 等）一般需要目标域微调数据、额外在线 rollout 或外层自我改进循环；在线 MBRL 的模型更新又和策略/价值学习耦合。作者说自己是**第一个在规划过程中适配 JEPA 世界模型**的。
- 和 Parthasarathy et al. 2025（训练时合成数据缩小 train–test gap）动机最近，但那个模型规划时仍固定、只评估分布内。

## 方法

### 背景（§3.1）

编码器 z_t = E^s_φ(o_t)，动作编码器 u_t = E^a_ψ(a_t)，预测器 ẑ_{t+1} = f_θ(z_t, u_t)（可带短历史）。离线用 JEPA 预测损失（式 2，K 步平均）训练，防坍塌用 stop-gradient 或正则。规划：最小化 Σ_k α_k d(ẑ_{t+k}, z_g)，d 是平方 L2（式 3），优化器用 GD 或 CEM。

### 闭环 Plan–Execute–Adapt–Replan（§3.2，算法 1）

每个 MPC 步：
1. 用当前模型规划；
2. 执行第一个动作（块）a_t，观察 o_{t+1}；
3. 把 (o_t, a_t, o_{t+1}) 加入缓冲区 ℬ，超过 N 条就裁剪；
4. 做 U 次梯度更新 Ω ← Ω − η∇_Ω L_ada(ℬ)；
5. 用更新后的模型重规划。

每个回合都从同一个预训练模型出发，各自维护模型副本和缓冲区（回合之间不累积）。

| 组件 | 做法 |
|---|---|
| 适配损失（式 4） | L_ada(ℬ) = 1/|ℬ| Σ ℓ(f_θ(z_i, E^a_ψ(a_i)), sg(z_{i+1}))，与预训练相同的潜预测信号；长历史、动作块、frameskip 时对所有有效窗口平均 |
| 防坍塌 | 默认对目标用 stop-gradient；作者说只更新最后几层、一步时去掉 SG 规划效果相近（没给表） |
| 缓冲区 | recent-N（只留最近 N 条，默认 N=5）或 hard-N（留预测误差最大的 N 条） |
| 适配参数 Ω | 默认 predlast + enclast：预测器最后一个 transformer 块（含最终 LayerNorm）+ 编码器最后一级（Linear–GELU–Linear–LayerNorm 投影头） |
| 步数 / 学习率 | 默认每个 MPC 步 1 次梯度，学习率等于训练时（η_pred = 5e-4，η_enc = 1e-5） |

### 基座模型与设置（§4.1，附录 B.1）

- 每个环境从零训练 JEPA 世界模型，按 Temporal Straightening（Wang et al. 2026）的配方：ResNet 编码器出全局特征 + transformer 预测器，stop-gradient + 曲率正则；动作嵌入与视觉、本体嵌入拼接；frameskip 5，历史 3 帧。
- 规划超参（表 4）：子规划时域 25，每次执行 5 个动作；GD 用 Adam、零初始化、lr 0.1、100 步；CEM 200 样本、10 步。
- 每个 MPC 步执行一个动作块，最大 MPC 步数 20；结果为 3 个测试数据种子 × 每种子 50 回合的均值。

### 四种分布偏移

| 偏移 | 环境 | 训练 → 测试 |
|---|---|---|
| 形状 | PushObj（PushT 换物体形状） | 训 {T, L, Z, +} 各 4k 条轨迹 → 测 7 种，其中 {I, smallT, square} 未见；数据偏向接触，测试轨迹至少一次接触；目标 25 步外 |
| 视觉 | PushT | 训原始 PushT（T 形 16k 条）→ 测模糊、椒盐噪声、暗光，以及移动 T / 锚点 T / 智能体改成红色；目标 25 步外 |
| 动力学 | PointMaze-Medium | 默认物理 → 低质量（×0.2）、高阻尼（×20）；起终点网格距离 >3 |
| 布局 | Diverse PointMaze（8×8 随机迷宫） | 训 25 个布局（各 2,000 条，共 50k）→ 测 5 个留出布局；最短路 3–5 格 |

## 实验与关键数字

### 1. 形状与视觉偏移（图 2）

只有曲线图，没有数值表。作者文字描述：
- 分布内（PushObj 训练形状、默认 PushT）：GD、CEM 两种规划器适配后都明显提升；PushObj 训练形状上增益最大，**超过 20%**（模型在多形状上训练，适配让它针对当前形状专门化）。
- 未见形状：冻结模型掉得很厉害，AdaJEPA **成功率接近翻倍**。
- 视觉偏移：模糊、噪声、暗光收益明显；**红锚点、红方块两种收益有限**（作者推测模型靠颜色区分固定锚点和被推物体）。
- 适配后成功率随重规划步数持续上升，冻结模型往往早早饱和。图 2 为展示这一趋势把最大步数延长到 30。

### 2. 动力学与布局偏移（表 1，PointMaze，成功率 %）

| 设置 | 默认 GD | 默认 CEM | 低质量 GD | 低质量 CEM | 高阻尼 GD | 高阻尼 CEM | 未见布局 GD | 未见布局 CEM |
|---|---|---|---|---|---|---|---|---|
| Frozen | 82.7±6.8 | 84.0±3.3 | 77.3±8.2 | 82.0±2.8 | 77.3±5.0 | 76.0±2.8 | 53.3±8.2 | 49.3±6.2 |
| predlast + enclast | 83.3±6.6 | 83.3±3.4 | 80.0±3.3 | 86.7±2.5 | 77.3±10.5 | 78.7±3.4 | 66.0±7.1 | 55.3±5.0 |
| predfirst + enclast | 84.0±1.6 | 84.0±4.3 | 82.0±1.6 | 82.7±3.4 | 78.7±4.7 | 82.0±3.3 | **78.7±5.0** | **70.7±3.8** |

- 默认动力学下适配基本持平（CEM 默认设置还 ↓0.7），作者据此说"分布内无害"。
- 动力学偏移下冻结模型本来就不差（作者猜是 3 帧历史带来的上下文学习），适配仍有小幅增益。
- 未见布局增益最大：适配预测器**第一块**时 GD +25.3、CEM +21.3；作者解释第一块离潜变量和动作输入最近，更能重校新的迷宫连通性下的局部转移。适配后轨迹更接近最短路（图 4、5）。

### 3. 不同基座世界模型 + 延迟（表 2，PushT 验证轨迹，一张 H200）

| 基座 | 潜维度 | 设置 | GD (%) | 每次重规划 (s) | CEM (%) | 每次重规划 (s) |
|---|---|---|---|---|---|---|
| Temporal Straightening（全局特征） | 1×384 | Frozen | 84.0±2.0 | 3.14 | 74.0±3.5 | 0.24 |
| | | Adapt | 85.3±3.1 | 3.17 | 81.3±6.4 | 0.27 |
| Temporal Straightening（空间特征） | 196×384 | Frozen | 91.3±4.2 | 3.37 | 89.3±3.1 | 5.37 |
| | | Adapt | 92.0±3.5 | 3.38 | 93.3±2.3 | 5.39 |
| DINO-WM（patch） | 196×384 | Frozen | 68.0±10.6 | 3.66 | 86.7±6.1 | 9.53 |
| | | Adapt | 70.0±4.0 | 3.68 | 90.0±3.5 | 9.56 |

- 分布内、模型已训好的情况下也有一致增益（GD +0.7~+2.0，CEM +3.3~+7.3），每次重规划只多 0.01–0.03 s。
- 作者还说适配后到达目标所需的重规划次数相同或更少，总时间可能反而减少。

### 4. 适配哪些参数（§4.3，图 8）

比较 predlast+enclast / predfirst+enclast / predfirstlast+enclast / predlast+encfirst / predlast+encfrozen / LoRA（rank 8，α=16，插到编码器和预测器所有线性层）。
- 所有变体都优于冻结模型；整体对选哪层**不太敏感**。
- 形状偏移：冻结编码器也差不多 → 需要的修正主要在预测器。
- 视觉、布局偏移：只改预测器效果差 → 失配是从观测表征进来的。
- LoRA 有提升，但不稳定地优于"直接更新选定层"。
- 图 8 只给了柱状图上的数字，文本里没有逐项对应，这里不转录。

### 5. 学习率 / 步数 / 缓冲区（附录 B.2，图 9，PushObj 的 T 与 square）

- 文本：所有设置都显著优于冻结模型，T 上从 50% 提到 88%，square 上从 20% 提到 51%（应是网格中的最好值）。
- 学习率和步数强耦合：5× 训练学习率一步就很有效，但多步会过冲；0.2× 稳定但需要更多步（增加延迟）。1–2×、1–2 步对两种形状都稳。
- 缓冲区影响小：T 上 81%–87%，square 上 35%–44%；**连不用缓冲区也远好于冻结**；recent-5 最稳，被选为默认。

### 6. 训练数据规模（§4.4，附录 B.3，图 6、图 10，PushObj 成功率 %）

K = 训练形状数，N = 每形状轨迹数；每个 K 构造 7 个平衡训练集，优化步数固定。

| K | 设置 | 已见形状 N=1k | N=16k | 未见形状 N=1k | N=16k |
|---|---|---|---|---|---|
| 1 | frozen | 28.1 | 43.5 | 19.5 | 29.1 |
| 1 | adapt | **60.8** | 77.0 | 34.3 | 45.8 |
| 2 | frozen | 41.1 | 47.2 | 30.0 | 31.4 |
| 2 | adapt | 72.1 | 80.9 | 44.2 | 49.7 |
| 4 | frozen | 43.4 | 54.0 | 32.4 | 38.4 |
| 4 | adapt | 75.9 | 81.4 | 49.7 | 53.4 |

- 同样 16k 总轨迹：K=4、N=4k 优于 K=1、N=16k（未见形状适配后 51.9% vs 45.8%，冻结 36.3% vs 29.1%）→ **形状多样性比每形状轨迹数更重要**。
- K=1、N=1k 时适配把已见形状从 28.1% 提到 60.8%，超过每形状 16 倍数据的冻结模型（43.5%），也超过最大的冻结模型（K=4、N=16k，共 64k 条，54.0%）。
- 平均增益：已见形状 >30 个百分点，未见形状 >15 个百分点。

### 7. 可视化（图 7，附录 C）

在预训练潜空间上训练解码器，轻量适配后仍能解码。未见的红色方块常被解码成灰色（训练颜色），未见形状被解码成相近的已见形状 → 作者认为 AdaJEPA 是在已学潜流形附近重新校准预测，而非学出新表征。附录 C 的逐步潜预测损失图显示适配后损失持续下降。

## 局限 / 存疑

> 论文没有单独的"局限"一节；第一条来自 §4.4，其余是 Claude 的推断，请核对。

- **受预训练表征覆盖范围限制**（§4.4）：测试环境需要训练中没有的特征时，适配能改善但不能完全补上差距；作者建议以后结合持续学习、主动学习。
- **最大 MPC 步数说法不一致，需核对**：§4.1 说最大 MPC 步数为 20；图 2 说明"延长到 30"；附录 B.2 又说消融用 20 步"（instead of 30 in the main experiments）"。主实验到底是 20 还是 30（或只有图 2 是 30）不清楚。
- **适配只在单个回合内**：每回合从同一预训练模型重新开始，回合间不保留，所以不是持续学习；同一环境里反复部署也不会越来越好。
- **形状、视觉偏移的主结果只有曲线图**（图 2），没有数值表，"接近翻倍""超过 20%"无法逐项核对。
- **"去掉 stop-gradient 效果相近"没有给表**，只是正文一句话。
- 动力学偏移下冻结模型本身就接近默认水平，增益（+0~+4.7）在标准差范围内，说服力有限。
- **全是 2D 仿真**（PushT/PushObj、PointMaze），基座模型小、从零训练；没有真机、没有 V-JEPA 2 这类大预训练骨干上的实验。
- 测试时用到的是真实转移 o_{t+1}，若环境本身随机或观测有遮挡，单条转移的一步更新是否会把模型带偏，没讨论；红色锚点等"颜色语义"偏移收益小，说明这种自监督信号修不了表征里的捷径。

## 与其他论文的关系

- **基座模型**：主实验基座来自 [[topics/notes/JEPA系列/1-04_TemporalStraightening|Temporal Straightening]]（同一作者组，stop-gradient + 曲率正则），表 2 还测了 [[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]]；规划沿用 DINO-WM 的 GD/CEM-MPC 设置，PushObj 形状设置也来自 DINO-WM。
- **其他 JEPA 世界模型**：相关工作列了 [[topics/notes/JEPA系列/1-03_PLDM|PLDM]]（Sobal et al.）、[[topics/notes/JEPA系列/1-05_LeWM|LeWM]]、[[topics/notes/JEPA系列/2-03_V-JEPA2|V-JEPA 2]]、HWM-PLDM（Diverse PointMaze 的数据生成按它）；作者的论点是这些模型测试时都冻结。
- **同组后续**：[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 也是 Ying Wang / Mengye Ren / LeCun，讨论训练目标对潜空间几何的影响；AdaJEPA 从另一个角度（部署时修正）改善规划。
- **防坍塌**：适配损失默认用 stop-gradient，正文提到可以换成 VICReg / SIGReg（[[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]]）一类正则。
- **TTT/TTA 谱系**：Sun et al. 2020（辅助任务 TTT）、Tent（熵最小化）、MEMO、MAE-TTT、视频流 TTT；本文的自监督信号是"执行后的下一帧"，天然由 MPC 闭环提供。
- 库里其他 JEPA 笔记：[[xsquare/notes/23_EgoJEPA|EgoJEPA]]。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Latent world models enable planning from high-dimensional observations by predicting future states in a compact latent space. However, these models are typically kept frozen at test time: when their predictions become inaccurate, planning can fail, especially under test-time distribution shift. To address this, we propose AdaJEPA, an adaptive latent world model that performs test-time adaptation within the closed loop of model predictive control (MPC). After training, AdaJEPA plans and executes the first action chunk, uses the observed next-state transition as a self-supervised adaptation signal, and replans with the updated model. This closed-loop update continuously recalibrates the world model without additional expert demonstrations. Across a range of goal-reaching tasks, AdaJEPA substantially improves planning success with as few as one gradient step per MPC replanning step.
