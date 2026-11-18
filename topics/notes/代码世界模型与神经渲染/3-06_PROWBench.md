---
id: "3-06"
org: 专题·代码世界模型与神经渲染
short: "PROWBench"
title: "PROWBench: Do Video Models Render What the Program Specifies?"
aliases: ["PROWBench", "ROWBench"]
date: 2026-10-01
category: "基准、立场与相邻工作"
venue: —
affiliation: "Alaya Lab（9 位作者里 6 位标了 Alaya Lab；Jian-Kai Zhu、Yu-Lun Liu、Yung-Yu Chuang 未标单位）"
authors: ["Zheng-Hui Huang", "Guixu Lin", "Yu-Ju Tsai", "Jian-Kai Zhu", "Fengbo Lan", "Yu-Lun Liu", "Yung-Yu Chuang", "Kaipeng Zhang", "Zhixiang Wang"]
arxiv: "2610.02205"
pdf: "[[topics/papers/代码世界模型与神经渲染/3-06_2610.02205_PROWBench.pdf]]"
code: "https://github.com/AlayaLab/PROWBench"
project: "https://alaya-lab.github.io/PROWBench"
license: CC BY 4.0（arXiv 摘要页）
status: 未读
rating:
read_date:
tags: ["paper", "benchmark", "generative-rendering", "code-world", "programmable-world-model", "proxy-video", "world-model", "evaluation", "long-horizon", "multi-view"]
---

# PROWBench: Do Video Models Render What the Program Specifies?

