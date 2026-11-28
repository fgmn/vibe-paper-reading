---
id: "4-02"
org: 专题·JEPA系列
short: "JEPTERA"
title: "JEPTERA: A Platform Agnostic JEPA-Assisted Model Predictive Planner for Urban UAV Navigation"
aliases: ["JEPTERA", "JEPA-Assisted Model Predictive Planner for Urban UAV Navigation"]
date: 2026-11-16
category: "导航、驾驶与机器人应用"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "Universitas Muhammadiyah Yogyakarta（印尼）；King Fahd University of Petroleum and Minerals（沙特）"
partners: []
authors: ["Gibran Fathoni Belva", "Mansur Arief", "Ahmad Alfan Alfian Irfan"]
arxiv: "2611.20593"
pdf: "[[topics/papers/JEPA系列/4-02_2611.20593_JEPTERA.pdf]]"
code: "https://anonymous.4open.science/r/JEPTERA-33BE"
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "uav", "drone-navigation", "model-predictive-control", "collision-avoidance", "sim-portability"]
---

# JEPTERA: A Platform Agnostic JEPA-Assisted Model Predictive Planner for Urban UAV Navigation

> [!info] 论文信息
> arXiv [2611.20593](https://arxiv.org/abs/2611.20593) · v1 2026-11-16 · 7 页（IEEE 会议双栏格式，无附录）
> [代码（匿名仓库）](https://anonymous.4open.science/r/JEPTERA-33BE)
> PDF：[[topics/papers/JEPA系列/4-02_2611.20593_JEPTERA.pdf|本地 PDF]]
> 作者：Gibran Fathoni Belva、Ahmad Alfan Alfian Irfan（Universitas Muhammadiyah Yogyakarta，信息技术系）、Mansur Arief（KFUPM，工业与系统工程系）
> 专题：[[topics/JEPA系列#四、导航、驾驶与机器人应用|JEPA系列 · 四]]

> [!note] 下面各节是 Claude 根据 PDF 全文（7 页，含表 I–III）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 架构："JEPA predicts the UAV's motion response to candidate commands for MPC action selection, while the safety layer checks trajectories against occupied space and predicted obstacle motion."（Abstract，p.1）
> - 动机："Although MPC–PID with a safety layer provides reliable navigation, its performance may degrade in complex dynamic environments where anticipating obstacle motion is essential"（§I，p.1）
> - JEPA 的定位："JEPTERA positions JEPA as a model for predicting a UAV's motion response to candidate actions, while action selection is performed via MPC."（§II-B，p.2）
> - 优化器："The optimizer uses locally linearized JEPA motion-effect predictions and a nominal response model."（§III-A，p.2）
> - 运动读出："The matrix W maps the difference between the prediction and a zero-velocity reference into a displacement effect, expressed in meters."（§III-C，p.3）
> - 障碍物运动另算："The movement of obstacles is estimated separately via LiDAR tracking."（§III-C，p.3）
> - 动作信息作用有限："the marginal difference between the model using actual actions and the one using zero actions suggests that the benefit of action information for the aggregate latent error remains limited."（§V-A，p.4）
> - 不是每个场景都最好："In the mini gym, however, MPC–PID with safety completed all trials, while the complete architecture experienced one collision."（§V-B，p.4）
> - 城市地图测试有限："As this evaluation is currently limited to a single route per map and separate portability tests, it does not yet fully capture consistency across all operational conditions."（§V-E，p.5）
> - 未来工作："Future work will involve real-time testing and flight operations using physical hardware"（§V-E，p.5）

## 一句话总结

一个工程型的城市无人机导航栈：LiDAR 体素占据图 + 障碍物跟踪 + A* 路由走廊，**JEPA 只负责预测"候选速度指令会让无人机怎么动"**（体素观测序列编码成 64 维潜变量，预测器给出 k 步潜预测，再经线性读出 W 变成位移效应），MPC（SLSQP，4 步 × 0.2 s）用它和一个名义响应模型优化速度参考与路径点，安全层用占据图和预测的障碍物运动检查轨迹，最后由级联 PID 执行；平台适配器 + YAML 配置让同一个规划核心接入 PyBullet、MuJoCo、Gazebo/ROS 2、CARLA。gym-pybullet-drones 三个场景 × 6 种配置 × 10 次共 180 次运行，完整架构 28/30 成功率最高（MPC–PID + 安全层 27/30 紧随其后）。但 JEPA 带动作和"零动作"版本的潜预测误差只差 0.11%。

## 要解决什么问题

- 城市无人机导航要同时考虑建筑约束的空域、自身运动约束和移动障碍物，需要基于持续更新观测的在线规划。
- MPC 通过优化预测运动来选动作；作者认为 MPC–PID + 安全层虽可靠，但在需要预判障碍物运动的复杂动态环境里性能可能下降，于是想用 JEPA 的表征空间预测来改进 MPC 的运动预测。
- 另一个工程目标：规划核心与仿真器 / 平台解耦，换平台不改核心逻辑。

## 方法

### 架构（§III-A，图 1）

每个规划周期：
1. 用最新 LiDAR 更新**体素占据图** M_t（占据 / 空闲 / 未知，1 m 分辨率）和**障碍物轨迹** T_t（位置、尺寸、速度、不确定性），并给动态区域打标；
2. 路由引导（目标 / A* / 观测到的空闲空间）+ 空闲走廊；
3. **JEPA 运动预测** + 名义响应模型 → 连续 MPC（SLSQP）优化控制序列和路径几何；
4. 优化计划和备用计划重新评估，安全层做准入检查；
5. 执行守卫在两次规划之间监控当前指令（风险或倾角超限时刹车），速度参考经变化率限制；
6. 平台适配器转换坐标系 / 单位 / 编码，送给低层 PID。

### 状态与输入（§III-B）

- 规划用平移状态 x_t = [p_t, v_t] ∈ R⁶（世界系，m 和 m/s），姿态只给执行守卫用。
- 规划输入 u_{k|t} ∈ R³ 是世界系下的速度参考（连续值，不是电机指令），k = 0,…,H−1。

### JEPA 运动预测（§III-C）

- z_t = E_θ(O_t)，ẑ_{k|t}(U) = F_φ^{(k)}(z_t, A_t, U)：编码器从观测上下文（8 帧体素观测 + 无人机状态，间隔 0.2 s）得到 64 维潜变量；预测器根据潜变量、动作历史 A_t 和候选速度参考序列 U 给出 k 步预测。
- 训练：先做表征预训练（论文没说预训练目标是什么），然后**冻结编码器**，只训练预测器 10 epoch，损失是潜空间 L1（式 4），目标潜变量来自冻结编码器对目标观测的编码。数据 1,365 个训练窗口、735 个验证窗口。
- 运动读出（式 5）：Δp_{k|t} = W^⊤ (ẑ_{k|t}(U) − ẑ_{k|t}(0))，即候选指令与零速度参考的潜预测之差，经矩阵 W 映射为位移（米）。MPC 里使用的是**局部线性化**的 JEPA 运动效应预测，与名义响应模型一起用。
- 障碍物的运动不由 JEPA 预测，而是 LiDAR 跟踪单独估计。

### MPC（§III-D，式 6）

min_{U,P} J = C_track(U) + 8·L(U,P) + C_smooth(U) + C_route(U) + C_risk(U,P) + C_static(U)

- 4 个控制步、间隔 0.2 s（预测时域 0.8 s），SLSQP 同时优化速度参考 U 和路径点 P；
- 各项：终端参考跟踪、投影路径长度（权重 8）、运动平滑、偏离路由、靠近走廊边界和预测动态障碍物的风险、靠近静态占据空间的惩罚。

### 安全层与低层控制（§III-E）

- 对轨迹做占据图 + 预测障碍物运动的检查，包括刹车过程中的响应；自适应变体还评估刹车前的继续运动（停下来本身也可能撞上动态障碍）。
- PyBullet 实现里级联 PID：位置 / 速度误差 → 推力和姿态 → 电机转速。MPC 定义运动参考，PID 负责执行。

### 平台无关接口（§III-F）

输入适配器统一坐标系和单位，输出适配器把速度参考翻译成平台指令；YAML 定义机体几何、运动限制、响应参数、速度换算。

## 实验与关键数字

### 1. JEPA 预测误差（§V-A）

| 模型 | 潜空间 L1 误差 |
|---|---|
| 用真实动作 | 0.05343 |
| 零动作 | 0.05349 |
| 持续性基线（persistence） | 0.06624 |

- 相对持续性基线误差降约 19.3%，**相对零动作只降约 0.11%**——作者自己承认动作信息对总体潜误差帮助有限，导航上的作用交给消融去看。

### 2. 六种配置的消融（表 I，gym-pybullet-drones，每场景 10 次；时间和路径只统计成功运行，延迟统计全部运行）

三个场景：Crossing、Mini gym、Extended gym（含静态和动态障碍，动态障碍有不规则、曲线、折返、走停、加速、斜向等运动模式，图 2）。所有失败都以碰撞结束。

| 配置 | Crossing | Mini gym | Extended gym | 合计 |
|---|---|---|---|---|
| MPC–PID | 10/10 | 8/10 | 4/10 | 22/30 |
| MPC–PID + Safety | 10/10 | **10/10** | 7/10 | 27/30 |
| JEPA–PID | 0/10 | 0/10 | 1/10 | 1/30 |
| JEPA–PID + Safety | 10/10 | 9/10 | 6/10 | 25/30 |
| JEPA–MPC–PID | 10/10 | 10/10 | 2/10 | 22/30 |
| **JEPA–MPC–PID + Safety** | 10/10 | 9/10 | **9/10** | **28/30** |

（"合计"列是 Claude 按表 I 加总的；论文正文只给了 28/30 和 JEPA–PID 1 → 25。）

部分效率数字（表 I）：

| 场景 | 配置 | 时间 (s) | 路径 (m) | 延迟 (ms) |
|---|---|---|---|---|
| Crossing | MPC–PID | 99.23±3.54 | 102.55±3.19 | 192.94±2.85 |
| Crossing | JEPA–MPC–PID + Safety | 101.03±7.58 | 100.15±5.56 | 245.63±5.29 |
| Extended | MPC–PID + Safety | 282.56±31.41 | 569.19±80.83 | 195.32±8.26 |
| Extended | JEPA–PID + Safety | 211.05±7.29 | 548.38±8.17 | 201.69±11.85 |
| Extended | JEPA–MPC–PID + Safety | 289.32±16.69 | 549.47±7.27 | 238.54±8.19 |

- Extended gym 是区分度最大的场景：完整架构 9/10，去掉安全层只剩 2/10。
- Mini gym 里 MPC–PID + Safety 10/10，完整架构 9/10（一次碰撞）。
- MPC–PID 加入 JEPA 后规划延迟增加约 30–40 ms（不含安全层：Crossing 192.94 → 232.73 ms，Mini 180.70 → 211.79 ms，Extended 183.91 → 225.37 ms）。
- JEPA–PID（无 MPC、无安全层）几乎全失败，加安全层后 25/30。

### 3. 城市地图（表 II，完整架构，每张图 1 条路线）

| 地图 | 成功 | 时间 (s) | 路径 (m) | 误差 (cm) |
|---|---|---|---|---|
| City A | 1/1 | 186.93 | 383.55 | 0.90 |
| City B | 1/1 | 172.73 | 356.85 | 2.12 |
| City C | 1/1 | 166.73 | 328.09 | 1.33 |

### 4. 跨仿真器移植（表 III）

| 集成 | 结果 | 时间 (s) | 误差 (m) |
|---|---|---|---|
| MuJoCo | 到达目标 | 7.63 | 0.048 |
| Gazebo / ROS 2 | 到达目标 | 12.23 | 0.047 |
| CARLA | 到达目标 | 8.23 | 0.277 |

同一规划核心，只改适配器和平台 YAML。

## 局限 / 存疑

> §V-E 是作者自己的讨论与局限（城市图每张只测 1 条路线、移植测试是分开做的、还没上真机）；其余是 Claude 的推断，请核对。

- **JEPA 的贡献不清楚**：带动作与零动作的潜误差只差 0.11%，说明预测器几乎没用上候选指令；而 MPC 里候选指令的效果恰恰来自 ẑ(U) − ẑ(0) 这个差。总成功率上，完整架构 28/30 只比不含 JEPA 的 MPC–PID + Safety（27/30）多 1 次，10 次重复下这个差异没有统计意义；JEPA–MPC–PID（无安全层）和 MPC–PID 都是 22/30。主要增益看起来来自安全层。
- **JEPA 本身描述不足**：表征预训练用什么目标、编码器结构、动作怎么编码、W 怎么得到、"局部线性化"怎么做，论文都没交代；训练数据只有 1,365 个窗口。
- **"JEPA" 的含义偏弱**：观测是 1 m 分辨率的体素 + 状态，预测目标最终被读出成位移；和 I-JEPA / V-JEPA 2 意义上的大规模自监督视觉表征关系不大（Claude 推断）。
- **评估规模小**：每配置每场景 10 次、城市图每张 1 次、移植测试每个平台 1 次，没有方差 / 置信区间检验。
- **CARLA 是驾驶仿真器**，论文没说明无人机在 CARLA 里是怎么建模的；移植表只给到达时间和误差，看不出规划质量。
- 规划时域只有 0.8 s，动态障碍物主要靠 LiDAR 跟踪 + 安全层处理，JEPA 不预测障碍物运动——与引言里"预判障碍物运动"的动机对不上。
- 式 (6) 写 L(U,P)，正文解释写 L(P)，符号小不一致。
- 全部在仿真，无真机；作者把真机飞行列为未来工作。

## 与其他论文的关系

- **JEPA 来源**：引用 LeCun 的 JEPA 立场论文、[[topics/notes/JEPA系列/2-01_I-JEPA|I-JEPA]]、[[topics/notes/JEPA系列/2-02_V-JEPA|V-JEPA]]、[[topics/notes/JEPA系列/2-03_V-JEPA2|V-JEPA 2]]（动作条件世界模型用于机器人规划）作为动机，但本文的 JEPA 是自己在体素观测上训练的小模型，只当 MPC 的运动响应模型用。
- 与本系列世界模型篇的对比：[[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]]、[[topics/notes/JEPA系列/1-05_LeWM|LeWM]] 用 CEM 直接在潜空间里优化到目标的距离；JEPTERA 把潜预测读出成物理位移，再交给经典的 SLSQP-MPC + 代价项。
- **经典无人机规划**：EGO-Planner、FASTER、Fast-Planner、minimum-snap、DWA；安全层思路来自 CBF-QP、离散时间 CBF-MPC、predictive safety filter。
- 导航专题：[[topics/无人机VLN|无人机VLN]]（本文不涉及语言，是 LiDAR 城市导航 / 避障）；同系列导航应用：[[topics/notes/JEPA系列/4-01_InJePA|InJePA]]（室内图像目标导航）、[[topics/notes/JEPA系列/4-03_Auto-JEPA|Auto-JEPA]]（自动驾驶）。
- 系列总览：[[topics/JEPA系列]]。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Urban navigation for Unmanned Aerial Vehicles (UAVs) requires planning that accounts for environmental geometry, vehicle dynamics, and moving obstacles. This paper presents JEPTERA, a navigation architecture that integrates a Joint-Embedding Predictive Architecture (JEPA), Model Predictive Control (MPC), PID control, and a safety layer. JEPA predicts the UAV's motion response to candidate commands for MPC action selection, while the safety layer checks trajectories against occupied space and predicted obstacle motion. Simulator adapters and platform-specific YAML configurations separate the planning core from simulator interfaces. An ablation study evaluated six configurations across three gym scenarios, totaling 180 runs. The complete architecture achieved the highest aggregate success rate, completing 28 of 30 runs. Additional tests completed one route across three city maps without collisions. Separate integration tests demonstrated operation in Gazebo/ROS 2, MuJoCo, and CARLA without modifying the core planning logic. These results support the feasibility of the integrated architecture for simulated urban UAV navigation and its portability across simulator interfaces.
