---
id: "2-03"
org: 专题·JEPA系列
short: "V-JEPA 2"
title: "V-JEPA 2: Self-Supervised Video Models Enable Understanding, Prediction and Planning"
aliases: ["V-JEPA 2", "V-JEPA 2-AC", "VJEPA2"]
date: 2025-06-11
category: "JEPA 奠基与防坍塌正则"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "FAIR at Meta；Mila – Quebec AI Institute / Polytechnique Montréal"
partners: ["Mila", "Polytechnique Montréal"]
authors: ["Mahmoud Assran", "Adrien Bardes", "David Fan", "Quentin Garrido", "Russell Howes", "Mojtaba Komeili", "Matthew Muckley", "Ammar Rizvi", "Claire Roberts", "Koustuv Sinha", "Artem Zholus", "Sergio Arnaud", "Abha Gejji", "Ada Martin", "Francois Robert Hogan", "Daniel Dugas", "Piotr Bojanowski", "Vasil Khalidov", "Patrick Labatut", "Francisco Massa", "Marc Szafraniec", "Kapil Krishnakumar", "Yong Li", "Xiaodong Ma", "Sarath Chandar", "Franziska Meier", "Yann LeCun", "Michael Rabbat", "Nicolas Ballas"]
arxiv: "2506.09985"
pdf: "[[topics/papers/JEPA系列/2-03_2506.09985_V-JEPA2.pdf]]"
code: "https://github.com/facebookresearch/vjepa2"
project: "https://ai.meta.com/blog/v-jepa-2-world-model-benchmarks"
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "video-representation", "action-conditioned", "latent-planning", "robot-manipulation", "cem", "video-qa"]
---

# V-JEPA 2: Self-Supervised Video Models Enable Understanding, Prediction and Planning

