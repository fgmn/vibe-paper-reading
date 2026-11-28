---
id: "2-07"
org: 专题·JEPA系列
short: "MotionJEPA"
title: "MotionJEPA: Preventing Temporal Feature Collapse by Capturing Visual Changes in Latent Space"
aliases: ["MotionJEPA", "DISReg", "Difference Image and Single image embedding Regularization"]
date: 2026-09-20
category: "JEPA 奠基与防坍塌正则"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "University of Oxford；vivo Tech Research GmbH；Bielefeld University；Slater Labs；Cold Spring Harbor Laboratory；Brown University；AMI Labs；vivo BlueImage Lab"
partners: []
authors: ["Markus Karmann", "Shile Li", "Christian Internò", "Bruno Andreis", "David Klindt", "Randall Balestriero", "Jindong Gu", "Philip Torr", "Qi Zhang", "Peng-Tao Jiang", "Hao Zhang", "Bo Li", "Onay Urfalioglu"]
arxiv: "2609.23881"
pdf: "[[topics/papers/JEPA系列/2-07_2609.23881_MotionJEPA.pdf]]"
code: "https://github.com/mkarmann/motion-jepa"
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "anti-collapse", "feature-suppression", "slow-feature", "latent-planning", "sigreg"]
---

# MotionJEPA: Preventing Temporal Feature Collapse by Capturing Visual Changes in Latent Space

