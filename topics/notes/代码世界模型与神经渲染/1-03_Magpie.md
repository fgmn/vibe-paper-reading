---
id: "1-03"
org: 专题·代码世界模型与神经渲染
short: "Magpie"
title: "Magpie: Real-Time World Renderer for Interactive Games"
aliases: ["Magpie"]
date: 2026-08-27
category: "代码世界 + 视频渲染器（完整系统）"
venue: —
affiliation: "Mogo AI Ltd. · 南京大学 · 南安普顿大学"
authors: ["Xiaoyu Zhan", "Xinyu Wang", "Xiaohong Zhang", "Huanjie Zhu", "Tengjiao Sun", "Pengcheng Fang", "Jiaxing Yu", "Yanwen Guo", "Dongjie Fu"]
arxiv: "2608.27168"
pdf: "[[topics/papers/代码世界模型与神经渲染/1-03_2608.27168_Magpie.pdf]]"
code: ""
project: "https://zhanxy.xyz/Magpie-website"
license: CC BY 4.0（arXiv 摘要页）
status: 未读
rating:
read_date:
tags: ["paper", "world-model", "neural-rendering", "game-engine", "white-box", "real-time", "autoregressive-video", "wan2.2"]
---

# Magpie: Real-Time World Renderer for Interactive Games

