---
id: "3-04"
org: 专题·JEPA系列
short: "I Act Therefore I Am"
title: "I Act Therefore I Am: When is JEPA's Action-Conditioning Enough to Learn Causal Mechanisms?"
aliases: ["I Act Therefore I Am", "A-JEPA", "Action-Modulated JEPA", "When is JEPA's Action-Conditioning Enough to Learn Causal Mechanisms?"]
date: 2026-09-25
category: "JEPA 理论"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "Responsible AI Research Centre（Australia）；Australian Institute for Machine Learning, Adelaide University"
partners: []
authors: ["Yuhang Liu", "Zhuo Huang", "Javen Qinfeng Shi"]
arxiv: "2609.31161"
pdf: "[[topics/papers/JEPA系列/3-04_2609.31161_IActTherefore.pdf]]"
code: ""
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "identifiability", "causal-representation-learning", "world-model", "action-conditioned", "nonlinear-ica"]
---

# I Act Therefore I Am: When is JEPA's Action-Conditioning Enough to Learn Causal Mechanisms?

> [!info] 论文信息
> arXiv [2609.31161](https://arxiv.org/abs/2609.31161) · v1 2026-09-25 · 35 页（正文 9 页 + 附录 A–L，含证明）
> PDF：[[topics/papers/JEPA系列/3-04_2609.31161_IActTherefore.pdf|本地 PDF]]
> 作者：Yuhang Liu（Responsible AI Research Centre、AIML Adelaide）、Zhuo Huang（AIML Adelaide）、Javen Qinfeng Shi（Responsible AI Research Centre、AIML Adelaide）
> 论文没给代码链接。注意：提出的方法叫 **A-JEPA**，和 2023 年音频 JEPA "A-JEPA: Joint-Embedding Predictive Architecture Can Listen"（本文参考文献里也引了）重名。
> 专题：[[topics/JEPA系列#三、JEPA 理论|JEPA系列 · 三]]

> [!note] 下面各节是 Claude 根据 PDF 全文（正文 + 附录 B、C、F–L；定理 3.3 的证明只看了思路）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 核心问题："accurate prediction does not, in general, necessarily imply recovery of underlying causal states that give rise to the observed dynamics."（Abstract，p.1）
> - 研究问题："When and how can JEPA recover the underlying causal states from observational data?"（§1，p.2）
> - 两条原则："Transition Predictiveness … Information Preservation."（§2.2，p.3）
> - 定理 2.1 的不足："the learned representation may still correspond to non-trivial mixtures of the underlying latent causal states, e.g., through an orthogonal transformation."（§2.2，p.4）
> - 首个逐分量结果："To the best of our knowledge, this is the first component-wise identifiability result within the JEPA framework."（§1，p.2）
> - 关键条件："JEPA can identify the underlying latent causal states when the observed actions induce sufficiently rich variation in the transition mechanisms."（§3，p.4）
> - 信息保留 ≠ 逐分量恢复："on OGB, PLDM achieves nonlinear state R2 = 0.989 but an MCC of only 0.485."（§5.2，p.9）
> - 关联而非因果："this establishes an empirical association rather than implying that component-wise identifiability alone guarantees improved rollout performance."（§5.2，p.9）
> - LeWM 的旋转不变性："the LeWM objective does not, by itself, distinguish a latent representation from its orthogonal mixtures."（附录 K，p.33）
> - 两级坍塌："Resolving this second level therefore requires additional identifying structure rather than stronger anti-collapse regularization."（附录 L，p.35）

## 一句话总结

预测准不等于恢复了真正的因果状态：Klindt et al. 证明 JEPA 在高斯隐变量模型下只能恢复到**正交变换**，表征可能是因果变量的混合。本文给 JEPA 套上一个"隐因果状态 + 动作调制的时序 SCM 转移 + 可逆观测"的生成模型，提出信息论目标"条件似然最大化（转移可预测）+ 熵最大化（保留信息）"，证明当**不同动作足够多样地改变转移机制**（2d+1 个动作使一个由对数密度一、二阶导组成的矩阵满秩）时，全局最优编码器能把隐因果状态恢复到**置换 + 逐分量可逆变换**。按这个结论实例化出 A-JEPA：动作同时调制均值和方差的高斯加性噪声转移 + 对比式熵替代项。合成数据上 MCC 约 0.90–0.96，四个视觉控制环境 MCC 都高于 LeWM / PLDM；RoboNet 换机器人零样本 20 步 rollout R² 保持 >0.90（Franka 0.910，LeWM 0.012）。

## 要解决什么问题

- JEPA 世界模型（V-JEPA 2、LeWM 等）预测效果好，[[topics/notes/JEPA系列/3-02_WhenLeJEPAWorldModel|Klindt et al. 2026]] 也给出了理论保证——但只到"线性 / 正交变换"。**正交混合的表征同样可以预测得很准**，却没有把各个因果变量分开；分开的因果机制才更可能在环境变化（换机器人、换外观）时迁移。
- 已有的因果 JEPA（[[topics/notes/JEPA系列/1-11_Causal-JEPA|Causal-JEPA]] 的物体级掩码）靠启发式归纳偏置，没有形式化的恢复保证。
- 问：**什么时候**（条件）、**怎么**（目标与模型）JEPA 能从观测中恢复隐因果状态？

## 方法

### 生成模型（§2.1）

- 隐状态 s_t ∈ R^d，动作 a_t（观测到的外生输入），观测 x_t。时序 SCM：s_{t,i} := f_i(s_{t−1, pa_i}, a_{t−1}, ε_{t,i})，x_t := g(s_t)。pa_i 是 s_{t,i} 在上一时刻的因果父节点，图是 DAG。
- 外生噪声相互独立、且独立于 (s_{t−1}, a_{t−1}) → 转移分解为 p(s_t | s_{t−1}, a_{t−1}) = Π_i p(s_{t,i} | s_{t−1,pa_i}, a_{t−1})。

### 信息论 JEPA 目标（§2.2，式 4）

L_λ(h, φ) = −E[log p_φ(z_t | z_{t−1}, a_{t−1})] − λ H(z_t)，z_t = h(x_t)。

第一项是**转移可预测性**（条件似然），第二项是**信息保留**（表征的微分熵）。

**定理 2.1**：观测按式 (1)(2) 生成，h : X → (0,1)^d，(h*, φ*) 是 λ ≥ 1 时达到下界的全局极小元，则
- I(z_t; z_{t−1}, a_{t−1}) = I(s_t; s_{t−1}, a_{t−1})（表征保留了全部与转移相关的信息）；
- p_{φ*}(z_t | z_{t−1}, a_{t−1}) = Q_{h*}(z_t | z_{t−1}, a_{t−1}) a.e.（学到的转移模型等于表征空间里诱导的转移分布）。

证明思路（附录 C）：NLL = H(z_t | c_t) + E[KL(Q_h ‖ p_φ)]，代入后 L_λ + I(s_t; s_{t−1}, a_{t−1}) 拆成三个非负项（数据处理不等式缺口、KL、(λ−1)(−H(z_t))，后者因 (0,1)^d 上 H ≤ 0 而非负）。λ > 1 时还推出 z_t ~ Unif((0,1)^d)。
作者强调这只是信息层面的保证，**仍允许非平凡混合**（如正交变换）。

### 逐分量可辨识（§3）

- **假设 3.1**：g 光滑可逆。
- **假设 3.2（动作变异性）**：对任意 s_t，存在 2d+1 个动作 a^{(0)},…,a^{(2d)}，使矩阵 L = [w(s_t, s_{t−1}, a^{(1)}) − w(·, a^{(0)}), …, w(·, a^{(2d)}) − w(·, a^{(0)})] 可逆，其中 q_i = log p(s_{t,i} | s_{t−1,pa_i}, a_{t−1})，w = (∂q_1/∂s_{t,1}, …, ∂q_d/∂s_{t,d}, ∂²q_1/∂s²_{t,1}, …, ∂²q_d/∂s²_{t,d})^⊤ ∈ R^{2d}。直觉：不同动作要足够多样地改变每个隐变量的转移机制，给每个变量留下可区分的"签名"。
- **定理 3.3**：在假设 3.1、3.2 下，令 h : X → (0,1)^d 是 λ > 1 时式 (4) 某个全局极小元对应的光滑编码器，则 z_t = (r_1(s_{t,π(1)}), …, r_d(s_{t,π(d)}))，π 是置换，r_i 是一维可逆变换。
- 证明三步（附录 D）：① 由定理 2.1 的信息保留 + 动作变异性得 r = h∘g 的 Jacobian 处处满秩（局部可逆）；② 用局部逆和假设 3.2 证明逆 Jacobian 每行至多一个非零元；③ 合起来是广义置换矩阵，域正则时置换模式全局固定。
- 这类变异性条件来自非线性 ICA（Hyvärinen & Morioka、iVAE）和因果表征学习的已有工作，作者在附录 B 局限里承认。

### A-JEPA：动作调制的高斯 ANM（§4）

- 隐空间实例化：s_{t,i} = f_i(s_{t−1,pa_i}, a_{t−1}) + σ_i(a_{t−1}) ε_{t,i}，ε ~ N(0,1)。此时 ∂q_i/∂s_{t,i} = −(s_{t,i} − f_i)/σ_i²，∂²q_i/∂s²_{t,i} = −1/σ_i²：动作改变均值影响一阶导，改变方差同时影响一、二阶导 → 假设 3.2 变成"动作要足够多样地改变条件均值和方差"。
- 表征空间转移模型镜像这一结构：p_φ(z_t | z_{t−1}, a_{t−1}) = Π_i N(z_{t,i}; μ_{φ,i}(z_{t−1,pa_i}, a_{t−1}), σ²_{φ,i}(a_{t−1}))，NLL 为式 (14)。
- 熵项难估计，用**对比式替代**（依据 Wang & Isola 2020 等关于负样本对比学习与熵正则的渐近联系，附录 E）：从 minibatch 里取 K 个其他转移的未来表征当负样本，在同一转移模型下打分。实用目标（式 15）：

  L = E[α·NLL_φ(z_t | z_{t−1}, a_{t−1}) + (1−α)·log (1/K) Σ_k exp(−NLL_φ(z_t^{(k)} | z_{t−1}, a_{t−1}) / τ)]

- 实现细节（附录 F–H）：编码器输出经 sigmoid 映到 (δ, 1−δ)；每个坐标一个独立 MLP 预测均值（按预设因果序只看 ≤i 的坐标 + 动作），方差由动作单独预测、log 方差截断到 [−1, 1]；图恢复用可学门控 g_ji + ℓ1 稀疏（式 70）再阈值化。默认 α = 0.51、τ = 1.0。
- 附录 K：LeWM 可以看成本文目标的受限特例——固定各向同性方差的高斯 NLL 就是 MSE；在固定一、二阶矩下各向同性高斯是最大熵分布，所以 SIGReg 是熵最大化的受限实现。但 MSE 和各向同性高斯都对正交旋转不变，**LeWM 的目标本身无法区分表征与其正交混合**。
- 附录 L：区分两级"坍塌"——Level I 信息丢失（常数解，防坍塌机制能解决）；Level II **信息保留下的表征混合**（体积保持变换不改变熵，熵最大化解决不了），需要额外的可辨识结构，这里就是动作诱导的机制变化。

## 实验与关键数字

### 1. 合成数据（§5.1，图 1–3；数字只在正文给出，没有表格）

数据按 §4 的动作调制高斯 ANM 生成：时序 DAG（每个变量至多 3 个父节点含自身）、动作 2d 维（前一半调均值、后一半调方差）、**动作在每个 episode 内固定、跨 episode 变化**、观测由随机正交变换 + LeakyReLU 的可逆混合得到。指标：Spearman MCC（匈牙利匹配后取平均）；图恢复用 F1 / precision / recall / SHD。

| 分析 | 结果 |
|---|---|
| 权衡参数 α（图 1a） | α < 0.50 时 MCC 低；α ≈ 0.51 时峰值 **0.9479**，再往似然一侧加权逐渐下降 |
| 动作设置数（图 1b，d=5） | 5 个动作 MCC 0.8566 → 50 个 0.9588，逐渐饱和 |
| 隐维数 d = 5 → 10（图 1c） | A-JEPA MCC 保持 0.90–0.96，明显高于 LeWM 式和 PLDM 基线（具体数字只在图里） |
| 门控稀疏度（图 2a） | MCC 稳定在约 0.96；图恢复对稀疏正则更敏感，最佳区间 edge F1 约 0.70 |
| 图恢复随 d（图 2b,c） | precision 高、recall 中等，SHD 随维数上升 |
| 观测可逆性（图 3a） | 逐步删观测坐标，MCC 从 0.9584 降到 0.5312 |
| 只调均值或只调方差（图 3b） | 各维度上恢复都下降，支持假设 3.2 |
| 噪声失配（图 3c） | Laplace、Student-t 几乎无影响；Uniform 噪声下降更多 |

### 2. 四个视觉控制环境（§5.2，图 4）

TwoRoom、OGBench Cube、Reacher、PushT；与 LeWM、PLDM 对比，三者共用同一个紧凑 CNN 编码器（4 个卷积块 32–256 通道）、动作表示、隐维度、frame skip 5、优化器设置，从零训练 10 epoch，3 个种子。三类指标：MCC（逐分量对齐）、非线性 state R²（信息保留）、rollout R²（多步动作条件预测）。

- A-JEPA 在四个环境的 **MCC 都高于两个基线**（正文没给具体数，只有图）。
- **信息保留 ≠ 逐分量恢复**：OGB 上 PLDM 非线性 state R² = 0.989，但 MCC 只有 0.485。
- rollout：A-JEPA 长时域更稳，Reacher 和 PushT 上改善尤其明显。作者明说这只是经验关联，不说明逐分量可辨识本身保证 rollout 更好。
- 选维度跑（附录 H，单次选择运行）：TwoRoom d_z=10（rollout R²_{h=5} 0.6343）；Reacher d_z=6（MCC 0.926，R²_{h=5} 0.973）；PushT d_z=10（MCC 0.620，R²_{h=5} 0.919）；OGB Cube d_z=14（MCC 0.865，R²_{h=5} 0.999，h=10 时 0.9940±0.0051；物体高度和夹爪开合仍难恢复）。注意维度是按"MCC + rollout"联合挑的。
- Reacher 干预实验（附录 I，定性）：MCC 把 z0 对到近端关节（约 0.80）、z3 对到远端关节（约 0.89），学到的门控图有 z0 → z3 边；干预 z0 同时改变两段臂，干预 z3 只改远端——与两连杆的物理依赖方向一致。

### 3. RoboNet 跨机器人迁移（§5.3，附录 J 表 1）

在 Baxter、Kuka、WidowX 上训练（9,300 个转移样本），**不适配**直接在 Franka、Sawyer 上做 20 步隐空间 rollout，指标是预测隐状态与真实未来帧编码之间的 rollout R²。三者编码器、隐维度 8、训练设置一致，3 个种子。

| 机器人 | 步数 h | A-JEPA | LeWM | PLDM |
|---|---|---|---|---|
| Franka | 1 | 0.9691±0.0088 | 0.6154±0.2418 | 0.4486±0.4487 |
| Franka | 20 | **0.9099±0.0167** | 0.0119±0.1864 | −8.7251±6.7523 |
| Sawyer | 1 | 0.9816±0.0051 | 0.8782±0.0225 | 0.6821±0.0550 |
| Sawyer | 20 | **0.9028±0.0159** | 0.5155±0.0351 | −13.3202±8.2978 |

- PLDM 从 h=2–3 起 R² 变负并持续发散；LeWM 在 Franka 上逐步退化到接近 0。

## 局限 / 存疑

> 附录 B 是作者自己的局限（可逆观测、动作变异性假设难以在真实场景验证）；其余是 Claude 的推断，请核对。

- **假设难以验证**（作者自承）：g 光滑可逆、2d+1 个动作使矩阵 L 满秩。真实环境里动作往往只影响少数变量（比如 PushT 里方块只在接触时才受动作影响），"每个隐变量的转移都被动作足够多样地调制"未必成立。
- **合成数据里动作在 episode 内固定**，每个 episode 相当于一个不同的"机制环境"，这更接近非线性 ICA 的多环境 / 辅助变量设定，而不是常规控制里逐步变化的动作。
- **理论目标与实用目标之间有缺口**：定理针对总体上的条件似然 + 微分熵、全局最优；实践用对比式替代熵、有限样本、梯度优化。作者在局限里也说要"更紧的连接"。
- **视觉实验的定量证据偏弱**：图 4 的主要比较没有给数字表，只有图；隐维度按 MCC 和 rollout 联合挑选（A-JEPA 的维度在各环境不同，基线用同一维度），可能有利于 A-JEPA；基线是"保留原目标、共享 CNN 编码器、从零训练 10 epoch"的复现，未必是基线的最佳设置。
- **rollout R² 的比较对象是各自编码器的未来编码**，不是共同的真值空间；不同方法的表征尺度和坍塌程度会影响这个 R²，跨方法比较时需谨慎（Claude 推断）。
- **RoboNet 训练集很小**（9,300 个转移）、训练 5 epoch，表 1 没列 h=5、h=10 两行；PLDM 的大负值方差很大（±6–8），说明它在这个设定下可能基本没训好。
- MCC 只看匹配后的单坐标相关，TwoRoom 只评估 (x, y) 两个因子、Reacher 用分组圆坐标、PushT 额外加了两个有限差分运动因子——评估因子的选择会影响 MCC。
- 没有规划 / 控制任务的成功率，只评表征和预测。

## 与其他论文的关系

- **理论起点**：[[topics/notes/JEPA系列/3-02_WhenLeJEPAWorldModel|When Does LeJEPA Learn a World Model?]]（Klindt et al.）给出高斯模型下到正交变换的可辨识；本文把它推进到动作条件下的**逐分量**可辨识。同期的 [[topics/notes/JEPA系列/3-03_BeyondGaussianWorlds|Beyond Gaussian Worlds]] 走另一条路：推广到流形隐空间，仍是线性 / 正交可辨识——两篇都指出各向同性高斯目标的旋转不变性是辨识的瓶颈。
- **基线**：[[topics/notes/JEPA系列/1-05_LeWM|LeWM]]（附录 K 把它解释为本文目标的受限特例：MSE = 固定各向同性方差的高斯 NLL，SIGReg = 固定矩下的最大熵）；[[topics/notes/JEPA系列/1-03_PLDM|PLDM]]。环境 TwoRoom 来自 PLDM，PushT 来自 [[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]]，OGBench Cube 也是 [[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 用的任务。
- **因果世界模型**：[[topics/notes/JEPA系列/1-11_Causal-JEPA|Causal-JEPA]] 用物体级掩码当因果归纳偏置，本文批评其缺少形式化保证。
- **防坍塌视角**：附录 L 的"两级坍塌"给 [[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]]、[[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]]、VICReg、I-JEPA 的 stop-gradient 等防坍塌讨论加了一个维度：防坍塌只解决信息丢失，不解决混合。
- **非线性 ICA / 因果表征学习**：TCL、iVAE、TDRL、CITRIS、作者此前的 latent polynomial causal models 等；假设 3.2 的形式直接来自这条线。
- 系列总览：[[topics/JEPA系列]]。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Recent empirical and theoretical advances suggest that joint-embedding predictive architectures (JEPAs) may learn meaningful representations for action-conditioned prediction of future outcomes, thus becoming one of the foundational structures for world models. However, accurate prediction does not, in general, necessarily imply recovery of underlying causal states that give rise to the observed dynamics. This work investigates when and how JEPAs can recover the underlying causal states from observations. We first introduce a latent variable model, in which high-dimensional observations are generated from latent causal states whose dynamics are governed by action-conditioned transition mechanisms. Based on this formulation, we develop a general information-theoretic objective that combines conditional likelihood maximization for learning transition dynamics with entropy maximization for preserving latent state information. We then establish identifiability conditions under which representations learned by this general objective recover the underlying latent causal states up to component-wise invertible transformations and permutation. One key condition for such identifiability is sufficient action-induced variation in the transition mechanisms. Guided by this finding, we instantiate the general objective with an action-modulated Gaussian additive-noise model, yielding action-modulated JEPA (A-JEPA). Experiments on synthetic environments verify the theoretical findings under the identifiability conditions and robustness to moderate violations, while visual benchmarks demonstrate improved state recovery and transfer to unseen transition mechanisms.
