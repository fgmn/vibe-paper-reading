---
id: "2-01"
org: 专题·JEPA系列
short: "I-JEPA"
title: "Self-Supervised Learning from Images with a Joint-Embedding Predictive Architecture"
aliases: ["I-JEPA", "Image-based JEPA", "Image JEPA"]
date: 2023-01-19
category: "JEPA 奠基与防坍塌正则"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "Meta AI (FAIR)；McGill University；Mila；New York University"
partners: ["McGill University", "Mila", "New York University"]
authors: ["Mahmoud Assran", "Quentin Duval", "Ishan Misra", "Piotr Bojanowski", "Pascal Vincent", "Michael Rabbat", "Yann LeCun", "Nicolas Ballas"]
arxiv: "2301.08243"
pdf: "[[topics/papers/JEPA系列/2-01_2301.08243_I-JEPA.pdf]]"
code: ""
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "self-supervised", "masked-image-modeling", "vit", "ema-target", "representation-learning"]
---

# Self-Supervised Learning from Images with a Joint-Embedding Predictive Architecture

> [!info] 论文信息
> arXiv [2301.08243](https://arxiv.org/abs/2301.08243) · v3 2023-04-13 · 17 页（正文 8 页 + 附录 A–E）
> PDF：[[topics/papers/JEPA系列/2-01_2301.08243_I-JEPA.pdf|本地 PDF]]
> 作者：Mahmoud Assran（Meta AI FAIR、McGill、Mila）、Quentin Duval、Ishan Misra、Piotr Bojanowski、Pascal Vincent、Michael Rabbat（FAIR、Mila）、Yann LeCun（FAIR、NYU）、Nicolas Ballas（FAIR）
> 发表：PDF 上没有写会议；一般引用为 CVPR 2023（需核对，frontmatter 按规则写"arXiv 预印本"）。PDF 里也没有给代码链接。
> 专题：[[topics/JEPA系列#二、JEPA 奠基与防坍塌正则|JEPA系列 · 二]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录 A 的实现细节和附录 C 的消融表）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 核心想法："from a single context block, predict the representations of various target blocks in the same image."（Abstract，p.1）
> - 掩码策略是关键："it is crucial to (a) sample target blocks with sufficiently large scale (semantic), and to (b) use a sufficiently informative (spatially distributed) context block."（Abstract，p.1）
> - 与生成式的区别："a key difference is that the loss function is applied in embedding space, not input space."（§2，p.3）
> - 防坍塌靠非对称结构："we leverage an asymmetric architecture between the x- and y-encoders to avoid representation collapse."（§2，p.3）
> - 目标块在输出端遮："the target blocks are obtained by masking the output of the target-encoder, not the input. This distinction is crucial to ensure target representations of a high semantic level"（§3，p.4）
> - EMA 必不可少："The use of an exponential moving average target-encoder has proven essential for training JEAs with Vision Transformers [18,25,79], we find the same to be true for I-JEPA."（§3，p.4）
> - 计算效率："Pretraining a ViT-H/14 on ImageNet requires less than 1200 GPU hours, which is over 2.5× faster than a ViT-S/16 pretrained with iBOT [79] and over 10× more efficient than a ViT-H/14 pretrained with MAE."（§1，p.2）
> - 每步更慢但收敛更快："I-JEPA introduces extra overhead by computing targets in representation space (about 7% slower time per iteration). However, since I-JEPA converges in roughly 5× fewer iterations"（§7，p.6）
> - 预测器能表达位置不确定性："The I-JEPA predictor correctly captures positional uncertainty and produces high-level object parts with the correct pose"（§8，p.7）
> - 像素空间目标大幅退化："predicting in pixel-space leads to a significant degradation in the linear probing performance."（§9，p.7）

## 一句话总结

JEPA 在图像上的第一个大规模实例：一个 ViT 上下文编码器只看图里的**一个大上下文块**，一个窄 ViT 预测器按位置 mask token 去预测**同一张图里 4 个目标块在目标编码器（EMA）输出空间里的表示**，损失是 L2，不用任何手工数据增强、不重建像素。关键是 multi-block 掩码（目标块够大、上下文块够大且分散）。ViT-H/14 在 16 张 A100 上不到 72 小时训完，ImageNet 线性探针 79.3%（448 分辨率的 ViT-H/16 达 81.1%），明显好于 MAE / data2vec，接近用增强的 iBOT，在计数、深度这类低层任务上还超过 DINO / iBOT。

## 要解决什么问题

- 当时自监督视觉两条路各有毛病：
  - **不变性方法**（SimCLR、DINO、iBOT、MSN）：依赖手工数据增强构造多视图，语义强，但增强带来强偏置，对不同任务（分类 vs 实例分割）不一定合适，也难推广到音频等别的模态；还要处理多个视图，费算力。
  - **生成式 / 掩码重建**（MAE、BEiT、data2vec 的像素版）：先验少、易推广，但表示语义层级低，线性探针和少标签迁移差，往往要端到端微调。
- 目标：**不用手工增强**也拿到高语义的表示。作者把 JEPA（LeCun 2022 的框架）落到图像上：预测发生在表示空间，目标编码器可以把无关的像素细节抽象掉。

## 方法

### 架构（§3，图 3）

| 组件 | 内容 |
|---|---|
| 上下文编码器 f_θ | 标准 ViT，**只处理可见的上下文 patch** |
| 目标编码器 f_θ̄ | 同架构 ViT，权重 = 上下文编码器的 EMA；输入**整张图**，在**输出端**按目标块取 patch 表示 |
| 预测器 g_ϕ | 窄 ViT（嵌入维 384，头数同骨干；深度 B/16 为 6、L/H 为 12、G/16 为 16）；输入上下文表示 + 每个目标 patch 一个"共享可学向量 + 位置嵌入"的 mask token；对 M 个目标块分别调用 M 次 |
| 损失 | (1/M) Σ_i Σ_{j∈B_i} ‖ŝ_{y_j} − s_{y_j}‖²，只更新 θ、ϕ；θ̄ 走 EMA |
| 评估用的表示 | **目标编码器**输出做平均池化（没有 [cls] token） |

### Multi-block 掩码（§3，图 4）

- 目标：M = 4 个块（可重叠），尺度 (0.15, 0.2)，长宽比 (0.75, 1.5)。
- 上下文：1 个块，尺度 (0.85, 1.0)，长宽比 1；**再去掉与目标块重叠的区域**，保证预测不平凡。
- 上下文和目标块对每张图独立采样；为了批处理，同一 GPU 上所有上下文掩码大小一致、目标掩码大小一致。

### 训练细节（附录 A）

- AdamW，batch 2048；lr 前 15 epoch 从 1e-4 线性升到 1e-3，再余弦降到 1e-6；weight decay 0.04 → 0.4 线性增长。
- EMA 动量 0.996 线性增到 1.0。
- 防坍塌只靠 EMA + 预测器的非对称结构，没有方差 / 协方差正则。

## 实验与关键数字

### 1. ImageNet-1K 线性探针（表 1，Top-1 %）

| 方法 | 架构 | Epochs | Top-1 |
|---|---|---|---|
| *无视图增强* | | | |
| data2vec | ViT-L/16 | 1600 | 77.3 |
| MAE | ViT-H/14 | 1600 | 77.2 |
| CAE | ViT-L/16 | 1600 | 78.1 |
| I-JEPA | ViT-B/16 | 600 | 72.9 |
| I-JEPA | ViT-L/16 | 600 | 77.5 |
| I-JEPA | ViT-H/14 | 300 | 79.3 |
| I-JEPA | ViT-H/16 @448 | 300 | **81.1** |
| *用视图增强* | | | |
| DINO | ViT-B/8 | 300 | 80.1 |
| iBOT | ViT-L/16 | 250 | 81.0 |

### 2. ImageNet-1%（表 2，微调或线性探针取较好者）

I-JEPA ViT-H/14 73.3（= data2vec ViT-L/16 的 73.3），ViT-H/16@448 **77.3**；MAE ViT-H/14 71.5；用增强的 MSN ViT-B/4 75.7、DINO ViT-B/8 70.0。

### 3. 迁移线性探针（表 3、表 4）

| 方法 | CIFAR100 | Places205 | iNat18 | Clevr/Count | Clevr/Dist |
|---|---|---|---|---|---|
| data2vec ViT-L/16 | 81.6 | 54.6 | 28.1 | 85.3 | 71.3 |
| MAE ViT-H/14 | 77.3 | 55.0 | 32.9 | **90.5** | 72.4 |
| I-JEPA ViT-H/14 | 87.5 | 58.4 | 47.6 | 86.7 | 72.4 |
| DINO ViT-B/8 | 84.9 | 57.9 | 55.9 | 86.6 | 53.4 |
| iBOT ViT-L/16 | **88.3** | **60.4** | **57.3** | 85.7 | 62.8 |

- 语义任务上明显好于 MAE / data2vec，iNat18 仍落后 iBOT 约 10 个点。
- 低层任务：深度（Clevr/Dist）72.4 远超 DINO 53.4 / iBOT 62.8；计数 86.7 不如 MAE 90.5。

### 4. 规模与效率（§7，表 5，图 1/5）

- ViT-H/14 预训练 < 1200 GPU 小时：比 iBOT ViT-S/16 快 2.5× 以上，比 MAE ViT-H/14 省 10× 以上。每步比 MAE 慢约 7%（要算目标表示），但迭代数少约 5×。
- 数据和模型放大（表 5）：IN22k 上 ViT-H/14 → CIFAR100 89.5、iNat18 50.5、Clevr/Dist 75.0；ViT-G/16 在语义任务上继续涨（iNat18 55.3），但低层任务不涨（作者归因于更大的 patch）。
- 全量 ImageNet 微调（附录 D，表 15）：ViT-H/16@448 87.1，比 MAE ViT-H/14@448 的 87.8 低不到 1 个点，训练 epoch 少 5.3 倍。

### 5. 消融（表 6–14，均为 ImageNet-1% 线性探针）

| 消融 | 设置 → Top-1 |
|---|---|
| 掩码策略（ViT-B/16，300 ep，表 6） | multi-block **54.2** / rasterized（四象限）15.5 / 单块 block 20.2 / random 17.6 |
| 目标空间（ViT-L/16，表 7） | 目标编码器输出 66.9（500 ep） / 像素 40.7（800 ep） |
| 目标块尺度（表 8） | (0.075,0.2) 19.2 → (0.15,0.2) **54.2** → (0.2,0.3) 33.6 |
| 上下文尺度（表 9） | (0.40,1.0) 31.2 → (0.85,1.0) **54.2** |
| 目标块数量（表 10） | 1 块 9.0 / 2 块 22.0 / 3 块 48.5 / 4 块 54.2 |
| 目标在输入端还是输出端遮（ViT-H/16，表 11） | 输出端 67.3 / 输入端 56.1 |
| 预测器深度（ViT-L/16，表 12） | 6 层 64.0 / 12 层 66.9 |
| 预测器宽度（ViT-L/16，表 14，微调） | 384 → 70.7 / 1024 → 68.4（瓶颈更好） |
| weight decay（表 13） | 0.04→0.4：1% 69.4、线性 77.8；固定 0.05：1% 70.7、线性 76.4 |

### 6. 可视化（§8，附录 E）

用 RCDM 扩散解码器把平均池化的预测器输出 / 编码器输出映回像素：预测器能给出姿态正确的高层物体部件（鸟背、车顶），同时丢掉精确低层细节和背景；对照 MSN 的样本变化更大（姿态、尺度、实例数都不稳）。

## 局限 / 存疑

> 论文没有单独的"局限"一节，下面是 Claude 的推断，请核对。

- **防坍塌缺少解释**：只说 EMA 目标编码器"被证明是必要的"，没有分析为什么 L2 + EMA 不会坍塌，也没有监控坍塌的指标。后来的 [[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]] 一类工作正是针对这一点。
- **消融对比不完全公平**：表 7 像素目标用 800 epoch、表示目标用 500 epoch；表 12/13/14 的 epoch 数也各不相同，读数时要注意。
- 消融都在 **ImageNet-1% 线性探针**这一个指标上做；multi-block 的尺度超参数（0.15–0.2、0.85–1.0）很敏感（目标块从 (0.15,0.2) 换到 (0.2,0.3) 就从 54.2 掉到 33.6），说明方法对掩码设计依赖很强。
- 评估协议是给每个方法"挑最好的表示和头"（最后一层 vs 最后 4 层拼接，带不带 BN），I-JEPA 用平均池化而其他方法用 [cls]，可比性有一定折扣。
- 依然落后于最强的增强方法：iNat18 47.6 vs iBOT 57.3；计数不如 MAE。
- 只做了图像；"预测表示空间能推广到其他模态"是动机，不是本文验证的结论。

## 与其他论文的关系

- **JEPA 谱系的起点**：[[topics/notes/JEPA系列/2-02_V-JEPA|V-JEPA]] 把同一套"EMA 目标编码器 + 窄预测器 + 输出端遮挡"搬到视频（3D multi-block 掩码、L1 损失），[[topics/notes/JEPA系列/2-03_V-JEPA2|V-JEPA 2]] 再放大到百万小时视频并接动作条件预测器做机器人规划。
- **防坍塌两条路**：I-JEPA 是 stop-gradient / EMA 一系的代表；[[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]]（SIGReg）走分布正则一系（同节还有 [[topics/notes/JEPA系列/2-06_VISReg|VISReg]]）。[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 指出 SG 一系的潜路径在世界模型里是锯齿状的——这个判断就是针对 I-JEPA / V-JEPA 式的目标。
- **早期 JEPA 在视频上的分析**：[[topics/notes/JEPA系列/2-04_JEPASlowFeatures|JEPA Slow Features]]（2022-11，早于本文）用 VICReg / SimCLR 目标的 JEPA 在移动点上发现会学到"慢特征"、被固定噪声背景带偏。
- **概率化**：[[topics/notes/JEPA系列/1-12_VJEPA|VJEPA]] 把本文的 L2 损失读作固定方差高斯似然，推广为预测分布；并认为 I-JEPA 只学空间关系，不构成动力系统。
- 对比方法：MAE（像素重建）、data2vec（同样预测表示，但目标是多层平均、要处理完整输入）、CAE、iBOT / DINO / MSN（不变性 + 增强）。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> This paper demonstrates an approach for learning highly semantic image representations without relying on hand-crafted data-augmentations. We introduce the Image-based Joint-Embedding Predictive Architecture (I-JEPA), a non-generative approach for self-supervised learning from images. The idea behind I-JEPA is simple: from a single context block, predict the representations of various target blocks in the same image. A core design choice to guide I-JEPA towards producing semantic representations is the masking strategy; specifically, it is crucial to (a) sample target blocks with sufficiently large scale (semantic), and to (b) use a sufficiently informative (spatially distributed) context block. Empirically, when combined with Vision Transformers, we find I-JEPA to be highly scalable. For instance, we train a ViT-Huge/14 on ImageNet using 16 A100 GPUs in under 72 hours to achieve strong downstream performance across a wide range of tasks, from linear classification to object counting and depth prediction.
