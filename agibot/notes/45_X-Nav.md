---
id: "45"
org: 智元
short: "X-Nav"
title: "X-Nav Technical Report: Real-World Long-Horizon Indoor-to-Outdoor Navigation on a Humanoid Robot"
aliases: ["X-Nav", "MELIOR", "MELIOR-A", "MELIOR-N", "MELIOR-X", "X-Navarch"]
date: 2026-11-12
category: "导航"
source: "智元主导"
product: "灵犀 X2"
partners: ["MBZUAI", "电子科技大学", "澳门大学", "南洋理工大学", "墨尔本大学", "武汉大学"]
authors: ["Jiaxin Huang", "Chengxing Lin", "Xiaoyu Luo", "Sirui Chen", "Jingyu Guo", "Aolin Li", "Kairui Chen", "Rui Zhen", "Cheng Wen", "Kerui Gu", "Shunyao Wang", "Zhihui Peng", "Shaoli Huang"]
arxiv: "2611.17598"
pdf: "[[agibot/papers/45_2611.17598_X-Nav.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "agibot", "lingxi", "vln", "humanoid", "real-world", "digital-twin", "3dgs", "agentic-workflow", "long-horizon"]
---

# X-Nav Technical Report: Real-World Long-Horizon Indoor-to-Outdoor Navigation on a Humanoid Robot

