---
id: "1-07"
org: 专题·代码世界模型与神经渲染
short: "Oneira"
title: "Oneira: From Open-Ended Generation to Open-World Interaction in Video World Models"
aliases: ["Oneira", "ONEIRA", "InteractionBench"]
date: 2026-10-01
category: "代码世界 + 视频渲染器（完整系统）"
venue: —
affiliation: "莫纳什大学 · 布里斯托大学 · 大连理工大学 · 香港中文大学（深圳） · 牛津大学"
authors: ["Xindi Yang", "Baolu Li", "Liam Lee", "Zhenfei Yin", "Songxin Zhang", "Zhuoyang Song", "Xu Jia", "Jianfei Cai", "Tien-Tsin Wong", "Bingyi Jing", "Mengyue Yang"]
arxiv: "2610.01614"
pdf: "[[topics/papers/代码世界模型与神经渲染/1-07_2610.01614_Oneira.pdf]]"
code: ""
project: "https://madaoer.github.io/projects/oneira/"
license: CC BY 4.0（arXiv 摘要页）
status: 未读
rating:
read_date:
tags: ["paper", "world-model", "interactive-video", "world-state", "coding-agent", "3d-bounding-box", "minimax-h3", "memory", "benchmark"]
---

# Oneira: From Open-Ended Generation to Open-World Interaction in Video World Models

