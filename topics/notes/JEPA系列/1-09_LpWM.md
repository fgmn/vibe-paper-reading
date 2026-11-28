---
id: "1-09"
org: 专题·JEPA系列
short: "LpWM"
title: "LpWM: A Case for Sparse Representations in World Models"
aliases: ["LpWM", "LpWorldModel", "A Case for Sparse Representations in World Models"]
date: 2026-08-24
category: "JEPA 世界模型与规划"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "NYU；AMI Labs；Duke University；Mila；Brown University"
partners: ["AMI Labs"]
authors: ["Yilun Kuang", "Yash Dagade", "Quentin Le Lidec", "Lucas Maes", "Randall Balestriero", "Yann LeCun"]
arxiv: "2608.22764"
pdf: "[[topics/papers/JEPA系列/1-09_2608.22764_LpWM.pdf]]"
code: "https://github.com/YilunKuang/lpworldmodel"
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "sparse-representation", "anti-collapse", "latent-planning", "linear-dynamics"]
---

# LpWM: A Case for Sparse Representations in World Models

> [!info] 论文信息
> arXiv [2608.22764](https://arxiv.org/abs/2608.22764) · v1 2026-08-24 · 28 页（正文 8 页 + 附录 A–H，附录 H 是大量超参扫描图）
> [代码](https://github.com/YilunKuang/lpworldmodel)
> PDF：[[topics/papers/JEPA系列/1-09_2608.22764_LpWM.pdf|本地 PDF]]
> 作者：Yilun Kuang（NYU、AMI Labs）、Yash Dagade（Duke）、Quentin Le Lidec（NYU、AMI Labs）、Lucas Maes（Mila、AMI Labs）、Randall Balestriero（Brown、AMI Labs）、Yann LeCun（NYU、AMI Labs）
> 专题：[[topics/JEPA系列#一、JEPA 世界模型与规划|JEPA系列 · 一]]

> [!note] 下面各节是 Claude 根据 PDF 全文（正文 + 附录 A–G、附录 H 的文字部分）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 研究问题："it remains unclear whether dense features are the most favorable geometry for modeling controlled dynamics."（§1，p.2）
> - 理论动机："sufficiently high-dimensional one-hot representations can approximate the dynamics with action-conditioned linear latent dynamics (Proposition 1), with rollout error vanishing as the dimension grows (Corollary 1)."（§1，p.2）
> - 不靠 stop-gradient 防坍塌："Importantly, LpWM does not rely on stop-gradient for collapse prevention"（§2.2，p.3）
> - 维度诅咒："the approximation error of one-step prediction under an exact one-hot sparse encoding decreases as O(N^{−1/d}), and therefore suffers from the curse of dimensionality."（§3.1，p.5）
> - Wall 太简单："even the simplest linear LTI(1) predictor reaches nearly 100% closed-loop CEM success rate for both LeWM and LpWM"（§3.3，p.5）
> - 差距出现在中等容量："on PushT, sparse LpWM improves planning success over dense LeWM by 24%–57% with MLP◦LTI(k), 36%–45% with MLP◦LTV(k), and 11%–23% with LTI(k)."（§3.3，p.6）
> - 高容量下无差别："Deep-AdaLN(k) and Shallow-AdaLN(k) perform similarly for both representations"（§3.3，p.6）
> - mode-factored 定义："We call a representation mode-factored when its binary support primarily identifies the discrete dynamics regime, while feature magnitudes capture finer within-regime state."（§4，p.7）
> - 不加时间先验时支撑集是运动检测器："without temporal regularization, support instability behaves largely as a motion detector"（§4.2，p.8）
> - 扫描只用一个训练种子："Due to compute constraints, we fix one seed for training but average over 3 seeds during planning evaluations"（附录 H.1，p.19）

## 一句话总结

LeWM 一类 JEPA 世界模型用 SIGReg/VICReg 把潜变量往各向同性高斯推，得到**稠密**表征；本文问：**稀疏**表征会不会让动作条件的潜动力学更好学？理论上，紧致状态空间上的 Lipschitz 动力学可以用足够高维的 one-hot 编码 + 动作条件线性转移任意逼近（误差 O(N^{−1/d})）。实践上用 RDMReg 把编码器输出（过 ReLU）匹配到 Rectified Laplace 分布，得到非负、约 30–65% 非零的稀疏码，即 **LpWM**。PushT 上在中等容量的预测器（MLP∘LTI、MLP∘LTV、LTI）下比稠密 LeWM 规划成功率高 11%–57%，高容量 DiT 预测器下两者持平；稀疏码还是 mode-factored 的——支撑集编码离散动力学区域（Piecewise 环境里区域可解码 94–99%），数值大小编码区域内连续状态。

## 要解决什么问题

- 端到端训练的 JEPA 世界模型需要防坍塌项：PLDM 用 VCReg，LeWM 用 SIGReg。这类信息最大化目标产生**稠密**表征（几乎所有坐标非零）。
- 稠密是否是建模**受控动力学**最合适的几何？作者的直觉来自理想极限：状态空间量化成足够细的格子、用 one-hot 编码时，动力学在潜空间里就是一个动作条件的置换矩阵 P(a)，完全线性（类似经典符号抽象 / Koopman 提升）。
- 精确 one-hot 不可学且需要指数级维度，于是退一步用**分布式稀疏码**作为可学的松弛，检验它是否降低所需的预测器复杂度。
- 同时问：稀疏码里会出现什么样的动力学结构（支撑集 vs 数值大小）。

## 方法

### LpWM 目标（§2.1，式 1–2）

min_{θ,φ} ‖ẑ_{t+1} − z_{t+1}‖² + λ_RDMReg · R(z_{t+1})

- **RDMReg**（来自 Rectified LpJEPA，Kuang et al. 2026b）：R(z) = E_c L(P_{cᵀz} ‖ P_{cᵀy})，c 在单位球上均匀采样（随机切片），目标 y 的每一维服从 ReLU(GN_p(μ, σ))（Rectified Generalized Gaussian），L 用 2-Wasserstein 距离。
- 默认 μ=0、σ=1/2、p=1 → **Rectified Laplace**；Generalized Gaussian 是期望 ℓ_p 范数约束下的最大熵分布，p≤1 给稀疏目标。μ 控制稀疏度（§3 扫 μ ∈ {0, −1, −2}）。
- μ=0、σ=1、p=2 且不加 ReLU 时退化为 LeWM 的各向同性高斯。

### 架构与整流（§2.2）

- 按 LeWM：ViT 编码器 CLS token → 三层 MLP 投影头；预测器是 AdaLN-zero 动作条件的 transformer + 三层 MLP 投影头。
- 编码器和预测器的投影输出都过 **RepReLU**：前向 = ReLU（得到精确零），反向梯度走 GELU（防 dying ReLU）。作者强调**防坍塌不靠 stop-gradient**，普通 ReLU + RDMReg 也能训练不坍塌，RepReLU 只是防死神经元的保险。
- 规划：CEM 最小化 ‖ẑ_T − z_g‖²（300 候选、30 精英、30 轮，H=5，frameskip 5 → 目标 25 步外）。

### 理论（§3.1，附录 G）

- **命题 1**：紧致状态空间 X、紧致动作空间 A、状态上一致 L-Lipschitz 的确定性系统，对任意 ε>0 存在有限维 N、one-hot 编码器、解码器和动作条件 0/1 矩阵 P_ε(a)，使 z_{t+1} = P_ε(a_t) z_t 精确线性，单步解码误差 ≤ (L+1)ε。证明就是有限覆盖 + 量化。
- **引理 1**：H 步 rollout 误差 ≤ ε Σ_{k=0}^{H} L^k。
- **推论 1**：X=[0,1]^d、每维 n 等分（N=n^d 格）时 ε_N = (√d/2) N^{−1/d}，单步误差 O(N^{−1/d})，固定 H 时 N→∞ 误差趋零。作者承认有维度诅咒，所以只把它当"高维稀疏能简化转移"的动机。

### 预测器复杂度阶梯（表 1、表 2）

| 预测器 | 层 | 历史 k | 形式 | D=384 参数量 | D=4096 参数量 |
|---|---|---|---|---|---|
| Deep-AdaLN(k)（LeWM 用的） | 6 | 3 | σ(AdaLN⁽⁶⁾(z_{t−k+1:t}, a_t)) | 25.8M | 822.4M |
| Shallow-AdaLN(k) | 1 | 3 | σ(AdaLN⁽¹⁾(·)) | 5.6M | 151.1M |
| MLP∘LTV(k) | 1 | 3 | σ(W ReLU(Σ A_i(z_t) z_{t−i} + B(z_t) a_t)) | 0.81M | 84.7M |
| MLP∘LTI(k) | 1 | 3 | σ(W ReLU(Σ A_i z_{t−i} + B a_t)) | 0.74M | 83.9M |
| LTI(k) | 1 | 3 | σ(Σ A_i z_{t−i} + B a_t) | 0.59M | 67.1M |
| LTI(1) | 1 | 1 | σ(A z_t + B a_t) | 0.30M | 33.6M |

- σ：LeWM 为恒等，LpWM 为 RepReLU（所以 LpWM 的 LTI 并不严格线性，作者在附录 B 承认）。
- MLP∘LTV 的状态依赖算子：A_i(z_t) = A_i + U_i diag(g_i(z_t)) V_iᵀ，g = sigmoid(G z_t) 选 r=16 个低秩模式；U_i 零初始化，初始时与 MLP∘LTI 完全一致。
- 潜维度 D ∈ {384, 768, 1536, 2048, 4096}，用 **μP** 稳定跨宽度训练（基准宽度 384，学习率 ∝ D₀/D）。

### 可选的 Temporal Jaccard 损失（附录 E）

软 Jaccard J_S(x,y) = Σmin(x_i,y_i) / (Σmax(x_i,y_i)+ε)；L_TJ = 相邻帧 1 − J_S 的平均，作为支撑集上的"慢度先验"，不干扰 RDMReg 的稀疏约束。

### 实验配置（表 5）

| | Wall | PushT | Piecewise | OGBench-Cube |
|---|---|---|---|---|
| 编码器 | 从零 ViT，12 层，宽 384 | 同左 | 从零 ViT-Tiny，宽 192 | 同左 |
| 预测器 | 表 1 全部 | 表 1 全部 | Deep-AdaLN(k) | Deep-AdaLN(k) |
| D | 384–4096 | 384–4096 | 192 | 192 |
| 历史 k | 1 | 3 | 3 | 3 |
| 批 / epoch | 128 / 20 | 64 / 2 | 128 / 10 | 128 / 10 |
| 正则权重 λ | 扫描 | 扫描 | 25 | 10 |
| 投影数 | 8192 | 8192 | 1024 | 1024 |
| μ | {0,−1,−2} | {0,−1,−2} | 0 | 0 |
| TJ 权重 | 关 | 关 | {0, 0.01} | {0, 0.005, 0.01, 0.05, 0.1} |

§3 两个环境评估 50 条轨迹（目标来自评估集），报开环（只规划一次）和闭环（每 5 个动作重规划、最多 10 次）成功率。

## 实验与关键数字

### 1. Wall：线性预测器就够（§3.3，图 3a）

最简单的 LTI(1) 闭环 CEM 成功率对 LeWM 和 LpWM 都接近 100% → Wall 的潜动力学可以用线性模型描述，区分不出稀疏和稠密。只有散点图，没有数值表。

### 2. PushT：中等容量下稀疏明显更好（§3.3，图 1b）

| 预测器 | LpWM 相对 LeWM 的成功率差 |
|---|---|
| Deep-AdaLN(k)、Shallow-AdaLN(k) | 持平（预测器复杂度饱和） |
| MLP∘LTI(k) | +24% ~ +57% |
| MLP∘LTV(k) | +36% ~ +45% |
| LTI(k) | +11% ~ +23% |
| LTI(1) | 两者都失败 |

- 范围是跨 5 种潜维度的差值；原文用"%"，从图 1b 的箭头说明看应是**成功率的百分点差**（"success-rate difference"），不是相对提升——需核对。
- 绝对成功率只在图里（以及附录 H 的扫描热图），正文没有数值表。
- 作者说这些差距经过双方大量超参扫描验证（附录 H.1：λ ∈ {0.01, 0.1, 1, 10} × μP 学习率 ∈ {0.05, 0.005, 5e-4, 5e-5}）。
- 稀疏度（表 3）：各预测器、各维度下 LpWM 编码的非零比例约 0.28–0.63（LTI(1) 最高，0.56–0.63），LeWM 为 1.0。

### 3. 与 VICReg 比较（图 3b，附录 H.2）

把 LeWM 的 SIGReg 换成 VICReg 得到另一个稠密基线："VICReg"。LpWM 在 Deep-AdaLN(k)、MLP∘LTV(k)、MLP∘LTI(k) 上都胜过它，**连高容量 Deep-AdaLN 也胜**。作者推测 VICReg 只约束二阶矩，目标分布欠定。

### 4. Piecewise：支撑集恢复分段仿射结构（§4.1，图 2，表 4）

Piecewise：224×224 空房间分成 g×g 区域，每个区域给运动加固定偏置 b_i，动力学局部线性、全局分段仿射，区域划分已知。

成功率（表 4，%，50 个测试样本，3 种子）：

| 环境 | 方法 | 目标来自评估集 H=R=5 | 随机目标 H=5, R=1 | 随机目标 H=R=5 |
|---|---|---|---|---|
| 2×2 | LpWM | 99.33±1.15 | **84.67±4.16** | 59.33±2.31 |
| 2×2 | LpWM+TJ | 99.33±1.15 | 82.67±5.03 | **68.67±4.62** |
| 2×2 | LeWM | 99.33±1.15 | 65.33±4.16 | 36.00±3.46 |
| 3×3 | LpWM | 100.00±0.00 | 58.67±1.15 | 56.00±4.00 |
| 3×3 | LpWM+TJ | 100.00±0.00 | **60.00±2.00** | **58.00±5.29** |
| 3×3 | LeWM | 100.00±0.00 | 50.00±5.29 | 47.33±6.11 |

- 评估集目标下全部饱和，随机目标下 LpWM 明显更好。
- 20×20 网格上，每格嵌入二值化成支撑集，与参考格的 Jaccard 在同一区域内高、跨区域边界骤降；**区域没有视觉提示时也成立** → 支撑集是从动作条件预测中学到动力学区域，而不只是外观。
- 线性探针：二值支撑集解码区域身份和完整嵌入一样准（结论里说 94–99%），智能体位置从数值大小解码得更好 → "支撑集 = 离散模式，数值 = 区域内状态"。
- 规划随时域 H 增加，两种稀疏变体在每个 H 都胜过 LeWM，差距随 H 拉大（图 2c）。

### 5. OGBench-Cube：要加时间先验支撑集才跟踪接触（§4.2，图 4）

用相邻帧"支撑集不稳定度" 1 − J(z_t, z_{t+1}) 与末端运动、方块运动、夹爪接触算 Pearson 相关。

| TJ 权重 | 与末端运动 r | 与方块运动 r | 与夹爪接触 r |
|---|---|---|---|
| 0（不加 TJ） | 0.87 | 0.26 | 0.05 |
| 0.1 | 0.40 | 0.80 | 0.61 |

（图 4a 说明里的汇总值；规划成功率不变。）
- 不加 TJ 时 RDMReg 只约束逐帧边缘分布，支撑集跟着最主要的快变信号走，基本是个**运动检测器**。
- 加 TJ 后支撑集随时间平滑，在接触窗口内重组。作者把这列为 vanilla LpWM 的局限。

## 局限 / 存疑

> 论文没有单独的"局限"一节；第 1、2、5 条是作者在正文/附录里自己承认的，其余是 Claude 的推断，请核对。

- **理论与实践之间距离大**：命题 1 依赖 one-hot 和指数级维度（O(N^{−1/d}) 的维度诅咒），而 LpWM 的码有 30–65% 非零，离 one-hot 很远；RepReLU 输出层也让 LTI 预测器不再严格线性。理论只是动机，不解释为什么分布式稀疏码有效。
- **vanilla LpWM 的支撑集不一定对应有语义的事件**（§4.2）：需要额外的 Temporal Jaccard 先验。
- **优势只在"中等容量"区间**：PushT 上高容量 DiT 预测器（即 LeWM 实际用的配置）两者持平；Wall 上线性就够。作者推测动力学更复杂时优势会扩展到更强预测器，但没验证。
- **主结果只有图**：PushT 的 11%–57% 是从图 1b 读的差值区间，没有绝对成功率表；"%"是百分点还是相对值需核对。
- **统计力度**：附录 H 的扫描只用 1 个训练种子（规划评估 3 个种子），而且扫描是顺序做的、逐步删网格，不同预测器覆盖的超参子集不同（作者自己说明）。OGBench-Cube 的评估目标只在 25 步外，作者承认可能饱和、区分力有限。
- **LeWM 基线不是原版**：为统一扫描，"LeWM"用的是切片 Wasserstein 匹配高斯，而不是 SIGReg 的 Epps–Pulley 检验（附录 H.1）。作者说两者都是 Cramér–Wold 的实例，但严格说比较的是"同一框架下的高斯目标 vs Rectified Laplace 目标"。
- **数字表述需核对**：§4.2 正文说方块运动相关从 r=0.21 升到 0.80，图 4a 说明汇总值是 0.26→0.80；0.21 其实是图 4b 单个示例回合的值（r_cube=0.21 → 0.80），正文把两者混用了。
- PushT 只训 2 个 epoch、批 64（表 5），而 Wall 训 20 epoch；附录 C.1 提到 TwoRoom 数据，但正文没有 TwoRoom 结果。
- 全部是仿真小环境（Wall、PushT、Piecewise、OGBench-Cube），没有真实视频或大规模预训练。

## 与其他论文的关系

- **直接对照**：[[topics/notes/JEPA系列/1-05_LeWM|LeWM]]——同一套编码器 / 预测器 / 规划器，LpWM 只把防坍塌目标从各向同性高斯换成 Rectified Laplace（两篇共享 Lucas Maes、Quentin Le Lidec、Balestriero、LeCun）。
- **防坍塌谱系**：SIGReg 来自 [[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]]；RDMReg 来自同一作者的 Rectified LpJEPA（2602.01456，不在本系列）；[[topics/notes/JEPA系列/1-03_PLDM|PLDM]] 用 VCReg；本系列 [[topics/notes/JEPA系列/3-03_BeyondGaussianWorlds|Beyond Gaussian Worlds]] 也质疑高斯目标，可对照。
- **潜空间几何改造**：相关工作提到 [[topics/notes/JEPA系列/1-04_TemporalStraightening|Temporal Straightening]]（曲率正则）、SCALE、[[topics/notes/JEPA系列/1-07_AdaJEPA|AdaJEPA]]（测试时在线适配最后几层）；[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 讨论防坍塌方式如何决定几何，和本文"稀疏 vs 稠密几何"是同一类问题。Temporal Jaccard 相当于支撑集上的慢度先验，与 Content–Geometry Tradeoff 的慢通道思路相近。
- **线性化动力学**：Koopman / DMDc / SINDy；本系列 [[topics/notes/JEPA系列/3-01_KoopmanJEPA|Koopman-JEPA]] 从 Koopman 角度看 JEPA，可对照"线性潜动力学"这条线。
- **离散 / 稀疏世界模型**：DreamerV2 的类别潜变量、Variational Sparse Gating；本文是连续、非负、支撑集不固定的稀疏码。
- 规划协议沿用 [[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]] 的数据与 CEM 设置。
- 库里其他 JEPA 笔记：[[xsquare/notes/23_EgoJEPA|EgoJEPA]]。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Joint-embedding predictive architectures (JEPAs) learn latent dynamics for planning and avoid representation collapse by matching features to maximum-entropy distributions such as isotropic Gaussians, yielding dense representations. However, it is unclear whether dense representations are the most favorable geometry for modeling dynamics. In this work, we ask whether a different geometry—sparse representations—can make action-conditioned latent dynamics easier to model, and what dynamical structure emerges from such representations. We first show that nonlinear Lipschitz dynamics can be approximated arbitrarily well by action-conditioned linear dynamics in a sufficiently high-dimensional one-hot latent space, with rollout error vanishing as the dimension grows. This motivates distributed sparse representations as a practical relaxation of one-hot sparsity. We introduce LpWorldModel (LpWM), a JEPA model regularized with Rectified Distribution Matching Regularization (RDMReg) to match encoder features to a Rectified Generalized Gaussian distribution, yielding non-negative sparse codes. Empirically, sparsity lowers the predictor complexity required for successful planning: on PushT, sparse LpWM outperforms dense LeWM by up to 57% in planning success at intermediate predictor capacities. This advantage also extends beyond Gaussian distribution matching, with LpWM outperforming dense VICReg representations across multiple predictor families. We further find that the learned sparse representations are mode-factored, with support encoding discrete dynamical regimes and feature magnitudes capturing continuous within-regime state. Together, these results suggest that sparse representations can reduce the predictor complexity required for control while revealing interpretable structure.
