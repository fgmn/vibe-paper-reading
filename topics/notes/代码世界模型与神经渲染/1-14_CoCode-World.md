---
id: "1-14"
org: 专题·代码世界模型与神经渲染
short: "CoCode-World"
title: "CoCode-World: Shared 3D Proxy Representation for Multi-Player World Models"
aliases: ["CoCode-World", "CCW"]
date: 2026-11-11
category: "代码世界 + 视频渲染器（完整系统）"
venue: —
affiliation: "上海交通大学 · 中国电信人工智能研究院（TeleAI） · 卡迪夫大学"
authors: ["Qirui Li", "Xin Zhang", "Yabo Chen", "Jinkun Hao", "Paul L Rosin", "Yu-Kun Lai", "Haibin Huang", "Yin Chen", "Ran Yi", "Chi Zhang"]
arxiv: "2611.15602"
pdf: "[[topics/papers/代码世界模型与神经渲染/1-14_2611.15602_CoCode-World.pdf]]"
code: ""
project: "https://iapple233.github.io/CCW/"
license: CC BY 4.0（arXiv 摘要页）
status: 未读
rating:
read_date:
tags: ["paper", "world-model", "neural-rendering", "code-world", "multiplayer", "multi-view", "proxy-video", "minimax-h3", "lora", "gta-v"]
---

# CoCode-World: Shared 3D Proxy Representation for Multi-Player World Models

