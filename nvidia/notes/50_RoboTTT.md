---
id: "50"
org: 英伟达
short: "RoboTTT"
title: "RoboTTT: Context Scaling for Robot Policies"
aliases: ["RoboTTT", "RoboTTT-8K", "DAgger Distillation"]
date: 2026-07-16
category: "操作与其他"
source: "英伟达主导"
partners: []
authors: ["Yunfan Jiang", "Yevgen Chebotar", "Ruijie Zheng", "Fengyuan Hu", "Yunhao Ge", "Jimmy Wu", "Tianyuan Dai", "Scott Reed", "Li Fei-Fei", "Yuke Zhu", "Linxi \"Jim\" Fan"]
arxiv: "2607.15275"
pdf: "[[nvidia/papers/50_2607.15275_RoboTTT.pdf]]"
code: ""
project: "http://research.nvidia.com/labs/gear/robottt/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia", "vla", "test-time-training", "long-context", "in-context-imitation", "dagger"]
---

# RoboTTT: Context Scaling for Robot Policies

> [!info] 论文信息
> arXiv [2607.15275](https://arxiv.org/abs/2607.15275) · v1 2026-07-16
> PDF：[[nvidia/papers/50_2607.15275_RoboTTT.pdf|本地 PDF]]
> [项目页](http://research.nvidia.com/labs/gear/robottt/)
> 系列：物理AI · 操作与其他 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：RoboTTT：用测试时训练层把视觉运动上下文扩展到 8K 步，不增加推理延迟地提升长时程策略。
> 汇总：[[nvidia/英伟达-论文与报告汇总|英伟达论文与报告汇总]]

> [!note] 下面各节是 Claude 根据论文全文（22 页：正文 12 页 + 参考文献 + 附录 A–B）写的初稿（2026-11-16）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身前后对不上的，没有替你选择。

## 一句话总结

在 GR00T N1.7 的 DiT 动作头里，每层注意力后面加一个 **TTT 层**（快权重是一个两层 MLP，推理时也用梯度下降更新）：注意力只管单个时间步内的 token，TTT 层跨时间步把历史压进快权重，所以上下文能拉到 **8K 步（30 Hz 下约 4–5 分钟）**而推理开销不随历史增长。训练上靠**序列动作强制**（每个动作块独立采噪声级）+ **截断 BPTT**（快权重跨段传递、梯度在段边界截断）把训练上下文做长；再利用"只更新快权重、不算损失"的掩码，做出**看一段人手视频就一次模仿**和 **DAgger Distillation**（机器人的失败动作当上下文、人的纠正当目标）。三个真机长时程装配任务上平均完成度 79%（单步 GR00T N1.7 42%），5 分钟十阶段的 Gear Bot 有 2/10 完全成功（基线 0）；预训练上下文从 128 拉到 8K，闭环表现一路上升。

## 要解决什么问题

- 现在的机器人基础模型（π0、GR00T、OpenVLA 等）基本只看**当前一帧或很短的历史（2–8 帧）**；而大语言模型里上下文长度早已是重要的扩展维度。
- 长视觉运动上下文对几类能力是必需的：从人手视频**一次模仿**（in-context imitation）、从自己的部署历史**在线改进**、多阶段长时程任务（阶段之间画面相似，会"状态混淆"）、被干扰后知道回到哪一步。
- 现有做法的问题：
  - 直接把历史帧拼进去：会引入**伪相关**（copycat 问题，策略从历史观测里偷看到过去动作），作者自己的实验里拼一帧历史反而变差。
  - 全历史自回归 Transformer：KV cache 下解码延迟随上下文线性增长，真机长时程跑不动。
  - 传统 RNN（LSTM）：推理恒定开销，但向量状态容量小、扩展性差。
  - 外挂记忆 / 关键帧 / 语言摘要：把长程推理交给高层语义，但丢掉了视觉运动细节。
- 作者归纳的三个挑战：**容量够存长历史**、**真的会用条件上下文**、**推理开销与上下文长度无关**。TTT 的快权重分别对应：MLP 比向量状态容量大；在线训练会保留显著特征、丢掉机器人数据流里大量重复的部分；快权重往下传，推理恒定开销。

## 方法

### TTT 机制回顾（§2）

- 快权重 $W$ 参数化一个小网络 $f_W$。每个时间步先**更新**：$W_t \leftarrow W_{t-1} - \eta \nabla_W \|f_{W_{t-1}}(K_t) - V_t\|^2$，再**应用**：$O_t = f_{W_t}(Q_t)$。
- 投影矩阵 $\theta_Q,\theta_K,\theta_V$、快权重初值 $W_0$、内层学习率 $\eta$ 都由外层任务损失学；$W_0$ 是"梯度的梯度"元学习出来的。
- 和全注意力的对比：注意力保留全部 K/V 每步都看一遍；TTT 把处理过的 token 压进快权重。

### 模型结构（§3.1，[[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=4|图 2、图 3，第 4 页]]）

- 底座：GR00T N1.7 = VLM（附录写的是 Eagle）+ 16 层 DiT 动作头（538M 参数）。每层 DiT 加一个 TTT 层，每个约 10M 参数，合计约 **690M**（需核对：538M + 16×10M = 698M，作者写"总共 690M"，大概是取整）。
- 快模型是**两层 MLP + GeLU**，内层用普通梯度下降（基础学习率 0.1 之上再学一个学习率），Muon 之类的测试时优化器留作后续。位置编码 RoPE（θ=10000）。
- **分工**：自注意力 + 交叉注意力只处理**当前时间步**的 token（寄存器 token $R_t$、本体感知 $q_t$、加噪动作 $\tilde A_t$，交叉注意力看该步的 VL token $\Phi_t$）；之后把各步输出沿时间拼成长序列，交给 TTT 层**跨时间**处理。
- **VL token 不进 TTT 层**（太多太贵），改为每步加 $N=16$ 个可学习的 **register token**，由它们把视觉语言信息带过时间轴。
- **tanh 门控保住预训练能力**：$O = \tanh(\alpha)\odot O_{\text{TTT}} + O_{\text{attn}}$，$\alpha$ 初始化 0.001，开始时 TTT 几乎不起作用，慢慢学着放大（Flamingo 式）。

### 序列训练（§3.2，[[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=5|第 5 页]]）

- 训练样本是整条轨迹或其中连续一段（最长到上下文上限），内层沿序列跑 TTT，外层在**每个时间步**都算 flow-matching 损失再平均。
- **序列动作强制（sequence action forcing）**：每个动作块**独立**采 flow-matching 噪声级 $\tau_t = s(1-u),\ u\sim\text{Beta}(1.5,1),\ s=0.999$。作者说不这样做训练会不稳——整条序列共用一个噪声级时，整段要么全简单要么全难，呼应 Diffusion Forcing 的发现。消融里去掉它几乎做不成任务。
- **截断 BPTT**：序列切段，梯度只在段内流动；但**快权重跨段传递**（值传，梯度 detach），所以 TTT 仍覆盖整条序列，显存只看段长。$W_0$ 通过第一段拿到梯度。
- **推理**：每次 rollout 从学到的 $W_0$ 开始，每步用当前观测更新快权重再往下传；动作块用 $k$ 步去噪生成。

### 从上下文学习（§3.3，[[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=6|图 6，第 6 页]]）

关键是**快权重更新和慢权重损失解耦**：某些时间步把 flow-matching 损失掩掉，它们就只是"上下文"，只更新快权重，不当模仿目标。

- **从人手视频一次模仿**：把同一任务配置的一段人手视频（机器人不动、人用手装）和一条机器人轨迹拼成一个训练序列，视频部分掩损失。测试时给一段**没见过配置**的人手视频，机器人照做。
- **DAgger Distillation**：DAgger 采数据时，机器人出错 → 人接管纠正，得到"机器人动作 / 人的纠正"交错的轨迹。
  - 普通 DAgger：只拿人的纠正微调，机器人的错误动作丢掉。
  - 本文：**全部动作都更新快权重，损失只算在人的纠正上**——"失败当上下文、纠正当目标"，让模型学"看到这种失败就这样纠正"，而不是孤立地模仿纠正。作者把它看作 Algorithm Distillation 在机器人上的实例。
  - 测试时没有人介入，模型自己的纠正进入历史、被快权重吸收。

### 实现（§3.4、附录 A）

| 项目 | 设置 |
|---|---|
| 预训练数据 | 桌面双臂机器人数据 + 第一视角人类数据（EgoScale），偏重长轨迹；长度分布：<512 步 41.4%、512–1K 25.9%、1K–2K 17.1%、2K–4K 12.5%、>4K 3.1%（[[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=20|图 A.1]]） |
| 预训练 | **只训新加的序列层**（TTT 或 GDN），GR00T 其余冻结；上下文逐步加长到目标（如 8K）；30K 步，16 张 GB200；≤4K 时全局 batch 64，>4K 时 16；AdamW，WSD 调度，峰值 lr 2e-5 |
| 后训练 | 每个任务单独、**全参数**；上下文 1K；20K 步，8 张 GB200；cosine，峰值 lr 5e-5 |
| 部署 | YAM 双臂桌面机器人，4 个 RealSense D405（上、下、左腕、右腕）480p；单张 RTX 5090，**30 Hz** 控制 |

## 实验与关键数字

**任务**（[[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=6|图 5]]、附录 B.1）：

| 任务 | 平均时长 | 采集数据 | 内容 |
|---|---|---|---|
| Pup Go Car | 2 分钟 | 8 小时 | 玩具车：装车顶、用电钻拧螺丝、双手交接电钻、翻车、装轮子再拧紧；14 档评分 |
| Circuit | 1 分钟 | 6 小时 | 电路板上装 2–3 个元件，带开关的还要打开；约 80 种配置，训 20 测 60（**全是没见过的配置**），装错顺序不给分 |
| Gear Bot | 5 分钟 | 5 小时 | 十阶段：两侧各装齿轮和两个轮子、翻两次底盘、装头、用遥控器开走；每项 +0.1 |

**基线**：GR00T N1.7（单步）、GR00T N1.7 Hist.（多一帧历史）、**GDN**（把 TTT 层换成 Gated DeltaNet，位置、门控、参数量都对齐——这是最关键的对照，因为同样是固定大小的循环状态，只差更新规则）。序列模型后训练用 1K 上下文，非序列模型按相同算力训练。每种 20 次（Gear Bot 10 次），初始摆放记录下来逐一复现。

### 主结果（[[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=7|图 7]]、表 1）

| 方法 | Pup Go Car | Circuit | Gear Bot |
|---|---|---|---|
| RoboTTT | **9 / 20** | **13 / 20** | **2 / 10** |
| GR00T N1.7 | 3 / 20 | 3 / 20 | 0 / 10 |
| GR00T N1.7 Hist. | 0 / 20 | 8 / 20 | 0 / 10 |
| GDN | 3 / 20 | 8 / 20 | 0 / 10 |

- 平均完成度：RoboTTT **79%**，GR00T N1.7 42%（相对 +87%），最好的基线 GDN 56%（+41%）。分任务的完成度只在柱状图里，正文没列数（文中提到 Pup Go Car 上 GR00T N1.7 57%、Hist. 39.5%）。
- 注意：主结果里 Pup Go Car 用了 DAgger 训练（图 8 注释说扩展实验都早于这一步）。
- 定性三点：**追踪任务进度**（阶段相似时基线会做错动作或跳阶段）；**策略性重试**（电钻没对准螺丝时抬臂、重新对准，基线直接进下一阶段）；**细粒度阶段更准**（被遮挡时靠过去的观测）。
- "只加历史帧有没有用？"——没有：Pup Go Car 上 Hist. 39.5% < 无历史 57%。GDN 在 Circuit、Gear Bot 上好于 GR00T N1.7，但 Pup Go Car 上没有。作者的解释：gated delta rule 是线性联想更新、没有测试时梯度下降，难以从几千步密集重复的机器人流里提取结构。

### 上下文长度扩展（[[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=8|图 8，第 8 页]]）

- RoboTTT 和 GDN 分别用 128 / 256 / 512 / 1K / 2K / 4K / 8K 上下文预训练，再后训练、三任务闭环评测。
- RoboTTT：**8K 时 71.5%**，1K 时 43.9%，最好的短上下文基线 GR00T N1.7 Hist. 45.6%；从 1K 起超过短上下文基线，作者说"没有饱和迹象"。GDN 没有这种趋势。
- 低于 1K 时较差的解释：1K 步约半分钟，比最短任务还短，推理时快权重要更新到训练没见过的长度，位置编码也外推。
- 作者把差异归因于：TTT 的 $W_0$ 和更新动态被外层损失元学习，更长的训练序列能在更多更新步上塑造它；GDN 的线性状态没有这种元学习。

### 一次模仿（表 2，Circuit，10 次）

| 方法 | 完成度 | 完全成功 |
|---|---|---|
| RoboTTT | 65% | **6 / 10** |
| GDN | 33% | 0 / 10 |

- 每个训练配置采 5–20 段人手视频；所有配置都用同一句提示 "assemble circuit"，**目标只能从视频里看出来**。GR00T N1.7 不能吃上下文、Hist. 的窗口装不下视频，所以只和 GDN 比。GDN 拿错元件或装错顺序。

### 抗干扰（表 3，Pup Go Car，各 20 次）

| 方法 | 拿掉车顶 | 拿掉轮子 |
|---|---|---|
| RoboTTT | **15** | **18** |
| GR00T N1.7 | 10 | 11 |
| GR00T N1.7 Hist. | 3 | 5 |
| GDN | 13 | **18** |

- 额外采 30 分钟干扰数据和任务数据共训。所有方法都有一定恢复能力（作者认为来自共训），长上下文方法更好；RoboTTT 和 GDN 差距不大。

### DAgger Distillation（[[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=10|图 10、图 11，第 10 页]]，Pup Go Car）

- DAgger 数据：RoboTTT 和 GR00T N1.7 当基础策略各采 50 条，合起来 100 条给所有方法用。
- 普通 DAgger（只用人的纠正）：四个方法平均提升 9%，两个序列模型平均 13%。
- **DAgger Distillation**（只适用于序列模型）：平均 **33%**——RoboTTT +36%，GDN +29%。
- 对照：GR00T N1.7 用整条轨迹（含机器人错误动作）当模仿目标微调，和只用纠正**完全一样（都是 57%）**——说明错误动作当目标没价值，价值在于当上下文。
- 定性：增益主要来自出错后的恢复（图 11：拧车顶螺丝两次没对准，第三次成功）。

### 消融（[[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=11|图 12，第 11 页]]，Pup Go Car）

- 去掉序列动作强制：动作不准，几乎没进展。
- 快模型换成线性层（TTT-Linear）：好于 GR00T N1.7，但比 MLP 差 27%。
- 开发路线：TTT 只处理状态 token → 加动作 token（相对 +23%，知道自己过去做了什么能更好地捕捉动力学）→ 加 register token（再 +18%）= 完整 RoboTTT。
- 给 GR00T N1.7 加同样数量的 register token **没用**，说明 register token 只在配合 TTT 的时间建模时才有帮助。

## 局限 / 存疑

作者承认的：

- 训练上下文变长，训练成本上升；可以考虑 TNT 等更新的 TTT 训练技巧。
- TTT 层用的还是通用的 K→V 重建目标，可以探索面向机器人的自监督目标。
- 不能解决部署中所有失败模式；下一步想结合强化学习直接优化成功率。

读的时候值得核对的：

- **摘要和正文数字对不上（需核对）**：8K vs 1K，摘要写"高 62%"，引言和 §4 写"高 63%"。按 71.5% / 43.9% 算是 1.629，即 63%。另外 79% / 42% = 1.88，正文写 +87%，应该是用未取整的数算的。
- **VLM 骨干说法不一（需核对）**：附录 A.1 说 GR00T N1.7 的 VLM 是 Eagle；本库 [[nvidia/projects/GR00T-N1.7|GR00T N1.7 项目笔记]] 记的是 Cosmos-Reason2-2B。
- **"8K 上下文"指的是预训练**：所有任务的后训练都只用 **1K 上下文**，而任务本身 1–5 分钟（1.8K–9K 步）。部署时的有效上下文其实是"整条 rollout，快权重一路更新"，比后训练窗口长得多；8K 预训练的好处是让快权重在长更新序列下稳定，而不是后训练真的看了 8K。
- **"推理延迟不随上下文增长"没有给出具体数字**：只说 RTX 5090 上 30 Hz 控制，没有报每步耗时、和 GR00T N1.7 的延迟对比，也没有说 $k$ 步去噪的 $k$ 是多少。
- **统计量小**：每个条件 20 次（Gear Bot、一次模仿只有 10 次），没有置信区间；Gear Bot 2/10 vs 0/10、抗干扰里 RoboTTT 15/20 vs GDN 13/20 这种差距在统计上很难说显著。
- **扩展曲线只有一条**：每个上下文长度只训一个模型、评一次，"没有饱和"是看 7 个点的趋势；预训练数据里 >4K 的轨迹只有 3.1%，8K 上下文的样本很少，增益具体从哪来不好拆。
- **预训练时只训 TTT / GDN 层、冻结其余**，后训练才全参数——GDN 和 TTT 在同一流程下对比是公平的，但 GR00T N1.7 单步基线没有这段额外的 30K 步预训练（论文说非序列模型"按相同算力"训练，具体怎么对齐需核对）。
- **只在一个底座、一个机器人上验证**：GR00T N1.7 + YAM 双臂，3 个装配任务；"plug-and-play 适配任意 VLA" 是说法，没有实验。
- **一次模仿只在 Circuit 上**，而且视频配置的变化是"元件组合 + 顺序"，组合空间有限（80 种）；没测换物体、换场景的泛化。
- 代码和权重：项目页之外没有给代码仓库链接（`code` 留空）。

## 与其他论文的关系

- **底座**：[[nvidia/projects/GR00T-N1.7|GR00T N1.7]]（参考文献引用的是 [[nvidia/notes/12_GR00T-N1|GR00T N1]] 论文）；预训练用到 [[nvidia/notes/35_EgoScale|EgoScale]] 的第一视角人类数据。同组的后续 [[nvidia/notes/52_GR00T-2|GR00T 2]] 走世界动作模型路线，可以对比"长上下文"和"预测未来视频"两种给策略加时间信息的方式。
- **TTT 一系**：Sun et al. 2020（原始 TTT）→ Learning to (Learn at Test Time)（TTT-Linear / TTT-MLP，RNN 视角）→ **LaCT（Test-Time Training Done Right）**（大块更新、非线性快模型，本文快模型设计主要参照它）→ End-to-end TTT for long context、TNT、Titans。视频方向有 One-Minute Video Generation with TTT，视觉有 ViT³，3D 重建有 TTT3R。更早的根源是 Schmidhuber 的快权重（Linear Transformers are Secretly Fast Weight Programmers）。
- **对照的线性循环层**：Gated DeltaNet（Yang, Kautz, Hatamizadeh），本文的 GDN 基线；两者都是固定大小状态，差在"线性联想更新"还是"梯度下降更新非线性 MLP"。
- **训练技巧来源**：Diffusion Forcing（逐 token 独立噪声级）→ 本文的序列动作强制；Flamingo 式 tanh 门控；register token（Vision Transformers Need Registers、Perceiver）。
- **长上下文策略**：BPP（关注关键历史帧）、MEM（多尺度具身记忆）、OneTwoVLA（语言推理）等把历史交给关键帧或语言；ContextVLA 压缩 VL token 来加长观测窗口；ICRT（In-Context Imitation Learning via Next-Token Prediction）等全历史自回归；"copycat"伪相关问题（Wen et al. 2020）。记忆基准 RoboMME 是作者引的"会不会用上下文"的评测。
- **在线改进**：Algorithm Distillation（Laskin et al.）是 DAgger Distillation 的直接灵感；RMA（快速运动适应）、AdA（Human-Timescale Adaptation）属于"上下文适应"一族。
- **同名但不同的"测试时训练"**：[EVOLVE-VLA](https://arxiv.org/abs/2512.14666)（在 [[topics/递归自我改进RSI|递归自我改进RSI]] 专题第二节里）、TTT-Parkour 等是在测试任务上收数据**微调整个模型**，没有快权重；最接近的是 VITA（给 VLM 加快权重去适应价值函数），但不是视觉运动策略。RoboTTT 的 DAgger Distillation 也可以放进 RSI 专题的"在线改进"一类对照着看。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文 CC BY 4.0，这里只记位置和要点，原句请点页码看）
> 1. [[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=2|第 2 页]]引言第 2–3 段：8K 步上下文、6/10 一次模仿、+36% 在线改进、83% vs 53% 抗干扰、+87%、8K 比 1K 高 63% → 主要结论
> 2. [[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=3|第 3 页]] §2 式 (1)(2)："先更新再应用"，$W_0$ 与投影由外层损失学 → TTT 机制
> 3. [[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=4|第 4 页]] §3.1：TTT 层放在注意力后，注意力管单步、TTT 管跨步；VL token 不进 TTT，靠 16 个 register token → 结构
> 4. 第 4 页式 (3)：tanh 门控，$\alpha$ 初始化 0.001 → 保住预训练能力
> 5. [[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=5|第 5 页]]"Sequence Action Forcing"：每个动作块独立噪声级，否则训练不稳 → 序列动作强制
> 6. 第 5 页 TBPTT 段与图 4：快权重跨段传递、梯度在边界 detach → 训练长上下文
> 7. [[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=6|第 6 页]] §3.3 与图 6：失败当上下文、纠正当目标 → DAgger Distillation
> 8. [[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=8|第 8 页]]表 1 与"Can history alone match"段；[[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=9|第 9 页]] 71.5% / 43.9% / 45.6% → 主结果与扩展曲线
> 9. 第 9–10 页表 2、表 3 与 DAgger 段：6/10 vs 0/10；平均 +9% vs +33%；全轨迹微调与只用纠正同为 57% → 一次模仿、抗干扰、DAgger
> 10. [[nvidia/papers/50_2607.15275_RoboTTT.pdf#page=20|第 20 页]]附录 A：Eagle VLM、538M→690M、预训练只训序列层、后训练 1K 上下文、RTX 5090 30 Hz → 实现细节与存疑点

## 摘要（中文）

近来的机器人基础模型只使用单步或短历史的视觉运动上下文。我们提出测试时训练机器人策略（RoboTTT），一种把视觉运动上下文扩展到 8K 时间步的机器人模型与训练方法，比当前最好的策略长三个数量级，而且推理延迟不随之增长。在这个上下文长度下，我们解锁了新的机器人能力：从人类视频示范中一次性上下文模仿、在线策略改进、对干扰的鲁棒性，以及在多阶段长时程任务上更强的表现。我们还首次观察到闭环表现随预训练上下文长度增长而稳定提升。RoboTTT 的核心是把测试时训练（TTT）融入视觉-语言-动作策略等机器人基础模型，得到一个循环状态由快权重构成的序列模型：快权重在训练和推理时都用梯度下降更新，把历史压缩进权重空间，并检索上下文信息以支持长上下文条件化。为扩展训练上下文长度，该方法结合了序列动作强制与截断时间反向传播。在有挑战性的真机操作任务上，RoboTTT 的整体表现比单步上下文基线高 87%，并完整完成了一个五分钟、十阶段的装配任务，没有任何基线做到过。用 8K 步上下文训练的 RoboTTT 比用 1K 步预训练的同一模型高 62%，表明上下文长度可以成为机器人基础模型新的扩展维度。

## 摘要（原文）

> Recent robot foundation models operate with single-step or short-history visuomotor context. We introduce Test-Time-Training Robot Policies (RoboTTT), a robot model and training recipe that scale visuomotor context to 8K timesteps, three orders of magnitude beyond state-of-the-art policies, without growing inference latency. At this context length, we unlock new robot capabilities: one-shot in-context imitation from human video demonstrations, on-the-fly policy improvement, robustness to perturbations, and stronger performance on multi-stage, long-horizon tasks. We also observe, for the first time, steady gains in closed-loop performance as pretraining context length scales. At its core, RoboTTT integrates Test-Time Training into robot foundation models such as Vision-Language-Action policies, yielding a sequence model whose recurrent state consists of fast weights, parameters updated by gradient descent during both training and inference, compressing histories into weight space and retrieving contextual information for long-context conditioning. To scale training context length, the recipe combines sequence action forcing with truncated backpropagation through time. On challenging real-robot manipulation tasks, RoboTTT improves overall performance by 87% over the single-step context baseline and fully completes a five-minute, ten-stage assembly task, which no baseline ever does. RoboTTT trained with 8K-timestep context outperforms the same model pretrained with 1K timesteps by 62%, suggesting context length as a new scaling axis for robot foundation models. Videos are available at this https URL
