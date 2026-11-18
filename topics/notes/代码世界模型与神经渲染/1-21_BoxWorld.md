---
id: "1-21"
org: 专题·代码世界模型与神经渲染
short: "BoxWorld"
title: "BoxWorld: Let World Engines Control and Video Generators Render"
aliases: ["BoxWorld", "Box World Engine", "Box-State Generative Renderer", "PairedStateBench"]
date: 2026-10-26
category: "代码世界 + 视频渲染器（完整系统）"
venue: —
affiliation: "英属哥伦比亚大学（UBC）· 华为加拿大 · Vector 研究所"
authors: ["Zike Wu", "Ahmed Hatem", "Chintan Trivedi", "Wallace Michel Pinto Lira", "Xuebin Qin", "Lele Wang", "Renjie Liao"]
arxiv: "2610.36371"
pdf: "[[topics/papers/代码世界模型与神经渲染/1-21_2610.36371_BoxWorld.pdf]]"
code: —
project: "https://boxworld-web.github.io"
license: CC BY 4.0（arXiv 摘要页）
status: 未读
rating:
read_date:
tags: ["paper", "world-model", "code-world", "coding-agent", "neural-rendering", "layout-to-video", "bounding-box", "streaming", "self-forcing", "longlive", "benchmark"]
---

# BoxWorld: Let World Engines Control and Video Generators Render

