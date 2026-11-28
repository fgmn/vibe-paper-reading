---
id: "2-04"
org: 专题·JEPA系列
short: "JEPA Slow Features"
title: "Joint Embedding Predictive Architectures Focus on Slow Features"
aliases: ["JEPA Slow Features", "JEPAs Focus on Slow Features", "moving dot JEPA"]
date: 2022-11-20
category: "JEPA 奠基与防坍塌正则"
venue: "NeurIPS 2022"
source: "arXiv"
affiliation: "New York University；Meta AI；Prescient Design (Genentech)；CIFAR"
partners: ["Meta AI", "Prescient Design, Genentech", "CIFAR"]
authors: ["Vlad Sobal", "Jyothir S V", "Siddhartha Jalagam", "Nicolas Carion", "Kyunghyun Cho", "Yann LeCun"]
arxiv: "2211.10831"
pdf: "[[topics/papers/JEPA系列/2-04_2211.10831_JEPASlowFeatures.pdf]]"
code: "https://github.com/vladisai/JEPA_SSL_NeurIPS_2022"
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "slow-feature", "vicreg", "contrastive", "distractor", "failure-analysis"]
---

# Joint Embedding Predictive Architectures Focus on Slow Features

> [!info] 论文信息
> arXiv [2211.10831](https://arxiv.org/abs/2211.10831) · v1 2022-11-20 · 13 页（正文 4 页 + 附录 A.1–A.11）
> PDF：[[topics/papers/JEPA系列/2-04_2211.10831_JEPASlowFeatures.pdf|本地 PDF]]
> 作者：Vlad Sobal、Jyothir S V、Siddhartha Jalagam（NYU）、Nicolas Carion（Meta AI）、Kyunghyun Cho（NYU、Prescient Design / Genentech、CIFAR Fellow）、Yann LeCun（NYU、Meta AI）
> 发表：PDF 页脚写 "36th Conference on Neural Information Processing Systems (NeurIPS 2022)"；正文只有 4 页，按篇幅看更像 NeurIPS 2022 的 workshop 论文（需核对具体是哪个 workshop）。
> 代码：[vladisai/JEPA_SSL_NeurIPS_2022](https://github.com/vladisai/JEPA_SSL_NeurIPS_2022)
> 专题：[[topics/JEPA系列#二、JEPA 奠基与防坍塌正则|JEPA系列 · 二]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录的数据集、损失、3 点数据集结果和局限）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 研究对象："we analyze performance of JEPA trained with VICReg and SimCLR objectives in the fully offline setting without access to rewards"（Abstract，p.1）
> - 核心发现："JEPA methods perform on par or better than reconstruction when distractor noise changes every time step, but fail when the noise is fixed."（Abstract，p.1）
> - 伪相关："the loss can be easily minimized by paying attention to noise that does not change with time, making the system ignore all other information."（§2.1，p.2）
> - 慢特征："Intuitively, the objectives make the model focus on 'slow features' [37]. When the slowest features in the input belong to fixed background noise, the representation will only contain the noise."（§2.1，p.2）
> - 平凡解让 VICReg 总损失为零："The total sum of the loss components is then 0 for the described trivial solution."（§2.1，p.3）
> - SimCLR 同样中招："therefore SimCLR objective is also susceptible to fixed distractor noise problem."（§2.1，p.3）
> - 重建的表现："Reconstruction performs well in all settings with α ≤ 1.5, while JEPA-based methods fail in the presence of fixed noise, both structured and uniform."（§3.1，p.4）
> - IDM 的问题："this method may be unsuitable for pre-training as it only learns representations that capture the agent"（§3.1，p.4）
> - 推广到真实场景的担忧："the model may focus on cloud patterns that are easily predictable, rather than trying to learn the traffic participants' behavior."（§4，p.4）
> - 可能的解法："adding hierarchy to the architecture (see HJEPA in [20]) or by changing the objective to impose an additional constraint that prevents the representations from being constant across time."（§4，p.4–5）

## 一句话总结

一篇 4 页的早期分析：用 VICReg 或 SimCLR（InfoNCE）防坍塌、带 GRU 前向模型的**动作条件 JEPA**，在"移动的点 + 背景干扰"玩具数据上和像素重建、逆动力学（IDM）比较。干扰**每帧都变**时 JEPA 能忽略它，表现与重建相当甚至更好、而且不用重调超参；但干扰**在一个序列里固定不变**（每个序列重新采样）时，JEPA 只编码背景、丢掉点的位置——因为"直接复制静态噪声 + 预测器取恒等"能让 VICReg 损失精确为零、也是 InfoNCE 的最优解。作者把这叫 JEPA **偏好慢特征**。

## 要解决什么问题

- 当时的世界模型多用像素重建（Dreamer、PlaNet 一类），有"小物体消失"的问题；LeCun 2022 提出的 JEPA 是不重建的替代方案，但还没人系统检查它在**有干扰**时学到了什么。
- 设定：完全离线、没有奖励，只有观测-动作序列；目标是学一个编码器 g_φ 和前向模型 f_θ(s_t, a_t) → s̃_{t+1}，让表示尽可能包含环境和动力学的信息。
- 想回答：JEPA 能否像宣称的那样忽略不可预测的噪声？有没有它特有的失败方式？

## 方法

### 被比较的方法（§2，附录 A.3）

| 方法 | 训练信号 |
|---|---|
| JEPA + VICReg | 前向模型输出 s̃_t 与编码器输出 s_t 的 L2 预测损失 + **每个时间步分别**算的方差 / 协方差损失 |
| JEPA + SimCLR | 同一时间步的预测与编码作为正样本对，InfoNCE（双向） |
| 重建 | 对称的卷积解码器，从 s̃_t 重建 o_t（L2），不用潜变量 |
| IDM | 前向预测损失 + 线性层从 (s_t, s_{t+1}) 预测动作 a_t |
| Supervised | 探针误差端到端回传，作为误差下界 |
| Random / Center | 随机初始化网络 / 永远预测正中心，作为上界参照 |

- 共同点：前向模型从第一帧编码出发**自回归展开 16 步**，梯度穿过时间；**不用图像增强**。
- 架构（附录 A.7）：编码器 3 层卷积（BN + ReLU）+ 平均池化 + 线性层到 512 维；前向模型是单层 GRU（隐藏 512，输入为 2 维动作，隐状态用 g_φ(o_1) 初始化）。
- 评估：冻结编码器和前向模型，训一个线性探针从展开的表示 s̃_1…s̃_17 回归点的位置，报告 17 步平均 RMSE（附录 A.4）——**探测的是预测器输出**，不只是编码器输出。

### 平凡解的论证（§2.1）

若背景噪声在序列内不变且服从 N(0, σ²I)，令编码器直接复制噪声 g_φ(o_t) = s、前向模型为恒等：
- 预测损失 = 0（相邻时刻表示相同）；
- 方差损失 = 0（σ 足够大时各维方差超过阈值 γ）；
- 协方差损失 = 0（不同序列的噪声独立）。

VICReg 总损失为 0，所以这是一个全局最优解；对 InfoNCE，按 Wang & Isola 的定理，正样本完全对齐 + 输出在球面上均匀时损失在无穷负样本极限下最小，这个解同样满足。也就是说，**目标函数本身没有理由去编码那个点**。

### 数据（§3，附录 A.2）

- 28×28 图像，单个点在单位正方形内移动，高斯模糊 σ=0.05；动作是坐标增量，‖a‖ ≤ 0.14，方向由 von Mises 分布采样（避免原地不动）；每个序列 17 帧（16 个动作）。
- 干扰：uniform（逐像素均匀噪声）或 structured（叠加 CIFAR-10 图像），亮度系数 α ∈ [0, 3]（相对点的最亮像素）；时间上 **changing**（每帧重采样）或 **fixed**（序列内不变、序列间重采样）。
- 规模：预训练 100 万序列、探针训练 30 万、评估 1 万。每种噪声类型和强度各跑 100 组随机超参，最优者跑 3 个种子（附录 A.9）。

## 实验与关键数字

### 1. 单点 + 干扰（图 3，主结果只有曲线图，没有数值表）

| 设置 | 结果（按图 3 和 §3.1 文字） |
|---|---|
| 无干扰 | 所有方法都好 |
| 每帧变化的噪声（uniform / structured） | 所有方法都好；JEPA 不重调超参也能适应更强的噪声 |
| 固定噪声（uniform / structured） | **VICReg、SimCLR 失败**（RMSE 接近 Random / Center 基线）；重建在 α ≤ 1.5 时都好；IDM 全部设置都好 |

- 不逐噪声调参时（附录图 5，超参按无噪声设置选定）：VICReg / SimCLR 在更低的固定噪声强度就失败；而重建在**变化的 uniform 噪声**下不调参会明显变差——这是 JEPA 的优势所在。
- 用一个额外的**静止点**代替背景噪声，也观察到同样的掉点（附录 A.6.2）。

### 2. 三点数据集（附录 A.6，表 1，17 步 RMSE，3 个种子）

三个通道各放一个点：受动作控制的点、动作未知的随机游走点、整段静止的点（序列间位置不同）。理想表示应包含受控点和静止点、忽略随机点。

| 方法 | 平均 | 受控点 ↓ | 随机点 | 静止点 ↓ |
|---|---|---|---|---|
| VICReg | 0.229±0.031 | 0.277±0.041 | 0.273±0.044 | 0.066±0.026 |
| SimCLR | 0.158±0.001 | 0.193±0.001 | 0.193±0.002 | 0.025±0.001 |
| IDM | 0.234±0.001 | **0.035±0.000** | 0.298±0.002 | 0.272±0.000 |
| Reconstruction | 0.107±0.000 | 0.021±0.001 | 0.182±0.000 | 0.026±0.002 |
| Supervised | 0.104±0.000 | 0.010±0.001 | 0.180±0.001 | 0.005±0.000 |
| Random | 0.260±0.001 | 0.235±0.002 | 0.278±0.002 | 0.265±0.004 |
| Center | 0.299±0.000 | 0.304±0.000 | 0.304±0.000 | 0.289±0.000 |

- VICReg / SimCLR 只抓住**静止点**（最慢的特征），受控点的误差接近 Random 基线。
- IDM 只抓住**受控点**（只有它和动作有关），静止点完全丢失——所以 IDM 不适合做通用预训练。
- 重建两者都抓住，最接近 Supervised。
- "平均"一列看起来是三个点 RMSE 的均方根而不是算术平均（例如 VICReg：√((0.277²+0.273²+0.066²)/3) ≈ 0.228），论文没说明，需核对。

## 局限 / 存疑

> 附录 A.8 是作者自己写的局限（前两条）；其余是 Claude 的推断，请核对。

- **作者承认**：只用了简单玩具数据，不清楚在复杂视频和更大模型上是否成立；只测了 VICReg 和 SimCLR 两种 JEPA 目标（没测 BYOL / EMA 一类）。
- **主结果没有数值表**，只有曲线图（图 3、图 5），定量比较要读图。
- **"慢特征"这个解释偏直觉**：平凡解证明了失败解是全局最优之一，但没说明训练为什么一定会落到它（而不是同样零损失、同时编码点的解）。事实上同时编码噪声和点也能让 VICReg 损失为零，论文的论证更像是"目标函数没有理由偏好点"，真正的选择机制（例如静态特征更容易学）没有分析。
- 设置有利于暴露这个问题：表示 512 维、编码器很小、噪声亮度可以远超点；固定噪声每个序列重新采样，所以跨序列方差很大，正好满足 VICReg 的方差项。
- 防坍塌只覆盖分布正则 / 对比两类；EMA + stop-gradient 的 JEPA（后来的 I-JEPA、V-JEPA）是否也有同样问题，本文没有回答。
- 平均 RMSE 把"本该被忽略的随机点"的误差也算进去了，用"平均"一列排名会奖励编码随机点的方法。

## 与其他论文的关系

- **问题的后续**：[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 讨论的是几乎反过来的现象——无 SG 的 SVReg 会**丢掉**慢变、难预测的物体（静止方块），而 SG 版本倾向于保住它们；并用"慢通道"有意偏好慢因子。两篇放在一起看，"慢特征"在 JEPA 里既可能是陷阱也可能是需要保护的内容，取决于目标函数和数据。
- **同作者的 PLDM**：第一作者 Vlad Sobal 后来的 [[topics/notes/JEPA系列/1-03_PLDM|PLDM]]（Sobal et al. 2025，V-JEPA 2 把它列为最接近的工作之一）延续了"VICReg 式 JEPA 世界模型 + 离线无奖励数据"的路线；Content–Geometry Tradeoff 提到 PLDM 对整个潜向量加慢度项。本文结论里的"加一个约束防止表示在时间上恒定"正是这类方向的伏笔。
- **JEPA 奠基**：本文早于 [[topics/notes/JEPA系列/2-01_I-JEPA|I-JEPA]]（2023-01），是 LeCun 2022 JEPA 框架在世界模型上最早的实验检查之一；[[topics/notes/JEPA系列/2-02_V-JEPA|V-JEPA]] 的相关工作也把慢特征（SFA）作为一条前史，并说自己"超越了时间不变性"。
- **干扰鲁棒性**：[[topics/notes/JEPA系列/1-12_VJEPA|VJEPA]] 的"Noisy TV"实验结论（JEPA 对高方差干扰鲁棒）与本文"变化噪声下 JEPA 鲁棒"一致，但 VJEPA 的干扰是 AR(1) 粘滞随机游走，并没有测本文这种序列内完全静止的干扰。
- **防坍塌正则**：VICReg 是后来 SIGReg / [[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]] 一类分布正则的前身；本文显示逐时间步的方差 / 协方差项对"跨序列变、序列内不变"的特征毫无约束力。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Many common methods for learning a world model for pixel-based environments use generative architectures trained with pixel-level reconstruction objectives. Recently proposed Joint Embedding Predictive Architectures (JEPA) [20] offer a reconstruction-free alternative. In this work, we analyze performance of JEPA trained with VICReg and SimCLR objectives in the fully offline setting without access to rewards, and compare the results to the performance of the generative architecture. We test the methods in a simple environment with a moving dot with various background distractors, and probe learned representations for the dot's location. We find that JEPA methods perform on par or better than reconstruction when distractor noise changes every time step, but fail when the noise is fixed. Furthermore, we provide a theoretical explanation for the poor performance of JEPA-based methods with fixed noise, highlighting an important limitation.
