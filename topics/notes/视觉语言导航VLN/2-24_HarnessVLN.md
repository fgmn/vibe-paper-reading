---
id: "2-24"
org: 专题·视觉语言导航VLN
short: "HarnessVLN"
title: "HarnessVLN: Unifying Training-Free Embodied Navigation through an Agent Harness"
aliases: ["HarnessVLN"]
date: 2026-09-29
category: "零样本大模型智能体与分层系统"
venue: "—（arXiv 预印本）"
affiliation: "南京大学 · 智元机器人 AGIBOT · 清华大学"
authors: ["Yang Chen", "Lirong Che", "Zhenyu Huang", "Wenbo Fu", "Chuang Wang", "Xu Cao", "Daqi Liu", "Yuzhe Yang", "Jian Su", "Lan-Zhe Guo"]
arxiv: "2609.15195"
pdf: "[[topics/papers/视觉语言导航VLN/2-24_2609.15195_HarnessVLN.pdf]]"
code: "https://github.com/AgibotGeneral/harnessvln"
project: "https://agibot-harnessvln.netlify.app/"
license: 论文里没有标注
status: 未读
rating:
read_date:
tags: ["paper", "vln", "objectnav", "agent-harness", "training-free", "memory", "humanoid"]
---

# HarnessVLN: Unifying Training-Free Embodied Navigation through an Agent Harness

