---
id: "2-02"
org: 专题·JEPA系列
short: "V-JEPA"
title: "Revisiting Feature Prediction for Learning Visual Representations from Video"
aliases: ["V-JEPA", "Video JEPA", "Video Joint-Embedding Predictive Architecture"]
date: 2024-02-15
category: "JEPA 奠基与防坍塌正则"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "FAIR at Meta；Inria；ENS / PSL；Univ. Gustave Eiffel；NYU"
partners: ["Inria", "École normale supérieure", "Univ. Gustave Eiffel", "New York University"]
authors: ["Adrien Bardes", "Quentin Garrido", "Jean Ponce", "Xinlei Chen", "Michael Rabbat", "Yann LeCun", "Mahmoud Assran", "Nicolas Ballas"]
arxiv: "2404.08471"
pdf: "[[topics/papers/JEPA系列/2-02_2404.08471_V-JEPA.pdf]]"
code: "https://github.com/facebookresearch/jepa"
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "self-supervised", "video-representation", "masked-video-modeling", "ema-target", "attentive-probe"]
---

# Revisiting Feature Prediction for Learning Visual Representations from Video

> [!info] 论文信息
> arXiv [2404.08471](https://arxiv.org/abs/2404.08471) · v1 2024-02-15 · 23 页（正文 10 页 + 附录 A–E）
> PDF：[[topics/papers/JEPA系列/2-02_2404.08471_V-JEPA.pdf|本地 PDF]]
> 作者：Adrien Bardes（FAIR、Inria、ENS）、Quentin Garrido（FAIR、Univ. Gustave Eiffel）、Jean Ponce（ENS、NYU）、Xinlei Chen（FAIR）、Michael Rabbat（FAIR）、Yann LeCun（FAIR、NYU）、Mahmoud Assran†、Nicolas Ballas†（FAIR）。† 共同末位作者
> 代码：[facebookresearch/jepa](https://github.com/facebookresearch/jepa)
> 日期：arXiv 页眉写 "2404.08471v1 … 15 Feb 2024"，PDF 正文写 "Date: April 15, 2024"；编号 2404 说明是 2024 年 4 月提交，2-15 这个日期需核对。PDF 未标注发表会议。
> 专题：[[topics/JEPA系列#二、JEPA 奠基与防坍塌正则|JEPA系列 · 二]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录 B–E 的实现细节和补充结果）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 研究问题："How effective is feature prediction as a stand-alone objective for unsupervised learning from video with modern tools?"（§1，p.1）
> - 不用任何其他监督："without the use of pretrained image encoders, text, negative examples, reconstruction, or other sources of supervision."（Abstract，p.1）
> - 防坍塌目标："we use the following modified objective to prevent representation collapse"（§3.1，式 1，p.3）
> - 换成 L1："we modify it to use an ℓ1 regression, which we found to be more stable."（§3.1，p.3）
> - 防坍塌的假说："The hypothesis is that incorporating an exponential moving average to compute the representation of y ensures that the predictor evolves faster than the encoder and remains close to optimal, thereby preventing collapse."（§3.1，p.3）
> - 掩码比例："the result is an average masking ratio of ∼90%."（§3.2，p.4）
> - 无归一化目标不保证线性可分："Since the prediction objective in equation (1) is unnormalized, there is no a priori reason for the encoder to yield a linearly separable subspace"（§4.3，p.6）
> - 数据分布："the best task-specific performance is obtained by independently selecting the pretraining data for each specific downstream task."（§4.2，p.6）
> - 运动理解优势："the V-JEPA models provide a major improvement (over +21 points) compared to large-scale image baselines, such as DINOv2, OpenCLIP, and I-JEPA."（§5.2，p.8）
> - 数据多样性不足："we hypothesize that the datasets used to train V-JEPA and other video models are too constrained and lack the visual diversity of the internet-scale pretraining data used by the images models"（§5.2，p.9）

## 一句话总结

把 [[topics/notes/JEPA系列/2-01_I-JEPA|I-JEPA]] 搬到视频：在约 200 万段公开视频（VideoMix2M）上，只用"从可见时空 patch 预测被遮住区域在 EMA 目标编码器里的特征"这一个目标（L1 损失、stop-gradient，不用图像预训练编码器、文本、负样本或像素重建）训练 ViT。关键设计是 3D multi-block 掩码（空间块贯穿整个时间维，遮掉约 90%）和冻结骨干上的 attentive probe。ViT-H/16@384 冻结评估 K400 81.9%、SSv2 72.2%、ImageNet 77.9%；SSv2 比 DINOv2 / OpenCLIP / I-JEPA 等图像模型高 21 个点以上，且预训练只处理了 2.1 亿个样本，比其他方法少一个数量级。

## 要解决什么问题

- "相邻时刻的表示应能互相预测"（predictive feature principle）是老想法，但以往视频特征预测要么用冻结的预训练编码器，要么靠监督 / 对比负样本防坍塌，多是小卷积网络。
- 作者问：有了 ViT、掩码自编码框架、query 式特征池化、JEPA、大数据这些现代工具后，**单靠特征预测**做视频自监督效果如何？
- 对照组是视频像素重建（VideoMAE、OmniMAE、Hiera）——像素预测要花很多容量在低层细节上，冻结评估差，通常要微调。

## 方法

### 目标函数（§3.1，式 1）

min_{θ,ϕ} ‖P_ϕ(E_θ(x), Δy) − sg(Ē_θ(y))‖₁

- E_θ：x-encoder（ViT）；Ē_θ：其 EMA（y-encoder）；P_ϕ：预测器，条件 Δy 是 y 的时空位置；sg = stop-gradient。
- 相对 I-JEPA 的改动：**L2 → L1**（作者说更稳）。
- 理论动机（改编自 BYOL 的分析，一维、忽略条件变量）：最优预测器是条件中位数，代入后编码器梯度 = ∇_θ MAD(Y | E_θ(x))，即编码器要尽量多地捕捉信息以减小目标的条件偏差；**假说**是 EMA 让预测器比编码器演化得快、始终接近最优，从而不坍塌。这一段只是动机，不是证明。

### 预测任务：3D multi-block 掩码（§3.2）

| 掩码 | 构成 | 每帧覆盖 |
|---|---|---|
| short-range | 8 个随机块的并集 | 15%（每块空间尺度 0.15） |
| long-range | 2 个随机块的并集 | 70%（每块空间尺度 0.7） |

- 长宽比 (0.75, 1.5)；**空间块在整个时间维上重复**，减少视频时空冗余导致的信息泄漏。平均遮挡约 90%。
- 每个 clip 同时采两种掩码（multi-mask）：x-encoder 和预测器各跑两次，y-encoder 只算一次，摊薄目标计算。
- x 在 **x-encoder 输入端**丢 token；y 在 **y-encoder 输出端**取（上下文化目标）。

### 网络与训练（§3.3–3.4，附录 B/C，表 8）

- 输入 16 帧、帧间隔 4；tubelet 2×16×16（3D conv），224 分辨率下 1568 个 token，3D sin-cos 位置编码；无 [cls]。
- 预测器：窄 ViT，12 层、嵌入维 384，头数同骨干。
- 模型：ViT-L/16、ViT-H/16（224）、ViT-H/16（384）；batch 3072 / 3072 / 2400；**全部只训 90K 迭代**。
- AdamW；lr 2e-4 → 6.25e-4（12K 步 warmup）→ 1e-6 余弦；wd 0.04 → 0.4；EMA 动量 0.998 → 1.0。所有调度按 112,500 步计算、只跑到 90K（截掉最后 25%，作者说更好）。
- 数据 VideoMix2M = HowTo100M + Kinetics-400/600/700 + SSv2，去掉与验证集重叠，约 200 万视频。

### 评估：attentive probe（§4.3，附录 D）

冻结骨干上接一层 cross-attention（可学 query token，12 头）+ 残差 + 两层 MLP + LayerNorm + 线性分类器。K400 用 8 个 clip（约 16 秒）拼接、SSv2 多 clip、3 个空间视角平均；图像任务把图复制成静态视频。

## 实验与关键数字

### 1. 特征 vs 像素目标（表 1，ViT-L/16，90K 步，单中心视角）

| 目标 | K400 冻结 | SSv2 冻结 | IN1K 冻结 | K400 微调 |
|---|---|---|---|---|
| 像素（归一化，MSE） | 68.6 | 66.0 | 73.3 | 85.4 |
| 特征（V-JEPA） | **73.7** | **66.2** | **74.8** | **85.6** |

### 2. 预训练数据（表 2，冻结，单中心视角）

| 架构 | 数据 | 样本数 | K400 | SSv2 | IN1K | 平均 |
|---|---|---|---|---|---|---|
| ViT-L/16 | K710 | 700K | 75.8 | 63.2 | 73.7 | 70.9 |
| | K710+SSv2 | 900K | 72.9 | 67.4 | 72.8 | 71.0 |
| | K710+HT | 1900K | 74.5 | 64.2 | 74.8 | 71.1 |
| | VideoMix2M | 2000K | 73.7 | 66.2 | 74.8 | **71.5** |
| ViT-H/16 | K710+SSv2 | 900K | 75.7 | 66.8 | 73.7 | 72.0 |
| | VideoMix2M | 2000K | 74.0 | 68.5 | 75.9 | **72.8** |

平均分随数据量单调增，但单任务最好成绩要按下游任务挑数据。

### 3. 池化与掩码消融（表 3、表 4，ViT-L/16）

- 平均池化 vs attentive probe：K400 56.7 → 73.7（+17），SSv2 50.1 → 66.2（+16.1）。附录表 12：VideoMAE 也从中受益（K400 52.5 → 77.8）。
- 掩码（K710+SSv2 预训练）：random-tube[0.9] 51.5 / 46.4 / 55.6；causal multi-block[6] 61.3 / 49.8 / 66.9；causal multi-block[12] 71.9 / 63.6 / 72.2；**multi-block 72.9 / 67.4 / 72.8**（K400 / SSv2 / IN1K）。只用前几帧当上下文（因果预测）反而更差。
- 附录 E.4（ViT-B/16、K400，26 组实验，图 8，数字只在图里）：低空间 / 时间覆盖让任务过于简单；多个小块比单个大块好；每个 clip 两种掩码比一种好。

### 4. 与像素预测方法同架构对比（表 5，ViT-L 级）

| 方法 | 见过样本 | 迭代 | K400 | SSv2 | AVA | IN1K | Places205 | iNat21 | K400-ft | SSv2-ft |
|---|---|---|---|---|---|---|---|---|---|---|
| OmniMAE | 2400M | 1170K | 65.6 | 60.6 | 14.4 | **75.1** | 59.8 | 66.1 | 84.0 | 74.2 |
| VideoMAE | 410M | 400K | 77.8 | 65.5 | 21.6 | 71.1 | 59.3 | 64.6 | 85.4 | 74.3 |
| Hiera-L | 770M | 1500K | 75.5 | 64.2 | 15.8 | 68.9 | 58.5 | 56.9 | **87.3** | **75.1** |
| **V-JEPA** | **270M** | **90K** | **80.8** | **69.5** | **25.6** | 74.8 | **60.3** | **67.8** | 85.6 | **75.1** |

冻结评估除 IN1K（OmniMAE 直接在 ImageNet 上训过）外全胜；微调 K400 不如 Hiera-L，SSv2 打平。

### 5. 与 SOTA 对比（表 6，冻结 + attentive probe）

| 方法 | 参数 | 数据 | K400 | SSv2 | AVA | IN1K | Places205 | iNat21 |
|---|---|---|---|---|---|---|---|---|
| I-JEPA ViT-H/16@512 | 630M | IN22K | 79.7 | 50.0 | 19.8 | 84.4 | 66.5 | 85.7 |
| OpenCLIP ViT-G/14 | 1800M | LAION | 81.8 | 34.8 | 23.2 | 85.3 | **70.2** | 83.6 |
| DINOv2 ViT-g/14 | 1100M | LVD-142M | **83.4** | 50.6 | 24.3 | **86.2** | 68.4 | **88.8** |
| VideoMAE ViT-H/16 | 630M | K400 | 79.8 | 66.2 | 20.7 | 72.3 | 59.1 | 65.5 |
| VideoMAEv2 ViT-g/14 | 1100M | Un.Hybrid | 71.2 | 61.2 | 12.9 | 71.4 | 60.6 | 68.3 |
| V-JEPA ViT-L/16 | 200M | VideoMix2M | 80.8 | 69.5 | 25.6 | 74.8 | 60.3 | 67.8 |
| V-JEPA ViT-H/16 | 630M | VideoMix2M | 82.0 | 71.4 | **25.8** | 75.9 | 61.7 | 67.9 |
| V-JEPA ViT-H/16@384 | 630M | VideoMix2M | 81.9 | **72.2** | 25.0 | 77.4 | 62.8 | 72.6 |

- 对视频模型：H/16 在 SSv2 上至少 +5、K400 +2、AVA +5、IN1K +1、Places205 +2、iNat +0.2；墙钟时间约快 2×（图 5，按单卡测速线性外推）。
- 对图像模型：SSv2 高 21 个点以上；但外观类任务（K400、IN1K、iNat）仍明显落后 DINOv2。摘要里的 IN1K 77.9% 是换成两层 attentive probe 后的数字，表 6 一层探针是 77.4%。

### 6. 标签效率（表 7，冻结，3 个随机划分均值 ± 标准差）

| 方法 | K400 5% | K400 10% | K400 50% | SSv2 5% | SSv2 10% | SSv2 50% |
|---|---|---|---|---|---|---|
| MVD ViT-L/16 | 62.6±0.2 | 68.3±0.2 | 77.2±0.3 | 42.9±0.8 | 49.5±0.6 | 61.0±0.2 |
| VideoMAE ViT-H/16 | 62.3±0.3 | 68.5±0.2 | 78.2±0.1 | 41.4±0.8 | 48.1±0.2 | 60.5±0.4 |
| VideoMAEv2 ViT-g/14 | 37.0±0.3 | 48.8±0.4 | 67.8±0.1 | 28.0±1.0 | 37.3±0.3 | 54.0±0.3 |
| V-JEPA ViT-H/16@384 | **68.2±0.2** | **72.8±0.2** | **80.6±0.2** | **54.0±0.2** | **59.3±0.5** | **67.9±0.2** |

标签减到 1/10 时 V-JEPA 掉得最少（K400 −12.4，SSv2 −13.9），差距随标签减少而拉大。

### 7. 其他

- 全量微调（附录表 15）：V-JEPA ViT-H/16 K400 86.6 / SSv2 77.0，MVD ViT-H/16（用了 IN1K、2400M 样本）87.2 / 77.3 最好。
- 样本效率（表 16）：V-JEPA ViT-H/16@384 处理 210M 样本，VideoMAEv2 1600M、DINOv2 1900M、OpenCLIP 39000M。
- 定性（§6，图 6）：冻结编码器 + 预测器，训练一个只看被遮区域预测特征的条件扩散解码器；样本在时空上和可见区域一致，运动连贯，有物体恒存的迹象。

## 局限 / 存疑

> 论文没有单独的"局限"一节；第一条是 §5.2 里作者自己的说法，其余是 Claude 的推断，请核对。

- **作者承认**：视频数据集缺少互联网图像那样的视觉多样性，所以外观类任务（IN1K、iNat21）仍落后 DINOv2 / OpenCLIP 不少（IN1K 77.4 vs 86.2）。
- **防坍塌只有假说**：EMA + stop-gradient 不坍塌的解释沿用 BYOL 的一维分析，没有实验监控表征秩或坍塌。
- **评估协议偏向非线性探针**：作者自己说无归一化目标不保证线性可分，所以全文用 attentive probe（平均池化低 16–17 个点）。这让和其他论文的线性探针数字不能直接比；虽然附录说明基线也换成了 attentive probe。
- **"只靠特征预测"不完全成立**：训练时仍用了随机缩放裁剪 (0.3, 1.0) 和水平翻转（表 8），只是没有多视图不变性目标。
- **掩码不是因果的**：上下文和目标都来自整个 16 帧 clip，causal 变体更差。所以 V-JEPA 学的是 clip 内时空补全，不是对未来的预测——后来 [[topics/notes/JEPA系列/1-12_VJEPA|VJEPA]] 也据此说 clip 级 V-JEPA 不构成可组合的动力系统；要做规划需要 [[topics/notes/JEPA系列/2-03_V-JEPA2|V-JEPA 2]] 那样另训动作条件预测器。
- **需核对的小矛盾**：
  - §3.4 说 16 帧 × 间隔 4 "约 3 秒"，附录 B 说同样的 64 帧在 30 fps 下"约 2 秒"。
  - 附录 D.1 说 SSv2 的 attentive probe 用 2 个 clip，表 9 的 SSv2 num_clips 写的是 1。
  - arXiv v1 日期（2024-02-15）与编号 2404、PDF 内 "April 15, 2024" 对不上。
- 所有模型只训 90K 步，没给出继续训练是否还涨；数据规模也只到 200 万视频，"规模化"的问题留给了 V-JEPA 2。

## 与其他论文的关系

- **直接前身**：[[topics/notes/JEPA系列/2-01_I-JEPA|I-JEPA]]（同组；EMA 目标编码器、窄预测器、输出端取目标、multi-block 掩码都继承过来，损失从 L2 改 L1，掩码从 2D 改为贯穿时间的 3D）。
- **直接后续**：[[topics/notes/JEPA系列/2-03_V-JEPA2|V-JEPA 2]] 把数据放到 100 万小时以上、模型到 1B，加渐进分辨率训练，并在冻结编码器上训动作条件预测器 V-JEPA 2-AC 做零样本机器人规划。
- **防坍塌路线**：属于 stop-gradient / EMA 一系。[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 认为这类目标只训练编码器"预测当前潜变量"，潜路径不平滑；[[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]] 用 SIGReg 取代 EMA / stop-gradient。
- **慢特征**：§2 把 SFA、慢特征一系列为相关工作，并说本文"超越了时间不变性"；[[topics/notes/JEPA系列/2-04_JEPASlowFeatures|JEPA Slow Features]] 正好分析了 JEPA 在视频上退化成慢特征、被固定噪声背景带偏的问题。
- **概率化 / 理论**：[[topics/notes/JEPA系列/1-12_VJEPA|VJEPA]] 把本文的回归损失推广为预测分布，并把 clip 级 V-JEPA 归为"不构成动力系统"。
- 像素重建对照：VideoMAE / VideoMAEv2 / OmniMAE / Hiera；蒸馏对照：MVD。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> This paper explores feature prediction as a stand-alone objective for unsupervised learning from video and introduces V-JEPA, a collection of vision models trained solely using a feature prediction objective, without the use of pretrained image encoders, text, negative examples, reconstruction, or other sources of supervision. The models are trained on 2 million videos collected from public datasets and are evaluated on downstream image and video tasks. Our results show that learning by predicting video features leads to versatile visual representations that perform well on both motion and appearance-based tasks, without adaption of the model's parameters; e.g., using a frozen backbone. Our largest model, a ViT-H/16 trained only on videos, obtains 81.9% on Kinetics-400, 72.2% on Something-Something-v2, and 77.9% on ImageNet1K.