> [!info] 论文信息
> arXiv [2608.27168](https://arxiv.org/abs/2608.27168) · 只有 v1（2026-08-27）· AAAI 风格双栏排版，没写投稿去向
> 单位：Mogo AI Ltd.（主）、南京大学、南安普顿大学 · 共同一作：Xiaoyu Zhan、Xinyu Wang、Xiaohong Zhang、Huanjie Zhu · 通讯作者：Dongjie Fu（Mogo AI）
> PDF：[[topics/papers/代码世界模型与神经渲染/1-03_2608.27168_Magpie.pdf|本地 PDF]]（14 页：正文第 1–12 页，参考文献第 12–14 页，没有附录）
> 项目页：[zhanxy.xyz/Magpie-website](https://zhanxy.xyz/Magpie-website) · 论文里没有给代码仓库；据 Matrix-Game 4.0 表 3（2026-10-19 查），只放出了"Lite"版的渲染 / 白盒配对视频数据集，代码和权重未开源
> 专题：[[topics/代码世界模型与神经渲染#一、代码世界 + 视频渲染器（完整系统）|代码世界模型与神经渲染 · 一、代码世界 + 视频渲染器（完整系统）]]

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-18）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。

## 一句话总结

一篇偏**系统设计**的报告：设计者在 Unreal Engine 里搭"白盒"（灰模、无材质）场景并写规则，**游戏引擎**处理玩家输入、维护全部状态，再把白盒画面和相机位姿交给独立的 **Render Server**；Render Server 上的 Wan2.2-TI2V-5B 自回归渲染器只在初始化时看一次文字 + 首帧风格图，之后**唯一持续的去噪条件就是白盒画面**（经交叉注意力注入），相机位姿只用来按视野重叠检索历史帧。玩家动作、状态变量、物体属性、事件**一律不进渲染器**。训练数据是人工在 30 多个 UE 场景里玩出来的约 300 小时高保真 / 白盒配对视频。部署沿用 Helios 的金字塔式 3 步蒸馏 + LightTAE + FP8：单张 H100 上 1280×768，每块 5 个潜帧（20 帧）约 620 ms，计算侧 32.2 FPS，峰值显存 34 GB；但因为引擎要先录满 20 帧白盒（24 FPS 下 0.83 s）才开始渲染，**按键到看到画面约 1.55 s**。全文**没有任何定量画质指标**。

## 要解决什么问题

- 游戏开发里，高质量画面要建模、材质、绑定、动画、灯光、特效、性能优化一整条资产管线，原型阶段成本高；而游戏真正的核心价值在玩法设计。
- 视频基础模型画面好、换风格的边际成本低，但**游戏不是线性视频**：同样的动作和状态在既定规则下要有稳定含义，机制才能被测试、调整和复现。碰撞体积、通行权限、冷却、隐藏触发器、进度标志这类东西在画面里几乎看不出来，靠视频模型从像素里"推"不可靠。
- 纯视频交互世界模型（Matrix-Game 2.0 / 3.0、WorldCam、LingBot-World 2.0、DreamX-World 等）用键盘或文字控制，**不能保证遵守设计者写好的规则**。
- 作者的划分：**引擎决定发生了什么，渲染器决定怎么呈现**。渲染出错只会降低反馈的清晰度，不会改变碰撞、进度或之后的玩法判断。目标用户是做原型的开发者：白盒场景在资产完工前就能看到接近目标的画面。

## 方法

### 系统分工（§3、§5，[[topics/papers/代码世界模型与神经渲染/1-03_2608.27168_Magpie.pdf#page=4|图 2，第 4 页]]）

| 组件 | 负责什么 | 发给谁、发什么 |
|---|---|---|
| Gameplay Design | 设计者在引擎里定义布局、可通行区域、交互规则与物体、物理参数、触发器、事件逻辑，设定初始状态 | 只改可执行场景，设计元数据**不直接发给** Render Server |
| User Client | 显示视频流，采集键鼠 / 手柄输入并打时间戳 | 输入只发给 Game Engine，不改本地状态，也不发给 Render Server |
| Game Engine | 执行规则、推进状态，解算移动、碰撞、交互、事件和相机，再渲出白盒画面 | 每个生成块只发两样：**白盒画面 + 相机位姿** |
| Render Server | 管理渲染器生命周期：初始化时收文字 + 首帧图；之后每块注入白盒、用位姿检索历史 | 生成视频流回 User Client，不做任何玩法判断 |

- 组件间通信用 **WebRTC**；作者把 jitter buffer 调成"新鲜优先"：网络抖动时宁可丢旧帧、降帧率，也不排队延迟后续帧。
- 用"显式消息边界"防止玩法状态绕过引擎、以未声明的条件信号进入生成模型。
- 一次交互循环的因果顺序（§5.5）：客户端采到动作 → 引擎解算后果、渲出白盒和位姿 → Render Server 生成这一段画面。渲染器拿到的是**已经被规则决定好的可见结果**，不预测也不改写规则层的结果。当前实现只在**块边界**交换。
- 世界状态怎么"用代码表示"：这里**没有编码智能体**，状态和规则就是设计者在 UE 里手工搭的蓝图 / 场景逻辑。论文没写运行时用的是不是同一个 UE 工程（数据采集明确是 UE，运行时只说"Game Engine"，需核对）。

### 数据引擎（§4，[[topics/papers/代码世界模型与神经渲染/1-03_2608.27168_Magpie.pdf#page=6|图 3，第 6 页]]）

| 项目 | 内容 |
|---|---|
| 规模 | 约 **300 小时**、**30+ 个** UE 场景的人工游玩配对视频 |
| 格式 | 每段 1920×1080、60 FPS；单段从几十分钟到几小时 |
| 谁来玩 | 训练过的操作员，像真实玩家那样玩，刻意反复走难视角、交互边界、过渡和发呆时段；不用脚本或自主智能体 |
| 配对方式 | 每个场景有高保真版和白盒版，二者空间占位、碰撞边界、主要轮廓、交互功能一致；共享时间线、角色状态、相机，逐帧同视角同时间录 |
| 白盒保留什么 | 可见几何、布局、遮挡、主要运动；去掉最终纹理、材质、复杂光照和非必要几何细节 |
| 动作覆盖 | 走、跑、跳、攀爬、转视角、驾驶、坐下；碰墙 / 地面、上下楼梯、车辆运动变化、阻挡、滑动、姿态变化 |
| 刻意保留"不动" | 站立、小幅转镜头、只有环境在动的片段，防止自回归渲染器偏向多余运动或静止场景不稳 |
| 没覆盖 | 复杂战斗、多角色协作、密集物体操作 |
| 结构化记录 | 相机位姿、操作员输入、碰撞、状态转移、事件，同一时间戳；**当前只用相机位姿**（检索历史），其余字段不进训练目标也不进条件接口 |
| 文字标注 | 用 Qwen3.6-27B 从高保真画面自动生成两个字段：场景风格、角色外观；固定提示词明确排除玩法语义（不描述机制、规则、动作、事件结果） |

### 渲染器（§6，[[topics/papers/代码世界模型与神经渲染/1-03_2608.27168_Magpie.pdf#page=7|图 4，第 7 页]]）

| 项目 | 做法 |
|---|---|
| 骨干 | **Wan2.2-TI2V-5B** |
| 长视频框架 | 沿用 **Helios** 的有界多尺度上下文、层级（金字塔）生成和多阶段蒸馏 |
| 初始化条件 | 文字 c + 首帧风格图 r，只编码一次：s0 = E(c, r)，确定场景风格、角色外观和初始画面 |
| 持续条件 | 每个生成块（5 个潜帧）的白盒画面 g_t，**全程注入去噪**，是唯一持续的外部条件 |
| 注入方式 | 比较了三种（[[topics/papers/代码世界模型与神经渲染/1-03_2608.27168_Magpie.pdf#page=8|第 8 页]]）：① 直接嵌进噪声潜变量——结构贴合最强、最便宜，但压掉细节、画质明显下降；② AdaLN 调制——块内有效，但**块边界明显不连续**；③ 把编码后的白盒放进历史条件序列、经**交叉注意力**进入去噪网络——画质和结构一致性折中最好，采用 ③ |
| 去噪函数 | ε_θ = D_θ(z_τ, τ \| g_t, h_t, s0)；动作、状态、属性、事件都不在里面，只能间接影响（改变白盒画面，或通过位姿改变检索到的历史） |
| 蒸馏 | 多步教师 → **3 步**学生（金字塔式），再用 Self Forcing 缩小"干净视频训练 / 自生成上下文推理"的差距 |
| 部署 | LightTAE 替换原时空自编码器（块边界反复编解码，直接影响延迟）；骨干 FP8 混合精度（线性层、注意力、FFN 低精度，归一化、时间嵌入等敏感算子保持高精度） |

- **训练细节基本没给**：学习率、步数、GPU 数、用了多少小时数据、Helios 那套多阶段蒸馏各阶段的具体设置都没写（需核对）。
- 白盒条件是一张 **RGB 灰模渲染图**，没有深度、法线、语义（作者在局限里承认这会带来深度歧义）。

### 记忆：三段式历史上下文（§6.2）

h_t = [h^anchor, h^relevant_t, h^recent_t]，按固定顺序拼：

1. **早期锚块**：会话开头的几块，保住首帧确立的外观和场景身份，减少长时漂移。
2. **检索历史**：照 Context-as-Memory，用相机位置、朝向、视锥算**视野重叠**，取出与当前视角相关的历史帧。位姿只用于索引，**不当去噪条件**。
3. **最近生成块**：保持局部运动和相邻块连续，旧块被逐出，上下文有上界。

作者在局限里承认这是有界的**二维历史**，没有显式持久的三维表示，大幅转视角或长时间离开后外观会漂移。

### 流式与实时（§6.4、§7）

- 每次推理的固定流程：编码一块白盒视频 → 拼有界历史 → 去噪一块 → 解码。编解码都一次只做一块，开销不随会话变长。
- **块间桥接解码**（§7.1）：Wan 解码器在时间上是因果的，当前块的解码依赖前面的时间上下文，直接把相邻块当独立输入不行；所以在相邻块之间加一个 bridge 提供边界处的因果上下文，保持固定的逐块解码。
- 每块 5 个潜帧：**首块解码出 17 帧，之后每块 20 帧**。

## 实验与关键数字

### 稳态推理（[[topics/papers/代码世界模型与神经渲染/1-03_2608.27168_Magpie.pdf#page=9|表 1，第 9 页]]）

| 配置 | 值 |
|---|---|
| 模型 | 5B（蒸馏后） |
| GPU | 1× NVIDIA H100 |
| 推理方式 | 逐块自回归，逐块解码 + 桥接 |
| 分辨率 | 1280×768 |
| 每块潜帧 | 5 |
| 首块 / 后续块输出 | 17 帧 / 20 帧 |
| 稳态每块预测时间 | 620 ms |
| 计算侧吞吐 | 32.2 FPS（= 20 帧 / 0.62 s，预热后，首块不计） |
| 峰值显存 | 34 GB |

### 端到端延迟（[[topics/papers/代码世界模型与神经渲染/1-03_2608.27168_Magpie.pdf#page=10|表 2，第 10 页]]；[[topics/papers/代码世界模型与神经渲染/1-03_2608.27168_Magpie.pdf#page=8|图 5，第 8 页]]）

| 环节 | 时间 |
|---|---|
| 引擎录制一块白盒（20 帧 @ 24 FPS） | 0.83 s |
| 网络传输 + 编码 | ≈0.1 s |
| Render Server 推理 + 解码 | 0.62 s |
| **端到端响应** | **≈1.55 s** |

- 交互管线按 **24 FPS** 播放；32.2 FPS 的计算吞吐高于 24 FPS，所以稳态能跟上播放，但首个和动作对齐的画面要等约 1.55 s，之后每块在约 830 ms 内播完。
- 瓶颈不在模型而在"**先录满一整块白盒再开始渲染**"：0.83 s 占了一半以上。

### 定性结果（§7.4，图 6、图 7）

- [[topics/papers/代码世界模型与神经渲染/1-03_2608.27168_Magpie.pdf#page=10|图 6]] 是基础自回归模型，[[topics/papers/代码世界模型与神经渲染/1-03_2608.27168_Magpie.pdf#page=11|图 7]] 是蒸馏后的实时模型，都是 1280×768 的白盒 / 生成对照。
- 作者说渲染器评估应看三点：长时记忆、与白盒条件的一致性、整体画质——但**三点都没有给数字**，也没和任何基线比较，三种条件注入方式的比较也只有文字描述。

## 局限 / 存疑

作者在 §8 承认的：

- **延迟**：引擎要先录完整块白盒，"约 1.6 s"对需要即时反馈的交互太高；需要逐帧流式架构，让引擎执行、条件编码、生成、显示重叠起来。
- **白盒的深度歧义**：单张 RGB 白盒对度量深度、表面朝向、细结构、颜色相近区域的前后关系有歧义，生成结果可能二维看着对、几何却错；建议补充引擎导出的深度、法线、分割、运动矢量等。
- **不完全遵循白盒**：快速运动、大视角变化、遮挡、复杂交互或训练分布外场景下，几何、角色位置、物体边界会偏离引擎观测。
- **高保真外观监督不够**：配对数据的目标画面覆盖不了真实世界材质、光照、天气、人体运动的多样性；以后要混真实视频和离线高质量渲染，但它们没有对齐的白盒，需要额外渲染、伪标注或分阶段训练。
- **没有音频**。
- **没有持久三维视觉记忆**（见上文"记忆"）。
- **推理贵**：5B 蒸馏模型仍要数据中心 GPU、34 GB 显存，端侧部署不现实。
- **帧率和画质**：作者自己说 32.2 FPS 仍达不到游戏要求；少步生成、低精度、有界上下文、数据覆盖有限会带来闪烁、纹理退化、身份漂移、与引擎可见细节不一致。

读的时候值得核对的：

- **延迟数字前后不一**：§7.3 和表 2 是 ≈1.55 s，§8 写"约 1.6 s"（需核对，可能只是取整）。
- **"实时"的口径**：标题叫 Real-Time，但实际播放是 24 FPS、按键到画面 1.55 s；32.2 FPS 是预热后的纯计算吞吐，不含引擎和传输。专题清单里写的"32 FPS"应理解为计算侧吞吐。
- **没有任何定量评测**：没有 FVD / FID、没有从生成画面反推结构与白盒的一致性误差、没有长时漂移指标、没有消融（三种注入方式、记忆三段、蒸馏前后）的数字，也没有和 AlayaRenderer-Flash、Cosmos-Transfer 等结构条件渲染器比较。
- **交叉注意力注入的具体形式说得含糊**：原文说把编码后的白盒"放进历史条件序列"并"通过交叉注意力"进入去噪网络。放进历史序列听起来像自注意力里的上下文 token，交叉注意力又是另一条通路，到底是哪种、白盒 token 有没有和噪声潜变量做空间对齐，需核对（没有代码可查）。
- **分辨率**：采集是 1920×1080（16:9），输出是 1280×768（5:3），中间怎么裁剪 / 缩放没说。
- **"首块 17 帧、后续 20 帧"**：5 个潜帧在 Wan2.2 VAE（时间压 4 倍）下首块 1+4×4=17 帧说得通，后续块 20 帧依赖桥接解码，但桥接具体怎么做没写。
- **训练配方缺失**：骨干是 Wan2.2-TI2V-5B，又说沿用 Helios 的多尺度上下文和层级生成；Helios 原本是怎样的模型、Magpie 是从 Wan2.2 直接按 Helios 方法训练，还是从 Helios 权重出发，正文没交代（需核对）。
- **记录了但没用的信号**：操作员输入、碰撞、状态转移、事件都录了却不用。这是作者有意的"受限接口"设计，但也意味着白盒里看不出来的事件（比如受伤、拾取）渲染器无从得知，只能靠白盒上的可见变化。
- **开源情况**：论文里没提代码 / 权重 / 数据是否开放；专题清单里的"只有 Lite 数据集"来自 Matrix-Game 4.0 表 3 的核对，不是本文自述。

## 与其他论文的关系

- **同一分工、但没有编码智能体**：本专题第一节的大部分工作（[[topics/notes/代码世界模型与神经渲染/1-01_CodeWorldModel|CWM]]、[[topics/notes/代码世界模型与神经渲染/1-04_ProgrammableWorldModel|Programmable World Model]]、[[topics/notes/代码世界模型与神经渲染/1-05_CoDeR|CoDeR]]、[[topics/notes/代码世界模型与神经渲染/1-07_Oneira|Oneira]]、[[topics/notes/代码世界模型与神经渲染/1-10_Mallea|Mallea]]、[[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]]）都让编码智能体写世界或改规则；Magpie 的世界和规则是**设计者在 UE 里手工搭的**，定位是"给游戏开发者的原型渲染层"。严格说它属于"引擎状态 + 神经渲染"，和 [[mirros/notes/01_AgentGarten|AgentGarten]] 提到的 NVIDIA OmniDreams、GameDirector 同一类（AgentGarten 正是把 Magpie 归在"状态由引擎推进"的一组）。
- **和 [[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]] 最像**：都是 UE 采集的低模 / 高保真配对数据（Magpie 约 300 小时、30+ 场景；Matrix-Game 4.0 1712 小时、4 个场景），都用 Wan2.2 5B（Magpie 用 TI2V-5B，Matrix-Game 用 Fun-5B-Control），都按相机位姿检索空间记忆帧。差别：
  - 条件注入：Magpie 交叉注意力；Matrix-Game 4.0 是**通道拼接**（Fun Control 原生方式）。Magpie 说直接嵌进噪声潜变量会损画质，Matrix-Game 恰好走了这条路，可以对照看。
  - 语义条件：Magpie 只有初始化时一次文字；Matrix-Game 4.0 每帧有由引擎状态生成的**动态字幕**。
  - 速度：Matrix-Game 4.0 每块只有 1 个潜帧（4 帧）、1–2 步，按键到画面 112 ms；Magpie 每块 5 个潜帧（20 帧）、3 步，1.55 s。Matrix-Game 4.0 表 3 正是拿 Magpie 当对照之一。
- **条件信号的谱系**（专题"一句话脉络"第 3 条）：Magpie 的灰模 RGB 白盒和 Matrix-Game 4.0 的低模代理同属"粗渲染画面"一档，比 [[mirros/notes/01_AgentGarten|AgentGarten]] 的深度 / 法线、StreamRender-H3 的语义图信息更"像图"，但没有显式几何；作者自己在局限里建议加深度。
- **结构条件渲染器**（专题第二节）：Magpie 相关工作里点名了 DiffusionRenderer、[Generative World Renderer](https://arxiv.org/abs/2604.02329)（G-buffer）和 [Coarse-to-Real](https://arxiv.org/abs/2601.22301)（粗仿真 → 真实视频），并说自己是把"粗结构 → 逼真视频"推进到闭环交互。[[topics/notes/代码世界模型与神经渲染/2-06_AlayaRenderer-Flash|AlayaRenderer-Flash]] 在单张 H200 上做到 31.54 FPS，吞吐与 Magpie 的 32.2 FPS 相当，但条件是 5 通道 G-buffer。
- **渲染器的技术来源**：[Helios](https://arxiv.org/abs/2603.04379)（有界多尺度上下文、金字塔生成、多阶段蒸馏）、[Self Forcing](https://arxiv.org/abs/2506.08009)、[Context-as-Memory](https://arxiv.org/abs/2506.03141)（视野重叠检索）、LightTAE（LightX2V）。
- **被引用**：[[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]] 表 3 收录了 Magpie（≈1.55 s、1280×768、1× H100、峰值约 34 GB）；[[topics/notes/代码世界模型与神经渲染/1-15_GameWM|GameWM]] 和 [[topics/notes/代码世界模型与神经渲染/3-04_WorldDraft|WorldDraft]] 讨论"引擎管状态、视频模型只渲染"时可对照。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文是 CC BY 4.0，这里附了少量原句）
> 1. 第 1 页摘要："Player actions, state variables, object properties, and event signals remain in the Game Engine and will not be passed directly to the Render Server." → 受限接口：状态不进渲染器
> 2. 第 2 页 §1 第 3 段：碰撞体积、通行权限、冷却、隐藏触发器、进度标志在画面里几乎没有可靠证据 → 为什么状态要留在引擎
> 3. 第 4–5 页 §3 末段：渲染错误只影响反馈质量，不会改变碰撞逻辑、进度和后续玩法 → 分工的好处
> 4. 第 5 页 §4.1："approximately 300 hours of human-operated interactive paired videos from 30+ Unreal scenes"，1920×1080、60 FPS → 数据规模
> 5. 第 5 页 §4.4：操作员输入、碰撞、状态转移、事件都录了，但当前只用相机位姿做检索 → 记录了但没用的信号
> 6. 第 7 页 §6：骨干 Wan2.2-TI2V-5B，沿用 Helios 的多尺度上下文、层级生成和少步蒸馏 → 渲染器来源
> 7. 第 8 页 §6.1：直接嵌入噪声潜变量损画质、AdaLN 在块边界不连续、交叉注意力折中最好 → 条件注入方式
> 8. 第 8 页 §6.2：锚块 + 视野重叠检索历史 + 最近块，位姿只用于索引 → 记忆机制
> 9. 第 9–10 页表 1、表 2：620 ms/块、32.2 FPS、34 GB；0.83 + 0.1 + 0.62 ≈ 1.55 s → 速度与延迟
> 10. 第 10–12 页 §8：延迟"approximately 1.6 s"、深度歧义、不完全遵循白盒、无三维记忆、"32.2 FPS still unable to meet the requirements of the games" → 局限与数字不一致

## 摘要（中文）

现代游戏开发高度依赖传统图形管线。高质量画面需要建模、材质制作、动画、光照、特效和运行时优化，使资产生产昂贵，也拉长了游戏原型的开发周期。近来视频基础模型开始改变影视和视频制作，但游戏不同于线性媒体：它不仅需要连续逼真的画面，还需要稳定、可复现的玩法规则、物体状态和交互结果。我们提出 Magpie，一个面向交互式游戏的实时生成式世界渲染系统。Magpie 把玩法执行和视觉生成分开：设计者在游戏引擎中定义场景和规则；运行时，游戏引擎解算玩家动作并维护世界状态，独立的 Render Server 则根据引擎产出的白盒画面生成视觉输出。Render Server 只在初始化时接收一段指定视觉风格的文字提示和一张首帧图像；之后的交互中，白盒画面作为持续的去噪条件，相机位姿用于检索与当前视角相关的历史帧。玩家动作、状态变量、物体属性和事件信号都留在游戏引擎中，不会直接传给 Render Server。因此生成模型负责视觉呈现，游戏引擎继续执行玩法规则、控制状态。为训练 Magpie，我们在 Unreal Engine 场景中人工采集了约 300 小时的交互视频，覆盖基本移动、视角变化、驾驶、坐下、碰撞交互和静止状态，并同步记录高保真渲染、白盒渲染、相机位姿和结构化交互记录。Magpie 为把生成模型用于实时游戏渲染提供了一条系统层面的实现路径，保留了玩法的可设计性和可复现性，并减少早期游戏原型对完整视觉资产的依赖。

## 摘要（原文）

论文采用 [CC BY 4.0](http://creativecommons.org/licenses/by/4.0/) 许可，以下转录自 [arXiv 摘要页](https://arxiv.org/abs/2608.27168)（作者：Xiaoyu Zhan 等）。

> Modern game development relies heavily on conventional graphics pipelines. High-quality visual content requires modeling, material authoring, animation, lighting, effects, and runtime optimization, making asset production expensive and extending the development cycle of game prototypes. Recently, video foundation models are beginning to change film and video production, but games differ from linear media, they require not only continuous and realistic imagery, but also stable and reproducible gameplay rules, object states, and interaction outcomes. We present Magpie, a real-time generative world-rendering system for interactive games. Magpie separates gameplay execution from visual generation. Designers define scenes and rules in a game engine. At runtime, the Game Engine resolves player actions and maintains world state, while an independent Render Server generates visual output from white-box frames produced by the engine. Magpie provides a system-level implementation path for applying generative models to real-time game rendering. It preserves gameplay designability and reproducibility, and reduces the dependence of early game prototypes on complete visual assets.

（注：arXiv 摘要页上的摘要比 PDF 第 1–2 页的摘要短，PDF 版还多了初始化条件、受限接口和 300 小时数据的几句，上面的中文译文按 PDF 版翻译。）
