---
id: "4-35"
org: 专题·视觉语言导航VLN
short: "VTInstructor"
title: "VTInstructor: Visual Trajectory Prompting for Navigation Instruction Generation in Continuous Environments"
aliases: ["VTInstructor"]
date: 2026-08-15
category: "数据生成与扩展"
venue: "ACM MM 2026"
affiliation: "Peking University (CFCS) · PrimeBot"
authors: ["Haolin Yang", "Zihan Yang", "Yuxing Long", "Hao Dong"]
arxiv: "2608.15284"
pdf: "[[topics/papers/视觉语言导航VLN/4-35_2608.15284_VTInstructor.pdf]]"
code: ""
project: ""
license: CC BY 4.0（论文首页注明）
status: 未读
rating:
read_date:
tags: ["paper", "vln", "instruction-generation", "visual-prompting", "grpo"]
---

# VTInstructor: Visual Trajectory Prompting for Navigation Instruction Generation in Continuous Environments

> [!info] 论文信息
> arXiv [2608.15284](https://arxiv.org/abs/2608.15284) · v1 2026-08-15
> 发表：ACM MM 2026 · 单位：北京大学计算机学院 CFCS、PrimeBot · 通讯作者：董豪（Hao Dong）
> PDF：[[topics/papers/视觉语言导航VLN/4-35_2608.15284_VTInstructor.pdf|本地 PDF]]（9 页，无附录）
> 代码 / 项目页：论文里没有给出
> 专题：[[topics/视觉语言导航VLN#数据生成与扩展|视觉语言导航VLN · 四、任务、基准与数据 · 数据生成与扩展]]

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-09）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。

## 一句话总结

做 VLN 的"反方向"——给一段走过的轨迹，生成一条人能照着走的导航指令（speaker）。以前的 speaker 都在离散导航图上、看 36 视角全景；这篇第一个在连续环境（R2R-CE / RxR-CE）里只用第一人称 RGB 做这件事。核心办法是**把轨迹几何画到图上**：先把几百帧压成 ≤32 张关键帧，在每张上画出"接下来往哪走 / 转多少度 / 终点在哪"，再把这些标记当作额外信号注入 Qwen3-VL-8B 的 ViT，最后用 GRPO 以 NLG 指标为奖励微调。

## 要解决什么问题

- **指令生成（NIG）** 有两个用处：给 VLN 造训练数据（Speaker-Follower 以来的数据增广路线），以及人机沟通（机器人向人描述自己走过的路）。
- 现有 speaker（BT/EnvDrop、CCC、LANA、C-Instructor、BEVInstructor、MapInstructor……）都建立在**离散导航图**上：每个节点有全景图，节点间关系显式，轨迹结构"白给"。
- 连续环境里只有一条稠密的第一人称 RGB 流，相邻帧看起来几乎一样，**方向、转弯、离终点多远这些线索都是隐式的**。作者引用自己组的 NavSpace 指出，从细微帧间变化恢复这些信息正是现有 VLN 智能体和 MLLM 最弱的空间智能能力；结果是生成的指令方向含糊、泛泛而谈。
- 所以思路是：**别让模型自己推轨迹几何，直接画给它看。**

## 方法

总览见 [[topics/papers/视觉语言导航VLN/4-35_2608.15284_VTInstructor.pdf#page=4|图 2（第 4 页）]]。四个部件：EDTC 压缩 → VTP 渲染 + GPT 过滤 → VTMod 注入 → 两阶段训练（SFT → VT-GRPO）。

### 问题设定（§3.1–3.2）

- 动作空间是 VLN-CE 的四个原子动作：前进 0.25 m、左转 30°、右转 30°、停止。轨迹 τ = (f₁,a₁)…(f_T,a_T)，目标是生成指令 y。
- 注意输入**同时有 RGB 和动作序列**：模型收到的是交错序列 `系统提示, I₁, [Action 1: go forward 1.25 m], I₂, [Action 2: turn left 90°], …`。"只用 RGB"指视觉输入没有全景、导航图、地图或重建，不是说不知道动作。
- 骨干：Qwen3-VL-8B。每张关键帧单独过 ViT，patch token 在各层位置固定——这是后面能做"像素级一一对应"注入的前提。

### EDTC：事件驱动的轨迹压缩（§3.3）

三级，把 T 帧压到最多 F_max = 32 帧：

| 级 | 做法 | 作用 |
|---|---|---|
| L1 动作游程编码 | 连续相同动作合并成一段（n 步前进 → n×0.25 m；n 次转向 → n×30°）；前进超过 4 m（n>16）的段对半拆 | 按动作边界切"事件"，对导航语义无损 |
| L2 小步组合 | 0.25/0.5 m 的小前进、单次 30° 转向这类碎步，连续的合成一个 combo 事件（最多 6 段） | 防止"转一下走一步"的微调被切成一堆零碎片段 |
| L3 动态优先级压缩 DPC | 仍超过 32 帧时，对相邻事件帧打分 J = λ_vis·Δvis + λ_geo·Δgeo，反复删分数最低的；首帧和当前帧必留 | 视觉变化小、几何变化小的边界先删 |

关键帧选在**事件边界**上，也就是 VTP 的"锚点"。λ_vis、λ_geo 的取值和 Δvis 用的冻结特征是什么，论文没写。

### VTP：视觉轨迹提示（§3.4）

在每张关键帧的第一人称视角里画三种东西：

| 通道 | 标记 | 什么时候画 |
|---|---|---|
| C0 路径带（ribbon） | 一条彩带画出接下来的路线；原始折线经插值、Chaikin 切角、两轮高斯平滑，再做遮挡检查防止画到墙后 | 当前事件不是纯转向；全被遮挡时退化成一小截 |
| C1 转向箭头 | 左/右弧形箭头，标注转角度数 | 当前事件是纯转向 |
| C2 终点标记 | 小旗标出目标位置 | 接近轨迹末尾且终点未被遮挡 |

- 存成 **3 通道二值掩码** M ∈ {0,1}^{3×H×W}，每种标记一个通道，避免颜色混淆。论文说"彩色 PNG 只用于可视化"。
- **use-but-don't-mention**：系统提示告诉模型图里有路径带、转向箭头和终点旗，让它用来推断路线，但禁止在指令里提到这些标记，免得生成"沿着蓝色带子走"之类的话。R2R-CE 和 RxR-CE 各一套提示（15–45 词 vs 50–120 词）。
- **GPT 质量过滤（QF）**：按四项打分——方向是否与 VTP 一致、地标是否具体、距离是否合理、语言是否流畅；10 分制 ≥6 分的才留作训练数据。

### VTMod：视觉轨迹调制器（§3.5）

把掩码变成 ViT 能用的特征，逐 patch 加进去：

1. **VTP 编码器**：3 个 stride-2 卷积块（Conv + GroupNorm + GELU，通道 64→128→256）→ 1×1 卷积到 384 维 → 自适应平均池化到 ViT 的 patch 网格。每个位置的特征和对应 ViT patch 一一对应。
2. **注入**：在 ViT 第 7 层，h′ᵢ = hᵢ + g ⊙ LN(W vᵢ)。g 是逐通道门控向量，**初始化为≈0**（lazy activation），训练开始时 ViT 行为不变，避免冲掉预训练视觉先验。

形式上类似 ControlNet / adapter 的零初始化旁路（这是 Claude 的类比，论文没这么说）。

### 两阶段训练（§3.6、§4.1）

- **阶段 1 SFT**：全部模块可训；新模块学习率 5e-4，骨干 3e-5。3 epoch，8×H200 约 9 小时。
- **阶段 2 VT-GRPO**：每个输入采 8 条，奖励 = 0.25·BLEU-1 + 0.25·BLEU-4 + 0.25·METEOR + 0.20·ROUGE-L + 0.05·CIDEr（CIDEr 量级大，权重压低）；KL 0.04，clip 0.2。冻结 ViT、VTP 编码器和投影层，**只训 LLM 和门控 g**。1 epoch，约 30 小时。
- **门控对比损失**：作者认为 GRPO 对一组 8 条做优势加权平均，正负信号相互抵消，g 拿到的梯度太散。于是额外对组内最好 y⁺ 和最差 y⁻ 做 L_gate = −log σ((ℓ̄(y⁺) − ℓ̄(y⁻))/τ)（ℓ̄ 是平均 token 对数概率），总损失 L_GRPO + 0.05·L_gate。

## 实验与关键数字

设置：训练只用 R2R-CE / RxR-CE 的 Train；测试在 Val Unseen（RxR-CE 只用英文）。基线大模型都是 few-shot（提示里放几条训练集参考指令）。

**指令质量（表 1，第 6 页）**

| 方法 | R2R-CE BLEU-4 | R2R-CE CIDEr | RxR-CE BLEU-4 | RxR-CE CIDEr |
|---|---|---|---|---|
| Gemini-3.1-Pro-Preview（最强基线） | 0.166 | 0.203 | 0.073 | 0.029 |
| Qwen3.5-9B | 0.121 | 0.181 | 0.077 | 0.027 |
| Qwen3-VL-8B-Instruct（同骨干，未训练） | 0.085 | 0.147 | 0.053 | 0.022 |
| Qwen3-VL-8B（SFT-only） | 0.282 | 0.484 | 0.201 | 0.060 |
| **VTInstructor** | **0.320** | **0.560** | **0.308** | **0.142** |

- 摘要里的 "+0.357 / +0.109 CIDEr" 是相对各基准上的最强基线（R2R-CE 是 Gemini 0.203；RxR-CE 0.142−0.109=0.033，对应 Qwen3.5-Plus）。
- 大模型不一定好：GPT-5.4 在 R2R-CE 的 CIDEr 只有 0.078，低于 Qwen3.5-9B。

**与离散设定的旧方法对比（表 2）**：作者明说"不是严格对照，只作参考"。R2R：CIDEr 0.560 vs MapInstructor 0.490；RxR：BLEU-4 0.308 vs 0.159，CIDEr 0.142 vs 0.057。

**消融（表 3、表 4，第 7 页，均为 R2R-CE Val Unseen）**

表 3（只有 SFT，不含 VT-GRPO）：

| # | VTMod | EDTC | QF | BLEU-4 | SPICE |
|---|---|---|---|---|---|
| 1 | | | | 0.282 | 0.201 |
| 2 | | | ✓ | 0.286 | 0.220 |
| 3 | | ✓ | ✓ | 0.288 | 0.223 |
| 4 | ✓ | ✓ | | 0.302 | 0.232 |
| 5 | ✓ | ✓ | ✓ | 0.308 | 0.238 |

- 3→5 是加 VTMod：BLEU-4 +0.020，作者据此称 VTMod 是主要贡献。
- 表 4：EDTC 比每 4 帧取 1 帧好（平均 10.5 帧 vs 13.0 帧，BLEU-1 0.743 vs 0.738）；只在第 7 层注入好于 7/15/23 三层（0.299 vs 0.295）；门控逐 patch 投影好于交叉注意力（0.300 vs 0.295）；VT-GRPO 好于普通 GRPO（0.320 vs 0.314）。

**下游导航（表 5）**：R2R-CE Val Unseen 全部轨迹用各模型生成指令，交给冻结的 CorrectNav 跟随。

| 指令来源 | SR | SPL | NE (m) |
|---|---|---|---|
| 官方人工指令 | 61.6 | 53.3 | 4.53 |
| Qwen3.5-Plus（最好的基线） | 48.6 | 39.0 | 5.70 |
| Claude Opus 4.6（最差） | 21.7 | 15.2 | 9.56 |
| **VTInstructor** | **63.3** | 52.7 | **4.47** |

摘要的 "+14.7 个百分点" = 63.3 − 48.6。作者自己也说，单一冻结跟随者不足以证明好于人工指令，只能说"达到可比水平"。

**数据增广（表 6、7）**：CorrectNav（LLaVA-Video-7B 骨干）从头训练。A = 人工 R2R-CE + RxR-CE；B = A + 2 万条 VTInstructor 生成指令。

| | R2R-CE SR | R2R-CE NE | RxR-CE SR | RxR-CE NE |
|---|---|---|---|---|
| A | 45.1 | 6.20 | 41.2 | 8.34 |
| B | 48.4 | 5.85 | 44.4 | 7.74 |

**真实视频人评（表 8）**：50 段 YouTube 房间巡游视频，先估计逐帧深度和相机位姿，再走 EDTC + VTP。3 名标注者看不带标记的关键帧，1–5 分打分。

| | 动作 | 地标 | 方向 | 可跟随性 |
|---|---|---|---|---|
| GPT-5.4 | 2.65 | 3.55 | 2.53 | 2.29 |
| Qwen3-VL-8B | 2.63 | 3.65 | 2.67 | 2.49 |
| VTInstructor | 4.38 | 4.21 | 4.25 | 4.35 |

差距主要在动作和方向；地标差距小，因为大模型本来就认得常见室内物体。

## 局限 / 存疑

论文自述（§5）：VT-GRPO 的奖励全是和参考指令比的 NLG 指标，没有直接优化导航成功率；以后可以加一个轻量跟随者的成败信号。

读的时候值得核对的地方：

- **提升主要来自哪里？** 表 1 的"SFT-only"（0.282 / CIDEr 0.484）就是表 3 第 1 行，也就是不加 VTMod、EDTC、QF 的裸 SFT。它已经把 R2R-CE CIDEr 从未训练的 0.147 和 Gemini 的 0.203 拉到 0.484；之后 VTMod + EDTC + QF + VT-GRPO 再加到 0.560。也就是说，对通用大模型的大幅领先，**大部分来自在域内数据上微调、学会了 R2R 的措辞风格**，论文的新部件贡献的是后面那一段。
- **VTP 本身没有被单独消融（需核对）**。表 3 去掉的是 VTMod（掩码注入），但第 1 行的 RGB 上是否已经画了 VTP、提示里是否已有 use-but-don't-mention，没交代。§3.4 说"彩色 PNG 只用于可视化"，但 §2.1 写的是"以带 VTP 渲染的第一人称 RGB 为输入"，图 2 也画着带路径带的图像进 ViT。两种说法对不上，因此"完全没有视觉提示"的基线到底多少，从论文里得不出。
- **表 4 的数字和表 3 对不上（需核对）**：(b) 第 7 层 0.299/0.248/0.497/0.224 和 (c) 门控投影 0.300/0.247/0.497/0.226 本应都是默认配置，却彼此不同，也不等于表 3 的第 4 行（0.302）或第 5 行（0.308）。消融各自基于什么配置没说明。差距本身也很小（BLEU-4 差 0.004–0.006），没有方差或多次运行。
- **基线拿到的输入是否相同（需核对）**：表 1 / 表 5 的大模型是否也看到 VTP 标记和动作文字片段，没写清。§4.7 真实视频实验说基线"收到同样的关键帧"，但没说带不带标记。
- **"无需导航图或重建"的边界**：推理时虽然不要导航图，但画路径带需要把未来轨迹投影进当前视角并做遮挡检查，这需要相机位姿和深度——仿真里是真值，真实视频里要额外估计（§4.7 用了什么估计方法没写）。
- **表 2 跨设定对比要谨慎**：RxR 上 BLEU-1 0.774 vs 旧方法最好 0.411，差得过大；连裸 SFT 都有 0.630。更可能有协议差异（只用英文子集、R2R-CE 的轨迹是 R2R 的子集等），作者也承认不是严格对照。"R2R-CE 和 R2R 路径完全相同"这一说法，据 Claude 所知 VLN-CE 去掉了一部分无法转换的轨迹，属推测，需核对。
- **下游评测的跟随者是作者组自己的 CorrectNav**，同样在 R2R-CE 上训练。VTInstructor 的指令风格贴近 R2R-CE 训练分布，可能本身就更"对 CorrectNav 的胃口"。生成指令 SR 63.3 高于人工指令 61.6，也提示这一点。
- **2 万条增广指令来自哪些轨迹**没说（训练集原轨迹重新配指令？还是新采的轨迹？），影响对 +3 SR 的解读。
- **QF 过滤的对象（需核对）**："instruction candidates are scored by GPT" 后又说训练数据是"GPT 过滤过的 VTP 标注轨迹"。被打分的是人工参考指令还是生成的候选，不明确。
- **门控对比损失的梯度去向**：L_gate 用的是整条输出的对数概率，阶段 2 里 LLM 也是可训的，所以梯度不只流向 g。"专门校准 g"这一说法比实际机制更强（推测）。
- **复现信息不全**：λ_vis、λ_geo、τ_GPT、Δvis 用的特征、GPT 打分用的具体模型都没给，也没有代码链接。

## 与其他论文的关系

- **同组工作**（北大董豪组 + PrimeBot）：
  - [NavSpace](https://arxiv.org/abs/2510.08173)（专题 4-34）：同一第一作者，引言里"MLLM 缺空间智能"的论据就来自它。
  - [CorrectNav](https://arxiv.org/abs/2508.10416)（专题 3-17）：下游实验的跟随者，也用来做数据增广的训练对象。
- **speaker / 数据增广这条线**：[Speaker-Follower](https://arxiv.org/abs/1806.02724)（5-01）开了用 speaker 造数据的头；[EnvDrop](https://arxiv.org/abs/1904.04195)（5-06）的 back-translation 是表 2 里的 EDrop-speaker；[SRDF](https://arxiv.org/abs/2412.08467)（4-18）让生成器和导航器互相筛数据，是"指令生成器 → 数据飞轮"的更完整版本；[ScaleVLN](https://arxiv.org/abs/2307.15644)（4-17）说明了合成数据规模的价值。VTInstructor 补的是**连续环境**这一块。
- **离散设定的 speaker 前作**：C-Instructor（思维链提示）、BEVInstructor / MapInstructor（BEV、俯视地图）、LANA（指令跟随与生成联合训练）都在表 2 里。
- **视觉提示的出处**：红圈（What does CLIP know about a red circle）、Set-of-Mark、PIVOT；最接近的是机器人操作里的 TraceVLA（把末端执行器轨迹画在观测上）。VTInstructor 等于把 TraceVLA 的思路搬到导航指令生成，并多了一个"掩码 → 特征 → ViT 中层注入"的通道。
- **与 RSI 专题的联系**：作者在 §5 设想把轻量跟随者的成败信号接进奖励，这就是 speaker–follower 互相改进的闭环，可以和[[topics/递归自我改进RSI|递归自我改进RSI]]专题里的数据飞轮类工作对照着看。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 句原文，论文为 CC BY 4.0）
> 1. 第 2 页 §1："recovering them from subtle inter-frame changes is itself a fine-grained spatial-intelligence problem" → 问题动机
> 2. 第 2 页 §1："convert trajectory geometry into explicit visual trajectory prompts on ego-centric views" → 核心思路
> 3. 第 3 页 §3.2："P, I1, [Action 1: d1], I2, [Action 2: d2], ..." → 输入含动作文字片段
> 4. 第 3 页 §3.3："When the number of retained frames after Levels 1–2 still exceeds Fmax = 32" → EDTC 上限 32 帧
> 5. 第 4 页 §3.4："This mask is the direct input to the VTP Encoder; the coloured PNG visualisation is an artefact used only for qualitative inspection." → VTP 输入方式（与 §2.1 对照）
> 6. 第 4 页 §3.4："yet is explicitly prohibited from referencing them in the generated instruction" → use-but-don't-mention
> 7. 第 5 页 §3.5："The gate g is initialised to g0 ≈ 0, implementing a lazy activation" → 零初始化门控
> 8. 第 5 页 §3.6："During VT-GRPO, the ViT backbone, VTP Encoder, and modulator projection layers are frozen; the LLM backbone and the gate vector g remain trainable." → 阶段 2 可训参数
> 9. 第 7 页 §4.5："a single frozen follower cannot establish superiority over human annotations" → 作者对下游结果的保留
> 10. 第 8 页 §5："the policy is not directly optimised for navigational success rate" → 论文自述局限

## 摘要（中文）

在连续环境中根据第一人称 RGB 视频生成导航指令，是人机交互和大规模构建数据集的一项重要而有挑战的任务。以往的指令生成器假设环境是带全景观测的离散视点图，轨迹结构是显式的；而在连续环境中，智能体只能拿到稠密的 RGB 流，轨迹线索很难恢复。我们提出 VTInstructor，第一个面向连续环境的 VLN 指令生成框架。核心想法是把隐式的轨迹几何转成显式的视觉轨迹提示：EDTC 把长 RGB 轨迹压缩成对导航关键的关键帧；VTP 在这些锚点上叠加路径、转弯和终点提示；VTMod 把得到的轨迹信号注入视觉编码器；VT-GRPO 在训练中进一步校准这种空间注入。整个过程不需要导航图、预建地图或场景重建。在有挑战的 R2R-CE 和 RxR-CE Val Unseen 基准上，VTInstructor 在所有标准 NLG 指标上都达到新的最优，CIDEr 分别比最强基线高 0.357 和 0.109。除自动指标外，VTInstructor 生成的指令让冻结跟随者的成功率达到 63.3%，比最好的其他指令来源高 14.7 个百分点；用于数据增广时，在下游导航任务上稳定带来 +3 个点的 SR 提升。

## 摘要（原文）

> Navigation instruction generation from ego-centric RGB video in continuous environments is an important yet challenging task for human–robot interaction and scalable dataset construction. Prior instruction generators assume discrete viewpoint graphs with panoramic observations, where trajectory structure is explicit; in continuous environments, however, the agent receives only a dense RGB stream, making trajectory cues difficult to recover. We propose VTInstructor, the first VLN instruction generation framework for continuous environments. Our key idea is to convert implicit trajectory geometry into explicit visual trajectory prompts: EDTC condenses long RGB trajectories into navigation-critical keyframes, VTP overlays path, turn, and goal cues onto these anchors, VTMod injects the resulting trajectory signals into the visual encoder, and VT-GRPO further calibrates this spatial injection during training, all without requiring a navigation graph, pre-built map, or scene reconstruction. On the challenging R2R-CE and RxR-CE Val Unseen benchmarks, VTInstructor sets a new state of the art across all standard NLG metrics, surpassing the strongest baseline by +0.357 CIDEr and +0.109 CIDEr, respectively. Beyond automatic metrics, VTInstructor-generated instructions raise a frozen follower's success rate to 63.3%, a +14.7 percentage-point gain over the best competing instruction source, and provide consistent data augmentation gains of +3 SR points on downstream navigation tasks.
