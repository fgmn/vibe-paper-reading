---
org: Skild
short: "Steel"
title: "Steel: Scaling Simulation Across Robots, Tasks, and Worlds"
date: 2026-11-09
category: 仿真
source: Skild 主导（与 NVIDIA 合作）
partners: [NVIDIA]
code: "https://github.com/skild-ai/steel"
status: 暂无 PDF
read_date:
rating:
tags: ["project", "仿真", "物理引擎"]
---

# Steel：跨机器人、任务与场景的大规模仿真

> [!info] 报告信息
> [技术博客](https://www.skild.ai/blogs/steel) · [代码](https://github.com/skild-ai/steel) · [Newton](https://github.com/newton-physics/newton) · [Isaac Lab](https://github.com/isaac-sim/IsaacLab) · [浏览器演示](https://www.skild.ai/demos/steel?demo=jenga)
> 作者：Skild Team，与 NVIDIA 合作。页面只写"Nov 2026"，测量日期为 2026-11-07 至 11-09，`date` 取最晚的测量日。
> 这是工程博客，不是论文：没有 arXiv、没有公式、没有策略训练结果。

Steel = **S**calable **T**hroughput-optimized **E**ngine for **E**mbodied **L**earning。

## 一句话总结

Steel 是 Skild 在 NVIDIA 开源物理引擎 Newton 里实现的 GPU 刚体动力学求解器（`newton.solvers.SolverSteel`），专为"一个 batch 里混着很多种不同机器人和任务"的场景设计。在 20 个单任务基准上平均是 PhysX 的 3.8 倍吞吐，混合 20 种任务时达到 PhysX 的 13.0 倍。

## 要解决什么问题

- GPU 并行仿真对**运动控制 / 全身控制**很好用：同一个机器人复制成千上万份并行训练。
- **操作**任务难得多：物体、布局、本体（平行夹爪、灵巧手、人形）都在变。每个场景里刚体更多、关节机构更多、接触频繁变化；一个 batch 里还要混合不同场景和机器人结构。
- 现有引擎的两个瓶颈：
  1. **稠密的关节体分解**：机器人自由度一多，代价迅速上升；
  2. **padding 表示**：各环境差别大时，按最大环境补齐会浪费大量计算和显存。
- 动机落在 Skild 的路线上：要训练跨本体共享的"机器人大脑"（S1、omni-bodied），就要让仿真数据的**多样性**和**数量**一起扩展。

## 方法

只有设计层面的描述，没有给公式。

- **按环境组织**动力学和约束，而不是把所有环境补成同样大小。
- **按关节数分组**：关节数相近的关节体放在一起执行，提高 GPU 利用率。
- **按需分配接触求解**：根据每个环境当前的接触情况分配工作量；每个环境有自己的约束行数，轻量场景不求解用不到的约束。
- **分路径执行**（Figure 2 示意）：
  - 自由物体走简单更新路径；
  - 当前步没有接触的环境走轻量路径；
  - 复杂场景走通用路径。
  - 示意图里的 5 个环境：A 机械臂+杯子（7 关节）；B 机械臂+夹爪推盒子（9 关节）；C 机械臂+灵巧手+方块（23 关节，大量手指接触）；D 机械臂+装了 20 个零件的料箱（7 关节，杂乱接触）；E 机械臂在空中够取（7 关节，本步无接触）。
- **数值核心**：约化坐标（reduced-coordinate）关节体动力学 + 投影 Gauss-Seidel（PGS）约束求解。关键技巧是对每个关节体的关节空间质量矩阵**只分解一次、在它的所有接触间复用**，不构建约束两两耦合的稠密矩阵。
- **工程集成**：共享 Newton 的模型表示和碰撞检测；目标是接入 Isaac Lab。单任务测试中用了 `reuse_kinematics=True`（Newton 1.8 中需手动开启）。

## 实验与关键数字

全部在单张 **NVIDIA RTX PRO 6000 Blackwell** 上测得，**只计物理仿真**，不是端到端训练速度。除特别说明外，每个引擎取各自最优 batch size。

### 混合任务（异构 batch）

混合人形、四足、机械臂、灵巧手等任务类型，单位为每秒环境步数（env-steps/s）：

| 任务类型数 | Steel 峰值 @ 环境数 | PhysX 峰值 @ 环境数 | 倍数 |
|---|---|---|---|
| 5 | 5.83M @ 61,440 | 632K @ 15,360 | 9.2× |
| 10 | 4.95M @ 122,880 | 474K @ 61,440 | 10.4× |
| 15 | 3.82M @ 122,880 | 306K @ 61,440 | 12.5× |
| 20 | 3.90M @ 245,760 | 300K @ 61,440 | 13.0× |

- **同 batch 对比**（20 种任务、61,440 个环境）：Steel 3.61M，是 PhysX 的 12.0 倍；显存少约 62%（约 11 GiB 对 29 GiB）。
- 图中另一组显存数字"PhysX 54 GiB @ 123K、Steel 39 GiB @ 246K"是不同 batch 下的，不能和 62% 混用。
- PhysX 的曲线多数停在 122,880（10 种任务时停在 61,440），因为碰到了 PhysX 的 64K 材质数上限。
- 任务种类越多，Steel 的优势越大，符合"为异构设计"的论点。

### 单任务（20 个 Isaac Lab 任务）

- 几何平均：Steel = **3.8× PhysX**，MuJoCo Warp = 2.9× PhysX，即 Steel 约为 MuJoCo Warp 的 1.3 倍。
- 20 个任务中 19 个比 PhysX 快。
- 文中点名的例子：Kuka Allegro lift 是 PhysX 的 6.7 倍、MuJoCo Warp 的约 1.8 倍。

逐任务倍数（相对 PhysX；括号内为 MuJoCo Warp）。以下是从柱状图读出的值，需对照原图核对：

| 任务 | Steel | MuJoCo Warp |
|---|---|---|
| UR10 reach | 8.2× | 5.6× |
| Kuka Allegro reorient | 7.2× | 4.0× |
| Kuka Allegro lift | 6.7× | 3.8× |
| Franka reorient | 6.7× | 4.5× |
| ANYmal-D rough | 6.4× | 3.7× |
| Franka lift | 6.3× | 4.3× |
| Cassie rough | 5.8× | 3.8× |
| Allegro cube reorient | 5.3× | 2.2× |
| G1 rough | 4.3× | 2.3× |
| ANYmal-D flat | 3.6× | 1.4× |
| Humanoid direct | 3.5× | 3.5× |
| Humanoid | 3.5× | 3.4× |
| Franka reach | 3.1× | 3.4× |
| Kuka Allegro reorient (RGB) | 3.0× | 2.5× |
| Kuka Allegro lift (RGB) | 3.0× | 2.4× |
| Ant | 3.0× | 3.0× |
| Franka reach OSC | 2.7× | 3.0× |
| H1 flat | 1.8× | 1.4× |
| G1 flat | 1.7× | 1.2× |
| Cartpole | **0.9×** | 2.4× |

规律：接触多、关节多的操作任务（灵巧手、reorient、lift）和崎岖地形运动任务提升最大；简单任务（Cartpole、平地人形）提升小，Cartpole 甚至更慢。Franka reach 等少数任务上 MuJoCo Warp 略快于 Steel。

### 其他能力演示（视频，无数字）

刚体与 VBD 线缆/软体梁耦合、布料操作、刚体落在隐式 MPM 沙子上、水弹性（hydroelastic）接触抓笔、刚体休眠与岛划分；可微仿真（无人机 MPC）和光滑接触模型下的穿接触梯度标为"Experimental"。另有 WebGPU 版求解器，在浏览器里跑 24 个场景（叠叠乐、多米诺、纸牌屋、投石机等）。

### 测量设置

- 混合任务：Steel 用 Newton 1.8 RC（`01ea1293`），开启关节速度限制，因此 `reuse_kinematics` **未**生效；PhysX 来自 Isaac Sim 6.1.0.0（omni.physx 110.3.2），原生运行。每个环境步 = 一个 5 ms 物理步；目标是带小噪声的保持位置指令；没有策略、没有域随机化、没有相机；开启 CUDA graph。
- 单任务：Steel 开 `reuse_kinematics=True`；MuJoCo Warp 3.17；PhysX 来自 Isaac Sim 6.1.0；batch 最多扫到 524,288。只计物理步进，在返回主机处计时，每步同步设备；不含观测、奖励、重置。

## 局限 / 存疑

- **只有仿真吞吐**，没有任何策略训练速度、成功率或 sim-to-real 结果。仿真快 13 倍不等于训练快 13 倍，观测、渲染、网络前向都没算进去。
- **两组实验配置不同**：单任务开了 `reuse_kinematics`，混合任务没开；不能直接横向比较两组数字。
- **PhysX 版本的选择**：文中自己承认 Isaac Sim 6.0.0.0 的 PhysX 在这些混合任务上比 6.1 最多快约 2.7 倍，但对比用的是 6.1。若换成 6.0，13.0× 可能缩到约 5× 左右（粗算，需核对）。
- **Cartpole 的 0.9×**：Steel 的扫描停在 65,536 个环境，当时吞吐仍在上升；PhysX 和 MuJoCo Warp 扫到 524,288。这个劣势可能部分来自扫描范围。
- **PhysX 的 64K 材质上限**让它的混合任务曲线提前截断，"峰值"是在截断处取的，对 PhysX 不完全公平，也不完全不公平。
- 混合任务没有和 MuJoCo Warp 对比。
- 精度、稳定性、接触真实度没有评测；只比速度。
- Figure 5 把 Steel 仿真放在"多样性高、可扩展性高、贴近硬件程度中等"，作者自己注明是示意，不是测量结果。

## 与其他论文的关系

- **Newton**（NVIDIA 等开源，基于 Warp）：Steel 是其中的一个求解器，与 Newton 现有的 MuJoCo Warp 求解器并列。
- **PhysX / Isaac Lab**：主要对比对象和目标平台。
- **MuJoCo Warp / MJX**：同类 GPU 并行刚体仿真。
- Skild 自家博客：[S1](https://www.skild.ai/blogs/s1)、[omni-bodied](https://www.skild.ai/blogs/omni-bodied)、[physical self-play](https://www.skild.ai/blogs/physical-self-play)；Steel 是给这些跨本体训练提供数据的基础设施。
- 和 `topics/递归自我改进RSI.md` 第五节（环境与课程生成）相关：异构 batch 便宜了，自动生成大量不同任务/场景的课程才划算。

## 我的想法

## 原文摘录

> "Scalable Throughput-optimized Engine for Embodied Learning" — Steel 名称全称（Skild 博客）
