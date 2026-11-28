---
id: "2-06"
org: 专题·JEPA系列
short: "VISReg"
title: "VISReg: Variance-Invariance-Sketching Regularization for JEPA training"
aliases: ["VISReg", "Variance-Invariance-Sketching Regularization"]
date: 2026-06-01
category: "JEPA 奠基与防坍塌正则"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "Altos Labs；Brown University"
partners: []
authors: ["Haiyu Wu", "Randall Balestriero", "Morgan Levine"]
arxiv: "2606.02572"
pdf: "[[topics/papers/JEPA系列/2-06_2606.02572_VISReg.pdf]]"
code: "https://haiyuwu.github.io/visreg"
project: "https://haiyuwu.github.io/visreg"
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "self-supervised", "anti-collapse", "sliced-wasserstein", "vicreg", "ood-generalization"]
---

# VISReg: Variance-Invariance-Sketching Regularization for JEPA training

> [!info] 论文信息
> arXiv [2606.02572](https://arxiv.org/abs/2606.02572) · v1 2026-06-01 · 17 页（正文 9 页 + 附录）
> PDF：[[topics/papers/JEPA系列/2-06_2606.02572_VISReg.pdf|本地 PDF]]
> 作者：Haiyu Wu（Altos Labs，通讯）、Randall Balestriero（Brown）、Morgan Levine（Altos Labs）
> 项目与代码：[haiyuwu.github.io/visreg](https://haiyuwu.github.io/visreg)（摘要写的是 "Project and code"，同一个链接）
> 专题：[[topics/JEPA系列#二、JEPA 奠基与防坍塌正则|JEPA系列 · 二]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录 A–C 的训练细节和消融表）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 协方差只管二阶："However, covariance captures only second-order statistics—encouraging decorrelation but failing to enforce the full distributional shape needed for stable training."（Abstract，p.1）
> - SIGReg 的问题："More critically, the gradient of the Epps-Pulley test diminishes as the embedding collapses (Figure 2), eventually vanishing entirely—precisely when a strong corrective signal is needed most."（§1，p.1）
> - 方法核心："VISReg retains the variance term from VICReg to control the scale of the embedding space, but replaces covariance regularization with sketching regularization…"（§1，p.2）
> - 方差项在坍塌时的梯度："This formulation provides a gradient that approaches a constant during collapse, ensuring a reliable corrective signal."（§3.1，p.3）
> - stop-gradient 在这里的角色："Unlike prior uses of stop-gradient as a collapse-prevention heuristic (Grill et al., 2020; Chen & He, 2021), here it serves a principled role in objective decomposition."（§3.1，p.3）
> - 切片数要大于维度："It indicates that K must be larger than D by a factor of C > 1 to maintain the best accuracy, so these approaches are O(CD²) to scaling factors on one GPU."（图 4 说明，p.5）
> - 多卡补切片："Thus, K can remain constant when scaling, preserving the O(NDK) complexity."（§3.2，p.6）
> - 低质量数据上需要调权重："Table 1 shows that VISReg outperforms all methods at all levels after adjusting the shape loss weight (details in Table 12), whereas DINO fails to learn meaningful embeddings."（§3.3，p.6）
> - 域内仍有差距："Comparing to the w/ heuristics methods, there is still an accuracy gap."（§4.2，p.8）
> - IN-22K 对 DINOv2："…VISReg with ViT-L/14 backbone achieves a comparable accuracy to DINOv2, which was trained with a 10x larger training set."（§4.2，p.8）
> - 分割仍有差距："Nevertheless, there is still a large gap comparing with MoCoV3 and iBOT, which is an important aspect that we will work on."（§4.2，p.9）

## 一句话总结

VISReg 把 VICReg 和 LeJEPA 的 SIGReg 拼成一个"尺度 / 形状解耦"的防坍塌正则：保留 VICReg 的**逐维方差项**控制尺度（坍塌时梯度趋于常数，不会消失），把协方差项换成**Sliced Wasserstein 切片项**（嵌入先按 stop-gradient 的标准差归一化，再沿随机方向投影、排序，和标准正态分位数做 L2），再加一个均值居中项；不变性项沿用 LeJEPA。复杂度 O(NDK)。ImageNet-1K 上 ViT-B/16 线性探针 75.7%、ViT-L/14 77.0%，域内不如 DINO/iBOT 等带启发式的方法，但 6 个 OOD 数据集平均最好（ViT-L 70.63）；IN-22K 预训练的 ViT-L 在 OOD 平均上与用 10 倍数据的 DINOv2 持平（72.94 vs 72.93）。

## 要解决什么问题

- **VICReg** 的协方差项只约束二阶统计：能去相关，但一个分布可以均值、协方差都对，形状离高斯很远；而且协方差计算是 O(ND²)。
- **SIGReg**（[[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]]）直接把分布推向各向同性高斯，但作者指出两点：
  1. Epps–Pulley 统计量的梯度随嵌入坍塌而变小，最后消失——恰恰是最需要纠正信号的时候（图 2：把特征尺度 r 从 1 缩到 10⁻⁴，SIGReg 梯度掉到很小，Barlow Twins 和 VISReg 仍保持大梯度）；
  2. 尺度和形状绑在一起，不同数据情形下没法分别调。
- **DINO** 一类 teacher–student 方法在低质量（长尾、低秩）数据上不调参就学不出东西。

## 方法

### 正则项（§3.1，算法 1）

记中心化嵌入 Ẑ ∈ R^{N×D}。

| 项 | 定义 | 作用 |
|---|---|---|
| 尺度 L_scale（式 1） | (1/D) Σ_j (1 − σ_j(Ẑ))² | 逐维标准差拉向 1。作者说直接最小化到各向同性高斯的 KL 是 O(D³)，于是分解成边缘分布；坍塌时梯度趋于常数 |
| 形状 L_shape（式 2、5） | 先 Z = Ẑ / (sg(σ) + ϵ)；再 (1/K) Σ_k ‖sort(Z w_k) − q_N‖² | Sliced Wasserstein（W₂）：一维 W₂ 有闭式解 = 排序后与标准正态分位数 q_N 的 L2。sg 让形状梯度不干扰尺度项 |
| 居中 L_center（式 6） | ‖μ‖² | 经验上提高鲁棒性、加快收敛 |

- **Lemma 3.1**（Cramér–Wold，Radon 变换单射）：所有方向投影同分布 ⇔ 分布相同——切片法的理论依据。
- **Lemma 3.2**（一维 Wasserstein 闭式）：一维 W_p^p = 两组次序统计量之差的 p 次方均值。
- **Proposition 3.3**：L_Reg = λ_scale L_scale + λ_shape L_shape + λ_center L_center，默认 λ\*=1。作者说加大形状权重对低质量数据有帮助。
- 不变性项沿用 LeJEPA：L_pred = (1/V) Σ_i ‖μ_g − z_i‖²（μ_g 为全局视图嵌入均值）。总损失 **L_VISReg = (1−λ) L_pred + λ L_Reg**。
- 和 SIGReg 不同，VISReg 天然与批大小无关，所以需要较大的 λ：小数据集（ImageNette、Galaxy10）从 0.6 起，ImageNet-1K 从 0.9 起。

### 复杂度与可扩展性（§3.2）

- **Definition 3.4 / 式 10–11**：C_Reg = O(NDK)（投影）+ O(KN log N)（排序）≈ O(NDK)，对比 VICReg 的 O(ND²)。
- 图 3（单张 H100，投影维度 10K、切片 2.5K、8 视图）：SWD 类方法速度、内存都更省；批大小 50K 时 VISReg 比 SIGReg 略快，"13.7% memory demand over SIGReg"——这句话是"只需 SIGReg 13.7% 的内存"还是"多 13.7%"，原文表述含糊，需核对（按图意应是前者）。
- **K 与 D 的耦合**（图 4，ViT-S/8，ImageNette，K=4096 变 D）：切片数要比投影维度大一个因子 C>1 才能达到最好精度，VISReg 需要的 C 最小 → 单卡上实际是 O(CD²)。
- **用多卡补切片**（图 6）：各卡独立采样切片，M 张卡各 CD/M 个就等价于单卡 CD 个。单卡上 K=128 与 K=1024 的差距：SIGReg 13.88、SWD 2.21、VISReg 2.44 个百分点；8 卡、每卡 K 不变时差距缩到 0.27 / 0.24 / 0.22。
- 图 5（D=256，K 从 D/8 到 16D）：OT 类方法在 K=D/8 时仍稳健，VISReg 最稳。

## 实验与关键数字

### 1. 低质量数据（§3.3；ViT-S/8，128px，从零训练 400 epoch，lr=1e-4，K=4096，D=256）

**ImageNet-LT 线性探针（表 1，%）**：

| 方法 | Overall | Many | Medium | Few |
|---|---|---|---|---|
| SWD / SIGReg（两行） | 31.85 / 32.00 | 51.54 / 51.86 | 22.70 / 22.88 | 8.36 / 7.92 |
| VISReg（默认权重） | 32.11 | 51.55 | 23.19 | 8.52 |
| **VISReg\***（加大形状权重） | **35.14** | **54.49** | **26.87** | **9.40** |
| VICReg | 33.08 | 52.29 | 24.63 | 8.54 |
| DINO | 5.13 | 12.22 | 0.82 | 0.24 |

- PDF 文本里 SWD、SIGReg 两行的标签排在一起，哪行是 31.85、哪行是 32.00 没法从文本确定，需核对。
- 注意：**默认权重的 VISReg（32.11）其实低于 VICReg（33.08）**，"outperforms all methods at all levels" 只对调过形状权重的 VISReg\* 成立（正文也写了 "after adjusting the shape loss weight"）。

**Galaxy10 线性探针（表 2）**：PDF 文本里的六个数是 80.60、80.50、79.93、73.49、80.51、80.76，表头顺序为 SWD、SIGReg、VISReg、VISReg\*、VICReg、DINO，但文本排版错乱，逐一对应不了。能确定的：DINO 明显最低（应是 73.49，正文说它 "struggles"），四种正则都在 80 左右。另外表 12 里 VISReg 默认权重在 Galaxy10 上是 79.44、形状 4:1 是 80.76，而表 2 的数里没有 79.44——两表的 VISReg 数字对不上，需核对。

### 2. 超参消融（表 3；ImageNet-1K，ViT-B/16，在线线性探针，前三项 100 epoch、最后一项 300 epoch）

| λ | 0.7: 67.98 · 0.8: 68.64 · 0.9: 69.19 · 0.95: 69.04 |
|---|---|
| 学习率 | 1e-4: 65.73 · 3e-4: 68.85 · 5e-4: 69.19 · 7e-4: 69.28 · 9e-4: 69.66 |
| 批大小 | 128: 67.63 · 256: 69.43 · 512: 69.66 · 1024: 69.45 · 2048: 68.79 |
| 投影维度 | 64: 73.20 · 128: 73.34 · 256: 73.44 · 512: 73.53 |

**投影维度对下游的影响（表 4）**：域内 7 个数据集精度随维度升高（512 最好）；OOD 上 Galaxy10 256 维最好（73.33）、512 维最差（70.93）；ADE20K 线性分割 mIoU 随维度升高而下降（64: 30.08 → 512: 28.94）。作者最终选 256。

### 3. 一般对比（表 5，冻结线性探针 %，下游 10 epoch，ImageNet 列取原论文数）

| 方法 | 骨干 | epoch | 8 数据集平均 | ImageNet-1K |
|---|---|---|---|---|
| MoCoV3 | ViT-B/16 | 300 | 80.5 | 76.7 |
| DINO | ViT-B/16 | 400 | 83.1 | 78.2 |
| data2vec | ViT-L/14 | 1600 | 72.1 | 77.3 |
| iBOT | ViT-B/16 | 400 | 83.2 | 79.8 |
| iBOT | ViT-L/16 | 250 | 84.5 | 81.0 |
| I-JEPA | ViT-H/14 | 300 | 78.7 | 79.3 |
| MAE | ViT-L/16 | 1600 | 77.8 | 75.1 |
| **VISReg** | ViT-B/16 | 400 | 79.1 | 75.7 |
| **VISReg** | ViT-L/14 | 400 | 78.5 | 77.0 |
| LeJEPA（原论文数，下游 100 epoch） | ViT-L/14 | 100 | 79.5 | 75.6 |
| **VISReg**（下游 100 epoch） | ViT-L/14 | 100 | 80.7 | 75.6 |

- 在"无启发式"组里 VISReg 好于 MAE 和 LeJEPA；比带启发式的 DINO / iBOT 低不少（平均 79.1 vs 83.1/83.2）。表里唯一的 OOD 数据集 DTD 上，VISReg ViT-L 76.5、ViT-B 75.7，都高于所有带启发式的方法（最高的 iBOT-L 75.3、DINO 74.3）。
- ViT-L/14、400 epoch 那行 CIFAR-100 只有 71.9，比 ViT-B（78.8）和 ViT-L 100 epoch（84.2）都低很多，像是异常值或笔误，需核对。

### 4. OOD（表 6，冻结线性探针；ChestXRay 为 AU-ROC 口径的数，其余为精度）

| 方法 | 骨干 | DTD | Galaxy10 | AID | ChestXRay | Retina | OrganA | 平均 |
|---|---|---|---|---|---|---|---|---|
| MoCoV3 | ViT-B/16 | 73.72 | 73.06 | 90.20 | 23.89 | 64.50 | 91.37 | 69.46 |
| DINO | ViT-B/16 | 74.26 | 72.77 | 91.52 | 24.63 | 62.50 | 91.70 | 69.56 |
| iBOT | ViT-B/16 | 74.10 | 71.65 | 91.73 | 24.80 | 63.75 | 91.84 | 69.64 |
| I-JEPA | ViT-H/14 | 69.89 | 71.31 | 88.68 | 23.46 | 65.75 | 92.19 | 68.55 |
| MAE | ViT-L/16 | 72.77 | 71.98 | 86.42 | 22.87 | 63.00 | 90.06 | 67.85 |
| **VISReg** | ViT-B/16 | 75.69 | 74.01 | 90.91 | 24.88 | 62.25 | 93.40 | 70.19 |
| **VISReg** | ViT-L/14 | 76.54 | 76.32 | 90.12 | 23.64 | 64.25 | 92.93 | **70.63** |
| DINOv2（LVD-142M） | ViT-L/14 | 82.23 | 76.72 | 94.27 | 23.83 | 69.50 | 91.01 | 72.93 |
| **VISReg（IN-22K）** | ViT-L/14 | 80.74 | 79.82 | 92.81 | 24.46 | 66.50 | 93.33 | **72.94** |

- 表 4 的说明里 ChestXRay 用 AU-ROC（0.75 左右），表 6 里却是 23–25 这种量级，两处口径不一致，需核对表 6 ChestXRay 用的是什么指标。
- OOD 平均的优势很小：VISReg ViT-B 70.19 vs iBOT-B 69.64（+0.55）。和 DINOv2 的"持平"是平均值差 0.01，单项上 DINOv2 在 DTD、AID、Retina 明显更高。

### 5. 微调、分割、生成引导（表 7–9，ViT-B/16）

| 任务 | DINO | VISReg | 备注 |
|---|---|---|---|
| 微调 CIFAR10 / CIFAR100 / Flowers / IN-1K / Galaxy10 | 99.1 / 91.7 / 98.8 / 82.8 / 86.6 | 99.2 / 91.8 / 99.0 / 83.0 / 87.0 | 有监督 DeiT：99.0 / 89.5 / 98.5 / 81.5 |
| ADE20K 线性分割 mIoU | 29.40 | 30.16 | MoCoV3 31.69、data2vec 21.99、MAE 23.60（复现值） |
| SiT-B/2 + iREPA 引导，100K 步，无 CFG | IS 33.47 / gFID 41.15 / P 50.51 / R 60.70 | IS 33.48 / gFID 40.36 / P 51.38 / R 61.26 | — |

- 微调的提升都在 0.1–0.4 个点；生成引导的差距也很小（gFID 差 0.79）。

### 6. 组件消融（附录 B；ViT-S/8，128px，λ=0.6，K=4096）

- **表 10（ImageNette）**：完整 91.82；去掉尺度项 20.80（−71.02 个百分点，正文写成 "71.02% decrease"）；去掉形状项 33.42（−58.4）；去掉居中项 91.41（−0.41，但收敛更慢）。
- **表 11（detach 的必要性）**：不 detach / detach = ImageNette 90.62 / 90.89、ImageNet-LT 31.59 / 31.94、Galaxy10 78.91 / 79.44。
- **表 12（三项权重比，总和固定为 3）**：形状 4:1 在 ImageNet-LT +3.2（35.14）、Galaxy10 +1.3（80.76），但 ImageNette 降到 89.87；尺度 4:1 最差（LT 27.35、Galaxy10 76.71）。高质量数据用等权最好。
- 附录 C.1：ViT-L/14 在 IN-1K 训练 100 epoch，训练损失与在线探针精度的 Pearson r = −0.996。

### 训练配置（附录 A.1）

- ViT-B/16：lr 9e-4、λ=0.9、d_p=256、K=2048、有效批 512（32 张 H100），400 epoch，约 1,120 GPU 小时；ViT-L/14：lr 8e-4、λ=0.7、d_p=384、K=4096，约 2,060 GPU 小时。4 全局 + 6 局部视图。
- IN-22K（14.2M 图）ViT-L/14：100 epoch、16 张 H100、有效批 1,024、λ=0.8，约 2,720 GPU 小时。
- 投影头：3 层 MLP（2048→2048→d_p），输入是最后两层 CLS token 拼接。

## 局限 / 存疑

> 论文没有单独的"局限"一节（只在 §4.2 承认分割有差距），下面主要是 Claude 的整理和推断，请核对。

- **域内精度仍落后**带启发式的方法（ImageNet-1K 75.7–77.0 vs iBOT-L 81.0），作者把卖点放在 OOD 和迁移上，但 OOD 平均的领先幅度很小（0.5–1 个点），也只有单次结果、没有方差。
- **"在所有层级都更好"依赖调权重**：ImageNet-LT 上默认权重的 VISReg 不如 VICReg，只有加大形状权重后才最好；而同样的调权在 ImageNette 上反而降精度——"解耦带来灵活性"也意味着要按数据调参。
- **SIGReg 梯度消失的论据**来自图 2 的模拟（直接缩放特征范数），没有在真实训练里展示 SIGReg 因此坍塌的案例；本文自己的实验里 SIGReg 也都没坍塌。
- **内部不一致，需核对**：
  - 表 2（Galaxy10）与表 12 的 VISReg 数字对不上（79.44 不在表 2 里）；
  - §3.2 那句 "13.7% memory demand over SIGReg" 含义含糊；
  - 表 5 中 VISReg ViT-L/14（400 epoch）CIFAR-100 = 71.9 疑似异常；
  - 表 4 说 ChestXRay 用 AU-ROC（~0.75），表 6 的 ChestXRay 却是 23–25；
  - 附录 B.2 两次出现未定义的 "DSSO"（看起来是方法旧名），§4.1 说 4096 切片 / 2 全局 + 6 局部视图，附录 A.1 的 ViT-B 却是 K=2048、4 全局 + 6 局部。
- **形状项用了排序**：LeJEPA 恰好以"排序不可微、破坏多卡并行"为由放弃 CDF 类检验，本文用排序做 SWD，靠的是每卡独立切片；多卡时每卡只对本卡的 N 个样本排序，相当于在小批量内做分布匹配，统计效率的影响没讨论（Claude 的推断）。
- 只做了图像 SSL，没有视频、世界模型或规划实验——放在 JEPA 系列里，它和世界模型那条线的联系只停留在"防坍塌正则"层面。

## 与其他论文的关系

- **直接前身**：[[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]]（SIGReg，Epps–Pulley 特征函数检验）和 VICReg（方差 + 不变 + 协方差）。VISReg = VICReg 的方差项 + LeJEPA 的不变项 + Sliced Wasserstein 形状项。LeJEPA 的 §5.2 指出用 mean²+(std−1)² 当检验时 SIGReg 退化为 VICReg，本文相当于反过来把 VICReg 往"完整分布匹配"推。
- **同类正则**：KerJEPA（MMD，O(N²)）、LpJEPA（RDMReg，促稀疏）在相关工作里被提到。系列里 [[topics/notes/JEPA系列/1-09_LpWM|LpWM]] 可能与 LpJEPA 有关，需对照。
- **世界模型里的防坍塌**：[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 的 SVReg 同样是"随机切片 + 方差下限"，但只设单边下限、不约束分布形状，正好和 VISReg"约束完整形状"形成对照；[[topics/notes/JEPA系列/2-07_MotionJEPA|MotionJEPA]] 也提到 SIGReg 可以换成 SWD 类正则。
- 对比基线：DINO、iBOT、MoCoV3、I-JEPA（[[topics/notes/JEPA系列/2-01_I-JEPA|I-JEPA]]）、MAE、DINOv2。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Self-supervised learning methods prevent embedding collapse via modeling heuristics or explicit regularization of the embedding space. Among the latter, VICReg decomposes regularization into variance and covariance objectives, offering flexibility and interpretability. However, covariance captures only second-order statistics—encouraging decorrelation but failing to enforce the full distributional shape needed for stable training. Sketching-based methods such as SIGReg address this by aligning embeddings to an isotropic Gaussian, but lack flexibility and suffer from vanishing gradients under collapse. We propose Variance-Invariance-Sketching Regularization (VISReg), which replaces covariance with a Sliced-Wasserstein-based sketching objective that enforces full distributional shape, while retaining a variance term for scale control. By decoupling scale and shape, VISReg combines VICReg's flexibility with the distributional rigor of sketching methods, providing robust gradients even under collapse. We show that VISReg scales linearly, outperforms existing regularization on low-quality datasets, and is resilient to long-tailed and low-rank regimes. Pre-trained on ImageNet-1K, VISReg achieves state-of-the-art performance on out-of-distribution datasets. Pre-trained on ImageNet-22K, it matches DINOv2's OOD performance despite the latter using 10× more data (LVD-142M). Project and code: https://haiyuwu.github.io/visreg.
