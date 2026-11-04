---
id: "09"
org: 自变量
short: "HOST"
title: "HOST:Robots Acquire Manipulation Skills in Seconds from a Single Human Video"
aliases: ["HOST"]
date: 2026-07-22
category: 技能学习
source: 自变量主导
partners: ["北京理工大学", "清华大学"]
authors: ["Guangyan Chen", "Meiling Wang", "Te Cui", "Zichen Zhou", "Qi Shao", "Shalfun Li", "Hang Su", "Roy Gan", "Hao Wang", "Mengyin Fu", "Yi Yang", "Yufeng Yue"]
arxiv: "2607.20033"
pdf: "[[xsquare/papers/09_2607.20033_HOST.pdf]]"
code: "https://github.com/CGuangyan-BIT/HOST"
project: "https://x2robot.com/pages/host"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "one-shot-imitation", "human-video", "skill-acquisition"]
---

# HOST:Robots Acquire Manipulation Skills in Seconds from a Single Human Video

> [!info] 论文信息
> arXiv [2607.20033](https://arxiv.org/abs/2607.20033) · v1 2026-07-22 · 最新 v4（2026-08-20）
> PDF：[[xsquare/papers/09_2607.20033_HOST.pdf|本地 PDF]]
> [代码](https://github.com/CGuangyan-BIT/HOST) · [项目页](https://x2robot.com/pages/host)
> 合作单位：北京理工大学、清华大学

> [!note] 下面各节是 Claude 根据论文写的初稿，2026-11-03 按精读讨论做了补充，并新增「精读问答」一节。读的时候请核对并改成你自己的理解。

## 一句话总结

机器人看一段人类视频，不更新任何参数就能执行新任务：先在视频里定位自己做到哪一步，再把视频接下来的进展翻译成自己视角的未来画面，最后从画面推出动作。对比实验的 8 个新任务平均成功率 62%，习得一个技能平均约 29 秒（基本就是录一段视频的时间），且不会遗忘已掌握的技能。

## 要解决什么问题

- 习得新技能依赖"采集示范 → 微调"的训练期循环：慢（50 条示范时每任务约 4–5 小时）、贵，还会侵蚀已掌握的技能。
- 已有的单样本视觉模仿（OSVI）方法难以把人类视频转成机器人动作。论文归结为三点结构性错配（见 §1）：
  1. **时间不同步**：人和机器人做同一任务的速度不同，预测目标与视频脱钩，视频沦为"被动上下文"；
  2. **状态差异**：整段视频一次性输入，混入大量与当前阶段无关的状态；本体、视角、外观的差异又让高维视频难以直接回归到低维动作；
  3. **配对数据稀缺**：人和机器人做同一件事的配对数据很少。

## 方法

方法总览见 [[xsquare/papers/09_2607.20033_HOST.pdf#page=4|图 2（第 4 页）]]：A 讲训练目标怎么定，B 讲模型怎么逐步预测，C 讲推理时怎么用。

### 机制一：预测目标与示范视频耦合（图 2A，§4.2）

**对齐模块**：先单独训练，训完冻结，只用于离线构造训练样本，推理时不调用（见附录 B.1）。
- Qwen3-VL-Embedding-8B 全量微调。每个时刻的三路相机图像加 [EOS] 输入，取最后一层 [EOS] 位置的隐状态（1,536 维），线性投影到 128 维后做 L2 归一化。人类视频和机器人轨迹共用同一个编码器。
- 两两负平方距离 → 按列 log-softmax 得到代价矩阵 → Smooth DTW 前向–后向得到软匹配概率 β → 取 argmax 得到单调的帧对应 $\pi_{r\to d}$、$\pi_{d\to r}$。
- 损失为时间循环一致性 TCC + 0.3 × DTW 路径代价，两个方向对称。训练数据是同一任务的任意两条轨迹（机器人–机器人和人–机器人都有），不需要帧级标注。

**耦合目标的构造**：对机器人第 t 步，
1. $k=\pi_{r\to d}(t)$：机器人现在对应视频第 k 帧；
2. 取视频接下来的 H=32 帧，k…k+31；
3. 逐帧映射回机器人时刻 $t_i=\pi_{d\to r}(k+i)$，这些时刻的机器人数据就是目标：32 个动作 𝒯ᵃ 全部保留，画面 𝒯ᵒ 按 8:1 降采样成 4 帧；
4. 围绕这一段截取 192 帧视频窗口 W（降采样后输入 24 帧，位置随机偏移），k 在 W 中的相对位置记为进度标签 $p_t$。

一条样本 =（W、机器人当前画面、本体状态、指令 → $p_t$、𝒯ᵒ、𝒯ᵃ）。和常规做法相比（目标取 t+1…t+32，按机器人自己的节奏往后数），**只改了标签，网络和损失都不变**。

### 机制二：自我锚定预测级联（图 2B，§4.3）

一个自回归扩散模型，按因果顺序生成三个目标：
1. **定位**：进度 p，即机器人在视频窗口里做到了哪一步；
2. **视觉**：把视频接下来的进展翻译成机器人**自己相机**里的未来画面；
3. **动作**：从预测画面推出 32 步动作块。

- 架构是双专家 Mixture-of-Transformers（见附录 B.2）：
  - 视频专家：30 层 DiT，由 Wan2.2-TI2V-5B 初始化，hidden 3,072，负责定位和视觉；
  - 动作专家：30 层，hidden 1,024，负责动作；
  - 两者每层拼接 Q/K/V 做共享自注意力，FFN 各自独立。
- 输入：视觉部分经冻结的 Wan VAE 编码；指令经冻结的 UMT5-XXL 编码，本体状态经线性投影，两者都通过交叉注意力注入。训练时有 50% 概率丢弃示范视频，只靠指令。
- token 序列为 `[z_d ‖ z_o ‖ y^p_σ, y^p ‖ y^o_σ, y^o ‖ y^a_σ]`。每个目标有一对 token，一个加噪、一个干净；注意力掩码保证每个目标只能看到上下文和前面目标的干净 token。三个目标在一次前向里联合训练。
- 损失为 flow matching：$\mathcal{L}=\lambda_p\mathcal{L}_{loc}+\lambda_o\mathcal{L}_{obs}+\lambda_a\mathcal{L}_{act}$，每一项都是 $\lVert\hat v-(\epsilon-y)\rVert^2$。

### 两阶段训练（§4.4）

- 阶段 1：229 个任务、193,462 条机器人轨迹两两配成机器人–机器人对，一条当示范、一条当目标，训练 50 万步。
- 阶段 2：5,847 段自采的人类视频，每段配同任务的机器人轨迹，训练 10 万步。
- 只用阶段 2 的数据效果很差；阶段 1 数据越多，效果越好（§2.10）。

### 推理（图 2C，附录 B.5）

每个循环：定位（10 步去噪）→ 预测画面（20 步）→ 生成动作（20 步）→ 执行全部 32 步 → 按预测进度把窗口前移（只能前进，不能后退）。全程不更新参数。示范视频连同指令和初始场景存入记忆库，同类任务再次出现时按相似度检索复用。

### 关键设置

| 项 | 取值 |
|---|---|
| 平台 | 双臂 ARX R5（六轴 + 平行夹爪），2 个腕部相机 + 1 个第三人称相机 |
| 动作 | 每臂 10 维（位置 3 + 6D 旋转 6 + 夹爪 1），双臂共 20 维，为绝对末端位姿 |
| 动作块 H / 视频窗口 L | 32 步 / 192 帧（输入 24 帧） |
| 目标画面 | 4 帧（32 步按 8:1 降采样） |
| 机器人历史 K | 0（只用当前帧） |

## 实验与关键数字

设置：全部是真机实验，单一平台。每个任务做 20 次试验，物体初始位置随机，由人工判定是否成功（见 §2.2）。"新任务"指所需技能不在训练数据中的任务。

**主结果**
- 50 个新任务全部能完成，单任务成功率约 45%–75%（图 4）。
- 在其中 8 个新任务上与基线对比，平均成功率如下（图 5）：

| 方法 | 测试时输入 | 平均成功率 |
|---|---|---|
| HOST-base（同骨干，无耦合和级联） | 语言 | 4% |
| π0.5 | 语言 | 11% |
| Vid2Robot（作者复现） | 视频 | 16% |
| Wall-OSS | 语言 | 17% |
| AWDA | 视频 | 19% |
| **HOST** | 视频 | **62%** |

- 摘要里的 62% 就是这 8 个任务的平均值。"比零样本基线高 45%""比 OSVI 基线高 43%"都是**绝对百分点**（62−17、62−19）。两个 OSVI 基线都把各自的条件机制移植到 HOST 骨干上，并按相同的两阶段流程训练。
- 与 LoRA 微调对比（§2.5）：最好的 Wall-OSS+SFT 用 50 条示范达到 56%，仍低于 HOST。SFT 每个任务需要 4.0–4.9 小时（采集 + 训练），HOST 约 29 秒，快 507 倍。
- 保留旧技能（§2.6，7 个已掌握任务）：用 50 条示范微调后，π0.5+SFT 只保留原有性能的 20%，HOST-base+SFT 保留 22%，Wall-OSS+SFT 保留 43%；HOST 不更新参数，基本没有损失。

**消融**
- 目标耦合（§2.8，图 9E）：整段视频作条件 0.21 → 按时间戳截取窗口 0.29 → 按进度截取窗口 0.45 → 目标与视频耦合 0.62。在人工标注的事件点上，对齐误差从按时间比例对应的 0.079 降到对齐模块的 0.006。
- 自我锚定级联（§2.9，图 10A）：视频直接映射到动作 0.34 → 加进度定位 0.43 → 加画面预测（与动作并行）0.55 → 从预测画面推出动作 0.62。进度定位的平均误差为 0.013。
- 阶段 1 数据量（§2.10）：成功率随数据量单调上升。

**部署相关**
- 鲁棒性（§2.7）：光照变化 −1、分布外物体 −4、更换场景 −6、执行中有人挪动物体 −9（单位为百分点）。
- 持久化（§2.11）：检索阈值在较宽范围内都能同时保证复用准确率和新任务识别；用检索到的视频执行，效果与新录视频相当。

## 局限 / 存疑

论文自述（§3）：
- 只在一个双臂平台上测试过，没有在本体差异大的机器人上验证；
- 视频传达不了接触力，精细操作受限；
- 记忆库变大后，指令和场景只差一点的任务可能检索错。

精读中留下的疑问：
- **对齐可能失效的场景**（推测）：重复或周期性动作（来回擦、搅拌）；步骤顺序可变的任务（违反 DTW 的单调假设）；视觉上看不出变化的阶段（拧紧、按压到位）。
- **新任务有多"新"**：训练集 229 个任务的列表不在正文里，难以判断"擦盘子"这类新任务和训练任务差多远。
- **推理延迟**：文中没有找到具体数字。每个循环要做 10+20+20 步去噪再执行 32 步，实际控制频率值得关注。
- **对比的公平性**：π0.5、Wall-OSS 测试时只有指令，HOST 有视频，所以 45 个点里有一部分来自信息差。更能说明方法本身作用的，是与 OSVI 基线的对比（43 个点）和消融（0.21 → 0.62）。
- **采样间隔**：附录 B.4 写"base action frame interval 15 frames at 32Hz，随机缩放 0.5–2 倍"，描述比较简略。耦合目标"跳着取"的时刻和执行节奏之间的具体换算，还没有弄清楚。

## 与其他论文的关系

- 同样从人类数据学习：[[08_XRZero-G0]]（免机器人数据采集）、[[23_EgoJEPA]]（第一视角视频）。
- [[03_WALL-WM]]：同公司，同样用 Wan2.2-5B 初始化视频塔、再加一个动作 DiT。区别在于：WALL-WM 的动作塔用单向交叉注意力读取视频特征，关注预训练单元怎么切（按语义事件）；HOST 用 MoT 共享自注意力，关注新任务怎么进来（靠示范视频而非微调）。
- [[01_WALL-OSS]]：实验中的语言条件基线之一。
- Fast-WAM（arXiv 2603.16666）：基线 HOST-base 引用它，并与 HOST 共享骨干。Fast-WAM 认为 WAM 的收益主要来自训练时的视频共训练，推理时不必生成画面；HOST 的级联消融（0.55 → 0.62）则显示，在单段人类视频的场景下，显式生成画面再推动作仍有帮助。两者设置不同，不能直接说谁推翻了谁。
- LingBot-VA：同样用 MoT + 自回归扩散联合预测未来帧和动作，结构上最接近。
- OSVI 基线是 Vid2Robot 和 AWDA；对齐方法沿用 Hadji et al. 2021（Smooth DTW）和 Dwibedi et al. 2019（TCC）。

## 精读问答

整理自 2026-11-03 的讨论。

### HOST 是 Transformer backbone 吗？

HOST 是整个框架的名字，包括对齐模块、策略模型和推理循环。图 2 里标着 "HOST" 的方块是策略模型，骨干是**扩散 Transformer（DiT）**，靠 flow matching 去噪来生成输出，不是直接回归。结构上接近 π0 的"VLM + 动作专家"，只是底座换成了视频扩散模型。

视频专家来自 Wan2.2-TI2V-5B。Wan（通义万相）是阿里巴巴通义团队的开源视频生成模型，Wan2.2 于 2025 年 7 月开源；5B 版本是用文本或图像作条件的稠密模型，单卡就能跑。这段背景来自 Claude 的知识，论文只给了引用。

### 图 2A 的预测目标是什么？

三样：进度 p（一个标量）、机器人自己未来的画面 𝒯ᵒ、同一批时刻的动作 𝒯ᵃ。
- 目标全部来自**机器人自己的轨迹**，人类视频只当输入。这就是 "self-grounded" 的含义。
- 取轨迹上的哪些时刻，由视频决定。机器人比人慢时，目标在轨迹上是"跳着取"的；图 2A 上排的 𝒯 不紧挨着 O，就是在画这一点。

### 视频起什么作用？模型要推测人的意图吗？

推理时视频是**输入，不是训练数据**，权重不变，更像大模型的 in-context learning。模型在训练中学会的，是"怎么跟着一段示范做"这个元能力。

"理解人类视频"可以分三层，HOST 只取中间一层：

| 层次 | 例子 | HOST 怎么处理 |
|---|---|---|
| 语义意图（为什么做） | 人想把花插进瓶子 | 不专门建模，主要靠指令提供 |
| **任务进展（接下来场景该变成什么样）** | 红花离开桌面、到瓶口上方 | **从视频里拿走的就是这一层** |
| 人的身体动作（手怎么动） | 手指角度、手腕轨迹 | 不提取 |

这种理解是隐式学到的，但可以检查：进度 p 和预测画面都是中间输出，看预测画面就能知道模型从视频里理解了什么。

### 需要从视频里提取人的动作吗？

不需要。没有手部姿态估计、关键点或重定向，人类视频以原始像素直接进 VAE。跨本体的翻译发生在"预测机器人自己的未来画面"这一步。

对比其他路线：重定向方法要先提取人手姿态再映射到机器人，受本体差异和姿态估计精度限制；FMimic 等模块化 OSVI 方法先提取手–物关键点再开环回放，执行很脆，只能做简单动作。

### 目标耦合为什么能把 0.45 提到 0.62？

- 固定偏移时，目标由机器人自己的节奏决定，和视频关系松散。模型容易走捷径，只看自己的画面和指令。这在训练任务上行得通，但新任务的信息只在视频里，捷径就失效了。
- 耦合之后，目标第 i 步和视频第 k+i 帧一一对应，任务变成"把视频接下来这一段，用我的身体在我的场景里重演一遍"。不读视频就做不对。
- 进度 p 恰好标出耦合段在窗口里的起点，推理时也按同样的规则运行。

### 什么是 DTW？

动态时间规整（Dynamic Time Warping），用来对齐两条快慢不同的序列。在代价网格上从左上角走到右下角，只能向右、向下或向右下走（单调、不跳格），找总代价最小的路径。用动态规划递推：$R(i,j)=c(i,j)+\min\big(R(i-1,j-1),R(i-1,j),R(i,j-1)\big)$。

例：人 A=[1,3,5]，机器人 B=[1,1,1,3,5]（在第一阶段磨蹭了很久）。DTW 得到 A1↔B1–3、A2↔B4、A3↔B5，总代价为 0。按时间比例对应则会把 B3（实际还在第一阶段）错配到 A2。

HOST 用的是 **Smooth DTW**：把 min 换成可导的加权平均（smoothMin），带来两个好处：
1. 总代价可以直接当损失来训练编码器；
2. 用前向表和反向表可以算出软匹配概率 β，再取 argmax 就得到帧对应。

### 为什么能在"任务进度流形"上对齐？

"流形"是概念上的说法，实际计算只有 128 维嵌入、两两距离和 DTW。三种差异分开处理：

| 差异 | 谁来解决 |
|---|---|
| 速度（各阶段快慢不同） | DTW 的单调拉伸 |
| 外观（人手和夹爪、视角、光照） | 编码器学会忽略 |
| 阶段顺序 | 同一任务天然一致，是可以利用的共同结构 |

编码器能学到阶段信息，靠的是这几点：
- TCC 只认跨执行一致的信息，也就是物体状态和空间关系；
- 列归一化类似对比学习，防止所有帧被编码成一样；
- Qwen3-VL 本身带有语义先验；
- 训练配对里包含人–机器人对。

### 对齐模块怎么自监督？

不告诉模型哪两帧对应，只告诉它"这两段是同一个任务"，然后利用"同一任务一定能按顺序、来回一致地对上"这个结构约束来训练。

一次迭代：采样同一任务的两段 → 编码每一帧 → 计算代价矩阵 → 跑 Smooth DTW → 用两个损失反向传播。
- **DTW 损失** $R(T,N)/(T+N)$：要求两段整体能按顺序、低代价地对齐。
- **TCC 损失**：视频第 i 帧 → 在机器人序列里找软最近邻 → 再找回视频，应该回到 i 附近。带一个方差项，允许模糊的帧表达不确定，但会被 log ν 惩罚。

更准确地说，这是"序列级弱监督、帧级自监督"。

### 还需要人工标注吗？

不需要帧级对应、进度、人的动作或阶段切分的标注。需要的是：
- **任务归类**（哪些数据是同一个任务）：按任务录制时就自带了；
- **机器人动作**：遥操作时记录下来的，不是标出来的，但遥操作本身是最贵的部分；
- **人–机器人配对**：成本在拍视频，不在标注。

唯一的人工标注是评估对齐精度时用的事件点，不参与训练。部署新任务时只需要一段视频，指令可选。

### HOST 算 WAM 吗？

从架构看算。论文对 WAM 的定义是"在同一架构里联合训练视频预测和动作生成"，HOST 完全符合；基线 HOST-base 引用 Fast-WAM，并与 HOST 共享骨干。但论文只在相关工作里提到 WAM，把它当作"仍需微调、泛化不出训练分布"的一类方法，自己的定位是单样本视觉模仿。

和典型 WAM 的区别：
- 多了示范视频作条件，还多了进度 token；
- 预测画面是"有参照的翻译"，而不是自由想象；
- 画面和动作是因果级联，而不是并行生成。

严格意义上的世界模型是"状态 + 动作 → 下一状态"。HOST 先出画面再推动作，更接近 UniPi 那条"视频规划 + 逆动力学"的路线。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（中文）

对机器人来说，能够快速、轻松地习得新技能，同时保留已经掌握的技能，至关重要。然而，现有方法仍依赖繁琐的"训练期循环"：成本高、速度慢，还会侵蚀已掌握的技能。本文提出 HOST（Human-to-robot One-Shot Skill AcquisiTion，人到机器人的单样本技能习得）。这一框架让机器人只需一段人类视频，就能在数秒内习得新技能，同时保留原有技能。

HOST 通过一串层层递进的"自我锚定预测"来完成技能习得：先估计机器人在示范任务中进行到了哪一步；再把接下来的任务进展转化为机器人自身未来的观测画面；最后从这些预测出的观测中推导出动作。这条预测链的训练目标与视频示范是绑定的：先把机器人轨迹和视频示范映射到一个共享的"任务进度流形"上，再重新定义每个训练目标，使其对齐视频接下来的进展。这样，机器人就能主动跟随示范的操作流程，并把它适配到自己的本体上。

HOST 在推理阶段仅凭一段人类视频即可习得新技能，平均耗时 29 秒，平均成功率 62%。它比零样本基线高出 45%，同时保留了原有技能。它甚至超过了"每个任务用 50 条机器人示范微调"的基线，所需示范少 50 倍，每项技能的习得速度快 507 倍。

## 摘要（原文）

> The ability to acquire skills rapidly and effortlessly while retaining those already mastered is essential for robots. However, current methods still rely on a cumbersome training-time loop that is costly and slow, while eroding skills already mastered. In this paper, we introduce HOST (Human-to-robot One-Shot Skill AcquisiTion), a framework that enables a robot to acquire skills in seconds from a single human video while retaining previously mastered skills. HOST resolves skill acquisition through a cascade of self-grounded prediction. It first estimates the robot's progress within the demonstrated task, then translates the upcoming progression into the robot's own future observations, and finally derives actions from these predicted observations. This cascade is trained on targets coupled to the video demonstration, obtained by mapping the robot trajectory and the video demonstration onto a shared task progress manifold, then redefining each target to align with the future progression of the video. HOST thereby enables the robot to actively follow the demonstrated procedure and adapt it to the robot's embodiment. HOST acquires novel skills at inference time from a single human video in an average of 29 seconds and achieves a 62% average success rate. It exceeds the zero-shot baseline by 45% while retaining previously mastered skills. HOST even exceeds the baseline fine-tuned on 50 robot demonstrations per task while requiring 50 times fewer demonstrations and acquiring each skill 507 times faster. Additional information about HOST is available on the project website.