> [!info] 论文信息
> arXiv [2611.15602](https://arxiv.org/abs/2611.15602) · 本地 PDF 是 v1（2026-11-11）
> 单位：上海交通大学（1）、中国电信人工智能研究院 TeleAI（2）、卡迪夫大学（3）· 一作 Qirui Li（上交 + TeleAI）· 通讯作者：Ran Yi（上交）、Chi Zhang（TeleAI）
> PDF：[[topics/papers/代码世界模型与神经渲染/1-14_2611.15602_CoCode-World.pdf|本地 PDF]]（13 页：正文约 10 页 + 参考文献 3 页，没有附录）
> 项目页：[iapple233.github.io/CCW](https://iapple233.github.io/CCW/) · 论文里没有给代码仓库链接
> 专题：[[topics/代码世界模型与神经渲染#一、代码世界 + 视频渲染器（完整系统）|代码世界模型与神经渲染 · 一、代码世界 + 视频渲染器（完整系统）]]

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-18）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。

## 一句话总结

把 [[topics/notes/代码世界模型与神经渲染/1-01_CodeWorldModel|CWM]] 的"代理视频 + 视频模型渲染"从单视角推广到**双人游戏**：同一张共享地图和同一套实体身份，分别从两个玩家的相机投影成两段无纹理代理视频；然后把两段代理、两张外观参考图、两段目标视频**沿图像宽度左右拼成一张画布**（玩家 1 永远在左、玩家 2 在右），交给**冻结的 MiniMax-H3 33B Ref2VA** 一次联合去噪，只训 LoRA。跨视角的外观一致不靠额外模块，而靠骨干原生的全注意力——一个视角里看得到的衣服可以直接指导另一个视角里同一个人的生成。数据是自建的 GTA V 双人数据集（7,846 段约 5 秒的配对片段）；在 150 个"换角色、换风格"的测试用例上，DOVER 0.524、LAION 5.655、Edge F1 0.124、跨视角身份分 3.847/5，都高于 Seedance 2.5、SolarRenderer、原版 H3 和 Gamma-World，但相邻帧稳定性和参考保持略低于 Seedance 2.5。目前是 50 步双向生成，**不是实时**。

## 要解决什么问题

- **多人世界模型的核心约束**：每个玩家相机不同，但在同一个场景里。一个人从背后看到的角色，另一个人可能从正面看到；一个物体出了你的视野还可能在别人视野里。生成的多路观测必须对共享实体"说法一致"，同时又各自服从自己的相机运动和遮挡。
- **现有两条路各有缺口**（§1，第 1–2 页）：
  - 在**隐空间**协调（联合去噪、跨智能体注意力、共享表示：Solaris、ShareVerse、Gamma-World、MultiWorld）：没有显式状态。
  - **显式状态**的方法（MASS）、或依赖**精细的、逐张地图**几何的方法（WorldCast）：后者换场景难、可玩世界的多样性受限。
- **只有共享几何不够**：共享代理约束了布局、运动、遮挡，但**没规定同一实体在不同视角里长什么样**。两个视角各自独立生成，都能贴合各自的代理，却可能给同一个角色穿上不同的衣服（[[topics/papers/代码世界模型与神经渲染/1-14_2611.15602_CoCode-World.pdf#page=8|图 4，第 8 页]] 里 Seedance 就是这样）。所以需要一种在生成过程中**跨视角交换外观信息**的机制。
- 作者的定位：沿用"视频模型当渲染器"（CWM、SolarRenderer）的结构 / 外观分离，但这些工作基本只研究单视角。

## 方法

总览见 [[topics/papers/代码世界模型与神经渲染/1-14_2611.15602_CoCode-World.pdf#page=4|图 2，第 4 页]]。

### 世界状态怎么表示、谁"写"它（§3.1）

| 项 | 内容 |
|---|---|
| 数据来源 | 私有 FiveM 服务器上录的**双人 GTA V** 对局 |
| 每个客户端记录 | RGB 视频、相机参数、玩家和附近实体的身份与位姿 |
| 共享世界 | 导出同一坐标系下的**静态地图几何** M；持久的实体 ID 把两个视角连起来 |
| 代理渲染 | $P^{(p)}_t = R(M, E^{(p)}_t, C^{(p)}_t)$，p ∈ {1,2}；E 是该玩家看到的实体观测，C 是相机位姿和投影 |
| 代理内容 | 地图保留表面和障碍；角色、车辆用简化几何；**无纹理**，只用类别颜色区分粗实体 |
| 外观来源 | 衣服、材质、场景外观全部来自 RGB 参考图和视频先验 |

- 注意：**实验里没有编码智能体**。世界状态来自 GTA V 引擎（地图 + 各客户端的实体观测），"可编程代理、由编码智能体构建和更新世界"只出现在引言的动机里（第 1 页）。渲染器本身也不学状态转移（§2 最后两段，第 3 页："learning action-driven state transitions is outside the renderer"）。
- 动态实体用的是**每个客户端自己**在本地流式加载和网络同步下能拿到的状态，所以两个玩家的 E 不一定完全相同（第 4 页）。

### 数据集（§3.1 "Paired Supervision"、[[topics/papers/代码世界模型与神经渲染/1-14_2611.15602_CoCode-World.pdf#page=5|图 3，第 5 页]]）

- 两段录像按估计的服务器时间戳对齐，只保留两人都有观测的时段。
- 每个训练样本：两段 RGB、两段代理、一张**联合**外观参考图（训练时就是两个视角各自的第一帧 RGB 拼起来）、一条字幕（场景、共享角色身份、各视角里的动作和可见性）。
- 共 **7,846 段、每段约 5 秒**。按字幕自动估计的类别占比：探索 66.4%、骑乘 18.7%、交互 9.8%、打斗 5.1%（多类并存时按打斗 > 骑乘 > 交互 > 探索取主类）。
- 作者说数据集还包含共享 3D 世界表示、世界状态和玩家动作元数据，方便别人自己造代理（贡献列表，第 3 页）。是否已发布需核对项目页。

### 联合生成：一张画布放两个视角（§3.2）

| 项 | 内容 |
|---|---|
| 骨干 | **MiniMax-H3 33B Ref2VA**，参数冻结 |
| 适配 | LoRA，加在注意力投影和前馈层上（rank 等超参论文没给） |
| 空间组织 | $V_t = [V^{(1)}_t \| V^{(2)}_t]$，$P_t = [P^{(1)}_t \| P^{(2)}_t]$，沿图像宽度拼接；参考图 I 也同样左右排 |
| 条件注入 | 走 H3 **原生的图像 + 视频参考通路**：联合 RGB 图给外观，联合代理视频给结构，字幕补场景和动作 |
| 跨视角通信 | 参考段和目标段进同一个**全双向注意力**上下文；任一目标区域都能看两个玩家的参考和目标特征 |
| 建模目标 | $p_{θ,ϕ}(V \| P, I, c)$，θ 冻结、ϕ 是 LoRA |

- 和 MetaWorld 的区别：MetaWorld 给每个玩家一个**独立生成分支**，再加跨注意力模块通信；本文只用**一个分支**，靠预训练视频模型的上下文学习能力（第 2 页）。
- 作者的说法：跨视角外观对应是从**配对 RGB 监督**里学出来的，几何表示只负责各相机的结构约束（第 5 页）。

### 训练与推理（§3.3）

- 损失：骨干原有的 flow matching，$z_τ = τz + (1-τ)ε$，预测速度 $z - ε$；只在两个玩家的目标区域算，参考段不算损失。
- 推理：代理和参考按训练时同样的左右布局放；参考可以换成和原始对局不同的风格，代理保留原轨迹。联合去噪、解码后去掉填充，切成两段玩家视频。
- 生成消费的是一整段预先给定的代理区间（不是逐块流式）。
- **速度**（§5.2，第 10 页）：现在是双向注意力 + **50 步**去噪；蒸馏到 8 步画质还行；要达到实时目标得降到 1–2 步，初步尝试下画质难保持。论文没有报告任何生成耗时、分辨率、帧数。

## 实验与关键数字

### 设置（§4.1，第 6 页）

- **基准**：150 个双人用例，四类事件（探索、骑乘、玩家打斗、环境交互）。代理轨迹取自 GTA V 对局；用 **GPT Image 2.5** 给参考图换风格（换角色外观、背景环境、视觉风格），检验"同一段对局换皮后还能不能保住"。
- **指标**（照 SolarRenderer）：DOVER（视频质量）、LAION 美学分、DINO Adj.（相邻帧 DINOv2 相似度，时间稳定性）、Edge F1（生成画面和代理轮廓的吻合）、First-frame（生成视频最后一秒和参考图的 DINOv2 相似度）。两个视角分别算，先在用例内平均，再跨用例平均。
- **跨视角一致**：用代理给出的身份、可见性和对应关系，在玩家同时出现在两个视角时裁出两张图，让 **Qwen3.8-27B** 判断身份和动作是否一致。
- **基线**：Gamma-World（只给初始帧和动作序列，不需要地图）；MiniMax-H3、Seedance 2.5（都给参考图和代理轨迹）；SolarRenderer（只支持单视角，两个视角分开生成）。

### 主结果（[[topics/papers/代码世界模型与神经渲染/1-14_2611.15602_CoCode-World.pdf#page=7|表 1，第 7 页]]）

| 方法 | DOVER↑ | LAION↑ | DINO Adj.↑ | Edge F1↑ | First-frame↑ | Cross-view↑（0–5） |
|---|---|---|---|---|---|---|
| Gamma-World | 0.170 | 4.364 | 0.923 | 0.038 | 0.160 | 0.697 |
| SolarRenderer | 0.454 | 5.477 | 0.968 | 0.073 | 0.655 | 3.696 |
| MiniMax-H3 | 0.441 | 5.397 | 0.958 | 0.060 | 0.659 | 2.868 |
| Seedance 2.5 | 0.469 | 5.568 | **0.973** | 0.120 | **0.700** | 3.552 |
| **CoCode-World** | **0.524** | **5.655** | 0.970 | **0.124** | 0.684 | **3.847** |

- 相对没微调的 MiniMax-H3：跨视角身份 2.868 → 3.847，Edge F1 0.060 → 0.124，First-frame 0.659 → 0.684。这一组对比最能说明 LoRA + 联合画布的作用。
- 相对 Seedance 2.5：DOVER、LAION、Edge F1、跨视角身份更高；DINO Adj. 和 First-frame 略低（作者用"competitive"描述）。
- SolarRenderer 两视角分开生成，跨视角身份 3.696，只比本文低 0.15；比原版 H3 联合输入（2.868）还高。
- Gamma-World 各项都差很多，作者解释为现有多人世界模型难以迁移到这么多样的场景和外观。

### 定性（图 4，第 8 页）

- 农场场景：Seedance 给同一个玩家在两个视角里穿了不同衣服；本文一致。
- 夜间街道：Seedance 在一个视角里把快递员漏掉了；本文两个视角都有。

### 代理构造的消融（§4.3，[[topics/papers/代码世界模型与神经渲染/1-14_2611.15602_CoCode-World.pdf#page=9|图 5，第 9 页]]，只有定性）

| 代理 | 内容 | 现象 |
|---|---|---|
| Raw | 粗场景 + 粗实体几何 | 深度关系、遮挡、局部结构表达不准；工业建筑附近出现**发黑区域**，对布局和运动的跟随变弱 |
| + Detail & Lighting | 加场景细节和明暗 | 轮廓、深度线索、阴影更丰富，复杂环境渲得更好，角色仍是粗控制 |
| + Skeleton | 再加近似的角色骨架 | 肢体被**过度约束**，动作僵硬照抄代理；人形骨架驱动非人角色（海滩上的比格犬）时尤其明显 |

- 结论：**环境要细（几何 + 光照），角色要粗**，肢体细节留给视频先验。这和 [[topics/notes/代码世界模型与神经渲染/1-15_GameWM|GameWM]] "代理不必带肢体动作"的立场一致。

### 生成方式的消融（§4.4，图 6，第 9 页，只有定性）

- 对照：仿 MetaWorld 的**双分支**变体（每个玩家一个分支，去噪时用跨注意力交换特征），同样搬到 H3 上、用同样的配对数据微调。两者都用 2,000 步的检查点。
- 只给了一个"马赛克庭院"用例两个时刻的对比，看同一玩家的衣服在两个视角里是否一致。正文只说比较了，没有给数字，也没有在正文里明确写出结论（结论在引言和贡献列表里："joint generation better preserves character details"）。

## 局限 / 存疑

作者自己承认的（§5.2，第 10 页）：

- 只做了**两人**。拼接法原则上能推广到 N 人，但固定单视角分辨率和片段长度时，每多一个玩家 token 序列就变长，单流 DiT 的注意力计算和显存跟着涨。
- **不是实时**：50 步双向生成；8 步还行，1–2 步的激进蒸馏下画质难保。
- 学状态转移、持续交互留给以后。

读的时候值得核对的：

- **名字里的 "Code" 在实验里没有出现**：没有编码智能体写世界，代理完全来自 GTA V 引擎导出的地图和实体观测。专题把它归到"代码世界 + 视频渲染器"是按作者的定位，实际做的是**多视角的结构条件渲染器**。
- **跨视角指标的定义对不上（需核对）**：§4.1 说 Qwen3.8-27B 对每对裁图**分别判断身份和动作是否一致**（像是二值判断），表 1 报的却是 0–5 分的"player-identity score"；动作一致性的结果没有报。分数怎么从判断聚合成 0–5、裁图对的数量都没说。
- **两个消融都只有定性图**：代理构造（图 5）和联合 vs 双分支（图 6）都没有数字；双分支只展示了一个用例。贡献列表里"better preserves character appearance than a dual-branch alternative"目前只有这一张图支撑。
- **主实验用的是哪种代理没写明（需核对）**：§4.3 说"倾向用 Detail & Lighting + 粗角色"，但没说表 1 是否就是这个配置。
- **训练细节缺失**：分辨率、帧数、LoRA rank、学习率、训练步数（只从图 6 知道有 2,000 步检查点）、GPU 数、推理耗时都没给。
- **基线的公平性**：Gamma-World 不接收代理，只给初始帧和动作，Edge F1 和跨视角分自然吃亏；原版 MiniMax-H3 是否也用左右拼接联合生成、Seedance 2.5 的代理以什么形式输入（相关工作里说 Seedance 2.5 支持无纹理 3D 渲染参考）都没交代。
- **训练与测试的参考图分布不同**：训练时参考是原始第一帧 RGB，测试时是 GPT Image 2.5 换风格后的图。这正是作者想测的泛化，但 First-frame 指标比的是"最后一秒 vs 参考图"，换风格越大越难，解读时注意。
- **Edge F1 的绝对值都很低**（0.038–0.124），无纹理代理的轮廓和逼真画面的边缘本来就差很多，这个指标的区分度需要结合定性图看。
- **贡献列表的说法略强**："在跨视角身份和视频质量上 SOTA、超过 Seedance 2.5 和 SolarRenderer"——身份和 DOVER / LAION 确实最高，但 DINO Adj. 和 First-frame 不是。
- **同名作者**：通讯作者 Chi Zhang 署 TeleAI，CWM 的 Chi Zhang 署西湖大学 AGI Lab，是否同一人需核对。

## 与其他论文的关系

- **直接前身**：[[topics/notes/代码世界模型与神经渲染/1-01_CodeWorldModel|CWM]]（1-01）提出"可执行状态 → 粗代理视频 → H3 渲染"，也用 GTA V 对局微调 H3；CoCode-World 把它推广到两个同时存在的视角，并把"谁维护状态"换成游戏引擎本身。
- **渲染器一侧**：[[topics/notes/代码世界模型与神经渲染/2-09_SolarRenderer|SolarRenderer]]（2-09）同样走 H3 原生参考通路接结构视频，本文的评测协议直接照它，并把它当单视角基线。和 [[topics/notes/代码世界模型与神经渲染/1-15_GameWM|GameWM]]（1-15）、[[topics/notes/代码世界模型与神经渲染/1-12_StreamRender-H3|StreamRender-H3]]（1-12）一样，都是"H3 Ref2VA + LoRA、不加控制分支"。
- **和 GameWM 的对照**：两篇都认为代理里的角色应该粗、细节交给视频先验（本文的 Skeleton 消融、GameWM 的胶囊体代理）。GameWM 把自由度用在"同一事件多种视觉实现"，本文用在"多视角外观一致"；两者都还不是实时。
- **单视角实时系统**：[[mirros/notes/01_AgentGarten|AgentGarten]]、[[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]]（1-11）、StreamRender-H3 都只渲一个视角，但已经做到块因果实时；本文反过来，先解决多视角一致，实时留给以后。
- **显式状态的多人世界**：[MASS](https://arxiv.org/abs/2608.06257)（逻辑引擎更新类型化状态 + 渲染引擎出各相机观测，本文最接近的同类）、[MultiGen](https://arxiv.org/abs/2603.06679)（外部关卡地图 + 玩家位姿）、[WorldCast](https://arxiv.org/abs/2610.12412)（依赖逐张地图的精细几何，作者因此没拿它当基线）。
- **隐空间协调的多人世界模型**：[Solaris](https://arxiv.org/abs/2602.22208)（Minecraft）、[ShareVerse](https://arxiv.org/abs/2603.02697)、[Gamma-World](https://arxiv.org/abs/2605.28816)（本文基线）、[MultiWorld](https://arxiv.org/abs/2604.18564)、[Prisma-World](https://arxiv.org/abs/2606.09507)、[MetaWorld](https://arxiv.org/abs/2606.02753)（双分支 + 跨注意力，本文消融的对照对象）。
- **外观记忆 / 跨视角一致的另一种做法**：[[topics/notes/代码世界模型与神经渲染/1-10_Mallea|Mallea]]（1-10）按物体身份存外观记忆；本文不存记忆，而是把两路参考放进同一注意力上下文。[[topics/notes/代码世界模型与神经渲染/1-04_ProgrammableWorldModel|Programmable World Model]]（1-04）的 OBB 也维护屏幕外实体，可以对照"共享状态"的表示方式。
- **评测**：[[topics/notes/代码世界模型与神经渲染/3-04_WorldDraft|WorldDraft]]（3-04）评"代码建世界、视频模型只渲染"时的属性绑定，本文的跨视角身份分可以看成多视角版本的属性绑定问题。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文是 CC BY 4.0，可转录，但这里仍只记位置和要点）
> 1. 第 1 页摘要 + §1 第 2 段：多人观测必须对共享实体一致；精细地图限制场景多样性，共享几何保证不了外观一致 → 要解决的问题
> 2. 第 1–2 页 §1 第 3–4 段：CWM、SolarRenderer 只研究单视角；独立生成的两个视角会给同一角色不同衣服 → 为什么要跨视角通信
> 3. 第 2 页 §1 第 5 段：用 MiniMax-H3 33B Ref2VA，沿宽度拼两视角，冻结骨干训 LoRA；对比 MetaWorld 的分支 + 跨注意力 → 方法核心
> 4. 第 3 页 §2 "Explicit State" 段末：渲染器只做条件观测合成，学动作驱动的状态转移不在范围内 → 没有编码智能体 / 状态转移
> 5. 第 4 页 §3.1 + 式 (1)：FiveM 私服录双人 GTA V，共享地图 + 各客户端实体观测 + 相机渲出无纹理代理 → 世界状态的来源
> 6. 第 5 页 §3.1 图 3：7,846 段约 5 秒；探索 66.4%、骑乘 18.7%、交互 9.8%、打斗 5.1% → 数据规模和构成
> 7. 第 5 页 §3.2 "Reference Conditioning"：参考和目标进同一全双向注意力，LoRA 加在注意力投影和 FFN → 条件注入方式
> 8. 第 6 页 §4.1：150 个用例，GPT Image 2.5 换风格；指标照 SolarRenderer；Qwen3.8-27B 判身份和动作 → 评测协议（及指标定义的疑点）
> 9. 第 7 页表 1 → 全部主结果数字
> 10. 第 8–10 页 §4.3、§5.2：Skeleton 过约束；50 步、8 步可行、1–2 步困难；只有两人 → 消融结论与局限

## 摘要（中文）

多人生成式世界模型必须在相机运动和遮挡各不相同的情况下，让各路观测对共享实体保持一致。显式的世界表示能提供空间控制，但对单张游戏地图做精确建模会限制场景多样性，而仅有共享几何又无法保证跨视角的外观一致。我们提出 CoCode-World，一个共享 3D 代理框架，在双人视频生成中把结构控制和视觉合成分开：可编程代理规定场景布局、运动和遮挡，RGB 参考图引导角色和场景外观。为了在玩家之间协调视觉细节，我们把成对的代理视频、外观参考和目标视图按一致的空间布局拼接起来，用一个预训练视频模型联合生成两个视角。这种表述在单一生成分支内利用模型原生的注意力完成跨视角通信，并通过 LoRA 适配从配对观测中学习对代理的遵循和外观对应。我们构建了一个双人 GTA V 数据集，把同步的 RGB 观测与由共享地图几何和游戏引擎状态得到的代理视频配对。实验表明，方法能把外观迁移到训练中未见过的角色和场景风格上，在视频质量和跨视角玩家身份上优于所评测的基线。消融实验进一步考察了代理的构造方式和跨视角通信方式对生成的影响。

## 摘要（原文）

论文以 CC BY 4.0 许可发布（[arXiv 摘要页](https://arxiv.org/abs/2611.15602)），以下按原文转录。作者：Qirui Li 等，"CoCode-World: Shared 3D Proxy Representation for Multi-Player World Models"，arXiv:2611.15602。

> Multiplayer generative world models must produce observations that agree on shared entities despite different camera motions and occlusions. Explicit world representations provide spatial control, but precise modeling of individual game maps limits scene diversity, while shared geometry alone cannot ensure consistent appearance across views. We present CoCode-World, a shared 3D proxy framework that separates structural control from visual synthesis for two-player video generation. Programmable proxies specify scene layout, motion, and occlusion, while RGB references guide character and scene appearance. To coordinate visual details across players, we concatenate paired proxy videos, appearance references, and target views in a consistent spatial layout and generate both views jointly with a pretrained video model. This formulation uses the model's native attention for cross-view communication within a single generation branch, with LoRA adaptation learning proxy adherence and appearance correspondence from paired observations. We construct a two-player GTA V dataset that pairs synchronized RGB observations with proxy videos derived from shared map geometry and game-engine state. Experiments demonstrate appearance transfer to characters and scene styles unseen during training, with improvements in video quality and cross-view player identity over the evaluated baseline. Ablations further examine how proxy construction and cross-view communication affect generation. Project page: https://iapple233.github.io/CCW/.
