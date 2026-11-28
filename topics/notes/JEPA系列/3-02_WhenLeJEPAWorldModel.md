---
id: "3-02"
org: 专题·JEPA系列
short: "When Does LeJEPA Learn a World Model?"
title: "When Does LeJEPA Learn a World Model?"
aliases: ["When Does LeJEPA Learn a World Model?", "WhenLeJEPAWorldModel", "LeJEPA Identifiability"]
date: 2026-05-25
category: "JEPA 理论"
venue: "NeurIPS 2026"
source: "arXiv"
affiliation: "Cold Spring Harbor Laboratory；New York University；Brown University"
partners: []
authors: ["David Klindt", "Yann LeCun", "Randall Balestriero"]
arxiv: "2605.26379"
pdf: "[[topics/papers/JEPA系列/3-02_2605.26379_WhenLeJEPAWorldModel.pdf]]"
code: "https://github.com/klindtlab/lejepa-identifiability"
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "theory", "identifiability", "sigreg", "world-model", "hermite", "lean4"]
---

# When Does LeJEPA Learn a World Model?

> [!info] 论文信息
> arXiv [2605.26379](https://arxiv.org/abs/2605.26379) · v2 2026-11-09（v1 2026-05-25）· 52 页（正文 10 页 + 附录 A–H）
> PDF：[[topics/papers/JEPA系列/3-02_2605.26379_WhenLeJEPAWorldModel.pdf|本地 PDF]]
> 作者：David Klindt（Cold Spring Harbor Laboratory）、Yann LeCun（NYU）、Randall Balestriero（Brown）
> 发表：PDF 页脚标注 40th Conference on Neural Information Processing Systems（NeurIPS 2026）
> 代码 / Lean 证明 / demo：[klindtlab/lejepa-identifiability](https://github.com/klindtlab/lejepa-identifiability)
> 专题：[[topics/JEPA系列#三、JEPA 理论|JEPA系列 · 三]]

> [!note] 下面各节是 Claude 根据 PDF 全文（正文 + 附录 B、G、H 的关键部分）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 主张："We prove that LeJEPA (alignment plus Gaussian regularization) linearly recovers the world's latent variables from nonlinear observations, a property known as linear identifiability…"（Abstract，p.1）
> - 主要结果："Our main result is that among all such worlds, the Gaussian is the unique latent distribution for which this guarantee holds."（Abstract，p.1）
> - 空白："Yet no identifiability results exist for JEPAs."（§1，p.2）
> - 只假设 SIGReg 已成功："We model the situation where SIGReg has succeeded, i.e., h(z) matches the target Gaussian; in practice this holds approximately (Sec. 5.3)."（§3.2，p.4）
> - 关键直觉："In words: any nonlinear distortion of the representation strictly reduces the correlation between positive pairs. This is the key intuition."（§4，p.5）
> - 逆命题的直觉："For linear identifiability this eigenfunction must be affine, which only the Gaussian satisfies."（§5.2，p.5）
> - 近似版本："In practice the first dominates, so recovery error scales as δ/(2ρ(1−ρ)): alignment is hard, whitening essentially free."（§5.3，p.6）
> - 高维实验："…batch-statistic estimators (SIGReg, VICReg) maintain R² > 0.999 up to N = 2048; InfoNCE degrades at scale under fixed kernel width."（§6.1，p.7）
> - 真实轨迹破坏假设："Table 2 (right) shows per-dimension R² is anisotropic, and total R² never exceeds 0.5, consistent with Thm. 2."（§6.2，p.8）
> - 带预测器："Aligning h(z′) with a learned prediction P(h(z)) leaves recovery unchanged (0.989 without, 0.987 linear, 0.988 MLP predictor; N=8, 5 seeds)…"（§6.5，p.10）
> - 有限样本："Our result is a population-level statement about the global optimum."（§7，p.10）
> - 数据的实际含义："…for self-supervised pretraining, exploration approximating an isotropic random walk keeps the data in the regime our theory covers."（§8，p.10）

## 一句话总结

这是 JEPA 的第一个**可辨识性**结果。设世界的潜变量 z 独立、平稳、正样本对满足加性噪声转移 z′ = m(z) + η，观测 x = g(z) 经过任意未知非线性混合；LeJEPA 学 h = f∘g，目标是"拉近正样本对 + h(z) 服从 N(0, I)"。作者证明：在**高斯潜变量 + OU 转移**的世界里，任何满足这两条的 h 都有 L(h) ≥ 2(1−ρ)N，等号**当且仅当 h(z) = Qz（Q 正交）**——即 LeJEPA 的最优表示恰好是真实潜变量的旋转（线性可辨识）；反过来，在这一类世界里**高斯是唯一**能保证这一点的潜变量分布。另外给出近似版误差界（误差 ≈ δ/(2ρ(1−ρ))），以及"正交可辨识 ⇒ 用旋转不变代价在学到的潜空间里规划与在真实潜空间里规划等价"。实验：RealNVP 混合下 SIGReg 到 N=2048 维仍有 R² > 0.999；Reacher 上 OU 采样的数据 R² = 0.95，而真实 RL 轨迹的数据 R² 不超过 0.5。

## 要解决什么问题

- 什么时候学到的表示算"世界模型"？作者的回答：当它**线性地**恢复世界的潜变量（位置、速度、颜色……）时。把位置和颜色、速度和纹理搅在一起的表示，可能在窄任务上不错，但世界一变就失效；线性探针能否读出潜变量，隐含问的就是这个。
- 以往 JEPA 靠隐式防坍塌（stop-gradient、EMA teacher、聚类自蒸馏），嵌入分布没有被指定，所以**一直没有 JEPA 的可辨识性结果**。LeJEPA 用 SIGReg 显式把嵌入推向各向同性高斯，第一次让这个问题变得可分析。
- 同时，非线性 ICA 一般不可辨识，需要额外结构（非平稳、时间依赖、辅助变量、对比学习、增广、干预……）；本文要说明 LeJEPA 的"高斯 + 正样本对"提供了什么结构。

## 方法

### 1. 世界与学习者（§3）

**World 假设（Assumptions 3.1）**：
- (i) **独立**：各分量 z_i 相互独立，转移 p(z′_i | z_i) 也逐分量独立；
- (ii) **平稳**：两个视图边缘分布相同，p(z) = p(z′)；
- (iii) **加性噪声**：z′_i = m_i(z_i) + η_i，η_i 与 z_i 独立。作者指出常波动率的 Itô 扩散 dz = b(z)dt + σdW 在一阶 Δt 下就是这种形式。

**高斯世界（§3.1.1）**：z ~ N(0, I_N)，取线性转移 m_i(z_i) = ρz_i；平稳性加 Cramér 分解定理迫使噪声也是高斯，得到 **OU 转移** z′ = ρz + √(1−ρ²) η（式 1），ρ ∈ (0,1) 控制两视图相关度。

**学习者（式 2）**：min_h L(h) = E‖h(z′) − h(z)‖²，s.t. h(z) ~ N(0, I_N)。即假设 SIGReg 已经成功（近似情形见定理 3）。LeJEPA 本身没有 predictor。h 只要求可测，输出维度取 N。白化后 E‖h‖² = N，所以 L(h) = 2N − 2Σ_i E[h_i(z′)h_i(z)]（式 3）——最小化距离等价于最大化两视图相关。

### 2. 谱分析（§4）

- 转移算子 (T h_i)(z) = E[h_i(z′) | z]，即动力学的（随机）Koopman 算子；特征值 1 = λ_0 > λ_1 ≥ λ_2 ≥ … ≥ 0，特征值越大的特征函数跨视图越相关（越"慢"、越可预测）。
- **高斯世界**：特征函数是 Hermite 多项式 He_k，d 次 Hermite 的特征值恰为 ρ^d（Mehler 公式）。零均值单位方差的 h_i 按次数分解，方差占比 w_1, w_2, … 之和为 1，于是
  **E[h_i(z′)h_i(z)] = w_1ρ + w_2ρ² + w_3ρ³ + … ≤ ρ**（式 4），等号当且仅当 w_1 = 1，即 h_i 线性。任何非线性扭曲都严格降低正样本对相关。
- **一般分布（常扩散）**：特征函数由 Sturm–Liouville 方程刻画；第一个非常数特征函数总是单调的（所以对任何分布都有"单调变换意义下"的可辨识），但要线性可辨识就要求它是仿射的。

### 3. 四个定理（§5）

| 定理 | 假设 | 结论 |
|---|---|---|
| **Thm 1**（LeJEPA 线性可辨识） | 高斯世界（OU）；h: R^N → R^N 可测且 h(z) ~ N(0, I_N) | L(h) ≥ 2(1−ρ)N，**等号当且仅当 h(z) = Qz，Q ∈ O(N)**；在最优处 h(z′) \| h(z) ~ N(ρh(z), (1−ρ²)I_N)，即同时恢复了真实转移 |
| **Thm 2**（高斯唯一性） | 任一满足 Assumptions 3.1 的世界；假设式 (3) 在 Cov(h(z)) = I_N 约束下的**每个**最小解都是线性的 h(z) = Qz | 则 z 是高斯。证明：仿射特征函数 ⇒ 得分函数 (log p)′ 线性 ⇒ log p ∝ −(z_i − μ)²；逐分量证明，独立性推广到联合分布。附录 B 另要求每个分量的平稳分布在 R 上全支撑 |
| **Thm 3**（近似可辨识） | 高斯世界；E[h(z)] = 0；近似对齐 L(h) ≤ 2(1−ρ)tr(Cov(h(z))) + δ；近似白化 ‖Cov(h(z)) − I_N‖_F ≤ ε；记 D = δ/(2ρ(1−ρ)) | 存在 Q ∈ O(N) 使 **E‖h(z) − Qz‖² ≤ D + (ε + D)²**。D 衡量非线性，(ε+D)² 衡量线性部分偏离正交；实践中第一项主导——对齐难、白化几乎免费 |
| **Thm 4**（最优潜空间规划） | h(z) = Qz（Q 正交）；阶段代价 ℓ 与终端代价 ℓ_T 旋转不变：ℓ(Rz, a) = ℓ(z, a)、ℓ_T(Rz) = ℓ_T(z)，∀R ∈ O(N) | 在学到的潜空间 ẑ = h(z) 里规划（转移经 h 映射、代价相同）得到**相同的最优值和最优动作序列** |

- Thm 1 只用到了白化（Cov(h(z)) = I），SIGReg 蕴含这一点；Thm 2 回答"那换成别的白化分布行不行"——在这类世界里不行。
- 附录 E 给了 Thm 1 的另一个证明（Dirichlet 能量 + Mazur–Ulam，ρ→1 情形）；附录 F 与慢特征分析（SFA）理论对照。
- **Lean 4 形式化（附录 G）**：四个定理的推理链在 Lean 4 + Mathlib 中零 sorry 编译通过，但 Hermite 基完备性、Mehler 公式、"1 次 ⇒ 线性"、"高斯 + 线性 ⇒ 正交"、"仿射得分 ⇒ 高斯密度"、Mazur–Ulam、极分解界等标准结果是作为**公理**引入的（表 5 列出了清单）。

## 实验与关键数字

### 1. 正向：高斯潜变量下的线性可辨识（§6.1）

- 2D：z ~ N(0, I₂)，四种非线性混合（随 ‖z‖ 旋转的螺旋、正弦剪切、抛物剪切、RealNVP 耦合层），都是微分同胚；螺旋还保测度，说明光是观测高斯不够、对齐不可少。4 层 MLP + LeJEPA 损失 L = λL_SIG + (1−λ)L_inv，正样本对按 OU 生成。学到的表示把每种混合都反解到旋转（图 3）。网格搜索：λ = 0.5 时 Gaussianity 过强导致坍塌，最好在低 λ、高 ρ。
- **高维扩展（表 1，RealNVP 混合 + 匹配编码器，5 个种子）**：

| N | 原始观测线性 R²(x→z) | SIGReg R²(h→z) | VICReg | InfoNCE |
|---|---|---|---|---|
| 2 | 0.781 | 0.999998 | 0.999996 | 0.950961 |
| 16 | 0.734 | 0.999988 | 0.999987 | 0.999880 |
| 64 | 0.737 | 0.999966 | 0.999968 | 0.648496 |
| 256 | 0.742 | 0.999884 | 0.999889 | 0.696587 |
| 1024 | 0.763 | 0.999561 | 0.999582 | 0.720241 |
| 2048 | 0.768 | 0.999043 | 0.999094 | 0.727140 |
| 4096 | 0.768 | 0.663 → **0.999449**（批 1024，3 种子） | 0.652 | 0.727111 |

- 批统计类估计（SIGReg、VICReg）到 N=2048 都 R² > 0.999；InfoNCE 在固定核宽 σ=1 下随维度退化（N=16 时 0.9999 是个异常高点）。N=4096 时批 256 成了瓶颈，批 1024 让 SIGReg 恢复。作者结论：方法间差异来自估计（核宽、批大小），不是可辨识性本身。

### 2. 逆向：非高斯潜变量破坏线性可辨识（§6.2）

- **分布扫描**：潜变量取广义正态族（形状参数 α：α→0 重尾、α=1 Laplace、α=2 高斯、α→∞ 均匀），三种目标的线性恢复都在 **α = 2 处达到峰值**（图 4b，附录 H.7）；SIGReg、InfoNCE 对重尾分布的平台比 VICReg 宽。
- **像素 RL 轨迹（DMC Reacher，表 2，3 个种子）**：两个关节角 z = (θ₀, θ₁)，CNN 编码器，同一渲染管线、两种数据分布：

| OU（高斯）ρ | 0.30 | 0.50 | 0.70 | 0.80 | 0.90 | 0.95 | 0.99 |
|---|---|---|---|---|---|---|---|
| R²(h→z) | 0.67 | 0.86 | 0.93 | 0.94 | 0.95 | 0.95 | 0.95 |

| 轨迹 帧间隔 δ | ρ₀ / ρ₁ | R²(z→h) | R²(h→z₀) | R²(h→z₁) |
|---|---|---|---|---|
| 1 | 1.000 / 0.999 | −0.39 | 0.71 | −0.03 |
| 2 | 0.999 / 0.996 | −0.47 | 0.73 | 0.01 |
| 4 | 0.997 / 0.991 | −0.05 | 0.51 | 0.43 |
| 8 | 0.992 / 0.982 | 0.50 | 0.80 | 0.78 |
| 16 | 0.981 / 0.963 | 0.44 | 0.63 | 0.87 |
| 32 | 0.959 / 0.928 | 0.45 | 0.62 | 0.81 |
| 64 | 0.915 / 0.863 | 0.44 | 0.55 | 0.77 |

- 真实 RL 轨迹同时违反多条假设：非高斯边缘、两个关节 ρ 不同（各向异性）、关节角越过 ±π 回绕。总 R² 最高 0.50（δ=8）。小 δ 时 ρ≈1 没有谱间隙，大 δ 时腕关节的双峰平稳分布让 SIGReg 又变差，中间 δ ∈ {8, 16} 最好（附录图 15）。

### 3. 近似界验证（§6.3，图 4a）

- 对每次运行计算 ε、δ、界 D + (ε+D)² 和实际恢复误差 min_Q E‖h(z) − Qz‖²：网格搜索、2D 混合、扩展实验、分布扫描的点都在对角线下方；两个接近零的离群点归因于 ε、δ 的有限样本估计噪声。推论：训练损失可以当可辨识性的代理（附录 H.9）。

### 4. 潜空间规划（§6.4，图 4c–d、图 5）

- 实验是 Thm 4 的一个特例：目标到达，代价最小轨迹就是潜空间里起点到目标的直线。做法（附录 H.12）：在潜空间做 15 步直线插值，每个插值点用 1-NN 在 1 万帧留出库里检索回帧和关节角，看关节空间路径长度 / 弦长（理想 1）。
- 高斯（OU，ρ=0.99）编码器的直线计划解码后与 oracle 统计上无差别；轨迹编码器（δ=8）路径明显弯、代价偏高；所有模型的控制代价随线性可辨识 R² 单调下降。具体数值只在图里，正文没给。

### 5. 超出假设（§6.5）

- **潜维度设错（图 6，真 N=8）**：输出维度 M < N 时编码器保留 M 维子空间完好、其余丢弃，恢复 ≈ M/N；M > N 时饱和。嵌入协方差的参与比 PR = (Σλ)²/Σλ² 在 M ≤ N 时恰好等于 M，M = N+1 起开始低于 M，可以无标签地读出真实 N（附录 H.13）。
- **自然图像（表 3，ImageNet-X 的 9 个样本数 > 1000 的二值因子，平均平衡准确率，线性探针）**：

| LeJEPA | DINO | iBOT | DINOv2 | DINOv3 | 随机初始化 | 像素 |
|---|---|---|---|---|---|---|
| **0.677** | 0.589 | 0.628 | 0.656 | 0.645 | 0.545 | 0.533 |

LeJEPA、DINO、iBOT 都是同一代码库、同一日程在 IN-1k 上训练的 ViT-B/16；DINOv2（LVD-142M）、DINOv3（1.7B）只作参照。附录 H.16：LeJEPA 投影头输出到高斯的 Epps–Pulley 距离 0.0049（采样下限 3×10⁻⁵，骨干特征 0.25），归一化参与比 0.91——SIGReg 只是近似满足，属于 Thm 3 的情形。

- **加预测器（附录 H.14，N=8，5 种子）**：不加 / 线性 / MLP 预测器的恢复 R² 为 0.989 / 0.987 / 0.988；随机初始化的线性预测器收敛到真实转移 ρI（‖P − ρI‖_F = 0.011，螺旋情形 0.002）。MLP 预测器没有理论保证（它原则上能吸收 h 的非线性扭曲），只是梯度下降没找到那种解。
- **训练动态（附录 H.15）**：恢复先有几百到几千步的平台，然后在几百步内跳到最终值；跳跃步数随 N 先增后减（N≈8–32 最慢且种子间差异最大）。

## 局限 / 存疑

- **论文自己写的（§7）**：
  - 潜变量是否高斯无法从观测判断；作者给的是最大熵和中心极限定理的论据，承认"这是论证不是证据"，依赖、非欧的潜变量是开放问题。
  - 结果是总体层面、全局最优的陈述；Thm 3 给了连续退化，但没有回答 ε、δ 如何随样本量和训练动态缩放。
- 以下是 Claude 的推断，请核对：
  - **假设 SIGReg 已完全成功**：Thm 1–2 把 h(z) ~ N(0,I) 当约束而非惩罚项；实际 LeJEPA 是 (1−λ)L_inv + λL_SIG 的加权和，作者自己的网格搜索显示 λ 太大就坍塌。Thm 3 覆盖了近似情形，但界里的 δ、ε 需要知道真实潜变量才能算。
  - **"世界"是 i.i.d. 正样本对**：理论里只有 (z, z′) 一对、没有动作；Thm 4 的规划等价需要动作条件转移已经学好，而这一步本文没有处理（§8 也承认"动作条件转移还要学"）。§6.4 的"规划"实验其实是潜空间直线插值 + 最近邻检索，不是真正带动作的规划器（如 CEM）。
  - **Thm 2 的离散/连续缝隙**：假设 (iii) 是离散时间的加性噪声，而附录 B 的证明借用常扩散下的连续时间生成元和 Sturm–Liouville 理论（"in continuous time, this is the constant-diffusion regime"），两者如何精确对上，正文没讲清楚，需核对。
  - **Lean 验证的分量**：推理链是机器验证的，但几条核心数学事实（Hermite 完备性、Mehler 公式、仿射得分 ⇒ 高斯等）是公理化引入的，"verified in Lean 4" 不等于从头证明。
  - **ImageNet-X 比较不完全对等**：LeJEPA 用的是 64 维投影头输出（理论所针对的空间），其他编码器用的是 768 维 CLS 的前 64 个主成分；附录 H.16 自己承认只是名义维度匹配、不是信息量匹配，而且 LeJEPA 骨干的有效维度更低，所以投影对 DINO/iBOT 丢掉的信息更多。
  - **实践含义有张力**：§8 建议预训练数据用"近似各向同性随机游走"的探索来保持在理论覆盖范围内，但真实机器人/视频数据恰恰是目标导向、非各向同性的（Reacher 的 RL 轨迹 R² ≤ 0.5），这限制了结论对 [[topics/notes/JEPA系列/1-05_LeWM|LeWM]] 一类模型的直接适用性。

## 与其他论文的关系

- **理论对象**：[[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]]（同两位作者 LeCun、Balestriero）。LeJEPA 证明"各向同性高斯对下游探针最优"，本文进一步证明"在高斯世界里 LeJEPA 的最优解就是真实潜变量的旋转"，并给出高斯唯一性的逆命题。
- **同一谱视角**：[[topics/notes/JEPA系列/3-01_KoopmanJEPA|Koopman Invariants]] 用 Koopman 算子特征值 1 的不变子空间解释 EMA 型 JEPA 的区制聚类；本文用转移算子（作者也称随机 Koopman 算子）的 Hermite 谱解释 SIGReg 型 JEPA 的线性可辨识。两篇都指向"JEPA 选最慢 / 最可预测的特征函数"，与 SFA 和 [[topics/notes/JEPA系列/2-04_JEPASlowFeatures|JEPA Slow Features]] 一脉相承。
- **后续与对照**：[[topics/notes/JEPA系列/3-03_BeyondGaussianWorlds|Beyond Gaussian Worlds]] 从标题看是把本文推广到非高斯世界；[[topics/notes/JEPA系列/2-07_MotionJEPA|MotionJEPA]]（Klindt、Balestriero 也是作者）引用本文，把 LeJEPA 的时间对齐目标和慢特征分析联系起来，并在实验上展示 SIGReg 型世界模型压掉快变特征。§8 提到动作条件世界模型可以用逆动力学正则代替各向同性高斯目标，作为非高斯潜变量的可辨识路线。
- **世界模型与规划**：[[topics/notes/JEPA系列/1-05_LeWM|LeWM]]（参考文献 [9]）是本文 Reacher 轨迹数据和"带预测器"设置的来源；Thm 4 的"直线计划"与 [[topics/notes/JEPA系列/1-04_TemporalStraightening|Temporal Straightening]]、[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 对潜空间几何的关注一致。
- **可辨识性文献**：非线性 ICA、时间对比学习（TCL/PCL）、对比学习可辨识（Zimmermann et al.）、增广可辨识（von Kügelgen et al.）；本文强调其 Hermite 方法适用于任意可测映射，而不只是光滑微分同胚。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> A representation that scrambles the true degrees of freedom of the world cannot support reliable planning or compositional generalization. We prove that LeJEPA (alignment plus Gaussian regularization) linearly recovers the world's latent variables from nonlinear observations, a property known as linear identifiability, in a class of worlds where latents evolve under stationary, additive-noise transitions. Our main result is that among all such worlds, the Gaussian is the unique latent distribution for which this guarantee holds. The forward direction rests on a spectral decomposition in which each degree of nonlinearity is strictly penalized by alignment, making the linear map the optimum; the converse rules out every non-Gaussian alternative. We further prove an approximate identifiability result where the guarantee degrades gracefully, and show that linear, orthogonal identifiability enables optimal latent-space planning. We validate the theory with experiments ranging from 2D examples to 4096-dimensional latents, including ablations, pixel-based robotic control, and natural images from ImageNet-X. Our theory turns an empirically successful recipe into a mathematical guarantee, providing the foundation for building World Models that provably recover the structure of the world.
