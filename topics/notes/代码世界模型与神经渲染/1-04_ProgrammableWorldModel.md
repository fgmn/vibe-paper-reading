---
id: "1-04"
org: 专题·代码世界模型与神经渲染
short: "PWM"
title: "Programmable World Model"
aliases: ["PWM", "Programmable World Model", "可编程世界模型", "CombatStateBench"]
date: 2026-09-09
category: "代码世界 + 视频渲染器（完整系统）"
venue: —
affiliation: "Alaya Lab（另有 3 位作者论文未标单位）"
authors: ["Zheng-Hui Huang", "Guixu Lin", "Jiacheng Lin", "Yi-Chuan Huang", "Ruihan Yu", "Muyao Niu", "Siqi Yang", "Yu-Lun Liu", "Yung-Yu Chuang", "Kaipeng Zhang", "Zhixiang Wang"]
arxiv: "2609.10540"
pdf: "[[topics/papers/代码世界模型与神经渲染/1-04_2609.10540_ProgrammableWorldModel.pdf]]"
code: "https://github.com/AlayaLab/pwm"
project: "https://alaya-lab.github.io/pwm"
license: CC BY 4.0（arXiv 摘要页）
status: 未读
rating:
read_date:
tags: ["paper", "world-model", "code-world", "coding-agent", "neural-rendering", "3d-bounding-box", "controlnet", "explicit-state", "benchmark"]
---

# Programmable World Model

