---
id: "1-01"
org: 专题·JEPA系列
short: "Content–Geometry Tradeoff（SVReg）"
title: "The Content–Geometry Tradeoff in World Models: When JEPA Learns Latent Maps"
aliases: ["When JEPA Learns Latent Maps", "SVReg", "Slow SVReg", "Content–Geometry Tradeoff"]
date: 2026-11-19
category: "JEPA 世界模型与规划"
venue: "技术报告 AGL-TR-2026-04（未经同行评审）"
source: "技术报告"
affiliation: "NYU Agentic Learning AI Lab；AMI Labs"
partners: ["AMI Labs"]
authors: ["Mengye Ren", "Ying Wang", "Christopher Hoang", "Yilun Kuang", "Yann LeCun"]
arxiv: ""
pdf: "[[topics/papers/JEPA系列/1-01_ContentGeometryTradeoff.pdf]]"
code: ""
project: "https://agenticlearning.ai/content-geometry-tradeoff/"
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "anti-collapse", "latent-planning", "cognitive-map", "stop-gradient", "slow-feature"]
---

# The Content–Geometry Tradeoff in World Models: When JEPA Learns Latent Maps

> [!info] 论文信息
> 技术报告 AGL-TR-2026-04 · DOI [10.5281/zenodo.24356797](https://doi.org/10.5281/zenodo.24356797) · 34 页（正文 15 页 + 附录）
> [项目页](https://agenticlearning.ai/content-geometry-tradeoff/) · [alphaXiv](https://www.alphaxiv.org/abs/2611.jepa-latent-maps-content-geometry) · [PDF 原链接](https://cdn.agenticlearning.ai/25c41dcbc4b7a11e/content-geometry-tradeoff-2026.pdf) · [作者推文](https://x.com/mengyer/status/2123473934129791032)
> PDF：[[topics/papers/JEPA系列/1-01_ContentGeometryTradeoff.pdf|本地 PDF]]（从 alphaXiv 下载；公司网络的 Fortinet 防火墙拦了原 CDN）
> 作者：Mengye Ren、Ying Wang\*、Christopher Hoang\*、Yilun Kuang（NYU）、Yann LeCun（NYU、AMI Labs）。\* 共同一作
> 日期：PDF 上没写日期；`date` 取实验室网站发布这篇报告的 GitHub issue 创建日期 2026-11-19。
> **没有 arXiv，项目页上没有代码链接**（项目页元数据的 `links` 为空）。
> 专题：[[topics/JEPA系列#一、JEPA 世界模型与规划|JEPA系列 · 一]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录 C 的超参数表）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 规划需要两种性质："A latent world model for planning needs two properties: latent distances that smoothly track progress toward a goal (geometry), and task-relevant factors that remain decodable from the latent representation (content)."（Abstract，p.1）
> - SG 只训练编码器去预测当前潜变量："With stop-gradient (SG), the target is held fixed during each update, so the encoder is trained only to predict its current latents."（§1，p.2）
> - 不加 SG 时的效果："The target then moves with the encoder, so the whole latent is trained to be predictable from its past, and directions the predictor cannot explain, such as noise, are suppressed."（§1，p.2）
> - 可预测性压力会抹掉内容："However, the predictability pressure can erase task-relevant content."（§1，p.2）
> - SG 下噪声方向不受罚："With stop-gradient (SG), target variance is constant during an update, so noise directions are unpenalized and perfectly predictable rotations allow curved paths even at zero prediction error."（§2.1，p.3）
> - 信号坍塌的定义："We call this failure signal collapse. In-sample statistics cannot detect it…"（§2.2，p.4）
> - 先占位的因子能守住潜空间："…so whichever factor fills the latent first can keep it."（§2.3，p.4）
> - 规划成功率跟随局部平滑度而非全局排序："Planning success follows path smoothness more closely than global distance ranking…"（§5.3，p.10）
> - 内容丢失发生在获取阶段："SVReg's content failure therefore lies in acquisition."（§5.5，p.11）
> - SG 下门控残差的平凡解："Under SG, the predictor's default copy is a trivial solution…"（§5.6，p.12）

## 一句话总结

规划用的潜空间世界模型要同时有**几何**（潜距离平滑地跟踪离目标还有多远）和**内容**（物体位姿等任务因子线性可读）。作者发现两种常见防坍塌办法都伤几何：stop-gradient（SG）的目标是单边的，路线在潜空间里走成锯齿；VICReg / SIGReg 约束整个分布，是为 i.i.d. 多视图设计的。于是提出 **SVReg**——不加 SG，只沿随机方向给潜变量的标准差设一个单边下限——学出平滑的"潜在地图"，但会丢掉慢变、难预测的因子（被推的方块、静止的立方体高度）。**Slow SVReg** 再加两件东西：一小组"慢通道"的方差归一化慢度项，和一个默认复制当前潜变量、只学增量的门控残差预测器。结果：五个视觉控制任务的困难设置里规划成功率都最高，第一人称迷宫和真实城市街区（3DGS 重建）的第一人称视频里，潜变量的前两个主成分直接画出了地图。

## 要解决什么问题

- **JEPA 目标本身有平凡解**：编码器把一切映射成常数。主流有两种补救：
  - **stop-gradient**（I-JEPA、V-JEPA、BYOL、SimSiam 一系）：目标分支过编码器但不回传梯度；
  - **分布正则**（Barlow Twins、VICReg、SIGReg/LeJEPA）：不加 SG，约束潜变量的分布。
- 这个选择通常只从**训练稳定性**考虑，作者指出它其实**决定了潜空间结构**，而潜空间规划器（DINO-WM、LeWM 一类 CEM-MPC）对结构很敏感：
  - SG：目标在每步更新里固定，编码器只被要求"预测当前的潜变量"，不要求相邻潜变量落在平滑路径上。平滑的路线在 SG 潜空间里是锯齿状，潜距离当不了远目标的导航信号；数据少时还会"信号坍塌"。
  - VICReg / SIGReg：为 i.i.d. 多视图批次设计，要求整体去相关或各向同性高斯；而世界模型的数据是时间相关的轨迹，状态分布没理由长那样。
- 但几何好了，**内容**可能丢：无 SG 时目标对不可预测方差有惩罚，慢变、只在接触时才动的物体（被推的方块、静止的立方体）恰好是难预测的，会被挤出潜空间。作者把这对矛盾叫 **content–geometry tradeoff**。

## 方法

### 线性分析（§2，附录 A）

线性编码器 Φ(o)=Wo + 线性预测器 ẑ_{t+1}=Az_t+Ba_t，JEPA 损失 L = 1/(T−1) Σ‖Az_t+Ba_t−z_{t+1}‖²。

**定理 2.1**（消去最优预测器后的编码器目标，不带动作项）：

| | 最优 A | 编码器目标 |
|---|---|---|
| 无 SG | A* = C_zᵀ Σ_z⁻¹ | L*_no-sg(W) = tr(W Σ̂₁₁ Wᵀ) − tr(C_zᵀ Σ_z⁻¹ C_z) |
| SG（目标 W_tgt 冻结） | A* = Σ̂_zz'ᵀ Σ_z⁻¹ | L*_sg = tr(W_tgt Σ̂₁₁ W_tgtᵀ) − tr(Σ̂_zz'ᵀ Σ_z⁻¹ Σ̂_zz') |

- 无 SG 的目标里第一项 tr(WΣ̂₁₁Wᵀ) 惩罚**无法解释的目标方差**，去掉不可预测方向（包括观测噪声）就能降损失 → 平滑移动的状态得到平滑的潜路径。作者在相关工作里说这在线性情形下"类 VAMP"。
- SG 下目标方差在一次更新里是常数 → 噪声方向不受罚；完全可预测的旋转在零预测误差下也允许弯曲的路径。

**有限数据（§2.2）**：有限样本噪声的滞后 1 互协方差量级为 σ²√d/T。它超过信号的滞后结构时，固定目标的目标函数会选中噪声方向——潜方差看起来健康，读到的却是噪声，作者叫**信号坍塌**。样本内统计查不出来，只有留出集上的状态探针能查（命题 A.1）。

**内容（§2.3，命题 A.2）**：一维模态 s_{t+1}=φs_t+κa_t+ε_t，φ 是持续度（接近 1 = 慢变）。
- 无 SG 时越难预测的模态损失越大，SVReg 会缩小它的坐标；方差下限保证它不缩到零，所以**单纯缩小不会丢内容**。
- 真正丢内容是在**潜维度不够、模态抢位置**时：新模态更持久时更容易挤进来；无 SG 时动作解释的方差越多也越容易进来；而且"一个坐标承载两种动力学"的代价会保护占位者——**谁先占住潜空间谁就能守住**。
- 被操作物体大部分时间静止、只靠接触移动，动作解释不了它多少方差，于是会被换成机械臂这类动作驱动的因子。

### SVReg：切片方差正则（§3，式 1）

R_SVReg(z) = E_u [ max(0, 1 − std_t(z_t·u))² ]，u ~ Unif(S^{r−1})

- 单边平方铰链：只有某方向的标准差低于 1 才罚。
- u 限制在坐标轴上就退化成 VICReg 方差项（平方形式）；但逐元素下限允许两个坐标互相复制（差方向没有方差），切片版连这种混合方向也查，**却不要求坐标去相关**。
- 一边像 VICReg（单边下限），一边像 SIGReg（随机切片），但只约束"别太扁"，不约束分布形状。
- 以权重 λ 加到**不带 SG** 的 JEPA 预测损失上。

### Slow SVReg = SVReg + 慢通道 + 门控残差预测器

| 组件 | 定义 | 作用 |
|---|---|---|
| 慢通道（式 2） | 固定一小组潜维度 b_t（实现里是**潜向量最后 1/8**），加 R_slow(b) = E_t‖b_{t+1}−b_t‖² / (2 tr Var(b))，权重 β（实现里取 1/λ） | 慢特征分析（SFA）目标的方差归一化版本，所以把慢通道缩小也降不了这一项；SVReg 仍覆盖整个潜向量。和 PLDM 等"整个潜向量都加慢度"不同，只作用于一部分 |
| 门控残差预测器（式 3） | ẑ_{t+1} = z_t + c ⊙ f(z_≤t, a_t)，c 是逐维可学门控，初始 c₀=0.1 | 默认复制当前潜变量、只预测变化量，帧间不变的因子预测成本为零。形式同 LayerScale，但门控缩放的是时间上的变化量而不是深度上的残差 |

两者合起来在**不用 SG** 的前提下偏好慢因子，作者说这呼应了 SG 在模态竞争中的"局部偏好"。

### 度量（§3，式 4–5）

- **内容**：留出集上 ridge 线性读出的 R²（智能体位置、关节角、立方体位置和高度、方块位姿），二值因子（夹爪–立方体接触）用 AUC。
- **几何（全局）**：潜距离与真实任务距离的 Spearman ρ（迷宫用最短路，Reacher 用关节空间，操作任务用 cost-to-goal ρ）。
- **几何（局部）**：**锯齿度 J** = 原始潜路径长度 / 9 步滑动平均后的长度，平滑路径 J≈1。
- **有效维度**：留出集潜协方差特征值的参与比 PR = (Σμ)²/Σμ²。

### 实现（附录 C，表 6）

| | U-maze | Medium | Reacher | Cube | PushT |
|---|---|---|---|---|---|
| 数据 | 一条均匀随机探索轨迹 5k 帧 | 同上 20k 帧 | 同上 5k 帧 | OGBench 脚本专家 2,000 回合，80k 帧 | DINO-WM 离线数据 470k 帧 |
| 图像 | 224 | 224 | 128 | 224 | 224 |
| 编码器 | 5 块 ResNet，BatchNorm | 同左 | 同左 | 5 块 ResNet，GroupNorm | 同左 |
| 潜维度 D | 128 | 128 | 128 | 384 | 128 |
| 步数 × 批 | 10k×32 | 20k×32 | 50k×32 | 50k×64 | 50k×32 |
| Slow SVReg (λ, lr) | 100, 1e-4 | 10, 1e-3 | 1, 1e-5 | 30, 1e-4 | 100, 1e-4 |

- 预测器：block-causal ViT（深度 6），3 帧历史，10 维动作嵌入拼到潜变量上。一帧 = 5 个环境步。
- 所有方法共享编码器和预测器，同一列里只差目标函数（Slow SVReg 另多一个门控残差预测器）；全部从零训练，没有预训练骨干。
- 规划：CEM-MPC，按 DINO-WM 的做法最小化预测潜状态到目标图像潜变量的 L2 距离（迷宫 / Reacher 用逐步加权 2^t 的累计代价），每 1 帧重规划（Cube 每 5 帧）。

## 实验与关键数字

### 1. 带噪线性动力学（§4，图 3）

二维状态以频率 ω 旋转，经随机正交映射 U∈R^{32×2} 加 σ=0.3 噪声观测。作者说这是"单元测试"（原始观测做 PCA 就能还原）。
- SG 在**高频、短轨迹**时失败最严重；SVReg 直到 ω≈1 都贴近信号还原上限；SG + SVReg 在两者之间。
- Slow SVReg 慢信号上和 SVReg 一样；默认 c₀=0.1 时丢掉最快的信号（T=250 时 ω>0.5），c₀=1 能保住到 ω≈1。
- T=250 的 PCA：无 SG 学出按相位排序的圆环，SG 是散点。
- 对频率的依赖理论没预测到，作者明说是经验发现。
- 第二个线性实验（附录 B，图 7）：动作驱动的手臂 + 只在接触时动的物体抢一个容量不够的潜空间——SVReg 保住手臂、几何最好，但**约一半种子丢掉物体**；SG 保住物体、手臂几何差。

### 2. 五个视觉控制任务的规划成功率（表 1，%，6 个训练种子均值 ± 标准差）

| 方法 | U-maze 易 | U-maze 难 | Medium 易 | Medium 难 | Reacher | Cube 全部 | Cube ≥4 cm | PushT |
|---|---|---|---|---|---|---|---|---|
| SG | 85.1±17.0 | 65.0±18.7 | 96.6±3.1 | 71.6±8.7 | 86.5±1.6 | 80.4±2.1 | 67.2±3.6 | 44.0±19.3 |
| SG + straightening | 86.3±5.5 | 88.0±3.1 | 96.9±1.6 | 72.8±5.6 | 86.6±2.9 | 85.4±1.0 | 75.6±1.6 | 62.1±7.7 |
| SG + SVReg | 96.3±1.6 | 95.8±1.1 | 96.0±1.5 | 62.7±6.2 | 96.3±1.6 | 77.2±1.3 | 61.7±2.3 | 76.9±4.3 |
| VICReg | 99.9±0.3 | 94.3±2.3 | 96.4±0.8 | 77.2±2.3 | 93.1±1.7 | 69.6±5.8 | 49.8±9.3 | 55.0±3.6 |
| SIGReg-BN | 92.4±7.9 | 82.2±13.7 | 97.3±1.0 | 78.2±3.8 | 95.8±1.3 | 87.4±0.8 | 79.0±1.3 | 60.4±2.6 |
| SVReg | 99.7±0.4 | 96.4±1.3 | 98.0±1.3 | 81.3±2.3 | 98.7±0.9 | 76.9±8.8 | 62.9±13.1 | 75.0±8.6 |
| **Slow SVReg** | 99.7±0.4 | **98.7±0.7** | 97.9±0.8 | **84.7±2.7** | **99.6±0.4** | **89.1±1.6** | **81.9±2.5** | **87.3±3.8** |

- 迷宫的难目标：50 步外、至少相隔 3 个迷宫单位；易目标 25 步外。Cube ≥4 cm 只算立方体移动超过 4 cm 的目标（约 60%）。
- 基线：SIGReg-BN 按 LeWM 的做法在编码器后接 BatchNorm MLP 投影头再上 SIGReg；逐帧统计（LeWM）和批内池化统计（LeJEPA）两种都跑了，每个任务取规划更好的那种。SG + straightening 加的是时间拉直的曲率罚项（式 6，Wang et al. 2026b）。
- 超参选择：每个方法、任务、目标集在一个单独的规划种子上选学习率和正则权重，再在另外三个规划种子上报告。
- SVReg 单独：只有智能体在动的任务（导航、Reacher）里仅次于 Slow SVReg；有物体的任务里落后（Cube 不如 SIGReg-BN，PushT 不如 SG + SVReg），方差也大。

### 3. 第一人称迷宫（表 2，%）——差距最大的地方

| 方法 | U-maze 易 | U-maze 难 | Medium 易 | Medium 难 |
|---|---|---|---|---|
| SG | 97.2±1.1 | 42.0±6.8 | 98.4±0.9 | 21.2±6.4 |
| SG + straightening | 96.6±1.5 | 37.7±16.0 | 97.2±1.9 | 24.9±8.8 |
| SG + SVReg | 97.6±1.2 | 38.3±12.5 | 97.2±4.1 | 46.0±16.6 |
| VICReg | 94.2±1.2 | 40.3±4.4 | 95.0±1.0 | 29.6±7.3 |
| SIGReg-BN | 99.0±0.8 | 71.0±6.1 | 98.7±0.8 | 42.8±5.2 |
| SVReg | 98.2±0.8 | 90.4±1.6 | 97.0±0.7 | 75.3±5.5 |
| **Slow SVReg** | **99.7±0.6** | **95.6±1.4** | **99.4±0.5** | **92.9±3.2** |

智能体只看得到前方，位置要靠视图和动作推。Medium 难目标上 SG 只有 21.2%，Slow SVReg 92.9%。Slow SVReg 相对 SVReg 的增益在这里最大（位置要跨帧携带，正是"慢因子"）；在每帧都能看到智能体的俯视迷宫和 Reacher 里增益很小。图 1(a)：同一条 Medium 路线的锯齿度 SG 5.31 / SG+straightening 3.51 / SVReg 1.17 / Slow SVReg 1.20。

### 4. 几何（§5.3，图 4）

- 无 SG 时，SVReg / Slow SVReg 留出集潜变量的**前两个主成分直接画出迷宫布局**，Medium 的各条走廊是分开的分支——第一人称视角下也是如此，而智能体从没见过自己的真实位置。SG 俯视时只有粗略的位置排序，第一人称时位置混在一起。
- 有效维度（第一人称 Medium）：SG 37.5，SVReg 7.9，Slow SVReg 4.6——无 SG 的潜变量用的方向少得多。
- **局部锯齿度和规划高度相关**（U-maze、Medium、Reacher 上锯齿最严重的三种方法恰好是最弱的三个规划器，表 7、8）；**全局距离秩相关不相关**（SG + SVReg 的潜距离几乎不跟随迷宫距离，难目标却规划得好）。解释：CEM 每次只比较几步内的潜距离，靠的是局部形状。

### 5. 内容（§5.4–5.5，图 5，表 9–10）

- Cube 上几何解释不了规划排名：SIGReg-BN 和 SG + straightening 的潜距离最不跟随目标距离，却排第二、第三；SVReg 距离排序好，却规划差。差别在**立方体**（而非机械臂）的内容：最弱的三个 Cube 规划器（VICReg、SVReg、SG + SVReg）检测夹爪–立方体接触最不可靠，SVReg 会丢立方体高度。
- PushT 更明显：静止的方块只在被推时变化，VICReg、SIGReg-BN、SVReg 都丢了它，留出集方块读出**低于直接预测均值**（R² < 0）。PushT 最好的两个规划器（Slow SVReg、SG + SVReg）都保住了方块。
- 单个旋钮（预测器深度、慢度权重 β）上，立方体高度 R² 越高，身体几何 ρ 越低（图 5a）；Slow SVReg 处在高内容端，几何损失很小。
- **内容在训练早期就决定了**：同一种子的三个目标从同一个随机初始编码器出发，SVReg 恰好在初始读出立方体高度最少的那些种子上失败（项目页：6 个种子里有 3 个）；从这些起点 SG 能继续获取高度，SVReg 不能，Slow SVReg 都能（弱起点慢一些）。
- 一旦获得就不会丢：附录 F 里先用 SG 训练、20k 步时换成 SVReg，高度保住且规划好于 SG → SVReg 的问题出在**获取**。
- 两阶段（冻结的 SG 编码器 + SVReg 头）保住了内容，但所有任务上都不如 Slow SVReg。

### 6. 消融（表 3、表 4）

| 任务 | SVReg | + GR | + 慢通道 | + 两者（Slow SVReg） |
|---|---|---|---|---|
| U-maze 难 | 96.4±1.3 | 98.1±0.9 | 96.6±1.7 | 98.7±0.7 |
| Medium 难 | 81.3±2.3 | 86.0±3.1 | 82.7±2.5 | 84.7±2.7 |
| Reacher | 98.7±0.9 | 99.7±0.3 | 96.9±1.5 | 99.6±0.4 |
| Cube | 76.9±8.8 | 78.6±9.7 | 84.6±3.3 | 89.1±1.6 |
| PushT | 75.0±8.6 | 85.9±3.9 | 78.9±6.6 | 87.3±3.8 |

- Cube 的增益主要来自慢通道；单独加门控残差时部分种子失败（潜变量在快速抖动阶段停留更久、立方体高度获取得晚，翻倍步数后能恢复）。PushT 的方块主要靠门控残差变得可读。
- 把门控残差加到其他目标上（表 4，Cube）：**SG + GR 塌了**（80.4 → 51.4），因为 SG 下"默认复制"是平凡解；SG + straightening 85.4 → 58.6；VICReg 69.6 → 78.3；SIGReg-BN 87.4 → 86.4 基本不变。
- 把 SVReg 的随机方向限制到坐标轴（逐元素下限）会丢立方体高度，Cube 规划约 50% → 增益依赖"切片 + 无 SG"。

### 7. 数据规模（§5.7，图 11、13）

- Slow SVReg 用很少数据就能达到高成功率：难 U-maze 目标用表 1 数据的五分之一接近饱和，SG 用全部数据也差很远；Medium 和 Reacher 只用 1k–2k 帧就明显超过 SVReg 和 SG。
- PushT 上训练更久持续上升（到 150k 步，配短的学习率冷却），第二名 SG + straightening 提升速度类似，Slow SVReg 保持领先。

### 8. 城市街区漫步（§6，表 5，图 6）

数据：Wanderland 的真实城市街区 3DGS 重建；沿采集路径随机转向、前进渲染第一人称漫步，**只用画面和动作，不用位姿**训练。

| 方法 | 13Skv 位置误差 (m)↓ | 13Skv 留出区域 (m)↓ | 13Skv 朝向 (°)↓ | 13Skv 地图 R²↑ | 另 10 个场景 位置 (m)↓ | 另 10 个场景 地图 R²↑ |
|---|---|---|---|---|---|---|
| 未训练编码器（对照） | 25.9 | 41.2 | 54.1 | 0.02 | 13.7 | 0.04 |
| SG | 3.4 | 10.0 | **3.4** | 0.26 | 5.4 | 0.10 |
| SG + straightening | 9.1 | 14.5 | 11.0 | 0.24 | 5.2 | 0.21 |
| VICReg | 12.5 | 21.3 | 21.1 | 0.12 | 5.3 | 0.13 |
| SIGReg-BN | 2.1 | 11.9 | 7.1 | 0.30 | **2.1** | 0.21 |
| SVReg | 5.4 | 12.2 | 8.0 | 0.54 | 4.1 | 0.60 |
| **Slow SVReg** | **1.6** | **6.3** | 6.3 | **0.88** | 3.1 | **0.63** |

- "地图 R²"衡量**前两个主成分**（不拟合读出头）把走过的区域摆得多像真实布局。Slow SVReg 在 13Skv 上 0.88，其次 SVReg 0.54，其他单阶段方法都 ≤0.30。
- 10 个额外场景（4 室内、6 室外，每个场景训 2 次）里，地图分最高的全都是 SVReg 变体，多数是 Slow SVReg；但**线性读出定位最准的是 SIGReg-BN**（平均 2.1 m），只是它的主成分不成地图。
- 无 SG 的潜变量能跨视角认出地方：对多数验证帧，在朝向相差 >90° 的训练帧里找潜空间最近邻，拍摄位置在 5 m 以内；SG 主要匹配朝向相近的视图。
- 地图随经验形成：训练漫步从 2 条增加到 100 条、反复经过同一条街，位置误差下降一个数量级（图 14）。

## 局限 / 存疑

> 论文没有单独的"局限"一节，下面是 Claude 从正文里整理的，请核对。

- **技术报告，未经同行评审**；没有 arXiv，项目页没有代码链接，暂时无法复现。
- **全是仿真 / 重建环境**：PointMaze、Reacher、OGBench-Cube、PushT、Wanderland 的 3DGS 渲染；没有真机。城市街区是在重建场景里沿采集路径渲染的随机漫步，不是真实拍摄的视频流。
- **模型规模很小**：5 块 ResNet 编码器从零训练，潜维度 128/384，单任务单模型；没有和 V-JEPA 2 这类预训练大骨干比较，也没说 SVReg 在大规模视频预训练里是否成立。
- **超参数逐任务挑选**：λ 从 1 到 100、学习率从 1e-5 到 1e-3 变化很大；每个方法、每个目标集都单独选设置（选设置用独立规划种子，算公平，但也说明方法对超参敏感）。
- **门控初始值的权衡**：默认 c₀=0.1 在线性实验里丢最快的信号（T=250 时 ω>0.5）；慢通道取最后 1/8、β=1/λ 是固定设计，没看到对比例的系统扫描。
- **对频率的依赖**理论没有解释，作者明说是经验发现。
- **城市街区里 Slow SVReg 不是全面最好**：朝向误差 SG 最好（3.4° vs 6.3°）；10 个场景平均的线性读出定位误差 SIGReg-BN 最小（2.1 m vs 3.1 m）。它赢的是"主成分直接成图"的地图分。
- **Cube 上 SVReg 的成败取决于随机初始化**（6 个种子里 3 个丢立方体高度），所以 SVReg 一栏方差很大（Cube ≥4 cm ±13.1）。
- 与 LeWM 的 Cube 设置有一处差别：本文的起点和目标帧来自留出回合，LeWM 来自训练回合（附录 C.3），两边的数字不能直接对比。

## 与其他论文的关系

- **防坍塌谱系**：一边对比 SG 一系（I-JEPA、V-JEPA、BYOL、SimSiam），一边对比分布正则一系（VICReg、SIGReg / [LeJEPA](https://arxiv.org/abs/2511.08544)、Barlow Twins）。SVReg 是"VICReg 的单边下限 + SIGReg 的随机切片"，但去掉了形状约束。
- **JEPA 世界模型**：规划沿用 DINO-WM 的 CEM-MPC；SIGReg-BN 基线复刻 LeWM（[2603.19312](https://arxiv.org/abs/2603.19312)）。PLDM 也不用 SG，但对整个潜向量加慢度；本文只对一小组通道加。Karmann et al. 2026 报告过 LeWM 在 Pong 里把球压掉、SG 版本能恢复——和本文"无 SG 丢内容"是同一现象。
- **时间拉直**：SG + straightening 基线来自 Wang et al. 2026b 的曲率正则；作者的论点是 SVReg 不需要曲率罚项也能得到平滑路径。
- **慢特征 / Koopman**：慢通道是 SFA 的方差归一化版；无 SG 目标在线性情形下类 VAMP；也提到 JEPA 与 Koopman 不变子空间的联系（Ruiz-Morales et al. 2025，即 [Koopman Invariants as Drivers of Emergent Time-Series](https://arxiv.org/abs/2511.09783)）。
- **空间表征 / 认知地图**：以往预测模型、慢特征模型里的位置编码大多要训练解码器或看单个神经元才读得出来；本文是前两个主成分直接成图，而且是在没有位姿的第一人称真实街区重建上。
- 库里其他 JEPA 笔记：[[xsquare/notes/23_EgoJEPA|EgoJEPA]]（自我中心视频 → 灵巧操作的 JEPA 式潜动作预训练）。
- 和库里的导航专题相关：第一人称"潜在地图"可以对照 [[topics/视觉语言导航VLN|视觉语言导航VLN]] 和 [[topics/语义3DGS与具身导航|语义3DGS与具身导航]]（Wanderland 是 3DGS 重建）。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> A latent world model for planning needs two properties: latent distances that smoothly track progress toward a goal (geometry), and task-relevant factors that remain decodable from the latent representation (content). Common approaches prevent representation collapse with a stop-gradient (SG) target or a distributional regularizer, but we find that both often yield poor latent geometry. In this paper, we introduce sliced variance regularization (SVReg), which imposes a variance floor on latent projections along random directions. SVReg learns a smooth map of the agent's state. Its latent trajectories are smooth, and its latent distances track progress in navigation and reaching. These geometric benefits, however, can come with a tradeoff in content. SVReg can discard slowly changing, hard-to-predict factors, such as the pose of a manipulated object, that SG variants tend to preserve. To address this tradeoff, we propose Slow SVReg, which favors slowly changing factors with a slowness term and a gated residual predictor. It keeps these factors and improves planning. This simple recipe has the highest planning success in the hard settings of five visual control tasks, and it learns latent maps from first-person mazes and city walks.
