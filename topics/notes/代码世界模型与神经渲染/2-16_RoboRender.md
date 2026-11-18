---
id: "2-16"
org: 专题·代码世界模型与神经渲染
short: "RoboRender"
title: "RoboRender: Robot-Oriented Video Generation for Visual Sim-to-Real Transfer"
aliases: ["RoboRender"]
date: 2026-10-07
category: "结构条件的生成式渲染器"
venue: —
affiliation: "斯坦福大学 · NVIDIA · Microsoft Research"
authors: ["Huang Huang", "Wensi Ai", "Ziyu Chen", "Youhui Wang", "Zijian Du", "Yang Liu", "Jiaolong Yang", "Li Fei-Fei", "Jiajun Wu"]
arxiv: "2610.09254"
pdf: "[[topics/papers/代码世界模型与神经渲染/2-16_2610.09254_RoboRender.pdf]]"
code: "—（论文说会公开处理好的配对训练数据，没给代码仓库）"
project: "https://robo-render.github.io/"
license: CC BY 4.0（arXiv 摘要页）
status: 未读
rating:
read_date:
tags: ["paper", "neural-rendering", "sim-to-real", "visual-sim-to-real", "robot-learning", "data-generation", "depth-conditioned", "multi-view", "wan2.1", "dmd2", "pi0.5", "manipulation", "mobile-manipulation", "cross-embodiment", "domain-randomization"]
---

# RoboRender: Robot-Oriented Video Generation for Visual Sim-to-Real Transfer

