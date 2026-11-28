---
id: "1-06"
org: 专题·JEPA系列
short: "What Drives Success（JEPA-WMs）"
title: "What Drives Success in Physical Planning with Joint-Embedding Predictive World Models?"
aliases: ["What Drives Success", "JEPA-WMs", "jepa-wms"]
date: 2025-12-30
category: "JEPA 世界模型与规划"
venue: "TMLR 2026"
source: "arXiv"
affiliation: "Meta FAIR；Inria Paris；ENS / PSL；NYU"
partners: []
authors: ["Basile Terver", "Tsung-Yen Yang", "Jean Ponce", "Adrien Bardes", "Yann LeCun"]
arxiv: "2512.24497"
pdf: "[[topics/papers/JEPA系列/1-06_2512.24497_WhatDrivesSuccess.pdf]]"
code: "https://github.com/facebookresearch/jepa-wms"
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "latent-planning", "empirical-study", "robot-manipulation", "cem-mpc", "design-choices"]
---

# What Drives Success in Physical Planning with Joint-Embedding Predictive World Models?

> [!info] 论文信息
> arXiv [2512.24497](https://arxiv.org/abs/2512.24497) · v4 2026-09-02（v1 2025-12-30）· Transactions on Machine Learning Research（05/2026，[OpenReview](https://openreview.net/forum?id=cHZn5Gdh8e)）· 55 页（正文 12 页 + 大量附录）
> [代码 / 数据 / 权重](https://github.com/facebookresearch/jepa-wms)
> PDF：[[topics/papers/JEPA系列/1-06_2512.24497_WhatDrivesSuccess.pdf|本地 PDF]]
> 作者：Basile Terver（Meta FAIR、Inria Paris）、Tsung-Yen Yang（Meta FAIR）、Jean Ponce（ENS/PSL、NYU）、Adrien Bardes（Meta FAIR）、Yann LeCun（NYU；PDF 写作 "Yann Le Cun"）
> 专题：[[topics/JEPA系列#一、JEPA 世界模型与规划|JEPA系列 · 一]]

> [!note] 下面各节是 Claude 根据 PDF 正文和附录中的关键表（表 2、6、11，V-JEPA-2-AC 复现说明）写的初稿（2026-11-28）。附录 55 页没有逐页读完。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 研究对象："we characterize models from this family as JEPA-WMs and investigate the technical choices that make algorithms from this class work."（Abstract，p.1）
> - JEPA-WM 的界定："The term JEPA-WM designates a specific recipe in which the dynamics model is trained solely through a predictive loss in embedding space, with no reconstruction, reward prediction, or value/policy heads"（§1，p.2）
> - 研究问题："how to efficiently learn a dynamics model in the embedding space of a pretrained visual encoder for manipulation and navigation planning tasks ?"（§1，p.2）
> - 每次只改一个因素："Each component is independently varied from the base configuration to isolate its effect."（§4，p.5）
> - 规划器："We observe in Figure 3a that the CEM L2 planner performs best overall."（§5.2，p.8）
> - 梯度规划的适用范围："on 2D navigation tasks (Wall, Push-T, Maze) that require non-greedy planning, gradient-based methods perform very poorly compared to sampling-based ones, as GD gets stuck in local minima."（§5.2，p.8）
> - 多步展开损失像数据增强："The multi-step rollout loss thus acts as data augmentation against compounding error"（§5.2，p.9）
> - 本体感受："models trained with proprioceptive input are consistently better than without."（§5.2，p.9）
> - 编码器："we see a clear advantage of DINO encoders compared to V-JEPA encoders."（§5.2，p.10）
> - 规模："increasing encoder size (with predictor width) or predictor depth does not improve performance on simulated environments."（§5.2，p.11）

## 一句话总结

一篇**大规模对照实验**：在"冻结预训练视觉编码器 + 训练动作条件预测器 + 在潜空间里做 MPC 规划"这一类 JEPA 世界模型（作者统称 **JEPA-WM**，DINO-WM、V-JEPA-2-AC 都属此类）上，以 DINO-WM（ViT-S、无本体感受）为基础配置，一次只改一个因素，系统比较规划器（CEM / Nevergrad / Adam / GD，L1 / L2）、多步展开损失、本体感受、上下文长度、编码器（DINOv2 / DINOv3 / V-JEPA / V-JEPA 2）、预测器条件方式（特征拼接 / 序列 token / AdaLN）、模型和数据规模。环境覆盖 Metaworld、PushT、Wall、PointMaze 和真实数据 DROID（零样本迁移 Robocasa）。主要结论：CEM + L2 总体最好；2 步展开损失（真实数据 6 步）、本体感受、3 帧上下文（真实数据 5 帧）有用；DINO 系编码器明显好于 V-JEPA 系；仿真里加大模型没用，真实数据里加大有用。组合出的最优配方在多数任务上超过 DINO-WM 和 V-JEPA-2-AC（如 DROID 48.2 vs 39.4 / 42.9，Wall 78.8 vs 64.1）。

## 要解决什么问题

- JEPA-WM 这一类方法（PLDM、DINO-WM、V-JEPA-2-AC、DINO-World 等）都很新，各家在编码器、预测器结构、训练损失、规划器上各做各的选择，**没有人系统地拆开看哪个设计真正起作用**。
- 本文聚焦**动力学（预测器）的学习**而非表征学习：给定冻结的预训练视觉编码器，怎样最有效地学一个能用于导航和操作规划的预测器？
- 作者明确说 JEPA-WM 是统一的实现配方（式 1–4），不是新算法；JEPA-WM 也不限于冻结编码器（PLDM、EB-JEPA 是联合训练的），但本文只研究冻结编码器的情形。

## 方法

### 统一框架（§3，式 1–4）

- 训练：冻结视觉编码器 E^vis，可选浅层本体感受编码器 E^prop、动作编码器 A_θ，预测器 P_θ 用帧级因果掩码，对过去 w 帧状态和动作预测下一帧嵌入，损失为 MSE（视觉和本体感受两项各算）。训练最大上下文 W 默认 3；frameskip f 时把 f 个动作拼成一个 f×A 维动作。
- 规划：代价 L_p^α = (L_vis + α·L_prop)(G(o_t, a), E(o_g))，G 取预测器从真实初始嵌入自回归展开 H 步后的终态；规划时滑动上下文 W_p（默认 2）。
- **多步展开损失**（式 5）：除 teacher forcing 外，再加 k 步自回归展开后的损失 L_k，用截断 BPTT（只回传最后一步预测的误差）。

### 研究的设计选择（表 1）

| 组件 | 候选 | 仿真导航最佳 | 真实操作最佳 |
|---|---|---|---|
| 视觉编码器 | DINOv2（S/B/L）、DINOv3-L、V-JEPA-L、V-JEPA-2-L | DINOv2-S | DINOv3-L |
| 预测器结构 | 特征拼接 + sincos、序列 token + RoPE、特征拼接 + RoPE、AdaLN + RoPE、AdaLN-zero + RoPE | AdaLN + RoPE | AdaLN + RoPE |
| 预测器深度 | 3、6、9、12 | 6 | 12 |
| 展开步数 | 1（teacher forcing）、2、3、6 | 2 | 6 |
| 上下文 W | 1、2、3、5、7、9、14 | 3 | 5 |
| 本体感受 | 有 / 无 | 有 | 有（但 Robocasa 迁移时不能用） |
| 规划器 | CEM、NG（Nevergrad）、Adam、GD | CEM | CEM |
| 代价 | L1、L2 | L2 | L2 |

- 调研顺序：先定规划器（影响所有评测），再看训练和结构，最后看规模。
- **NG 规划器**是作者新接的 Nevergrad 接口，默认 NGOpt 元优化器（实际选到对角 CMA-ES），不调任何参数。
- 视频编码器（V-JEPA 系）的帧编码方式：每帧复制成 2 帧视频单独编码；各编码器每时间步 token 数对齐，差别主要在权重本身。

### 环境与评测（§5.1）

- Metaworld：用 TD-MPC2 在线智能体采数据，评测 Reach（MW-R）和 Reach-Wall（MW-RW）。
- PushT、Wall、PointMaze：用 DINO-WM 公开的离线数据，90% 作训练。
- DROID：真实 Franka 数据训练；在实验室拍的 16 段真实 Franka 视频上离线评测（规划出的动作与真实动作的 L1 误差，取反后重标为 Action Score）；并**零样本**迁移到 Robocasa 仿真的自定义 Place / Reach 任务（Rc-Pl、Rc-R），不做微调。
- 最终模型每个 3 个训练种子；每个 epoch 评测 e 个回合（多数 96，DROID 64，Robocasa 32），对最后 n 个 epoch 取平均。

## 实验与关键数字

### 1. 最终对比（表 2，成功率 % / DROID 为 Action Score；括号内为误差项，PDF 未在表注说明是标准差还是标准误）

| 模型 | Maze | Wall | Push-T | MW-R | MW-RW | Rc-R | Rc-Pl | DROID |
|---|---|---|---|---|---|---|---|---|
| DINO-WM | 81.6 (3.4) | 64.1 (4.6) | 66.0 (4.7) | 44.8 (8.9) | 35.1 (9.4) | 19.1 (13.4) | 21.7 (7.2) | 39.4 (2.1) |
| V-JEPA-2-AC | — | — | — | — | — | 16.2 (8.3) | **33.1 (7.2)** | 42.9 (2.5) |
| **本文最优** | **83.9 (2.3)** | **78.8 (3.9)** | **70.2 (2.8)** | **58.2 (9.3)** | **41.6 (10.0)** | **25.4 (16.6)** | 30.7 (8.0) | **48.2 (1.8)** |

- 最优配方：仿真用 DINOv2 ViT-S 编码器 + 深度 6 的 ViT-S 预测器、AdaLN + RoPE、带本体感受、2 步展开损失、W=3；DROID / Robocasa 用 DINOv3 ViT-L 编码器 + 深度 12 的 ViT-L 预测器、无本体感受；全部 CEM L2。
- 8 项里 7 项最好，Rc-Pl 输给 V-JEPA-2-AC。Robocasa 两项误差很大（±16.6、±13.4），差异未必显著。
- V-JEPA-2-AC 的数字来自**作者修 bug 后重训的模型**，不是官方权重（见下"复现"）。
- 注意：这里 DINO-WM 的数（Maze 81.6、Wall 64.1、Push-T 66.0）远低于 DINO-WM 原文（0.98 / 0.96 / 0.90）。本文基础配置去掉了本体感受、评测协议（目标采样、对最后若干 epoch 取平均）也不同，两边数字不能直接比较。

### 2. 规划器（§5.2，图 3a；完整数字见附录表 11）

节选表 11（成功率 %，各优化器下 DINO-WM / 本文）：

| 规划器 | Maze | Wall | Push-T | MW-R | DROID |
|---|---|---|---|---|---|
| CEM L2 | 81.6 / 83.9 | 64.1 / 78.8 | 66.0 / 70.2 | 44.8 / 58.2 | 39.4 / 48.2 |
| CEM L1 | 78.8 / 79.7 | 48.7 / 46.7 | 61.6 / 63.4 | 45.1 / 55.1 | 41.7 / 47.2 |
| NG L2 | 54.2 / 72.7 | 25.3 / 35.4 | 47.6 / 48.0 | 28.1 / 29.3 | 36.0 / 39.9 |
| Adam L2 | 14.8 / 17.7 | 0.1 / 1.1 | 8.0 / 9.0 | **62.0** / 55.3 | 0.0 / 0.0 |
| GD L2 | 14.5 / 17.7 | 0.1 / 1.1 | 8.1 / 9.1 | **62.2** / 55.3 | 0.0 / 0.0 |

- **CEM L2 总体最好**；所有设置下 L2 都好于 L1。
- 梯度规划器（Adam、GD）在 Metaworld 上反而最好（代价地形平滑、目标可贪心到达），在需要非贪心规划的 2D 导航（Wall 接近 0）和真实操作（DROID 全 0）上失败——卡在局部极小，比如在 Wall 里撞墙过不了门、或跑到图像边缘找到假极小（附录图 10）。
- NG 在 2D 导航上明显不如 CEM（收敛慢、探索多），但在 DROID / Robocasa 上与 CEM 相当且**无需调参**，作者推荐作为换新任务时的实用选择。
- 有意思的一点：用梯度规划器时，DINO-WM 在 Metaworld 上好于本文最优模型（62.0 vs 55.3），说明"最优"是针对 CEM 选出来的。

### 3. 训练相关（图 3b、4a、5b）

- **多步展开损失**：从纯 teacher forcing 到 2 步有提升，仿真里再多就下降；DROID 上最佳是 6 步。作者给的解释（附录 D 形式化）：预测器 Lipschitz 常数 Λ≥1 时误差随时域指数增长；多步训练会抬高单步误差 δ_K 但降低有效 Lipschitz 常数 Λ_K，起到"抗累积误差的数据增强"作用（类似 scheduled sampling）。仿真里精度项占主导、最优 K 小；真实数据里降低 Λ_K 更划算。
- **本体感受**：一致有帮助。冻结编码器的视觉嵌入只隐式、且被 patch 量化地编码精确度量信息，靠近目标时小位移几乎不改变嵌入距离；Metaworld 上没有本体感受时机械臂会在目标附近来回振荡。
- **上下文长度**：必须 W_p ≤ W；W=1 到 W=2 有大跳跃（2 帧才能推出速度）；仿真最佳 W=3，DROID 最佳 W=5。W 过大时可用的独立训练片段变少（DROID 上 W=14 只保留 86% 的视频）。

### 4. 编码器与结构（图 4b、5a）

- **DINO 系明显好于 V-JEPA 系**（都用 ViT-L）。作者的解释：DINO 的细粒度物体分割更好，不同物体落在不同空间 token、边界清晰，物体运动表现为局部稀疏的 token 变化，预测器容易学；V-JEPA 即使在图像模式下分割也更粗，物体信息分散在重叠的 token 上。
- **DINOv3 只在照片级环境（DROID、Robocasa）上明显好于 DINOv2**；在 Maze、Wall 这类合成环境上 DINOv3 收敛更慢、成功率更低。
- 预测器结构：AdaLN + RoPE 平均最好但优势很小，且任务相关——Metaworld 上反而是 sincos + 特征拼接最好；RoPE 换 sincos 没有明显差别。AdaLN-zero 平均分更高，但在作者认为信号最可靠的 DROID、PushT、Maze 上不如 AdaLN，所以最终选 AdaLN。附录 G.1 用相同动作维度占比重做后，仍发现条件方式偏好是任务相关的；序列条件的模型规划时偶尔选出幅度极大的动作。

### 5. 规模（图 6、7）

- 仿真里加大编码器（S→B→L，同时加宽预测器）或加深预测器（3→12）**都不提升**；最优深度多数为 6，最简单的 Wall、Maze 可能 3 就够。作者给三条假设：任务简单已饱和；高维嵌入让规划优化更难；固定训练算力下大模型每参数更新次数少。
- DROID 上编码器大小、预测器深度都与规划性能**一致正相关**。
- 数据规模（2% / 10% / 50% / 100%，迭代数固定）：所有方法都随数据增加而提升；本文方法在 DROID 和 Wall 上领先最明显；Robocasa 上因 DROID→Robocasa 的域差，规模趋势不清晰。

### 6. 复现 V-JEPA-2-AC 时发现的 bug（附录 C）

- 官方代码里 2 步展开损失算错了：实际被训练的是"输入真实 z₁ 拼接预测 ẑ₂，输出 ẑ₂"。作者修复后重训，在其 DROID 协议下官方权重的 Action Score 远低于修复后的模型。
- 官方权重的解码图像和反事实"抬杯子"测试（图 2）却看起来和修复后的模型差不多——**预测看起来好不等于规划好**（附录 G.1 也专门论证"能忠实展开很多步"不直接带来规划成功）。
- 为与 V-JEPA-2-AC 可比，DROID 上不做动作归一化，并沿用其 CEM 对采样动作范数裁剪到 0.1 的做法。

### 7. 算力（附录表 6）

训练时间按"每 epoch 分钟数"报：Maze、Wall 用 16 张 H100，Push-T、Metaworld 用 32 张 H100；例如 Push-T 1 步展开 48 分钟 / epoch，6 步 64 分钟；DROID 训 315 个 epoch。

## 局限 / 存疑

> 论文 §6 自述的局限：预测器是确定性的，MSE 学的是多模态未来的条件均值；本文的基准动力学基本确定、加上潜空间抽象和闭环 MPC 缓解了这一点，有随机性的环境需要隐变量或潜空间扩散等随机扩展。其余条目是 Claude 的推断，请核对。

- **只研究冻结编码器**：结论（例如"DINO 好于 V-JEPA"、"仿真里模型越小越好"）不一定适用于 PLDM、LeWM 这类端到端训练编码器的 JEPA-WM。
- **一次只改一个因素**：相互作用没测（例如本体感受 × 展开步数、编码器 × 预测器结构），最终配方是把各单项最优拼起来，作者也没验证这样拼一定是联合最优。
- **评测指标噪声大**：Robocasa 误差 ±13–17；作者自己挑 DROID / PushT / Maze 作为"可靠信号"来决定 AdaLN vs AdaLN-zero，带有一定主观性。
- **真实机器人只有离线评测**：DROID 是 16 段实验室视频上的动作误差（Action Score），不是闭环真机成功率；Robocasa 存在系统性的相机 / 动作标定偏移（模型预测的状态总是偏左，附录图 12），Pick 任务成功率低。
- **与 DINO-WM 原文数字差距很大**（见上），说明 JEPA-WM 的成功率对评测协议非常敏感，跨论文比较要谨慎。
- 作者贡献声明里提到 Quentin Garrido 提出了 AdaLN 条件实现，但他不在作者名单里（在致谢中），属于小的文本不一致。
- 附录很长（55 页），本笔记没有逐页核对附录中所有消融的数字。

## 与其他论文的关系

- **研究对象**：把 [[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]] 当作基础配置和主基线，把 [[topics/notes/JEPA系列/2-03_V-JEPA2|V-JEPA 2]] 的 V-JEPA-2-AC 当作第二基线，并修复了后者官方代码里的展开损失 bug。
- **与 PLDM**：[[topics/notes/JEPA系列/1-03_PLDM|PLDM]] 证明了 JEPA 世界模型在导航上比 GCRL 泛化更好；本文引用其"世界模型擅长拼接次优轨迹"的结论来解释上下文长度的结果。PLDM 联合训练编码器，不在本文研究范围内。
- **与 Temporal Straightening**：[[topics/notes/JEPA系列/1-04_TemporalStraightening|Temporal Straightening]] 引用本文（Terver et al., 2025）"DINOv2 在 2D 导航规划上好于 DINOv3 和 V-JEPA 2"的结论来选编码器；两篇对梯度规划器的看法形成对照——本文发现 GD/Adam 在 2D 导航上几乎为 0，Temporal Straightening 则说明加曲率正则后 GD 在同类任务上能到 90%+，即梯度规划失败很大程度是潜空间几何问题。
- **与 LeWM**：[[topics/notes/JEPA系列/1-05_LeWM|LeWM]] 走端到端路线，也采用 AdaLN 注入动作；本文的"本体感受有用""预测器深度 6 左右"等结论可以和 LeWM 的消融对照。
- **与 V-JEPA 系表征**：本文发现 V-JEPA / V-JEPA 2 编码器（[[topics/notes/JEPA系列/2-02_V-JEPA|V-JEPA]]）在这类精细定位任务上不如 DINO，原因归于物体分割粒度。
- 作者在相关工作里提到同组的 EB-JEPA（Terver et al., 2026）是联合训练编码器的 JEPA-WM；以及 TD-JEPA 这种把时间抽象折进表征的"隐式世界模型"。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> A long-standing challenge in AI is to develop agents capable of solving a wide range of physical tasks and generalizing to new, unseen tasks and environments. A popular recent approach involves training a world model from state-action trajectories and subsequently using it with a planning algorithm to solve new tasks. Planning is commonly performed in the input space, but a recent family of methods has introduced planning algorithms that optimize in the learned representation space of the world model, with the promise that abstracting irrelevant details yields more efficient planning. In this work, we characterize models from this family as JEPA-WMs and investigate the technical choices that make algorithms from this class work. We propose a comprehensive study of several key components with the objective of finding the optimal approach within the family. We conducted experiments using both simulated environments and real-world robotic data, and studied how the model architecture, the training objective, and the planning algorithm affect planning success. We combine our findings to propose a model that outperforms two established baselines, DINO-WM and V-JEPA-2-AC, in both navigation and manipulation tasks. Code, data and checkpoints are available at https://github.com/facebookresearch/jepa-wms.
