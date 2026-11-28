---
id: "1-02"
org: 专题·JEPA系列
short: "DINO-WM"
title: "DINO-WM: World Models on Pre-trained Visual Features enable Zero-shot Planning"
aliases: ["DINO-WM", "DINO World Model"]
date: 2024-11-07
category: "JEPA 世界模型与规划"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "NYU Courant Institute；Meta AI"
partners: []
authors: ["Gaoyue Zhou", "Hengkai Pan", "Yann LeCun", "Lerrel Pinto"]
arxiv: "2411.04983"
pdf: "[[topics/papers/JEPA系列/1-02_2411.04983_DINO-WM.pdf]]"
code: ""
project: "https://dino-wm.github.io"
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "latent-planning", "dinov2", "cem-mpc", "offline-learning"]
---

# DINO-WM: World Models on Pre-trained Visual Features enable Zero-shot Planning

> [!info] 论文信息
> arXiv [2411.04983](https://arxiv.org/abs/2411.04983) · v2 2025-02-01（v1 2024-11-07）· 21 页（正文 8 页 + 附录）
> [项目页](https://dino-wm.github.io)（正文说代码和模型开源，但 PDF 里只给了项目页地址，没有单独的代码仓库链接）
> PDF：[[topics/papers/JEPA系列/1-02_2411.04983_DINO-WM.pdf|本地 PDF]]
> 作者：Gaoyue Zhou、Hengkai Pan、Yann LeCun、Lerrel Pinto（NYU Courant；LeCun 另属 Meta AI）
> 发表：PDF 版式像 ICML，但正文没写会议名；`venue` 按 PDF 记为预印本（印象中是 ICML 2025，需核对）。
> 专题：[[topics/JEPA系列#一、JEPA 世界模型与规划|JEPA系列 · 一]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录 A 的消融、超参数和推理时间表）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 三条要求："we argue that they should 1) be trainable on offline, pre-collected trajectories, 2) support test-time behavior optimization, and 3) facilitate task-agnostic reasoning."（Abstract，p.1）
> - 离线方法依赖辅助信息："methods in this domain require strong auxiliary information which can take the form of expert demonstrations…, structured keypoints…, access to pretrained inverse models… or dense reward functions"（§1，p.1–2）
> - 编码器冻结："The observation model remains frozen during training and testing."（§3.1.1，p.4）
> - 帧级因果注意力："we implement a causal attention mechanism in the ViT model, enabling the model to predict latents autoregressively at a frame level."（§3.1.2，p.4）
> - 训练全在潜空间："Note that our world model training is entirely performed in latent space, without the need to reconstruct the original pixel images."（§3.1.2，p.5）
> - 规划代价："The planning cost is defined as the mean squared error (MSE) between the current latent state and the goal's latent state"（§3.2，p.5）
> - CEM 优于梯度下降："However, we empirically observe that CEM outperforms GD in our experiments"（§3.2，p.5）
> - 无奖励时 TD-MPC2 学不好："for TD-MPC2, the lack of reward signal makes it difficult to learn good latent representations"（§4.3，p.6）
> - patch 特征的作用："We posit that patch-based representations better capture spatial information, in contrast to models like R3M, ResNet, and DINO CLS"（§4.4，p.7）
> - 局限之一："DINO-WM assumes having access to offline datasets with sufficient state-action coverage"（§5，p.8）

## 一句话总结

把**冻结的 DINOv2 patch 特征**当作世界模型的潜状态，在上面训练一个帧级因果 ViT 预测器（只用 MSE 预测下一帧的 patch 特征，不重建像素、不用奖励），测试时给一张目标图，用 CEM + MPC 最小化"预测终态潜变量与目标潜变量的 MSE"来零样本规划。六个环境里，导航任务和 DreamerV3 打平，接触丰富的操作任务（PushT 0.90 vs 0.30、Rope、Granular）大幅领先；换成全局向量编码器（R3M、ResNet、DINO CLS）性能明显下降。它是这个系列里后续 JEPA 世界模型（PLDM、LeWM 等）最常用的规划框架和基线。

## 要解决什么问题

- 作者希望世界模型满足三点：①能从**离线、预先采集的轨迹**训练；②支持**测试时行为优化**（而不是前馈策略）；③**与任务无关**。
- 在线世界模型（DreamerV3、TD-MPC2）只在当前策略覆盖到的区域准，换任务要重训；而且往往要奖励、折扣、终止信号，天然带任务信息。
- 离线方法需要额外信息：专家示范、结构化关键点、预训练逆模型或稠密奖励，都削弱通用性。
- 像素空间预测（视频扩散，如 AVDC）计算贵、难用于 MPC；潜空间方法又通常靠重建损失学表征，不确定特征里有没有任务需要的信息。
- 核心问题：有没有一种不牺牲通用性的"辅助信息"？作者的答案是**大规模预训练的视觉表征**（DINOv2 patch 特征）。

## 方法

### 模型组成（§3.1）

| 组件 | 做法 |
|---|---|
| 观测模型 | 冻结的 DINOv2，把图像编码成 patch 嵌入 z_t ∈ R^{N×E}；训练、测试都不更新。实现：特征形状 (14×14, 384)，即 ViT-S/14 级别的维度 |
| 转移模型 | 去掉 tokenization 层的 ViT（深度 6、16 头、MLP 2048，约 19M 参数）；输入历史 H 帧的潜变量和动作，预测下一帧 |
| 动作 / 本体感受条件 | 动作经 MLP 映射成 K 维（实现里 10 维），**拼接到每个 patch 向量上**；有本体感受时同样拼接 |
| 注意力掩码 | **帧级因果**：第 t 帧的每个 patch 可以看历史各帧的所有 patch，按帧自回归（区别于 IRIS 的逐 token 自回归） |
| 解码器（可选） | 转置卷积把 patch 特征解码回像素，只用于可视化；**单独训练，不回传给预测器** |

训练损失（式 1，teacher forcing）：L_pred = ‖p_θ(enc(o_{t−H:t}), φ(a_{t−H:t})) − enc(o_{t+1})‖²，在每段长度 H+1 的切片里对 H 个预测帧都算。因为编码器冻结，不存在表征坍塌问题，所以没有 stop-gradient、方差正则之类的设计。

为了让预测有意义，相邻帧之间用 frameskip 跳帧（多数环境 5，Rope/Granular 为 1）。

### 规划（§3.2，附录 A.5）

- 输入当前图 o_0 和目标图 o_g，代价 C = ‖ẑ_T − z_g‖²，ẑ 由预测器自回归滚出。只看**终态**，不看中间步。
- 优化器：CEM（高斯初始化，每轮采 N 条动作序列，取 top-K 更新均值和协方差），执行前 k 个动作后重规划（MPC）。
- 也试了梯度下降（GD）直接对动作反传，效果差很多（见下表 8）。

## 实验与关键数字

六个环境：PointMaze（Maze）、Wall（两房间 + 门）、Reacher（要求整条手臂匹配目标姿态）、PushT、Rope、Granular（XArm + Nvidia Flex 可变形物体）。图像 224×224；目标是随机采样的目标图像。Maze/Wall/Reach/PushT 各 50 个起点–目标对，算成功率 SR；Rope/Granular 因仿真慢只测 10 个实例的 Chamfer Distance（CD，越低越好）。基线（IRIS、DreamerV3、TD-MPC2）都用同样的离线数据训练、不给奖励，再在其上做 MPC。

### 1. 主结果（表 1）

| 模型 | Maze SR↑ | Wall SR↑ | Reach SR↑ | PushT SR↑ | Rope CD↓ | Granular CD↓ |
|---|---|---|---|---|---|---|
| IRIS | 0.74 | 0.04 | 0.18 | 0.32 | 1.11 | 0.37 |
| DreamerV3 | **1.00** | **1.00** | 0.64 | 0.30 | 2.49 | 1.05 |
| TD-MPC2 | 0.00 | 0.00 | 0.00 | 0.00 | 2.52 | 1.21 |
| **DINO-WM** | 0.98 | 0.96 | **0.92** | **0.90** | **0.41** | **0.26** |

- 简单导航（Maze、Wall）和 DreamerV3 持平；接触丰富的操作任务大幅领先。
- TD-MPC2 全 0：作者归因于没有奖励信号时学不到好的潜表征。
- 引言里"最难任务上平均比先前工作高 45%"、"LPIPS 提升 56%"这两个汇总数字没有给出具体算法（哪几个任务、和哪个基线比），需核对。

### 2. 预训练表征是否重要（表 2）

| 编码器 | Maze | Wall | Reach | PushT | Rope CD↓ | Granular CD↓ |
|---|---|---|---|---|---|---|
| R3M | 0.94 | 0.34 | 0.40 | 0.42 | 1.13 | 0.95 |
| ImageNet ResNet-18 | 0.98 | 0.12 | 0.06 | 0.20 | 1.08 | 0.90 |
| DINO CLS | 0.96 | 0.58 | 0.60 | 0.44 | 0.84 | 0.79 |
| **DINO Patch** | 0.98 | 0.96 | 0.92 | 0.90 | 0.41 | 0.26 |

PointMaze 上各编码器都接近满分；一旦需要精细空间信息，单个全局向量（R3M、ResNet、CLS）就明显掉，作者归因于 patch 表征保留了空间细节。

### 3. 泛化到没见过的环境配置（表 3）

| 模型 | WallRandom SR↑ | PushObj SR↑ | GranularRandom CD↓ |
|---|---|---|---|
| IRIS | 0.06 | 0.14 | 0.86 |
| DreamerV3 | 0.76 | 0.18 | 1.53 |
| R3M | 0.40 | 0.16 | 1.12 |
| ResNet | 0.40 | 0.14 | 0.98 |
| DINO CLS | 0.64 | 0.18 | 1.36 |
| **DINO-WM** | **0.82** | **0.34** | **0.63** |

- WallRandom：测试时墙和门的位置与训练不重叠；PushObj：训练 4 种形状，测试 2 种没见过的（俄罗斯方块形、"+"形）；GranularRandom：粒子数不到训练时的一半。
- PushObj 对所有方法都难，DINO-WM 也只有 0.34。
- 正文 §4.5 写"From Table 5"，实际对应的是表 3（附录的表 5 是数据规模），属于引用笔误。

### 4. 解码质量（表 4 / 表 9，LPIPS↓）

| 方法 | PushT | Wall | Rope | Granular |
|---|---|---|---|---|
| R3M | 0.045 | 0.008 | 0.023 | 0.080 |
| ResNet | 0.063 | 0.002 | 0.025 | 0.080 |
| DINO CLS | 0.039 | 0.004 | 0.029 | 0.086 |
| AVDC | 0.046 | 0.030 | 0.060 | 0.106 |
| **DINO-WM** | **0.007** | **0.0016** | **0.009** | **0.035** |

SSIM 同样最好（PushT 0.985、Granular 0.940）。即使编码器从没用重建目标训练过，解码出的预测帧也最接近真值。AVDC（视频扩散）画面逼真但物理上不合理，单步内会出现大幅跳变；动作条件版 AVDC 长程会发散（附录 A.6）。

### 5. 消融（附录 A.4、A.5）

**数据规模（表 5，PushT）**

| 轨迹数 | 200 | 1000 | 5000 | 10000 | 18500 |
|---|---|---|---|---|---|
| SR | 0.08 | 0.48 | 0.72 | 0.88 | 0.92 |
| LPIPS | 0.056 | 0.013 | 0.007 | 0.006 | 0.005 |

**因果掩码（表 6，PushT SR）**：h=1 时有无掩码都 0.76；h=2/3 时无掩码掉到 0.36/0.08（训练时能偷看未来帧），有掩码升到 0.88/0.92。

**解码器损失回传给预测器（表 7）**：0.92 → 0.80，说明把特征学习和重建目标分开更好。

**规划优化器（表 8）**

| | PointMaze | PushT | Wall | Rope | Granular |
|---|---|---|---|---|---|
| CEM（开环，不重规划） | 0.80 | 0.86 | 0.74 | NA | NA |
| GD（开环） | 0.22 | 0.28 | NA | NA | NA |
| MPC（CEM + 重规划） | 0.98 | 0.90 | 0.96 | 0.41 | 0.26 |

注意表 8 把 Rope/Granular 的 CD 和成功率放在同一表里。

### 6. 速度（表 10，A6000）

单步推理（batch 32）0.014 s；仿真器前进一步（batch 1）3.0 s；一次 CEM 规划（100 样本 × 10 轮）53.0 s。作者强调相对可变形物体仿真的加速，但 53 s 一次规划离实时还远。

## 局限 / 存疑

> 论文 §5 自述三条局限：需要状态–动作覆盖充分的离线数据；依赖真实动作标签，难直接用无动作的互联网视频；目前在原始动作空间规划，后续可做分层。下面其余条目是 Claude 的推断，请核对。

- **全是仿真**，没有真机实验；目标以与当前同视角的目标图像给出。
- **规划慢**：一次 CEM 规划 53 s（表 10），长程或实时控制会受限。后续 LeWM 等工作专门以"规划快多少倍"作为卖点，正是针对这一点。
- **代价只看终态 MSE**：没有中间步代价，潜空间距离是否平滑地反映"离目标多远"没有分析——这正是 [[topics/notes/JEPA系列/1-04_TemporalStraightening|时间拉直]]、[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry]] 等后续工作的出发点。
- **编码器冻结**：DINOv2 不针对动力学调整；好处是不会坍塌，坏处是表征里与控制无关的内容（纹理、背景）也要被预测，patch 特征维度高（196×384）。
- **评估样本少**：每个环境 50 个起点–目标对（Rope/Granular 只有 10 个），没有给方差或多种子结果。
- **图像尺寸前后不一**：§4.1 和表 12 写观测是 224×224，附录 A.9 又说输入"resized to 196 × 196"得到 14×14 patch；两者大概是"环境渲染 224、送入 DINOv2 前缩到 196"，需核对。
- 引言的汇总数字（+45% 成功率、+56% LPIPS）口径未说明，需核对。

## 与其他论文的关系

- **规划框架的源头**：本系列多数世界模型论文都沿用 DINO-WM 的"冻结/学习编码器 + 动作条件预测器 + CEM-MPC 最小化到目标潜变量的距离"范式，并用它的环境（PointMaze、Wall、PushT、Reacher）。例如 [[topics/notes/JEPA系列/1-03_PLDM|PLDM]] 同期走端到端路线（VICReg 式防坍塌、MPPI 规划），但只在相关工作里引用 DINO-WM、没有直接比较；[[topics/notes/JEPA系列/1-05_LeWM|LeWM]] 改成端到端从像素学单 token 编码器（SIGReg 防坍塌），沿用 DINO-WM 的规划协议，一次规划 0.98 s vs DINO-WM 47 s；[[topics/notes/JEPA系列/1-06_WhatDrivesSuccess|What Drives Success]] 以 DINO-WM 为基础配置，系统拆解编码器、预测器结构、展开损失、规划器等设计选择——它在自己的协议下测得的 DINO-WM 成功率（Wall 64.1%、Push-T 66.0%，无本体感受）远低于本文表 1。
- **潜空间几何**：DINO-WM 只要求预测准，不管潜距离的形状；[[topics/notes/JEPA系列/1-04_TemporalStraightening|Temporal Straightening]] 加曲率正则让轨迹变直，[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 讨论 SG / 分布正则对潜几何的影响，都以 DINO-WM 的规划设置为评测协议。
- **表征来源**：编码器来自自监督图像表征（DINOv2）；同一谱系的 JEPA 表征见 [[topics/notes/JEPA系列/2-01_I-JEPA|I-JEPA]]、[[topics/notes/JEPA系列/2-02_V-JEPA|V-JEPA]]；[[topics/notes/JEPA系列/2-03_V-JEPA2|V-JEPA 2]] 的 V-JEPA 2-AC 也是"冻结视频编码器 + 动作条件预测器 + CEM 规划"，可看作把 DINO-WM 思路搬到大规模视频预训练和真机上。
- **对比的世界模型**：DreamerV3、TD-MPC2、IRIS（重建或奖励驱动），AVDC（像素空间视频扩散）。
- 库里相关：[[xsquare/notes/23_EgoJEPA|EgoJEPA]]。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> The ability to predict future outcomes given control actions is fundamental for physical reasoning. However, such predictive models, often called world models, remains challenging to learn and are typically developed for task-specific solutions with online policy learning. To unlock world models' true potential, we argue that they should 1) be trainable on offline, pre-collected trajectories, 2) support test-time behavior optimization, and 3) facilitate task-agnostic reasoning. To this end, we present DINO World Model (DINO-WM), a new method to model visual dynamics without reconstructing the visual world. DINO-WM leverages spatial patch features pre-trained with DINOv2, enabling it to learn from offline behavioral trajectories by predicting future patch features. This allows DINO-WM to achieve observational goals through action sequence optimization, facilitating task-agnostic planning by treating goal features as prediction targets. We demonstrate that DINO-WM achieves zero-shot behavioral solutions at test time on six environments without expert demonstrations, reward modeling, or pre-learned inverse models, outperforming prior state-of-the-art work across diverse task families such as arbitrarily configured mazes, push manipulation with varied object shapes, and multi-particle scenarios.