> [!info] 论文信息
> arXiv [2609.15195](https://arxiv.org/abs/2609.15195) · 本地 PDF 是 v3（2026-09-29），v1 日期 PDF 里没写
> 单位：南京大学、智元机器人（AGIBOT）、清华大学 · 通讯作者：Jian Su（AGIBOT）、Lan-Zhe Guo（南京大学）
> PDF：[[topics/papers/视觉语言导航VLN/2-24_2609.15195_HarnessVLN.pdf|本地 PDF]]（18 页，正文 9 页 + 附录）
> 代码：[AgibotGeneral/harnessvln](https://github.com/AgibotGeneral/harnessvln) · 项目页：[agibot-harnessvln.netlify.app](https://agibot-harnessvln.netlify.app/)
> 专题：[[topics/视觉语言导航VLN#二、零样本大模型智能体与分层系统|视觉语言导航VLN · 二、零样本大模型智能体与分层系统]]；也列在 [[agibot/智元-论文与报告汇总|智元-论文与报告汇总]]（合作）

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-09）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。

## 一句话总结

免训练的导航智能体，同一套框架同时做**指令跟随（R2R-CE / RxR-CE）**和**物体目标导航（HM3D-v2 / HM3D-OVON）**。思路是把 MLLM 降成"提议者"：MLLM 只提出语义操作（"去左边那扇门""找白色的床"），由一层 **Agent Harness** 负责在派发前核对证据、几何可达性和当前子目标，执行后把结构化反馈写回两种记忆（任务侧的分层事件记忆、环境侧的时空图 ST Graph），并且**MLLM 不能直接发 Stop**，只能申请，由 harness 做语义 + 几何 + 进度三重校验。GPT-5.5 下 R2R-CE 全量 val-unseen SR 59.6%、RxR-CE 51.4%；GPT-5.6-luna 下 HM3D-v2 76.0%、HM3D-OVON 59.3%，都是表里免训练方法最高。

## 要解决什么问题

- 现有 MLLM 导航系统里，MLLM 是流水线中的规划器：感知模块喂观测，MLLM 出子目标，下游模块做定位和执行。**证据怎么保留、提议怎么验证、失败怎么处理**没有统一的机制，全压在 MLLM 的语义推理上。
- 作者点出两个"差距"：**认出目标不等于到达**，**发出动作不等于子目标完成**。导航一长，计划和真实任务状态就会脱节。
- 通用 agent harness（模型 + 工具 + 记忆 + 环境反馈）能提供这种协调，但搬到导航要补上：证据要带"在哪里、什么时候看到的"；提议的目标要可达、和任务相关；执行结果要反过来驱动重规划、恢复和停止。
- 同时想证明这层 harness 是**任务无关**的：换任务只换"进度表示"和"完成判据"，协议不变。

## 方法

总览见 [[topics/papers/视觉语言导航VLN/2-24_2609.15195_HarnessVLN.pdf#page=4|图 2（第 4 页）]]，运行流程见 [[topics/papers/视觉语言导航VLN/2-24_2609.15195_HarnessVLN.pdf#page=6|算法 1（第 6 页）]]。

### Harness 状态与决策循环（§3.1.1、算法 1）

harness 在第 t 步维护 S_t = (x, ω_t, p_t, z_t, M_t, G_t)：任务描述、当前 RGB-D 观测和局部几何图、位姿、**任务进度 z_t**、分层事件记忆 M_t、ST 图 G_t。

- z_t 是唯一按任务区分的部分：指令跟随记当前路段、已满足的动作约束、已看到的地标；ObjectNav 记已探索区域、候选目标假设及其验证状态。
- 每步循环：观测与位姿不一致就重新观测 → 记事件 → 合并进 ST 图 → 取当前子目标 → 按子目标检索经验 → 组装上下文 → MLLM 提议 c_t → **Validate** → 派发工具 → 用反馈更新状态。

### 统一工具接口（§3.1.2、表 1）

| 工具 | 角色 | 作用 |
|---|---|---|
| observe / observe_panorama | 感知 | 当前 RGB-D + 位姿 / 按预设朝向拍全景 |
| retrieve_memory | 检索 | 从事件记忆和 ST 图里取与任务相关的证据 |
| ground_target | 定位 | 把子目标落到某个视角的图像区域 |
| query_depth | 感知 | 估计定位区域的深度和不确定度 |
| navigate_to | 导航 | 调用 Navigation Executor 去一个**已验证**的目标 |
| backtrack | 恢复 | 回到之前去过的位置并确认到达 |
| request_stop | 终止 | 先验证完成再停 |

派发前检查四件事：参数合法、支撑证据的**来源和新鲜度**、目标几何可达、与当前子目标一致（还要参考相关的失败历史）。每个工具都返回结构化反馈：执行状态、测量值、失败证据。因为输入输出契约统一，单个工具可以替换，不用改 MLLM 或 harness 协议。

### 分层事件记忆（§3.1.3，任务侧）

| 层 | 存什么 | 要点 |
|---|---|---|
| 工作记忆 | 当前观测、有限长的全景历史、当前目标假设、最近的工具反馈 | 有上限，不随轨迹变长 |
| 进度记忆 | 子目标分解，每个子目标有 ID 和四种状态之一：pending / active / completed / blocked | 同一时刻最多一个 active；标"完成"必须有位姿对齐的观测或成功的工具结果作证据，防止规划器"想当然"推进 |
| 反思记忆 | 子目标级别的完整执行事件：不可达、定位不一致、碰撞、没进展、回溯失败、停止申请被拒 | 每条带事件 ID、任务上下文、位置、时间戳、工具反馈、支撑观测；是失败轨迹的"权威来源" |

附录的提示词里，进度记忆就是一张 TODO 表（按稳定的 todo_id 更新，不按列表位置），和 Uni-LaViRA 的 TODO List Memory 很像；论文也说部分设置取自 Uni-LaViRA。

### 时空图 ST Graph（§3.2，环境侧）

- **节点**：地点节点（去过的位置、支撑观测、可通行航点；在 0.75 m 半径内的观测合并进已有地点）和实体节点（ObjectNav 目标和指令里的地标：语义别名、空间假设、置信度、支撑视角；合并半径 1.0 m）。
- **边**：相邻地点间双向 NavigableTo（前进和回溯用的拓扑）；ObservedFrom 记录实体在哪个视点、什么时候被看到（溯源）；Contains 粗略表示地点包含实体。另存时间戳和轻量事件注释。
- **按子目标检索**（式 3）：s(v | g_t) = R + λ_rec·C + λ_sal·A − λ_fail·P，分别是语义相关度、新近度、空间显著性和失败惩罚。附录给了取值：R 用局部 IDF 加权余弦相似度，λ_rec = λ_sal = 0.3，每条适用失败扣 0.5、最多扣 1.0；取前 3 个种子地点扩一跳，最多返回 5 个地点。所以图怎么长，送进 MLLM 的上下文都不变大。
- **失败注释**：有空间复用价值的失败只在图上挂一条轻量注释（子目标条件、失败类型、时间、适用权重、指回事件记忆的引用），子目标换了或有新证据推翻时降权，同类失败重复时升权。完整记录仍在反思记忆里，图只做"空间索引"。罚分设上限，是为了不把曾经失败的分支永久排除。

### 执行与停止（§3.3、附录 1.3）

- **Navigation Executor** 是 harness 管理的一个工具：平面运动用 FMM 规划器，要上下楼梯时调用 NavDP。执行反馈包括到达、碰撞、不可达、没有进展。前进和回溯走同一个"验证 → 执行 → 更新"循环。
- **证据式终止**（式 4）：F_stop = F_semantic ∧ F_geometric ∧ F_progress。
  - 指令跟随：当前证据要支持最后一段路线、所提地标和定位出的终点。
  - ObjectNav：MLLM 先确认目标清晰可见且类别正确（排除长得像的），给出框；**距离不让 MLLM 从 RGB 估**，由深度工具量：框锚点处 5×5 深度中值、标准差 ≤ 0.5 m 才算可靠，阈值 2.5 m；深度不可靠时退回"到投影导航目标的距离 ≤ 1.0 m"。
  - 被拒的停止申请写进事件记忆，触发再观测、细化目标、靠近或回溯。

### 实现细节（§4.2、附录 1.2–1.3）

- 观测 640×480 RGB-D、79° 水平视场；GroundingDINO + SAM 做开放词汇区域和分割。
- 一个 MLLM 用不同角色提示词承担分解、规划、定位、停止验证和恢复：**指令跟随用 GPT-5.5，ObjectNav 用 GPT-5.6-luna**。温度 0.7（定位 0），每次请求最多 50 张图。
- 步数上限 500；前进 0.25 m / 转 30°，全景要转 12 次、每次算 1 步。成功距离：指令跟随 3.0 m，ObjectNav 1.0 m。

## 实验与关键数字

**指令跟随（表 2，第 7 页）**

| 方法 | 设置 | R2R-CE NE↓ | OSR | SR | SPL | RxR-CE SR | SPL | nDTW |
|---|---|---|---|---|---|---|---|---|
| HSGM-GPT-5（之前最好的免训练全量结果） | 全量 | 5.42 | 58.7 | 47.9 | 32.8 | 41.8 | 25.1 | 54.9 |
| **HarnessVLN-GPT-5.5** | 全量 | **4.08** | 70.7 | **59.6** | 43.6 | **51.4** | 38.1 | 55.6 |
| AgenticNav-GPT-5.5 | Rand100 | 5.19 | 65.0 | 55.0 | **48.4** | — | — | — |
| mini-swe-agent-GPT-5.5 | Rand100 | 7.29 | 57.0 | 52.0 | 44.2 | — | — | — |
| **HarnessVLN-GPT-5.5** | Rand100 | **4.24** | **77.0** | **58.0** | 35.8 | — | — | — |
| ABot-N0（训练式，参考） | 全量 | 3.78 | 70.8 | 66.4 | 63.9 | — | — | — |

- 全量比 HSGM 高 11.7（R2R）和 9.6（RxR）个点。Rand100 上和同样用 GPT-5.5 的 AgenticNav 比：SR +3.0、OSR +12.0、NE 5.19 → 4.24 m，**但 SPL 低 12.6 个点**。
- 训练式方法里 ABot-N0、NavFoM、InternVLA-N1 的 R2R-CE SR 仍更高（66.4 / 61.7 / 58.2）。

**物体目标导航（表 3）**

| 方法 | 是否训练 | HM3D-v2 SR | SPL | HM3D-OVON SR | SPL |
|---|---|---|---|---|---|
| FiLM-Nav | ✓ | 77.0 | 41.3 | 40.8 | 24.4 |
| ABot-N0 | ✓ | — | — | 54.0 | 30.5 |
| DRIVE-Nav | ✗ | 72.4 | 41.3 | 50.2 | 32.6 |
| MSGNav | ✗ | 74.4 | 33.4 | 48.3 | 27.0 |
| **HarnessVLN（GPT-5.6-luna）** | ✗ | **76.0** | 37.9 | **59.3** | **36.6** |

- HM3D-v2：免训练最高（比 MSGNav +1.6），离最好的训练式 FiLM-Nav 差 1.0；SPL 低于 DRIVE-Nav 和 FiLM-Nav。
- HM3D-OVON：SR 和 SPL 都是全表最高，SR 比训练式 ABot-N0 高 5.3。

**逐项累加消融（表 4，第 8 页；R2R Rand100 和 HM3D-OVON 的固定 100 集子集）**

| 事件记忆 | ST 图 | 停止验证 | R2R SR | SPL | OSR | OVON SR | SPL | OSR |
|---|---|---|---|---|---|---|---|---|
| | | | 43.0 | 24.3 | 65.0 | 45.0 | 32.0 | 72.0 |
| ✓ | | | 50.0 | 30.9 | 73.0 | 52.0 | 32.4 | 72.0 |
| ✓ | ✓ | | 56.0 | 32.4 | 76.0 | 53.0 | 34.2 | 71.0 |
| ✓ | ✓ | ✓ | 58.0 | 35.9 | 77.0 | 55.0 | 33.0 | 74.0 |

事件记忆在两个任务上都 +7；ST 图在 R2R 上 +6、在 OVON 上只 +1；停止验证各 +2。整套比"基础智能体"高 15 / 10 个点。

**换模型与同模型对比（附录表 6，固定 100 集 ObjectNav 子集）**

| 方法 | 模型 | HM3D-v2 SR | SPL | OSR−SR | OVON SR | SPL | OSR−SR |
|---|---|---|---|---|---|---|---|
| MSGNav（作者重跑） | GPT-5.6-luna | 62.0 | 27.7 | 22.0 | 37.0 | 18.9 | 9.0 |
| HarnessVLN | GPT-5.6-luna | 76.0 | 40.8 | 10.0 | 55.0 | 33.0 | 19.0 |
| HarnessVLN | GPT-6-astra | **86.0** | **47.1** | 9.0 | **63.0** | **39.4** | 13.0 |
| HarnessVLN | Qwen3.8-flash | 72.0 | 36.9 | 13.0 | 51.0 | 32.8 | 24.0 |

同模型下比 MSGNav 高 14 / 18 个点 SR。换成更强的 GPT-6-astra 再涨 10 / 8 个点。

**步数预算（附录 1.3、图 4）**：R2R Rand100 上，观测转身占全部环境步数的 **54.85%**（平均每集 199 步，总 363 步）。步数上限从 500 放到 1000，SR 58 → 61、OSR 77 → 81，SPL 和 nDTW 略降。

**真机（§5、图 3）**：智元 A3 Ultra 人形机器人（1.74 m），头部双目相机 + Fast-FoundationStereo 估深度，规划模型换成 Qwen-3.8-27B。三个场景：顺序指令跟随（806 房间外路口左转、停在饮水机旁垃圾桶、再去冰箱），开放词汇找打印机，以及"先到入口指示牌再带我去自动售货机"的组合任务。**只有定性展示，没有成功率**。

## 局限 / 存疑

论文自述（§6）：编排和验证规则都是预先写死的；以后想做通过交互自我演化的机制。另外 §4.3 承认效率（SPL）提升在不同基准上不一致。

读的时候值得核对的地方：

- **提升有多少来自基础模型？** 主表里 HarnessVLN 用 GPT-5.5 / GPT-5.6-luna，HSGM 是 GPT-5，EvoNav 是 Gemini-2.5-pro，CA-Nav、GC-VLN、MSGNav 等的模型没标。真正同模型的对照只有两处：Rand100 上的 AgenticNav / mini-swe-agent / SmartWay / Uni-LaViRA（都标了 GPT-5.5），以及附录里重跑的 MSGNav。表 6 里同一 harness 从 GPT-5.6-luna 换到 GPT-6-astra 就涨了 10 个点，和整套 harness 在 OVON 消融里的总增益（+10）一样大。
- **"统一"的边界**：两类任务用了不同的 MLLM（GPT-5.5 vs GPT-5.6-luna），进度表示 z_t 和终止判据也按任务写。协议统一是对的，但不是"一套配置跑四个基准"。为什么两类任务要用不同模型，论文没解释。
- **重跑的 MSGNav 比它自己报的低很多（需核对）**：表 3 里 MSGNav 在 HM3D-v2 上是 74.4，附录用 GPT-5.6-luna 重跑在 100 集子集上只有 62.0。差 12 个点，可能来自子集、模型或复现差异，论文没讨论。"同模型高 14 个点"要结合这一点看。
- **小样本、单次运行**：消融和表 6 都只用 100 集，温度 0.7，没有多次运行或置信区间。100 集上成功率的标准误约 ±5 个点，ST 图在 OVON 上的 +1、停止验证的 +2 都在噪声范围内。"基础智能体"（表 4 第一行）具体保留了哪些部分（工具、TODO 表、回溯？）也没说清。
- **SPL 和步数代价**：Rand100 上 SPL 35.8 明显低于 AgenticNav（48.4）和 mini-swe-agent（44.2）；HM3D-v2 上 SPL 也低于 DRIVE-Nav。一半以上的环境步数花在原地转身拍全景上。另外每次请求最多 50 张图、多种角色调用，**推理成本和时延完全没报告**（API 调用次数、token、每集耗时），这对真机部署很关键。
- **Rand100 的 500 步数字是怎么来的（需核对）**：附录说 500 步的结果是把 1000 步的轨迹截断后离线重算的，而这组数字（SR 58.0、SPL 35.85）和表 2、表 4 完全一致。如果表 2 / 表 4 本身就来自截断重算，那和在线跑 500 步是否等价，取决于智能体会不会感知剩余步数。
- **停止验证管的是"到没到自己选的目标"，不是"选对了没有"**：ObjectNav 的深度阈值是 2.5 m，比 1.0 m 的成功距离宽松得多（图 11：深度 1.20 m 通过，实际离目标 2.15 m，失败）；指令跟随的投影目标检查只看离自己选的终点是否 ≤ 1.0 m（图 10：检查通过，但离真正终点 6.48 m）。语义那一项也是同一个 MLLM 在复核自己。作者自己在图注里也指出了这两点。
- **"免训练"的含义**：指不做导航任务专门的训练。工具链里的 GroundingDINO、SAM、NavDP（扩散导航策略）都是训练过的模型；仿真里位姿和深度是真值。真机上换成了双目估深度，但位姿来源没写。
- **真机没有定量结果**，且规划模型换成了 Qwen-3.8-27B，和仿真里的 GPT 系列不同；表 6 里 Qwen3.8-flash 比 GPT-5.6-luna 低 4 个点，真机上效果如何无从判断。

## 与其他论文的关系

- **最直接的对手：工具调用式 harness**
  - [AgenticNav](https://arxiv.org/abs/2606.10577)（专题 2-21）：把动作、像素深度、选择性视觉回忆做成可调用工具，带几何安全检查。HarnessVLN 在它之上多了任务进度、两层记忆和停止校验，同模型 Rand100 上 SR 高 3、但 SPL 低 12.6。
  - [Embodied Agents Take Control](https://arxiv.org/abs/2607.26148)（2-22）：主张"最小接口"的零样本智能体；论文引用了它作为 agent harness 的依据。两者是"薄 harness"和"厚 harness"的两种取向，可以对照看。
  - mini-swe-agent：把通用编码智能体直接接到导航上的基线，也在表 2 里。
- **TODO 记忆和回溯的来源**：[LaViRA](https://arxiv.org/abs/2510.19655)（2-15）及其统一版 Uni-LaViRA（专题附录备选）提出了 TODO List Memory 和 Second Chance Backtrack，HarnessVLN 说部分设置取自 Uni-LaViRA；[SmartWay](https://arxiv.org/abs/2503.10069)（2-09）也做回溯。
- **同一时期的 harness / 记忆类 VLN**：[HAM-VLN](https://arxiv.org/abs/2607.29600)（2-23，智能体自写的分层记忆）、[NavHarness: Adaptive Goals](https://arxiv.org/abs/2609.39915)（2-25）、[NavGPT-3](https://arxiv.org/abs/2610.10787)（1-03，推理 LLM + VLA 的类操作系统运行时）。
- **同组前作（南京大学 Lan-Zhe Guo 组）**：STEGNav（时空事件图做终身 ObjectNav，表 3 里的免训练基线）大概率是 ST Graph 的前身（推测）；LookStep（事件驱动记忆）、Re²Agent（反思与重执行）对应事件记忆和反思记忆。
- **训练式对照**：[NaVid](https://arxiv.org/abs/2402.15852)（3-03）、[Uni-NaVid](https://arxiv.org/abs/2412.06224)（3-06）、[NavFoM](https://arxiv.org/abs/2509.12129)（3-19）、[ABot-N0](https://arxiv.org/abs/2602.11598)（3-28）同样追求"一个模型多种导航任务"，但是靠训练；HarnessVLN 是靠协议。
- **与 RSI 专题的联系**：作者说下一步是让 harness 自我演化，这正是 [[topics/递归自我改进RSI|递归自我改进RSI]] 第一节里的方向，例如 RegenHarness（1-22，依据执行记录改规则和路由）、NavHarness: Towards Lifelong Embodied Navigation（1-23）、ASENA（1-24）、EMHO（1-25，读执行轨迹改写 harness）。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文没有标注 CC 许可，这里只记位置和几个关键词，原句请点页码看）
> 1. 第 2 页 §1 第 3 段："recognizing a target does not confirm arrival" → 问题动机：认出 ≠ 到达，发动作 ≠ 子目标完成
> 2. 第 4 页 §3.1.2 第 2 段：派发前检查参数、证据来源与新鲜度、几何可行性、子目标一致性 → 提议验证
> 3. 第 4 页 §3.1.3 "Progress memory"：最多一个 active，完成需观测或工具结果支撑 → 进度记忆
> 4. 第 5 页 §3.2 "Failure-aware updates"：失败注释带适用权重并随新证据衰减 → ST 图失败注释
> 5. 第 6 页 §3.3 "Evidence-based termination"：MLLM 只能申请、不能直接发 Stop（式 4） → 三重停止校验
> 6. 第 7–8 页 §4.2：指令跟随用 GPT-5.5、ObjectNav 用 GPT-5.6-luna → 两类任务模型不同
> 7. 第 8 页 §4.3 末句：效率提升在不同基准上不一致 → 作者对 SPL 的保留
> 8. 第 13 页附录 1.3 "Geometric stop validation"：深度阈值 2.5 m / 投影目标 1.0 m → 停止阈值
> 9. 第 14 页附录 1.3 "Step budget"：观测转身占 54.85% 步数；500 步结果由离线截断得到 → 步数代价
> 10. 第 9 页 §6：编排和验证是预定义的，以后做自我演化 → 论文自述局限

## 摘要（中文）

具身导航要求智能体把指令或物体目标落到空间观测上，并把计划变成成功的执行。MLLM 越来越强，不经任务专门训练也能更好地支撑导航；但语义推理变强，并不能保证提出的动作与空间证据、任务进度和执行结果保持一致。我们提出 HarnessVLN，一个零样本、免训练的框架，通过一个共享的 Agent Harness 统一指令跟随导航和物体目标导航。Harness 通过统一接口协调感知、记忆和执行工具，在派发前检查规划器提议的证据支撑、几何可行性和子目标一致性。它同时管理分层事件记忆和一个持久的时空图（ST Graph），用来跟踪任务进度、保留空间证据、为失败提供上下文。结构化的执行反馈更新这些共享状态，指导后续的规划、恢复和终止。在 R2R、RxR、HM3D-v2 和 HM3D-OVON 上，HarnessVLN 的成功率分别为 59.6%、51.4%、76.0% 和 59.3%，超过此前的免训练方法。人形机器人部署进一步展示了它在真实环境中完成两类导航任务的能力。

## 摘要（原文）

见 [arXiv 摘要页](https://arxiv.org/abs/2609.15195)。论文没有标注 CC 许可，这里不转录原文。
