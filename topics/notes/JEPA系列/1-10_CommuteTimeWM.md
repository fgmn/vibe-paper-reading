---
id: "1-10"
org: 专题·JEPA系列
short: "CommuteTimeWM（CTWM）"
title: "Learning Commute-Time-Preserving World Models for Planning"
aliases: ["CTWM", "Commute-Time-Preserving World Models", "CommuteTimeWM"]
date: 2026-10-01
category: "JEPA 世界模型与规划"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "Friedrich Miescher Institute for Biomedical Research (FMI)；University of Basel"
partners: []
authors: ["Michael Hauri", "Peter Buttaroni", "Fabian A. Mikulasch", "Friedemann Zenke"]
arxiv: "2610.01373"
pdf: "[[topics/papers/JEPA系列/1-10_2610.01373_CommuteTimeWM.pdf]]"
code: "https://github.com/fmi-basel/commute-time-preserving-world-models"
project: "https://CTWM-website.github.io"
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "laplacian-representation", "commute-time", "log-det", "latent-planning"]
---

# Learning Commute-Time-Preserving World Models for Planning

> [!info] 论文信息
> arXiv [2610.01373](https://arxiv.org/abs/2610.01373) · v1 2026-10-01 · 21 页（正文 10 页 + 附录 A–F）
> [项目页](https://CTWM-website.github.io) · [代码](https://github.com/fmi-basel/commute-time-preserving-world-models)
> PDF：[[topics/papers/JEPA系列/1-10_2610.01373_CommuteTimeWM.pdf|本地 PDF]]
> 作者：Michael Hauri\*、Peter Buttaroni\*、Fabian A. Mikulasch、Friedemann Zenke（Friedrich Miescher Institute for Biomedical Research，Basel；Hauri、Buttaroni、Zenke 同属 University of Basel 理学院）。\* 共同一作
> 专题：[[topics/JEPA系列#一、JEPA 世界模型与规划|JEPA系列 · 一]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录 A–F）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 动机："planning can benefit from latent representations whose distances mirror commute-times in the environment."（Abstract，p.1）
> - 现有方法的问题："existing methods, which commonly encourage isotropic representations to prevent representational collapse, tend to degrade the "correct" eigenvalue-dependent scaling"（Abstract，p.1）
> - 防坍塌不等于好几何："collapse-avoidance alone does not naturally lead to representational geometries that are also useful for planning"（§1，p.1–2）
> - 缩放拉普拉斯表征是各向异性的："Crucially, the scaled Laplacian representation is anisotropic for most environments with non-degenerate eigenvalues."（§3.1，p.4）
> - β 项的作用："By penalizing large predictor outputs, β > 0 forces the encoder to keep consecutive latent states close together"（§3.3，p.4–5）
> - 为什么用 log-det："we use log-det regularization, which instead constrains the product of the eigenvalues."（§3.4，p.5）
> - 区别在缩放："what distinguishes the log-det from the two other regularizers is the eigenvalue-dependent scaling λ_k^{−1/2}, which carries the metric information relevant for planning."（§3.5，p.6）
> - 只靠残差预测不够："Thus residual prediction alone is not sufficient for good subspace alignment."（§4，p.7）
> - 环面上的上限："This degeneracy puts an inherent ceiling on the subspace similarity metric at ≈0.91"（§4，p.8）
> - 远目标时优势更大："These results suggest that the benefits of a commute-time-preserving geometry become more pronounced as the goal moves further away."（§4.1.1，p.9）

## 一句话总结

用目标距离做 CEM 规划时，最理想的潜空间是"欧氏距离 = 环境里的 commute time（随机游走来回的期望步数）"，经典答案是图拉普拉斯特征向量乘上 λ_k^{−1/2} 的**缩放拉普拉斯表征**——它是各向异性的，而 SIGReg / VICReg / 正交约束都推向各向同性，把这个缩放抹掉了。CTWM 换两样东西：预测器预测**潜位移** Δ = φ(s′) − φ(s) 并惩罚位移大小（β‖T‖²，相当于慢度项），防坍塌用协方差的 **log-det**（只约束特征值乘积）。定理：确定性动力学、预测器在不动点时，最优编码器恰好是缩放拉普拉斯表征，潜距离平方 ∝ 截断 commute time。实验：MNIST 环面图上潜距离对 commute time 的 R² 0.95（VICReg 0.84）；六个像素输入基准上参数量减半（9M vs 18M）仍持平或超过 LeWM，Cube 89.8 vs 64.8、Pointmaze 100 vs 68.5；目标拉远到 100 步时 LeWM 在 Two-Room 掉到 17.3%，CTWM 仍有 98.3%。

## 要解决什么问题

- LeWM 证明了端到端、无重建、只靠轻量防坍塌正则的 JEPA 世界模型可行，但**防坍塌本身不保证规划友好的几何**（作者引 Wang et al. 2026、Nguyen et al. 2026）。
- 经典 RL 里有一个有原则的选择：拉普拉斯表征（转移图拉普拉斯的特征向量），按特征值缩放后欧氏距离就是 commute-time 距离——考虑了墙、门这类障碍，天然适合规划。已有学习拉普拉斯表征的方法（Wu et al. 2018、GDO、ALLO）**不学潜动力学模型**，也**不保证特征值缩放**。
- 两条线之间缺一座桥：能不能让 LeWM 式 JEPA 配方学到"正确缩放"的拉普拉斯几何？
- 和 quasimetric / TD 时间距离、successor features 不同：那些只算距离不训练世界模型，或距离依赖行为策略；commute time 只取决于环境。

## 方法

### commute time 与缩放拉普拉斯表征（§3.1，式 2–3）

C(s, s′) = vol(G) Σ_k (u_k(s) − u_k(s′))² / λ_k。定义 ψ_k(s) = λ_k^{−1/2} u_k(s)，则 C(s, s′) = vol(G)‖ψ(s) − ψ(s′)‖²，即存在一个欧氏空间让 commute time 变成平方距离；它要求随特征值变化的缩放，所以多数环境下是各向异性的。

### 残差预测 + 位移惩罚（§3.3，式 5–6）

L(φ, T) = E[‖Δ(s, s′) − T(φ(s), a)‖² + β‖T(φ(s), a)‖²] + Reg(φ)，Δ = φ(s′) − φ(s)

- β 项惩罚大的预测位移（类似 Saanum et al. 2024，也可看成慢特征目标）：没有它，足够强的预测器可以吸收任意大的位移，编码器就能把相邻状态映射得很远。
- 预测器在不动点 T* = E[Δ|s,a]/(1+β) 时，损失可写成 tr Cov(Δ|s,a)（让转移可预测）+ β/(1+β)·‖μ(s,a)‖²（把时间上相邻的状态拉近）+ Reg（防全局坍塌）。
- 不动点条件意味着 rollout 应该用 (1+β)T 而不是 T（附录 D.2）；在 PushT 上用 OLS 估计出的 β_est 与真实 β 很接近（β=0.1 → 0.108，β=1.0 → 1.04，表 3）。
- 等价的下一状态预测写法见附录 D.1。

### log-det 正则（§3.4，附录 B、C.2）

| 正则 | 收敛到的表征（作者的分析） |
|---|---|
| 硬正交约束（GDO） | 拉普拉斯子空间，但**没有**特征值缩放 |
| VCReg | 最小特征值方向缩放为常数、其余 ∝ λ_k^{−1}（启发式分析） |
| SIGReg / Barlow Twins / VICReg 等 | 显式或隐式鼓励各向同性谱，与缩放拉普拉斯不相容 |
| **log-det**（−γ/2·log|Σ|，多元高斯的熵） | 只约束特征值乘积、不设方差硬下限 → 允许 λ_k^{−1/2} 缩放 |

### 定理与推论（§3.5，附录 C.3–C.4）

CTWM 目标：L = E[‖Δ − T‖² + β‖T‖²] − (γ/2) log|Σ|，Σ = Cov(φ(s))。

- **定理 1**：确定性动力学、预测器在不动点时，损失化为 β/(1+β)·E‖φ(s′) − φ(s)‖² − (γ/2) log|Σ|，其最小值（差一个旋转和平移）是 φ*(s) = √(γ(1+β)/(4β)) · ψ(s)（PDF 里根号符号的抽取不完整，系数形式需对照原文）。
- **推论 1.1**：‖φ*(s) − φ*(s′)‖² = γ(1+β)/(4β) · C_d(s, s′)，C_d 是秩 d 截断的 commute time。
- **推论 1.2**：第 k 个特征方向方差 = γ(1+β)/(4βλ_k)，慢方向被放大、快方向被压制；比值 Var(φ_k)/Var(φ_1) = λ_1/λ_k，可以直接拿来验证。
- 特征方向（最慢的那些）与 VCReg、正交约束共享，区别**只在缩放**。
- 摘要写"在可逆确定性动力学下"可证，定理 1 正文只写了"确定性"；commute time 本身是在无向（可逆）图上定义的。
- 作者在 AI 使用声明里说附录 C.3 的证明写作用了生成式 AI 辅助，证明由作者独立推导和验证。

### 连续环境的实现（§4.1，附录 A 表 2）

- 在 LeWM 上把 SIGReg 目标换成式 7；编码器同为 ViT-Tiny（5.5M）。
- 预测器保留 6 层 deep-AdaLN，但潜维度从 192 降到 64，预测器参数从 11M 降到约 3M（表 2 写 3.3M），总参数 **9M vs LeWM 18M**。
- 去掉 weight decay（T 已被 β 项约束）；用 LayerNorm 代替 SIGReg 需要的 BatchNorm。
- 超参：224×224，历史 3，frameskip 5，AdamW lr 5e-5，批 32，10 epoch，β=0.1，γ=1.0；CEM 300 样本 / 30 轮 / 30 精英，时域 5 个块（每块 5 动作），每 5 块重规划，目标 25 步外 / 步数预算 50，评估 200 回合。所有环境同一套超参。

## 实验与关键数字

### 1. 离散环面图（§4，图 2）

- 环境：环面图，每个节点有一个随机分配的三位数字标签，观测是从对应类别随机抽取的三张 MNIST 图（每次访问重新抽）→ 图动力学确定，观测随机。
- 模型：小 CNN 编码器出 12 维嵌入，预测器为 32 单元单隐层 MLP，动作 one-hot，β=0.1；随机策略采 20,000 条转移；4 个种子。
- 对比：VICReg（非残差世界模型代表）、ALLO（拉普拉斯表征代表）、WM-GDO（保留 CTWM 的残差预测，log-det 换成图绘制正交约束）。

| 方法 | 子空间相似度（图 2b） | 方差比是否跟随 λ_1/λ_k（图 2c） | 潜距离² vs commute time R²（图 2d） |
|---|---|---|---|
| CTWM | 接近上限 ≈0.91 | 是（唯一跟随） | **0.95** |
| ALLO | 与 CTWM 相当 | — | 0.67 |
| VICReg | 明显较低 | 谱更平 | 0.84 |
| WM-GDO | 与 VICReg 相当 | 谱更平 | 0.73 |

- 子空间相似度到不了 1：环面拉普拉斯每个非平凡特征值重数 ≥4，特征基不唯一，随机旋转估出的上限约 0.91。子空间相似度只给了图，没有具体数值。
- WM-GDO 的结果说明**只靠残差预测不够**，log-det 是关键。

### 2. 六个像素输入规划基准（表 1，CEM，成功率 %，3 种子，10 epoch）

| 模型 | Reacher | Cube | Two-Room | PushT | Scene | Pointmaze |
|---|---|---|---|---|---|---|
| Random | 13.0±2.3 | 45.2±0.9 | 24.3±2.7 | 4.3±2.1 | 49.8±3.1 | 14.3±1.7 |
| LeWM | 83.3±2.1 | 64.8±1.3 | 88.8±1.6 | 91.5±1.1 | 69.3±2.6 | 68.5±1.8 |
| **CTWM** | 82.3±2.6 | **89.8±1.0** | **100.0** | 92.2±0.6 | **82.3±1.4** | **100.0** |
| Random-100 | 7.3±1.9 | 45.5±2.5 | 1.0±0.4 | 0.3±0.2 | 24.2±1.7 | 11.3±1.0 |
| LeWM-100 | 81.0±0.8 | 61.7±1.4 | 17.3±0.8 | 15.3±1.4 | 40.3±2.5 | 28.2±1.2 |
| **CTWM-100** | **98.2±0.8** | **73.0±1.2** | **98.3±0.9** | **26.5±2.6** | **57.5±1.6** | **98.8±0.2** |

- 上半：目标 25 步外、预算 50 步（LeWM 协议）；下半：目标 100 步外、预算 125 步。
- 数据：Two-Room、Reacher、PushT、Cube 用 stable-worldmodel 提供的数据；Pointmaze（OGBench medium-navigate 1000 条，转成图像）和 Scene 来自 OGBench。
- Reacher、PushT 持平；Two-Room 达到 100%（作者提到 LeWM 论文自己说过 SIGReg 在低复杂度环境里可能有害）；Cube、Scene、Pointmaze 明显更好，训练早期差距更大（图 3）。
- 远目标下差距大幅拉开：LeWM 在 Two-Room / PushT / Pointmaze 掉到 17.3 / 15.3 / 28.2，CTWM 在 Two-Room / Pointmaze / Reacher 仍有 98.3 / 98.8 / 98.2；PushT 两者都下降。

### 3. 梯度规划（附录 E 表 4，Adam，%）

| 模型 | Reacher | Cube | Two-Room | PushT | Scene | Pointmaze |
|---|---|---|---|---|---|---|
| LeWM | 73.7±2.7 | 60.2±0.5 | 93.7±2.5 | 86.5±1.2 | 66.7±2.4 | 88.3±1.2 |
| CTWM | 77.0±3.3 | 78.2±2.1 | 98.7±0.8 | 87.5±1.1 | 72.8±2.5 | 100.0 |

换成一阶优化器规划，CTWM 仍全部持平或更好。

### 4. 连续空间的 commute-time 几何（§4.1.2，图 4）

把 Pointmaze 状态空间离散成图，算从某点出发的真实 commute time，与 LeWM、CTWM 的潜 L2 距离比较：CTWM 的距离图更接近真值。前 64 个潜维度的方差：CTWM 呈推论 1.2 预测的 λ_k^{−1/2} 衰减，LeWM 谱更平（更各向同性）。只有图，没有定量指标。

## 局限 / 存疑

> 论文没有单独的"局限"一节，下面都是 Claude 的推断，请核对。

- **理论假设强**：确定性（摘要说可逆）动力学 + 预测器处于不动点；PushT、Cube 等有接触、不可逆的环境不满足可逆性，理论只能当动机。commute time 依赖于转移图上的随机游走，而真实数据的行为策略各不相同，图的"边权"实际由数据分布决定，论文没讨论这一点。
- **LeWM 基线是作者重跑的**：表 1 的 LeWM（Reacher 83.3、Cube 64.8、Two-Room 88.8、PushT 91.5）和 LeWM 论文的发表值不同（例如 SD-JEPA 笔记里引用的发表值为 86 / 74 / 87 / 96），需核对重跑设置（批 32 vs LeWM 的批 128？表 2 用绿色标出与 LeWM 的差异，但 PDF 抽取后颜色丢失，看不出哪些是改动）。
- **一些数字看起来反常，需核对**：Reacher 上 CTWM 目标 100 步外（98.2%）反而比 25 步外（82.3%）高；Cube 的随机策略就有 45%（Scene 49.8%），说明这些任务的成功判定或初始状态对随机策略较宽松，绝对值意义有限。
- **参数减半的比较混入了潜维度变化**：CTWM 用 D=64、LeWM 用 D=192，没有同维度对照，也没有"LeWM + 残差预测"或"LeWM + log-det"这类拆分消融（拆分只在离散环面上做了 WM-GDO）。
- **连续环境的几何验证只有定性图**（图 4），没有 R² 一类指标；环面上子空间相似度也只有图。
- 全部是仿真基准、小模型（9M），没有真实视频或大规模预训练；作者在结论里推测"commute time 是任何先建图再用的智能体的自然目标"，这是展望而非结果。

## 与其他论文的关系

- **直接基线**：[[topics/notes/JEPA系列/1-05_LeWM|LeWM]]——同一套编码器 / 规划协议 / 基准，只把 SIGReg 换成"残差预测 + β 位移惩罚 + log-det"。SIGReg 来自 [[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]]；本文的论点是各向同性目标与规划所需的各向异性几何冲突。
- **同一主题（防坍塌方式决定潜几何）**：[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]]（SVReg 只设方差下限、不约束形状，也学出"潜在地图"）、[[topics/notes/JEPA系列/1-09_LpWM|LpWM]]（稀疏 vs 稠密目标）、[[topics/notes/JEPA系列/3-03_BeyondGaussianWorlds|Beyond Gaussian Worlds]]；[[topics/notes/JEPA系列/1-04_TemporalStraightening|Temporal Straightening]] 也被引为"防坍塌不等于好几何"的证据。三者都在说同一件事：各向同性高斯不一定是规划的好目标。
- **慢特征 / 门控残差**：β‖T‖² 位移惩罚与 Content–Geometry Tradeoff 的门控残差预测器 + 慢通道思路相近；拉普拉斯表征本身与慢特征分析（SFA）密切相关，可对照 [[topics/notes/JEPA系列/2-04_JEPASlowFeatures|JEPA Slow Features]]。
- **其他 JEPA 世界模型**：[[topics/notes/JEPA系列/1-03_PLDM|PLDM]]（Two-Room 环境来源）、[[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]]（PushT 来源）、[[topics/notes/JEPA系列/2-03_V-JEPA2|V-JEPA 2]]。
- **拉普拉斯表征 / 时间距离**：Wu et al. 2018、GDO、ALLO；quasimetric / TD 时间距离（QRL 等）、successor features、TD-JEPA。
- 库里其他 JEPA 笔记：[[xsquare/notes/23_EgoJEPA|EgoJEPA]]。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> World models allow agents to plan in latent space by choosing a sequence of actions that most reduces the distance to a given goal state. Thus, planning can benefit from latent representations whose distances mirror commute-times in the environment. The spectral embedding space of the graph Laplacian provides such a representation, if it obeys a specific eigenvalue-dependent scaling. Unfortunately, instantiating the graph Laplacian is intractable in large, continuous environments. Self-supervised learning offers a natural route to such commute-time-preserving embeddings at scale. However, here we show that existing methods, which commonly encourage isotropic representations to prevent representational collapse, tend to degrade the "correct" eigenvalue-dependent scaling, leading to an inaccurate representation of commute times. To address this problem, we introduce Commute-Time-Preserving World Models (CTWMs), combining a latent displacement predictor and a log-determinant regularizer that prevents collapse, which provably recover the correctly scaled Laplacian representation under reversible deterministic dynamics and at the predictor's fixed point. In numerical simulations, CTWM matches or outperforms LeWM, a task-agnostic baseline, on several complex, continuous goal-reaching benchmarks, while using half the parameters.
