---
id: "1-08"
org: 专题·JEPA系列
short: "SD-JEPA"
title: "Subspace-Decomposed JEPAs: Disentangling Progression and Content in Latent World Models"
aliases: ["SD-JEPA", "Subspace-Decomposed JEPAs"]
date: 2026-05-29
category: "JEPA 世界模型与规划"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "LIX, École Polytechnique；IRT SystemX；Safran Tech"
partners: []
authors: ["Lucas Thil", "Jesse Read", "Rim Kaddah", "Guillaume Doquet"]
arxiv: "2605.31111"
pdf: "[[topics/papers/JEPA系列/1-08_2605.31111_SD-JEPA.pdf]]"
code: "https://github.com/LucasStill/SD-JEPA"
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "sigreg", "progress-representation", "interpretability", "triplet-loss"]
---

# Subspace-Decomposed JEPAs: Disentangling Progression and Content in Latent World Models

> [!info] 论文信息
> arXiv [2605.31111](https://arxiv.org/abs/2605.31111) · v3 2026-10-08（v1 2026-05-29）· 23 页（正文 9 页 + 附录 A–G）
> [代码](https://github.com/LucasStill/SD-JEPA)
> PDF：[[topics/papers/JEPA系列/1-08_2605.31111_SD-JEPA.pdf|本地 PDF]]（v3）
> 作者：Lucas Thil（LIX École Polytechnique、IRT SystemX）、Jesse Read（LIX）、Rim Kaddah（IRT SystemX）、Guillaume Doquet（Safran Tech）
> 专题：[[topics/JEPA系列#一、JEPA 世界模型与规划|JEPA系列 · 一]]

> [!note] 下面各节是 Claude 根据 PDF 全文（v3，含附录 A–G）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 核心主张："describing a scene takes many dimensions, but where the scene stands on its way to the goal can be summarised by only a few."（Abstract，p.1）
> - 现有潜变量缺的东西："What they do not offer is a place where one can read where the agent is in its task."（§1，p.1）
> - 两种防坍塌力不在同一坐标上："Each loss sees only its own coordinates, so the two anti-collapse forces cannot cancel or duplicate each other on the same dimensions."（§1，p.2）
> - 三元组损失不显式排序："The loss does not order frames explicitly: it asks consecutive frames of a trajectory to stay close in direction while different trajectories stay apart."（§5.1，p.4–5）
> - 结论只是持平："All four differences are smaller than the seed-to-seed standard deviation of either method, so we read them as parity, not improvement."（§6.2，p.5）
> - 只用进度块规划不行："planning with the progression block alone reaches only 28% on Push-T, since a few coordinates cannot describe a goal scene."（§6.3，p.6）
> - 消融只是单种子："We therefore treat the ablation as indicative."（§6.4，p.6）
> - θ 既像时钟又像任务阶段："So θt is partly a clock and partly a task-phase coordinate, and it becomes less clock-like as k grows."（§7.2，p.7）
> - 跨回合不校准："θt is a phase coordinate within a trajectory, not a calibrated distance shared across episodes."（§7.2，p.7）
> - 事件检测的公允解读："The fair reading is that changes in θt sit closer to task events than prediction error does, not that θt is a precise event detector."（§7.3，p.8）

## 一句话总结

在 LeWM（端到端像素 JEPA + SIGReg）上把 192 维潜向量切成两块：前 k（2/4/8，占 1%–4%）维是**进度子空间**，用余弦间隔三元组损失约束"同一轨迹相邻帧方向接近、不同轨迹分开"；剩下的是**内容子空间**，只对它施加 SIGReg；预测损失仍作用于整个潜向量，不加参数。结果：四个 LeWM 基准上规划与 LeWM **持平**（差异小于种子标准差），但潜变量变得可读——8 维进度坐标的回合内线性探针 R² 在 Cube/Push-T/Reacher 上达到 0.91/0.91/0.95，远高于时间步；进度块前两维构成的角度 θ_t 随任务推进、回退时倒转，在抓取/释放附近变化最快，场景被替换后会跳变并停在新的区间。

## 要解决什么问题

- JEPA 世界模型（PLDM、DINO-WM、LeWM）的潜变量适合预测，也已知会变慢、变直，但**没有一个固定位置能读出"任务进行到哪了"**，想知道就得训练后拟合探针、碰运气。
- 而进度正是规划器从起点走向目标时要推理的量；作者认为它可以很紧凑（场景内容需要很多维，进度几维就够），理由来自三条线：深度表征的内在维度低 / 意识先验 / 全局工作空间；语言模型里时间、空间可线性解码但分散在各处；控制问题本质是"朝目标移动"（VIP、LIV、quasimetric、Hilbert 表征等时间距离表征有用）。
- 无监督解耦不可辨识（Locatello et al.），需要归纳偏置；帧序是每个轨迹数据集免费提供的弱信号。
- 已有时间距离表征方法让**整个**表征围绕时间距离组织；本文只占用几维，其余 JEPA 潜变量不动。

## 方法

### 基座：LeWM（§4）

编码器 z_t = f_θ(o_t) ∈ R^D，预测器 ẑ_{t+1} = p_φ(z_{t−H+1:t}, a_t)。L_LeWM = ‖ẑ_{t+1} − z_{t+1}‖² + λ·SIGReg(z)；SIGReg 把批内潜变量投到 M 个随机方向，对每个方向做 Epps–Pulley 正态性检验再平均，只约束边缘分布 p(z)。规划用 CEM 让预测潜变量接近目标图像嵌入。

### 切分潜向量（§5.1，式 3–5）

z_t = [z_t^prog ; z_t^cont]，z^prog ∈ R^k，z^cont ∈ R^{D−k}，D=192，k ∈ {2, 4, 8}。

L_SD = L_pred(z) + λ_S·SIGReg(z^cont) + λ_T·L_trip(z^prog)

| 项 | 作用对象 | 细节 |
|---|---|---|
| L_pred | 整个 z | 不变 |
| SIGReg | 只作用于 z^cont | 随机方向在 R^{D−k} 里采样；λ_S = 0.09，1024 个随机投影 |
| 三元组损失 | 只作用于 z^prog | max(0, m − cos(a,p) + cos(a,n))，m=0.2，λ_T = 0.10；在 LeWM 的 4 帧训练窗口里，锚点 = 中间帧，正样本 = 同轨迹下一帧，负样本 = 批内另一条轨迹同位置帧（批的随机非零 roll）；复用预测损失已算好的嵌入，不增加前向 |

- λ_T=0 且 SIGReg 作用于全 z 时退化为 LeWM。
- **Remark 1（梯度支撑分离）**：两个正则在潜变量层面梯度互补、互不补偿；作者明说只在潜变量层面成立，两者都会通过共享编码器权重互相影响，切分是否有用要看实验（§6.4）。附录 A 给一般正交块形式，并列出切分会失效的情况：环境没有一致的回合时间结构、任务有多条分叉进度、k 太大使进度块吸收内容。
- 动机里的理论框架：Garrido et al. 2023 的"样本对比 / 维度对比"对偶——三元组和 SIGReg 属于同一族，作用于同一坐标就会推同一方向。

### 读出与规划（§5.2，式 6）

- θ_t = atan2(z^prog_{t,2}, z^prog_{t,1})，r_t = ‖z^prog_t‖；余弦三元组作用于方向，所以读角度。§7 都用 θ_t 和 |Δθ_t|。
- 规划：LeWM 的 CEM 不变（300 条候选、30 精英、Push-T 30 轮、其他 10 轮），**默认代价只比较内容块** ‖ẑ^cont_H − z^cont_g‖²，也报告全潜向量代价。
- 尝试过但没用的东西（附录 D）：给预测器加 (θ, r) 条件、角度规划代价、显式拉直损失 —— 都没提升规划，没放进模型。

### 实现（§6.1，附录 C）

ViT-tiny 编码器（patch 14）+ 6 层 transformer 预测器（AdaLN-zero 动作条件），共 18M 参数；224×224 图像，frameskip 5，历史 3 帧预测 1 步；AdamW lr 5e-5、wd 1e-3、余弦退火；10 epoch、批 128（LeWM 预算）；bf16，梯度裁剪 1.0。评估协议照搬 LeWM：50 步回合、目标 25 步外、规划时域 5。三个种子（0、42、3072）。

## 实验与关键数字

### 1. 规划成功率（表 1，%，内容块代价，三种子均值）

| 方法 | Two-Room | Reacher | Push-T | OGB-Cube |
|---|---|---|---|---|
| LeWM（论文发表值） | 87±3.0 | 86±5.0 | 96±2.8 | 74±3.5 |
| SD-JEPA k=2 | 90.0±2.0 | 84.0 | 94.0 | 72.0±4.0 |
| SD-JEPA k=4 | 88.0 | 88.0±3.6 | 96.0 | 69.3 |
| SD-JEPA k=8 | 90.0 | 83.3 | 97.3±1.2 | 69.3 |

- 最佳 k 下 Two-Room、Reacher、Push-T 略高，Cube 略低，作者明确读作**持平而非提升**。
- 最佳 k 随环境变：Push-T 随 k 上升，Reacher 选 4，Cube 选 2，Two-Room 平。
- 表中多数格子没给标准差（原文"where available"）。
- 脚注：作者用公开代码重跑 LeWM，Reacher 只有 76%（发表值 86%），追查到是公开超参文件与论文所述不一致；表里用的是发表值。
- 图 2 把两者放在 LeWM 论文的其他基线（PLDM、DINO-WM、GCBC、GCIQL、GCIVL，以及 Push-T 上的 Wang+26 拉直方法）中：和 LeWM 一样，Two-Room、Cube 落后最强基线，Push-T 领先。
- 只用进度块做规划代价：Push-T 只有 28%。改用全潜向量代价：Reacher k=8 多 3.3 个点（没系统比较）。

### 2. 三元组放在哪（表 2，Push-T，单种子 3072）

| 变体 | SIGReg 作用于 | 三元组作用于 | Push-T (%) |
|---|---|---|---|
| LeWM（自己重跑） | z | 无 | 96 |
| 不切分 | z | z | 96 |
| 切分，但三元组作用于全 z | z^cont | z | 92 |
| SD-JEPA（k=2） | z^cont | z^prog | 98 |

只有把三元组限制在进度块才达到或超过 LeWM。作者提醒：单种子，差异接近种子间波动（k=2 三种子均值 94%，这个种子 98%），只算"提示性"。

### 3. 两块组织方式不同（§7.1，表 7）

Push-T 的 t-SNE：内容嵌入每个回合一团；进度嵌入是跨回合重叠的弧。固定时间步下不同回合的进度嵌入平均余弦相似度约 0.5，内容嵌入约 0。作者明说这**不能证明内容块里没有进度信息**。

### 4. θ_t 是否跟踪进度（§7.2，表 3、表 6）

与时间步 vs 与任务量（Reacher 末端–目标距离、Cube 方块–目标距离、Push-T 方块角度误差）的 |Spearman ρ|（表 6）：

| 运行 | 对时钟 |ρ| | 最强非时钟量（|ρ|） | 结论 |
|---|---|---|---|
| Push-T k=2 | 0.91 | 方块角度误差 0.81 | 时钟主导 |
| Push-T k=8 | 0.56 | 方块角度误差 0.57 | 持平 |
| Reacher k=8 | 0.53 | 末端–目标距离 0.49 | 持平 |
| Two-Room k=8 | 0.50 | 智能体–目标距离 0.34 | 时钟领先（往返轨迹使 Spearman 低估） |
| Cube k=8 | 0.47 | 方块–目标距离 0.59 | 任务量胜出 |

回合内线性探针预测归一化任务进度（表 3，40 个留出回合、留一步交叉验证，平均 R²，k=8）：

| 特征（维度） | Cube | Push-T | Reacher | Two-Room |
|---|---|---|---|---|
| 时间步（1） | 0.29 | 0.62 | 0.29 | 0.69 |
| z 的随机投影（2） | 0.26 | 0.30 | 0.24 | −0.27 |
| (sin θ, cos θ)（2） | 0.56 | 0.42 | 0.34 | 0.04 |
| **z^prog（8）** | **0.91** | **0.91** | **0.95** | **0.72** |

- 四个环境上 8 维进度坐标都胜过时间步，Reacher、Cube 差距最大，Two-Room 优势小。
- **跨回合池化探针**时只有时间步可靠（Cube 池化 R²：时间步 +0.110，z^prog +0.026，z^cont / 全 z 严重过拟合到 −1.76/−1.78，附录 G.4）→ θ_t 是**回合内的相位坐标**，不是跨回合校准的距离。
- 单回合里 Push-T 智能体倒退时 θ_t 跟着倒转，时钟做不到。

### 5. θ_t 是否标记任务事件（§7.3，表 4，OGBench-Cube，40 回合 160 个夹爪开合事件，k=8）

| 容差 | z-MSE AUROC | |Δθ_t| AUROC | |Δθ_t| 更高的回合 |
|---|---|---|---|
| ±1 步 | 0.24 | 0.41 | 39/40 |
| ±2 步 | 0.36 | 0.47 | 34/40 |
| ±3 步 | 0.51 | 0.57 | 29/40 |

- |Δθ_t| 每个容差都高于预测误差 z-MSE，但前两个容差下**两者都低于 0.5（机会水平）**：z-MSE 在搬运方块期间（事件之间）达峰，|Δθ_t| 靠近事件但常偏几步。公允解读：θ 的变化比预测误差更靠近事件，不是精确的事件检测器。
- 负对照（附录 G.2）：把 25% 连续动作打乱（幅度异常而非任务事件），z-MSE 更好（Reacher 0.771 vs 0.657，Push-T 0.598 vs 0.496，Cube 0.696 vs 0.659）。
- 变点检测（附录 G.3，BinSeg K=4）：紧容差下 z-MSE 边界更准（F1 ±1：0.481 vs 角速度 0.394），只有 ±3 时角速度 |dθ/dt| 最好（0.812 vs 0.775）。
- 作者的定位：θ 是预测误差的**补充**而非替代。

### 6. 对"意外"的反应（§7.4，图 4，附录 F）

Push-T 第 50 步把下一帧换成另一个回合（T 块在目标另一侧）的画面，然后继续规划：|Δθ_t| 单帧尖峰（标记"何时"意外），之后 θ_t 不回原区间而是停在圆上新的位置，对应新的求解模式（标记"什么变了"）；预测误差只有前一种反应。插入单个外来帧 → 尖峰后很快回来；倒放一小段帧（图像集合不变）→ 两端都出现尖峰，说明信号对违反动力学也敏感。作者明说这是少数回合上的定性分析。

## 局限 / 存疑

> 前四条来自论文 §8 Limitations，后面是 Claude 的补充，请核对。

- **只持平、不提升规划**；最佳 k 要逐环境选。
- **四个短时域基准、10 epoch 预算**；进度子空间在长时域、多阶段任务上是否更有用是最重要的开放问题。
- **θ 不是处处干净的任务坐标**：有些环境接近时钟，跨回合不校准；只证明了进度块含进度信息，没证明内容块不含。
- 切分是固定的、读出是角度式的；可学习的分解或非角度进度头可能更好；其他 JEPA 骨干没测。
- **统计力度弱**：表 2 消融单种子；表 1 多数格子没有标准差；§7 的探针、事件、意外分析多为 k=8 的单个检查点，意外分析只是少数回合的定性结果。
- **事件检测数字有一处表述需核对**：§7.3 正文说"只有 ±3 步时 |Δθ_t| 超过机会水平"，但表 4 里 z-MSE 在 ±3 步也是 0.51（略高于 0.5）；附录 G.3 的表把 |Δθ| 标注为"(prediction error)"，与正文把 |Δθ_t| 当角度变化的用法不一致。
- **基线数字来源不统一**：表 1 的 LeWM 用发表值，而作者自己重跑 Reacher 只有 76%；表 2 又用的是自己重跑的 LeWM（Push-T 96）。和发表值比较时 Reacher 的"持平"其实是对着一个作者自己复现不出来的数字。
- 附录 D：在 SIGReg 上叠加时间拉直损失会让 Push-T 掉约 14 点，作者解释为与 SIGReg 作用在同一坐标；这和 Wang et al. 2026 在 stop-gradient 下拉直有效的结论不矛盾，但也说明"拉直"效果依赖防坍塌方式。

## 与其他论文的关系

- **直接基座**：[[topics/notes/JEPA系列/1-05_LeWM|LeWM]]——编码器、预测器、规划器、基准和评估协议全部沿用，只改潜变量结构和正则；SIGReg 来自 [[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]]。
- **拉直**：[[topics/notes/JEPA系列/1-04_TemporalStraightening|Temporal Straightening]] 的曲率正则在本文 SIGReg 设置下有害（附录 D，Push-T −14 点）；[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 也讨论 SG vs 分布正则如何决定潜空间几何，并同样只对一小组"慢通道"加额外约束——两篇都是"潜向量的一小块专门承载某种结构"的思路，可以对照。
- **其他 JEPA 世界模型**：图 2 基线里有 [[topics/notes/JEPA系列/1-03_PLDM|PLDM]]、[[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]]；背景引了 [[topics/notes/JEPA系列/2-01_I-JEPA|I-JEPA]]、[[topics/notes/JEPA系列/2-02_V-JEPA|V-JEPA]]、[[topics/notes/JEPA系列/2-03_V-JEPA2|V-JEPA 2]]。
- **时间距离 / 进度表征**：TCN、TCC、CEBRA、VIP、LIV、quasimetric / Hilbert 表征——这些让整个表征围绕时间距离，本文只占几维。
- 库里其他 JEPA 笔记：[[xsquare/notes/23_EgoJEPA|EgoJEPA]]。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> World models used for planning learn to predict how a scene evolves, yet they rarely hold a global view of how far a task has progressed. We argue that such a view should be part of the representation, and that it can be compact: describing a scene takes many dimensions, but where the scene stands on its way to the goal can be summarised by only a few. We propose SD-JEPA, a joint-embedding predictive world model whose latent is split into a small progression subspace and a large content subspace. A temporal triplet loss keeps consecutive frames of a trajectory close in the progression coordinates and separates different trajectories, while a distributional regulariser keeps the content coordinates from collapsing. On four control benchmarks, the model plans as well as the same architecture without the split. In return, its latent becomes easier to read. A few percent of its dimensions are enough to predict progress within an episode, and the angle they form follows the task, moves backward when the agent backtracks and changes fastest around events such as grasps and releases. Surprise also becomes anchored in the trajectory: when the scene changes mid-episode, the angle spikes and then relocalizes on a new part of the progression, anchoring surprise in the agent's own map of the task. Code is available at https://github.com/LucasStill/SD-JEPA.
