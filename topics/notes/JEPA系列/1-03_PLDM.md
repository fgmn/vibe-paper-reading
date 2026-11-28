---
id: "1-03"
org: 专题·JEPA系列
short: "PLDM"
title: "Learning from Reward-Free Offline Data: A Case for Planning with Latent Dynamics Models"
aliases: ["PLDM", "Planning with a Latent Dynamics Model", "Learning from Reward-Free Offline Data"]
date: 2025-02-20
category: "JEPA 世界模型与规划"
venue: "NeurIPS 2025"
source: "arXiv"
affiliation: "NYU；Genentech；Brown University；University of Toronto；Meta FAIR"
partners: []
authors: ["Vlad Sobal", "Wancong Zhang", "Kyunghyun Cho", "Randall Balestriero", "Tim G. J. Rudner", "Yann LeCun"]
arxiv: "2502.14819"
pdf: "[[topics/papers/JEPA系列/1-03_2502.14819_PLDM.pdf]]"
code: "https://github.com/vladisai/PLDM"
project: "https://latent-planning.github.io"
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "latent-planning", "offline-rl", "reward-free", "vicreg", "navigation"]
---

# Learning from Reward-Free Offline Data: A Case for Planning with Latent Dynamics Models

> [!info] 论文信息
> arXiv [2502.14819](https://arxiv.org/abs/2502.14819) · v4 2025-10-29（v1 2025-02-20）· NeurIPS 2025 · 30 页（正文 9 页 + 附录）
> [项目页](https://latent-planning.github.io) · [代码](https://github.com/vladisai/PLDM)
> PDF：[[topics/papers/JEPA系列/1-03_2502.14819_PLDM.pdf|本地 PDF]]
> 作者：Vlad Sobal\*、Wancong Zhang\*（NYU）、Kyunghyun Cho（NYU、Genentech）、Randall Balestriero（Brown）、Tim G. J. Rudner（Toronto）、Yann LeCun（NYU、Meta FAIR）。\* 共同一作，顺序抛硬币决定。PDF 作者行把 Cho 的名字拼成了 "Kynghyun"，这里按通行拼写记。
> 专题：[[topics/JEPA系列#一、JEPA 世界模型与规划|JEPA系列 · 一]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录 C–L 的环境、损失消融、规划时间、超参数）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 研究问题："However, their comparative strengths in the offline setting—where agents must learn from reward-free trajectories—remain underexplored."（Abstract，p.1）
> - 主结论："Our results show that model-free RL benefits most from large amounts of high-quality data, whereas model-based planning generalizes better to unseen layouts and is more data-efficient"（Abstract，p.1）
> - PLDM 定义："We propose a model-based method named Planning with a Latent Dynamics Model (PLDM), which learns latent dynamics using a reconstruction-free SSL objective and the JEPA architecture"（§3.3，p.4）
> - 防坍塌："To prevent representation collapse, we use a VICReg-inspired [4] objective, and inverse dynamics modeling [40]."（§3.3，p.5）
> - 不确定性项："Cuncertainty penalizes the model from choosing state-action transitions that deviate from the training distribution"（§3.3，p.5）
> - 速度代价："By default, we use i = 1 for all experiments, making PLDM ∼4x slower than the model-free baselines."（§3.3，p.5）
> - 数据充足时都行："Takeaway: All methods can perform well when data is plentiful and high-quality."（§4.2，p.6）
> - 拼接："When solving the task requires 'stitching', HILP and GCIQL work great. The performance of PLDM drops, but is better than that of most offline model-free GCRL methods."（§4.4，p.7）
> - 换任务只换代价："PLDM can generalize to tasks other than goal-reaching simply by changing the planning objective."（§4.6，p.8）
> - 方差项沿时间维："We modify it to apply variance objective across the time dimension to encourage features to capture information that changes, as opposed to information that stays fixed"（附录 D.1.1，p.19–20）

## 一句话总结

一篇**对比研究**：在无奖励的离线轨迹上，比较 5 种无模型方法（GCIQL、HIQL、HILP、CRL、GCBC）和作者提出的 **PLDM**（JEPA 式潜动力学模型 + VICReg 式防坍塌 + MPPI 规划）。在两个可精细控制数据质量的导航环境（自建 Two-Rooms、可换布局的 Diverse PointMaze）加 Ant-U-Maze 上造了 23 个数据集，逐项测试"数据多且好""数据少""轨迹短需拼接""随机策略数据""新任务""新布局"。结论：数据又多又好时大家都接近 100%；PLDM 是唯一在所有设置下都有竞争力的方法，**泛化到没见过的迷宫布局**最好，换任务只需改规划代价；代价是推理约慢 4 倍，且在"数据里从不穿门"的拼接设置下只有 34.4%（HILP、GCIQL 接近 100%）。

## 要解决什么问题

- 目标：从**大量次优、无奖励**的离线轨迹里学出能解多种任务、能适应新环境的智能体。两条路线：
  - 强化学习（这里指显式或隐式用奖励信息训练策略）：目标条件 RL（GCIQL、HIQL、CRL、GCBC）和零样本 RL（HILP）；
  - 最优控制：学一个动力学模型，测试时显式搜索动作。
- 之前的工作大多在专家或探索策略数据上测 RL，**没有拆开数据质量的哪些方面影响性能**；OGBench 有多个数据集但没做这种细粒度分析。
- 作者用导航任务作受控测试床（需要空间推理、换布局泛化、轨迹拼接），明确不覆盖操作任务。

## 方法

### PLDM 模型（§3.3，附录 D.1）

- 编码器 ẑ₀ = z₀ = h_θ(s₀)；预测器 ẑ_t^k = f_θ^k(ẑ_{t−1}^k, a_{t−1})，K>1 时是预测器集成（用于测试时的不确定性正则）。
- 预测损失 L_sim：在整个预测时域 H 上，对每个集成成员把预测潜变量和编码潜变量的 L2 距离求和（多步自回归展开，不是只预测一步）。
- 总损失：L_JEPA = L_sim + α·L_var + β·L_cov + δ·L_time-sim + ω·L_IDM

| 项 | 内容 |
|---|---|
| L_var | VICReg 方差铰链 max(0, γ − √Var + ε)，但**沿时间维**对每个时间步、每个特征维算——鼓励特征捕捉随时间变化的信息而非固定不变的信息 |
| L_cov | VICReg 协方差项，压非对角元 |
| L_time-sim | 相邻时刻潜变量的 L2 距离，**时间平滑（慢度）**项，作用于整个潜向量 |
| L_IDM | 逆动力学：MLP(z_t, z_{t+1}) 预测 a_t |

- 没有 stop-gradient，目标分支和在线分支是同一个编码器（Content–Geometry 那篇把 PLDM 归为"无 SG + 全潜向量慢度"）。

**损失消融（附录 D.1.2，成功率 %，把对应系数置 0）**

| 去掉的项 | Two-Rooms | Diverse Maze（5 张图） |
|---|---|---|
| 无（完整） | 98.0±1.5 | 98.7±2.8 |
| 方差 α | 13.4±9.2 | 11.4±6.5 |
| 协方差 β | 29.2±4.4 | 7.8±4.1 |
| 时间平滑 δ | 71.0±3.0 | 95.6±3.2 |
| IDM ω | 98.0±1.5 | 75.5±8.2 |

方差、协方差项缺一不可（去掉就近乎坍塌）；时间平滑项在 Two-Rooms 关键，IDM 在 Diverse Maze 关键（Two-Rooms 默认 ω=0，所以去掉没影响）。

### 规划（式 4–7）

- C_goal：所有集成成员、所有时间步上，预测潜变量与目标编码 h_θ(s_g) 的距离之和（**每一步都算**，不只终态）。
- C_uncertainty：集成预测在各维上的方差，按 γ^t 折扣求和，惩罚走出训练分布的状态–动作（作者类比 GCIQL/HIQL/HILP 里 expectile 回归让策略留在分布内）。
- a* = argmin C_goal + β·C_uncertainty，用 **MPPI** 优化；MPC 每 i 步重规划，默认 i=1（Diverse PointMaze 用 k=4）。
- 换任务不用重训，只改代价：§4.6 把目标代价取反，就变成"躲开某个状态"。

### 实现

| 环境 | 编码器 | 预测器 | 参数量 |
|---|---|---|---|
| Two-Rooms（64×64，2 通道：智能体 / 墙） | OGBench 的 Impala Small | 2 层 GRU（512 隐维），初始隐状态 = h_θ(s₀) | 约 2.2M |
| Diverse PointMaze（64×64 RGB + 速度） | 5 层小 CNN，输出 16×26×26 空间特征，速度扩成平面拼接（18×26×26） | 3 层卷积 | 约 5.4 万 |
| Ant-U-Maze（29 维状态） | 只把全局 (x,y) 用 MLP 编成 256 维，其余本体感受原样拼接 | 3 层 MLP，集成 5 个 | 约 108 万 |

预测时域 H=16；MPPI 500 个样本。所有实验单卡 V100、每个最多 1 天；总算力（含研究过程）估计 500–2000 GPU 天（附录 K）。

## 实验与关键数字

评测：3 个种子，报告均值 ± 标准误（除特别说明）。Two-Rooms：200 步内从一个房间到另一个房间的随机目标；默认数据 3M 转移（约 3 万条、每条 T=91），动作方向按 Von Mises 分布（集中度 5）采样，约 35% 的轨迹穿门。

### 1. 总览（表 1，定性星级）

作者结论：HILP 和 PLDM 最好，**PLDM 是唯一在所有六项（换布局、换任务、数据效率、最佳性能、随机策略数据、拼接）都达到有竞争力水平的方法**。表 1 在 PDF 抽取后星级错位，具体每格需对照 PDF 原图核对。

### 2. 数据好且多 vs 不穿门（表 2，Two-Rooms 成功率 %）

| 方法 | 高质量数据 | 没有穿门轨迹 |
|---|---|---|
| CRL | 89.3±0.7 | 14.7±4.1 |
| GCBC | 86.0±2.0 | 8.4±1.2 |
| GCIQL | 98.0±0.9 | 99.6±0.4 |
| HILP | 100.0±0.0 | 100.0±0.0 |
| HIQL | 96.4±1.3 | 26.3±5.6 |
| PLDM | 97.8±0.7 | 34.4±2.7 |

- 数据充足时 HIQL、GCIQL、HILP、PLDM 都接近 100%。
- "不穿门"设置要求把两个房间的轨迹拼起来：HILP、GCIQL 满分；PLDM 掉到 34.4%，仍高于 CRL/GCBC/HIQL。PLDM 的弱项就在这里。

### 3. 数据效率、轨迹长度、数据质量（图 4，只有曲线）

- **数据量**（10³–10⁶ 转移）：PLDM 和 GCIQL 最省数据，几千条转移就接近 80%；HILP 最"吃数据"，但数据够时满分。
- **轨迹长度**（91/64/32/16，总量固定 3M）：最难的目标约需 90 步，T=16 时目标从未在一条轨迹里出现；除 GCIQL 外的目标条件方法在短轨迹上崩，HILP 和 PLDM 保持较好。
- **随机策略数据**：均匀随机动作的轨迹平均最大跨度约 10（全图 64×64），Von Mises 数据约 28。HILP、GCIQL、PLDM 明显好于其他。作者解释：PLDM 只用数据学动力学，随机数据对学动力学依然够用；GCRL 训练时采到的状态–目标对都很近，远目标成了分布外。
- 具体数值只在图里，正文没给表；附录 H 用 Welch t 检验说明 PLDM 显著优于 CRL、GCBC、HIQL，对 GCIQL、HILP 在这三组上多数不显著（表 7、8）。

### 4. 换任务：躲避追逐者（§4.6，图 5b）

用 §4.2 训练好的模型、不再训练；追逐者沿最短路追，速度可调。PLDM 把目标代价取反（最大化与追逐者潜变量的距离），HILP 把技能方向取反。成功 = 100 步内始终保持 ≥1.4 像素距离。PLDM 优于 HILP，回合末保持更大距离。只有曲线，没有具体数字。

### 5. 高维控制：Ant-U-Maze（§4.7，图 6）

基于状态（29 维状态、8 维动作）；用预训练方向专家策略 + 高斯噪声（σ=1.0）采 5M 转移；轨迹长度 25/50/100/250/500，测试起终点约 200 步，各 10 次试验。PLDM、HIQL、HILP 在拼接上达到 100%，其他方法短轨迹时失败；这里 HIQL 好于 GCIQL（与 Two-Rooms 相反）。

### 6. 泛化到新迷宫布局（§4.8，图 2、7、8）——PLDM 最突出的结果

- Diverse PointMaze：4×4 网格迷宫随机生成，64×64 RGB 俯视图 + 速度，动作是二维加速度，随机动作采数据；训练 5/10/20/40 种布局，各 1M 转移；测试布局全部与训练不重叠（40 张图各 1 次试验）。
- PLDM 只用 5 种布局训练就能泛化，其他方法失败；按与训练布局的最小编辑距离分组看分布偏移，**除 PLDM 外所有方法随偏移增大而退化**。
- 单一固定布局时所有方法都接近满分（表 4：PLDM 0.990、GCIQL/HIQL/HILP 1.000、CRL 0.980、GCBC 0.970）。
- HILP 失败原因（附录 I）：它的潜距离在训练过的迷宫里平滑反映步数，在没见过的迷宫里变成噪声。

### 7. 重建式 / TD-MPC2 基线（附录 G，表 6，Two-Rooms 高质量数据）

| 方法 | 成功率 % |
|---|---|
| PLDM | 97.4±1.3 |
| DreamerV3（去奖励，按潜距离规划，用 KL） | 24.0±6.9 |
| Reconstruction（PLDM 架构，VICReg 换成像素重建） | 26.2±13.9 |
| TD-MPC2（去奖励，只留一致性损失） | 0.0±0.0（坍塌） |
| TD-MPC2 + IDM（单种子） | 35.0 |

作者自己也承认 DreamerV3 这样用"不是它的设计用途，比较有缺陷"。

### 8. 规划耗时（附录 F，表 5，Two-Rooms 每回合 200 步）

| 方法 | 每几步重规划 | 每回合秒数 | 归一化成功率 |
|---|---|---|---|
| PLDM | 1 | 16.0 | 1.00 |
| PLDM | 4 | 4.8 | 0.95 |
| PLDM | 16 | 2.6 | 0.90 |
| PLDM | 32 | 2.2 | 0.62 |
| GCIQL | – | 3.6 | – |
| HIQL | – | 4.0 | – |

每 4 步重规划时速度接近策略方法，性能只掉一点（图 10、11）。

## 局限 / 存疑

> 论文附录 L 自述：只做了导航，没有操作和部分可观测环境；推理约慢 4 倍（但限定同等推理算力时仍保留大部分性能）。下面其余条目是 Claude 的推断，请核对。

- **环境都很简单**：Two-Rooms 是两通道合成图、无动量；Diverse PointMaze 是 4×4 网格；Ant-U-Maze 直接用状态，PLDM 只编码 (x,y)。离 DINO-WM 那类自然图像、接触丰富的操作还很远。
- **拼接是短板**：不穿门数据下 34.4%，远低于 HILP/GCIQL 的 ~100%；作者把 PLDM 定位为"综合最均衡"，不是每项最好。
- **超参按数据集逐个调**：附录 J 里 α、β、δ、学习率随数据集变化很大（如 Diverse Maze 的 α=35–54.5，Two-Rooms 的 α=2.2–5），说明 VICReg 式损失对系数敏感；去掉方差或协方差项就崩。
- **数字前后不一致，需核对**：
  - 同一"高质量数据 Two-Rooms"设置，PLDM 在表 2 是 97.8±0.7，在附录表 6 是 97.4±1.3，消融表里是 98.0±1.5；其他方法在两表里均值相同但误差不同（如 CRL ±0.7 vs ±1.2），可能表 6 报的是标准差而表 2 是标准误，但没说明。
  - 正文说结果是 3 个种子，附录 H 却写"Because 5 seeds is not enough for statistical tests"。
  - 附录表 16 的布局数写成 5、5、20、40（缺 10），疑似笔误。
  - 表 1 的星级在文本里排列错乱，需看原图。
- **主要结果只在图里**（数据量、轨迹长度、换布局、追逐任务），正文缺具体数字表，读者难以精确比较。
- 作为 JEPA 世界模型，PLDM 和 DINO-WM 没有直接比较（只在相关工作里引用 DINO-WM）。

## 与其他论文的关系

- **与 DINO-WM 的对照**：[[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]] 用冻结的预训练编码器、只训练预测器，自然没有坍塌问题；PLDM 端到端从零训练编码器和预测器，用 VICReg 方差/协方差 + 时间平滑 + IDM 防坍塌。两者都是"潜空间预测 + 采样式 MPC（CEM / MPPI）"，但 PLDM 的代价对每一步都算、还加了集成不确定性项。
- **防坍塌谱系**：PLDM 属于"不加 stop-gradient、靠分布正则"的一支（VICReg）。[[topics/notes/JEPA系列/1-05_LeWM|LeWM]] 把 VICReg 换成 SIGReg，把多项损失简化为两项；[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 把 PLDM 作为"对整个潜向量加慢度"的代表，自己只对一小组慢通道加。
- **时间平滑 / 潜几何**：L_time-sim 是慢特征思想；[[topics/notes/JEPA系列/1-04_TemporalStraightening|Temporal Straightening]] 更进一步要求潜轨迹"直"（低曲率），可以看作同一方向。
- **离线 RL 一侧**：HILP（距离保持表征，近似拉普拉斯表征）是最强对手，它在训练布局上潜距离很好但换布局就失效——这和本系列关心的"潜空间距离能否当导航信号"直接相关，也可参照 [[topics/notes/JEPA系列/1-10_CommuteTimeWM|Commute-Time WM]]。
- **系统性拆解**：[[topics/notes/JEPA系列/1-06_WhatDrivesSuccess|What Drives Success]] 对 JEPA 世界模型的设计选择做了更大规模的消融，可与本文的损失消融对照。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> A long-standing goal in AI is to develop agents capable of solving diverse tasks across a range of environments, including those never seen during training. Two dominant paradigms address this challenge: (i) reinforcement learning (RL), which learns policies via trial and error, and (ii) optimal control, which plans actions using a known or learned dynamics model. However, their comparative strengths in the offline setting—where agents must learn from reward-free trajectories—remain underexplored. In this work, we systematically evaluate RL and control-based methods on a suite of navigation tasks, using offline datasets of varying quality. On the RL side, we consider goal-conditioned and zero-shot methods. On the control side, we train a latent dynamics model using the Joint Embedding Predictive Architecture (JEPA) and employ it for planning. We investigate how factors such as data diversity, trajectory quality, and environment variability influence the performance of these approaches. Our results show that model-free RL benefits most from large amounts of high-quality data, whereas model-based planning generalizes better to unseen layouts and is more data-efficient, while achieving trajectory stitching performance comparable to leading model-free methods. Notably, planning with a latent dynamics model proves to be a strong approach for handling suboptimal offline data and adapting to diverse environments.