> [!info] 论文信息
> arXiv [2610.09254](https://arxiv.org/abs/2610.09254) · 本地 PDF 是 v1（2026-10-07，cs.RO）
> 单位：斯坦福大学（主）、NVIDIA、Microsoft Research · 共同一作：Huang Huang、Wensi Ai、Ziyu Chen、Youhui Wang · 资深作者：Li Fei-Fei、Jiajun Wu（论文没标通讯作者）
> PDF：[[topics/papers/代码世界模型与神经渲染/2-16_2610.09254_RoboRender.pdf|本地 PDF]]（15 页：正文 1–8 页 + 参考文献 8–9 页 + 附录 A–G 10–15 页）
> 代码：没给仓库（附录 A 说会公开处理好的配对数据）· 项目页：[robo-render.github.io](https://robo-render.github.io/)
> 专题：[[topics/代码世界模型与神经渲染#二、结构条件的生成式渲染器|代码世界模型与神经渲染 · 二、结构条件的生成式渲染器]]

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-18）。本机 Read 工具打不开 PDF，全文是用 PDFKit 脚本抽成文本后读完的（正文 + 附录 A–G）；表 I、表 III 抽出来错位，另外把第 4、7 页渲染成图片逐格核对过。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。

## 一句话总结

把**仿真器当"世界"、视频模型当"渲染器"**来造机器人训练数据：在 Wan2.1-T2V-1.3B 上用 LoRA 微调出一个以**多视角仿真深度视频 + 机器人 RGB 掩码视频 + 文字 + 上一块末帧**为条件的生成器（条件潜变量与噪声潜变量按通道拼接、三个视角在潜空间堆叠联合去噪），训练数据是从 AgiBot-World-Alpha 和 DROID 自动处理出的约 13 万段真实操作视频（深度用 Video-Depth-Anything / FoundationStereo 估、机械臂用 SAM3 抠、描述用 Qwen2-VL 写）。推理时把 OmniGibson / MuJoCo 里脚本规划器生成的轨迹渲成逼真 RGB，再与仿真给的动作和状态配对，微调 π0.5；挖掉部分深度并改提示词还能**插入干扰物**。生成质量上 FID 25.7 / FVD 93.9（最好基线 Cosmos-Transfer2.5 为 42.8 / 164.5）；8 个真机任务**零样本**平均成功率 71%，是纯仿真渲染（10%）的 7.1 倍、视觉域随机化（20%）的 3.6 倍；开抽屉 / 开冰箱两项只有它不是 0；DMD2 蒸馏到 6 步后单张 H200 每段三视角 81 帧 4.29 s。

## 要解决什么问题

- **仿真能大规模、低成本、自动重置地造机器人数据，但视觉上的仿真到真实差距让策略迁移失败**（§I，第 1 页）。对基于视觉的操作，观测外观和真实差得多是主要瓶颈；动力学差距可以靠系统辨识、动力学随机化或自适应处理，不是本文目标。
- **已有三条路各有毛病**（§II-A）：
  - **real2sim2real / 数字孪生**（NeRF、3DGS 重建）：要逐场景采集、标定、准备资产，交互几何也未必准；
  - **几何或物体中心的表示**（深度、点云、物体位姿）：绕开了 RGB 差距，但丢掉语义外观，部署时还要额外的感知模块；
  - **视觉域随机化**（纹理、光照、相机、背景随机）：要细调，而且离真实观测仍然远。
- **已有"视频生成造机器人数据"的工作也不够**（§II-B）：DreamGen 只用语言，物理依据弱，动作要靠逆动力学或潜动作反推；AnchorDream 有机器人运动但没有物体交互的依据；EmbodieDreamer、CRAFT 用物体掩码或 Canny 边缘，没有 3D 信息、多视角不一致；RoboTransfer 用深度 + 法线 + 外观示例图，依赖事先采好的真实外观参考；GigaWorld-0 面更广，但不专攻从仿真深度轨迹出发的视觉迁移。
- 作者想要的是：**几何、动力学、动作标签都来自仿真器，外观交给视频先验**，而且多视角一致、能插干扰物、能换没见过的机器人。

## 方法

总览见 [[topics/papers/代码世界模型与神经渲染/2-16_2610.09254_RoboRender.pdf#page=1|图 1（第 1 页）]] 和 [[topics/papers/代码世界模型与神经渲染/2-16_2610.09254_RoboRender.pdf#page=3|图 2（第 3 页）]]。

### 世界状态在哪：仿真器 + 脚本规划器（§III-B、附录 E）

- 不是编码智能体写的程序，而是**现成仿真器里的预定义场景**（基于 MolmoSpaces 的流程 + CuRobo 运动规划）：每个 episode 实例化场景、目标物体、机器人和同步的多视角相机，用**脚本化任务与运动规划器**执行任务，记录多视角 RGB-D、本体感觉、动作和机器人分割掩码。
- 规划器用离线抓取库（平行夹爪的对踵末端位姿，再加 180° 对称），按可达性、朝向、稳定性、离操作区域远近排序，做碰撞过滤和批量 IK 检查，取第一个可行的。
- 任务原语：抓放是"预抓取–抓取–抬起–放置–撤回"；铰接物体沿关节约束移动（转动关节走圆弧、移动关节走直线）；移动操作是"导航–预抓取–抓取–抬起"。失败就换一个抓取重规划；放置成功或关节位移超过阈值才保留，否则重试超限或 300 步超时就丢弃。
- 两个仿真器：DROID 抓放和移动操作的数据在 **OmniGibson**，开门 / 开抽屉和 YAM 任务在 **MuJoCo**——作者用来说明跨仿真器可用。
- 引擎**导出给渲染器的条件信号**：每个视角的深度视频、机器人 RGB 掩码视频（仿真渲染的机器人像素）；文字提示另由 Claude Opus 4.6 按任务生成（§III-C）。

### 渲染器：骨干与条件注入（§III-A、图 2）

| 项目 | 内容 |
|---|---|
| 骨干 | Wan2.1-T2V-1.3B 的一个变体，双向扩散，固定 81 帧窗口 |
| 条件 | ① 每视角深度视频（场景几何与物体运动）；② 每视角机器人 RGB 掩码视频（本体外观与运动）；③ 文字（外观、材质、光照、背景语义；图 2 说是 CLIP 编码）；④ 上一块末帧（长时程自回归） |
| 注入方式 | 深度和机器人掩码视频经 VAE 编码，**与噪声潜变量按通道拼接**；三个视角的潜变量再**堆叠成一个统一的多视角潜变量**一起去噪（不是各视角独立生成） |
| 训练 | LoRA，全局批 16，12K 次迭代，约 13 万段真实数据，416×240 |
| 两个训练技巧 | 随机丢弃上一帧条件（同一模型既能生成首块又能续写）；**随机挖掉大块深度**，让模型学会在没有几何的地方按提示词补出合理内容——推理时就是插干扰物的开关 |
| 长视频 | 每块以上一块最后一帧为条件自回归续写（照 Cosmos、SkyReels-V2 的做法） |
| 加速 | 默认 50 步 + CFG 5.0，单张 H200 生成一段三视角 81 帧要 68.8 s；TeaCache（阈值 0.10）35.3 s（1.95×）；**DMD2 蒸馏到 6 步**（单节点 2,000 次迭代）后 4.29 s |

- 这是**离线造数据用的渲染器**，不是交互式实时渲染：没有流式、没有 KV 缓存、没有动作条件；"实时"对它不是目标。

### 训练数据怎么来（§III-A、附录 A，[[topics/papers/代码世界模型与神经渲染/2-16_2610.09254_RoboRender.pdf#page=10|图 9、表 VI]]）

- 真实机器人数据集只有 RGB 和动作，没有渲染器需要的条件，所以做了一条自动预处理流水线：每段取跨所有视角时间对齐的 81 帧窗口，生成四种对齐条件：
  - **描述**：Qwen2-VL 两遍——先看首帧写草稿，再跨所有非腕部视角核对物体，输出背景 / 工作面 / 前景物体的结构化描述，减少幻觉；
  - **深度**：Video-Depth-Anything 估相对深度，有双目的样本再跑 FoundationStereo，都转成逆深度归一化；训练时**每个视角随机混用不同来源的深度**，避免对单一估计器的偏置；
  - **机械臂 RGB 与掩码**：SAM3 分割机械臂和夹爪；
  - **前一帧**：窗口之前的那一帧。

| 来源 | 样本数 | 不同场景数 | 任务类别 |
|---|---|---|---|
| AgiBot-World-Alpha | 69,910 | 22,650 | 10 |
| DROID | 57,040 | 17,042 | 15 |
| 合计 | 126,950 | 39,692 | 16 |

- 任务分布：抓放 47.8%、折叠 / 柔性物 19.1%、开关 7.0%、挂取 5.2%，其余 12 类各在 4% 以下。

### 怎么变成策略训练数据（§III-C、§V-A）

- 把仿真深度视频 + 仿真机器人 RGB 掩码 + Claude 写的场景提示词送进渲染器，得到多视角逼真 RGB；再与仿真给的**动作和状态原样配对**，得到 RGB–动作–状态轨迹。
- 机器人本体直接用仿真渲染的 RGB 掩码，理由是机器人外观简单、仿真到真实差距小。
- **干扰物插入**（附录 D、[[topics/papers/代码世界模型与神经渲染/2-16_2610.09254_RoboRender.pdf#page=13|图 14]]）：在各视角深度上采样时间一致的矩形区域挖掉，提示词里加干扰物描述；DROID 抓放任务外部视角挖 2–5 块（占画面 20%–50%）、腕部视角 1–2 块。
- **一条轨迹多份外观**：换提示词和挖洞位置，同一条仿真轨迹可生成多段不同外观的视频。
- 每个任务的仿真数据量：抓放每任务 1K 条、移动操作 2K、开抽屉 2K、开冰箱 1K；随机物体尺寸、桌高、机器人位姿、外部相机位姿。
- 策略：**π0.5** 预训练底座微调，预测 32 步动作块、执行前 16 步；所有抓放任务一个联合策略，开门 / 开抽屉 / 移动操作各一个；40K 步，批 72。

## 实验与关键数字

### 生成质量（[[topics/papers/代码世界模型与神经渲染/2-16_2610.09254_RoboRender.pdf#page=4|表 I、表 II，第 4 页]]）

500 段 DROID / AgiBot 保留片段。Wan-Fun-Control、RoboTransfer 和本文都在 416×240；Cosmos-Transfer2.5 在这个分辨率跑不了，用 480p 生成再降采样（作者说这对 Cosmos 有利）。

| 模型 | FID↓（首块） | FVD↓（首块） | PSNR↑（AR 续写） | SSIM↑（AR 续写） | LPIPS↓（AR 续写） |
|---|---|---|---|---|---|
| Wan-Fun-Control（Wan2.1-Fun-1.3B-Control） | 62.5 | 267.8 | 20.30 | 0.738 | 0.175 |
| Cosmos-Transfer2.5-2B | 42.8 | 164.5 | 13.26 | 0.481 | 0.423 |
| RoboTransfer | 52.8 | 275.4 | 13.75 | 0.509 | 0.418 |
| **RoboRender** | **25.7** | **93.9** | **22.28** | **0.784** | **0.142** |

2AFC 人评（50 人，每人 20 对，评真实感和多视角一致性；**输入是仿真深度，没有真值 RGB**）——RoboRender 被选中的比例：

| 对比对象 | 多视角一致 | 生成质量 |
|---|---|---|
| Wan-Fun-Control | 76.9% | 90.6% |
| Cosmos-Transfer2.5 | 74.9% | 68.9% |
| RoboTransfer | 85.7% | 94.6% |

- **15 s 自回归滚动**（[[topics/papers/代码世界模型与神经渲染/2-16_2610.09254_RoboRender.pdf#page=5|图 4，第 5 页]]，200 段长片段，只有首块用真值前一帧）：每个时间点 PSNR / LPIPS 都领先 Wan 和 Cosmos（只给了曲线，没给数字）。
- **三视角堆叠给基线**（附录表 VII）：Wan-Fun-Control 堆叠后 FID / FVD 62.5 / 267.8 → 61.8 / 255.6，Cosmos-Transfer2.5 反而 42.8 / 164.5 → 57.1 / 236.0——作者据此说多视角一致来自专门的多视角训练，不是推理时拼一下就行。

### 真机零样本（[[topics/papers/代码世界模型与神经渲染/2-16_2610.09254_RoboRender.pdf#page=7|表 III，第 7 页]]）

每个任务 10 次；在自然的办公室环境，物体尺寸、几何、相机视角、背景都和仿真不同；抓放任务桌上放随机干扰物。Franka + Robotiq（DROID 式，外部 + 腕部相机）做 4 个抓放和 2 个开启任务；**R1Pro**（1 个第一视角 + 2 个腕部相机）做移动操作；**YAM** 机械臂（第一视角 + 腕部）抓放。R1Pro 和 YAM 都**没在视频模型训练数据里出现过**。

| 训练数据 | Mug | Bowl | Apple | Egg | 开冰箱 | 开抽屉 | 拿收音机（R1Pro） | 放绿色记号笔（YAM） | 平均 |
|---|---|---|---|---|---|---|---|---|---|
| Sim | 40% | 30% | 10% | 0% | 0% | 0% | 0% | 0% | 10% |
| Sim + DR | 60% | 20% | 20% | 30% | 0% | 0% | 30% | 0% | 20% |
| **RoboRender** | **80%** | **80%** | **60%** | **50%** | **70%** | **90%** | **70%** | **70%** | **71%** |

- 平均数按表核对：10% / 20% / 71.25%，倍数 7.1× / 3.6× 无误。
- DR 基线 = 回放同样的仿真轨迹，物体纹理换成 DTD 纹理、随机光照。
- **干扰物**（图 7，第 6 页）：DROID 抓放在无干扰物的设置下 Sim / Sim+DR / RoboRender 为 48% / 70% / 80%；加上真实干扰物后（按表 III 算）降到 20% / 32.5% / 67.5%，RoboRender 掉得最少。

### 消融（第 7–8 页）

**和深度策略比（表 IV）**：深度策略在仿真深度上训练，部署时用 VideoDepthAnything 从 RGB 估深度。

| 设置 | YAM | DROID 抓放 | R1Pro |
|---|---|---|---|
| 只用深度 | 30% | 25% | 10% |
| RoboRender | 70% | 68% | 70% |

**换成别的视频模型造数据（表 V，同一批仿真数据、同样数量的视频；基线不吃机器人掩码，改在提示词里描述机器人纹理）**：

| 生成器 | 开抽屉 | 开冰箱 |
|---|---|---|
| Wan-Fun-Control | 0% | 0% |
| Cosmos-Transfer2.5 | 30% | 0% |
| RoboRender | 90% | 70% |

**一条轨迹生成几份视频（[[topics/papers/代码世界模型与神经渲染/2-16_2610.09254_RoboRender.pdf#page=7|图 8]]，只用一半仿真轨迹）**：
- 抓放（每任务 500 条）：1× → 2× → 3× 平均成功率 48% → 58% → 饱和；参考线（全部轨迹各 1 份，即表 III）约 67.5%。
- 开启（开冰箱 500 条、开抽屉 1K 条）：1× → 1.5× → 2× 为 **0% → 45% → 65%**；参考线 80%。摘要里"开启任务成功率提高 65 个百分点"指的就是这个半数据实验。

## 局限 / 存疑

- **作者自述**（§VI）：只解决视觉差距，受仿真器动力学和接触建模的上限约束，柔性物体尤其难；跨形态、相机配置、真实环境的验证还不够；长时程复杂任务留作以后。
- **统计量很小**：每个任务 10 次，没有置信区间；10% 的差距就是一次成功。7.1× / 3.6× 的倍数是在很低的基线上算的。
- **基线偏弱**：DR 只换纹理和光照（DTD），不随机背景、不加干扰物，而真机评测恰好在杂乱桌面上加了干扰物；RoboRender 的一部分优势来自它能插干扰物而 DR 不能。没有和数字孪生 / 3DGS 类 real2sim2real 方法、也没有和 RoboTransfer / DreamGen 造的数据比策略成功率。
- **π0.5 预训练的贡献分不开**：所有策略都从 π0.5 预训练底座微调，底座本身见过大量真实机器人数据，"零样本 sim-to-real"里有多少来自底座的真实先验，没做无预训练对照。
- **半数据 1× 开启任务 0%、全数据 1× 却 80%**（图 8）：数据量减半就从 80% 掉到 0%，说明开启任务对数据量非常敏感，结果的稳定性值得怀疑；2× 半数据（视频总数与全数据相同）是 65%，仍低于 80%。
- **表 I 的设置写法不一致（需核对）**：正文说在"首块生成"和"自回归续写"两种设置下都评测，表 I 却是首块只报 FID / FVD、续写只报 PSNR / SSIM / LPIPS。而且基线怎么做"以真值前一帧为条件的续写"（Wan-Fun-Control、Cosmos-Transfer2.5 是否原生支持）没说清。
- **文字编码器（需核对）**：图 2 说文字用 CLIP 编码，但 Wan2.1-T2V 原生用的是 umT5，是作者改了还是图注笔误，没说。
- **训练–推理的机器人外观不一致**：训练时"机器人 RGB"是 SAM3 从真实视频里抠出来的真实机械臂像素，推理时换成仿真渲染的机械臂。作者认为机器人外观简单、差距小，但没有消融。
- **深度条件的训练–推理差异**：训练用估计的相对逆深度（Video-Depth-Anything / FoundationStereo），推理用仿真精确深度，归一化方式是否一致、有没有域差，没讨论。
- **策略实验用的是哪个版本的渲染器（需核对）**：50 步原版、TeaCache 还是 6 步蒸馏版造的策略数据，没说；蒸馏版有没有质量损失也只给了 TeaCache 的对比图，没给 DMD2 的指标。
- **小笔误**：局限一段只提"未见形态 R1Pro"，但 YAM 也是未见形态；表 IV 说是"三个抓放和移动抓放任务"，表里却是 YAM / DROID 抓放 / R1Pro 三列（DROID 抓放 68% 与表 III 四个抓放的平均 67.5% 对得上，应是四个任务的平均）。
- **代码**：只承诺公开处理好的配对数据，没说公开模型和代码。

## 与其他论文的关系

- **在本专题里的位置**："结构信号 → 逼真视频"的一半，和 [Cosmos-Transfer1](https://arxiv.org/abs/2503.14492)（2-01，Cosmos-Transfer2.5 是本文的主要基线）、[[topics/notes/代码世界模型与神经渲染/2-06_AlayaRenderer-Flash|AlayaRenderer-Flash]]（G-buffer）、[[topics/notes/代码世界模型与神经渲染/2-09_SolarRenderer|SolarRenderer]]（任意结构视频）同类。区别：
  - **条件信号**：只用深度 + 机器人 RGB 掩码 + 文字，比 G-buffer 粗、比低模代理细；注入方式（VAE 编码后与噪声潜变量通道拼接）和 [[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]] 用的 Wan2.2-Fun-5B-Control 同一路数。
  - **多视角联合生成**是本专题渲染器里少见的：游戏 / 交互世界模型一般只要一路第一视角，机器人策略却要外部 + 腕部多路相机严格一致。
  - **用途**：专题里大多数渲染器是给人玩或看的、追求实时；RoboRender 是**离线造训练数据**，追求的是"外观多样且和动作标签严格对齐"，所以不在意实时，在意吞吐（6 步、4.29 s/段）和多样性（一条轨迹多份外观）。
  - 和 [[mirros/notes/01_AgentGarten|AgentGarten]] 最像：都是"仿真器管物理和状态、一个生成式渲染器把粗糙渲染变逼真、产出给智能体学习"。AgentGarten 用 Cosmos 3-Nano、深度 / 法线条件、实时 4 步，训的是靠 playbook 改进的 LLM 智能体；RoboRender 用 Wan2.1-1.3B、深度 + 机器人掩码、离线，训的是 VLA 策略并真机验证。
  - 和本批 [[topics/notes/代码世界模型与神经渲染/1-17_DR-WM|DR-WM]] 对照：DR-WM 用生成式渲染做**执行前的后果预测**，RoboRender 用来**造训练数据**；前者把物理（地形接触）当核心、外观次要，后者明说不管动力学差距、只管外观。
- **同类"仿真条件生成"**：[SimGen](https://arxiv.org/abs/2406.09386)（2-10，驾驶模拟器条件生成训练数据，思路是同一条）、[Coarse-to-Real](https://arxiv.org/abs/2601.22301)（2-04，粗糙仿真 → 真实风格视频）、[Proxy2World](https://arxiv.org/abs/2609.35023)（2-08，不需要配对数据的深度条件生成）。RoboRender 绕开"缺配对数据"的办法是：**从真实机器人视频反推条件**（估深度、抠机械臂、写描述），而不是去造仿真–真实配对。
- **机器人数据生成这一支**：[DreamGen](https://arxiv.org/abs/2505.12705)、[RoboTransfer](https://arxiv.org/abs/2505.23171)（基线）、[GigaWorld-0](https://arxiv.org/abs/2511.19861)、[EmbodieDreamer](https://arxiv.org/abs/2507.05198)、[RoboCurate](https://arxiv.org/abs/2602.18742)。RoboRender 的立足点是"动作标签和几何来自仿真，不用逆动力学反推"。
- **对机器人策略学习 / sim-to-real / 导航的实际用处**（这一段是我的归纳）：
  - **策略学习**：给"仿真大规模造轨迹 + VLA 微调"这条流水线补上了最薄弱的视觉一环，而且不需要逐场景重建、不需要部署时额外感知模块，策略仍然吃原始 RGB。"一条轨迹多份外观"把视觉多样性和轨迹多样性解耦，对仿真轨迹贵（需要规划器、需要成功筛选）的任务尤其划算。
  - **sim-to-real**：它只处理**视觉**差距。和 [[topics/语义3DGS与具身导航|语义 3DGS 专题]]第四节那些 3DGS 仿真 / real2sim2real 工作是两条互补的路：3DGS 给特定场景高保真、但要采集；RoboRender 给开放多样的外观、但几何只来自仿真资产。动力学差距（接触、柔性物体）它完全不碰。
  - **导航**：直接相关的只有一个"移动到桌边再拿收音机"的移动操作任务（R1Pro 第一视角，70%）。原理上，同样的"深度 + 文字 → 逼真 RGB"可以拿来把 Habitat / Isaac 里的 VLN 轨迹渲成逼真视频，正好对上 [[topics/视觉语言导航VLN|VLN 专题]]里"仿真训练的单目视频大模型在真机上失效"的问题（例如 [[topics/notes/视觉语言导航VLN/3-40_Compass-1|Compass 1]] 对这一类方法的批评，以及 [VLN-PE](https://arxiv.org/abs/2507.13019) 的物理 / 视觉差距研究）。但要注意：
    - 训练数据**全是桌面操作**（AgiBot、DROID），没有房间级、户外、大视角运动的导航视频，416×240、81 帧窗口；
    - 长视频只靠"上一块末帧"续写，**没有空间记忆**，导航里走回同一个房间时外观不会保持一致——这正是本专题 Matrix-Game 4.0、DR-WM 等用空间记忆 / 参考帧去解决的问题；
    - 生成速度 4.29 s / 段（81 帧），大规模导航数据集（几十万条轨迹）的渲染成本不低。
- **和 [[topics/递归自我改进RSI|RSI 专题]]的联系**：RSI 专题里"大模型生成任务与环境"那一支解决的是任务和场景从哪来；RoboRender 解决的是这些仿真环境**看起来不像真实**的问题，两者可以串起来。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置 + 要点；论文是 CC BY 4.0，下面的短引用照原文）
> 1. 第 1 页 §I 第 1 段：已有方法"can be scene-specific, semantically lossy, require additional perception modules, or remain visually mismatched to real observations" → 问题动机
> 2. 第 2 页 §I 第 1 段：深度保几何与多视角一致、语言控外观、机器人掩码保运动并支持新形态 → 三种条件各管什么
> 3. 第 3 页 §III-A "Model Architectures"：Wan2.1-T2V-1.3B 变体，深度与掩码 VAE 编码后与噪声潜变量通道拼接、跨视角堆叠；LoRA、批 16、12K 次迭代、约 13 万段 → 骨干与注入方式
> 4. 第 3 页 §III-A 第 2 段：上一帧条件随机丢弃；训练时随机挖掉大块深度，推理时用来插干扰物 → 长视频与干扰物机制
> 5. 第 4 页 §III-C：机器人外观简单、仿真到真实差距小，直接用仿真渲染的机器人 RGB 掩码 → 训练–推理外观不一致的来源
> 6. 第 5 页 §IV "Comparison with Baselines"：Cosmos-Transfer2.5 在 416×240 跑不了，用 480p 再降采样 → 表 I 的比较条件
> 7. 第 5 页 §IV "Accelerated Inference" + 第 12 页附录 C：DMD2 50 步 → 6 步，H200 上 4.29 s；50 步 68.8 s、TeaCache 35.3 s → 吞吐
> 8. 第 6 页 §V-A "Training Setup"：π0.5 微调，32 步动作块执行 16 步，40K 步、批 72 → 策略设置与预训练底座问题
> 9. 第 7 页表 III + 第 6 页图 7：平均 71% / 20% / 10%；无干扰物 80% / 70% / 48% → 主结果
> 10. 第 7–8 页 §V-B 最后一问 + 图 8：一半轨迹下开启任务 0% → 45% → 65% → 摘要里"+65 个百分点"的出处

## 摘要（中文）

仿真使大规模、低成本的机器人数据生成成为可能，但在仿真中训练的策略常因仿真与真实之间的视觉差异而无法迁移到真实世界。已有方法往往依赖中间表示，这些表示可能丢失丰富的语义信息，或在部署时需要额外的感知模块。我们用 RoboRender 来解决这一视觉上的仿真到真实差距：它是一个把仿真轨迹转换成用于策略学习的逼真 RGB 视频的框架。RoboRender 训练了一个面向机器人的视频生成模型，以仿真深度视频、语言指令和机器人 RGB 掩码视频为条件，在保留仿真器几何、机器人运动和动作标签的同时，合成逼真的纹理、背景和干扰物。生成的 RGB 视频与仿真器提供的状态和动作配对，用来训练可零样本部署到真实世界的策略。在机器人视频测试集上，我们的视频模型在生成质量上优于以深度为条件的视频生成基线。在涵盖抓取放置、铰接物体操作和移动操作的真实世界实验中，用 RoboRender 生成数据训练的策略平均成功率达到 71%，分别约为用原始仿真渲染和常规视觉域随机化训练的策略的 7.1 倍和 3.6 倍。我们还表明，每条仿真轨迹生成的视频越多，策略表现越好，开启类任务的成功率因此提高了 65 个百分点。这些结果说明，生成式视频渲染能够缓解视觉上的仿真到真实差距，实现零样本的策略迁移。

## 摘要（原文）

论文以 CC BY 4.0 许可发布，下面按本地 PDF 第 1 页转录（与 [arXiv 摘要页](https://arxiv.org/abs/2610.09254) 可能有细微出入）。

> Simulation enables large-scale, low-cost robot data generation, but policies trained in simulation often fail to transfer to the real world due to the sim-to-real visual discrepancies. Existing approaches often rely on intermediate representations, which can discard rich semantic information or require additional perception modules at deployment. We address this visual sim-to-real gap with RoboRender, a framework that converts simulated trajectories into photorealistic RGB videos for policy learning. RoboRender trains a robot-oriented video generation model conditioned on simulated depth videos, language instructions, and robot RGB mask videos, preserving simulator geometry, robot motion, and action labels while synthesizing realistic textures, backgrounds, and distractors. The generated RGB videos are paired with simulator-provided states and actions to train policies for zero-shot real-world deployment. On robot video test sets, our video model outperforms depth-conditioned video generation baselines in generation quality. In real-world experiments across pick-and-place, articulated-object manipulation, and mobile manipulation tasks, policies trained on RoboRender-generated data achieve a 71% average success rate, outperforming raw simulation renderings and conventional visual domain randomization by approximately 7.1× and 3.6×, respectively. We further show that policy performance improves with more generated videos per simulation trajectory, increasing opening-task success by 65 percentage points. These results demonstrate that generative video rendering mitigates the visual sim-to-real gap for zero-shot policy transfer.