> [!info] 论文信息
> arXiv [2610.02205](https://arxiv.org/abs/2610.02205) · 本地 PDF 是 v2（2026-10-05）；v1 是 2026-10-01。PDF 首页标题写的是 **ROWBench**，arXiv 标题和正文都叫 **PROWBench**
> 单位：Alaya Lab（与 [[topics/notes/代码世界模型与神经渲染/1-04_ProgrammableWorldModel|Programmable World Model]]、AlayaRenderer 同组）；9 位作者中 Jian-Kai Zhu、Yu-Lun Liu、Yung-Yu Chuang 没标单位 · 共同一作：Zheng-Hui Huang、Guixu Lin · 通讯作者：Zhixiang Wang（项目负责人）、Kaipeng Zhang
> PDF：[[topics/papers/代码世界模型与神经渲染/3-06_2610.02205_PROWBench.pdf|本地 PDF]]（39 页：正文 1–15 页 + 参考文献 15–19 页 + 附录 A–C 20–39 页，附录后半是整页定性图）
> 代码：[AlayaLab/PROWBench](https://github.com/AlayaLab/PROWBench)（MIT）· 项目页：[alaya-lab.github.io/PROWBench](https://alaya-lab.github.io/PROWBench)
> 专题：[[topics/代码世界模型与神经渲染#三、基准、立场与相邻工作|代码世界模型与神经渲染 · 三、基准、立场与相邻工作]]（表格"补充"部分）

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-18）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。
> 本机 Read 工具打不开 PDF，这次是用 macOS PDFKit 脚本把全部 39 页抽成文字来读的；表 1（第 8 页）抽取后行序有错位，另把第 8 页渲染成 PNG 对照原表核过一遍（表 1 里各方法的输入图标也是从 PNG 上看的）。其余图（图 3–8、附录图）只看到了图注和正文引用的数字。

## 一句话总结

Alaya Lab 给"可编程世界模型"做的渲染保真度基准：用一个程序化的世界生成管线跑出 **170 个 episode**，把实体状态、关节姿态、带时间戳的事件（包括相机视野外的）记成**可重放的世界记录**，再从同一份记录、同一条相机轨迹渲出三种代理表示（**粗 3D 灰模 / CWM 代理 / 带身份色的有向包围盒 Colored-OBB**），共 **600 段代理视频**；生成视频按引擎记录逐帧打分：实体框 IoU、相机误差，以及两个 VLM（Qwen3.6-27B）指标——**交互成功率 ISR**（动作和终态都对）和**逻辑-渲染对齐 LRA**（时间线每段的动作都画出来了）。测了 11 个模型，七条结论里最重要的是：给代理视频的模型实体放置明显好于只给相机轨迹的世界模型（Verified-FF 类均值 IoU 0.450 / 0.464 对 0.322），相机跟随却打平（代理本身就编码了相机）；**通用视频底座 MiniMax-H3、Seedance 2.5 不做任何适配就很能打**，在 H3 上微调的 LynnReal-Omni 在大多数指标上最好；但 30 秒长视频里 IoU 只剩 0.175–0.280、离开视野再回来的实体 Reappearance IoU 只有 0.053–0.131，多视角下灰模代理让人物身份全乱（C2R 外观合规 32.2%），专门训练的 PWM 在枪战事件上 ISR 0.850 仍明显高于通用模型（0.450–0.650）。

## 要解决什么问题

- **背景**：CWM、PWM 这类"可编程世界模型"把世界状态演化（代码、引擎）和视觉生成（视频模型）分开。但**程序执行对了，不等于画面对了**：生成视频可能看起来合理，却违反了规则、漏画了规定的交互。
- **现有基准的缺口**（§1、表 A.1）：VBench、WorldScore、WorldModelBench、MIND、WorldArena、WBench 等评的是画质、可控性、物理合理性、交互一致性，但
  1. 没有**可重放的实体状态和带时间戳的事件记录**，只能判断"像不像"，不能对照"程序到底执行了什么"；
  2. 没有从**同一场景同一轨迹**渲出多种代理表示，无法把"表示形式"的影响单独隔离；同步多视角也少见；
  3. 大多评完整流水线，动作理解、状态预测、记忆、动力学、渲染的误差混在一起。
- PROWBench 的定位是**只隔离渲染这一环**：世界演化由引擎固定下来，看视频模型能不能把规定的结构、规则、交互画出来。图 1（[[topics/papers/代码世界模型与神经渲染/3-06_2610.02205_PROWBench.pdf#page=1|第 1 页]]）用一个开门例子说明：CLIP 分数给明显更差的那段视频打了更高分（24.51 对 22.29），交互指标则是 0/3 对 3/3。

## 方法

### 世界生成管线（§3.1，[[topics/papers/代码世界模型与神经渲染/3-06_2610.02205_PROWBench.pdf#page=4|图 2，第 4 页]]）

| 环节 | 做什么 |
|---|---|
| 世界合成 | 由配置（环境、实体布局、参与者、任务控制器、随机种子、时长）程序化生成地形、建筑、道路、室内和交互物体；实体有 episode 级持久 ID、语义类别、部件层级。控制器分三类：**交互控制器**（如搬运分为接近—抓—举—运—放五个阶段，并更新手部目标和物体归属）、活动与运动控制器（动物、简化的飞行和游泳）、驾驶控制器（闭环控车）。外部智能体可以查询实体、提交动作或计划、按固定 tick 推进世界、读执行反馈 |
| 记录 | 每次执行产出结构化 episode 记录：共享场景几何、实体定义、初始条件，以及实体变换、关节姿态、可见性、外观变化的时间序列 + 控制器事件；任一存档状态都能从场景描述 + 动态记录独立重建 |
| 控制编译 | 第三人称相机按任务轨迹跟拍；第一人称相机来自记录的头部位置、角色 / 载具朝向和注视信息（观察者自身几何在第一人称里隐藏）。渲染适配器 `I = R_r(G, S_i, C_i^v)` 把同一份记录渲成不同表示，换相机或换表示**不用重跑行为控制器** |
| 输出 | 场景与运动记录、同步的多视角多表示代理视频（附度量深度）、带时间戳的事件和文字标签 |
| 校验 | 任务与时间线检查、几何检查（穿透、支撑、接触）、重放与对齐检查、首帧可见性和画面质量检查；失败的尝试单独保留，改动有哈希和版本记录 |

论文**没有说底层用的是什么引擎**（Unity、Unreal 还是自研），也没说场景是谁写的（是不是编码智能体），只说是"程序化生成框架"。需核对代码仓库。

### 三种代理表示（§3.1、附录 A.3，第 5、26 页）

| 表示 | 内容 | 保留 / 丢掉什么 |
|---|---|---|
| Coarse 3D（粗 3D） | 全场景浅灰低模，人是带关节的灰色方块人 | 保留形状、轮廓和**关节运动**；灰色只代表几何 |
| CWM proxy | 环境用平涂语义色；人是固定姿势的蓝色直立人偶，交互物体是红盒子 | 保留全局轨迹和朝向，**没有肢体运动**（就是 [[topics/notes/代码世界模型与神经渲染/1-01_CodeWorldModel|CWM]] 那种代理） |
| Colored-OBB | 人、车、动物、交互物体画成半透明实心框，每个实体一个固定的身份色；框的**白色一面是正面**；环境结构和简单物体保留几何 | 只给位置、范围、朝向；颜色只是身份码，不是目标颜色 |

### 评测指标（§3.2、附录 B，第 6–7、29–30 页）

| 维度 | 指标 | 怎么算 |
|---|---|---|
| 实体控制 | BBox IoU、Center Error | SAM 3 按语义标签检测，与引擎投影框做标签兼容的匈牙利匹配；漏检记 IoU = 0，所以 IoU 同时反映定位和持续性；中心误差只在检测到时算，按图像对角线归一 |
| 交互 | **ISR**（交互成功率） | 每个引擎登记事件（参与者、时间窗、动作、期望终态）取事件窗口附近 8 帧（全帧 + 按引擎位置裁的局部图）给 Qwen3.6-27B，独立判断动作、终态、参与者是否出现；**动作和终态都判 yes** 才算成功。按样本等权平均 |
| 时间线 | **LRA**（逻辑-渲染对齐） | 时间线每一段取该时间窗的 12 帧 + 期望事件描述 + 相邻描述，判断规定的动作是否在这一段画出来 |
| 联合 | gISR、gLRA | 每个样本的 ISR / LRA 乘该样本的 BBox IoU 再平均，即"由放对位置的实体完成的事件" |
| 相机 | Rot / Trans / CamMC | ViPE 只估位姿（内参固定为记录值、按引擎标签遮掉动态实体），照 CamI2V 的定义；平移序列各自除以最大范数，所以 Trans 和 CamMC **只看路径形状、不看长度** |
| 画质 | Img（MUSIQ）、Aes（LAION）、Warp（RAFT 光流回扭误差 ×10⁻³）、Smooth、CLIP | 不参照引擎状态，只衡量"合理性"而非"遵循度" |
| 长时记忆 | Reappearance IoU、State Persistence | 实体离开视野后再进入时的框 IoU；回来的人是否保持规定的走 / 站状态（Qwen3.6-27B 判） |
| 多视角 | Appearance Compliance、Cross-view Consistency、MEt3R | 前两个按 5 个属性（衣服颜色、款式、发型、配饰、体型）由 VLM 判，要求所有可判属性全对；MEt3R 只测生成视角之间的几何互洽，不对照引擎 |

### 赛道与数据（§3.3、附录 A.1，第 7、20 页）

| 赛道 / 设置 | 规模 | 内容 |
|---|---|---|
| 主赛道 · Verified-FF | 40 对（31 第三人称跟拍、9 第一人称），5 秒 | 给一张**校验过的 RGB 首帧**当外观参考；首帧由 MiniMax-H3 根据 Colored-OBB 代理和场景描述生成，再用 SAM 3 人数、框 IoU ≥ 0.30、VLM 查瑕疵、朝向四项硬检查（附录 A.2）；所有接受首帧的方法拿到同一张 |
| 主赛道 · Unverified-FF | 90 对（78 第三人称、12 第一人称），5 秒，场景与上面不重叠 | 只给世界状态、文字、控制信号，外观由模型自己从文字里定；需要 RGB 输入的方法（世界模型、CWM）拿 MiniMax-H3 输出的第 0 帧 |
| 挑战赛道 · 长时 | 10 段 30 秒录制，每段一个相机（6 第一人称、4 第三人称） | 实体离开再回来，跨生成窗口保持状态 |
| 挑战赛道 · 多视角 | 10 个四人场景 × 4 个同步第三人称跟拍视角 | 各视角**独立生成**，看人物身份和外观是否一致 |
| 领域专项 · 枪战 | 20 个 case（来自 10 段源录制） | 一人中枪倒地；专为和只在枪战数据上训练的 PWM 比较 |

- 总量：170 个 episode、200 个选定视角、600 段代理视频（570 段 5 秒 150 帧 + 30 段 30 秒 900 帧；540 段 1280×720、枪战 60 段 832×480；30 FPS），合计 62.5 分钟。
- 场景域：城市 64、室内 38、自然 31、赛车 12、水下 10、奇幻 8、天空 7（共 170）。交互类型 9 类、可重叠，人—人最多（44.7%）。画风 7 种，写实占 63.5%。第三人称视角 86.5%。
- **文字提示**由引擎记录确定性生成（只有外观描述那一块由 Qwen3.6-27B 写），带完整的时间线（"00:00.000–00:04.667 主角过马路，车辆减速让行，主角沿路线走了约 10 米……"）、主体到代理框的绑定（用 16 进制身份色），以及一个"控制块"规定冲突时的优先级：几何 / 相机 / 运动听代理，风格和外观听首帧，具体动作听时间线。**相机运动刻意不写进文字**，只经代理或相机轨迹给出。不同方法按各自接口做确定性格式转换（表 A.3）。

## 实验与关键数字

### 被测方法（§4.1、表 C.1）

| 类别 | 方法 | 输入 |
|---|---|---|
| 相机条件世界模型 | EchoWM、SANA-WM、LingBot-World 2.0、AlayaWorld v1.1 | RGB 首帧 + 文字 + 记录的相机轨迹；**没有实体轨迹** |
| 代理视频→RGB 的专用渲染器 | Cosmos-Transfer2.5 | 引擎深度 + 类别级分割 |
| | C2R | 粗 3D 代理 + 文字（不给首帧） |
| | CWM（在 MiniMax-H3 上微调） | CWM 代理 + 深度 + RGB 首帧 + 文字 |
| | LynnReal-Omni（在 H3 上扩展原生异构控制） | Colored-OBB 代理 + 首帧（Verified-FF）+ 文字 |
| | PWM（只在枪战数据上训练） | Colored-OBB 代理（表 C.1 写的是"3D 框的实例 ID 图"）+ 首帧 + 文字；只在枪战集上测 |
| 通用视频底座 | MiniMax-H3、Seedance 2.5 | 不做任何适配，Colored-OBB 代理当参考视频 + 文字（Verified-FF 另给首帧） |

### 主赛道（[[topics/papers/代码世界模型与神经渲染/3-06_2610.02205_PROWBench.pdf#page=8|表 1，第 8 页]]）

Verified-FF（40 对），只列关键列：

| 方法 | IoU↑ | CErr↓ | ISR↑ | LRA↑ | gISR↑ | gLRA↑ | Rot↓ | CamMC↓ | Img↑ | Warp↓ | CLIP↑ |
|---|---|---|---|---|---|---|---|---|---|---|---|
| EchoWM | 0.354 | 0.055 | 0.512 | 0.680 | 0.170 | 0.242 | 1.8 | 0.147 | 68.1 | 0.647 | 25.2 |
| SANA-WM | 0.306 | 0.070 | 0.590 | 0.569 | 0.183 | 0.179 | 2.7 | 0.168 | 68.6 | 0.871 | 25.1 |
| LingBot 2.0 | 0.325 | 0.064 | **0.727** | 0.804 | 0.238 | 0.258 | 2.8 | 0.132 | 70.0 | 1.127 | 25.4 |
| AlayaWorld v1.1 | 0.303 | 0.073 | 0.590 | 0.627 | 0.175 | 0.186 | 9.4 | 0.356 | 66.8 | 0.527 | 25.0 |
| Cosmos-Transfer2.5 | 0.452 | 0.061 | 0.381 | 0.560 | 0.165 | 0.246 | **1.7** | 0.172 | 67.2 | 0.429 | 24.2 |
| C2R | 0.377 | 0.062 | 0.606 | 0.699 | 0.219 | 0.262 | 7.8 | 0.438 | 70.5 | 0.783 | **25.7** |
| CWM | 0.455 | 0.040 | 0.637 | 0.795 | 0.290 | 0.360 | 2.0 | 0.154 | 66.7 | 0.398 | 25.3 |
| LynnReal-Omni | **0.518** | **0.037** | 0.621 | **0.832** | 0.327 | **0.429** | 2.1 | **0.101** | **73.8** | 1.258 | 25.2 |
| Seedance 2.5 | 0.433 | 0.043 | 0.652 | **0.832** | 0.280 | 0.358 | 3.6 | 0.152 | 66.9 | **0.313** | 25.3 |
| MiniMax-H3 | 0.494 | 0.038 | 0.669 | 0.748 | **0.330** | 0.372 | 3.4 | 0.133 | 70.1 | 0.444 | 25.2 |

Unverified-FF（90 对）：

| 方法 | IoU↑ | CErr↓ | ISR↑ | LRA↑ | gISR↑ | gLRA↑ | Rot↓ | CamMC↓ | Img↑ | Warp↓ | CLIP↑ |
|---|---|---|---|---|---|---|---|---|---|---|---|
| EchoWM | 0.255 | 0.099 | 0.669 | 0.712 | 0.172 | 0.180 | 3.1 | 0.193 | 70.2 | 0.823 | 24.8 |
| SANA-WM | 0.240 | 0.075 | 0.564 | 0.591 | 0.145 | 0.142 | 4.7 | 0.275 | 69.9 | 0.676 | 24.5 |
| LingBot 2.0 | 0.240 | 0.083 | 0.713 | 0.799 | 0.180 | 0.196 | 4.0 | 0.152 | 71.8 | 1.037 | 25.0 |
| AlayaWorld v1.1 | 0.204 | 0.101 | 0.714 | 0.712 | 0.159 | 0.146 | 10.7 | 0.461 | 69.3 | 0.564 | 24.8 |
| Cosmos-Transfer2.5 | 0.376 | 0.057 | 0.440 | 0.457 | 0.154 | 0.158 | 5.3 | 0.326 | 71.9 | 0.603 | 24.3 |
| C2R | 0.315 | 0.052 | 0.540 | 0.625 | 0.181 | 0.204 | 8.8 | 0.548 | 69.9 | 0.666 | **25.3** |
| CWM | 0.356 | 0.050 | 0.741 | 0.784 | 0.269 | 0.284 | 4.7 | 0.208 | 67.5 | 0.384 | 24.8 |
| LynnReal-Omni | **0.457** | **0.036** | **0.809** | **0.852** | **0.379** | **0.395** | **1.4** | **0.101** | **74.8** | 1.676 | 24.2 |
| Seedance 2.5 | 0.336 | 0.058 | 0.758 | 0.829 | 0.259 | 0.282 | 4.5 | 0.216 | 66.4 | **0.257** | 24.9 |
| MiniMax-H3 | 0.409 | 0.055 | 0.758 | 0.806 | 0.326 | 0.337 | 3.6 | 0.168 | 71.6 | 0.407 | 24.8 |

（粗体按原表标注。两个设置场景不同，不能跨设置直接比。按表核对过：类均值 IoU、Warp 类均值、"Cosmos IoU 排第 4 / 第 3 但 ISR、LRA 两个设置都最低"、"LingBot ISR 最高但 IoU 倒数第三、gISR 第五"等正文说法都和表一致。）

### 七条结论（§4.5，[[topics/papers/代码世界模型与神经渲染/3-06_2610.02205_PROWBench.pdf#page=10|第 10–15 页]]）

1. **T1 给代理比只给相机好得多（实体和事件）**：两个"给代理"的类别在 40 个 Verified-FF 场景里 38 个、89 个 Unverified-FF 场景里 87 个 IoU 更高（中位数 +0.14，p < 10⁻⁸）；类均值 Verified-FF 0.450（专用渲染器）/ 0.464（通用底座）对 0.322，Unverified-FF 0.376 / 0.373 对 0.235。相机条件世界模型靠跟拍相机能把主角放对（0.43 / 0.42 对 0.46–0.54），但放不对其他实体（0.26 / 0.20 对 0.38–0.44）。通用底座的 LRA 在两个设置里都显著高于世界模型（p < 10⁻³）。但专用渲染器整体在 ISR 上不比世界模型好，被 Cosmos-Transfer2.5 拖了后腿。
2. **T2 相机跟随打平**：代理视频本身就是按规定相机渲的，隐含了相机运动。通用底座没有相机输入，CamMC 和三个世界模型打平（p = 0.87 / 1.0）。逐样本对比 LingBot 2.0（Unverified-FF 里 CamMC 最低的世界模型）：H3 赢 52%、Seedance 36%、LynnReal-Omni 78%（图 4）。**代理的构成影响相机控制**（图 5，LynnReal-Omni，20 对）：只有实体框 → 加地面 → 加天空 → 加 50% 背景物体，CamMC 0.243 → 0.213 → 0.223 → 0.147，旋转误差 6.89° → 3.31°；完整背景的参考 CamMC 0.109、旋转 1.91°（但这一档提示词和首帧也不同，不是受控一步）。
3. **T3 通用底座已经能渲好短片**：和专用渲染器比，IoU 相当（22/40、43/89 个场景更高），相机误差更低（CamMC 29/40、76/90，p ≤ 0.007），Unverified-FF 的 ISR、LRA 更高（p ≈ 10⁻⁶），Warp 类均值 0.38 / 0.33 对 0.72 / 0.83。
4. **T4 通用微调收益不一，领域事件仍需专门训练**：CWM 和 LynnReal-Omni 都基于 H3。CWM 在 71% 的 Unverified-FF 对里 IoU 比 H3 低、约 90% 画质更低，但 Warp 约 80% 更低；LynnReal-Omni 62% 的对 IoU 更高、80% 的非平局 Verified-FF 对 LRA 更高，但**每一对**的 Warp 都更高。作者提醒 Warp 低也可能只是动得少。枪战集（表 4）上：

   | 方法 | IoU | ISR | LRA | gISR | gLRA |
   |---|---|---|---|---|---|
   | C2R | 0.437 | 0.450 | 0.725 | 0.191 | 0.330 |
   | CWM | 0.413 | 0.650 | 0.900 | 0.287 | 0.381 |
   | **PWM** | **0.602** | **0.850** | 0.875 | 0.523 | 0.529 |
   | LynnReal-Omni | 0.552 | 0.625 | **0.975** | 0.340 | **0.535** |
   | MiniMax-H3 | 0.526 | 0.600 | 0.900 | 0.302 | 0.475 |

   通用模型还会出现**代理泄漏**（图 6，第 12 页）：彩色框或线框轮廓留在输出画面里，PWM 很少出现。
5. **T5 下一步是找最好的代理**（表 5，10 个 Verified-FF 对、同首帧同种子，只换 H3 的输入表示）：

   | 代理 | IoU | ISR | LRA | gISR | gLRA |
   |---|---|---|---|---|---|
   | Coarse 3D | 0.514 | 0.625 | **0.802** | 0.304 | **0.391** |
   | CWM proxy | 0.507 | 0.683 | 0.665 | 0.338 | 0.333 |
   | Colored-OBB | 0.503 | **0.733** | 0.690 | **0.347** | 0.339 |

   （表里三行的输入图标抽不出来，行序是按正文"Colored-OBB ISR 最高 0.733、Coarse 3D LRA 最高 0.802"对上的。）布局几乎不随代理变（0.503–0.514），事件指标差异只来自几个场景，10 对样本下都不显著（p ≥ 0.25）。作者凭可视化（OBB 生成的人体动作更自然）选了 OBB 作为 H3 的输入。真正没解决的是**哪个外观归哪个实体**：框代理只给位置和运动，外观要从文字里猜；人工审计 62 个多人场景，H3 有 12 个把两个人的衣服换了；朝向也会反（马的正反面）。
6. **T6 挑战赛道没有类别解决**：

   长时（[[topics/papers/代码世界模型与神经渲染/3-06_2610.02205_PROWBench.pdf#page=9|表 2，第 9 页]]，10 段 30 秒）：

   | 方法 | IoU | ISR | LRA | Re-IoU | Re-State | Rot | CamMC |
   |---|---|---|---|---|---|---|---|
   | C2R | 0.212 | 0.519 | 0.718 | 0.111 | 0.405 | 41.9 | 1.119 |
   | CWM | 0.210 | 0.504 | 0.854 | 0.053 | **0.886** | 30.2 | 0.793 |
   | LynnReal-Omni | **0.280** | 0.515 | **0.897** | 0.103 | 0.528 | **22.7** | **0.610** |
   | Seedance 2.5 | 0.175 | 0.497 | 0.777 | **0.131** | 0.650 | 39.4 | 0.819 |
   | MiniMax-H3 | 0.206 | **0.553** | 0.844 | 0.059 | 0.833 | 31.8 | 0.814 |

   - 50 个"方法 × 录制"结果里 42 个 IoU < 0.3；所有方法前 5 秒最好（0.25–0.36），10 秒后掉到 0.12–0.25（图 7）。
   - 图 8 的例子：行人 3.9 s 离开、17.25 s 回来，离开前各方法 IoU 约 0.6，回来后 CWM 0.34、LynnReal-Omni 0.30、Seedance 0.17、H3 0.01。
   - Re-State 只覆盖每个方法 17–21 个事件，裁判未校准，只能看趋势；各方法的分窗续写协议也不同（Seedance 2.5 额外拿上一窗口末帧），所以测的是端到端长时保持，不是孤立的内部记忆。

   多视角（[[topics/papers/代码世界模型与神经渲染/3-06_2610.02205_PROWBench.pdf#page=10|表 3，第 10 页]]，10 场景 × 4 视角）：

   | 方法 | IoU | Miss↓ | ISR | LRA | Comp.% | Cons.% | MEt3R↓ | CamMC |
   |---|---|---|---|---|---|---|---|---|
   | C2R | 0.414 | 0.192 | 0.637 | 0.750 | 32.2 | 25.5 | **0.397** | 0.173 |
   | CWM | 0.439 | 0.064 | 0.812 | 0.950 | 92.9 | 88.1 | 0.422 | 0.071 |
   | LynnReal-Omni | 0.490 | **0.047** | 0.700 | 0.900 | 87.6 | **89.7** | 0.448 | **0.026** |
   | Seedance 2.5 | 0.341 | 0.089 | 0.812 | **0.963** | 82.2 | 81.0 | 0.499 | 0.083 |
   | MiniMax-H3 | **0.524** | 0.049 | **0.825** | 0.938 | **94.0** | 88.6 | 0.400 | 0.043 |

   C2R 的 MEt3R 最好（几何最互洽），外观合规和跨视角一致却最差——灰模代理把所有玩家画得一样，又没首帧。输入能区分参与者的方法（身份色框或首帧）达到 82–94% / 81–90%，但最好的也有 10–19% 的视角对把同一个人画成不同衣服。
7. **T7 新指标测到了老指标漏掉的东西**：场景内各方法 IoU 和 ISR 的 Spearman 相关平均只有 0.05 / 0.06（LRA 为 0.14 / 0.12），说明事件指标和放置基本独立；给裁判错配的时间线，各方法 LRA 从 0.46–0.85 掉到 0.07–0.20，说明 LRA 确实对规定内容敏感；CLIP 分数在方法间只差均值的 4.5–5.7%、平滑度约 1.6%，而 IoU 差 53–79%、ISR / LRA 差 38–58%。Unverified-FF 里 LynnReal-Omni 实体、相机、逻辑指标全部领先，CLIP 却最低（24.2）。

主赛道两种设置的方法排名高度一致：IoU、平移误差、CamMC、LRA 的 Spearman 相关分别为 0.98、0.98、0.99、0.93。

## 局限 / 存疑

- **MiniMax-H3 偏置（作者自己承认）**：Verified-FF 的首帧由 H3 生成；Unverified-FF 的评测集是用 H3 的输出筛的，而且需要 RGB 的方法（世界模型、CWM）拿的是 **H3 输出的第 0 帧**——这一帧会把 H3 的外观分配传给别的方法。所以"通用底座不用适配就很强"这一主结论里，H3 的部分要打折扣看。
- **VLM 裁判没有和人工标注校准**（第 14–15 页）：ISR、LRA、外观合规、State Persistence 都由 Qwen3.6-27B 判，论文只做了错配时间线的敏感性检查，没有人机一致率。相比之下 [[topics/notes/代码世界模型与神经渲染/3-04_WorldDraft|WorldDraft]] 至少报了 91.0% 的人机一致率。
- **相机指标的噪声不小**：ViPE 在引擎渲染图上自己就有 1.1–5.4° 的旋转误差（Verified-FF 是 1.1–2.7°），而多数方法的 Rot 就在 1.7–3.6°，所以作者说"大多数方法与估计器误差相当"——这些差异基本测不出来。另外平移按最大范数归一，只比路径形状，不比走了多远。
- **样本量小**：挑战赛道各 10 个；表 5 的代理比较只有 10 对、没有任何显著差异，但作者据此（加上主观可视化）给 H3 选了 OBB 输入，而 OBB 的 LRA（0.690）其实比粗 3D（0.802）低。
- **输入不对等**：每个方法用"原生接口"喂，所以不同方法拿到的信息差别很大——Verified-FF 里 Cosmos-Transfer2.5 和 C2R 不拿首帧（外观参考），CWM 多拿深度，世界模型没有实体轨迹；提示词也被转换成各自格式（C2R 的提示被压到 512 token、去掉时间戳）。所以表 1 比的是"方法 + 接口"整体，不是渲染器本身。
- **PWM 的输入和训练数据说法不一（需核对）**：§4.1 说 PWM 输入 Colored-OBB 代理，表 C.1 写的是"来自 3D 框的实例 ID 图"；§4.1 说 PWM"只在枪战场景上训练"，而 [[topics/notes/代码世界模型与神经渲染/1-04_ProgrammableWorldModel|PWM 笔记]]记的训练数据是《赛博朋克 2077》《极限竞速：地平线 6》《GTA V》的录像、评测在 CombatStateBench。可能是指 PROWBench 测的那个检查点只用了枪战数据，论文没说清。
- **LingBot 2.0 的引用（需核对）**：参考文献 [43] 是 "Advancing open-source world models"（arXiv 2601.20540），PWM 笔记里这篇对应的是 LingBot-World-v1。
- **标题不一致**：v2 PDF 首页标题是 "ROWBench"，arXiv 和正文都是 PROWBench；WorldDraft 的参考文献也写成了 "Rowbench"，大概就是这个原因。
- **引擎和数据来源没说**：底层是什么引擎、场景配置是人写还是智能体写的、"source recordings / source descriptions"指什么，正文都没交代；交互标签是"AI 辅助审核"的，作者也说这些标签不代表独立验证过的物理接触或因果。
- **"170 个 episode"不全是独立录制**：枪战 20 个 case 来自 10 段源录制，episode ID 只标识 benchmark case（附录 A.1）。
- **只测短窗口内的"遵循"，不测交互实时性**：所有方法离线生成，不涉及延迟或流式；长时是各方法自己的分窗续写。

## 与其他论文的关系

### 和 WorldDraft 的对比（同一问题的两种测法）

两篇都问"代码 / 引擎定下了世界，视频模型能不能只负责把它画对"，都用 Qwen3.6-27B 当 VLM 裁判、SAM 3 + 匈牙利匹配算框，但设计取向很不一样。[[topics/notes/代码世界模型与神经渲染/3-04_WorldDraft|WorldDraft]] 的 QA 协议说是沿用 PROWBench 的做法。

| | PROWBench（2026-10，Alaya Lab） | WorldDraft（2026-11，南科大 / 港科大等） |
|---|---|---|
| 世界从哪来 | 自家程序化生成框架 + 行为控制器（引擎未说明），偏游戏场景：城市、室内、赛车、水下、驾驶、枪战 | GPT-6-Astra 照真实视频写 MuJoCo / Blender 脚本，偏物理交互：碰撞、多米诺、形变、遮挡 |
| 规模 | 170 episode / 200 视角 / 600 代理视频 | 48 个世界族 × 9 种草稿 = 432 个配对用例 |
| 渲染器的输入 | 按各方法原生接口：代理视频（三种表示之一）、深度、分割、相机轨迹、首帧、**带时间线和主体绑定的长提示词** | 统一只给"RGB 草稿视频 + 一句目标描述"，**不写轨迹和相机**，没有首帧 |
| 受控变量 | 代理表示（粗 3D / CWM 代理 / OBB，只在 10 对上做）、视角（第一 / 第三人称、同步多视角）、时长（5 s / 30 s）、有无校验首帧 | 草稿精细度（P0–P2）× 外观对齐（中性 / 一致 / 冲突），在全部 48 个世界上做 |
| 主要指标 | 框 IoU、ISR、LRA、相机误差、长时重现、跨视角外观一致 | 世界保持（计数、框 IoU、轨迹、交互、相机）、属性渲染、外观持续、冲突惩罚、源泄漏，再合成总分 |
| 外观怎么测 | 主赛道不测细粒度属性（只有 CLIP）；多视角设置有按 5 个属性判的外观合规和跨视角一致 | 每个世界 2–4 个可验证属性，测"正确且持续绑定"，还专门测冲突外观的泄漏 |
| 被测范围 | 11 个：4 个相机条件世界模型 + 5 个专用渲染器（含 CWM、PWM、Cosmos-Transfer2.5）+ 2 个通用底座 | 12 个：生成式渲染器（SolarRenderer、C2R）+ omni 模型 + VACE 类 + 2 个商用；**没有世界模型，也没有 CWM / PWM** |
| 人机一致性 | 没做 | 6 个指标平均 91.0% |

**两边都测了的模型，结论并不一致**：

- **LynnReal-Omni** 在两边都是第一梯队（PROWBench Unverified-FF 几乎全部领先；WorldDraft 总分第一 64.89）。
- **MiniMax-H3** 在 PROWBench 的实体 IoU 排第二（0.494 / 0.409），多视角 IoU 第一；在 WorldDraft 里世界保持 WP 只有 50.70，12 个里倒数第二。可能的原因（推测，两篇都没讨论）：PROWBench 给 H3 的是**带身份色、白色正面的 OBB 代理 + 逐段时间线 + 明确的"几何听代理"控制块**，WorldDraft 只给 RGB 草稿和一句不含轨迹的描述，H3 更容易"自由发挥"成文生视频；另外 PROWBench 的 Unverified-FF 集是用 H3 输出筛的。
- **C2R** 两边都偏弱（WorldDraft WP 53.05；PROWBench 相机误差最大、多视角身份最差）。
- **Seedance 2.5** 在两边都是"事件 / 外观好、结构一般"（PROWBench LRA 高、IoU 中等；WorldDraft RF 75.55、WP 58.66）。

**两边独立观察到的同一类失败**：WorldDraft 的"草稿越精细外观越差""冲突源颜色泄漏"，和 PROWBench 的"输出会继承低模代理的粗糙形状""彩色框 / 线框留在画面里（代理泄漏，图 6）"是同一现象——渲染器把条件视频的像素当成要照抄的内容，而不是可覆盖的脚手架。PROWBench 用 OBB 的"颜色只是身份码、白面不许画出来"这类提示词来压，WorldDraft 用只改首帧的 Primer。

**互补之处**：WorldDraft 补上了 PROWBench 没做的外观冲突、属性持续绑定和人机校准；PROWBench 补上了 WorldDraft 没做的长时（30 s）、离开视野再回来、同步多视角、第一人称，以及把相机条件世界模型和代码世界系统（CWM、PWM）放进同一张表。另外 WorldDraft 把 PROWBench 描述为"外观只用 CLIP 一类整体分数"，对主赛道成立，但 PROWBench 的多视角设置其实有按属性的外观合规和跨视角一致指标。

### 和专题其他工作

- **第一次给 CWM、PWM 定量成绩**：[[topics/notes/代码世界模型与神经渲染/1-01_CodeWorldModel|CWM]] 原文没有任何定量指标，这里第一次被系统测：短片 IoU 低于它的底座 H3（71% 的对更低），但长时 State Persistence 最高（0.886），多视角外观合规 92.9%（靠首帧）。[[topics/notes/代码世界模型与神经渲染/1-04_ProgrammableWorldModel|PWM]] 只在枪战集上测，ISR 0.850 / IoU 0.602 都是第一，支持"领域事件需要专门训练"；PWM 原文首页挂的基准链接就是 PROWBench（PWM 笔记里记过"CombatStateBench 和 PROWBench 是否同一个"这个疑问——现在看 PROWBench 是更大的独立基准，枪战集是其中专为 PWM 准备的 20 个 case）。
- **条件信号之争**：专题脉络里条件信号从 G-buffer 一路变粗到低模代理。PROWBench 的 T5 在固定生成器下比较了粗 3D、CWM 代理、OBB 三种粗表示，发现布局几乎不变、差别在身份和朝向上；T2 发现**背景结构**对相机跟随帮助很大（只有框时旋转误差 6.89°，加一半背景降到 3.31°）。这对只给实体框的方案（PWM、[[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]] 的低模代理）和只给语义图的 [[topics/notes/代码世界模型与神经渲染/1-12_StreamRender-H3|StreamRender-H3]] 都有参考价值。没测的有 [[mirros/notes/01_AgentGarten|AgentGarten]] 的深度 / 法线、[[topics/notes/代码世界模型与神经渲染/2-06_AlayaRenderer-Flash|AlayaRenderer]] 的 G-buffer（同组的 AlayaRenderer 系列反而没进被测列表）。
- **"通用底座 + 代理"够用吗**：T3 的结论（H3 不微调就能渲好 5 秒短片）和 CWM、StreamRender-H3、[[topics/notes/代码世界模型与神经渲染/2-09_SolarRenderer|SolarRenderer]]、[[topics/notes/代码世界模型与神经渲染/1-05_CoDeR|CoDeR]] 都以 H3 为底座是一致的；T4 又说通用微调收益不一，CWM 的微调反而降低了实体放置。[[topics/notes/代码世界模型与神经渲染/2-14_LynnReal-Omni|LynnReal-Omni]]（本批将有笔记）在两个基准里都最稳。
- **[[topics/notes/代码世界模型与神经渲染/1-15_GameWM|GameWM]]** 主张交互细节交给视频模型生成；PROWBench 的 ISR 正好测"规定的交互是否发生、终态是否对"，但只看动作和终态，不管视觉细节怎么实现，和 GameWM 的取向不冲突。
- **AlayaWorld v1.1**（同组的相机条件世界模型）在相机误差上明显最差（Rot 9.4° / 10.7°），作者没有回避。
- **同类评测**：[[topics/notes/代码世界模型与神经渲染/3-04_WorldDraft|WorldDraft]]（见上）；[Video2World](https://arxiv.org/abs/2610.04432) 评上游"看视频搭仿真"；[VibePrevisBench](https://arxiv.org/abs/2611.15789) 评编码智能体在 Blender 里搭 4D 场景出灰盒代理视频；[ExeWorldBench](https://arxiv.org/abs/2610.15166) 评编码智能体建可执行 3D 世界。PROWBench 只评下游渲染这一环，世界由它自己的引擎固定。[[topics/notes/代码世界模型与神经渲染/1-10_Mallea|Mallea]] 说过要用 PROWBench 评物理结果，但还没有结果。
- **和机器人 / 导航的联系**：
  - 长时设置里"离开视野的行人 13 秒后回来要出现在引擎记录的位置"、第一人称相机、地标重访（landmark revisitation），和具身导航世界模型的需求几乎一样；30 秒后 IoU 掉到 0.2 左右、重现 IoU 0.05–0.13，说明现在拿生成式渲染器给导航智能体当闭环仿真（[[topics/视觉语言导航VLN]] 里"世界模型 / 想象"一类方法，如 DreamNav、NavMorph，依赖的正是这种长时一致性）还远不够可靠。
  - "程序记录状态 + 视频模型渲染 + 按记录逐帧校验"这套思路可以直接搬去评 sim-to-real 用的生成式渲染（同样是"仿真器给几何，视频模型给外观"），表 A.1 也把 WorldArena、TriWorldBench 这类具身世界模型基准列为对照；同专题的 [[topics/notes/代码世界模型与神经渲染/2-16_RoboRender|RoboRender]]（把仿真机器人轨迹渲成逼真视频做视觉 sim-to-real）就可以按这种方式评。
  - 多视角设置（四个玩家各自的视角独立生成、要对上身份）对应多机器人 / 多智能体协同仿真里的一致性问题。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文是 CC BY 4.0，必要处可引原句，这里仍以位置和要点为主）
> 1. 第 1 页图 1 图注：CLIP 给更差的视频打了更高分（24.51 对 22.29），交互指标 0/3 对 3/3 → 为什么需要事件级指标
> 2. 第 2 页 §1 第 1 段：程序执行正确不保证视觉实现正确，原句 "can video models faithfully render the scene structure, rules, and interactions of a programmable world?" → 核心问题
> 3. 第 4–5 页 §3.1：世界合成、控制编译 `I = R_r(G, S_i, C_i^v)`、三种代理表示、四类校验 → 管线设计
> 4. 第 6 页 §3.2 式 (1)–(4)：ISR 要求动作和终态都判 yes；LRA 按时间线分段；gISR / gLRA 乘 IoU → 指标定义
> 5. 第 7 页 §3.3：Verified-FF 40 对、Unverified-FF 90 对，Unverified 集用 H3 输出筛选、需注意偏置 → 赛道设计与 H3 偏置
> 6. 第 7–8 页 §4.1–4.2 与表 1：11 个方法分三类、各按原生接口输入；需要 RGB 的方法拿 H3 第 0 帧 → 被测方法与输入不对等
> 7. 第 10–11 页 T1、T2 与图 5：类均值 IoU 0.450 / 0.464 对 0.322；相机打平；加 50% 背景使旋转误差 6.89° → 3.31° → 代理优于相机条件、背景帮相机
> 8. 第 12 页 T4 与表 4：PWM 枪战 ISR 0.850 对通用模型 0.450–0.650；图 6 代理泄漏 → 领域事件需专门训练
> 9. 第 13 页 T5 与表 5：三种代理 IoU 0.503–0.514、10 对样本 p ≥ 0.25；62 个多人场景 H3 换衣 12 次 → 代理选择与身份绑定问题
> 10. 第 13–15 页 T6、T7 与局限段：30 s IoU 0.175–0.280、Re-IoU 0.053–0.131；VLM 裁判未经人工校准、ViPE 自身误差 1.1–5.4° → 挑战赛道结论与局限

## 摘要（中文）

可编程世界模型把可执行的动力学与视觉生成分离，为下一代游戏引擎提供了有前景的基础。然而，它们在视觉上对显式规则和交互的遵循程度仍缺乏充分评估。现有基准评估视觉质量、可控性以及指令或物理遵循，却很少检验对程序规定的细粒度世界事件的忠实度。我们提出 PROWBench，包含 170 个程序化构造的 episode 和 600 段代理视频，覆盖多样的场景与交互。PROWBench 把实体状态和带时间戳的事件（包括相机视野之外的）记录为可重放的世界记录，并据此渲染同步的视角和代理表示，从而可以对照程序执行的可观测后果来检查生成视频。一个可扩展的框架负责构建场景、控制行为，并能把每个相机视角渲染成不同的表示，例如粗 3D 和包围盒。基准覆盖第一人称和第三人称视角，部分 episode 提供同步的多视角观测。基于这些记录，PROWBench 评估实体控制、长时记忆，并用两个基于 VLM 的指标——逻辑-渲染对齐和交互成功率——评估对规定时间线的遵循以及引擎记录的带时间戳事件的视觉实现。

## 摘要（原文）

论文采用 CC BY 4.0 许可，以下转录 arXiv 摘要原文：

> Programmable world models separate executable dynamics from visual generation, offering a promising foundation for next-generation game engines. However, their visual adherence to explicit rules and interactions remains insufficiently evaluated. Existing benchmarks assess visual quality, controllability, and instruction or physical adherence, but rarely test fidelity to fine-grained, program-specified world events. We introduce PROWBench, comprising 170 programmatically constructed episodes and 600 proxy videos covering diverse scenes and interactions. PROWBench logs entity states and timestamped events, including those outside the camera's field of view, as replayable world records, from which it renders synchronized views and proxy representations. This enables generated videos to be checked against the observable consequences of program execution. An extensible framework constructs scenes, controls behaviors, and can render each camera view in different representations, such as coarse 3D, and bounding boxes. The benchmark covers first- and third-person perspectives, with synchronized multi-view observations available for a subset of episodes. Grounded in these records, PROWBench evaluates entity control, long-horizon memory, and, with two VLM-based metrics, Logic-Render Alignment and Interaction Success Rate, adherence to the prescribed timeline and the visual realization of timestamped engine-recorded events.
