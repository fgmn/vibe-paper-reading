---
id: "1-05"
org: 专题·代码世界模型与神经渲染
short: "CoDeR"
title: "Code Plans, Diffusion Renders: Open-Ended Generative World Modeling"
aliases: ["CoDeR", "Code Plans, Diffusion Renders", "Observation as World Registration", "Visual Cue Hacking"]
date: 2026-09-22
category: "代码世界 + 视频渲染器（完整系统）"
venue: —
affiliation: "中国科学技术大学 · 通义实验室（TongYi Lab）"
authors: ["Zixun Fang", "Yawen Shao", "Kai Zhu", "Jie Xiao", "Shihan Chen", "Yu Liu", "Xueyang Fu", "Yang Cao", "Wei Zhai", "Zheng-Jun Zha"]
arxiv: "2609.26458"
pdf: "[[topics/papers/代码世界模型与神经渲染/1-05_2609.26458_CoDeR.pdf]]"
code: ""
project: "https://becauseimbatman0.github.io/CoDeR"
license: CC BY 4.0（arXiv 摘要页）
status: 未读
rating:
read_date:
tags: ["paper", "world-model", "code-world", "neural-rendering", "coding-agent", "multi-agent", "threejs", "minimax-h3", "memory", "whitebox"]
---

# Code Plans, Diffusion Renders: Open-Ended Generative World Modeling

