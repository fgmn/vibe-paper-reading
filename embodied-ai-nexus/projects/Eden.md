---
org: Embodied AI Nexus
short: "Eden"
title: "Eden: One Task Definition from Simulation to Real Robots"
date: 2026-11-14
category: 仿真
source: embodied-ai-nexus 开源（基于 Genesis）
partners: []
code: "https://github.com/embodied-ai-nexus/Eden"
status: 暂无 PDF
read_date:
rating:
tags: ["project", "仿真", "机器人学习框架"]
---

# Eden：一份任务配置，从仿真训练到真机部署

> [!info] 项目信息
> [代码](https://github.com/embodied-ai-nexus/Eden) · [文档](https://embodied-ai-nexus.github.io/Eden) · [Genesis](https://github.com/Genesis-Embodied-AI/genesis-world) · PyPI 包名 `eden-world`（`pip install eden` 装的是无关项目）
> 作者署名 "Eden Authors"；`pyproject.toml` 写的作者是 Kashu Yamazaki。仓库建于 2026-05-10，本笔记读的是 2026-11-14 的 `main`（`83f00d2`），版本 0.1.0，Alpha。Apache-2.0。
> 这是开源框架，不是论文：没有 arXiv、没有对比实验，引用格式只是 `@misc`。下面的数量（245 个 term、47 个机器人、66 个任务、21 个策略）都是 README 自己的说法，没有逐个清点。

Eden = **E**mbodied-AI **D**evelopment **E**nvironments **N**exus。

## 一句话总结

Eden 是建在 Genesis 物理引擎上的机器人学习框架，定位类似"Genesis 版 Isaac Lab / mjlab"：一个任务写成一个 Pydantic 配置，在几千个 GPU 并行环境里用 RL 训练，再用 `eden deploy` 先在 MuJoCo 里做 sim-to-sim、再上真机。它把运动、动作模仿、操作、灵巧手、可变形物体、遥操作、数据集、VLA 客户端和部署都放进同一套接口里。

## 要解决什么问题

- 机器人学习的工具链是碎的：训练用 Isaac Lab，可变形物体换别的引擎，动作重定向、遥操作、数据录制、已发表策略的复现、真机部署又各是一套代码。
- Eden 的回答：**同一份任务配置**贯穿训练 → 回放 → 导出 → MuJoCo 校验 → 真机；周边能力（重定向、遥操作、录数据、调用外部策略）都挂在同一个环境接口上。
- 另一个明确目标是**方便编程智能体（coding agent）使用**：配置严格校验、报错信息直接给出修法、仓库自带 `AGENTS.md` 和若干 Claude Code skill。

## 方法（框架设计）

### 核心抽象：配置 → 环境 → 实体 → 管理器 → term

- **配置**：任务是 `EdenRLConfig`（RL）/ `EdenConfig`（无奖励）/ `EdenMimicConfig`（动作模仿，多一个参考动作）的子类。字段是选项组：`env_options`、`scene_options`、每个管理器一个 `*_options`、`runner_options`。全是 Pydantic，构造时校验，可存成 JSON/YAML，**拼错字段名立即报错**。
- **TaskMod**：任务的变体（换机器人、难度、曲目……），构造参数自动变成命令行参数，如 `--difficulty hard`、`--robot oli`。
- **管理器和 term**：沿用 Isaac Lab / mjlab 的 manager-based 设计。动作、指令、观测、奖励、终止、事件（随机化/重置）、课程、指标、录制各一个管理器，每个管理器跑一组 term。term 可以是加了装饰器的函数（无状态），也可以是类（参数校验、`build()` 时解析名字、跨步保存状态）。`eden terms --grep friction` 能搜索现有 term 及其参数。
- **注册表**：任务名 = 类名转 snake_case 去掉 `Config`；注册表靠扫描源码找装饰器，不需要中央列表。
- **一个控制步**：施加动作 → 物理 `decimation` 次 → 终止 → 奖励 → 重置结束的环境 → 课程/指令/事件 → 观测。注意**自动重置在观测之前**，结束环境返回的是新回合的第一帧。默认 200 Hz 物理、50 Hz 策略。

### 物理

- Genesis 的所有求解器都能用：刚体、PBD、MPM、SPH、FEM，由实体的**材质**决定进哪个求解器。
- **Mochi**：Eden 自己挂在 Genesis 上的全隐式多物理求解器（原实现来自 Meta 的 `project_superdex`）。每个子步对刚体/关节体、四面体软体、薄壳布料、离散弹性杆**联立解一个非线性方程组**，接触用平滑 SDF 罚函数，每次 Newton 迭代都重新检测接触，因此大步长稳定，软硬耦合不需要额外的耦合器。
  - 限制：Mochi 场景必须**全部**实体都用 Mochi 材质；默认刚度 1e9 Pa/m 需要双精度，Mochi 任务把刚度降到 1e7 才能用 `eden train` 的单精度训练；不支持可微、不支持批量渲染器。
- 基准（仓库内 `tests/engine/solvers/mochi/benchmark/README.md`，Ryzen 9 9900X + RTX 3080）：经过若干轮优化后，Genesis 版 Mochi 在 CPU 双精度上是原版单线程 mochi 的 2.2–7.4 倍耗时（优化前是 20–160 倍）；除带自碰撞的 T 恤外，每步只发一次 kernel。GPU 单精度 1024 个环境时，刚体场景约 2.2 µs / 环境步。

### 感知与渲染

- 相机（RGB / 深度 / 分割 / 法线 / 点云）、激光雷达、触觉、IMU、接触、**音频**（钢琴任务按下琴键合成声音）。
- 渲染器四选：光栅化（默认）、Madrona 批量渲染（从像素训练，仅 Linux x86）、光线追踪、Nyx 路径追踪（照片级，仅 CUDA）。
- 批量 Gaussian splat 背景：每个并行环境配一个 3DGS 场景，和仿真物体合成渲染。

### 数据：动作数据集、重定向、遥操作

- 12+ 个动作数据集的加载器，统一成一种动作格式：AMASS、LAFAN1、SEED、PHUMA、OMOMO、ARCTIC、DexYCB、HOT3D、OakInk2、TACO、HHI-Assist、Weave 等。
- `eden retarget`：人体动作重定向到机器人（SOMA、OTRetarget、OmniRetarget），也支持**带物体**的人-物交互（HOI）重定向和灵巧手重定向。
- 遥操作：GELLO、Meta Quest、PICO、Wuji 手套、SONIC；录成 HDF5 或 LeRobot 数据集；也能写脚本演示批量生成数据。

### 训练、导出、部署

- RL 库：rsl_rl（默认）、rl_games、skrl、Stable-Baselines3；多 GPU 用 `torchrun` DDP，`num_envs` 按每卡计。
- `eden export`：ONNX / TorchScript + `policy_spec.json`，给 ROS 2、Jetson、C++ 用。
- `eden deploy`：
  - 后端按机器人类绑定：Unitree G1 / Go2 / Go1、LimX Oli、Franka、RoboTera XHand、Wuji Hand 1/2，以及"臂+手"组合（每部分走各自 SDK）。
  - 同一个控制循环可以换成进程内 MuJoCo（`--mujoco`），先做 sim-to-sim 校验。
  - 安全设计：启动处于 STOP，手动 INIT（插值到初始姿态）再 START；建议先用低增益（`--deploy_kp_kd_scale 0.2`）；G1 上预装 Holosoma 行走策略作为"安全槽"，可以在多个策略槽之间热切换。
  - 回放和部署都读取 checkpoint 旁边保存的 `config.json`，保证跑的是训练时的环境。

### 策略库（Policy Zoo）

`eden inference --policy <name>` 直接跑已发表的控制器，权重首次使用时从 Hugging Face 下载并校验 MD5：

| 类别 | 策略 |
|---|---|
| 人形行走 | Holosoma、HOMIE、AMO、HUSKY（滑板）、LimX Oli（无发布权重） |
| 人形动作跟踪 | GEAR-SONIC、TWIST2、Humanoid-GPT、ProtoMotions v3、OmniXtreme、GMT、BeyondMimic（60 个片段各一个策略）、Meta Motivo |
| 操作 | SimToolReal（KUKA + SharPa 手用工具）、OmniReset（UR5e 插孔） |
| 远程服务器客户端（VLA / 世界模型） | OpenPI（π0 / π0-FAST / π0.5）、GR00T、GalaxeaVLA G0.5、Cosmos3-Nano-Policy、MolmoAct2、Octo |

VLA 走客户端模式：Eden 只负责打包观测、解码动作，模型在单独的服务器上推理。

## 任务与基准

66 个注册任务（`eden list` 查看）：

- **运动**：G1 / Oli 速度跟踪（平地、地形）、Go2 极限跑酷（teacher-student，深度相机蒸馏）、Go1 起身和倒立、HOMIE、HUSKY 滑板。
- **动作跟踪**：BeyondMimic、通用动作库跟踪（自适应课程）、带物体的 HOI 跟踪（G1 + Inspire 手）、手-物接触跟踪、**双智能体**护理任务（一个人形扶另一个起身/下床）。
- **操作与灵巧手**：Franka 抓举（含 RGB 和 YCB 多物体）、XHand 抓举、Wuji 手转方块、双 Wuji 手弹钢琴、UR5e 装配、手-物演示物理修正（FlashDexRetarget）、`reacher`（所有任务的模板）。
- **移植的基准**：robosuite（11 个）、LIBERO、SIMPLER（Bridge，4 个）、PolaRiS（6 个 + 批量版）。
- **Mochi 可变形**：叠毛巾、走线缆、用海绵擦吧台。
- **艺术类**：白板写字画画、毛笔书法、湿颜料丙烯画（《星月夜》）。

## 局限 / 存疑

- **没有论文，也没有和 Isaac Lab / mjlab / ManiSkill 的吞吐或训练效果对比**。唯一的性能数字是 Mochi 和原版 mochi 的单步耗时，而且 Genesis 版 CPU 上仍然慢 2–7 倍。
- 移植的基准（LIBERO、SIMPLER、robosuite 等）"保留场景和成功判定"，但换了物理引擎，结果能否和原基准对齐没有给数字，跨引擎比较 VLA 成功率要小心。
- 策略库里的策略是"按发布原样移植"，换了仿真器后行为是否与原实现一致，文档有专门的移植指南但没有逐个给出一致性指标。
- Mochi 的约束较多：全场景必须 Mochi、默认要双精度、不能批量渲染，目前更像演示和小规模任务。
- 平台：主力是 Linux + NVIDIA；macOS / Windows 尽力支持，Nyx、splat、Wuji 手套 SDK 有平台限制。0.1.0 Alpha，Python 限定 3.12–3.13，Genesis 锁定 1.4.6。
- 数量（245 term、47 机器人等）来自 README，未核对。

## 与其他工作的关系

- **Genesis**（底层引擎）、**quadrants**（生成 GPU/CPU 并行 kernel 的编译器）、gs-madrona（批量渲染）、genesis-nyx（路径追踪）。
- **Isaac Lab / mjlab**：管理器 + term 的设计直接沿用；仓库自带 `mjlab-to-eden` skill，用来把 mjlab 任务转成 Eden。
- **Skild Steel**（`skild/projects/Steel.md`）：同样关注"大规模、异构的仿真"，但 Steel 是一个求解器，Eden 是完整的训练-部署框架；Eden 的异构性体现在每个环境可以放不同物体（如 `manipulation_lift_ycb_rgb`）和批量 splat 背景，没有给 Steel 那样的吞吐数据。
- **MirroS AgentGarten**（`mirros/notes/01_AgentGarten.md`）：都强调给智能体用；Eden 是给"写代码的智能体"用（严格报错、AGENTS.md、`wire-vla` 等 skill），AgentGarten 是给"在世界里行动的智能体"用。
- **VLA 评测**：π0.5、GR00T、GalaxeaVLA、Cosmos3、MolmoAct2、Octo 都能接进 LIBERO / SIMPLER / PolaRiS 场景，可作为跨模型统一评测台；和 `topics/递归自我改进RSI.md` 第五节（环境与课程生成）相关。
- 语义 3DGS 专题：批量 Gaussian splat 背景是"真实扫描场景 + 并行仿真"的一种工程实现，可和 `topics/语义3DGS与具身导航.md` 对照。

## 我的想法

## 原文摘录

> "Write any robot-learning task as one typed config" — README 开头的定位句