> [!info] 论文信息
> arXiv [2609.10540](https://arxiv.org/abs/2609.10540) · 本地 PDF 是 v2（2026-10-13）；v1 是 2026-09-09（PDF 首页日期也写 9 月 9 日）
> 单位：Alaya Lab（11 位作者里 8 位标了 Alaya Lab；Jiacheng Lin、Yu-Lun Liu、Yung-Yu Chuang 没标单位，需核对）· 共同一作：Zheng-Hui Huang、Guixu Lin · 通讯作者：Zhixiang Wang（项目负责人）、Kaipeng Zhang
> PDF：[[topics/papers/代码世界模型与神经渲染/1-04_2609.10540_ProgrammableWorldModel.pdf|本地 PDF]]（17 页：正文 15 页 + 参考文献约 2.5 页，没有附录）
> 代码：[AlayaLab/pwm](https://github.com/AlayaLab/pwm) · 项目页：[alaya-lab.github.io/pwm](https://alaya-lab.github.io/pwm) · 基准页：[alaya-lab.github.io/PROWBench](https://alaya-lab.github.io/PROWBench)
> 专题：[[topics/代码世界模型与神经渲染#一、代码世界 + 视频渲染器（完整系统）|代码世界模型与神经渲染 · 一、代码世界 + 视频渲染器（完整系统）]]

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-18）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。
> 本地环境没有 poppler，PDF 是用 macOS PDFKit 抽文字读的，**图（图 1–5）只看了图注和抽出来的图内文字，没看图像本身**。

## 一句话总结

Alaya Lab（AlayaRenderer 同组）的"代码世界 + 生成渲染器"：给一张参考图和一段自然语言，3D 检测器先恢复实体的 **3D 有向包围盒（OBB）**，VLM 编码智能体再写出世界程序（实体的血量、阵营、状态，`on_hit: hp -= damage` 这类规则，胜负条件）；轻量引擎按规则推进**显式规范状态**（含画面外实体和血量、背包这类非视觉属性）；确定性的状态编译器把 OBB 沿目标相机投影，栅格化成三张像素对齐的控制图——**身份槽嵌入、语义文本嵌入、7 类相机系运动方向嵌入**——经一个可训练的 ControlNet 注入**冻结的 LingBot-World-v1**（相机通路沿用原模型），再用分块自回归 + 多尺度时间历史 + AlayaWorld 的几何对齐空间记忆做长视频。训练数据是无 HUD 的《赛博朋克 2077》《极限竞速：地平线 6》《GTA V》录像，经 ViPE + Qwen3-VL + SAM 3 + WildDet3D 自动标注。在自建的 50 段 **CombatStateBench** 上，用 Qwen3.6-27B 当裁判：存活人数准确率 **94%**、死亡状态准确率 **98%**，LingBot-World-V2 是 40.75% / 8%，YUME 是 32% / 58%。

## 要解决什么问题

作者列了视频世界模型当"交互世界引擎"缺的三样东西（[[topics/papers/代码世界模型与神经渲染/1-04_2609.10540_ProgrammableWorldModel.pdf#page=2|第 2 页]]）：

1. **不能逐个寻址实体**：控制接口主要是相机、动作、高层提示词。
2. **没有显式、持久的全局状态**：画面外的实体、背包、任务进度、交互历史无处存放，多人世界尤其需要。
3. **规则不可编程**：提示一个结果不等于建立了一条之后一直生效的可执行规则（比如门在什么条件下开、一次交互怎样影响别的实体）。

核心问题被表述为：**什么样的中间表示既能被程序直接编辑和演化，又保留视觉生成需要的空间和语义结构？**

### 表示的取舍（§2，[[topics/papers/代码世界模型与神经渲染/1-04_2609.10540_ProgrammableWorldModel.pdf#page=3|图 2，第 3 页]]）

这一节是全文最有价值的论述，单独记一下：

- 表示从轻到重排成谱系：文字 → 3D 包围盒 → 粗 3D 代理 → 完整 3D 场景（/ G-buffer、关节模型、动态 3D 几何）。越重，控制越强，但**数据获取越难**、**训练–推理不匹配越大**。
- 文字给不了几何约束；2D 框和掩码是图像空间的，随视角变，不能跨视角确定性重投影。
- **训练–推理不对称**（公式 1、2）：训练时动态已经发生，表示是从"已实现的动态"里**抽取**的；推理时却要从高层状态转移**主动生成**表示再交给生成模型。例子：指定"角色倒下"很简单，但要生成倒下过程的身体姿态和肢体轨迹就是动画 / 物理仿真问题了。表示越细，系统越是从"说明世界里**什么**变了"滑向"说明它**怎样**在几何和动力学上展开"。
- 结论：只显式表示**实体持久性、世界空间一致性、状态相关变化**所必需的结构，形状、纹理、材质、关节运动、局部形变、光照、次级运动交给预训练视频模型补。于是选**带状态的 3D OBB**。

## 方法

整体结构见 [[topics/papers/代码世界模型与神经渲染/1-04_2609.10540_ProgrammableWorldModel.pdf#page=6|图 3（第 6 页）]]，三段：①世界编程 ②控制编译 ③生成渲染。交互循环（公式 3）：

$s_t \xrightarrow{F,\,a_t} s_{t+1} \xrightarrow{P,\,C_{t+1}} M^{ctrl}_{t+1} \xrightarrow{G} I_{t+1}$

$F$ 是引擎的状态转移，$P$ 是确定性状态编译器，$G$ 是生成渲染器。

### 世界状态怎么用代码表示（§4.2）

- 规范状态 $s_t = (E_t, A_t, Q_t; R_t)$：
  - $E_t$：持久实体和它们的 3D 姿态（每个实体一个 OBB：位置、尺寸、朝向）；
  - $A_t$：语义和功能属性（身份、类别、血量、阵营……）；
  - $Q_t$：实体间关系（敌对、拥有）；
  - $R_t$：可执行规则。
- 图 1 / 图 3 里的示意程序：实体 `cover_01: pos, collision: solid, interaction: cover`，规则 `on_hit: hp -= damage`、`on_hp_zero: status = down`、`win: all_enemies_defeated`、`lose: player.hp <= 0`。状态模式（state schema）是 Transform · OBB · HP · status。
- **初始化**：一个现成的 3D 检测器从初始观测 $I_0$ 恢复可见实体的 OBB 和持久 ID（得到 $E_0$）；其余属性、关系、规则由智能体编排器根据玩家的自然语言描述写成"引擎可读的世界程序"，通过持久 ID 绑定到检测到的实体，还可加全局约束、事件触发器、任务目标。
- **执行**：$s_{t+1} = F(s_t, a_t)$。每步检查动作合法性 → 应用效果 → 解决触发的事件；变化可以涉及实体、属性、关系，**甚至规则集本身**。血量、背包、阵营这类不可见变量由引擎显式维护。
- 作者强调这是一个"轻量盒子世界"：不做带精细 3D 资产和底层仿真逻辑的常规游戏。

### 引擎导出什么条件信号（§4.3）

编译器 $M^{ctrl}_{t+1} = P(s_{t+1}, C_{t+1})$ 只挑需要空间落地的属性，把 OBB 投到目标相机下，在投影区域上栅格化三张图，按通道拼接：

| 控制图 | 内容 | 嵌入来源 | 作用 |
|---|---|---|---|
| 身份图 $M^{id}$ | 每个持久实体分配一个**固定的身份槽** | $K$ 个可学习身份嵌入（$K$ 没给） | 跨时间的实例对应，遮挡或出画再入画后保持外观；作者称它是"与外观参考相关联的空间键" |
| 语义图 $M^{sem}$ | 实体类别 | 预训练文本编码器编码语义标签（哪个编码器没说） | 类别信息；对初始画面里没有、缺少外观参考的实体尤其有用 |
| 方向图 $M^{dir}$ | 实体**自身**运动方向，量化成 7 类：前、后、左、右、静止、上、下 | 7 个可学习嵌入 | 用引擎里的世界空间速度旋到相机系计算，**不是**图像空间位移，所以相机动而物体不动时仍是"静止"，帮渲染器区分物体运动和相机运动 |

- 训练时每个样本的实体随机分配不同的身份槽，但同一序列内固定，防止某个槽和特定类别、外观、视角绑死；推理时每个持久实体的槽在整个交互中不变。
- 背景位置填零；投影框重叠时按深度保留可见实体（z-buffer）。
- 相机轨迹**单独**走骨干原有的相机条件通路，不进控制图。

### 渲染器骨干与条件注入（§4.4.1）

- **骨干：LingBot-World-v1**（参考文献 [18] "Advancing open-source world models"，arXiv 2601.20540），自带相机条件模块。
- **注入：可训练的 Structured Spatial ControlNet**。图 3 显示是复制的 DiT block × N/2（主干 N 个 block）。控制序列编码到视频潜变量的空间分辨率，与带噪潜变量一起进 ControlNet，逐层输出控制特征，投影到主干维度后**加到**对应主干 block 上：$h^{(\ell)}_{main} \leftarrow h^{(\ell)}_{main} + r^{(\ell)}$。
- **训练时主干（含相机通路）冻结**，只训 ControlNet 分支（参数 $\phi$）。
- 单窗口：$I_{1:T} = G_{\theta,\phi}(I_0, \mathcal{C}, M^{ctrl}_{1:T})$。

### 流式 / 长视频与记忆（§4.4.2）

- **分块自回归**：块内双向去噪，块间因果传递。第 1 块走原有的图生视频通路，从 $I_0$ 初始化，没有历史和空间记忆；之后每块额外接收时间历史 $H_{temp}$ 和空间记忆 $H_{spa}$（参数 $\psi$ 也要训练）。
- **时间历史**：有界的潜变量历史，分**近 / 中 / 远**三档，越远的块越粗的时空分辨率；另外**永久保留 $I_0$ 的潜变量当锚**。训练时历史来自原视频前面的帧，并随机加噪、特征破坏、部分丢弃，让模型容忍自回归误差。
- **几何对齐空间记忆**：直接沿用 [AlayaWorld](https://arxiv.org/abs/2607.18367) 的机制——已生成的 RGB 帧用估计深度和相机参数抬到世界空间，生成新块前检索相关的过往观测、重投影到目标视角，编码成空间潜 token。图 3 里两者通过"Memory-Augmented Self-Attention"（当前块 token + 时间历史 token + 空间记忆 token）进入主干。
- 块长 $L$、窗口帧数 $T$、去噪步数、分辨率、速度都**没有给**。论文没有声称实时。

### 训练数据管线（§4.5、§5.1）

| 步骤 | 工具 | 输出 |
|---|---|---|
| 相机估计 | ViPE | 内参、位姿、度量深度 |
| 语义类别发现 | Qwen3-VL 智能体 | 全局描述 + 可数物体类别词表（也可换成预定义词表） |
| 实例分割与跟踪 | SAM 3 | 时序关联的掩码、2D 框、语义标签、持久轨迹 ID；可见面积太小的掩码丢掉 |
| 物体轨迹恢复 | WildDet3D（2D 框 + RGB + 度量深度 + 内参） | 每帧 3D OBB $(p, d, R, \ell, k)$，用位姿转到共享世界坐标，同 ID 连成轨迹 |
| 运动方向 | 相邻帧世界坐标框中心的位移 → 转到当前相机系 → 量化 7 类，小位移阈值判静止 | 方向标签 |
| 控制图生成 | 投影 + z-buffer 栅格化 | 身份、语义、方向三张图；相机轨迹单独给渲染器 |

- 视频来源：**无 HUD 的《赛博朋克 2077》（第一人称）、《极限竞速：地平线 6》《GTA V》（第三人称，多种机位）**。
- 注意和 CWM 的区别：这里**不读游戏运行时状态**，全部从视频里估出来，所以原则上能用到任意野外视频（作者把它列为贡献之一）。
- 数据规模（小时数、片段数）、训练步数、算力**都没有给**。

## 实验与关键数字

### CombatStateBench（§5.1）

- 50 段受控的战斗片段。每个场景由数据管线从首帧重建 3D 布局（实体、3D 框、语义、相机），AI 智能体根据初始布局和提取的游戏规则**自动演化**一段短战斗，得到完整的盒子世界状态序列。覆盖相机运动和实体运动的多种组合，包括**开始时在画面外的实体**；死亡后目标保持在场景里。
- 自动校验器检查首帧重投影、度量深度一致性、框几何、接地、时间连续性、规定的相机和实体运动、状态转移持续性，全部通过才保留。
- 基线：LingBot-World-V2（[5]，"Infinite worlds with versatile interactions"）和 YUME（[15]）。两者没有外部实例级状态接口，所以用**切换提示词**传达状态转移：`{环境描述}. {动作描述}.`，比如某个 NPC 被杀时把动作描述换成让模型渲染这一事件。
- 裁判：**Qwen3.6-27B**，只看生成的 RGB 帧，不给真值框、身份、期望人数、死亡位置。
- **Count Accuracy**：每段随机采 8 帧（共 400 帧），VLM 数"可见的活着的角色"，和引擎记录的可见存活数比是否完全相等。
- **State Accuracy**：每个死亡事件（共 50 个）在转移后均匀采 3 帧，问 VLM 是否至少有一帧画出了死去的角色；不要求认出是谁死、在哪死。

### 主表（[[topics/papers/代码世界模型与神经渲染/1-04_2609.10540_ProgrammableWorldModel.pdf#page=12|表 1，第 12 页]]，单位 %）

| 方法 | Imaging | Subject Cons. | Background Cons. | Temporal Stability | Count Acc. | State Acc. |
|---|---|---|---|---|---|---|
| LingBot-World-V2 | 67.46 | 81.87 | 91.89 | 96.85 | 40.75 | 8.00 |
| YUME | 64.10 | 92.35 | 93.63 | 98.76 | 32.00 | 58.00 |
| **Ours** | **67.62** | **94.74** | **96.98** | **99.00** | **94.00** | **98.00** |

- 前四列是 VBench 指标（Temporal Stability 用 VBench 的时间闪烁分，越高越少闪）。
- 正文给的差值都和表对得上：Count Acc. 比 LingBot-World-V2 高 53.25、比 YUME 高 62.00；State Acc. 高 90.00 / 40.00；Subject Cons. 高 12.87 / 2.39；Background Cons. 高 5.09 / 3.35（第 14–15 页）。
- 画质（Imaging）只比 LingBot-World-V2 高 0.16，基本持平；明显的提升都在状态一致性上。

### 定性（[[topics/papers/代码世界模型与神经渲染/1-04_2609.10540_ProgrammableWorldModel.pdf#page=12|图 4]]、[[topics/papers/代码世界模型与神经渲染/1-04_2609.10540_ProgrammableWorldModel.pdf#page=13|图 5，第 13 页]]）

- 图 4：静止相机和运动相机 + 运动实体两种设置下的死亡交互。作者描述的基线失败：该活着的角色消失、被杀的角色继续动、可见人数无故变化。
- 图 5 五个例子：
  - (a) 新的牛头人（minotaur）场景，动态相机和实体；
  - (b) 大角度转相机，**正确渲出最初在首帧视野背后的三个角色**——这是"画面外实体由引擎维护"的直接演示；
  - (c) 赛车游戏，相机和车辆都在动；
  - (d) 人和车辆同场；
  - (e) **897 帧**的自回归序列，许多 NPC 陆续进场。
  - (b)(e) 的首帧取自训练没见过的 GTA V 数据，(a)(c)(d) 的首帧由 GPT Image 2 生成。

## 局限 / 存疑

论文**没有局限一节**，下面都是读的时候发现的：

- **对比方式偏向自己**：基线没有实例级接口，只能靠切换提示词传达"某人死了"，而本方法直接拿到逐帧的投影框和身份图。Count / State Accuracy 测的正是"有没有显式结构条件"，作为"显式状态比隐式状态可靠"的证据成立，但不能理解成渲染器本身更强。没有和其他结构条件渲染器（CWM 式代理视频、Coarse-to-Real、AlayaRenderer 的 G-buffer）比。
- **没有任何消融**：身份图 / 语义图 / 方向图各自贡献多少、空间记忆和时间历史各自的作用、OBB 与更细表示（论文 §2 花了大篇幅论证的取舍）的实际对比——都没有实验，§2 的论证目前只是论述。
- **训练细节几乎全缺**：数据规模、分辨率、块长、去噪步数、训练步数和算力、身份槽数量 $K$、语义文本编码器是哪个、生成速度都没写。ControlNet 和跨块记忆参数 $\psi$ 是一起训还是分阶段训也没说（需核对代码）。
- **"编码智能体"几乎没描述**：图 1 写 coding agent，正文写 "VLM-based coding agent" / "agent orchestrator"，但用的是哪个模型、引擎用什么语言写、程序格式长什么样，只有图里的伪代码。基准里的战斗由"AI 智能体自主演化"，同样没说是谁。
- **外观怎么跟着身份走没说清**：引言说 OBB 增广了"外观信息"，身份图被称为"与外观参考相关联的空间键"，但控制图里没有外观通道，外观参考只有首帧 $I_0$。对首帧里没有的实体（比如图 5b 背后的三个角色、5e 陆续进场的 NPC），外观来自哪里——只靠语义文本嵌入？——论文没说。
- **评测很宽松，也小**：50 段、50 个死亡事件；State Accuracy 只问"三帧里有没有一帧有死人"，不管是不是该死的那个；Count Accuracy 依赖 VLM 数人的准确率，而裁判本身的误差没有报告。作者自己也说这两个指标"宽松、全局"。
- **基准名字不一致**：论文正文叫 CombatStateBench，首页给的基准链接却是 `PROWBench`（需核对是否是同一个基准改名或更大的集合）。
- **没有引用 CWM**：作为两周后出现的同类工作，参考文献里没有 Code World Model（2608.25927），相关工作只对比了 StatePlay、MASS 和生成式渲染。v2（10 月）也没补上。
- **不实时**：主干是 LingBot-World-v1 + ControlNet（双向块内去噪），没有蒸馏、没有报速度，和专题里后来的 AgentGarten、StreamRender-H3、Matrix-Game 4.0 不在一个维度上。
- **作者单位**：3 位作者（Jiacheng Lin、Yu-Lun Liu、Yung-Yu Chuang）没标单位（需核对；后两位在 Generative World Renderer 里也是合作者）。

## 与其他论文的关系

- **和 [[topics/notes/代码世界模型与神经渲染/1-01_CodeWorldModel|CWM]] 的对照**（同一范式的两种做法）：
  - 中间表示：CWM 是稠密的代理视频（对数深度 + 语义 ID，1/4 分辨率），本文是 OBB 投影后的身份 / 语义 / 方向嵌入图，更粗；两篇都在讨论"条件带宽 / 表示取舍"，结论都是"只给最小必要结构，细节交给视频先验"，本文把它写得更系统（训练–推理不对称）。
  - 数据：CWM 从游戏**运行时**同步录状态（157 段 GTA V），本文从**纯视频**用 ViPE + SAM 3 + WildDet3D 估出来，规模可扩到野外视频，但标注更噪。
  - 骨干与注入：CWM 是 MiniMax-H3 Ref2VA + 全 block LoRA；本文是冻结的 LingBot-World-v1 + ControlNet，保留原相机通路。
  - 记忆：CWM 只有重叠帧 + 首帧锚；本文有多尺度时间历史 + 几何对齐空间记忆 + 身份槽，能演示画面外实体转过来时被正确渲出。
  - 评测：CWM 没有任何数字；本文有一个专门的状态一致性基准。
- **同组工作**：[Generative World Renderer](https://arxiv.org/abs/2604.02329)（AlayaRenderer，5 通道 G-buffer）、[[topics/notes/代码世界模型与神经渲染/2-06_AlayaRenderer-Flash|AlayaRenderer-Flash]]（实时化）、[AlayaWorld](https://arxiv.org/abs/2607.18367)（本文空间记忆的来源）。本文在 §2 把自家的 G-buffer 路线放在谱系"太重"的一端——同一组从稠密 G-buffer 走到了 OBB。
- **显式状态世界模型**：StatePlay（论文参考文献没给 arXiv 号；联合预测画面和游戏状态，状态由模型预测，会累积误差）、MASS（权威共享状态 + 分离的视图渲染，但状态由学习的 Logic Engine 推进）。本文的区别是状态转移由显式规则执行，可编程、可验证。
- **专题里的其他系统**：
  - [[topics/notes/代码世界模型与神经渲染/1-07_Oneira|Oneira]]（显式世界状态表）和本文最像，都强调新实体纳入可操作世界、交互结果持久写入状态；
  - [[topics/notes/代码世界模型与神经渲染/1-10_Mallea|Mallea]] 按物体身份存外观记忆，正好对应本文"身份槽有了、外观从哪来没说清"的缺口；
  - [[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]] 用低模代理，比 OBB 细一档；[[topics/notes/代码世界模型与神经渲染/1-12_StreamRender-H3|StreamRender-H3]] 用语义图；[[topics/notes/代码世界模型与神经渲染/1-15_GameWM|GameWM]] 把交互细节也交给视频模型——本文的"死亡状态"恰好就是一个只给状态、细节（怎么倒下）交给渲染器的例子；
  - [[topics/notes/代码世界模型与神经渲染/1-14_CoCode-World|CoCode-World]] 把共享代理扩到多人，本文引言也提到显式全局状态对多人世界重要；
  - [[mirros/notes/01_AgentGarten|AgentGarten]] 从单张图搭世界时用的是同一套工具（SAM 3、WildDet3D、Depth Anything 3 / ViPE），但它把几何拟合成场景程序后输出深度 / 法线，本文直接用 OBB。
- **结构条件渲染器**：[Coarse-to-Real](https://arxiv.org/abs/2601.22301)（粗 3D 代理，本文引为"更轻的结构条件"代表）、[DiffusionRenderer](https://arxiv.org/abs/2501.18590)（G-buffer）、RenderFormer（结构化 token 直接到图像，本文改用确定性编译器显式解决投影和实体到像素的对应）。
- **基线**：LingBot-World-V2（[2607.07534](https://arxiv.org/abs/2607.07534)，也是 CWM 用来说明纯文字条件不够的模型）、[YUME](https://arxiv.org/abs/2507.17744)。
- **评测**：[[topics/notes/代码世界模型与神经渲染/3-04_WorldDraft|WorldDraft]] 的"属性绑定"评测和本文的身份 / 状态一致性评测关注点相近，可以对照。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文是 CC BY 4.0 许可，引用了少量原句）
> 1. 第 2 页 §1 第 2 段：控制接口无法寻址单个实体、缺少显式持久全局状态、规则不可编程 → 要解决的三个问题
> 2. 第 4 页 §2 公式 (1)(2)：训练是 "realized dynamics → structural representation"，推理是 "state transition → structural representation → generated dynamics" → 训练–推理不对称的论证
> 3. 第 4 页 §2 倒数第 2 段：表示越细，系统越从说明"什么变了"转向说明"怎样展开" → 为什么选 OBB
> 4. 第 6–7 页 §4.2：$s_t=(E_t,A_t,Q_t;R_t)$；现成 3D 检测器初始化 OBB，智能体编排器写世界程序；规则集本身也可被更新 → 世界状态表示
> 5. 第 8 页 §4.3：身份槽训练时随机分配、序列内固定；方向用世界空间速度量化成 7 类，静止物体在相机运动时仍为静止 → 三张控制图
> 6. 第 9 页 §4.4.1：骨干是 LingBot-World-v1，主干与相机通路冻结，只训 Structured Spatial ControlNet，残差加到主干层 → 骨干与条件注入
> 7. 第 10 页 §4.4.2：块内双向、块间因果；近 / 中 / 远三档时间历史 + $I_0$ 锚；空间记忆沿用 AlayaWorld → 长视频与记忆
> 8. 第 10–11 页 §4.5、§5.1：ViPE → Qwen3-VL → SAM 3 → WildDet3D；数据来自无 HUD 的 Cyberpunk 2077、Forza Horizon 6、GTA V → 数据管线
> 9. 第 12–14 页表 1 与 §5.2：基线通过切换提示词传达状态；Qwen3.6-27B 裁判；Count Acc. 400 帧、State Acc. 50 个死亡事件；94.00 / 98.00 → 主要数字与评测方式
> 10. 第 15 页 §5.3：图 5(b) 大角度转相机正确渲出首帧视野背后的三个角色；(e) 897 帧序列；(a)(c)(d) 首帧由 GPT Image 2 生成 → 画面外实体与长序列演示

## 摘要（中文）

近来的视频世界模型生成的视觉体验越来越逼真、越来越可交互，但缺乏在长时间交互中维持持久世界状态、执行可编程规则的可靠机制。我们提出 Programmable World Model，一个把世界状态演化与视觉观测生成解耦的框架。智能体把自然语言指令翻译成可执行程序，程序规定实体状态和状态转移规则，从而可以直接控制单个实体及其交互。一个轻量引擎执行这些程序，更新并维护显式、持久的全局世界状态，包括画面外的实体和非视觉属性。为了把世界状态和视觉生成连接起来，我们引入带状态增强的 3D 有向包围盒（OBB）作为中间表示。这一表示连同目标相机轨迹，被确定性地编译成像素对齐的时空条件信号，提供给充当生成式渲染器的预训练视频模型。这一设计让用户可以创建带预定义机制的可玩游戏、直接控制单个实体，并在整个游戏过程中保持持久的世界状态。我们还提出 CombatStateBench，一个评测可编程世界模型的基准。在 CombatStateBench 上，我们的方法达到 94% 的数量准确率和 98% 的状态准确率，大幅超过现有交互式视频世界模型，同时支持连贯的长时生成。这些结果证明了把显式状态演化与生成式渲染分开、用于构建持久可编程世界的有效性。

## 摘要（原文）

论文以 CC BY 4.0 许可发布，以下转录自 arXiv v2 PDF 第 1 页。

> Recent video world models generate increasingly realistic and interactive visual experiences, yet lack reliable mechanisms for maintaining persistent world state and enforcing programmable rules over extended interactions. We introduce Programmable World Model, a framework that decouples world-state evolution from visual observation generation. An agent translates natural-language instructions into executable programs that specify entity states and state-transition rules, enabling direct control over individual entities and their interactions. A lightweight engine executes these programs to update and maintain an explicit, persistent global world state, including off-screen entities and non-visual attributes. To connect world state with visual generation, we introduce state-augmented 3D oriented bounding boxes (OBBs) as an intermediate representation. This representation, together with the target camera trajectory, is deterministically compiled into pixel-aligned spatiotemporal conditioning signals for a pretrained video model serving as the generative renderer. This design allows users to create playable games with predefined mechanics, direct control over individual entities, and persistent world state throughout gameplay. We further introduce CombatStateBench, a benchmark for evaluating programmable world models. On CombatStateBench, our method achieves 94% Count Accuracy and 98% State Accuracy, substantially outperforming existing interactive video world models while supporting coherent long-horizon generation. These results demonstrate the effectiveness of separating explicit state evolution from generative rendering for building persistent, programmable worlds.