> [!info] 论文信息
> arXiv [2610.01614](https://arxiv.org/abs/2610.01614) · 本地 PDF 是 v1（2026-10-01，目前也只有 v1）
> 单位：莫纳什大学（1，一作 Xindi Yang）、布里斯托大学（2，Mengyue Yang）、大连理工大学（3）、香港中文大学（深圳）（4）、牛津大学（5）· 通讯作者：Mengyue Yang（布里斯托大学）
> PDF：[[topics/papers/代码世界模型与神经渲染/1-07_2610.01614_Oneira.pdf|本地 PDF]]（19 页：正文第 1–10 页 + 参考文献第 10–13 页 + 附录 A–E 第 14–19 页：扩展相关工作、训练与渲染细节、数据细节、评测协议与 VLM 判官提示词、更多定性结果）
> 代码：论文说"将发布"，没有给仓库 · 项目页：[madaoer.github.io/projects/oneira](https://madaoer.github.io/projects/oneira/)
> 专题：[[topics/代码世界模型与神经渲染#一、代码世界 + 视频渲染器（完整系统）|代码世界模型与神经渲染 · 一、代码世界 + 视频渲染器（完整系统）]]

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-18）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。

## 一句话总结

在"从一张图出发的交互式视频世界模型"上加一张**显式世界状态表**：地面 + 每个物体的语义标签、3D 框中心与尺寸、偏航角、是否在位、交互状态（0/1/2 三档）。编码智能体（Claude Opus 4.8）读表和当前首帧，把动作或高层目标落实成"哪个实例、什么动作、第几块、相机停在多远、连带影响哪些物体"，确定性引擎把结果写回表，再用 OpenGL 渲成**粗条件视频**（照 Wonder 的环境球 + 立方格相机脚手架、地面网格、**按状态上色的物体框**，物体被拿走就删框）。MiniMax-H3 Ref2VA 加 rank-128 LoRA，吃首帧、条件视频、按状态过滤过的记忆帧和逐块字幕，生成 10 秒 832×480 片段。探索中新出现的物体会从生成画面里检测出来加进表，于是"生成出来的东西能被交互"（Open-World Interactivity），交互结果跨片段保留（Persistent State）。在自建的 InteractionBench 上 Interaction / Timing / Target 为 0.78 / 0.76 / 0.82（最好基线 0.49 / 0.57 / 0.53），记忆部分回访 PSNR 21.11 dB（基线最高 10.96）。

## 要解决什么问题

- 生成式世界一边走一边长，但**能交互的范围没有跟着长**：新合成的内容只存在于画面里，动作的效果只存在于最近的视觉上下文里。
- 作者提出"完整交互"需要两个性质：
  1. **Open-World Interactivity**：探索揭示或生成的新实体要变成之后动作的明确对象；
  2. **Persistent State**：交互结果要成为世界状态的持久部分，继续约束之后的观测和交互。
- 现有两类方法各缺一半：
  - 交互式视频世界模型（Genie 3、LingBot-World、YUME、ActWorld……）：控制越来越丰富，但状态隐式在像素、提示词、潜变量里，新物体不一定被登记成可操作实体，看起来合理的交互结果也不一定被"提交"。
  - 显式 3D 世界和仿真器：物体和状态可靠可改，但能交互的东西取决于预先搭好的几何、资产和逻辑。
- 所以缺的不只是"显式状态"，而是**能随生成世界一起增长的显式状态**。

## 方法

总览见 [[topics/papers/代码世界模型与神经渲染/1-07_2610.01614_Oneira.pdf#page=4|图 2（第 4 页）]]。四个组件：编码智能体 A、世界状态表 T、轻量引擎 E、预训练视频生成器 G。

作者把它对应到标准世界模型 s_k = f(s_{k−1}, a_k)，o_k ~ p(o | s_k)：**表 T_k 是显式状态 s_k，A + E 一起实现转移 f，G 是观测模型 p**。

### 世界状态怎么表示（§3.1–3.2，式 3）

T_k = (G_k, O_k)：

| 字段 | 含义 |
|---|---|
| G_k | 可行走地面 |
| ℓ_i | 语义标签 |
| c_i, s_i ∈ R³ | 世界坐标下 3D 框的中心与尺寸 |
| ψ_i | 偏航角 |
| ρ_i^(k) | 该物体是否在这个位姿上（被拿走就标为不在） |
| σ_i^(k) ∈ {0, 1, 2} | 交互状态。0 是默认，非默认状态的语义由配套文字说明；只用三档是因为一段生成视频很少清楚地展示两次以上状态变化 |

- 表里**不存外观**，只存与交互相关的几何和状态；外观和细节运动交给视频模型。

### 谁写"代码"、规则在哪（§3.2，式 4–7）

- **建表**：编码智能体从输入图识别与交互相关的物体并给初始状态；一个建表工具调现成感知模型恢复地面和每个物体的 3D 框。
- **规划**：给定动作或目标，智能体读上一张表和当前片段首帧，产出计划动作 P_k = (目标实例 i_k, 动作类别 α_k, 交互所在块 τ_k, 相机停止距离 d_k, 连带受影响物体集 A_k)；多个交互按状态依赖排序。
- **写回**：引擎把 P_k 映射成**确定性**转移 T_k = U(T_{k−1}, P_k)，只改目标和连带物体：留在原位的改 σ，离开原位的把 ρ 置为不在。表记录的是交互的**结果**，不规定运动轨迹；被移动的物体先"丢框"，静止后从生成画面里重新登记。
- **增长与保留**：每段生成完，从画面里检测新物体并入 O_k（式 7），表可以越长越大；之前改过的状态原样带到后面的片段。
- 和 CWM / PWM 的区别（附录 A 作者自己的说法）：那两篇是智能体**编写实体状态和转移规则**、玩家在里面行动；Oneira 的规则**固定在轻量引擎里**，编码智能体自己从目标出发去行动，决定哪个实例什么时候变。所以这里的"编码智能体"更像工具调用 + 规划，世界规则并不由它写（见"局限 / 存疑"）。
- 实验中智能体是 **Claude Opus 4.8**，所有动作都只根据首帧和动作文本规划（§4.1，第 7 页）。

### 引擎导出什么条件信号（§3.3、附录 B）

| 条件 | 内容 |
|---|---|
| 首帧 Î_0^(k) | 当前场景的局部外观；上一段最后一帧 |
| 粗条件视频 V_k | 照 Wonder：沿相机路径画**环境球 + 立方格**当相机脚手架（格距 1.5 m，两层，半径 6.6 m，带距离衰减）、地面网格（同格距，alpha 0.12）、表里每个物体的**实心框**（颜色编码状态，图 1 说紫色为默认、黄色为已改变）；物体不在位时不画框。OpenGL 渲染，448×256，每段光栅化约 9 s（主要花在读回像素和视频编码） |
| 记忆帧 M_k（可选） | 从之前看过的视角检索，只保留**物体状态与当前表一致**的帧，避免旧画面和新状态冲突 |
| 逐块字幕 c_k | 每块一句"动作 + 结果"（如"一只手拿起红苹果。""苹果离开了桌子。"）；全局字幕只描述场景，另含一段所有样本共享的固定说明，解释条件视频里每种元素、三种颜色、框消失的含义 |

### 渲染器骨干与条件注入（§4.1、附录 B）

| 项目 | 设置 |
|---|---|
| 骨干 | MiniMax-H3 **Ref2VA** |
| 微调方式 | DiT 注意力投影上加 **rank 128 LoRA** |
| 条件注入 | 首帧和条件视频走骨干的**参考输入**，用官方 packed-sequence builder 排在视频潜变量前面；全局字幕 + 8 条块字幕拼成一条文本序列，**块因果掩码**让第 c 块的视频 token 只看全局字幕和第 1…c 块字幕（照 LingBot-World-V2） |
| 片段长度 | 243 帧 → 72 个潜帧，每块 9 个潜帧，共 8 块；24 fps，约 10 秒 |
| 分辨率 | 条件视频 448×256，生成 832×480 |
| 训练 | 32 张 GPU（型号未写）、FSDP hybrid、每卡 1 段、学习率 1e-4；一半步数固定首帧（同推理），一半不固定以保留生成能力。训练总步数没写（需核对） |
| 推理时固定首帧 | 每个去噪步后把首个潜帧重置为 α·z_0 + (1−α)·ε，α = 0.999 |
| 流式 / 实时 | 按 10 秒片段串联；论文**没有**报告生成速度，不是实时系统 |

### 训练数据（§4.2、附录 C，[[topics/papers/代码世界模型与神经渲染/1-07_2610.01614_Oneira.pdf#page=8|图 4，第 8 页]]）

| 部分 | 来源 | 规模 |
|---|---|---|
| 交互片段 | 用**专有视频模型**合成的第一人称视频，12 种改变状态的动作；按动作、场景、交互开始的块均衡提示词 | 约 5,800 段（图 5：58%） |
| 导航片段 | Sekai 真实步行视频 + ABot 带相机位姿的游戏录像（后退、侧移几乎都来自游戏） | 约 4,200 段（42%），10 类相机运动各 10% |
| 带记忆帧的 | 同一地点的记忆帧 | 约 1K 段 |
| 合计 | 832×480、24 fps、10 秒 | 约 10K 段 |

- 12 类动作在交互片段中的占比（[[topics/papers/代码世界模型与神经渲染/1-07_2610.01614_Oneira.pdf#page=16|图 5，第 16 页]]）：射击 13.3%、砸碎 8.9%、拿起 8.8%、打开 8.8%、关闭 8.7%、冰霜灭火 8.6%、冻结 8.4%、工具灭火 8.3%、两步法术 7.7%、镀金 6.8%、隐身 6.3%、点燃 5.4%。
- 标注流水线：LingBot-Map（位姿、深度）、MoGe-2（米制尺度）、GeoCalib（重力方向）、SAM3（地面和命名物体掩码）、WildDet3D（世界坐标 3D 框），RANSAC 拟合地面；Gemini 3.7 Flash 逐块判断动作是否开始、目标是否离位、状态是否在变，再用固定规则拼出事件块、过渡窗口和字幕，所以字幕和条件视频"按构造一致"。
- 导航片段过滤：TransNetV2 去镜头切换、DOVER 去低质量、UniMatch 光流去运动过少/过多，再由 Gemini 排除眩光、黑屏、遮挡等；表里也放人和车的框（按拟合轨迹移动），字幕统一是"Nothing happens."

## 实验与关键数字

### InteractionBench（§4.1、附录 D）

- 100 个交互用例（单目标 50 个 + 多目标 50 个；多目标是五个相同物体，或两种各三个）+ 50 个记忆用例；首帧全由 GPT-Image-2 生成；12 类动作，每个交互用例一到两个动作。
- 记忆用例：两段共 20 秒，第一段做交互，第二段相机转开再回到交互后访问过的位姿。
- 指标：
  - Interaction：指定动作是否发生（Gemini 3.7 Flash 判，每块看 6 帧 + 上一块最后 2 帧，提示词见[[topics/papers/代码世界模型与神经渲染/1-07_2610.01614_Oneira.pdf#page=17|图 6，第 17 页]]）；
  - Timing：判官第一次看到动作开始的块是否就是指定块；
  - Target：在生成视频上重跑自己的数据流水线建表，看变了状态的实例是不是指定那个；
  - 记忆：同位姿的访问帧与回访帧算 PSNR / SSIM；State 问判官目标是否保持改变后的状态；
  - VBench 8 维（全部 150 个用例）。
- 基线输入：LingBot-World-V2、AlayaWorld 拿逐帧位姿；YUME 1.5 和 H3 Ref2VA 不吃位姿，相机运动按块写成文字；记忆部分 H3 Ref2VA 拿与 Oneira 相同数量的记忆帧。

### 主结果（[[topics/papers/代码世界模型与神经渲染/1-07_2610.01614_Oneira.pdf#page=8|表 1，第 8 页]]）

| 方法 | Interaction | Timing | Target | PSNR | SSIM | State | SC | BC | MS | TF | DD | AQ | IQ | OC |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| MiniMax-H3 Ref2VA | 0.30 | 0.57 | 0.53 | 10.96 | 0.34 | 0.68 | 0.83 | 0.90 | 0.99 | 0.97 | 1.00 | 0.53 | 0.73 | 0.19 |
| LingBot-World-V2 | 0.49 | 0.40 | 0.39 | 9.08 | 0.27 | 0.44 | 0.79 | 0.87 | 0.97 | 0.98 | 0.97 | 0.54 | 0.72 | 0.20 |
| YUME 1.5 | 0.05 | 0.43 | 0.22 | 10.09 | 0.35 | 0.41 | 0.83 | 0.89 | 0.99 | 0.97 | 0.95 | 0.52 | 0.74 | 0.20 |
| AlayaWorld | 0.08 | 0.16 | 0.26 | 9.19 | 0.30 | 0.39 | 0.79 | 0.88 | 0.99 | 0.95 | 0.65 | 0.49 | 0.69 | 0.18 |
| **Oneira** | **0.78** | **0.76** | **0.82** | **21.11** | **0.64** | **0.80** | 0.84 | 0.90 | 0.99 | 0.97 | 1.00 | 0.54 | 0.73 | 0.22 |

- Interaction、Timing、Target 是 100 个交互用例上的通过率；PSNR（dB）、SSIM、State 是 50 条记忆链上的。
- 正文说的提升都能从表里核对上：Interaction +0.29（对 LingBot 0.49）、Timing +0.19（对 H3 0.57）、Target +0.29（对 H3 0.53）；PSNR +93%（21.11 / 10.96）、SSIM +83%（0.64 / 0.35，YUME）、State +18%（0.80 / 0.68）。
- VBench 上 Oneira 和基线基本持平；正文说主体一致性 +2.14%、整体一致性 +8.58%、运动平滑度最高，按的是未四舍五入的分数（表里 MS 都是 0.99）。
- 三个基线的 Timing 高于 Interaction：它们常在指定块里"做了点什么"，但做错了动作或改错了实例。

### 消融（[[topics/papers/代码世界模型与神经渲染/1-07_2610.01614_Oneira.pdf#page=9|表 2，第 9 页]]，交互部分）

| 变体 | Interaction | Timing | Target | RotErr（°）↓ | TransErr ↓ |
|---|---|---|---|---|---|
| 去掉环境球和立方格 | 0.63 | 0.69 | 0.62 | 3.32 | 0.20 |
| 去掉物体框 | 0.61 | 0.74 | 0.61 | 2.78 | 0.15 |
| 去掉逐块字幕（时间写进全局字幕） | 0.73 | 0.66 | 0.80 | 2.71 | 0.15 |
| 完整 | **0.78** | **0.76** | **0.82** | **2.60** | **0.13** |

- 相机误差用 Pi3X 估位姿，Umeyama Sim(3) 对齐，照 SANA-WM 的协议。
- 去掉脚手架：相机运动变模糊，连带交互分数下降；去掉框：只能靠文字挑实例，Target 掉到 0.61；去掉块字幕：Timing 掉到 0.66。

### 定性（第 7 页图 3、第 18–19 页图 7–8）

- 30 秒三段链：Oneira 在指定块里灭火、给苹果镀金，相机转回来两者都还在；H3 Ref2VA 状态保住了但镀金晚一块、场景变了；LingBot-World-V2 和 YUME 1.5 没灭火、场景也变了。
- 图 7：目标不在首帧里，第一段探索时出现，智能体登记后第二段对它交互（射花瓶、镀金石球、冰冻传感器球）。
- 图 8：一排相同物体里按位置指定其中一个；Oneira 只改目标，基线改错或改多个，有两个基线连队列布局都丢了。

## 局限 / 存疑

- **作者承认的**（§5）：动作空间是离散的 12 类；复杂交互的物理真实性受视频模型学到的动力学限制，没有物理仿真器；长时视觉一致性仍受生成器限制。
- **"编码智能体"的作用比名字小**：规则固定在引擎里，Φ_α 只做"改状态 / 删框"；智能体做的是感知、实例落地、排期，而不是编写世界规则或新动作。和 CoDeR、CWM 那种"智能体写世界代码"不是一回事，专题里归类时需要注意。
- **训练交互全是合成的**：约 5,800 段交互视频由"专有视频模型"生成，用的哪家模型没写；它能学到的交互种类和质量受这些模型限制。12 类动作里有不少是"法术"类（镀金、隐身、冰霜），偏向视觉上好判定的状态变化。
- **评测与训练流水线同源**：Target 指标是在生成视频上**重跑自己的数据标注流水线**来判断哪个实例变了；Interaction / Timing 由与标注同一个 Gemini 3.7 Flash 判。这种设置可能偏向 Oneira（它的训练标签就是这么来的）。基线只能从文字里得知目标实例，Oneira 还额外拿到画在条件视频里的目标框，Target 上的差距一部分来自输入信息不对等。
- **记忆指标混了相机控制**：H3 Ref2VA 没有相机控制，回访帧根本不在同一位姿，PSNR 低主要不是因为"忘了"；正文也承认这一点。State 指标上 H3 Ref2VA 已有 0.68，Oneira 是 0.80，差距比 PSNR 小得多。
- **数字小出入**：§4.2 说约 60% 交互、40% 导航；附录 C.2 和图 5 是约 5,800 / 4,200，即 58% / 42%。
- **三档状态的颜色**：图 1 只说紫色为默认、黄色为已改变，附录 B 说全局字幕解释"三种颜色"，第三种颜色（状态 2）是什么正文和图 1、图 2 都没有展示（需核对）。
- **没写的复现信息**：训练步数、GPU 型号、生成一段的耗时、智能体每步的调用开销都没有；代码"将发布"。
- **用例规模小**：交互 100 个、记忆 50 个，没有置信区间；首帧都是 GPT-Image-2 生成的，没有真实照片场景的结果。

## 与其他论文的关系

- **作者自己划的两个近邻**（附录 A，第 14 页）：[[topics/notes/代码世界模型与神经渲染/1-01_CodeWorldModel|CWM]] 用编码智能体通过代码维护状态并编译成代理视频；[[topics/notes/代码世界模型与神经渲染/1-04_ProgrammableWorldModel|Programmable World Model]] 把状态增强的 3D 框编译成渲染器的控制。两者都是智能体写实体状态和转移规则、玩家在世界里行动；Oneira 规则固定，智能体从目标出发行动，只针对第一人称交互引起的物体状态变化，并用"删框 / 改色"表达。和 PWM 的中间表示最像（都是 3D 框 + 状态），区别是 Oneira 的框颜色直接编码离散状态、表可以从生成画面里增长。
- **同用 MiniMax-H3 的**：[[topics/notes/代码世界模型与神经渲染/1-05_CoDeR|CoDeR]]（白盒视频 + 深度，LoRA + ControlNet）、[[topics/notes/代码世界模型与神经渲染/1-12_StreamRender-H3|StreamRender-H3]]（语义图，Ref2VA，流式两步）、[[topics/notes/代码世界模型与神经渲染/2-09_SolarRenderer|SolarRenderer]]（结构视频走 H3 参考通路 + LoRA，与 Oneira "条件视频走参考输入" 的做法相近）、[[topics/notes/代码世界模型与神经渲染/1-15_GameWM|GameWM]]。专题清单第四节的 MiniMax-H3 条目列了"都用它当渲染器"的工作，没有列 Oneira。
- **外观记忆的三种做法**：[[topics/notes/代码世界模型与神经渲染/1-05_CoDeR|CoDeR]] 把生成画面反投影注册到白盒表面；Oneira 检索记忆帧并按当前物体状态过滤；[[topics/notes/代码世界模型与神经渲染/1-10_Mallea|Mallea]] 按物体身份存纹理，物体变了就作废（Mallea 正文把 Oneira 列为"按当前物体状态过滤历史帧"的先例）。
- **"交互细节交给视频模型"**：Oneira 的表只记交互结果、不记运动轨迹，物体被移动时先删框、静止后再登记，细节运动由生成器补。[[topics/notes/代码世界模型与神经渲染/1-15_GameWM|GameWM]] 把这一思路推得更远：引擎只算准事件，视频模型生成交互的视觉实现。
- **实时系统的对照**：[[mirros/notes/01_AgentGarten|AgentGarten]]、[[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]]、[[topics/notes/代码世界模型与神经渲染/1-12_StreamRender-H3|StreamRender-H3]] 都追求实时；Oneira 是 10 秒一段的离线生成，重点在交互正确性而非速度。
- **条件视频的设计来源**：[Wonder](https://arxiv.org/abs/2607.26037)（环境图 + 合成立方格让模型把相机运动当视觉证据）；逐块字幕和块因果文本掩码来自 LingBot-World-V2（[Infinite Worlds with Versatile Interactions](https://arxiv.org/abs/2607.07534)）。
- **结构条件渲染器**：附录 A 提到 G-buffer（DiffusionRenderer、[[topics/notes/代码世界模型与神经渲染/2-06_AlayaRenderer-Flash|AlayaRenderer]] 的前身 Generative World Renderer）、粗 3D 代理（Coarse-to-Real），它们只表达几何、布局、视角，没有物体状态，Oneira 在框的颜色上加了状态。
- **基线**：[LingBot-World-V2](https://arxiv.org/abs/2607.07534)、[YUME 1.5](https://arxiv.org/abs/2512.22096)、[AlayaWorld](https://arxiv.org/abs/2607.06291)。
- **评测路线**：[[topics/notes/代码世界模型与神经渲染/3-04_WorldDraft|WorldDraft]] 和 PROWBench（Mallea 引用）都在评"视频模型是否渲染出程序规定的状态和事件"，与 Oneira 的 Target / State 指标是同一类问题。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文是 CC BY 4.0，这里仍只记位置和要点，原句请点页码看）
> 1. 第 2 页 §1 第 2 段：开放生成不等于完整交互；Open-World Interactivity 与 Persistent State 两个性质 → 要解决的问题
> 2. 第 2 页 §1 第 3 段：显式 3D 世界可靠但交互范围取决于预制资产；缺的是能随世界增长的显式状态 → 动机
> 3. 第 4–5 页 §3.1 式 1–2：表 = 状态，智能体 + 引擎 = 转移，生成器 = 观测模型 → 整体分工
> 4. 第 5 页 §3.2 式 3：地面 + 标签、框中心尺寸、偏航、在位、三档状态 → 世界状态表示
> 5. 第 5 页 §3.2 式 4–6：计划动作五元组；确定性局部更新；移动物体先删框 → 谁决定什么
> 6. 第 6 页 §3.3：照 Wonder 画环境球与立方格、地面网格、按状态上色的框；记忆帧按状态过滤 → 条件信号
> 7. 第 6–7 页 §4.1 与第 15 页附录 B：H3 Ref2VA + rank 128 LoRA、448×256 条件、832×480 输出、Claude Opus 4.8、OpenGL、243 帧 / 72 潜帧 / 8 块、块因果字幕掩码 → 骨干与条件注入
> 8. 第 8 页表 1、第 9 页表 2 及第 8–9 页 §4.3 的增量说明 → 关键数字
> 9. 第 14 页附录 A "Abstract and explicit world state"：与 CWM、PWM 的区别是规则固定、智能体从目标出发行动 → 与专题其他工作的关系
> 10. 第 9–10 页 §5：动作空间离散、物理真实性受视频模型限制 → 局限

## 摘要（中文）

生成式视频世界模型如今已能合成开放式环境，供智能体以简单方式导航和交互。但开放式生成不等于完整交互：随着生成世界的扩展，通过导航新创造出的内容应当扩大智能体可以作用的范围；随着智能体改变世界，这些改变应成为环境的持久部分，而不是转瞬即逝的视觉效果。我们把这两个要求刻画为开放世界交互性（新生成或新遇到的实体被纳入可操作的世界）和持久状态（交互结果被提交到世界状态，并持续影响后续的观测与交互）。我们提出 ONEIRA，一个交互式视频世界模型，通过由编码智能体管理的显式、可扩展世界状态，闭合生成与交互之间的回路。给定当前观测以及一个动作或高层目标，智能体读取世界状态、定位相关实体、规划交互，并把结果写回世界状态表。当探索揭示新物体时，智能体从生成的观测中把它们纳入，使交互空间随生成的世界一起扩展。同时，之前引起的状态变化会跨视频片段延续，使交互的后果成为后续世界演化的持久部分。更新后的世界状态沿相机动作轨迹渲染成粗条件视频，视频生成器据此补全状态中没有表示的外观、运动和交互细节。实验表明，ONEIRA 能与新生成的物体直接、一致地交互，并在长时间跨度上保持先前交互的效果。

## 摘要（原文）

以下按 CC BY 4.0 许可转录自 arXiv 2610.01614（Yang et al., 2026）：

Generative video world models can now synthesize open-ended environments that agents can navigate and interact with in simple ways. Yet open-ended generation does not imply full interaction: as a generated world expands, newly created content through navigation should expand what the agent can act upon, and as the agent changes the world, those changes should become persistent parts of the environment rather than transient visual effects. We characterize these two requirements as Open-World Interactivity, where newly generated or encountered entities are incorporated into the actionable world, and Persistent State, where interaction outcomes are committed to the world state and continue to influence subsequent observations and interactions. We present ONEIRA, an interactive video world model that closes the loop between generation and interaction through an explicit, extensible world state managed by a coding agent. Given the current observation and an action or high-level goal, the agent reads the world state, grounds the relevant entities, plans the interaction, and writes its outcome back into a world state table. When exploration reveals new objects, the agent incorporates them from generated observations, allowing the interaction space to expand with the generated world. Meanwhile, previously induced state changes are carried across video segments, making the consequences of interaction persistent parts of subsequent world evolution. The updated world state is rendered along the camera action trajectory into a coarse conditioning video, from which a video generator fills in the appearance, motion, and interaction details not represented in the state. Experiments show that ONEIRA enables direct and consistent interaction with newly generated objects, while preserving the effects of prior interactions over long horizons.