> [!info] 论文信息
> arXiv [2506.09985](https://arxiv.org/abs/2506.09985) · v1 2025-06-11 · 48 页（正文 23 页 + 附录 A–E）
> PDF：[[topics/papers/JEPA系列/2-03_2506.09985_V-JEPA2.pdf|本地 PDF]]
> 作者：Mahmoud Assran、Adrien Bardes、David Fan、Quentin Garrido 等 29 人（FAIR at Meta；Artem Zholus、Sarath Chandar 来自 Mila / Polytechnique Montréal），Franziska Meier、Yann LeCun、Michael Rabbat、Nicolas Ballas 等列为 Core Team；通讯作者 Nicolas Ballas、Michael Rabbat
> 代码：[facebookresearch/vjepa2](https://github.com/facebookresearch/vjepa2) · [博客](https://ai.meta.com/blog/v-jepa-2-world-model-benchmarks)
> 专题：[[topics/JEPA系列#二、JEPA 奠基与防坍塌正则|JEPA系列 · 二]]

> [!note] 下面各节是 Claude 根据 PDF 正文（§1–9）和附录 A、B 的关键表格写的初稿（2026-11-28）；附录 C–E 的评估细节只扫了一眼。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 两阶段思路："combines internet-scale video data with a small amount of interaction data (robot trajectories), to develop models capable of understanding, predicting, and planning in the physical world."（Abstract，p.1）
> - 四个扩展要素："we extend the V-JEPA framework by exploring larger-scale models, increasing the size of the pretraining data, and introducing a spatial and temporal progressive resolution training strategy"（§2，p.4）
> - 扩展总增益："boosts performance to 88.2%, representing a cumulative 4.0-point improvement over the ViT-L/16 baseline."（§2.2，p.5–6）
> - 渐进分辨率的收益："we achieve an 8.4× reduction in GPU time for a model that can ingest 64-frame, 384×384 resolution inputs"（§2.4，p.8）
> - 动作条件预测器："Our action-conditioned world model is a 300M-parameter transformer network employing a block-causal attention mechanism"（§1，p.3）
> - "无标签"的含义："we do not use additional meta-data indicating any reward, what type of task was being performed in each demonstration, or whether the demonstration was successful or not"（§3.1，p.9）
> - 能量函数的形状："the energy landscape induced by V-JEPA 2-AC is relatively smooth and locally convex, which should facilitate planning."（§4.2，p.13）
> - 规划速度对比："with 10× more samples in each refinement step, the V-JEPA 2-AC world model requires only 16 seconds per action"（§4.2 / 表 3，p.13–15）
> - 相机位置敏感："we manually tried different camera positions before settling on one that worked well across all of our experiments."（§4.3，p.14）
> - 无语言监督的编码器也能对齐 LLM："a video encoder pre-trained without language supervision can be aligned with a language model and achieve state-of-the-art performance, contrary to conventional wisdom"（§1，p.3）

## 一句话总结

两阶段：先把 [[topics/notes/JEPA系列/2-02_V-JEPA|V-JEPA]] 的掩码特征预测放大到 **2200 万样本（100 万小时以上视频 + 100 万张图）、1B 参数 ViT-g、25.2 万步，并在冷却阶段渐进提高到 64 帧 / 384 分辨率**，得到 V-JEPA 2 编码器（SSv2 77.3、EK100 动作预期 R@5 39.7、对齐 8B LLM 后 PerceptionTest 84.0）；再**冻结编码器**，只用 Droid 里不到 62 小时的无标签机器人视频训一个 300M 的块因果动作条件预测器 **V-JEPA 2-AC**，用 CEM 在潜空间最小化到目标图像表示的 L1 距离做 MPC。两个从没出现在训练数据里的实验室的 Franka 机械臂上零样本抓取 / 拿取放置，pick-and-place 平均成功率 65–80%（Octo 10–15%），每步规划 16 秒（Cosmos 4 分钟）。

## 要解决什么问题

- 世界模型若只靠交互数据（state-action + 奖励）学，真实数据太少，难以扩展；用互联网视频训练动作条件视频生成模型（Genie、Cosmos 等）的工作，多数只展示生成质量，**很少真正用来闭环控制机器人**——像素级生成做规划太慢。
- 作者的假设：用 JEPA 在表示空间预测，能从大量**无动作**的观察视频里学到"世界背景知识"，只关注可预测的部分（物体轨迹）而忽略不可预测细节（每片草叶）；再用少量交互数据补上"动作的因果效应"。
- 同时要回答：视频自监督能否像图像/文本那样靠数据和模型规模持续变好？无语言监督的视频编码器能否做视频问答？

## 方法

### 阶段一：V-JEPA 2 预训练（§2，附录 A）

目标沿用 V-JEPA：min ‖P_ϕ(Δy, E_θ(x)) − sg(E_θ̄(y))‖₁，EMA 目标编码器 + stop-gradient，只在被遮 patch 上算损失，3D multi-block 掩码（空间尺度 0.15–0.7、时间全覆盖）。改动：

| 要素 | V-JEPA → V-JEPA 2 | 平均精度变化（图 3，6 个分类任务） |
|---|---|---|
| 基线 | ViT-L/16，VideoMix2M，90K 步 | 84.2 |
| 数据 | 200 万 → 2200 万样本（VM22M） | +1.0 → 85.2 |
| 模型 | ViT-L 300M → ViT-g 1B | +1.5 → 86.7 |
| 训练时长 | 90K → 252K 步（warmup-constant-decay 学习率） | +0.8 → 87.5 |
| 分辨率 | 256→384、16→64 帧（训练和评估都提高） | +0.7 → 88.2 |

- **位置编码**：绝对 sin-cos 换成 3D-RoPE（特征维分三段分别做时、高、宽旋转），作者说大模型训练更稳。
- **数据 VM22M（表 1）**：SSv2 168K（权重 0.056）、Kinetics 733K（0.188）、HowTo100M 1.1M（0.318）、YT-Temporal-1B 19M（0.188，经过检索式筛选）、ImageNet 1M 张图（0.250，复制成 16 帧静态视频）。YT1B 的筛选：按场景切分、算嵌入、用 DINOv2 式的聚类检索去对齐 Kinetics / SSv2 / COIN / EpicKitchen 训练集分布；ViT-L 上筛选比不筛选平均 +1.4。
- **训练配方（表 9）**：batch 3072；主阶段 16 帧、256 分辨率、4 fps，12K 步 warmup 后恒定 lr 5.25e-4；冷却阶段 12K 步，64 帧、分辨率 256/384/512，lr 线性降到 1e-6。EMA 固定 0.99925、weight decay 固定 0.04（V-JEPA 里是线性 ramp，作者发现影响很小）。
- **渐进分辨率**：高分辨率、长片段的代价只在冷却阶段付；对能吃 64×384×384 的 ViT-g，GPU 时间减少 8.4×（直接全分辨率训约需 60 GPU 年）。超过 64 帧（128、256）不再提升。
- 架构（表 12）：ViT-L 300M（宽 1024、24 层）/ ViT-H 600M（1280、32 层）/ ViT-g 1B（1408、40 层）；预训练预测器固定为 22M 的 ViT-s（宽 384、12 层）。

### 阶段二：V-JEPA 2-AC 动作条件世界模型（§3）

- **数据**：Droid 原始数据中 ≥4 秒的片段，左侧外部相机，合计不到 62 小时（约 23K 条轨迹，成功失败都用），**不用奖励、任务类型、成败标签**，只用视频 + 末端状态。
- **输入**：4 秒片段、256 分辨率、4 fps → 16 帧；末端状态 s_k ∈ R⁷（位置 3 + 欧拉角 3 + 夹爪 1）；动作 a_k = 相邻帧末端状态之差。
- **编码**：冻结的 V-JEPA 2 ViT-g **逐帧**编码成 16×16×1408 的特征图 z_k。
- **预测器**：约 300M 的 transformer（24 层、16 头、隐藏 1024），动作 / 状态 / 特征各自线性映射后按时间交错输入；**块因果注意力**（每个时间步内的 patch 可以互看，只能看过去时间步）；patch 用 3D-RoPE，动作和状态 token 只用时间 RoPE。
- **损失（式 2–4）**：teacher-forcing（T=15，每步用真实 z_k 预测 z_{k+1}，L1）+ 两步 rollout 损失（只通过一次递归反传）。
- **规划（式 5）**：给目标图像 x_g，最小化能量 E = ‖P(â_{1:T}; s_k, z_k) − z_g‖₁；用 CEM（800 样本、10 次迭代、top-10、视野 T=1），执行第一步后重规划。每个动作限制在半径 0.075 的 L1 球内（单步末端位移约 13 cm 以内）。pick-and-place 给 3 张子目标图（抓住 → 靠近目标 → 放下），分别优化 4 / 10 / 4 步。

## 实验与关键数字

### 1. 零样本机器人操作（表 2，两个实验室各 10 次试验的成功率）

| 方法 | 实验室 | Reach | Grasp 杯 | Grasp 盒 | 带物到达 杯 | 带物到达 盒 | Pick&Place 杯 | Pick&Place 盒 |
|---|---|---|---|---|---|---|---|---|
| Octo（在全量 Droid 上 BC 微调） | Lab 1 | 100% | 20% | 0% | 20% | 70% | 20% | 10% |
| | Lab 2 | 100% | 10% | 0% | 10% | 70% | 10% | 10% |
| | 平均 | 100% | 15% | 0% | 15% | 70% | 15% | 10% |
| **V-JEPA 2-AC** | Lab 1 | 100% | 70% | 30% | 90% | 80% | 80% | 80% |
| | Lab 2 | 100% | 60% | 20% | 60% | 70% | 80% | 50% |
| | 平均 | 100% | **65%** | **25%** | **75%** | **75%** | **80%** | **65%** |

- 两个实验室都不在 Droid 里，机器人上没有采过任何数据；单目、未标定、低分辨率 RGB 相机。
- 单目标到达（图 8）：三个方向上末端最终都到目标 4 cm 以内，误差单调下降。
- 能量地形（图 9）：扫 Δx、Δy，最小值在 (0, −0.05) 附近，而真实动作是 (0, −0.1)——方向对，幅度只有一半；地形平滑、局部凸。

### 2. 与视频生成世界模型 Cosmos 对比（表 3，Lab 2，同样用 CEM、单张 RTX 4090）

| 方法 | 样本数 | 迭代 | 视野 | 每步耗时 | Reach | Grasp 杯 | Grasp 盒 | P&P 杯 | P&P 盒 |
|---|---|---|---|---|---|---|---|---|---|
| Cosmos（7B 潜扩散，Droid 上动作条件微调） | 80 | 10 | 1 | 4 分钟 | 80% | 0% | 20% | 0% | 0% |
| V-JEPA 2-AC | 800 | 10 | 1 | **16 秒** | **100%** | **60%** | 20% | **80%** | **50%** |

按 4 分钟一步，Cosmos 跑完一次 pick-and-place 要一小时以上。

### 3. 视频理解：冻结 + 4 层 attentive probe（表 4）

| 方法 | 参数 | 平均 | SSv2 | Diving-48 | Jester | K400 | COIN | IN1K |
|---|---|---|---|---|---|---|---|---|
| DINOv2 | 1.1B | 81.1 | 50.7 | 82.5 | 93.4 | 83.6 | 90.7 | 86.1 |
| PE-core-G | 1.9B | 82.3 | 55.4 | 76.9 | 90.0 | **88.5** | **95.3** | 87.6 |
| SigLIP2 | 1.2B | 81.1 | 49.9 | 75.3 | 91.0 | 87.3 | 95.1 | **88.0** |
| V-JEPA ViT-H | 600M | 85.2 | 74.3 | 87.9 | 97.7 | 84.5 | 87.1 | 80.0 |
| InternVideo2s2-1B | 1B | 87.0 | 69.7 | 86.4 | 97.0 | 89.4 | 93.8 | 85.8 |
| V-JEPA 2 ViT-L | 300M | 86.0 | 73.7 | 89.0 | 97.6 | 85.1 | 86.8 | 83.5 |
| V-JEPA 2 ViT-H | 600M | 86.4 | 74.0 | 89.8 | 97.7 | 85.3 | 87.9 | 83.8 |
| V-JEPA 2 ViT-g | 1B | 87.5 | 75.3 | 90.1 | 97.7 | 86.6 | 90.7 | 84.6 |
| V-JEPA 2 ViT-g@384 | 1B | **88.2** | **77.3** | **90.2** | **97.8** | 87.3 | 91.1 | 85.1 |

运动类任务（SSv2、Diving、Jester）全面领先；外观类任务（K400、COIN、IN1K）仍不如 PE / SigLIP2 / InternVideo2（IN1K 85.1 vs 88.0）。作者强调各模型训练数据不同，只能算"系统级"比较。

### 4. 预测：EK100 动作预期（表 5，验证集 mean-class recall@5，预期 1 秒）

| 方法 | 参数 | Verb | Noun | Action |
|---|---|---|---|---|
| InAViT | 160M | 51.9 | 52.0 | 25.8 |
| Video-LLaMA | 7B | 52.9 | 52.0 | 26.0 |
| PlausiVL | 8B | 55.6 | 54.2 | 27.6 |
| V-JEPA 2 ViT-L（冻结） | 300M | 57.8 | 53.8 | 32.7 |
| V-JEPA 2 ViT-g（冻结） | 1B | 61.2 | 55.7 | 38.0 |
| V-JEPA 2 ViT-g@384（冻结） | 1B | **63.6** | **57.1** | **39.7** |

做法：编码器编码 1 秒前的上下文，**预训练预测器**用未来 1 秒那帧的 mask token 预测其表示，编码器 + 预测器输出拼接后进 attentive probe。Action R@5 比 PlausiVL 高 12.1（相对 +44%）。

### 5. 视频问答（表 6–8）

- **受控对比**（Qwen2-7B-Instruct，冻结编码器，1800 万对齐样本，表 6）：V-JEPA 2 ViT-g@512 平均 52.3，PE 49.1、SigLIP2 48.1、DINOv2 45.7；除 PerceptionTest（72.0 vs SigLIP2 72.4）外全部领先，MVP、TemporalBench、TVBench 这类时间理解任务优势最明显。
- **放大编码器 / 分辨率**（端到端训练，表 7）：ViT-L@256 平均 51.7 → ViT-g@512 54.4。
- **SOTA 对比**（8850 万样本，Llama 3.1 8B，按 PerceptionLM 配方，表 8）：

| 方法 | 平均 | PerceptionTest | MVP | TempCompass | TemporalBench | TOMATO | TVBench | MVBench |
|---|---|---|---|---|---|---|---|---|
| PLM 8B | 56.7 | 82.7 | 39.7 | 72.7 | 28.3 | 33.2 | **63.5** | **77.1** |
| V-JEPA 2 ViT-g@384 + Llama 3.1 8B | **59.5** | **84.0** | **44.5** | **76.9** | **36.7** | **40.3** | 60.6 | 73.5 |

注意表 8 说明：V-JEPA 2 的 PerceptionTest 是**测试集 + SFT**，其他模型是零样本。

## 局限 / 存疑

> §4.3、§6 末尾和 §9 是作者自己写的局限；后面几条是 Claude 的推断，请核对。

- **作者承认**：
  - 对**相机位置敏感**：没有标定，模型要从单目图像里隐式推断动作坐标轴；实际部署时手动试了多个相机位置才选定一个（附录 B.4 定量显示推断的坐标轴随相机角度旋转）。只用 Droid 左侧相机训练，左右混用反而变差。
  - **长视野规划**难：自回归误差累积、搜索空间指数增长；pick-and-place 需要人给子目标图，目前规划视野 T=1（作者说任务足够"贪心"）。
  - 只支持**图像目标**，不支持语言目标。
  - EK100 只测 1 秒预期，更长视野会退化；只在厨房、闭集词表。
  - 模型只到 1B 参数。
- **机器人评估规模小**：每格 10 次试验、两个实验室、两种物体（杯、盒），没有置信区间；Cosmos 对比只在 Lab 2 做，而且 Cosmos 每步只用 80 个样本（V-JEPA 2-AC 用 800），算力预算不对等。
- **Octo 基线**是在全量 Droid 上做目标图像 BC 微调，与 V-JEPA 2-AC 的数据量（<62 小时子集）和使用方式都不同；Octo 每步给 4 个动作、两帧上下文，比较的是两种范式而不是同条件下的模型。
- 能量最小点只有真实动作幅度的一半（图 9），说明潜空间距离对"走多远"的刻画偏弱，作者用"不需要精确感知"正面解读。
- 防坍塌依旧完全靠 EMA + stop-gradient；[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 一类工作认为这种目标学出的潜路径不平滑——这里的规划视野只有 1 步，局部几何的问题可能还没暴露。
- **需核对的数字**：
  - 模型规模增益：§2.4 和图 3 说 +1.5，图 5 说明文字说 +1.7。
  - 训练步数：§2.4 是 12K warmup + 228K 恒定 + 12K 冷却 = 252K；图 5 说明文字写成"252K 步 16 帧 + 12K 冷却"；表 9 的主阶段步数写的是"Variable"（训到 IN1K / COIN / SSv2 不再涨为止）。
  - YT1B 时长：§2.3 正文说 140 万视频小时，表 1 写 1.6M 小时。
  - 附录 A.4.1 显示 ViT-L 简版配方下，混合数据 + 筛选后的 YT1B 在 SSv2 上（72.8）反而不如混合 + 未筛选（73.3）；"筛选总是有益"的结论只在单独 YT1B 时成立。

## 与其他论文的关系

- **前身**：[[topics/notes/JEPA系列/2-02_V-JEPA|V-JEPA]]（同一目标、掩码、L1 损失，本文主要做规模化）→ 再往前是 [[topics/notes/JEPA系列/2-01_I-JEPA|I-JEPA]]。
- **JEPA 世界模型的标杆**：V-JEPA 2-AC 是"冻结预训练视觉编码器 + 动作条件预测器 + CEM/MPC 在潜空间到目标图像表示"这一范式的大规模真机版本。作者把 DINO-WM（Zhou et al. 2024，[[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]]）和 PLDM（Sobal et al. 2025，[[topics/notes/JEPA系列/1-03_PLDM|PLDM]]）列为最接近的工作，区别在于把同样的原则放到真实机器人上。本专题一节里的 JEPA 世界模型工作（如 [[topics/notes/JEPA系列/1-06_WhatDrivesSuccess|What Drives Success]]、[[topics/notes/JEPA系列/1-05_LeWM|LeWM]]）可以和它对照着读（它们与本文的具体关系未在本文中核对）。
- **防坍塌**：stop-gradient / EMA 一系；对照 [[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]]（SIGReg）。[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 讨论了 SG 目标对潜空间几何的影响，与 V-JEPA 2-AC 的 L1 能量规划直接相关。
- **概率化**：[[topics/notes/JEPA系列/1-12_VJEPA|VJEPA]] 把 V-JEPA 2-AC 当作"确定性 JEPA 世界模型、隐含假设预测充分性"的代表来批评。
- **生成式世界模型对照**：Cosmos（Agarwal et al. 2025）——本文第一次报告了用 Cosmos 做机器人控制的尝试。VLA 对照：Octo；作者认为 VLA 只能用成功示范，而 V-JEPA 2-AC 成功失败轨迹都能用。
- 自我中心视频 + JEPA 的机器人方向，可以对照库里的 [[xsquare/notes/23_EgoJEPA|EgoJEPA]]。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> A major challenge for modern AI is to learn to understand the world and learn to act largely by observation (LeCun, 2022). This paper explores a self-supervised approach that combines internet-scale video data with a small amount of interaction data (robot trajectories), to develop models capable of understanding, predicting, and planning in the physical world. We first pre-train an action-free joint-embedding-predictive architecture, V-JEPA 2, on a video and image dataset comprising over 1 million hours of internet video. V-JEPA 2 achieves strong performance on motion understanding (77.3 top-1 accuracy on Something-Something v2) and state-of-the-art performance on human action anticipation (39.7 recall-at-5 on Epic-Kitchens-100) surpassing previous task-specific models. Additionally, after aligning V-JEPA 2 with a large language model, we demonstrate state-of-the-art performance on multiple video question-answering tasks at the 8 billion parameter scale (e.g., 84.0 on PerceptionTest, 76.9 on TempCompass). Finally, we show how self-supervised learning can be applied to robotic planning tasks by post-training a latent action-conditioned world model, V-JEPA 2-AC, using less than 62 hours of unlabeled robot videos from the Droid dataset. We deploy V-JEPA 2-AC zero-shot on Franka arms in two different labs and enable picking and placing of objects using planning with image goals. Notably, this is achieved without collecting any data from the robots in these environments, and without any task-specific training or reward. This work demonstrates how self-supervised learning from web-scale data and a small amount of robot interaction data can yield a world model capable of planning in the physical world.