> [!info] 论文信息
> arXiv [2609.23881](https://arxiv.org/abs/2609.23881) · v1 2026-09-20 · 24 页（正文 9 页 + 附录）
> PDF：[[topics/papers/JEPA系列/2-07_2609.23881_MotionJEPA.pdf|本地 PDF]]
> 作者：Markus Karmann\*（Oxford）、Shile Li\*（vivo Tech Research）、Christian Internò（Bielefeld、Oxford）、Bruno Andreis（Oxford、Slater Labs）、David Klindt（CSHL）、Randall Balestriero（Brown、AMI Labs）、Jindong Gu（Oxford）、Philip Torr（Oxford、Slater Labs）、Qi Zhang、Peng-Tao Jiang、Hao Zhang、Bo Li（vivo BlueImage Lab）、Onay Urfalioglu（vivo Tech Research）。\* 共同一作
> 代码：[mkarmann/motion-jepa](https://github.com/mkarmann/motion-jepa)
> 专题：[[topics/JEPA系列#二、JEPA 奠基与防坍塌正则|JEPA系列 · 二]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录 7–10 节和表 4–10）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 问题："However, standard JEPA training exhibits a strong inductive bias towards slow features, causing feature suppression and the collapse of latent representation."（Abstract，p.1）
> - 逆动力学的局限："While inverse dynamics provides temporal anti-collapse, it relies on action labels and offers little incentive to embed general, unlabeled dynamics."（Abstract，p.1）
> - 图 1 的现象："When trained from scratch, visual probes of the image embeddings show that SIGReg encodes the slowly changing scoreboard and bats but suppresses the ball. IDM encodes only the action-controlled bats. DISReg preserves all three."（图 1 说明，p.1）
> - 动态项的性质："This dynamic term does not constrain the shape or distribution of the image embedding and only incentivizes that features that change between frames are present…"（§1，p.2）
> - 不需要标签："This design has the advantage that we do not require action or state labels as targets, therefore introducing no bias towards labeled features."（§3，p.3）
> - λ 的含义："Setting λ_d = 0 allows d to collapse and DiffPred_β to trivially predict a constant, imposing no additional dynamic feature embeddings on z_t and z_t+1, which resembles LeWM [22]."（§3，p.4）
> - 随机权重模型也有信息："This shows that even though the feature information is accessible at the start of training, models actively suppress it during training."（§4.1，p.6）
> - 坍塌看不出来："Crucially, the collapse is not visible in the training loss (see first column), demonstrating that monitoring loss alone is insufficient to diagnose collapse without explicit latent probing or downstream evaluation."（§4.1，p.7）
> - 唯一全部低于 0.1："MotionJEPA is also the only method that achieves a balanced probing loss below 0.1 on all categories, indicating robustness against feature collapse."（§4.1，p.6）
> - 与 IDM 互补："Combining our objective with IDM yields the best overall results, further indicating that the two training signals are complementary."（§4.2，p.8）
> - 局限："DISReg introduces two additional modules, DiffEnc_α and DiffPred_β, both increasing the parameter count and compute cost relative to a plain JEPA baseline."（§5，p.9）

## 一句话总结

标准 JEPA 世界模型（如 SIGReg 防坍塌的 LeWM）偏爱慢特征：静止的比分牌、背景被编码进去，快速运动的球、仙人掌反而被压掉；逆动力学（IDM，预测动作）能防时间坍塌，但只保留受动作控制的东西，还需要动作标签。MotionJEPA 加了一个正则 **DISReg**：用一个单独的编码器把**帧差图** o_{t+1}−o_t 编码成 d_t，再要求一个小 MLP 从相邻两帧的嵌入 (z_t, z_{t+1}) 预测 d_t；z 和 d 各加 SIGReg 防坍塌。这样不需要动作标签、不做像素重建，也不直接约束 z 的分布，就逼着 z 编码"帧间变化了什么"。三个合成游戏（Pong、Dino、Golf）里，它是唯一一个所有特征组探针 NMSE 都低于 0.1 的方法；在加了木纹静态背景干扰的四个 LeWM 任务上，25 步规划平均成功率 81.8%（LeWM 20.4%），和 IDM 合用到 86.4%。

## 要解决什么问题

- **特征压制 / 慢特征偏置**：JEPA 避开了"全部坍塌成常数"，但不保证所有任务相关因子都留在表示里。已有工作（Sobal et al.）发现 JEPA 会编码固定的、轨迹特定的干扰物，忽略更快的前景动态；JEPA 规划对背景变化也敏感。
- 防坍塌机制决定了这种偏置：
  - **SIGReg（LeWM）**：在 batch 维上把嵌入分布推向各向同性高斯，静止/慢变的背景、比分牌很容易提供 batch 内方差，于是挤掉快变物体。
  - **逆动力学（SMWM、Delta-JEPA）**：从相邻两帧嵌入预测动作，保住受控自由度，但需要动作标签；不受控的动态（球、障碍物）没有激励；动作效果有时延时也不合适。
- 作者想要一个**视觉落地、无标签**的时间防坍塌信号，让静态和动态特征都被平衡地编码。

## 方法

### 设定（§3）

离线轨迹 D = {(o_1, a_1, …, o_T)}，行为策略任意。编码器 Enc_θ: o_t → z_t ∈ R^{D_z}；前向预测器 ẑ_{t+1} = Pred_φ(z_{t−H+1:t}, a_{t−H+1:t})（H 为历史窗口）；不做像素重建。

### DISReg（式 1–5，算法 1）

| 组件 | 定义 |
|---|---|
| 帧差编码器 | d_t = DiffEnc_α(o_{t+1} − o_t)，架构同 Enc_θ（ViT-Tiny） |
| 帧差预测器 | d̂_t = DiffPred_β(z_t, z_{t+1})，三层 MLP（隐层 512，LayerNorm + GELU），输入为两帧嵌入拼接 |
| 防坍塌 | L_z = SIGReg(z)，L_d = SIGReg(d)（也可换 SWD 等分布正则） |
| 预测 | L_pred = MSE(d_t, d̂_t) |
| 合起来 | L_DISReg = λ_z L_z + λ_d L_d + λ_pred L_pred；**L_MotionJEPA = L_DISReg + MSE(z_{t+1}, ẑ_{t+1})** |

- 全部实验用同一组超参：**λ_z = 0.25、λ_pred = 0.5、λ_d = 2**。
- 两个旋钮的含义：
  - λ_d = 0 → d 可以坍塌成常数，DiffPred 平凡地预测常数，对 z 没有额外动态约束，**退化成 LeWM**；
  - λ_z = 0 → 最大化 z 里的动态信息，模型只关注帧差里提取的运动。
- 关键点：L_pred 让 z_t、z_{t+1} 都必须携带"转移相关"的信息，但**不对 z 的形状或分布加任何约束**；帧差图只依赖视觉，不依赖动作或状态标签。DiffEnc、DiffPred 只在训练时用，推理时丢掉。

### 基线（§3 末）

LeWM（SIGReg 权重 0.09）、SMWM（逆动力学权重 1.0），以及 LeWM 的三个常见改法：LeWM-Time（SIGReg 沿时间维）、LeWM-Flat（沿 batch×time 展平维）、LeWM-Detached（预测目标加 stop-gradient）；ForwardOnly（只有前向预测、不防坍塌）；Random（随机初始化冻结权重）。带 \* 的是对每个"基线 × 环境"做了网格搜索（λ ∈ {0.1, …, 100}，按 5 步 rollout 的残差 MLP 探针选），MotionJEPA 始终用固定超参（表 4）。

## 实验与关键数字

### 1. 合成游戏的坍塌分析（§4.1）

- **环境**：Pong（球、两块板、比分）、Dino（恐龙、仙人掌、云、红心、天空颜色）、Golf（球、横条障碍、十字障碍、木纹背景）。全部合成、确定性、在线生成样本；初始状态和动作随机，减少特征间相关性（避免"从球推板"这种捷径）。真实状态维度（不含速度）Pong 6、Dino 8、Golf 6，远小于 D_z = 192，排除维度瓶颈。
- **协议**：所有方法共用 LeWM 的编码器（ViT-Tiny，patch 14，CLS + 1 层 BN-MLP 投影）、预测器（6 层因果 Transformer）、训练日程和优化器；从零训练 1000 万个随机回合，冻结后在 100 万样本上训练高容量残差 MLP 探针（深 6、宽 128），在 1 万回合上评估。指标 NMSE：1.0 = 只会预测均值。3 个种子平均。

**表 1(a) 图像嵌入 z 的探针 NMSE（越低越好；只列文本能可靠对上的行）**：

| 方法 | Pong 平均 | Pong 球 / 板 / 比分 | Dino 平均 | Golf 平均 | Golf 横条障碍 |
|---|---|---|---|---|---|
| ForwardOnly | 1.058 | 1.260 / 1.001 / 0.930 | — | — | — |
| Random（未训练） | 0.116 | 0.143 / 0.093 / 0.115 | — | — | — |
| SMWM | 0.657 | 1.001 / 0.002 / 1.002 | — | — | — |
| LeWM | 0.658 | 0.999 / 1.002 / 0.003 | — | — | — |
| LeWM\* | 0.061 | 0.163 / 0.018 / 0.012 | — | — | — |
| LeWM-Flat\* | 0.008 | 0.012 / 0.004 / 0.008 | — | — | — |
| **MotionJEPA** | **0.004** | 0.005 / 0.003 / 0.004 | **0.021** | **0.061** | **0.095** |

- Pong 各行取自附录表 8（带标准差，排版清楚）；Dino、Golf 的基线行在正文表 1 的 PDF 文本里列序错乱，Claude 没有逐格还原，需对照 PDF 原表。
- MotionJEPA 在 Dino 上：仙人掌 0.011、云 0.037、恐龙 0.006、红心 0.006、天空 0.004；Golf 上：横条 0.095、十字 0.083、球 0.033、木纹 0.033。正文说 Golf 横条上**其他方法都 >0.3**。
- 现象：ForwardOnly 除 Dino 天空（0.511）外全部坍塌；**随机权重模型反而能读出不少信息**（Pong 平均 0.116、Dino 天空 0.004）→ 训练过程在主动压制特征。LeWM 默认参数只留慢/静态特征（如 Pong 比分）；调参后的 LeWM\* 在 Pong 从 0.658 降到 0.061，但在 Dino、Golf 上调参帮助不大（附录图 7）。LeWM-Time 是除本文外唯一编码了 Dino 仙人掌的变体，但在 Golf 上完全失败；SMWM 只保住受动作影响的状态（Pong 板 0.002，球和比分 ≈1）。
- **表 1(b) 5 步 rollout ẑ 的探针**：MotionJEPA 仍是三个环境平均最低（Pong 0.036、Dino 0.055、Golf 0.164），但 rollout 后并非全部低于 0.1（如 Golf 十字 0.348、Dino 仙人掌 0.243、Pong 球 0.122）。"唯一全部低于 0.1"只针对 (a)。附录表 5 的线性探针也是本文平均最低。

### 2. 坍塌何时发生（图 3，Dino）

- 在线 MLP 探针（stop-gradient）显示：天空、红心约 1 万步就饱和到 0.01 NMSE。LeWM 中，恐龙的探针误差先在约 5k 步降到 ≈0.1，再在约 20k 步回升到 1.0 且不再恢复——慢特征把它挤掉了。LeWM-Flat 很快抓住恐龙（跳跃动作简单但时间变化稳定）。
- **训练损失曲线上看不出坍塌**，必须靠探针或下游评估。

### 3. 潜路径直度（表 2；100 条状态空间线性插值，弧长 / 弦长，1.0 = 直线）

| 方法 | Pong | Dino | Golf |
|---|---|---|---|
| ForwardOnly | 45.514 | 4.045 | 26.412 |
| Random | 25.278 | 13.660 | 26.842 |
| SMWM | 1.207 | 7.557 | 1.078 |
| LeWM | 5.170 | 4.826 | 8.471 |
| LeWM-Time | 29.911 | 4.955 | 27.190 |
| LeWM-Detached | 3.067 | 18.372 | 15.455 |
| LeWM-Flat | 3.031 | 12.986 | 5.298 |
| SMWM\* | 1.427 | 8.631 | 1.078 |
| LeWM\* | 8.170 | 7.755 | 8.191 |
| LeWM-Time\* | 23.376 | 9.979 | 38.839 |
| LeWM-Detached\* | 4.111 | 8.806 | 7.935 |
| LeWM-Flat\* | 22.159 | 15.610 | 26.663 |
| **MotionJEPA** | 2.756 | 5.789 | 3.305 |

- SMWM 最直（无分布正则，但也坍塌了很多特征）；沿时间维加分布约束（LeWM-Time\*、LeWM-Flat\*）让曲率飙到 20 以上。MotionJEPA 在 Pong、Golf 上比所有分布正则方法都直；Dino 上不是最好（LeWM 4.826、ForwardOnly 4.045 更低，但它们坍塌了）。
- 图 4（Golf 单特征扫描的前两个主成分）：MotionJEPA 的球位置几乎是直线，十字和横条障碍是单圈闭环（障碍出界后从另一侧回来）；LeWM 把障碍压成一个点，却在木纹背景上画出高曲率轨迹。

### 4. 下游规划：静态木纹背景干扰（§4.2，表 3）

- 设置沿用 LeWM：Cube（OGBench）、PushT、Reacher、TwoRoom；把背景换成木纹图，每条 rollout 随机裁一块、回合内固定（Reacher、Cube 用训练集逐像素中值估背景掩码再替换）。10 epoch，批 64，AdamW lr 5e-5、wd 1e-3。CEM：300 条候选、30 精英，frame skip 5；25 步 = 规划 5 个模型步；50 步 = 先规划执行 25 步、再重规划 25 步。
- IDM 是作者自己的实现：三层 MLP 从 Δz_t = z_{t+1} − z_t 预测原始动作（沿 Delta-JEPA 的 Δz 输入）。

| 规划成功率 % | Cube | PushT | Reacher | TwoRoom | 平均 |
|---|---|---|---|---|---|
| **25 步** | | | | | |
| LeWM | 43.6 | 4.0 | 5.2 | 28.8 | 20.4 |
| LeWM-Flat | 55.2 | 14.4 | 49.2 | 48.0 | 41.7 |
| IDM | 76.0 | 83.6 | 49.2 | 100.0 | 77.2 |
| Ours（λ_z = 0） | 60.4 | 76.8 | 24.8 | 99.6 | 65.4 |
| **Ours** | 78.0 | 78.4 | 71.2 | 99.6 | 81.8 |
| **Ours + IDM** | 80.8 | 82.4 | 82.4 | 100.0 | **86.4** |
| **50 步** | | | | | |
| LeWM | 24.4 | 2.4 | 2.0 | 18.4 | 11.8 |
| LeWM-Flat | 42.4 | 2.0 | 60.4 | 22.8 | 31.9 |
| IDM | 53.2 | 26.0 | 62.0 | 96.0 | 59.3 |
| Ours（λ_z = 0） | 48.0 | 21.2 | 33.6 | 94.0 | 49.2 |
| **Ours** | 63.2 | 28.0 | 98.0 | 92.0 | 70.3 |
| **Ours + IDM** | 61.2 | 29.6 | 98.4 | 97.2 | **71.6** |

- LeWM 加了木纹背景后崩得很厉害（PushT 4.0%、Reacher 5.2%）。单独的 MotionJEPA 平均胜过 IDM（不需要动作标签），Cube 和 50 步 Reacher 提升最大；λ_z = 0 的消融变差 → 保留全局状态信息（静态项）也重要。
- 正文说把帧差目标加到 IDM 上"在 25 步规划中一致提升"，但按表 3，**PushT 从 83.6 降到 82.4**，并非逐项都提升；50 步时 Cube 上 Ours + IDM（61.2）也低于 Ours（63.2）。
- Reacher 上几乎所有方法 50 步都比 25 步高（Ours 71.2 → 98.0），应该是因为多一次重规划、步数更多，不是笔误；但幅度很大，值得核对。

### 5. LeWM 任务上的状态探针（附录 §10，表 6–7，木纹干扰）

| 探针（MLP，误差越低越好） | LeWM | LeWM-Flat | IDM | Ours | Ours + IDM |
|---|---|---|---|---|---|
| Reacher 关节 0（rad） | 0.735 | 0.111 | 1.162 | 0.0141 | 0.0100 |
| Reacher 指尖 xy | 0.126 | 0.0738 | 0.166 | 0.0061 | 0.0042 |
| Cube 物体 xyz | 0.126 | 0.0546 | 0.0046 | 0.0103 | 0.0059 |
| Cube 物体 yaw（rad） | 0.529 | 1.382 | 1.522 | 0.708 | 0.841 |

- PushT/TwoRoom（表 6）的列标签在 PDF 文本里缺失，按段落描述推测是 PushT 智能体位置 / T 形物体位置 / 物体朝向 / TwoRoom 智能体位置：LeWM 的 MLP 探针 121.17 / 73.66 / 0.788 / 45.33，Ours 8.60 / 18.20 / 0.397 / 1.48。列对应需核对。
- 有意思的是 IDM 在 Cube 物体位置上最好（0.0046），但在 Reacher 关节上很差（1.162）；Cube 的 yaw 所有方法都读不好（LeWM 0.529 反而最低）。

## 局限 / 存疑

- **论文自己写的局限（§5）**：DISReg 多了 DiffEnc 和 DiffPred 两个模块，参数量和训练计算更大。作者的回应：图 3 显示基线的 NMSE 平台期不是训练更久能解决的；两个模块推理时丢弃，无额外开销。
- 以下是 Claude 的推断：
  - **帧差图依赖静止相机**：o_{t+1} − o_t 能把"动的东西"分出来，前提是相机不动、背景像素对齐。第一人称或移动相机的视频里，帧差会被自运动占满，DISReg 的效果没有验证。
  - **干扰物只测了"静态背景"**：木纹在回合内固定，正好是帧差里会被抵消的那类；对动态干扰（如 Sobal et al. 里每步变化的噪声、移动的无关物体），帧差项反而会鼓励编码它们，论文没测。
  - **合成游戏是作者自己设计的**，特征可分、维度很低；LeWM 的四个任务只是换了背景，环境本身规模小。
  - **基线调参不对称**：基线在游戏环境上做了网格搜索，但在 LeWM 规划任务上用的是默认设置（表 3 没有 \* 版本）；MotionJEPA 全程固定超参，这点对它有利也不利，但 LeWM-Flat 等是否充分调参不清楚。
  - 规划实验没有给出种子数和方差（表 3 只有单个数）。
- 表 1 正文版排版错乱，Dino / Golf 基线数值需对照 PDF 原表或附录表 9–10。

## 与其他论文的关系

- **直接对照**：[[topics/notes/JEPA系列/1-05_LeWM|LeWM]]（SIGReg 防坍塌的像素世界模型，本文的主基线和代码基础）、SMWM / Delta-JEPA（逆动力学防坍塌）。SIGReg 来自 [[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]]。
- **同一现象的另一种解法**：[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 引用了 "Karmann et al. 2026 报告 LeWM 在 Pong 里把球压掉、SG 版本能恢复"，应该就是本文（作者 Karmann）。两篇都说 SIGReg 类分布正则会丢内容，但开的药方相反：Slow SVReg 用慢通道 + 门控残差**偏好慢因子**，因为它丢的是慢变、难预测的物体；MotionJEPA 用帧差**偏好快因子**，因为它面对的是静态背景挤掉快速物体。合起来看，"丢哪类特征"取决于干扰物和目标物谁更慢。
- **慢特征偏置**：本文的问题设定和评估方式（探针看特征是否被压掉）直接沿用 Sobal et al. 2022 "JEPAs focus on slow features"，即 [[topics/notes/JEPA系列/2-04_JEPASlowFeatures|JEPA Slow Features]]（参考文献 [26]）。本文引用的理论工作 [19] 把 LeJEPA 的时间对齐目标与慢特征分析联系起来，就是 [[topics/notes/JEPA系列/3-02_WhenLeJEPAWorldModel|When Does LeJEPA Learn a World Model?]]（Klindt、LeCun、Balestriero，两位作者也在本文作者表里）。
- **时间拉直**：表 2 的路径直度呼应 [[topics/notes/JEPA系列/1-04_TemporalStraightening|Temporal Straightening]]；本文发现沿时间维加 SIGReg 会显著变弯。
- 规划协议来自 [[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]] / LeWM 的 CEM-MPC。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Joint Embedding Predictive Architectures (JEPAs) are a promising paradigm for learning task-agnostic latent world models without visual reconstruction. However, standard JEPA training exhibits a strong inductive bias towards slow features, causing feature suppression and the collapse of latent representation. While inverse dynamics provides temporal anti-collapse, it relies on action labels and offers little incentive to embed general, unlabeled dynamics. We introduce Difference Image and Single image embedding Regularization (DISReg), a novel regularizer that builds on an inverse-dynamics-style module that predicts temporal difference image embeddings without any pixel reconstruction loss, encouraging balanced static and dynamic feature learning. DISReg consists of a static term that shapes the distribution of the image embedding and encourages slow features, and a dynamic term, which, unlike direct regularization on the embedding, imposes no constraint on the image embedding's shape or distribution and instead only incentivizes that dynamic features be present. By integrating this regularizer into a standard JEPA, we establish our new architecture, MotionJEPA. Latent probing demonstrates that MotionJEPA produces more complete representations than other methods, and our trajectory analysis shows it maintains geometrically simple latent embeddings with low curvature. We further show that MotionJEPA improves downstream planning success under static-background distractors across four environments. Code available: https://github.com/mkarmann/motion-jepa.