> [!info] 论文信息
> arXiv [2609.26458](https://arxiv.org/abs/2609.26458) · 本地 PDF 是 v1（2026-09-22，目前也只有 v1）
> 单位：中国科学技术大学（1）、通义实验室（2）· 前两位作者 Zixun Fang、Yawen Shao 同属两家；论文没有标注共同一作或通讯作者
> PDF：[[topics/papers/代码世界模型与神经渲染/1-05_2609.26458_CoDeR.pdf|本地 PDF]]（23 页：正文第 1–10 页 + 参考文献第 10–19 页 + 附录第 20–23 页：AI 使用声明、用户研究、Visual Cue Hacking、评测细节、局限、未来工作）
> 代码：论文说"代码和模型权重将公开"，arXiv 页没有代码链接 · 项目页：[becauseimbatman0.github.io/CoDeR](https://becauseimbatman0.github.io/CoDeR)
> 专题：[[topics/代码世界模型与神经渲染#一、代码世界 + 视频渲染器（完整系统）|代码世界模型与神经渲染 · 一、代码世界 + 视频渲染器（完整系统）]]

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-18）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。

## 一句话总结

把"造一个世界"拆成五个角色：**God of Concepts**（用户，用文字或图片说想要什么）→ **Creator**（LLM，定规则、定基调、出蓝图）→ **Executors**（一组编码智能体，按"逻辑空间"分工并行写 **Three.js 白盒世界**，再按接口契约拼起来）→ **Artists**（MiniMax-H3 微调成的视频渲染器，输入白盒视频 + 引擎导出的真值深度 + 从世界状态拼出的提示词）→ **Travelers**（玩家或相机，决定渲染哪里）。核心机制是 **Observation as World Registration**：生成出来的画面靠深度反投影"贴回"白盒世界的表面，下一次看到这块区域时，Artist 拿到的是"部分已上色"的白盒视频，以此做长时记忆。渲染器只训练了 200 步（32 张 A800，LoRA + ControlNet 分支全参），训练目标视频本身是用 Canny + 深度喂 ControlNet 合成的（"Visual Cue Hacking"）。WorldScore 10 项指标平均 **87.88**，对比 LingBot-World 74.79、Matrix-Game 3.0 74.20、ABot-World 69.24；但它是先从基准首帧重建白盒世界再评，口径与基线不同，且没有任何速度数字。

## 要解决什么问题

- 视频世界模型把世界状态**隐式**放在视觉历史里，导致三个老问题：持久记忆难、看不见的东西不会继续演化（离开视野的实体"冻住"）、物体交互不一致。
- 更根本地，画面只是世界的一部分：规则（交通法规）、内部状态（生命值、声望）、精确动力学（牛顿定律）不能从像素里可靠推出来。作者用"冰箱里的水不管有没有人看都会结冰"来说明：世界应按规则演化，与是否被观察无关。
- LLM 有世界知识和推理能力，可以把世界翻译成可执行规则和状态转移；但**光生成一段场景代码不够**：
  1. 一个完整世界由交通、建筑、资源管理等异质子系统组成，需要分解与协调；
  2. 抽象规则和状态转移要转成视频模型能跟随的时空条件。
- 所以需要一个框架同时组织"世界怎么搭"和"搭出来的世界怎么接到视觉生成上"。

## 方法

总览见 [[topics/papers/代码世界模型与神经渲染/1-05_2609.26458_CoDeR.pdf#page=5|图 2（第 5 页）]]。

### 五个角色（§3.1）

| 角色 | 由谁实现 | 职责 |
|---|---|---|
| God of Concepts | 用户 | 用文字或图片描述想要的世界；系统只做格式对齐，不经过提示词增强器，直接交给 Creator |
| Creator | LLM（实验用 GPT-6 Astra） | 递归分解、细化意图，由一组各有职责的智能体分别定外观和运行机制；把规则、智能体内部状态、物理动力学这类"看不见的信息"一开始就写成世界状态的一部分，产出世界设计蓝图。作者称它是世界的"主脑" |
| Executors | 多模态 LLM 编码智能体（同样是 GPT-6 Astra） | 按蓝图写可执行代码，生成**白盒世界**（完全由代码构建的 3D 粗模 / blockout） |
| Artists | 视频生成模型（MiniMax-H3 微调） | 把白盒世界的一段观测"画"成细节丰富、风格多样（写实到动漫）的视频，同时保持 Creator / Executors 定下的结构和逻辑；画完交还 Executors 注册回世界 |
| Travelers | 可见实体或无形相机 | 在世界里漫游、交互，决定哪些区域需要 Artist 渲染 |

### 世界状态怎么用代码表示：逻辑空间（§3.2，式 3–5）

- 用 **Three.js** 搭白盒世界（轻量、可编程、可组合）；涉及人的场景用 **SMPL-H** 表示人体运动、手物交互和视角绑定（§4.1）。
- Creator 定好关键参数后，harness 把全局建造目标 g 分解成**逻辑空间图** G = (V, E)：每个节点是一个局部目标 g_i 加一份**接口契约** K_i（输入、输出、建造约束），契约里带着 Creator 定的共享规则，具体实现留给各 Executor。逻辑空间是**功能范围**，不一定是互不重叠的空间区域。
- 每个逻辑空间分给一个 Executor，产出模块 B_i（场景元素、可执行行为、对外接口）；依赖满足后各 Executor 可**并发**开发。例：交通系统 = 车辆设计 + 交通规则 + 路网布局，一个 Executor 端到端做太慢。
- 最后用显式的接口绑定（空间变换、状态映射、事件连接）把模块组成可执行世界 W。例：车的视觉几何和碰撞几何并行开发后绑到同一个车辆状态上；单独做的驾驶舱暴露一个"司机相机"接口，绑定到车辆位姿。
- 开放式交互：动作空间不预先固定，Creator 可以定义新动作（开门、弹钢琴、骑龙、开飞船），由 Executors 实现（§4.3）。

### 引擎导出什么条件信号

Artist 的输入是 V = Artist(W, D, P)（§3.2，第 6 页）：

| 输入 | 来源 |
|---|---|
| W：白盒视频（n 帧，或部分注册后的 R） | 沿 Traveler 轨迹在白盒世界里采样 |
| D：真值深度视频 | 直接由白盒世界导出 |
| P：提示词 | 由采样位置及周边实体的身份、属性（从世界状态直接查到）构造 |

- 专题清单把条件信号写成"Canny + 深度"。按正文，**推理时 Artist 吃的是白盒视频（或部分已上色的 R）+ 深度 + 提示词**；Canny 边缘出现在"Visual Cue Hacking"构造训练数据那一步（见下）。训练时 Artist 内部是否还有一个吃 Canny 的 ControlNet 分支，正文没说清，需核对（§4.2 说"ControlNet 分支全参微调"）。

### 外观一致与记忆：Observation as World Registration（§3.2，式 6）

- 思路：Artist 每画完一段，就把画面**注册回世界**，成为之后任何智能体看这块区域时观测的一部分。
- **部分注册**：给定之前生成的视频 V 及其真值深度 D，**随机抽一部分像素**反投影到白盒世界的表面，再从当前观测视角渲染，得到部分已上色的观测 R。只保留对应同一表面、通过深度可见性检查的投影，重叠处做混合：
  R = M ⊙ Π(V, D) + (1 − M) ⊙ W
  其中 M 是覆盖掩码。没看过的区域保持白盒样子，留给本次生成。
- 训练 Artist 从这种"部分注册"观测恢复完整上色视频，于是它学会沿用已注册的外观。
- 作者强调：Artist 只在固定 124 帧上下文训练，但靠注册机制拿到了"长时记忆"。
- 多智能体：因为外观和状态都在共享世界里，一个 Traveler 改变世界（打倒靶子），另一个 Traveler 的观测里同步可见（[[topics/papers/代码世界模型与神经渲染/1-05_2609.26458_CoDeR.pdf#page=9|图 6，第 9 页]]）。
- 世界演化：水龙头往杯里倒水，相机移开再回来，水位按代码继续上涨（[[topics/papers/代码世界模型与神经渲染/1-05_2609.26458_CoDeR.pdf#page=8|图 5，第 8 页]]）。这一点靠的是代码状态，不是渲染器。

### 渲染器骨干、训练与条件注入（§4.2）

| 项目 | 设置 |
|---|---|
| 骨干 | MiniMax H3（开源视频生成模型） |
| 为什么要调 | 原生 H3 能把白盒视频重渲成彩色，但偏"渲染风"：硬边、纹理单调、光照平；也没法直接适配世界注册 |
| 数据构造（Visual Cue Hacking） | 在白盒世界里随机采轨迹 → 得到白盒视频 W 和提示词 P → 从 W 提 Canny 边缘，深度直接用 D → 把这些线索喂给 **ControlNet** 生成多种风格的视频 V，当作训练目标；训练元组是 (W 或 R, D, P, V) |
| 训练参数 | Transformer 骨干 **LoRA**；**ControlNet 分支全参微调** |
| 规模 | 32 张 NVIDIA A800，全局 batch 16，**200 步**，AdamW，学习率 1e-5 |
| 分辨率 / 长度 | 1280×704，124 帧 |
| 长视频 | 按块生成、自回归拼接；没有专门的长视频后训练 |
| 实时 / 流式 | 论文**没有**报告速度、延迟、蒸馏步数，不是实时系统 |

- 附录图 8（第 21 页）的解释：直接以白盒渲染为条件，模型会紧跟白盒的低层几何，出硬边；Visual Cue Hacking 让模型把白盒视频当"结构线索"而不是像素级目标。
- 喂 ControlNet 的基础生成模型是哪个、训练集有多少条轨迹 / 场景，论文没写（需核对）。

## 实验与关键数字

### WorldScore 定量对比（[[topics/papers/代码世界模型与神经渲染/1-05_2609.26458_CoDeR.pdf#page=9|表 1，第 9 页]]）

| 方法 | Camera Ctrl | Object Ctrl | Content Align | 3D Consist | Photo Consist | Style Consist | Subjective Qual | Motion Acc | Motion Mag | Motion Smooth | 平均 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| ABot-World | 92.47 | 84.23 | 76.94 | 80.60 | 83.56 | 83.22 | 39.95 | 50.33 | 26.89 | 74.21 | 69.24 |
| Matrix-Game 3.0 | 96.72 | 84.61 | 83.12 | 81.10 | 86.96 | 83.42 | 59.04 | 60.79 | 24.75 | 81.50 | 74.20 |
| LingBot-World | 90.50 | 87.73 | 75.29 | 86.28 | 90.03 | 85.39 | 65.71 | 59.48 | 27.93 | 79.60 | 74.79 |
| **CoDeR** | **98.91** | **92.25** | **98.44** | **88.65** | **91.10** | **89.40** | **69.08** | **82.76** | **84.92** | **83.31** | **87.88** |

- 我按表重算了四行的平均，都与表中"Average"一致（69.24 / 74.20 / 74.79 / 87.88）。
- 差距最大的是 Motion Mag（84.92 vs 25–28）和 Content Align（98.44 vs 75–83）。
- 评测方式（附录"Evaluation Details"，[[topics/papers/代码世界模型与神经渲染/1-05_2609.26458_CoDeR.pdf#page=21|图 9，第 21 页]]）：CoDeR 不能直接吃基准的输入格式，所以先用 SAM 3 分割首帧、Depth Anything V2 估深度，把首帧 + 分割 + 深度交给 GPT-6 Astra 重建白盒世界，再在里面采视频；生成时仍以原始首帧为条件"锚定"外观。作者承认重建的白盒和首帧不必完全对齐。

### 消融（[[topics/papers/代码世界模型与神经渲染/1-05_2609.26458_CoDeR.pdf#page=9|表 2，第 9 页]]）

| 变体 | Content Align | Photo Consist | Subjective Qual | Imaging Quality | Aesthetic Quality | Subject Consistency | Dynamic Degree |
|---|---|---|---|---|---|---|---|
| 去掉 Visual Cue Hacking | 82.48 | 89.21 | 49.05 | 63.52 | 66.18 | 87.54 | 97.29 |
| 去掉 Observation as World Registration | 89.06 | 84.85 | 53.98 | 69.37 | 70.44 | 84.63 | 98.02 |
| 完整方法 | **98.44** | **91.10** | **69.08** | **70.77** | **72.29** | **96.31** | **98.16** |

前三列来自 WorldScore，后四列来自 VBench。完整方法的前三列与表 1 一致。

### 用户研究（附录，[[topics/papers/代码世界模型与神经渲染/1-05_2609.26458_CoDeR.pdf#page=20|图 7，第 20 页]]）

30 份有效问卷，0–100 打分（数字从柱状图标注读出）：

| 方法 | 视觉质量 | 交互一致性 | 记忆与持久性 | 世界演化 | 总体偏好 |
|---|---|---|---|---|---|
| Matrix-Game 3.0 | 78.30 | 66.40 | 72.45 | 28.80 | 61.20 |
| LingBot-World | 81.20 | 48.80 | 62.60 | 30.00 | 64.85 |
| EgoSim | 65.80 | 72.65 | 61.60 | 24.40 | 54.60 |
| LiveWorld | 69.75 | 46.80 | 66.60 | 82.85 | 59.55 |
| **CoDeR** | **84.40** | **92.75** | **81.60** | **87.25** | **88.20** |

### 定性对比（第 7–9 页）

- **记忆**（图 3）：360° 旋转看墙上的"Coding World System"字样。ABot-World 画质严重退化，Matrix-Game 3.0 丢了字样 / 建筑结构，LingBot-World 不跟控制信号、出现重复帧；CoDeR 闭环回到起点且几何和外观一致。
- **开放交互**（图 4）：弹钢琴、骑龙等代码定义的动作；对比 EgoSim，EgoSim 打不开门，CoDeR 开门后露出门后的新环境。
- **演化**（图 5）：HyDRA 水柱几乎静止；LiveWorld 有水的动态但有明显伪影，杯子出视野后水位没更新；CoDeR 回来时水位已上涨。
- **多智能体**（图 6）：两个 Agent 互相看到对方打倒靶子。

## 局限 / 存疑

- **作者自己承认的**（附录第 22–23 页）：
  - Artist 只在 124 帧窗口上训练，长视频靠分块自回归拼接，误差累积；**约 5,000 帧**处开始明显退化（图 10）。
  - 白盒建模的问题：复杂手物交互时手的姿态严重扭曲；几何或碰撞处理不完善会穿模（图 11）。
  - 未来想让 Artist 输出分解表示（Albedo、Normal、Roughness、Irradiance），让注册回世界的是结构化视觉状态而不是一整张 RGB（图 12）。
- **条件信号的说法要核对**：正文推理公式是 Artist(W, D, P)，Canny 只在构造训练数据时出现；但训练段又说"ControlNet 分支全参微调"，Artist 内部到底有没有吃 Canny / 深度的 ControlNet 分支、深度经哪条通路注入 H3，没有说清（需核对）。
- **训练目标来自另一个生成器**：训练用的"真值"视频 V 是 ControlNet 从 Canny + 深度合成的，Artist 学到的外观上限受这个合成器约束；基础模型是什么、数据量多少都没写。总共 200 步、batch 16，即只看过约 3,200 个样本，规模很小。
- **定量对比口径不同**：CoDeR 评测时先由 GPT-6 Astra 从首帧重建白盒世界，再由确定性引擎给出相机轨迹和深度，而基线直接吃首帧和动作。Camera Ctrl、3D Consist 这类指标天然偏向"有显式几何"的系统；Motion Mag 84.92 对 25–28 的巨大差距，可能来自代码里显式加的运动，评测用的是 WorldScore 的哪个子集、多少个样本也没写（需核对）。
- **消融只测画质**：表 2 没有测记忆、交互、演化，所以"世界注册带来长时记忆"只有图 3 的定性证据；逻辑空间分解和多 Executor 并行也没有消融。
- **没有速度数字**：没有生成延迟、显存、蒸馏，和专题里 AgentGarten、StreamRender-H3、Matrix-Game 4.0 这类实时系统不在同一个维度上。
- **GPT-6 Astra**：论文称其为"具有强 3D 空间感知的多模态 LLM 编码智能体"，没有引用或版本说明，外人无法复现这一环（需核对是哪家的模型）。
- **注册机制的边界**：外观贴在白盒表面上，对会动、会变形的物体或光照变化怎么处理（旧注册颜色何时失效），正文没讨论。后来的 [[topics/notes/代码世界模型与神经渲染/1-10_Mallea|Mallea]] 正是在这一点上补"按物体身份和状态决定外观是否还能复用"。
- **用户研究**：30 份问卷，不包括表 1 里的 ABot-World；评分方式（打分是否盲评、每人看几段）没有细节。
- **开源**：写着"代码和权重将公开"，目前状态需核对项目页。

## 与其他论文的关系

- **同一范式的起点**：[[topics/notes/代码世界模型与神经渲染/1-01_CodeWorldModel|CWM]]（2026-08，西湖大学）也用 MiniMax-H3 当渲染器、编码智能体写代码维护状态、代理视频（深度 + 语义 ID）做条件。CoDeR 的区别：把世界建造组织成多角色、多 Executor 的逻辑空间图；条件用白盒视频 + 深度；靠"观测注册回世界"做外观记忆。CoDeR 正文没有直接引用 CWM（引用的是 Magpie 和 "Video Models as Native 4D Renderers"），需核对两者时间线（CWM 首版早于 CoDeR 约一个月）。
- **同用 H3 的其他工作**：[[topics/notes/代码世界模型与神经渲染/1-12_StreamRender-H3|StreamRender-H3]]（语义图、两步流式、8×GB200 实时）、[[topics/notes/代码世界模型与神经渲染/2-09_SolarRenderer|SolarRenderer]]（冻结 H3 + LoRA 吃任意结构视频）、[[topics/notes/代码世界模型与神经渲染/1-15_GameWM|GameWM]]、[[topics/notes/代码世界模型与神经渲染/1-07_Oneira|Oneira]]（H3 Ref2VA + LoRA）。CoDeR 是其中唯一用"白盒视频本身 + 深度"做条件、并且没做任何加速的。
- **[[mirros/notes/01_AgentGarten|AgentGarten]]**：同样是"代码定状态、渲染器定外观"，但渲染器是 Cosmos 3-Nano 改成块因果并蒸馏到 4 步、H100 上实时；条件是上色深度 / 法线，外观一致靠参考图和视觉历史。CoDeR 在实时性上完全没做，但多了"世界注册"这种显式外观记忆。
- **白盒 / 粗模条件的渲染器**：[[topics/notes/代码世界模型与神经渲染/1-03_Magpie|Magpie]]（被 CoDeR 引用为相关工作，白盒渲染画面 → Wan2.2-5B，32 FPS）；[[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]] 用 UE5 低模/高模配对数据，走实时路线。
- **中间表示的对照**：[[topics/notes/代码世界模型与神经渲染/1-04_ProgrammableWorldModel|Programmable World Model]] 用状态增强的 3D 有向包围盒；[[topics/notes/代码世界模型与神经渲染/1-07_Oneira|Oneira]] 用按状态上色的 3D 框；CoDeR 直接用完整白盒几何 + 深度，条件更"满"。
- **外观记忆的后续**：[[topics/notes/代码世界模型与神经渲染/1-10_Mallea|Mallea]] 明确把 CoDeR 引为"把外观注册到世界表面"的先例，改为按物体身份存纹理、物体材质变了就作废；[[topics/notes/代码世界模型与神经渲染/1-07_Oneira|Oneira]] 则是检索记忆帧并按当前物体状态过滤。
- **多人 / 多视角**：[[topics/notes/代码世界模型与神经渲染/1-14_CoCode-World|CoCode-World]] 把两个玩家视角拼成一张画布联合生成，靠注意力保证跨视角一致；CoDeR 靠共享白盒世界和注册的外观实现多 Traveler 互见，但只有定性图。
- **评测**：[[topics/notes/代码世界模型与神经渲染/3-04_WorldDraft|WorldDraft]] 专门评"代码建世界、视频模型只渲染"能否保持世界与属性绑定，可用来补 CoDeR 缺的那部分验证。
- **离屏演化的纯视频方法**：LiveWorld（论文里的对比对象，参考文献只写 ECCV 2026，没给 arXiv 号）把渲染和全局状态分开；HyDRA（[Out of Sight but Not Out of Mind](https://arxiv.org/abs/2603.25716)）是混合记忆。CoDeR 的演化来自代码，自然不受视野限制。
- **基线**：[Matrix-Game 3.0](https://arxiv.org/abs/2604.08995)、[LingBot-World](https://arxiv.org/abs/2601.20540)、[ABot-World-0](https://arxiv.org/abs/2607.19191)、EgoSim。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文是 CC BY 4.0，这里仍只记位置和要点，原句请点页码看）
> 1. 第 1–2 页 §1：视频世界模型把状态隐式放在视觉历史里，难以持久记忆、建模离屏动态；冰箱里的水的例子 → 要解决的问题
> 2. 第 4 页 §3.1 "The Creator"：规则、智能体内部状态、物理动力学一开始就显式写进世界状态 → Creator 的作用
> 3. 第 4 页 §3.1 "Executors"：编码智能体生成白盒世界（完全由代码构建的 3D blockout）→ 世界状态的代码表示
> 4. 第 5–6 页 §3.2 式 3–5：逻辑空间图、接口契约、模块绑定与组合 → 多 Executor 分工
> 5. 第 6 页 §3.2 "Observation as World Registration"：V = Artist(W, D, P)；随机抽部分像素反投影、深度可见性检查、式 6 → 条件信号与外观记忆
> 6. 第 6 页 §4.1、第 7 页：Three.js、SMPL-H、GPT-6 Astra 同时担任 Creator 和 Executors → 实现
> 7. 第 7 页 §4.2：H3 原生输出偏渲染风；Canny + 深度喂 ControlNet 造训练目标；32×A800、batch 16、200 步、1e-5、1280×704、124 帧、LoRA + ControlNet 分支全参 → 渲染器训练
> 8. 第 9 页表 1、表 2 → 定量数字
> 9. 第 20–21 页附录 "Evaluation Details"：先用 SAM 3 + Depth Anything V2 + GPT-6 Astra 从首帧重建白盒世界再评测 → 评测口径存疑
> 10. 第 22 页附录 "Limitations"：124 帧窗口、分块拼接、约 5,000 帧开始退化；手物交互扭曲、穿模 → 局限

## 摘要（中文）

我们提出 CoDeR，一种新的世界建模范式。现有视频世界模型通过视觉观测隐式表示世界动态，而我们的系统用代码显式构建一个可执行的世界，并用视频生成模型做视觉实现。具体地，我们协调五个互补的角色，把高层概念转化为结构化的世界规则、可执行的动态和感知观测。这一设计支持长时记忆、开放式交互、世界自主演化和多智能体场景，多个实体可以在当前观测之外持续地行动、交互和演化。大量实验表明，我们的框架显著扩展了现有世界模型的能力，实现了长时记忆、开放式交互、自主演化和持久的多智能体动态，并在多种评测设置下达到最先进的性能。代码和模型权重将公开。

## 摘要（原文）

以下按 CC BY 4.0 许可转录自 arXiv 2609.26458（Fang et al., 2026）：

We introduce CoDeR, a new paradigm for world modeling. Unlike existing video world models that implicitly represent world dynamics through visual observations, our system explicitly constructs an executable world with code and employs video generation models for visual realization. Specifically, we coordinate five complementary roles to translate high-level concepts into structured world rules, executable dynamics, and perceptual observations. This design enables long-term memory, open-ended interactions, autonomous world evolution, and multi-agent scenarios, where multiple entities can act, interact, and evolve persistently beyond the current observation. Extensive experiments demonstrate that our framework substantially extends the capabilities of existing world models, enabling long-term memory, open-ended interactions, autonomous evolution, and persistent multi-agent dynamics, while achieving state-of-the-art performance across multiple evaluation settings. Code and model weights will be made publicly available.