> [!info] 论文信息
> arXiv [2611.17598](https://arxiv.org/abs/2611.17598) · v1 2026-11-12 · 技术报告
> 单位：智元 X-Lab（Boson Lab）为主，另有 MBZUAI、电子科大、澳门大学、南洋理工、墨尔本大学、武汉大学（六位共同一作各自的学校）· 项目负责人 Jiaxin Huang · 通讯作者 Shaoli Huang
> PDF：[[agibot/papers/45_2611.17598_X-Nav.pdf|本地 PDF]]（24 页：正文 19 页 + 参考文献 + 附录 A–D）
> 角色：智元主导 · 机型：灵犀 X2（全部真机结果）
> 论文里没有代码、项目页或模型权重链接
> 汇总：[[agibot/智元-论文与报告汇总|智元论文与报告汇总]] · 相关专题：[[topics/视觉语言导航VLN|视觉语言导航VLN]]

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-17）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。

## 一句话总结

一套从数据到上机的**人形机器人长程导航系统**：数据引擎从三处采数据（开源仿真场景 630 万步、部署现场的 3DGS 数字孪生、灵犀 X2 真机），导航模型 **MELIOR** 只看机器人自带头部相机的单路 RGB，分输出动作的 **MELIOR-A**（Qwen3-VL-8B）和输出导航目标点的 **MELIOR-N**（Qwen3.5-4B），智能体工作流 **X-Navarch** 用 GPT-6 当规划器把一句话任务拆成子任务，路线交给 MELIOR、最后几米找具名物体交给 **MELIOR-X**（LocateAnything + VLM 校验 + SAM3 跟踪 + LiDAR 测距），再经目标适配器和避障层交给运动控制器。灵犀 X2 无地图、无参考路线走完**约 100 米、从写字楼大堂到隔壁楼便利店**的室内到室外任务（MELIOR-A 那次 96.6 m / 3 分 24 秒）。在大堂数字孪生里加纠错数据做 LoRA 适配，闭环 3 m 内停下的比例 34% → 78%。R2R-CE 上 MELIOR-N SR 70.5%，单目前向 RGB 方法里最高。

## 要解决什么问题

作者的问题意识是"导航有没有迎来 GPT 时刻？榜单上像，真机上还没有"。仿真高分转不到真机，原因归到三处：

1. **问题本身**：基准一集只有 10–15 m、在一栋楼里，相机高度固定、动作精确执行、场景里没东西动，停在 3 m 内就算成功。真实"任务"（mission）路线长几倍、要出楼，相机随步态晃动，执行的步子和命令不一样，有人、推车、汽车穿过，而且要停在店门口而不是 3 m 内。
2. **数据**：标准 VLN 数据都是扫描室内场景 + 模拟相机，既没有部署现场，也没有机器人自己的相机、步态和停止行为；参考路线只演示正确行为，没有从错误中恢复的样本。所以"先问要什么数据，再问要多少"。
3. **上机**：模型不等于会走的机器人。别人上机多是额外加一个 RealSense D455；任务还需要拆子任务、检查每次停下、在机器人继续走时让预测的目标点保持有效、避障、走完到具名目标的最后几米。

他们给"任务"的定义：双足人形收到自然语言指令（途中可能改），导航模型只看自带相机的 RGB，没有现场地图和参考路线，路线约 100 m、室内出发室外结束、沿途有静态和动态障碍，停在指令说的目的地才算完成。

作者声称这是第一个让双足人形完成**语言指令、约百米、跨室内外**任务的系统（表 1 对比 Qwen-RobotNav、Robostral Navigate、NavGPT-3、VbotNav-0、HoloAgent-0）。

## 方法

### 整体：三个嵌套循环（§2.1，[[agibot/papers/45_2611.17598_X-Nav.pdf#page=4|图 2，第 4 页]]）

- **L1 子任务循环**：MELIOR 看帧 → 预测动作或目标 → 机器人执行，直到模型判停或碰到上限。
- **L2 任务循环**：规划器设一个子任务、交给技能（路线给 MELIOR，具名目标给 MELIOR-X），交还控制时复查结果，决定继续下一个、改写当前的、还是结束任务。
- **L3 部署循环**：现场扫成数字孪生 → 用孪生里采的参考轨迹和纠错窗口适配模型 → 在孪生里闭环评测 → 上机；X-Navarch 记录每次任务，失败片段可以回放、新区域可以补扫。

两类子任务分开处理（§2.3、表 6）：**路线**（"穿过大堂、出玻璃门右转"）用**隐式导航**，指令→动作或目标点，路线只存在模型权重和上下文里；**具名目标**（自动售货机、蓝沙发、店门口）用**显式导航**，维护一个可检查的目标状态（图像掩码 $M_t$ + 机器人基座系位置 $\mathbf p^B_t$）。理由是端到端模型"到附近"比"停在那儿"容易得多（表 4 里 OSR 和 SR 的差距），而且目标小、被挡、视角变的时候没法检查模型内部的目标表示。

### 机器人与算力（§2.4）

- 灵犀 X2：头部 RGB 相机、向下俯视的 RGB-D 相机、LiDAR、腿式里程计。
- **MELIOR 只用头部 RGB**（矫正到 640×480、水平视场 79°），不加装相机。RGB-D、LiDAR、里程计只给 MELIOR-X 和底层执行用。
- 推理在**机外 GPU**，通过网络和机器人交换帧和目标。

### 数据引擎（§3）

| 来源 | 数据集 | 规模 | 提供什么 |
|---|---|---|---|
| 开源场景 | X-Nav-Syn | 111 万步 / 23,761 条轨迹 / 1,095 个场景（VLNVerse 176 个合成场景 46.1 万 + SAGE-3D 919 个重建场景 65.3 万）；再回放 R2R 63.7 万、RxR 188.9 万、SRDF 267.1 万，合计 **631 万步** | 规模和多样性 |
| 数字孪生 | X-Nav-Twin | 2,500 条轨迹、78,010 个纠错窗口（图 3） | 部署现场的布局和外观 |
| 真机 | X-Nav-Real | 15,000 条轨迹（图 3） | 机器人自己的相机视角、步态、停止位置 |

- **X-Nav-Sim**：基于 Isaac Sim 的采集 + 评测平台。批量回放用位姿控制相机；用仿真 X2 时按机器人轮廓规划、经运动控制器执行。
- **轨迹生成**（[[agibot/papers/45_2611.17598_X-Nav.pdf#page=7|图 4、图 5，第 7 页]]）：
  - **目标位姿采样**：同一物体只设一个终点位姿，从不同起点来的路线最后画面全一样；所以在物体周围采多个候选位姿，查可达、停得下、能面向并看见目标（距离、视角、视线、遮挡、截断），通过的轮流使用。
  - **离线规划**：按场景、任务类型（目标导向 / 逐步路线）、目标类别、长度区间分配配额；占用栅格上 A*，**偏好 0.35 m 净空**；平滑后离散成 0.25 m 前进和 15° 转弯；检查扫掠碰撞、终点位姿和停止标签。
  - **回放与标注**：渲 RGB-D 并记位姿；VLM 根据 8–24 个关键帧、路线图和目标元数据写指令。每步导出两种监督：后续动作序列（给 A），或路线上某个未来位姿的相对位置和朝向，目标点在视野内且通过深度遮挡检查时再记像素坐标（给 N）。
- **数字孪生**（§3.3.2，[[agibot/papers/45_2611.17598_X-Nav.pdf#page=8|图 6，第 8 页]]）：手持设备扫 RGB + 点云 + 位姿；外观用 3DGS，深度和可通行性用网格 + 占用层；大堂里人工标定 35 个具名物体的物体图。**纠错窗口**：在孪生里跑当前策略，用参考规划器标注"偏离后怎么回来"（恢复窗口）和"该不该停"（停止边界窗口），就是 DAgger 的做法。500 条轨迹设置下：参考 32,404 + 恢复 9,601 + 停止边界 6,001 = 48,006 个窗口；2,500 条设置是它的 5 倍（比例 67.5 / 20.0 / 12.5%）。
- **真机采集**：自研软件录机载 RGB 和机器人运动，支持同一现场多台机器人并行采；目标类别有垃圾桶、咖啡机、售货机。

**MELIOR-N 的 SFT 数据**（§3.4，[[agibot/papers/45_2611.17598_X-Nav.pdf#page=9|图 7，第 9 页]]）：共 8,551,878 条 = 导航 6,310,664（73.8%）+ LLaVA-Video 1,650,547 + VSI-590K 590,667（合 26.2%，用来保住骨干的视觉语言能力）。

### MELIOR：一个输入约定，两种输出（§4，[[agibot/papers/45_2611.17598_X-Nav.pdf#page=10|图 8，第 10 页]]）

输入相同：指令 $I$（路线描述，或规划器给的子任务）+ 当前帧 $o_t$ + 至多 7 张更早的采样帧 $H_t$，自回归 VLM：$y_t \sim \pi_\theta(\cdot \mid I, H_t, o_t)$。

- **MELIOR-A**（Qwen3-VL-8B）：每次决策输出至多 4 个原子动作 {前进 0.25 m, 左 15°, 右 15°, 停}，就是 VLN 基准的动作空间，所以能直接上榜。**真机上把一次推理的几个动作合成一个相对位姿目标**交给运动控制器，一次推理最多走 1 m。
- **MELIOR-N**（Qwen3.5-4B）：每次决策输出一个导航目标，四种模式（式 2）：
  - `<visible>(u, v, r, φ, ψ)`：在当前画面里指一个像素点（类似 InternVLA-N1 / DualVLN、Robostral 的"指点"）
  - `<polar>(r, φ, ψ)`：目标不在视野内时给极坐标
  - `<rotate>(ψ)`：原地转
  - `<stop>`
  - 词表 365 个专用 token（附录 A、表 5）：5 个控制 token，像素 256 档（u、v 共用），距离 32 档（0–15 m 上按 $\log(1+r)$ 均匀分），角度 72 档（5° 一档，φ、ψ 共用）；解码时每个位置只允许对应字段的 token。
  - 仿真执行：`<visible>` 用仿真深度反投影像素、映射到导航网格、最短路跟随，**预测的 r、φ、ψ 在这一支不用**；每次决策最多执行 4 个原子动作。
- **训练两阶段**（§4.4）：SFT（R2R、RxR、SRDF、X-Nav-Syn + 视频/空间问答），然后在仿真里跑模型、用 **DAgger** 收集它实际访问状态上的专家纠正再微调。H20 上 MELIOR-A 约 4,450 GPU 时，MELIOR-N 约 3,115 GPU 时。

### MELIOR-X：显式接近具名目标（§5，[[agibot/papers/45_2611.17598_X-Nav.pdf#page=12|图 10，第 12 页]]）

把"语义判断""视觉传播""几何控制"三件事拆开：

1. **找目标并校验**（1–2 Hz）：LocateAnything-3B 每张图给至多 3 个候选框 → Qwen3-VL-2B 校验器看候选裁剪 + 周围上下文，对照类别、颜色、外观、结构、姿态答 YES/NO；分数 $s = \sigma(\ell_{YES} - \ell_{NO})$（首 token logits），≥0.5 保留、取最高；占画面 >60% 的框丢掉。**连续两次接受**同一查询才初始化（不约束框的位置，因为机器人在转）。
2. **跟踪**（20 Hz）：第二个接受的框作为 SAM3 的提示，之后普通帧只靠 SAM3 视频记忆传播掩码，不调语言模型。查询变了、显式重置、或连续 3 帧没有有效掩码就重新找。
3. **测距**：把标定好的 LiDAR 点投到图像，取落在掩码内、且在向中心收缩的框内的点（式 4），按相机轴深度做百分位窗口取前景，至少 2 个点，基座系坐标取逐维中位数（式 5）。
4. **近距离换视角**：目标接近头部相机画面下沿时，切到向下的 RGB-D 相机，重新找 + 校验，再用掩码内的对齐深度测距；同一时刻只有一个相机持有跟踪状态，失败就回到 RGB 视角重新获取。
5. **接近控制**（式 6）：比例控制；方位误差带死区，超出前向锥就原地转，前进速度随方位误差缩放（系数下限 0.2），到视角相关的停靠距离就停；LiDAR 障碍检测可以额外刹停。对外接口只返回"到达"或"没找到目标"。

### X-Navarch：智能体工作流（§6，[[agibot/papers/45_2611.17598_X-Nav.pdf#page=13|图 11，第 13 页]]）

- **规划器**：多模态大模型（表 7：**GPT-6**），基于 **NavGPT-3 公开的运行时**改造；输入是任务指令和前向 RGB 帧，只有 4 个工具：`observe_forward`、`navigate_by_instruction`、`navigate_relative`、`terminate_episode`。**不用地图、不用参考路线**。
  - 每次只设一个子任务：路线子任务写成一句话交给 MELIOR-N，目标查询交给 MELIOR-X。
  - **规划器不在技能的循环里**，机器人按当前技能的节奏走。交还条件：MELIOR-N 判停、MELIOR-X 报到达、32 个导航目标、180 s、失败、新的任务指令。
  - 交还时规划器看当前帧复查：继续 / 改写当前子任务 / 结束任务。**模型的 stop 只结束子任务，任务是否完成由规划器决定**。人随时可以发新指令替换当前任务。
- **目标适配器**（式 7）：预测出来时那一帧已经过时了（机器人还在走）。对像素目标，取过该像素的射线上的 LiDAR 距离（接受 0.10–8 m），得到采图时刻 $t_0$ 的体坐标点，固定到里程计系，发布时刻 $t_1$ 再变回体坐标：$g(t_1) = T_{t_1}^{-1} T_{t_0}\, g(t_0)$，于是推理和网络延迟不会让目标漂。没测到距离就丢掉这条命令、保留上一个目标。一次只发一个目标位姿，新的覆盖旧的；**大约每 4 秒取一张新帧**。只发目标位姿，不发速度命令。心跳每 0.2 s，断 0.8 s 停机。
- **避障三层**：规划器在交还时看到障碍可以在下一个子任务里点名并说从哪边过；MELIOR-N 的训练路线带净空偏好，像素目标落在空地上；目标位姿和运动控制器之间有一层**基于测距的避障层**，静态障碍局部绕行、动态障碍让行、堵死就停。MELIOR-X 用自己的 LiDAR 障碍检测。

## 实验与关键数字

### 真机长程任务（§7.1）

同一条路线：写字楼大堂 → 过门 → 沿马路 → 隔壁楼一层的便利店（Lawson），约 100 m。两次运行，**各一次**。

**MELIOR-A 直接跟指令**（[[agibot/papers/45_2611.17598_X-Nav.pdf#page=15|图 12，第 15 页]]）：

| 项目 | 数字 |
|---|---|
| 总路程（里程计累计） | **96.6 m**，用时 3 分 24 秒（平均约 0.47 m/s） |
| 室内 / 室外 | 34.2 m / 62.4 m |
| 改目的地 | 走到 9.1 m 时操作员发新指令（原目标是售货机），指令用文字描述了路线：穿大堂、过玻璃门、右转、到前面那栋楼脚下的店 |
| 出门 | 34.2 m 处过玻璃门，傍晚低角度阳光、开阔地、几十米外的楼 |
| 让车 | 63.7–65.5 m 之间等了 24 s，让一辆车和行人过去 |
| 到达 | 85.9 m 看到店招，96.6 m 停在店门口 |

**X-Navarch + MELIOR-N**（[[agibot/papers/45_2611.17598_X-Nav.pdf#page=16|图 13，第 16 页]]）：操作员先说"去售货机买瓶水"，开始后不久改成"出去找 Lawson 买杯咖啡，出门右转第二栋楼"，**两条指令都没有逐步描述路线**。规划器自己拆出"更新目的地 → 找侧门 → 出门右转"等子任务。沿途 3 个动态障碍（被推着横穿大堂的推车、扫地机器人、行人）、2 个静态障碍（停在售货亭旁的机器人、标牌和锥桶）、2 处窄通道（侧门、标牌与锥桶之间的缝）；推车和扫地机由避障层绕开，行人是让行，锥桶缝由 MELIOR-N 把像素目标打在缝里。这一次**没有报路程和时间**。

### 数字孪生现场适配（§7.2，表 3）

设置：大堂孪生，500 个任务（300 指令跟随 + 100 目标导航 + 100 需求导航，路径 ≤35 m），400/50/50 划分；**MELIOR-A 冻结，只训 LoRA（rank 64）**；评测用验证 + 测试共 100 集；每次决策只执行 4 个动作里的前 2 个，持续碰撞或 500 步结束。

| 训练窗口 | SR@3m | STOP-SR@3m | SPL | nDTW | NE (m) | SR@1m | SR@0.5m |
|---|---|---|---|---|---|---|---|
| 只用参考轨迹（32,404） | 40 | 34 | 30.9 | 29.2 | 9.63 | **28** | **13** |
| 加纠错窗口（48,006） | **80** | **78** | **79.5** | **66.4** | **3.36** | 20 | 3 |

- 以持续碰撞结束的集数：52 → 3（/100）。
- 作者自己点出：**精确停在目标位姿反而变差**（SR@1m 28 → 20，SR@0.5m 13 → 3），纠错数据主要是减少碰撞、把停止拉到目标附近。
- 训练和评测是同一场景、同一类目标，所以测的是"对这个现场的适配"，不是泛化。
- 适配后的模型上了真实大堂的 X2：38 秒从起点穿过空地、经过储物柜、到售货机（[[agibot/papers/45_2611.17598_X-Nav.pdf#page=17|图 14，第 17 页]]）。**只有一段演示，没有真机成功率**。

### 基准（§7.3，[[agibot/papers/45_2611.17598_X-Nav.pdf#page=18|表 4，第 18 页]]）

val-unseen，只用一个前向 RGB 相机，不用全景：

| 方法 | R2R-CE NE↓ | OSR | SR | SPL | RxR-CE NE↓ | SR | SPL | nDTW |
|---|---|---|---|---|---|---|---|---|
| StreamVLN | 4.98 | 64.2 | 56.9 | 51.9 | 6.22 | 52.9 | 46.0 | 61.9 |
| DualVLN | 4.05 | 70.7 | 64.3 | 58.5 | 4.58 | 61.4 | 51.8 | 70.0 |
| CorrectNav | 4.24 | 67.5 | 65.1 | 62.3 | 4.09 | 69.3 | 63.3 | **75.2** |
| Qwen-RobotNav-4B | 4.22 | 73.6 | 66.9 | 60.5 | 4.15 | 71.3 | 61.5 | 68.6 |
| LightNav-0 | 3.91 | **73.7** | 68.5 | 62.8 | **3.66** | **73.6** | **64.5** | 67.4 |
| MELIOR-A（两个 checkpoint 平均） | 3.86 | 72.3 | 66.1 | 59.3 | 4.33 | 64.3 | 53.5 | 70.1 |
| MELIOR-N | **3.34** | 73.6 | **70.5** | **65.1** | 4.80 | 60.9 | 47.9 | 62.5 |
| *参考：* Robostral Navigate | 3.20 | 81.3 | 77.4 | 74.2 | 3.47 | 75.1 | 68.7 | – |
| *参考：* NavGPT-3（规划器 + VLA） | 2.18 | 87.0 | 81.5 | 70.4 | 1.56 | 90.4 | 74.3 | 78.5 |

- R2R-CE：MELIOR-N 的 SR、SPL、NE 在单目前向组里最好。
- RxR-CE：MELIOR-N 60.9 明显落后 LightNav-0（73.6）、Qwen-RobotNav（71.3）、CorrectNav（69.3）；MELIOR-A 64.3 也落后。
- 作者把 Robostral Navigate 放在"规模大得多 / 全景 / 带地图工具"的参考组，但从 Robostral 自己的设置看是单目 RGB（表 1 里也写 single RGB），分组理由是训练规模（240 万条仿真轨迹 + RL）。

## 局限 / 存疑

论文自己写的局限（§9）：任务只走过**一条路线、一层楼**；楼梯、电梯、需要开的门都不在系统能力内；现场适配只在**一个现场**评测过。

读的时候值得核对的地方：

- **真机结果是演示，不是统计**：主结论"约百米室内到室外"来自同一路线上的**两次运行**，没有重复次数、成功率、失败案例或人工干预记录。"首个"的说法本身也只靠这两次。作为技术报告可以理解，但和 Compass 1（8 类任务 × 4 场景 × 10 次）这种真机评测不是一个量级的证据。
- **"只用 RGB"指的是 MELIOR 这个模型**，系统整体用了 LiDAR（目标测距、避障、MELIOR-X 测距）、腿式里程计（目标锚定、距离统计）和 RGB-D；摘要里也写了这一点。另外规划器是闭源的 GPT-6，推理在机外 GPU，网络延迟和规划器调用延迟都没报告。
- **MELIOR-A 那次谁在避让？（需核对）** 第一跑"等 24 s 让车和行人"，但论文说 MELIOR-A 的动作被合成相对位姿目标直接交给运动控制器，摘要又说"有了 X-Navarch 才能绕过静态和动态障碍"。这 24 s 的停顿是模型自己判断的、避障层/安全层触发的，还是操作员干预，论文没说。
- **两次运行的指令难度不同**：MELIOR-A 那次换的新指令是逐段描述路线的（穿大堂、过玻璃门、右转、前面那栋楼）；X-Navarch 那次才是"出门右转第二栋楼"这种简短指令。两次不能直接比较两个版本的强弱。
- **X-Nav-Real 和 X-Nav-Twin 2,500 条设置用在哪了？（需核对）** 图 3 列了真机 15,000 条轨迹、孪生 2,500 条轨迹 / 78,010 个纠错窗口，§3.3.2 也说"site adaptation 用了 2,500 条参考轨迹"；但 §3.4 的 SFT 数据只有仿真和 VQA，§7.2 报的是 **500 条**设置的结果。真机数据进没进训练、2,500 条设置的适配效果如何、上真机的到底是哪个适配器，都没交代。
- **孪生实验的任务描述前后不一（需核对）**：§3.3.2 说"500 条去售货机的轨迹"，§7.2 说 500 个任务是 300 指令跟随 + 100 目标导航 + 100 需求导航。另外评测把**验证集**也算进 100 集里，验证集是否参与了选 checkpoint 没说。
- **图 2 和正文用的指标不同**：图 2 写"34% → 78%"是 STOP-SR@3m，正文和摘要说的"40% → 80%"是 SR@3m（不要求预测停止）。两个都对，引用时注意别混。
- **MELIOR-A vs MELIOR-N 的比较有混淆**：骨干不同（8B Qwen3-VL vs 4B Qwen3.5），MELIOR-A 的 SFT 数据构成没单独给（§3.4 只说 MELIOR-N），MELIOR-A 的榜单行是两个 checkpoint 的平均。所以"动作输出 vs 目标点输出哪个好"这张表回答不了。
- **MELIOR-N 在仿真里的执行用了仿真深度和导航网格**（附录 A）：`<visible>` 分支靠深度反投影 + 最短路跟随，r、φ、ψ 不用。这跟真机上用 LiDAR 测距 + 避障层是同一思路，但意味着 R2R-CE 上的 70.5% 里有一部分"走到点"的功劳属于执行器，不完全是模型的；和纯动作输出的方法比时要记住这一点。
- **RxR-CE 弱**：MELIOR-N 60.9%，比单目组的头部方法低 10 个点以上；论文只说"低于该组最强方法"，没分析原因（RxR 指令更长、路线更细，可能和 8 帧历史上限有关，这是我的猜测）。
- **MELIOR-X 和避障层没有任何量化评测**：找目标的成功率、测距误差、停靠精度都没报；避障层用的是什么算法（是不是 Nav2 一类的局部规划器）也没说，附录 D 只给了以后要换成学习式局部策略的设计图。
- **节奏很慢**：X-Navarch 下约每 4 s 一帧新观测；MELIOR-A 一次推理最多 1 m。动态场景下的反应主要靠避障层，而不是导航模型。
- **商业背景**：引言用智元的"Worken"（活跃机器人数 × 自主工作时长 × 产出效率）来引出问题，这是 2026-10-29 智元创新日发布的指标，属于公司叙事。

## 与其他论文的关系

- **同组前作**：[[agibot/notes/39_GuidedNav|GuidedNav]]（2026-10，Jiaxin Huang、Chengxing Lin、Xiaoyu Luo、Jingyu Guo、Cheng Wen、Shaoli Huang 都在两篇里）：同样在灵犀 X2 上用前向 RGB 做 VLN，GuidedNav 管"表征怎么学"，X-Nav 管"整套系统怎么上机"。X-Nav 没有引用 GuidedNav，MELIOR 与它的关系需核对。
- **规划器的底座**：[NavGPT-3](https://arxiv.org/abs/2610.10787)（VLN 专题 1-03）。X-Navarch 用的是 NavGPT-3 公开的运行时，限制成只看一个前向相机、不给地图，再加上两个技能、带延迟补偿的目标适配器和避障层。表 4 里 NavGPT-3 的 RxR-CE 90.4% 被放在参考组。
- **"指点"式导航目标**：[DualVLN](https://arxiv.org/abs/2512.08186)（3-24，InternVLA-N1 的双系统配置）、[Robostral Navigate](https://arxiv.org/abs/2607.20785)（3-34）都在当前画面里指像素航点；MELIOR-N 在此基础上加了 polar / rotate / stop 三种模式和量化 token。区别是 DualVLN 用第二个快速模型把像素目标转成轨迹，X-Nav 用 LiDAR 测距 + 里程计锚定 + 传统避障层。
- **同期的人形 / 真机长程导航**：
  - [Compass 1](https://arxiv.org/abs/2611.12087)（3-40，[[topics/notes/视觉语言导航VLN/3-40_Compass-1|笔记]]）：单目 RGB、跨轮式 / 四足 / 人形 / 无人机，真机评测更系统；X-Nav 强调的是单次任务更长、跨室内外、双足。
  - LHNav（2611.12136）：同期的人形长程导航，部署在 Unitree G1，指令里有多个连续目的地。
  - TANGO（2609.09158）：G1 上的全身 VLA 导航，室内约 10 m 和 30 m 的路线。
  - [NaVILA](https://arxiv.org/abs/2412.04453)（3-05）：四足和人形上的语言化中层动作。
  - VbotNav-0（2610.14634）、HoloAgent-0（2606.23565）：能覆盖更大场地、跨室内外，但依赖预先给的路线或预先建好的空间记忆；X-Nav 的卖点是不要现场先验。
- **单目前向 RGB 的基准对手**：[LightNav-0](https://arxiv.org/abs/2608.30935)（3-35，亮源，[[lightorigins/notes/02_LightNav-0|笔记]]）、Qwen-RobotNav（1,560 万样本，不在专题里）、[CorrectNav](https://arxiv.org/abs/2508.10416)（3-17，北大–智元联合实验室）、[StreamVLN](https://arxiv.org/abs/2507.05240)（3-15，[[topics/notes/视觉语言导航VLN/3-15_StreamVLN|笔记]]）、[JanusVLN](https://arxiv.org/abs/2509.22548)（3-21）、[NavFoM](https://arxiv.org/abs/2509.12129)（3-19）。
- **数据来源**：[VLNVerse](https://arxiv.org/abs/2512.19021)（VLN 专题 4-12）的合成场景、[SAGE-3D / Towards Physically Executable 3D Gaussian](https://arxiv.org/abs/2510.21307)（[[topics/语义3DGS与具身导航|语义3DGS与具身导航]] 专题）的重建场景、[SRDF](https://arxiv.org/abs/2412.08467)（4-18）数据飞轮的路线。孪生里"3DGS 管外观、网格管碰撞"的做法和 SAGE-3D 一致。
- **纠错数据**：DAgger（Ross et al. 2011）；CorrectNav 的自纠错飞轮是同一思路的另一种做法。X-Nav 把它用在现场孪生里，作为"上机前的现场适配"。
- **智元自己的相关工作**：社区开源的 [agibot-x2-navigation](https://github.com/Nova-Valley/agibot-x2-navigation)（X2 上的 ROS 2 建图 + Nav2）是传统的"有地图"路线，正好是 X-Nav 想绕开的；[[agibot/notes/37_PRIMO|PRIMO]] 做的是人形本体里程计，X-Nav 的目标锚定和距离统计都依赖里程计。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文 CC BY 4.0，这里只记位置和要点，原句请点页码看）
> 1. [[agibot/papers/45_2611.17598_X-Nav.pdf#page=2|第 2 页]]引言第 3 段：基准一集 10–15 m、相机固定高度、动作精确、无动态物体、3 m 内算成功，真实任务逐条打破 → 问题动机与任务定义
> 2. [[agibot/papers/45_2611.17598_X-Nav.pdf#page=3|第 3 页]]第 1 段：三种数据来源规模差几个数量级；孪生里几百条路线把闭环成功率从 40% 提到 80% → 数据观点
> 3. [[agibot/papers/45_2611.17598_X-Nav.pdf#page=5|第 5 页]] §2.3–2.4：路线用隐式导航、目标用显式导航；MELIOR 只用头部 RGB 640×480、79°，LiDAR/里程计/RGB-D 不进模型，推理在机外 GPU → 系统划分与"只用 RGB"的范围
> 4. [[agibot/papers/45_2611.17598_X-Nav.pdf#page=8|第 8 页]] §3.3.1–3.3.2：X-Nav-Syn 1,113,803 步、合计 6,310,664 步；孪生 48,006 / 240,030 个窗口及比例 → 数据规模
> 5. [[agibot/papers/45_2611.17598_X-Nav.pdf#page=10|第 10 页]] §4.2–4.3：MELIOR-A 一次推理合成一个相对位姿目标、最多 1 m；MELIOR-N 四种模式 → 两种输出接口
> 6. [[agibot/papers/45_2611.17598_X-Nav.pdf#page=11|第 11 页]] §5 "Attribute-aware target acquisition"：式 (3) 的 YES/NO logits 分数、0.5 阈值、60% 面积、连续两次接受 → MELIOR-X 的目标获取
> 7. [[agibot/papers/45_2611.17598_X-Nav.pdf#page=14|第 14 页]] §6 "Goal adapter" 与式 (7)：目标在采图时刻固定到里程计系，发布时变回体坐标 → 延迟补偿
> 8. [[agibot/papers/45_2611.17598_X-Nav.pdf#page=14|第 14 页]]末–[[agibot/papers/45_2611.17598_X-Nav.pdf#page=15|第 15 页]] §7.1：96.6 m / 3 分 24 秒、34.2 + 62.4 m、9.1 m 处换目的地、等车 24 s → 真机任务
> 9. [[agibot/papers/45_2611.17598_X-Nav.pdf#page=16|第 16 页]] §7.2 与第 17 页表 3：LoRA rank 64、SR@3m 40→80、STOP-SR 34→78、碰撞 52→3、SR@1m 28→20，同场景训练与评测 → 现场适配
> 10. [[agibot/papers/45_2611.17598_X-Nav.pdf#page=19|第 19 页]] §9 "Limitations"：一条路线、一层楼，不含楼梯电梯和要开的门，只在一个现场适配 → 作者自述局限；另见第 23 页表 7（规划器 GPT-6、约 4 s 一帧）

## 摘要（中文）

从室内到室外的长程导航对人形机器人仍是未解问题：一条指令要覆盖房间、门和道路，相机还随步态晃动。Worken 是智元衡量机器人有效工作量的指标，它依赖机器人能自主到达工作地点。我们提出 X-Nav，据我们所知是第一个让双足人形机器人按语言指令完成从室内到室外长程任务的系统。X-Nav 覆盖从数据到部署的完整流程：数据引擎在开源场景、部署现场的数字孪生和真机上采集导航数据；导航模型 MELIOR 只接收机器人自带相机的 RGB 图像，有两个版本，MELIOR-A 预测动作，MELIOR-N 预测导航目标；智能体工作流 X-Navarch 把简短的人类指令拆成子任务，并在机器人上以显式目标导航和避障的方式部署 MELIOR。在灵犀 X2 上，X-Nav 完成了一次约一百米、从写字楼大堂到隔壁楼一家商店的任务；目标接近和底层控制使用了 LiDAR 和里程计。两个版本的 MELIOR 都完成了这项任务：机器人跟随了目的地的变更，从大堂穿过门走到马路上；配合 X-Navarch，它还绕过了路线上的静态和动态障碍。部署时，MELIOR 用现场数字孪生里采集的数据做适配，适配提高了它在孪生中的闭环成功率，适配后的模型随后在真实现场部署到机器人上。此外，MELIOR 在 R2R-CE 和 RxR-CE 基准上取得了有竞争力的结果。

## 摘要（原文）

> Long-horizon navigation from indoors to outdoors remains an open problem for humanoid robots: one instruction covers rooms, doors and roads, and the camera moves with the gait. Worken, AGIBOT's measure of productive robot work, depends on robots that reach their workplaces autonomously. We present X-Nav, to our knowledge the first system to take a bipedal humanoid through a language-instructed long-horizon mission from indoors to outdoors. X-Nav covers a pipeline from data to deployment. Its data engine collects navigation data in open-source scenes, in digital twins of deployment sites and on real robots. Its navigation model, MELIOR, takes only RGB images from the robot's built-in camera and comes in two versions: MELIOR-A predicts actions, and MELIOR-N predicts a navigation goal. Its agentic workflow, X-Navarch, turns a brief human instruction into sub-tasks and deploys MELIOR on the robot with explicit target navigation and obstacle avoidance. On the Lingxi X2, X-Nav completes a mission of about a hundred metres from an office lobby to a store in a neighbouring building; LiDAR and odometry are used for target approach and low-level control. The mission is completed with both versions of MELIOR: the robot follows a change of destination and walks through a door from the lobby to the road, and with X-Navarch it also passes static and dynamic obstacles on the route. During deployment, MELIOR is adapted with data collected in a digital twin of the site; the adaptation raises its closed-loop success rate in the twin, and the adapted model is then deployed on the robot at the real site. In addition, MELIOR achieves competitive results on the R2R-CE and RxR-CE benchmarks.
