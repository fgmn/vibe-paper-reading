---
id: "1-12"
org: 专题·JEPA系列
short: "VJEPA"
title: "VJEPA: Variational Joint Embedding Predictive Architectures as Probabilistic World Models"
aliases: ["VJEPA", "Variational JEPA", "BJEPA", "Bayesian JEPA"]
date: 2026-01-20
category: "JEPA 世界模型与规划"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "University of Aberdeen（据作者邮箱 abdn.ac.uk 推断）"
partners: []
authors: ["Yongchao Huang"]
arxiv: "2601.14354"
pdf: "[[topics/papers/JEPA系列/1-12_2601.14354_VJEPA.pdf]]"
code: "https://github.com/YongchaoHuang/VJEPA"
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "probabilistic", "variational-inference", "bayesian-filtering", "latent-planning", "theory"]
---

# VJEPA: Variational Joint Embedding Predictive Architectures as Probabilistic World Models

> [!info] 论文信息
> arXiv [2601.14354](https://arxiv.org/abs/2601.14354) · v1 2026-01-20 · 77 页（正文约 46 页 + 附录 A–J）
> PDF：[[topics/papers/JEPA系列/1-12_2601.14354_VJEPA.pdf|本地 PDF]]
> 作者：Yongchao Huang（单作者；PDF 只给了邮箱 yongchao.huang@abdn.ac.uk，机构按邮箱推断为 University of Aberdeen）
> 代码：[GitHub](https://github.com/YongchaoHuang/VJEPA)（附录 J.6）
> 专题：[[topics/JEPA系列#一、JEPA 世界模型与规划|JEPA系列 · 一]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录 J 的实验细节和完整结果表）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 出发点："existing formulations rely on deterministic regression objectives, which mask probabilistic semantics and limit its applicability in stochastic control."（Abstract，p.1）
> - MSE 等价于固定方差高斯："minimizing L_JEPA is equivalent to maximizing the log-likelihood of Z_T under an isotropic Gaussian distribution centered at Ẑ_T with fixed variance"（§3，p.10）
> - 目标函数："A simple and effective objective is the regularized negative log-likelihood"（§4.3，式 11，p.12）
> - 坍塌与全局最优不相容："collapse is not merely discouraged but is fundamentally incompatible with global optimality of the VJEPA objective (Eq. (11)) under target diversity."（Remark 1，p.16）
> - 只有按时间索引才构成动力系统："it induces a latent dynamical system only when contexts and targets are explicitly indexed by time and predictions are reused across steps."（Table 2 说明，p.17）
> - VJEPA 本身不保证充分性："VJEPA does not, by itself, guarantee the predictive sufficiency property in Definition 2 without additional realizability and optimization assumptions."（§6.3，p.23）
> - BJEPA 的修正来自意图而非观测："In BJEPA, the correction comes from the intention or constraint η_{t+1} via p_prior."（§8.4，p.37）
> - 生成式基线崩掉："At scale σ = 8.0, VAE test signal recovery drops to R² ≈ 0.50 while its noise recovery remains high (R² = 0.62)"（§9.3，p.41）
> - 确定性 JEPA 反而精度最高："Deterministic JEPA achieved the highest accuracy (R² = 0.93), though it exhibited momentary instability at scale 3.0 (R² = 0.841)."（§9.3，p.41）
> - 作者承认的局限："the probabilistic VJEPA sometimes slightly underperformed the deterministic JEPA in peak accuracy, or required more careful hyperparameter tuning."（§10.4，p.45）

## 一句话总结

一篇以理论为主的单作者论文：把确定性 JEPA 的 MSE 损失读成"固定方差的高斯似然"，推广成**预测潜变量分布**的 **VJEPA**（负对数似然 + 对目标编码器分布的 KL 正则），并证明它在目标多样时全局最优不坍塌、按时间索引时构成潜空间状态空间模型、在预测充分的前提下潜状态足以做最优控制；再提出 **BJEPA**，把预测分布拆成"学到的动力学专家 × 可替换的先验专家"（Product of Experts），用来注入目标或物理约束。实验只有一个 4 维线性"Noisy TV"玩具系统：VAE / 像素 AR 在大干扰下信号 R² 掉到 0.50 / 0.58，JEPA 一族保持在 0.84 以上——但确定性 JEPA（0.93）比 VJEPA（0.87）、BJEPA（0.84）还高。

## 要解决什么问题

- I-JEPA、V-JEPA、以及 V-JEPA 2-AC、JEPA-WM 这类 JEPA 世界模型都是**确定性预测器 + 回归损失**。作者认为这带来三个没被形式化的问题：
  - 预测的**概率语义**不清楚：MSE 下预测器收敛到条件均值，分叉场景（"左转或右转"）里均值可能是无效状态（"撞墙"）。
  - 没有**未来潜状态的不确定性**，没法做信念传播、分布式规划。
  - JEPA 世界模型默认"潜状态足以规划"（predictive sufficiency），但没说什么时候成立。
- 另一个想回答的问题：给 JEPA 加时间结构，是否就得回到**自回归的观测似然**（像 Dreamer / PlaNet 那样重建像素）？作者的答案是不需要。

## 方法

### VJEPA 目标（§4，式 11）

| | JEPA | VJEPA |
|---|---|---|
| 预测 | 点估计 Ẑ_T = g_ϕ(Z_C, ξ_T) | 分布 p_ϕ(Z_T \| Z_C, ξ_T) |
| 目标编码器 | EMA，输出确定向量 | EMA，输出分布 q_θ′(Z_T \| x_T)（如对角高斯） |
| 损失 | MSE | E_{Z_T∼q_θ′}[−log p_ϕ(Z_T \| Z_C, ξ_T)] + β·KL(q_θ′(Z_T \| x_T) ‖ N(0, I)) |
| 防坍塌 | 结构上（EMA、非对称） | 目标函数层面（作者的说法） |

- ξ_T 是目标的结构信息（空间位置、时间索引、掩码模式）。
- q_θ′ 取 Dirac、p_ϕ 取固定方差高斯时退化回原 JEPA（附录 A）。
- 训练时从 q_θ′ 采一个样本（K=1，重参数化）当回归目标；推理/规划时从 p_ϕ 采 M≫1 个样本估计不确定性。附录 J.2.2 解释了为什么必须采样目标：直接用目标均值时预测方差会塌到 0。
- 实现细节（BJEPA 里写明）：目标编码器的均值走 EMA，方差参数直接靠 KL 项梯度学。

### 理论结果

| 结果 | 内容 | 位置 |
|---|---|---|
| 定理 1（不坍塌） | 若不同目标输入的 q_θ′ 不同（目标多样），且预测器族能区分不同上下文，则式 11 的**全局最优**不可能是常数编码器。证明：坍塌时预测器只能输出无条件分布，多付出 I_q(Z_T; X_T \| ξ_T) > 0 的损失 | §4.7，附录 F |
| 时间索引 = 潜空间状态空间模型 | 取 x_C = x_≤t、x_T = x_{t+Δ}，VJEPA 就是转移核 p_ϕ(Z_{t+Δ} \| Z_t)，可做信念传播（式 12）；I-JEPA 和 clip 级 V-JEPA 都不构成可组合的动力系统（表 2） | §5 |
| 定理 2（控制充分性） | 若 Z_t 对所有规划视野是"控制预测充分"的，则存在只依赖 Z_t 的最优策略。标准 POMDP 信息状态论证 | §6.3 |
| 定理 3（均值/MAP 规划最优） | 高斯预测、协方差与动作无关、代价对下一潜状态是二次的，则对期望代价最优的动作 = 对预测均值最优的动作；多步版本见推论 | §6.7，附录 G |
| 定理 4（互信息下界） | I(Z_t; Z_{t+Δ}) ≥ E[log p_ϕ(Z_{t+Δ} \| Z_t)] + H(Z_{t+Δ})（Barber–Agakov 界） | §7.1 |
| 命题 1（对干扰不变） | x = S + N，N 与未来无关时，重建目标必须编码 N，VJEPA 允许丢掉 N 的最小充分统计量 | §7.2，附录 H |

- 规划算法：VJEPA-MPC（算法 2），随机采样动作序列 + 从 p_ϕ 采样滚动 + 选累计代价最小者，执行第一步。
- 作者自己的说明：VJEPA 训练**本身不保证**定理 2 的充分性，需要额外的可实现性和优化假设（§6.3）。

### BJEPA（§8）

- 预测分布拆成 PoE：p(Z_{t+1} \| Z_t, η) ∝ p_like(Z_{t+1} \| Z_t) × p_prior(Z_{t+1} \| η)。p_like 学"世界怎么演化"，p_prior 编码"想要什么"（目标、约束、物理规律），η 是任务信息。
- 训练目标（式 33）= VJEPA 两项 + γ·KL(p_like ‖ p_struct)。刻意只对 p_like 做最大似然，不对融合后的后验做——否则模型会"假装数据满足约束"。
- 序列版本类似贝叶斯滤波：预测步来自动力学专家，"修正"步来自先验专家（相当于以"目标达成"为证据做滤波，§8.4）。定理 5：两个专家都是高斯且与动作无关时，对后验 MAP 规划即最优。
- 卖点：换先验专家即可零样本换任务，不用重训动力学（这一点没有实验）。

## 实验与关键数字

### 设置：线性"Noisy TV"系统（§9，附录 J）

- 观测 x_t = C s_t + D(σ d_t) + ε_t，D_x = 20。信号 s_t（4 维）做随机正交旋转 + N(0, 0.1²) 噪声；干扰 d_t 是 d_{t+1} = 0.9 d_t + v_t 的"粘滞"随机游走，乘以 σ ∈ [0, 8]（9 档）。σ=8 时 SNR −2.2 dB。
- 五个模型全是**线性、无 bias**，潜维度 D_z = D_s = 4（迫使信号和干扰抢位置）：VAE（重建当前帧）、像素 AR（预测下一帧像素）、JEPA、VJEPA、BJEPA。
- **注意：这里的"JEPA"基线用的是 VICReg 损失**（不变 25 / 方差 25 / 协方差 1）+ EMA 目标编码器，不是纯 EMA 的 JEPA。VJEPA β=0.01，BJEPA γ=0.1、静态但可学的高斯先验。
- 训练轨迹 6000 步、测试 2000 步；Adam lr 1e-3，全批量 6000 步；**单一随机种子 111**；Colab CPU，每个模型 6–24 秒。
- 评估：线性探针（最小二乘）读出真实信号的测试 R²。VAE 对齐 s_t，其余预测式模型用预测器输出对齐 s_{t+1}；同时报告读出干扰的 R²（越低越好）。

### 结果（表 4 / 附录表 7，测试集 R²）

| σ（SNR） | 模型 | 信号 R² ↑ | 干扰 R² ↓ |
|---|---|---|---|
| 0（无干扰） | VAE / AR | 1.000 / 0.999 | — |
| | JEPA / VJEPA / BJEPA | 0.930 / 0.999 / 0.981 | — |
| 3.0（6.3 dB） | VAE / AR | 0.770 / 0.801 | 0.393 / 0.256 |
| | JEPA / VJEPA / BJEPA | 0.841 / 0.930 / 0.919 | −0.003 / 0.176 / 0.078 |
| 4.0（3.8 dB） | VAE / AR | 0.730 / 0.756 | 0.458 / 0.338 |
| | JEPA / VJEPA / BJEPA | 0.999 / 0.993 / 0.899 | −0.010 / −0.007 / 0.156 |
| 8.0（−2.2 dB） | VAE / AR | 0.499 / 0.578 | 0.620 / 0.449 |
| | JEPA / VJEPA / BJEPA | **0.930** / 0.870 / 0.841 | 0.183 / 0.251 / 0.238 |

- 生成式基线随 σ 近似线性下降，且读出干扰的 R² 越来越高——印证"重建 ≈ 非线性 PCA，优先编码方差大的方向"；JEPA 一族作者解释为"非线性 CCA / 预测信息瓶颈"（§10.2）。
- **σ=8 时确定性 JEPA 的信号 R² 最高**（0.930 vs VJEPA 0.870、BJEPA 0.841），概率版本并没有更准。作者的论据是稳定性：JEPA 在 σ=3 掉到 0.841；脚注 29 说其他种子里 JEPA 偶尔在中间噪声档坍塌到 R² < 0.5，而 VJEPA / BJEPA 跨种子更稳——但这些多种子结果**没有给出表格**。
- 定性：图 4 里 σ=8 时 VAE / AR 的重建跟着高频干扰走，VJEPA / BJEPA 跟住真实信号。

## 局限 / 存疑

> 前两条是论文 §10.4 自己写的，其余是 Claude 的推断，请核对。

- **作者承认**：Gaussian 单峰假设下 VJEPA 有时峰值精度不如确定性 JEPA、调参更难，多峰分叉会被平均掉；β、γ 的平衡很敏感（太强坍塌、太弱方差不校准）。
- **实验和主张之间差距很大**：标题和摘要讲"概率世界模型 / 不确定性感知规划 / BJEPA 零样本迁移"，但唯一的实验是 4 维线性玩具系统上的线性探针，**没有任何规划、控制、MPC、迁移、不确定性校准（如可信区间覆盖率）的实验**，也没有图像或视频。
- **单种子**（seed 111），多种子稳定性只在脚注里口头描述。
- **关键结论没被实验支持**：σ=8 时最强的是确定性 JEPA；"概率版本更稳"缺数据。
- **数字自相矛盾 / 奇怪，需核对**：
  - §9.3 说 JEPA 一族在 σ=8 "R² > 0.84"，附录 J.4 写成 "R² > 0.85"，但 BJEPA 测试 R² 是 0.841，后者不成立。
  - 确定性 JEPA 在 σ=0（无干扰）时只有 0.930，σ=4、6 时反而 0.999；而且 0.947 / 0.930 这一对数字在 JEPA 的 7 个噪声档、VJEPA 的 2 个噪声档里原样重复出现，像是某个固定的次优解（例如只恢复部分信号方向），论文没解释。
- **基线不纯**：对比用的"JEPA"带 VICReg 方差/协方差正则，所以"JEPA 对干扰鲁棒"有多少来自 VICReg、多少来自潜空间预测本身，分不开。
- **理论多为标准结果的重述**：定理 2 是 POMDP 信息状态论证，定理 3 是二次代价下的确定性等价，定理 4 是 Barber–Agakov 界；定理 1 只讲全局最优，不涉及训练动力学里是否真会避开坍塌（而 JEPA 坍塌恰恰是优化过程的问题）。§10.4 也承认正则太强会坍塌。
- 命题 1 假设干扰 N 与未来无关，但实验里的干扰 d_t 是**可预测的**（AR(1)，系数 0.9）——这正是 AR 基线必须追踪它的原因；按定理 4 的 MI 论证，可预测的干扰也会提供 I(Z_t; Z_{t+1})，为什么 JEPA 一族能丢掉它，论文的解释（"静态先验惩罚漂移"）只覆盖 BJEPA。

## 与其他论文的关系

- **被推广的对象**：[[topics/notes/JEPA系列/2-01_I-JEPA|I-JEPA]]、[[topics/notes/JEPA系列/2-02_V-JEPA|V-JEPA]] 的确定性 MSE + EMA 目标；作者把 clip 级 V-JEPA 归为"学到时空相关但不构成可组合动力系统"（表 2）。
- **JEPA 世界模型**：动机直接来自 [[topics/notes/JEPA系列/2-03_V-JEPA2|V-JEPA 2]]（V-JEPA 2-AC 零样本机器人规划）、JEPA-WM（Terver et al.，即 [[topics/notes/JEPA系列/1-06_WhatDrivesSuccess|What Drives Success]] 一线）、价值引导 JEPA 规划（Destrade et al.）——作者认为它们都是确定性的、隐含假设了预测充分性。和 [[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]]、[[topics/notes/JEPA系列/1-03_PLDM|PLDM]]、[[topics/notes/JEPA系列/1-05_LeWM|LeWM]] 相比，本文没有在视觉控制任务上验证。
- **防坍塌**：本文说 VJEPA 靠目标函数防坍塌，但实验里的 JEPA 基线用的是 VICReg；与 [[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]]、[[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]] 的正则化路线是不同的切入点（后者关心潜空间分布 / 几何，本文关心预测分布）。
- **线性玩具系统**：和 Content–Geometry Tradeoff 的"带噪线性旋转"单元测试很像（都是正交旋转信号 + 噪声 + 线性编码器），但那篇比较的是 SG vs 无 SG，本文比较的是重建 vs 潜空间预测。
- **经典框架**：PSR（把 VJEPA 看成神经化、摊销的 PSR）、PlaNet / Dreamer（有观测似然的概率潜动力学）、Active Inference、预测信息瓶颈；附录 C–E 分别和 HMM、Kalman 滤波、粒子滤波做了类比。
- 同在本专题"JEPA 理论"一侧的还有 [[topics/notes/JEPA系列/3-01_KoopmanJEPA|Koopman JEPA]]、[[topics/notes/JEPA系列/3-02_WhenLeJEPAWorldModel|When LeJEPA World Model]]、[[topics/notes/JEPA系列/3-03_BeyondGaussianWorlds|Beyond Gaussian Worlds]]；从标题看，最后一篇可能和本文的"单峰高斯"局限有关（未核对其内容）。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Joint Embedding Predictive Architectures (JEPA) offer a scalable paradigm for self-supervised learning by predicting latent representations rather than reconstructing high-entropy observations. However, existing formulations rely on deterministic regression objectives, which mask probabilistic semantics and limit its applicability in stochastic control. In this work, we introduce Variational JEPA (VJEPA), a probabilistic generalization that learns a predictive distribution over future latent states via a variational objective. We show that VJEPA unifies representation learning with Predictive State Representations (PSRs) and Bayesian filtering, establishing that sequential modeling does not require autoregressive observation likelihoods. Theoretically, we prove that VJEPA representations can serve as sufficient information states for optimal control without pixel reconstruction, while providing formal guarantees for collapse avoidance. We further propose Bayesian JEPA (BJEPA), an extension that factorizes the predictive belief into a learned dynamics expert and a modular prior expert, enabling zero-shot task transfer and constraint (e.g. goal, physics) satisfaction via a Product of Experts. Empirically, through a noisy environment experiment, we demonstrate that VJEPA and BJEPA successfully filter out high-variance nuisance distractors that cause representation collapse in generative baselines. By enabling principled uncertainty estimation (e.g. constructing credible intervals via sampling) while remaining likelihood-free regarding observations, VJEPA provides a foundational frame-work for scalable, robust, uncertainty-aware planning in high-dimensional, noisy environments.
