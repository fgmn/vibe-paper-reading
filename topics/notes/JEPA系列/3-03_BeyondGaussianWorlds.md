---
id: "3-03"
org: 专题·JEPA系列
short: "Beyond Gaussian Worlds"
title: "Beyond Gaussian Worlds: Latent Geometry Matters for JEPAs"
aliases: ["Beyond Gaussian Worlds", "Latent Geometry Matters for JEPAs"]
date: 2026-09-18
category: "JEPA 理论"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "Université Paris-Saclay、CNRS、ENS Paris-Saclay（Centre Borelli）；Advanced Track and Trace；Universidad de la República（Uruguay）；Institut Universitaire de France"
partners: []
authors: ["Léo Nicollier", "Enric Meinhardt-Llopis", "Marc Pic", "Pablo Musé", "Gabriele Facciolo"]
arxiv: "2609.21656"
pdf: "[[topics/papers/JEPA系列/3-03_2609.21656_BeyondGaussianWorlds.pdf]]"
code: ""
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "identifiability", "riemannian-manifold", "distribution-matching", "hypersphere", "spectral-theory"]
---

# Beyond Gaussian Worlds: Latent Geometry Matters for JEPAs

> [!info] 论文信息
> arXiv [2609.21656](https://arxiv.org/abs/2609.21656) · v1 2026-09-18 · 25 页（正文 10 页 + 附录 A–E，含证明）
> PDF：[[topics/papers/JEPA系列/3-03_2609.21656_BeyondGaussianWorlds.pdf|本地 PDF]]
> 作者：Léo Nicollier（Centre Borelli、Advanced Track and Trace）、Enric Meinhardt-Llopis（Centre Borelli）、Marc Pic（Advanced Track and Trace）、Pablo Musé（Centre Borelli、Universidad de la República）、Gabriele Facciolo（Centre Borelli、Institut Universitaire de France）
> 论文没给代码链接（复现声明说"录用后公开"）。
> 专题：[[topics/JEPA系列#三、JEPA 理论|JEPA系列 · 三]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录 A–D 的实验细节，证明部分只看了结构）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 出发点："Klindt et al. (2026) showed that, under their Euclidean assumptions, matching a Gaussian target can recover Gaussian latent variables up to a linear transformation, and that the Gaussian is the unique distribution with this guarantee."（Abstract，p.1）
> - 主张："This shows that Gaussian uniqueness is not a universal property of distribution-matched JEPAs"（Abstract，p.1）
> - 目标分布隐含几何先验："These choices are typically motivated by optimization or downstream performance, but they also implicitly impose a geometric prior on the learned representation space."（§1，p.1）
> - 正样本对用流形上的 Langevin 扩散生成："To generate positive pairs intrinsically, we evolve Z for a fixed time t using a Langevin diffusion on M."（§3.1，p.4）
> - 直觉："Linear recovery is therefore possible when the ambient latent coordinates are exactly the complete set of slowest nonconstant functions."（§4，p.5）
> - 半径的作用："When ∥z∥ varies across the manifold, the centered squared radius is a non-constant function of the latent state and limits how far the first nonlinear eigenvalue can lie above the linear one."（§4，p.7）
> - 高斯不是几何中性的："A Gaussian target is not geometrically neutral."（§5，p.8）
> - 没有普适最优目标："More generally, our results do not identify a universally optimal target."（§5，p.8）
> - 失配实验在定理范围之外："mismatched experiments are controlled stress tests outside the formal scope of the theorems."（§6，p.8）
> - 环面的失败归为优化问题："The lower scores therefore reflect an optimization failure rather than a limitation of the matched toroidal geometry."（§6.1，p.9）

## 一句话总结

LeJEPA 把表征拉向各向同性高斯，SPHERE-JEPA 拉向超球面均匀分布——这其实是在给表征空间选几何先验。Klindt et al. (2026)（[[topics/notes/JEPA系列/3-02_WhenLeJEPAWorldModel|When Does LeJEPA Learn a World Model?]]）证明在欧氏空间里只有高斯能保证"对齐 + 分布匹配 → 线性恢复隐变量"。本文把这套 World–Learner 可辨识性理论推广到**嵌入的黎曼流形**上的隐变量（正样本对由流形上的 Langevin 扩散生成），给出线性可辨识的充要条件（"线性可容许世界"：密度、嵌入几何、谱排序三个条件），证明**球面均匀世界**也线性可辨识（只差一个正交变换），而且近似恢复的界比高斯更紧（λ_nl/λ = 2d/(d−1) > 2）。实验上，目标分布的几何和真实隐空间匹配时线性恢复最好（球面世界 R² 0.998，高斯目标只有 0.669），128 维 Clifford 环面上匹配目标 0.967 vs 高斯 0.795。

## 要解决什么问题

- **分布匹配型 JEPA 的目标分布该怎么选？** LeJEPA（SIGReg，各向同性高斯）、SPHERE-JEPA（超球面均匀分布）都通过约束表征的边缘分布来防坍塌，选择理由通常是优化或下游效果，作者指出它同时隐含地规定了表征空间的几何。
- **可辨识性问题**：数据由未知映射 g 从隐世界生成，正样本对编码"隐空间里相近"；问题是学到的编码器 f 是否满足 f∘g 在线性变换意义下还原隐状态。
- Klindt et al. (2026) 只处理 M = R^d、正样本对由逐坐标加独立噪声生成的情形，结论是"高斯唯一"。但很多隐变量天然是非欧的——旋转、方向、相位、关节构型都在流形上，加性扰动在流形上没有内蕴定义，欧氏框架不能直接用。
- 所以问：在流形世界里，什么条件下"对齐 + 精确分布匹配"能保证线性恢复？高斯唯一性是否还成立？

## 方法

### World–Learner 设定（§3）

- **隐世界**（定义 3.1）：W = (M, p, g, K)，M ⊆ R^d 是嵌入的黎曼流形，p 是 M 上的概率测度，g 是观测映射，K 是 Markov 转移核。正样本对：Z ~ p，Z′ | Z=z ~ K(z,·)，(X, X′) = (g(Z), g(Z′))。
- **假设 3.2**：
  1. p 关于黎曼体积有光滑、严格正的密度；
  2. K = K_t 是 Langevin 扩散 dZ_s = ∇_M log p(Z_s) ds + √2 dB^M_s 的时间 t 转移核（B^M 是流形上的 Brownian motion）；
  3. g 几乎处处单射且有可测逆（观测不丢信息）。
- 扩散的生成元是加权 Laplacian D_p φ = Δ_M φ + ⟨∇_M log p, ∇_M φ⟩，转移算子 T_t = e^{tD_p}；在标准边界条件下 D_p 在 L²(p) 自伴、半群保持 p，所以**平稳性是正样本对动力学自带的**，不是额外假设。欧氏高斯世界对应 Ornstein–Uhlenbeck 过程；球面、环面这类均匀紧世界对应内蕴 Brownian motion。
- **学习者**：诱导映射 h = f∘g : M → M。理论只考虑"匹配"设定（表征空间就是 M，目标分布就是 p），把分布正则理想化为**精确分布匹配**：

  min_{h: h#p = p} L_p(h) = E‖h(Z′) − h(Z)‖²（环境空间 R^d 的欧氏范数）。

### 主要结果（§4）

通用假设：M ⊆ R^d 连通、正常嵌入、内蕴维数 m；p 光滑严格正且平稳；−D_p 在 L²(p) 自伴、离散谱；p **居中且各向同性**：E[Z]=0，Cov(Z)=c_p I_d。

**定义 4.1（尺度 λ 下线性可容许）**：
1. 密度相容：p(z) ∝ exp(−λ‖z‖²/2)，z ∈ M（各向同性高斯势限制到 M 上；对常半径流形即均匀分布）；
2. 几何相容：Δ_M z = −λ z^⊥（z^⊥ 是位置向量的法向分量）；
3. 谱排序：环境坐标函数 z_1,…,z_d 恰好张成 −D_p 的**完整**第一非常数特征空间，特征值 λ。

前两条保证每个坐标满足 −D_p z_i = λ z_i；第三条说坐标就是最慢的非常数函数，且没有非线性函数和它们一样慢。附录 C 验证：高斯空间、球面、等半径平坦环面、平衡的球面乘积（含 Clifford 环面）都是线性可容许的；不等半径会破坏可容许性。

| 结果 | 假设 | 结论 |
|---|---|---|
| **定理 4.2（逆向刻画）** | 第一非常数特征空间特征值 λ₁>0、维数 d；分布保持问题的最小值达到谱下界 min L_p = 2d c_p (1 − e^{−λ₁t})；且**每个**分布保持的极小元都是环境坐标的线性函数 | (M, p) 在尺度 λ₁ 下线性可容许。即"精确线性恢复"必然要求密度、嵌入几何、最慢谱模三者相容 |
| **定理 4.3（正向线性可辨识）** | (M, p) 在尺度 λ 下线性可容许 | 分布保持对齐问题的极小元**恰好**是 h*(z) = Qz，Q ∈ O(d) 且 Q(M) = M。剩余的不确定性只有保持世界的旋转/反射 |
| **定理 4.4（近似线性可辨识）** | 线性可容许；λ_nl > λ 是 −D_p 下一个不同的特征值；ρ = e^{−λt}，ρ_nl = e^{−λ_nl t}；h#p = p 且 L_p(h) ≤ 2d c_p(1−ρ) + ε | 存在 A 使 ‖h − Az‖²_{L²(p)} ≤ ε / [2(ρ − ρ_nl)]；并存在 Q ∈ O(d)，令 η = ε/[2(ρ−ρ_nl)]，有 ‖h − Qz‖² ≤ η + η²/c_p。(8) 的常数在底层谱不等式层面最优 |
| **定理 4.5（径向阻碍与球面刚性）** | (M^m, p) 在尺度 λ 下线性可容许 | r(z) = ‖z‖² − m/λ 满足 −D_p r = 2λ r。所以要么 M ⊆ S^{d−1}(√(m/λ))，要么 λ_nl ≤ 2λ。若再有 m = d−1 且 M 闭，则 λ_nl > 2λ 推出 M 就是球面 S^{d−1}(√((d−1)/λ)) |
| **推论 4.6（高斯 vs 球面）** | — | 欧氏高斯世界 λ_nl/λ = 2；球面均匀世界 λ_nl/λ = 2d/(d−1) > 2，线性–非线性谱间隔更大 |

- 直觉（§4 开头）：对齐偏好沿正样本转移变化最慢的函数，精确分布匹配排除坍塌并固定边缘分布；当环境坐标恰好是全部最慢非常数函数时才能线性恢复。线性模和第一个非线性竞争者之间的谱间隔决定稳定性。
- 半径变化时，"中心化平方半径"本身就是特征值 2λ 的非线性模，所以高斯（任何有限维半径都在变）卡在 λ_nl/λ = 2；常半径流形上这个模消失。闭超曲面里只有球面能让第一非线性特征值严格超过 2λ。
- §5：在固定 ρ 下球面的近似恢复界更紧，但这个相对优势随 d → ∞ 消失（附录 D 图 6 画了系数 1/[2(ρ−ρ_nl)]）。作者明确说**没有普适最优目标**：已知世界且线性可容许时，按世界的分布选目标；未知世界时选高斯、球面还是别的，就是选归纳偏置——高斯适合欧氏高斯动力学，但可能扭曲方向、相位、旋转这类紧隐变量。

### 实践：几何感知的 heat-kernel MMD（附录 B）

- 每种目标分布用对应几何上的热核做 MMD：高斯用 OU 半群的 Mehler 核（t=1），S² 用球面热核（t=0.125），T² 用两个 S¹ 热核的乘积（各 t=1.5）。核相对目标不变分布定义，所以 MMD 里目标相关的期望可以解析算。
- 紧目标的热核时间按先验规则固定（归一化后对径点核值约 0.1–0.2），不按验证集选。
- 高维实验里高斯目标用 SIGReg，Clifford 目标用乘积热核 MMD。

## 实验与关键数字

**协议**：对齐 + 目标分布正则；每个世界–目标组合只用 seed 0 选正则权重 α（冻结编码器、拟合仿射 ridge probe Y→Z、取验证 R² 最高），再用 seed 1–3 重训报告测试均值 ± 样本标准差。作者承认这是**用隐变量标签做的 oracle 选择**，对失配目标是"有利的最好情况"比较。

### 1. 匹配 vs 失配的目标几何（表 1 / 表 2，测试 R²(Y→Z)）

三个内蕴维数为 2 的世界：高斯（笛卡尔机器人位置，程序化渲染 128×128）、球面（Stanford Bunny 的相机方向，PyVista 渲染）、环面（DeepMind Control reacher-hard 两连杆臂的关节角）。编码器是 ImageNet-1K 预训练的 EdgeNeXt-XX-Small + 线性投影。

| 隐世界 \ 目标 | 高斯 | 球面 | 环面 |
|---|---|---|---|
| 高斯 | **0.995±0.001** | 0.909±0.009 | 0.606±0.175 |
| 球面 | 0.669±0.005 | **0.998±0.001** | 0.921±0.003 |
| 环面 | 0.493±0.011 | 0.737±0.004 | **0.996±0.001**† |

- † 环面–环面跑了 10 个种子，只有 5 个接近完美恢复（R² 0.996±0.001，L_inv 0.052±0.001），表中是这 5 个的统计；另外 5 个 R² 0.597±0.187、L_inv 0.093±0.017，作者解释为陷入只编码了一个角度的局部极小，归为优化失败。
- 两个探针方向的不对称（表 2）：环面世界 + 高斯目标，R²(Z→Y) = 0.986 但 R²(Y→Z) 只有 0.493；球面世界 + 高斯目标 R²(Z→Y) = 0.997、R²(Y→Z) = 0.669。即失配目标给出的表征几乎是 Z 的线性函数，但**不可线性求逆**。图 1 可视化了失配造成的扭曲。

### 2. 高维 Clifford 环面（§6.2，表 3、表 4）

- 世界：C_d = S^{d/2} × S^{d/2} ⊂ R^{d+2}，隐状态是两个在 Morse 势下相互作用的粒子的（不可见）初始条件，编码器只看轨迹第 200–249 步的 50 个延迟状态；正样本对由 (1) 的平稳扩散生成，ρ = 0.95。编码器是等变时间卷积网络。
- 比较 Unif(C_d)（匹配，d+2 维输出）、N(0, I_d)（匹配内蕴自由度）、N(0, I_{d+2})（有利基线，多出的坐标可以保留规范嵌入）。

| d | N(0,I_d) | N(0,I_{d+2}) | Unif(C_d) |
|---|---|---|---|
| 4 | 0.4540±0.0298 | 0.6755±0.0148 | **0.8315±0.0119** |
| 8 | 0.5668±0.0194 | 0.7271±0.0010 | **0.8757±0.0038** |
| 16 | 0.6590±0.0134 | 0.7748±0.0035 | **0.9266±0.0096** |
| 32 | 0.7168±0.0126 | 0.8148±0.0054 | **0.9518±0.0098** |
| 64 | 0.7000±0.0690 | 0.8224±0.0124 | **0.9542±0.0038** |
| 128 | 0.7465±0.0651 | 0.7948±0.0481 | **0.9667±0.0024** |

（表 3，R²(Y→Z)，高斯目标用 SIGReg。）
- 把 SIGReg 换成 Matérn-3/2 MMD（表 4）排序不变：d=128 时 N(0,I_{d+2}) 为 0.8463，仍低于匹配目标 0.9667。表 4 还多跑了 d=256（0.8289 / 0.8553），但没有对应的 Clifford 结果。
- 结论：增加高斯输出维数（去掉"秩瓶颈"）能提高恢复，但补不上和匹配几何目标的差距；高维浓缩并不消除高斯与流形隐世界的全局几何/拓扑失配。

### 3. 无监督诊断与界的经验检验（附录 A.3、A.4）

- 球面匹配世界扫 α ∈ {10⁻³,…,0.5} × 3 种子（图 4）：只有不变性损失接近 L*_inv = 1−ρ = 0.05、且 MMD 接近目标采样参考值 1 时才高恢复；α ∈ [5×10⁻³, 10⁻¹] 时所有种子 R² > 0.99。α = 10⁻³ 匹配不足，α = 0.5 不变性损失太大 → 两个自监督损失联合起来可以当选模判据，不用隐变量探针。
- 定理 4.4 的经验检验（图 5）：Clifford 环面 + 可逆耦合观测映射，d ∈ {4,…,128} × 3 种子共 18 个运行，实测 E_lin 0.0206–0.0618，预测上界 B 0.0551–0.1033，**全部在对角线下方**。作者说因为是有限权重、有限批的 MMD，这是诊断而不是对总体定理的验证。

## 局限 / 存疑

> 论文没有单独的"局限"一节（结论里提了一个扩展方向），下面主要是 Claude 的推断，请核对。

- **理论只覆盖匹配设定 + 精确分布匹配**：表示空间就是 M、目标就是 p。实践里用的是有限权重、有限批的 MMD/SIGReg；失配实验作者自己说在定理范围之外。
- **需要知道隐世界的几何**才能选对目标。真实数据（自然图像、视频）的隐空间几何未知，论文给的建议只是"把目标选择当归纳偏置"，没有给出在未知世界里怎么诊断几何的办法。
- **超参用隐变量标签选**（oracle α 选择）。附录 A.3 说可以用两个自监督损失诊断高恢复区，但只在球面匹配世界上演示。
- **正样本对用流形上的平稳扩散生成**，这和实际 JEPA 的数据增强 / 时间相邻帧不一样；定理也依赖 L2 对齐损失的二次结构（结论里说 r-齐次损失是未来方向）。
- **实验规模小**：内蕴维数 2 的渲染世界 + 合成 Morse 动力学，没有真实数据或下游任务。
- **环面结果的种子数前后不一致，需核对**：§6.1 和附录 A.1 说环面–环面 10 个种子里 5 个成功，但结论（§7）写"matched target reaches near-perfect recovery in two of three runs, with one lower-recovery seed"，像是早期 3 种子版本没改过来。
- **附录 D 图 6 图例需核对**：正文写球面 λ_nl/λ = 2 + 2/(d−1)（d 为环境维数），图 6 图例写 "2 + 2/d"、横轴标 "Intrinsic dimension d"——用内蕴维数 m = d−1 表达时两者一致，但符号混用。
- **高维表 3 里 N(0,I_{d+2}) 在 d=128 反而比 d=64 低**（0.7948 vs 0.8224，且标准差 0.0481 较大），论文没解释。

## 与其他论文的关系

- **直接前作**：[[topics/notes/JEPA系列/3-02_WhenLeJEPAWorldModel|When Does LeJEPA Learn a World Model?]]（Klindt, LeCun, Balestriero 2026）——欧氏、加性噪声正样本、高斯唯一。本文沿用其 World–Learner 形式化，并在流形上恢复了欧氏高斯情形作为特例，同时找到了球面这个非欧可辨识世界。
- **被分析的方法**：[[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]] / SIGReg（各向同性高斯目标）；作者自己的 SPHERE-JEPA（超球面均匀目标，arXiv 2605.26900）和 Expanding SPHERE-JEPA（超球面上的 MMD/KSD/KL 正则，2606.17603）；KerJEPA（核差异框架）。本文从可辨识性角度给"球面目标"提供了理论理由。
- **慢特征 / 谱视角**：对齐偏好正样本转移下变化最慢的量，等价于转移算子的首个非常数特征函数，与 SFA、[[topics/notes/JEPA系列/2-04_JEPASlowFeatures|JEPA 与慢特征]]、[[topics/notes/JEPA系列/3-01_KoopmanJEPA|Koopman JEPA]]（JEPA 与 Koopman 不变子空间）、diffusion maps / Laplacian eigenmaps 是一条线。
- **与世界模型规划的联系**：[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 从规划角度批评 VICReg/SIGReg 对时间相关轨迹约束过多、强加不合适的分布形状；本文从可辨识性角度说明高斯目标会扭曲紧隐变量。两篇都指向"分布正则的目标形状不是中性的"。[[topics/notes/JEPA系列/1-05_LeWM|LeWM]] 用 SIGReg 训练世界模型，其隐状态（如关节角）就是本文说的环面型变量。
- **同系列理论篇**：[[topics/notes/JEPA系列/3-04_IActTherefore|I Act Therefore I Am]] 同样从 Klindt et al. 出发，但关注动作条件下的**逐分量**可辨识（而不是线性/正交可辨识），并指出各向同性高斯对正交旋转不变是无法解混的原因——和本文"高斯只能辨识到正交变换"的结论互补。
- 系列总览：[[topics/JEPA系列]]。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Recent Joint-Embedding Predictive Architectures (JEPAs) prevent representation collapse by constraining learned representations to follow a prescribed target distribution, such as an isotropic Gaussian or the uniform distribution on a hypersphere. Klindt et al. (2026) showed that, under their Euclidean assumptions, matching a Gaussian target can recover Gaussian latent variables up to a linear transformation, and that the Gaussian is the unique distribution with this guarantee. We extend their analysis to latent variables supported on embedded Riemannian manifolds and derive conditions on the latent geometry and positive-pair dynamics under which alignment and exact distribution matching guarantee linear recovery. In particular, when the latent variables are uniformly distributed on a sphere and the representations are matched to the same spherical distribution, every optimal representation recovers the latent state up to an orthogonal transformation. This shows that Gaussian uniqueness is not a universal property of distribution-matched JEPAs: non-Euclidean latent geometries can admit other linearly recoverable distributions. We further derive an approximate-recovery bound that is strictly tighter for the spherical world than for the Gaussian world. Experiments on Gaussian, spherical, and toroidal latent spaces show that geometrically compatible targets yield better linear recovery when optimization succeeds, whereas mismatched targets distort the latent structure. This advantage persists in high-dimensional Clifford-torus worlds.
