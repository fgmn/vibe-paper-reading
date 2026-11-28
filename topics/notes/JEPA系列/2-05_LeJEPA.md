---
id: "2-05"
org: 专题·JEPA系列
short: "LeJEPA"
title: "LeJEPA: Provable and Scalable Self-Supervised Learning Without the Heuristics"
aliases: ["LeJEPA", "SIGReg", "Sketched Isotropic Gaussian Regularization", "Latent-Euclidean JEPA"]
date: 2025-11-11
category: "JEPA 奠基与防坍塌正则"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "Brown University；NYU；Meta-FAIR"
partners: []
authors: ["Randall Balestriero", "Yann LeCun"]
arxiv: "2511.08544"
pdf: "[[topics/papers/JEPA系列/2-05_2511.08544_LeJEPA.pdf]]"
code: "https://github.com/rbalestr-lab/lejepa"
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "self-supervised", "anti-collapse", "sigreg", "isotropic-gaussian", "theory"]
---

# LeJEPA: Provable and Scalable Self-Supervised Learning Without the Heuristics

> [!info] 论文信息
> arXiv [2511.08544](https://arxiv.org/abs/2511.08544) · v3 2025-11-14（v1 2025-11-11）· 50 页（正文 18 页 + 附录）
> PDF：[[topics/papers/JEPA系列/2-05_2511.08544_LeJEPA.pdf|本地 PDF]]
> 作者：Randall Balestriero\*（Brown、Meta-FAIR）、Yann LeCun\*（NYU、Meta-FAIR）。\* 共同贡献
> 代码：[rbalestr-lab/lejepa](https://github.com/rbalestr-lab/lejepa)（摘要里 "GitHub repo" 的超链接）
> 专题：[[topics/JEPA系列#二、JEPA 奠基与防坍塌正则|JEPA系列 · 二]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录表 3–7）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 两条公理："We identify two axioms: (i) solving the prediction task while (ii) enforcing an isotropic Gaussian distribution of the embeddings (Section 3)."（§1，p.2）
> - 现有防坍塌机制像打地鼠："On the other hand, the design of the "anti-collapse" criterion is much closer to a game of Whac-A-Mole."（§2.2，p.4）
> - 各向异性放大偏差："Whenever λ_K > λ_1, there always exists a downstream task (y) for which Z_aniso produces a higher bias estimator than Z_iso for λ > 0."（Lemma 1，p.5）
> - 非线性探针下各向同性高斯唯一最优："…among distributions with a scalar-based covariance constraint, the isotropic Gaussian is the unique minimizer of the integrated square bias."（Theorem 1，p.6）
> - 用 max 换成平均："We replace the maximum over a ∈ A in thm. 2 by an average in (SIGReg) to avoid sparse gradient over the directions in A."（§4.2，p.7）
> - 有限阶矩不够："…for finite K does not imply P_θ^(a) = Q^(a)."（Theorem 3，p.8）
> - 选 Epps–Pulley 的理由："…(i) DDP-friendly and scalable, (ii) uniformly bounded gradients and curvature regardless of input distribution, and (iii) hyper-parameter free implementation."（§4.2.3，p.10）
> - 方向重采样的效果："Our experiments show that even with |A| as low as 16 can easily outperform a fixed set with |A| of order of thousands thanks to the compounding effect of resampling at each minibatch."（§4.3，p.11）
> - 退化成 VICReg："…using that T with SIGReg in LeJEPA recovers the VICReg SSL method in the limit of large number of slices."（§5.2，p.12）
> - 推荐默认值："We thus recommend to use λ = 0.05, V_g = 2, V_l = 8, and batch size ≥ 128 as starting points."（§6.1，p.13）
> - 训练损失与下游相关："By setting α ≈ 0.4, LeJEPA's training loss is able to achieve nearly 99% correlation with downstream performance across multiple datasets and models."（§6.2，p.15）

## 一句话总结

LeJEPA 先从理论上回答"JEPA 的嵌入应该服从什么分布"：在固定总方差的约束下，**各向同性高斯**对线性探针（偏差、方差）和 k-NN / 核探针（积分平方偏差）都是唯一最优；再给出能在高维、大批量下把嵌入推向这个分布的正则 **SIGReg**——沿随机一维方向投影，用 Epps–Pulley 特征函数检验和标准正态比较，O(N) 时间和内存、梯度有界。LeJEPA = 多视图预测损失 + SIGReg，只有一个权衡超参 λ，不需要 stop-gradient、EMA teacher、predictor、register token，在 60+ 种架构上稳定训练，ImageNet-1k 上 ViT-H/14 冻结线性评估约 79%，在 Galaxy10 这类小域数据上从零训练胜过 DINOv2/v3 迁移。

## 要解决什么问题

- JEPA 的预测任务本身有**坍塌**这个平凡解（完全坍塌到常数，或维度坍塌到低维子空间）。现有对策是一堆启发式：stop-gradient、非对称视图、带 EMA 调度的 teacher–student、白化/归一化层、负样本。
- 作者认为这些机制普遍有以下毛病中的至少两条：
  1. **欠定**：损失能在退化配置下被最小化；
  2. 对批大小和/或嵌入维度是**二次复杂度**；
  3. 对数据分布、超参、架构**敏感**；
  4. **缺理论保证**。
- 后果是 JEPA 训练脆弱，研究重心转向堆数据、堆模型，理论基础没人管。作者想从"JEPA 应满足的必要条件"出发，推出一个精简、可证明的配方。

## 方法

### 1. 为什么是各向同性高斯（§3）

设 N 个 K 维嵌入 Z，比较两种列空间相同、总能量相同的嵌入：Z_aniso（协方差特征值 {λ_k} 至少两个不等）和 Z_iso（特征值都等于均值）。

| 结论 | 设定 | 内容 |
|---|---|---|
| **Lemma 1**（各向异性放大偏差） | 带 Tikhonov 正则（λ>0）的线性探针 | 只要 λ_K > λ_1，总存在某个下游任务 y，使 Z_aniso 的估计量偏差比 Z_iso 大 |
| **Lemma 2**（各向异性放大方差） | λ=0 的 OLS | β̂ 的总方差在 Z_iso 处最小：tr(Var(β̂_aniso)) > tr(Var(β̂_iso)) |
| **Theorem 1**（各向同性高斯最优） | 半径 k-NN 与核回归探针；在总方差约束（tr(Cov)=κ₁ 或 ‖Cov‖_F=κ₂）下对所有分布搜索；附加正则条件见附录 A | ISB_kNN = r₀⁴/(K+2)² · τ_g² · J(p) + O(r₀⁴)；ISB_kernel ≤ (h²μ₂(K)/2)² · (2B² + 8L²J(p)) + o(h⁴)；**在标量协方差约束下，各向同性高斯是积分平方偏差的唯一最小者** |

结论：在不知道下游任务时，为了最小化最坏情况风险，嵌入应服从各向同性高斯。

### 2. SIGReg：用随机切片做分布检验（§4）

- 把"P_θ = Q"写成假设检验，再拆成一维方向检验：沿单位向量 a 把嵌入投影成标量，检验 P_θ^(a) = Q^(a)。
- **Lemma 3**（超球面 Cramér–Wold）：所有方向上的一维投影同分布 ⇔ 原随机向量同分布；依分布收敛也成立。
- **Theorem 2**（方向检验的充分性）：对 M 个方向取 max 的全局统计量 T_A 是原多元假设的合法检验——P=Q 时渐近水平 ≤ α，P≠Q 时渐近功效为 1（对经典的一致单变量检验成立）。
- **Definition 2（SIGReg）**：SIGReg_T(A, {f_θ(x_n)}) = (1/|A|) Σ_{a∈A} T({aᵀf_θ(x_n)})。实现里把 max 换成平均，避免梯度只落在一个方向上。

**选哪种一维检验**：

| 家族 | 代表 | 作者的判断 |
|---|---|---|
| 矩 | （扩展）Jarque–Bera：前四阶矩匹配 | **Theorem 3**：有限 K 阶矩匹配推不出分布相等；而阶数越高，梯度范数 O(k)、MC 梯度方差 O(k² m_{2(k−1)}) 越不稳定——稳定性和可辨识性不可兼得 |
| CDF | Cramér–von Mises、Anderson–Darling、Watson | 需要排序：不可微、破坏多卡并行 |
| 特征函数 | **Epps–Pulley**：EP = N∫|φ̂_X(t) − φ(t)|² w(t)dt | ECF 是复指数的平均，天然可微，多卡只需 all_reduce |

- **Theorem 4**（Epps–Pulley 的稳定性）：对投影样本 z_1..z_N，|∂EP/∂z_i| ≤ 4σ²/N，|∂²EP/∂z_i²| ≤ C√π σ³/(2N)（σ 为带宽）→ 梯度和曲率一致有界，不依赖输入分布。
- **Theorem 5**（统一误差界，对付维度灾难）：若嵌入密度 p_θ ∈ H^α（Sobolev 光滑度 α），且在 |A| 个方向上 EP=0，则所有方向上的期望特征函数差 ≤ C(K,α)·|A|^{−2α/(K−1)} × （一个 Sobolev 范数积分）。α 大时 |A| = O(K) 个方向就够 ε 近似。
- **SGD 也帮忙**：每步重新采样方向，累计方向数随训练线性增长；|A|=16 的重采样就能胜过上千个固定方向（图 7）。
- **Theorem 6**（小批量偏差）：E[L_n(θ)] = L(θ) + (1/N)∫w_s(t)(1 − |φ_P(t)|²)dt，损失和梯度都有 O(1/N) 的偏差；作者说批大小 16 时也不成问题，没去做 U-统计量去偏。
- 实现（算法 1）：方向用 global_step 做种子跨卡同步；积分用梯形法，[−5,5] 上 17 个节点；时间/内存 O(N)。V100 上 N=512、M=512、16 个积分点约 0.47 ms，N=32768 约 26.4 ms（表 6）。

### 3. LeJEPA 损失（§5）

- 沿用 DINO 的多裁剪：V_g 个全局视图 + V_l 个局部视图。预测损失 = 所有视图去预测全局视图嵌入的均值 μ_n：L_pred = (1/V) Σ_v′ ‖μ_n − z_{n,v′}‖²。
- 总损失：L_LeJEPA = (1−λ)·L_pred + λ·(1/V)Σ_v SIGReg({z_{n,v}})。只有 λ 一个权衡超参，核心代码约 50 行（算法 1、2）。
- 没有原型、stop-gradient、teacher–student；图像上也不用 predictor（只在视图间信息不对称时才需要，例如以动作为条件）。
- **与已有方法的关系（§5.2）**：切片思想同 sliced score matching、sliced Wasserstein；Epps–Pulley 积分精确计算时每个切片等价于核 MMD（但二次复杂度）；若把检验换成 T = mean² + (std−1)²，切片数趋于无穷时 SIGReg 退化成 E[Z]=0、Cov(Z)=I，即 **VICReg**——作者以 Theorem 3 为由反对这么做。

## 实验与关键数字

默认设置（§6.1 "Experiment Details 1"）：timm 骨干、8 个视图（2 个 224 全局 + 6 个 96 局部）、AdamW（lr ∈ {5e-3, 5e-4}，wd ∈ {1e-1, 1e-2, 1e-5}），线性 warmup + 余弦退火，无 weight-decay 调度。

### 1. 超参稳定性（表 1，ViT-L/14，ImageNet-1k 预训练 100 epoch，冻结线性探针 top-1 %）

| 消融 | 设置 → 精度 |
|---|---|
| 批大小 (c) | 128: 72.20 · 256: 74.15 · 512: 74.72 · 1024: 74.07 |
| 全局/局部视图 (b) | V_g=1：53.06–68.97（V=4→10）；V_g=2：72.26 / 73.07 / 74.24 / 74.06（V=4/6/8/10）；V_g=4：73.68 / 73.94 / 75.08（V=6/8/10） |
| 积分区间 × 切片数 (a) | [−1,1]：71.82–72.88；[−3,3]：73.95–75.02；[−5,5]：73.71–74.80 |
| 投影维度 × 嵌入维度 × 切片 (d) | 64 维投影最好（75.29–75.65），1024 维最低（73.65–74.79） |
| register token (e) | 0–8 个：1024 切片 75.08–75.34；4096 切片 75.58–75.84 → 有无都稳定 |

- ImageNet-100 + ResNet-50、400 epoch（图 8 / 表 7）：λ 从 0.001 到 0.5、视图 2/4/8 下精度在 76.67–84.68 之间，最佳值随视图数略移；作者推荐 λ=0.05。
- 推荐起点：λ=0.05、V_g=2、V_l=8、批 ≥128、17 个积分点、积分区间 [−5,5]、1024 切片。

### 2. 架构无关（图 9、表 4）

- ImageNet-10 上预训练 timm 里所有 <20M 参数的约 50 个模型（8 个家族），冻结线性探针 **91.5%–95%** top-1；ResNet、ViT 表现最好，作者建议别用 EfficientNet 这类特化架构起步。
- 去掉 predictor 和 teacher–student 也不坍塌（表 4，ImageNet-100，400 epoch）：ResNet-50 三层投影头 82.82–83.93；ViT-S/8 81.07–84.12；ViT-T/8 79.77–80.73。SWA（teacher 的替代）对 ViT 有小幅提升（ViT-S/8 三层头 81.07 → 84.12），不是防坍塌必需。表 4 的行标签在 PDF 文本里排版错乱，"w/ predictor / w/ SWA" 两列的对应关系是 Claude 推断的，需核对。

### 3. 训练损失可做无标签模型选择（§6.2，图 10–11）

- LeJEPA 训练损失与下游线性探针精度的 Spearman 相关约 85%；用 train_loss / λ^α 校正后（α≈0.4）接近 99%。
- 图 11 各设置（α=0 → 校正后）：resnet18-flowers102 0.60→0.95；resnet50-galaxy10 0.85→0.98；resnet50-inet10 0.81→0.99；ViT/base-8-inet1k 0.88→0.93；ViT/s-8-galaxy10 0.88→0.98；ViT/s-8-inet10 0.90→0.98。图 1 另标 ViT/base-8 inet1k 的 Spearman 94.52%。

### 4. 小域从零预训练胜过前沿模型迁移（表 3、表 5，Galaxy10）

| Galaxy10 top-1 %（全部样本） | 全量微调 | 冻结线性 |
|---|---|---|
| LeJEPA ConvNeXt-V2 Nano | 82.72 | 76.52 |
| LeJEPA ResNet-34 | 83.28 | 78.17 |
| DINOv2 ViT-S | 78.34 | 67.62 |
| DINOv3 ViT-S/16 | 81.60 | 71.38 |

- 1-shot 冻结：LeJEPA ResNet-34 31.08 vs DINOv3 30.17、DINOv2 27.68。
- 表 5（冻结线性，in-domain 预训练）：flowers102（仅 1,020 张训练图）上 ResNeXt26ts 82.19；Galaxy10 上 LeJEPA 各架构 73.78–77.29，而 I-JEPA ViT-H/14（IN-22k）只有 62.93；但在 CIFAR/food/ImageNet-10 这些自然图像上，I-JEPA 迁移明显更高（如 cifar100 86.93 vs LeJEPA 65.08–70.44）。

### 5. ImageNet-1k 规模与迁移（§6.4，表 2）

- ImageNet-1k 在线线性探针：ViT-L（0.3B）**77.1%**，ConvNeXt-V2-H（0.6B）**78.5%**；图 1 展示 ViT-g（1.8B）训练曲线平稳。
- 摘要说 ViT-H/14 达到 79%，但正文和表格里找不到 ViT-H/14 的这个数，需核对。

**表 2 冻结骨干小样本迁移（8 个数据集平均 %，平均值由 Claude 用表中各列算出，与 PDF 打印值一致）**：

| 模型 | 参数 | 预训练 | epoch | 1-shot | 10-shot | 全量 |
|---|---|---|---|---|---|---|
| LeJEPA ViT-L | 304M | IN-1K | 100 | 29.55 | 60.95 | 79.48 |
| LeJEPA ConvNeXtV2-H | 660M | IN-1K | 100 | 31.58 | 60.70 | 77.56 |
| I-JEPA ViT-H | 632M | IN-1K | 300 | 30.20 | 60.51 | 78.50 |
| I-JEPA ViT-H + STOP | 632M | IN-1K | 300 | 32.05 | 62.92 | 80.70 |
| I-JEPA ViT-H (22K) | 632M | IN-22K | 900 | 35.15 | 63.28 | 80.82 |

- 正文说 LeJEPA "consistently outperform I-JEPA"。对比原版 I-JEPA ViT-H（IN-1K）基本成立（10-shot、全量 LeJEPA ViT-L 更高，1-shot 低 0.65）；但**对 I-JEPA + STOP，三档平均都是 LeJEPA 更低**。表注强调的是 DTD、flowers102、food 这几个细粒度数据集上更好，以及训练 epoch 少 3 倍。

### 6. 涌现的语义结构（§6.5，图 13–14）

- ViT-L 最后一层特征的前 3 个主成分映成 RGB，前景/背景自然分开；对 [CLS] 自注意力取阈值，可以在视频里无监督地分割、跟踪显著物体（只有定性图）。

## 局限 / 存疑

> 论文没有单独的"局限"一节，下面是 Claude 的整理和推断，请核对。

- **理论与目标之间有缝**：§3 证明的是"在总方差约束下，各向同性高斯对线性 / k-NN / 核探针的（最坏情况）偏差或方差最优"，前提是对下游任务一无所知；真实下游任务不是"任意"的，这个最优性未必转化为实际精度优势。
- **数据假设**：§2.1 明确依赖样本 i.i.d.；对视频、轨迹这类时间相关数据，把每帧的边缘分布推成各向同性高斯是否合适，论文没讨论。后续 [[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 和 [[topics/notes/JEPA系列/2-07_MotionJEPA|MotionJEPA]] 正是在世界模型场景里指出了 SIGReg 的问题（几何差、压掉快变特征）。
- **用平均代替 max**：Theorem 2 的检验一致性是对 max 统计量证的，实际用的是平均，作者没给平均版本的对应结论。
- **摘要数字对不上**：摘要 "ViT-H/14 reaches 79%" 在正文里找不到出处（正文报 ViT-L 77.1%、ConvNeXt-V2-H 78.5%），需核对。
- **"consistently outperform I-JEPA" 偏强**：只对原版 I-JEPA（IN-1K）大体成立，不如 I-JEPA + STOP 和 IN-22K 版本（见表 2 平均值）。
- **规模与对比面**：ImageNet-1k 上的绝对精度（77–79%）仍低于 DINOv2/v3 一类有大量启发式的方法，正文没和它们在 ImageNet 上做同口径对比；"in-domain 胜过前沿模型"主要来自 Galaxy10 这类与自然图像差异很大的数据，自然图像小数据集上 I-JEPA 迁移仍强得多（表 5）。
- **只有一个超参**是就损失而言；实际还有视图数、投影头维度、切片数、积分区间、学习率与 wd 网格等，只是作者显示这些都不敏感。
- 图 13 的视频分割、图 14 的 PCA 只有定性结果。

## 与其他论文的关系

- **系列的"防坍塌"主线**：本文的 SIGReg 是系列里多篇的共同起点。
  - [[topics/notes/JEPA系列/2-06_VISReg|VISReg]]（同一作者 Balestriero 参与）把 VICReg 的协方差项换成基于 Sliced Wasserstein 的切片项，保留方差项控尺度，并指出 SIGReg 在坍塌时梯度消失。
  - [[topics/notes/JEPA系列/1-05_LeWM|LeWM]] 把 SIGReg 搬到动作条件的像素世界模型上；[[topics/notes/JEPA系列/2-07_MotionJEPA|MotionJEPA]] 和 [[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 则批评 SIGReg 在时间相关数据上压掉快变特征、几何差。
- **理论跟进**：[[topics/notes/JEPA系列/3-02_WhenLeJEPAWorldModel|When Does LeJEPA Learn a World Model?]]（Klindt、LeCun、Balestriero）证明在高斯潜变量 + OU 转移的世界里，LeJEPA 的最优解恰好是真实潜变量的旋转，而且高斯是唯一能这样的分布；[[topics/notes/JEPA系列/3-03_BeyondGaussianWorlds|Beyond Gaussian Worlds]] 从标题看是讨论非高斯情形。
- **被替代的启发式**：stop-gradient / EMA teacher（[[topics/notes/JEPA系列/2-01_I-JEPA|I-JEPA]]、[[topics/notes/JEPA系列/2-02_V-JEPA|V-JEPA]]、BYOL、DINO）、VICReg / Barlow Twins / W-MSE（白化、协方差）。本文表 2 直接对比 I-JEPA。
- 作者前作 "Gaussian embeddings: How JEPAs secretly learn your data density"（arXiv 2510.05949）讨论 JEPA 嵌入与数据密度的关系，可以一起读。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Learning manipulable representations of the world and its dynamics is central to AI. Joint-Embedding Predictive Architectures (JEPAs) offer a promising blueprint, but lack of practical guidance and theory has led to ad-hoc R&D. We present a comprehensive theory of JEPAs and instantiate it in LeJEPA, a lean, scalable, and theoretically grounded training objective. First, we identify the isotropic Gaussian as the optimal distribution that JEPAs' embeddings should follow to minimize downstream prediction risk. Second, we introduce a novel objective–Sketched Isotropic Gaussian Regularization (SIGReg)–to constrain embeddings to reach that ideal distribution. Combining the JEPA predictive loss with SIGReg yields LeJEPA with numerous theoretical and practical benefits: (i) single trade-off hyperparameter, (ii) linear time and memory complexity, (iii) stability across hyper-parameters, architectures (ResNets, ViTs, ConvNets) and domains, (iv) heuristics-free, e.g., no stop-gradient, no teacher–student, no hyper-parameter schedulers, and (v) distributed training-friendly implementation requiring only ≈50 lines of code. Our empirical validation covers 10+ datasets, 60+ architectures, all with varying scales and domains. As an example, using imagenet-1k for pretraining and linear evaluation with frozen backbone, LeJEPA reaches 79% with a ViT-H/14. We hope that the simplicity and theory-friendly ecosystem offered by LeJEPA will reestablish self-supervised pre-training as a core pillar of AI research (GitHub repo).
