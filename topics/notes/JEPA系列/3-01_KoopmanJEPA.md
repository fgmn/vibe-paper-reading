---
id: "3-01"
org: 专题·JEPA系列
short: "Koopman Invariants"
title: "Koopman Invariants as Drivers of Emergent Time-Series Clustering in Joint-Embedding Predictive Architectures"
aliases: ["Koopman Invariants", "KoopmanJEPA", "Koopman Invariants as Drivers of Emergent Time-Series Clustering"]
date: 2025-11-12
category: "JEPA 理论"
venue: "AAAI 2026"
source: "arXiv"
affiliation: "KU Leuven（DTAI、ESAT-WaveCore，M-Group）；Flanders Make@KU Leuven"
partners: []
authors: ["Pablo Ruiz-Morales", "Dries Vanoost", "Davy Pissoort", "Mathias Verbeke"]
arxiv: "2511.09783"
pdf: "[[topics/papers/JEPA系列/3-01_2511.09783_KoopmanJEPA.pdf]]"
code: ""
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "theory", "koopman-operator", "time-series", "clustering", "dynamical-systems"]
---

# Koopman Invariants as Drivers of Emergent Time-Series Clustering in Joint-Embedding Predictive Architectures

> [!info] 论文信息
> arXiv [2511.09783](https://arxiv.org/abs/2511.09783) · v2 2026-01-23（v1 2025-11-12）· 11 页（正文 7 页 + 附录 A–C）
> PDF：[[topics/papers/JEPA系列/3-01_2511.09783_KoopmanJEPA.pdf|本地 PDF]]
> 作者：Pablo Ruiz-Morales、Mathias Verbeke（KU Leuven DTAI）、Dries Vanoost、Davy Pissoort（KU Leuven ESAT-WaveCore）；均属 M-Group（Bruges 校区）与 Flanders Make@KU Leuven
> 发表：PDF 首行写明是被 AAAI 2026 接收论文的预印本。论文没有给代码链接（只给了资助项目网站 dn-isense.eu）。
> 专题：[[topics/JEPA系列#三、JEPA 理论|JEPA系列 · 三]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录 A 证明、B 数据参数、C 网络结构）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 核心假设："…hypothesizing that JEPA's predictive objective implicitly drives it to learn the invariant subspace of the system's Koopman operator."（Abstract，p.1）
> - 关键归纳偏置："…demonstrating that constraining the JEPA's linear predictor to be a near-identity operator is the key inductive bias that forces the encoder to learn these invariants."（Abstract，p.1）
> - EMA 近似："Specifically, if the rate of change of the online parameters θ per training step is small relative to (1−α), then the difference ∥θ−θ_EMA∥ remains small."（§2，p.3）
> - 区制不混合："These supports {X_i} are essentially disjoint, and trajectories starting in X_i remain confined to X_i for all future times (dynamical immiscibility)."（Assumption 3.1，p.3）
> - 指示函数逐路径可预测："…functions in V are not just invariant in expectation but are also perfectly predictable on a pathwise basis with respect to the regimes…"（§3，p.3）
> - 非线性预测器的直觉："Thus, an optimal non-linear predictor would learn to approximate an identity map, g_ϕ(z_t) ≈ z_t, for these highly predictable, regime-specific representations."（§3，p.4）
> - 聚类纯度："We quantified this alignment using K-Means clustering (K = 18), which revealed a mean cluster purity of 65.48% for JEPA's embeddings."（§5，p.6）
> - 自编码器对照："…a conventional autoencoder with an identical encoder architecture fails to separate the dynamical regimes for the same data, achieving a mean cluster purity of only 38.81%."（§5，p.6）
> - M 接近单位阵："…with a relative Frobenius error (∥M−I_k∥_F/∥M∥_F) of just 2.34%."（§5，p.6）
> - 解不唯一："Our control experiments with a randomly initialized predictor M converged to the same low loss but yielded a dense, non-identity transformation, while also exhibiting clear visual clustering."（§5，p.6）
> - 局限："Our empirical validation relies on synthetic data with well-defined, immiscible regimes, which perfectly fit the finite mixture of ergodic regimes model of Assumption 3.1."（§5，p.7）

## 一句话总结

JEPA 用在时间序列上时，潜空间常会按"动力学区制"（正弦、AR、方波、趋势……）自动聚类，而同结构的自编码器不会。作者用 Koopman 算子解释：如果数据是若干**互不混合的遍历区制**的混合，那么各区制的**指示函数**是 Δ 步 Koopman 算子特征值为 1 的特征函数，而且沿轨迹完全不变，所以在理想化 JEPA 损失（EMA 目标 ≈ 在线编码器、线性预测器 g(z)=Mz）下，编码器输出落在这些指示函数张成的子空间、M 在其上为恒等时，损失达到零——同一区制的窗口被映到同一点，自然形成 r 个簇。在 18 个合成区制上：JEPA 的 K-Means 簇纯度 65.48% vs 自编码器 38.81%；单位阵初始化的线性预测器训练后与 I 的相对 Frobenius 误差仅 2.34%，随机初始化则收敛到同样低的损失、但 M 是稠密的非单位阵。

## 要解决什么问题

- 经验现象：JEPA 在时间序列上学到的嵌入会**按未标注的动力学区制自发聚类**；容量相近、但目标是重构的自编码器没有这种组织（图 3）。
- 问题：JEPA 的预测目标里到底是什么机制产生了这种"按区制聚类"？
- 作者希望给出第一性原理的解释，把现代 SSL 和动力系统理论（Koopman 算子）接起来，并借此理解 **predictor 在表示解耦中的作用**。

## 方法

### 1. 理想化 JEPA 损失（§2）

- 输入是时间窗 x_t = (s_t, …, s_{t+n−1})，来自不变测度为 μ 的平稳过程。在线编码器 f_θ、预测器 g_ϕ（预测 Δ 步后窗口的表示）、EMA 目标编码器 f_EMA（θ_EMA ← αθ_EMA + (1−α)θ）。
- 原始损失 L(θ,ϕ) = E‖g_ϕ(f_θ(x_t)) − f_EMA(x_{t+Δ})‖²（式 1）。
- **关键简化**：若在线参数每步变化相对 (1−α) 很小，则 f_EMA ≈ f_θ，损失近似为 **L(f,g) ≈ E‖g(f(x_t)) − f(x_{t+Δ})‖²**（式 2）。全文理论都基于这个式子。

### 2. Koopman 算子（Definition 2.1）

- Δ 步 Koopman 算子 K: L²(X,μ) → L²(X,μ)，(Kψ)(x) = E[ψ(x_{t+Δ}) | x_t = x]。它是线性的、是 L²(μ) 上的压缩。特征值为 1 的特征函数是"期望意义下不变"的量。

### 3. 定理与假设（§3，附录 A）

**Assumption 3.1（遍历区制的有限混合）**：不变测度 μ = Σ_{i=1}^r α_i μ_i（α_i > 0，Σα_i = 1），每个 μ_i 是支撑在 X_i 上的遍历不变测度；各 X_i 本质上不相交，且从 X_i 出发的轨迹永远留在 X_i（"动力学不混合"）。定义区制指示函数 χ_i = 1_{X_i}，V = span{χ_1, …, χ_r}。

**Lemma 3.2**（在 3.1 下）：
- (a) 每个 χ_i 是 K 的特征函数，特征值 1：Kχ_i = χ_i；
- (b) χ_i 在 Δ 步上逐路径不变：χ_i(x_{t+Δ}) = χ_i(x_t)；
- (c) 因此任意 ψ ∈ V 满足 Kψ = ψ 且 ψ(x_{t+Δ}) = ψ(x_t)；
- (d) V 恰好是 K 特征值 1 的特征空间，维数为 r（遍历分解理论的结果）。

**Assumption 3.3（线性预测器）**：g(z) = Mz，M ∈ R^{k×k}。

**损失分解（式 5）**：记 f(x) = ψ⃗(x)，
L(f,M) = E‖Mψ⃗(x) − (Kψ⃗)(x)‖²（项 1：均值预测误差）+ E‖(Kψ⃗)(x) − ψ⃗(x_{t+Δ})‖²（项 2：固有随机性误差）。损失为零当且仅当两项都为零。

**Theorem 3.4（JEPA 学到区制指示函数）**：在 3.1、3.3 下，设潜维度 k ≥ r。损失 (5) 达到全局最小当且仅当：
- (a) 编码器各分量满足 (Kf_j)(x) = f_j(x_{t+Δ})，μ-a.e.；
- (b) Mf(x) = (Kf)(x)，μ-a.e.。

当 f 的各分量属于 V、且 M 在 f(X) 张成的子空间上为恒等时，这两条同时满足。特别地，若 f\*(x) = (χ_1(x), …, χ_r(x), 0_{k−r})ᵀ，则任意"在 f\* 非零分量张成子空间上为恒等、其余为零"的 M\* 都使 L(f\*, M\*) 最小（=0）。

- **"仅当"方向依赖额外假设**：附录 A 写明，从零损失推出 f_j ∈ V 时，**额外假设** M 在学到的表示上作用为恒等（"simplest predictor"）；由 (b) 得 f_j = Kf_j，再由 (a) 得 f_j(x_t) = f_j(x_{t+Δ}) a.s.，按遍历理论 f_j 在每个 X_i 上为常数，即 f_j ∈ V。不加这个假设，M 可以是任意满足 Mf = Kf 的矩阵。

**聚类推论**：若 f(x) = Aχ⃗(x)（A 为秩 r 的 k×r 矩阵），窗口属于 X_i 时 χ⃗(x) = e_i，所以 f(x) = A 的第 i 列——同一区制的所有窗口落在同一点，r 个区制对应 r 个不同的点 → r 个簇。

**非线性预测器（直觉，非定理）**：足够强的非线性预测器逼近 E[f(x_{t+Δ}) | f(x_t)]；若 f ∈ V 则 z_{t+Δ} = z_t，最优预测器近似恒等映射。

### 4. 实验设计（§4，附录 B、C）

- **合成数据**：r = 18 个区制（不同频率/幅度/谐波的正弦、方波、锯齿波、正负 AR、MA、ARMA、上升/下降趋势、稀疏脉冲、正弦+趋势、高噪声正弦）。每个主序列长 1024；确定性成分的观测噪声设为 0，ARMA 只含自身过程噪声；逐序列标准化。
- 每个主序列只取一对：上下文窗 = 前 768 步，目标窗 = 平移 Δ = 256 后的 768 步（两窗大量重叠；作者说不重叠时 Δ ≥ n_c 结果也令人满意）。每区制 10,000 条，共 180,000 对，按 70/20/10 划分。
- **模型**：编码器为 4 层 1D CNN（16→32→64→128 通道，stride 2）+ 线性投影，潜维度 k = 32（≥ r）。预测器两种：无偏置线性 M（主实验用**单位阵初始化**，对照实验用随机初始化），以及 MLP（隐藏维 2k）。EMA 衰减 α = 0.996。

## 实验与关键数字

论文没有编号的结果表，数字都在 §5 正文和图 4–5 里。全部是测试集结果。

| 量 | 数值 | 说明 |
|---|---|---|
| K-Means（K=18）平均簇纯度，JEPA（MLP 预测器） | **65.48%** | 图 3 左，t-SNE 上能看到按区制成簇 |
| 同结构自编码器 | 38.81% | 图 3 右，区制混在一起 |
| 线性 M（单位阵初始化）的 ‖M − I_k‖_F / ‖M‖_F | **2.34%** | 训练后仍接近恒等 |
| ‖M − Mᵀ‖_F / ‖M‖_F（反对称部分） | 2.06% | 接近对称 |
| M 的特征值模长 | 图 4：全部 32 个在约 0.97–1.02 之间 | 正文说"由 r 个接近 1 的特征值主导" |
| 18 个簇中心 c_i 的 ‖Mc_i − c_i‖ / ‖c_i‖ | 平均 **0.80%** | 图 5，各簇都在 1.2% 以下 |
| 线性 M（随机初始化） | 收敛到同样低的损失；M 稠密、非恒等；仍有明显聚类 | 只有定性描述，没给数 |

- 作者的解读：JEPA 损失对潜空间的任意可逆线性变换（换基）不变；随机初始化找到的是同一最优子空间的一个"纠缠基"，单位阵初始化则说明存在一个规范的、可解释的解并且是稳定最优——**predictor 往恒等方向的归纳偏置**选出了可解释的解。

## 局限 / 存疑

- **论文自己承认的（§5 末）**：
  - 只在合成数据上验证，区制定义清晰且互不混合，完美契合 Assumption 3.1；真实时间序列有渐变过渡、层次结构等。
  - 理论用了两个理想化：线性预测器，以及 f_EMA ≈ f_θ；非线性预测器和 EMA 稳定作用需要更正式的处理。
- 以下是 Claude 的推断，请核对：
  - **坍塌解没被排除**：常数函数也属于 V（= Σχ_i 的倍数），常数编码器 + 任意 M 同样让理想化损失为零。Theorem 3.4 说"f 的分量属于 V 时达到最小"，但没说为什么会学到**区分**各区制的 r 维解而不是坍塌解；防坍塌完全隐含在 EMA 机制里，而 EMA 恰好被 f_EMA ≈ f_θ 近似掉了。
  - **"当且仅当"偏强**：反方向需要额外假设 M 在表示上为恒等（附录 A 自己写了），所以严格说只证明了"V 中的表示 + 恒等 M 是最优解之一"。
  - **数据构造让结论接近同义反复**：每个样本来自单一区制的一条主序列，区制在一对窗口内天然不变；"学到区制指示函数"在这里几乎等价于"学到序列级标签"。没有区制切换的数据，也就没测试 Lemma 3.2(b) 之外的情形。
  - **摘要说"约束"、实验是"初始化"**：摘要称"把线性预测器约束为近恒等是关键归纳偏置"，但实验只是把 M **初始化**为单位阵，训练中没有约束；而且随机初始化同样产生聚类（只是基不同），所以"关键"指的是可解释性/解耦，不是聚类本身。
  - **图 4 和正文描述不太一致**：正文说 M 的谱"由 r 个接近 1 的特征值主导、其他方向可能被衰减"，但图 4 里全部 32 个特征值模长都在 0.97–1.02 之间，看不出 18 个与其余 14 个的分界，需核对。
  - 65.48% 的簇纯度来自 **MLP 预测器**的模型，而 M 的分析来自线性预测器模型；线性预测器模型的簇纯度没报告。
  - **附录 C 有不一致**：正文说 MLP 预测器"两个隐藏层"，附录表 2 也列了两层隐藏层，但下文又写 "the number of hidden layers was 1"；附录表 1 编码器最后线性层输出写成 2×k，而潜维度 k = 32。需核对。论文也没给优化器、学习率、训练轮数等训练细节，没给代码。
  - 没有和 VAMPnets、时滞自编码器、对比式时间序列 SSL（TS2Vec 等）做定量比较，只和自编码器比。

## 与其他论文的关系

- **系列里的理论线**：本文是 [[topics/notes/JEPA系列/3-02_WhenLeJEPAWorldModel|When Does LeJEPA Learn a World Model?]] 的"前辈"——两篇都用转移算子 / Koopman 算子的谱来解释 JEPA 学到了什么：本文看特征值 = 1 的不变子空间（区制指示函数），3-02 看高斯世界里 Hermite 多项式的谱 ρ^d，证明线性部分（特征值最大的非常数特征函数）被选中。3-02 也明确称转移算子为 "(stochastic) Koopman operator"。
- **慢特征**：特征值为 1 的不变函数是"最慢"的特征，和 [[topics/notes/JEPA系列/2-04_JEPASlowFeatures|JEPA Slow Features]]（JEPA 偏爱慢特征）是同一枚硬币：在这里慢特征偏置变成了好事（区制识别），在世界模型里则会压掉快变物体（[[topics/notes/JEPA系列/2-07_MotionJEPA|MotionJEPA]]）。
- **predictor 的作用**：本文认为 predictor 往恒等方向的偏置选出可解释解；[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 的门控残差预测器（默认复制当前潜变量）也是"恒等偏置"，那篇在相关工作里引用了本文。
- **防坍塌方式**：本文分析的是 EMA / stop-gradient 型 JEPA（[[topics/notes/JEPA系列/2-01_I-JEPA|I-JEPA]]、BYOL 一系），而不是 SIGReg 型（[[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]]）。
- 系列里的 [[topics/notes/JEPA系列/1-10_CommuteTimeWM|CommuteTimeWM]] 从标题看也用了转移算子 / 随机游走的谱几何，可对照。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Joint-Embedding Predictive Architectures (JEPAs), a powerful class of self-supervised models, exhibit an unexplained ability to cluster time-series data by their underlying dynamical regimes. We propose a novel theoretical explanation for this phenomenon, hypothesizing that JEPA's predictive objective implicitly drives it to learn the invariant subspace of the system's Koopman operator. We prove that an idealized JEPA loss is minimized when the encoder represents the system's regime indicator functions, which are Koopman eigenfunctions. This theory was validated on synthetic data with known dynamics, demonstrating that constraining the JEPA's linear predictor to be a near-identity operator is the key inductive bias that forces the encoder to learn these invariants. We further discuss that this constraint is critical for selecting this interpretable solution from a class of mathematically equivalent but entangled optima, revealing the predictor's role in representation disentanglement. This work demystifies a key behavior of JEPAs, provides a principled connection between modern self-supervised learning and dynamical systems theory, and informs the design of more robust and interpretable time-series models.