> [!info] 论文信息
> arXiv [2610.36371](https://arxiv.org/abs/2610.36371) · 本地 PDF 是 v1（2026-10-26，目前也只有 v1）· 版式没写投稿会议
> 单位：UBC（Zike Wu、Ahmed Hatem、Lele Wang、Renjie Liao）、华为加拿大（Ahmed Hatem、Chintan Trivedi、Wallace Michel Pinto Lira、Xuebin Qin）、Vector 研究所（Zike Wu、Renjie Liao）；Renjie Liao 另标 Canada CIFAR AI Chair · 论文没标共同一作和通讯作者
> PDF：[[topics/papers/代码世界模型与神经渲染/1-21_2610.36371_BoxWorld.pdf|本地 PDF]]（27 页：正文 9 页 + 参考文献第 10–17 页 + 附录 A–D 第 18–27 页）
> 项目页：[boxworld-web.github.io](https://boxworld-web.github.io)（PDF 里没有代码仓库链接；附录只说"将发布基准案例和评测代码"）
> 专题：[[topics/代码世界模型与神经渲染#一、代码世界 + 视频渲染器（完整系统）|代码世界模型与神经渲染 · 一、代码世界 + 视频渲染器（完整系统）]]（在该节末尾"补充"表里）

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-18）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。
> 本地环境没有 poppler，PDF 是用 macOS PDFKit 抽成文字读完正文和附录的；表 1 另渲染成 PNG 对照过。**图（图 1–10）只看了图注和抽出来的图内文字，没看图像本身**。

## 一句话总结

用户用自然语言写规则（"浇过水花才开""拿到钥匙门才开"），编码智能体（Kimi K2.5）照共享模板写出一个**Box World Engine**——一个轻量状态机，按规则推进实体和全局变量，每步把世界投影成**以物体为中心的状态接口**：每个物体一个 **2D 布局框 + 持久属性文字（身份、外观）+ 动态状态文字（当前在做什么、处于什么状态）**，写进状态缓冲区；渲染器异步读最新状态，**逐帧掩码交叉注意力**（每个视觉 token 只看覆盖它的框的状态 token）注入到 **LongLive**（Wan2.1 蒸馏出的少步自回归视频模型）里，4 步、832×480、20.7 FPS 流式出画面。渲染器分三阶段训练：开放域视频上用 Diffusion Forcing 学"框 ↔ 物体"、游戏录像上用 teacher forcing + LoRA 学状态切换、最后在自己的 rollout 上做 Self-Forcing 式 DMD 蒸馏；状态标注全部由现成感知模型自动得到，不需要动作配对数据。在自建的 **PairedStateBench**（87 例、37 对分支）上，成对两分支都对的比例 **97.3%**，LingBot-v1/v2 即使把结局写成文字给它们（oracle）也只有 16.2%；多阶段任务完成率 83.9% 对至多 25.3%。

## 要解决什么问题

- 目标是**实时、用户可定义行为**的交互视频世界：世界要追踪物体状态、应用交互规则，并在用户行动时渲出后果（[[topics/papers/代码世界模型与神经渲染/1-21_2610.36371_BoxWorld.pdf#page=1|图 1，第 1 页]]）。
- 两条已有路线各有短板（[[topics/papers/代码世界模型与神经渲染/1-21_2610.36371_BoxWorld.pdf#page=3|图 2，第 3 页]]）：
  - **隐式状态**（Genie、LingBot-World 一类端到端模型）：泛化好，但生成器要同时判断规则是否满足、该发生什么、怎么画，物体级规则很难指定和控制。
  - **稠密状态**（轨迹、布局、物理先验、3D 缓存、完整仿真器）：控制细，但越细越重、越依赖领域，造起来和仿真起来都贵，也难从视频里大规模获得。
- 作者的取法：规则在生成器外面显式执行，生成器只负责把结果画出来；两边之间用一个**"显式但最小"**的接口，只暴露物体级交互需要的变量，而且这些变量能用现成感知模型从视频里识别出来，这样训练渲染器不必依赖仿真器或稀缺的动作配对数据。
- 渲染这条状态流的三个难点：状态是在线到来的，需要少步、因果的生成（已有 layout-to-video 方法都是多步、双向、整段生成）；一次更新会让部分历史"过时"，渲染器要分清哪些保留、哪些改；还要画出受影响物体的新状态（比如门转开），而视频编辑方法依赖精确掩码、反演或逐视频优化，不适合在线、粗框的场景。

## 方法

### 世界状态怎么用代码表示（§3.1、附录 B）

- 接口：$S_t = \{(b_{t,i}, c_i, d_{t,i})\}_{i=1}^{N_t}$，每个活跃物体 $i$ 一组：
  - $b_{t,i}$：**布局框**，帧坐标下的 2D 位置（归一化）；
  - $c_i$：**持久属性**，身份和外观文字（如"一辆红色汽车"）；
  - $d_{t,i}$：**动态状态**，当前状态 / 动作文字（如"红车在红灯前停下"）。
- 纹理、光照、风格以及烟雾、水花这类物理效果都**不进接口**，留给生成器补。
- **Box World Engine** 是一个轻量状态机（附录 B、算法 1），由四部分组成：实体（ID、语义角色、初始框或世界坐标范围、持久描述）、更新规则（移动、激活、状态切换、显隐、生成新物体等）、相机与投影参数（把引擎坐标投到图像坐标得到逐帧框）、状态发布（把结果写成上面的接口流）。
- 每步：接收用户动作 / 脚本策略 / 外部控制信号 → 评估适用规则 → 更新框、属性、动态状态和全局变量 → 增删或激活实体 → 投影 → 发布 $S_t$ 到缓冲区。
- 已有的 2D / 3D 引擎可以保留自己的机制和物理，只要把活跃实体投成图像框、导出状态描述，就能接上同一个渲染器。

### 谁写代码（§4.1、附录 B–C.1）

- 实验里所有引擎都由 **Kimi K2.5** 根据用户规则和共享引擎模板生成；也可以由用户直接提供。
- 一个新规则系统需要 **205–714 行代码（中位数 351）**；一个新的视觉 / 场景变体通常只要 10–20 行 JSON 配置，引擎再程序化地生成轨迹、事件时间和反事实分支。

### 渲染器骨干与条件注入（§3.2、[[topics/papers/代码世界模型与神经渲染/1-21_2610.36371_BoxWorld.pdf#page=4|图 3，第 4 页]]）

| 项目 | 内容 |
|---|---|
| 骨干 | **LongLive**（从 Wan2.1 蒸馏出的少步自回归视频模型；论文没写参数规模） |
| 建模 | $p_\theta(x_t \mid x_{<t}, S_t)$，逐潜帧自回归，每帧只用自己那一时刻的状态 |
| 条件注入 | 每个骨干块里，在自注意力和文字交叉注意力**之间**插一个 **State Grounding Module**：每个物体的框、属性、动态状态编码成 $L$ 个 grounding token；框生成掩码，**每个视觉 token 只能注意覆盖它的物体的 token**；逐帧做交叉注意力（不跨帧，省算力） |
| 残差门控 | $h' = h + \lambda \tanh(\gamma)\bar{Y}$，$\gamma$ 初始化为 0，$\lambda$ 是控制强度 |
| 时间一致 | 交给骨干的因果自注意力 |
| 何时生效 | 框主要约束粗布局，而布局在去噪早期确定，所以模块只在**噪声水平 > 0.8** 时启用 |
| 推理 | 4 步去噪、832×480；LongLive 的 LoRA 和阶段 2、3 的 LoRA 都合并进主干权重，不增加推理开销 |
| 流式 | 引擎和渲染器是两个**异步进程**，通过状态缓冲区相连；渲染器每次生成新帧时读最新状态，所以状态更新会在接下来的几帧里体现，引擎同时继续仿真 |

### 三阶段训练（§3.3、附录 C.1）

| 阶段 | 学什么 | 数据 | 训练方式 | 可训练参数 | 迭代 / 超参 |
|---|---|---|---|---|---|
| 1 Masked Layout Grounding | 物体 ↔ 框 ↔ 属性的绑定 | 过滤后的开放域视频：VideoGen-1M、4DNeX | **Diffusion Forcing**（每帧独立噪声，历史本身也带不同噪声），损失加权偏向高噪声 | 只训 State Grounding Module，骨干冻结 | 20K 次，batch 32，AdamW，峰值 lr 1e-4 |
| 2 State Dynamics Adaptation | 状态切换（开放域视频里很少） | 网上收集的 **4,000 段短游戏录像** | **Teacher forcing**：干净的真值前缀表示旧状态、目标帧表示新状态，于是学会"只改受影响的物体，其余照常延续" | 冻结阶段 1 模型，在线性层加 **rank-16 LoRA** | 10K 次，batch 32，lr 3e-5 warmup 后余弦衰减到 10% |
| 3 Rollout Distillation | 恢复少步生成，适应自己生成的历史 | 两类来源的状态序列 | **Self-Forcing 式 DMD**：学生在自己的少步 rollout 上，用阶段 2 模型当教师、另一个从教师初始化的 critic 当 fake score | 冻结阶段 2，再加一个 **rank-64 LoRA** | 400 步 DMD |

工程：FlexAttention、bf16 混合精度、梯度检查点。论文**没写训练用的 GPU 型号和数量**。

### 从视频自动标注状态（§3.4、附录 A）

- 视频过滤：至少 720p、16 FPS、81 帧，物体可识别且在运动；剔除严重模糊、视角不稳、身份含糊的片段。
- 流水线：LLaVA-NeXT-Video 列出主要物体并写全片描述（含背景）→ Grounding DINO 在首帧出框 → SAM 2 跨帧跟踪 → 逐帧裁出每个物体，用图像描述模型写"身份外观"（成为 $c_i$）和"当前状态 / 动作，强调变化"（成为 $d_{t,i}$）。
- 游戏录像额外做"结构化描述"：主物体、相机、环境、时间天气光照、目标、交互（附录图 8 是一段赛车游戏的例子）。

## 实验与关键数字

### PairedStateBench（[[topics/papers/代码世界模型与神经渲染/1-21_2610.36371_BoxWorld.pdf#page=7|表 1，第 7 页]]）

- **87 个案例**、16 个场景族（搬运物体、凭证门、充电、重力控制、压力板门等），含 **37 对分支**；易 / 中 / 难 23 / 28 / 36 例。一对分支共享场景和初始布局，但动作不同，要求结局不同（附录 C.2）。
- 输入：BoxWorld 用全局提示 + 引擎导出的逐物体框和动态状态序列；LongLive 只用同一全局提示；LingBot-v1 用首帧 + 提示 + 由引擎导航动作转换来的键盘 / 相机输入；LingBot-v2 公开版只支持相机路径条件；oracle 变体另外拿到"已结算状态轨迹"的文字描述。
- 指标：Trigger（规定事件出现的比例）、Suppress（禁止后果不出现的比例；易档没有禁止后果，不计）、Paired-CF（两分支都对的对数比例）、State-Fid（每个物体在各状态窗口内是否保持规定状态，排除切换边界附近帧）、OnTime（事件起点与引擎边界按 16 FPS、每 12 帧一格，相差不超过 1 格）、Task（所有阶段、禁止约束、事件顺序、终态在同一视频里都成立）。
- 评判：Kimi K2.5 和 Qwen3.8-27B 看按时间排列的帧拼图，判断事件、状态和起点帧；两者分歧的 39 / 522 段（7.5%）人工复核。

总体（Overall）：

| 方法 | FPS | Trigger | Suppress | Paired-CF | State-Fid | OnTime | Task |
|---|---|---|---|---|---|---|---|
| LingBot-v1 | 0.05 | 53.5 | 11.1 | 16.2 | 43.1 | 44.5 | 25.3 |
| LingBot-v1（Oracle） | 0.05 | 45.5 | 25.4 | 16.2 | 42.3 | 27.7 | 18.4 |
| LingBot-v2†（仅相机版） | 13.3 | 21.3 | 63.5 | 10.8 | 46.1 | 14.3 | 11.5 |
| LingBot-v2†（Oracle） | 13.3 | 19.0 | 69.8 | 16.2 | 57.1 | 17.5 | 11.5 |
| LongLive | 20.7 | 10.7 | 50.8 | 13.5 | 36.2 | 5.7 | 8.0 |
| **BoxWorld** | **20.7** | **92.2** | **90.5** | **97.3** | **91.6** | **91.2** | **83.9** |

分档（BoxWorld vs 最好的基线）：

| 档 | BoxWorld Paired-CF | 基线最高 Paired-CF | BoxWorld Task | 基线最高 Task |
|---|---|---|---|---|
| 易 | 100.0 | 60.0（LingBot-v1） | 82.6 | 47.8（LingBot-v1） |
| 中 | 100.0 | 0.0（全部基线） | 89.3 | 32.1（LingBot-v1） |
| 难 | 94.7 | 15.8（LingBot-v1 Oracle） | 80.6 | 8.3（LingBot-v1 Oracle） |

- 从百分比反推，37 对大致是易 10 对、中 8 对、难 19 对（97.3% = 36/37，16.2% = 6/37；这是按表推算的，论文没直接给）。
- 中档里 LingBot-v2 和 LongLive 的 Suppress 是 100、Trigger 只有 13–26——基本"什么都没发生"，所以没出现禁止后果。
- LongLive（同一骨干、不给状态）Paired-CF 只有 13.5%，作者据此说结局是靠状态接地实现的。

### 公开基准

**VBench / VBench-Long 30 s**（附录 C.3 表 3；状态序列来自对 LongLive 用同一提示生成的视频跑标注流水线）：

| 模型 | FPS | VBench Total | Quality | Semantic | Long Total | Long Quality | Long Semantic |
|---|---|---|---|---|---|---|---|
| Self Forcing | 17.0 | 84.31 | 85.07 | 81.28 | 81.59 | 83.82 | 72.70 |
| LongLive | 20.7 | **84.87** | **86.97** | 76.47 | **83.52** | **85.44** | 75.82 |
| BoxWorld 阶段 1 | 20.7 | 83.30 | 84.46 | 78.62 | 81.72 | 82.81 | 77.36 |
| BoxWorld 阶段 2 | 20.7 | 83.57 | 84.22 | 80.97 | 81.82 | 82.85 | 77.71 |
| BoxWorld 阶段 3 | 20.7 | 83.76 | 84.82 | 79.54 | 83.00 | 84.34 | 77.67 |

Semantic 比 LongLive 高（76.47 → 79.54；75.82 → 77.67），但 Total 和 Quality 都比 LongLive 低一些，作者的说法是"相当"。

**YouTube-VIS 2021 布局到视频**（附录 C.4 表 4，照 BlobGEN-Vid 的协议，基线分数引自已有论文）：

| 方法 | 实时 | FVD↓ | mIOU | rCLIPt | rCLIPi | rCFC |
|---|---|---|---|---|---|---|
| TrackDiffusion | 否 | 464 | 0.492 | 0.273 | 0.804 | 0.940 |
| LVD | 否 | 558 | 0.281 | 0.261 | 0.803 | 0.861 |
| VideoTetris | 否 | 590 | 0.166 | 0.267 | 0.799 | 0.423 |
| BlobGEN-Vid | 否 | 317 | **0.598** | 0.289 | 0.836 | 0.958 |
| BoxWorld（阶段 3） | 是 | **62** | 0.572 | **0.291** | **0.837** | **0.965** |

### 消融（[[topics/papers/代码世界模型与神经渲染/1-21_2610.36371_BoxWorld.pdf#page=9|表 2，第 9 页]]；附录 C.5 表 5–7）

**训练阶段在 PairedStateBench 上**（表 7）：

| 阶段 | Trigger | Suppress | Paired-CF | State-Fid | OnTime | Task |
|---|---|---|---|---|---|---|
| 1 | 87.3 | 60.3 | 64.9 | 83.4 | 83.8 | 49.4 |
| 2 | 82.0 | 85.7 | 67.6 | 83.6 | 81.5 | 64.4 |
| 3 | 92.2 | 90.5 | 97.3 | 91.6 | 91.2 | 83.9 |

阶段 1 就能触发大多数事件，但常常带出禁止后果；阶段 2 主要提高 Suppress（游戏录像教会它"状态变了才改物体"），Trigger 和 OnTime 略降；阶段 3 各项都升，Paired-CF 跳到 97.3。

**接口消融**：

| 变体 | 结果 |
|---|---|
| 去掉空间掩码（每个视觉 token 看全部物体） | YouTube-VIS mIOU 0.572 → 0.291，FVD 62 → 79；VBench Total 83.76 → 80.33，Semantic 79.54 → 74.51 |
| 所有物体属性换成 "object" | mIOU → 0.323，rCLIPt 0.291 → 0.273，rCFC 基本不变（0.963） |
| 动态状态换成静态描述 | PairedStateBench Trigger 92.2 → 42.5，OnTime 91.2 → 16.1 |
| 阶段 2 LoRA 只在噪声 > 0.8 时用 | VBench Total 82.56（完整阶段 2 是 83.57） |
| 阶段 2 LoRA 改在开放域视频上训 | VBench Total 81.98 |

### 定性（[[topics/papers/代码世界模型与神经渲染/1-21_2610.36371_BoxWorld.pdf#page=8|图 4、图 5，第 8 页]]）

- 图 4：浇水后花开、拿钥匙后开门，BoxWorld 只在前提满足后渲出事件；LingBot-v1 不满足前提也渲，oracle 版仍会没钥匙就开门、没浇水就开花。
- 图 5：六个引擎（点燃目标、骑乘收集、拾取-搬运-放置、扫描两个目标、休息后站起、跳跃后左转），每个用两组不同的物体属性和场景描述渲出——例如"白色机器人 + 红色方块，阳光机器人工作室"和"蓝金机甲 + 红色方块，工业车间"——说明同一引擎可以驱动不同视觉世界。

## 局限 / 存疑

作者自己承认的（附录 D）：接口加上结构化全局提示能覆盖实验里多数情况，但对细几何、关节运动、接触丰富的交互可能不够；引擎决定所有交互结果，所以渲染出的后果只和引擎一样正确，且每个新规则系统都要单独实现引擎；自动标注的错误（比如跟踪漏掉物体）会导致后果缺失或身份互换。

读的时候值得核对的：

- **20.7 FPS 的口径（需核对）**：这个数和 LongLive 自己报告的吞吐完全一样，表 3 注明"FPS 是生成吞吐，基线按各自报告的设置"。论文**没写在什么 GPU 上测的**，也没说是否包含 State Grounding Module、引擎和异步缓冲的开销，也没报按键到画面的延迟。
- **基线对比的公平性**：PairedStateBench 是作者自建、案例由作者的引擎导出；只有 BoxWorld 能吃到逐物体的框和状态序列。LongLive 只拿全局提示，LingBot-v2 公开版只接受相机路径（作者自己在表注里标了），LingBot-v1 的键盘输入是从引擎动作转换来的。所以表 1 主要证明"给了显式物体状态就能按规则渲染"，而不是在同等信息下比生成能力。oracle 变体拿到的是文字形式的结局，和 [[topics/notes/代码世界模型与神经渲染/1-20_StateWorldModels|State World Models]] 的 Rule+end 是同一类对照。
- **评判模型与引擎作者同源**：引擎由 Kimi K2.5 写，评判也用 Kimi K2.5（加 Qwen3.8-27B），分歧才人工复核。
- **YouTube-VIS 的 FVD 62 对 317**：基线分数是"引自已有论文"，分辨率、帧数、采样数是否与 BoxWorld 一致，正文没说明；差距大到值得核对协议。
- **VBench 的状态来自骨干自己的生成**：每个提示先让 LongLive 生成一段视频，再标注出状态当条件，所以条件和骨干的偏好天然一致；Semantic 的提升有多少来自"多了物体级描述"而不是渲染能力，难以区分。
- **"新状态"靠文字**：动态状态是自由文本（"门打开""花开放"），渲染器在游戏录像上学会响应文字变化。没有报告对训练中没见过的状态描述、新物体类别的泛化，也没给 4,000 段游戏录像的来源和许可。
- **接口只有 2D 框**：引擎内部可以是 3D，但传给渲染器的是投影后的 2D 框，没有深度、遮挡顺序和显式相机；相机运动只能靠全局提示。长时一致和"回访"靠 LongLive 的滚动 KV 缓存，没有显式空间记忆，也没有评测回访一致性。
- **命名小错**：正文写 "VideoGen-1M"，参考文献是 VidGen-1M（Tan et al., 2024）。

## 与其他论文的关系

- **同一时期最像的一篇**：[[topics/notes/代码世界模型与神经渲染/1-20_StateWorldModels|State World Models]]（早一周）。两篇都把"规则执行"移出生成器、都做了"同一起点、不同分支"的成对基准（PairedStateBench vs WorldState-Bench），都发现端到端模型拿到写明结局的文字也做不对（oracle / Rule+end）。差别在渲染侧：State World Models 完全不训练、用冻结的 MiniMax-H3 回合制生成，状态以 VisualScript 文字 + 粘土预览传入；BoxWorld 训练一个**实时流式**渲染器，状态以 2D 框 + 属性 + 动态状态 token 经掩码交叉注意力传入。
- **框作为条件的其他做法**：
  - [[topics/notes/代码世界模型与神经渲染/1-04_ProgrammableWorldModel|PWM]]：3D OBB 投影成身份 / 语义 / 运动方向三张像素级嵌入图，经 ControlNet 注入冻结的 LingBot-World-v1，含屏幕外实体——"像素图"路线；BoxWorld 是"token + 掩码注意力"路线，接口更轻，但只有 2D。
  - [[topics/notes/代码世界模型与神经渲染/1-07_Oneira|Oneira]]：把按状态上色的 3D 框渲成条件视频喂给 H3——状态先变成像素再进模型。
  - [[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]]（低模代理）、[[mirros/notes/01_AgentGarten|AgentGarten]]（深度 / 法线）、[[topics/notes/代码世界模型与神经渲染/2-06_AlayaRenderer-Flash|AlayaRenderer-Flash]]（G-buffer）：条件更稠密，几何更准，但需要引擎导出更多东西；BoxWorld 处在专题清单"条件信号在变粗"那条线的最粗一端附近，物体之外的外观和物理效果全交给生成器。
- **实时性对照**：BoxWorld 832×480、4 步、20.7 FPS（硬件未写）；AgentGarten 单张 H100 480×832 约 36.5 FPS；[[topics/notes/代码世界模型与神经渲染/1-03_Magpie|Magpie]] 单张 H100 计算吞吐 32.2 FPS；Matrix-Game 4.0 单张 RTX 5090 按键到画面 112 ms。BoxWorld 的骨干（LongLive，Wan2.1 系）在这些系统里偏小。
- **渲染器的训练技术来源**：[Diffusion Forcing](https://arxiv.org/abs/2407.01392)（阶段 1）、[Self Forcing](https://arxiv.org/abs/2506.08009) + [DMD](https://arxiv.org/abs/2311.18828)（阶段 3）、[LongLive](https://arxiv.org/abs/2509.22622)（骨干、LoRA 接近全量微调的结论、滚动 KV 缓存）。逐帧掩码交叉注意力的思路接近 GLIGEN / LayoutDiffuse 一类布局生成，以及 [BlobGEN-Vid](https://arxiv.org/abs/2501.07647)（YouTube-VIS 协议的来源）、TrackDiffusion。实时运动控制方面可对照同样基于 Self Forcing 一系的 [MotionStream](https://arxiv.org/abs/2511.01266)。
- **被比较的端到端世界模型**：LingBot-World v1（[2601.20540](https://arxiv.org/abs/2601.20540)）和 v2（Infinite Worlds with Versatile Interactions，[2607.07534](https://arxiv.org/abs/2607.07534)）。
- **同一节的近邻**：[GameDirector](https://arxiv.org/abs/2609.25652)（1-16）、[Fight World Model](https://arxiv.org/abs/2610.40607)（1-22）、[Wizard](https://arxiv.org/abs/2610.40339)（1-23）都走"规则引擎 + 视频模型渲染"；[[topics/notes/代码世界模型与神经渲染/1-15_GameWM|GameWM]] 则主张交互细节也交给视频模型——BoxWorld 的动态状态文字（"门打开"）只规定"发生什么"，"怎么打开"确实是渲染器补的，和 GameWM 的分工接近。
- **评测角度**：[[topics/notes/代码世界模型与神经渲染/3-04_WorldDraft|WorldDraft]] 系统评测"代码建世界、视频模型渲染"，发现保持世界和渲染属性此消彼长；BoxWorld 的消融（去掉属性 mIOU 大降、去掉掩码一致性也降）是同一问题在"框接口"上的版本。[PROWBench](https://arxiv.org/abs/2610.02205)（3-06）也测"渲出的内容是否符合程序规定的事件"。
- **和本库方向的联系**：
  - 图 5 里有"白色机器人拾取、搬运、放置红色方块"的引擎，说明同一状态流可以换不同外观渲成多种"机器人操作视频"；接口能从真实视频用 Grounding DINO + SAM 2 自动标注，原理上可以用来批量合成带物体级标签的操作 / 导航视频。但接口只有 2D 框、没有深度和接触，离给机器人策略做 sim-to-real 数据还有距离；更贴近机器人渲染的是同专题的 RoboRender（2-16，[2610.09254](https://arxiv.org/abs/2610.09254)）和 DR-WM（1-17，四足导航，[2610.17630](https://arxiv.org/abs/2610.17630)）。
  - 具身导航里"门要有钥匙才开、压力板要站上去才开"这类条件事件，正是 PairedStateBench 的题型；可对照 [[topics/视觉语言导航VLN]] 里对世界模型 / 仿真环境的需求。
  - "编码智能体按用户规则写引擎"属于 [[topics/递归自我改进RSI]] 第五节"大模型生成任务与环境"一路；论文给了引擎代码量（中位 351 行），但没有报告智能体写引擎的成功率。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文是 CC BY 4.0，必要处附短句原文）
> 1. 第 2 页 §1 第 2–4 段：端到端模型要同时判断规则、后果、画面；稠密状态越细越重；提出"explicit-but-minimal Object-Centric State Interface" → 问题与接口动机
> 2. 第 2 页 §1 第 6 段：在线状态需要少步因果生成；更新使部分历史过时；要画出受影响物体的新状态 → 三个难点
> 3. 第 4 页 §3.1：$S_t=\{(b_{t,i},c_i,d_{t,i})\}$ 三元组定义；编码智能体从共享模板实现引擎，发布到异步读取的状态缓冲 → 状态表示
> 4. 第 5 页 §3.2 式 1–2：逐帧掩码交叉注意力、门控残差 $\lambda\tanh(\gamma)$ 初始化为 0；异步流式渲染 → 条件注入与流式
> 5. 第 5–6 页 §3.3：三阶段（Diffusion Forcing / teacher forcing + LoRA / Self-Forcing 式 DMD），LoRA 合并进主干 → 训练方案
> 6. 第 6 页 §4.1 与第 22 页附录 C.1：20K / 10K / 400 次迭代、rank 16 / 64、4 步 832×480、模块只在噪声 > 0.8 启用、Kimi K2.5 写引擎 → 实现细节
> 7. 第 7 页表 1 与 §4.2 "Quantitative Results"：97.3% vs ≤16.2% Paired-CF，83.9% vs ≤25.3% Task；oracle 也停在 16.2% → 主结果
> 8. 第 21 页附录 B "Reuse and authoring cost"：新规则系统 205–714 行（中位 351），新变体 10–20 行 JSON → 引擎编写成本
> 9. 第 22、25 页附录 C.2：87 例、16 个场景族、37 对、易中难 23/28/36；OnTime 公式；39/522 段裁判分歧人工复核 → 基准与评判
> 10. 第 25–26 页附录 C.3–C.5 表 3–7：VBench 状态来自 LongLive 生成视频的标注；YouTube-VIS 基线分数引自已有论文；各阶段与接口消融 → 公开基准与消融的口径

## 摘要（中文）

我们研究如何构建具有用户自定义行为的实时交互视频世界。这样的世界必须追踪物体状态、应用交互规则，并在用户行动时渲染出相应后果。然而，现有的端到端视频世界模型通常在生成器内部学习交互动力学，难以指定物体级规则并推理其后果。本文提出 BoxWorld，把交互推理与生成式渲染分开。给定用户指定的规则，编码智能体创建一个 Box World Engine，由它决定交互结果，并通过布局框、持久物体属性和动态状态变量组成的轻量接口暴露由此产生的物体状态，把外观和物理效果留给生成式渲染。随后，Box-State Generative Renderer 自回归地把这条不断演化的状态流渲染成视频，从而在线控制物体运动、状态切换和条件事件。渲染这条状态流并不简单：渲染器必须实时响应物体级状态更新，同时与已生成的历史保持连贯。为此，我们提出三阶段训练策略：从开放域视频学习物体接地、从游戏录像学习状态转换（两者都自动标注），最后在自生成的历史上做 rollout 蒸馏。我们还提出 PairedStateBench，一个用于细粒度交互控制的成对基准。BoxWorld 大幅超过端到端世界模型，并在多个公开基准上保持竞争力。项目页：boxworld-web.github.io。

## 摘要（原文）

论文以 CC BY 4.0 许可发布（[arXiv 摘要页](https://arxiv.org/abs/2610.36371)），以下转录自本地 PDF 第 1 页：

We tackle the challenge of building real-time interactive video worlds with user-defined behaviors. Such worlds must track object states, apply interaction rules, and render the resulting consequences as users act. Yet existing end-to-end video world models typically learn interaction dynamics within the generator, making it difficult to specify object-level rules and reason about their consequences. In this work, we introduce BoxWorld, which separates interaction reasoning from generative rendering. Given user-specified rules, a coding agent creates a Box World Engine that determines interaction outcomes and exposes the resulting object states through a lightweight interface of layout boxes, persistent object attributes, and dynamic status variables, leaving appearance and physical effects to generative rendering. A Box-State Generative Renderer then renders this evolving state stream into video autoregressively, enabling online control over object motion, state switches, and conditional events. Rendering this state stream is non-trivial: the renderer must respond to object-level state updates in real time while remaining coherent with the generated history. To this end, we introduce a three-stage training strategy that learns object grounding from open-domain videos and state transitions from gameplay videos, both annotated automatically, and finally performs rollout distillation on self-generated histories. We further propose PairedStateBench, a paired benchmark for fine-grained interaction control. BoxWorld substantially outperforms end-to-end world models and remains competitive across multiple public benchmarks. Project page: boxworld-web.github.io.
