---
id: "4-03"
org: 专题·JEPA系列
short: "Auto-JEPA"
title: "Auto-JEPA: A Latent World Model of Continuous Intent for End-to-End Autonomous Driving"
aliases: ["Auto-JEPA", "A Latent World Model of Continuous Intent for End-to-End Autonomous Driving"]
date: 2026-07-31
category: "导航、驾驶与机器人应用"
venue: "arXiv 预印本"
source: "arXiv"
affiliation: "清华大学车辆与运载学院；清华大学智能绿色车辆与交通全国重点实验室"
partners: []
authors: ["Jiwei Yang", "Zhengxian Chen", "Chaosheng Huang", "Jun Li"]
arxiv: "2607.29031"
pdf: "[[topics/papers/JEPA系列/4-03_2607.29031_Auto-JEPA.pdf]]"
code: "https://github.com/NoctYang/Auto-JEPA"
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "autonomous-driving", "end-to-end-planning", "navsim", "trajectory-retrieval", "world-model"]
---

# Auto-JEPA: A Latent World Model of Continuous Intent for End-to-End Autonomous Driving

> [!info] 论文信息
> arXiv [2607.29031](https://arxiv.org/abs/2607.29031) · v1 2026-07-31 · 12 页（正文 7 页 + 补充材料）
> [代码与模型](https://github.com/NoctYang/Auto-JEPA)
> PDF：[[topics/papers/JEPA系列/4-03_2607.29031_Auto-JEPA.pdf|本地 PDF]]
> 作者：Jiwei Yang、Zhengxian Chen†、Chaosheng Huang、Jun Li（清华大学车辆与运载学院；Chen 另属智能绿色车辆与交通全国重点实验室）。† 通讯作者
> 专题：[[topics/JEPA系列#四、导航、驾驶与机器人应用|JEPA系列 · 四]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含补充材料的实现细节、超参表和局限）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 核心主张："We argue that planning need not reconstruct the complete future world, but only focus on scene features that affect future ego action."（Abstract，p.1）
> - 与其他潜世界模型的区别："Auto-JEPA instead predicts the representation of future ego motion itself, retaining scene dynamics through their implications for the planned trajectory."（Related Work，p.2）
> - 与 Drive-JEPA 的区别："the future ego-trajectory latent directly serves as the planner's retrieval key and therefore participates in trajectory planning at inference"（Related Work，p.2）
> - 意图的含义："jointly describe one continuous future realization rather than eight maneuver classes"（Method，p.3）
> - 检索不管安全："Retrieval identifies intent-compatible geometry, while subsequent modules handle scene-level safety."（Method，p.5）
> - 打分器来自 CLOVER："We initialize Sϕ from the publicly released CLOVER trajectory scorer (Ang et al. 2026)"（Method，p.5）
> - v2 对比："CLOVER reports 90.4 EPDMS with a learned generator–scorer pipeline; Auto-JEPA remains competitive without parametric proposal generation."（Results on NAVSIM v2，p.6）
> - 去掉意图的消融："Replacing the predicted intent with a fixed codebook medoid reduces PDMS from 91.3 to 52.6"（Ablation，p.6）
> - 单次评估："they are not averages over independently retrained models."（补充材料，p.12）
> - 记忆覆盖的上限："If no feasible maneuver is represented in the retrieved candidate pool, neither the scene scorer nor the feasibility gate can synthesize one."（补充材料 Limitations，p.12）

## 一句话总结

驾驶世界模型大多做稠密未来预测（视频、占据、BEV、他车运动），作者认为规划只需要关心"会影响自车未来动作"的场景信息。Auto-JEPA 先训练一个轨迹自编码器并冻结其编码器，定义"未来自车轨迹潜空间"（8×1024 token，叫**连续驾驶意图**）；再用冻结的 V-JEPA 2 编码 4 帧前视图像，加上自车历史和导航指令，由 24 层 Transformer 预测器以 JEPA 方式（特征对齐 + token 余弦 + 批内 InfoNCE）预测这个意图潜变量。推理时用预测的意图去一个固定的 11 万条真值轨迹库里余弦检索 Top-300，再由从 CLOVER 初始化的场景打分器排序、一个可驾驶区域（DAC）门控过滤。只用单前视相机、不需要感知标注、没有学习式轨迹生成器，NAVSIM v1 达到 91.3 PDMS、NAVSIM v2 89.1 EPDMS（更新后的官方评估器；原评估器 85.6）。遮挡动态交通参与者导致的意图变化是等面积随机遮挡的 2.97 倍。

## 要解决什么问题

- 现有驾驶世界模型（GAIA-1、DriveDreamer、OccWorld、LAW、World4Drive、DeepSight、DriveWorld-VLA 等）预测的是"场景如何演化"：未来视频、占据、BEV 或潜特征，需要把容量分给很多对自车当下决策无关的元素，计算重，感知 / 预测误差还会传到规划。
- 作者主张：面向规划的预测模型不必重建完整未来，只需关注影响自车未来动作的场景特征——所以**预测目标直接取自车未来轨迹的表征**。
- 同时想避开学习式轨迹生成器（扩散 / 流匹配 / 自回归解码），用非参数的轨迹库检索给出可执行几何。

## 方法

### 阶段 1：轨迹潜空间预训练（Method；补充材料）

- 未来轨迹 Y ∈ R^{8×2}：4 秒、间隔 0.5 s 的 8 个平面路点（坐标除以 64 归一化）。
- 轨迹自编码器：编码器 E_traj（4 个 Transformer 块，宽 1024，16 头，8 个 Fourier 频带编码坐标）输出 Z⁺ = E_traj(Y) ∈ R^{8×1024}；轻量解码器（4 个自注意力块）预测路点增量再累加。
- 损失 L_traj = L_xy + 2.0 L_end + 0.5 L_vel + 0.2 L_acc（坐标、终点、速度、加速度），最多 40 epoch，按验证 ADE 选 checkpoint。
- 训练完**丢掉解码器、冻结编码器**：它既定义意图预测的目标，也编码轨迹库里的每条轨迹，保证预测和候选在同一个空间。8 个 token 合起来描述**一条**连续的未来实现，不是 8 个机动类别。

### 阶段 2：视觉意图预测

- 输入 X = (I, H, C)：4 帧历史前视图像（256×256）、4 个历史自车位置 H ∈ R^{4×2}、路由指令 C ∈ R⁴。
- 冻结的 V-JEPA 2 编码器出视觉 token；历史编码器、指令编码器把其余输入投到 1024 维。
- JEPA 预测器 P_θ：24 个 Transformer 块、宽 1024、16 头，加 8 个可学习的未来时刻 query，输出 Ẑ ∈ R^{8×1024}。
- 目标（式 12）：L_intent = 0.1 L_feat + 2.0 L_cos + L_NCE
  - L_feat：归一化后的 Smooth L1 特征对齐；
  - L_cos：8 个时刻逐 token 余弦距离；
  - L_NCE：把整段潜序列拉平归一化，批内其他场景的目标潜变量作负样本（τ = 0.07，分布式训练时跨 GPU 收集负样本），防止不同场景塌到相似表征。
- 不直接用 ADE/FDE 监督路点；不用任何物体框、占据、语义地图或他车运动标签。只训练历史编码器、指令编码器和预测器（每 GPU batch 8，lr 1e-5，10 epoch）；数据增强有时间帧遮挡（p=0.3，遮 1–3 帧，同时遮对应的历史位置）和随机擦除（p=0.2）。

### 推理：非参数检索 + 打分 + 门控

| 步骤 | 做法 |
|---|---|
| 轨迹库 | 只用 NAVSIM 训练集真值轨迹，N = 110,335 条，每条存 (Z_n, Y_n)；navtest 场景不进库 |
| 检索 | 拉平 + ℓ2 归一化后算平坦余弦 r_n = q^⊤ m_n，取 Top-K（K = 300） |
| 场景打分器 S_φ | 输入场景特征、自车上下文、候选轨迹，输出质量分 s_k。**从公开的 CLOVER 轨迹打分器初始化**，再在 Auto-JEPA 检索出的候选上重新优化：碰撞、可驾驶区域、TTC、舒适度、进度回归 + 场景内排序损失（L_score = L_comp + 0.5 L_rank） |
| DAC 门控 G_ψ | 独立训练，预测候选违反可驾驶区域的概率 p^DAC_k；用 7 个运动学特征 + 候选集自注意力；p ≤ 0.2 的才进入最终选择，全被拒时退回不加门控的排序 |
| 最终选择 | 门控掩码下对 s_k 取 argmax |

- 打分器和门控只用 NAVSIM 训练集场景的候选训练（75,823 训练 / 8,459 验证场景，scene-prefix 划分），标签由 NAVSIM/CLOVER 的 get_sub_score 离线生成（批量 navsim_v1_style 重标注，关闭逐候选双向 rollout）；梯度不回传到视觉编码器、预测器或轨迹库。
- 作者把这四部分的分工概括为：预测器决定"什么样的未来运动合适"，检索提供显式几何，打分器估计场景级驾驶质量，门控减少出界。各部分分阶段优化，但对外仍是传感器 → 轨迹的端到端接口。

## 实验与关键数字

所有 benchmark 数字都是**所选 checkpoint 的单次确定性 full-navtest 评估**，不是多次重训的平均。

### 1. NAVSIM v1 navtest（表 1，12,146 个场景）

| 方法 | 传感器 | NC | DAC | TTC | C | EP | PDMS |
|---|---|---|---|---|---|---|---|
| Human | – | 100.0 | 100.0 | 100.0 | 99.9 | 87.5 | 94.8 |
| TransFuser | 3×C+L | 97.7 | 92.8 | 92.8 | 100.0 | 79.2 | 84.0 |
| Hydra-MDP | 3×C+L | 98.3 | 96.0 | 94.6 | 100.0 | 78.7 | 86.5 |
| DiffusionDrive | 3×C+L | 98.2 | 96.2 | 94.7 | 100.0 | 82.2 | 88.1 |
| LAW（潜世界模型） | 1×C | 96.4 | 95.4 | 88.7 | 99.9 | 81.7 | 84.6 |
| WoTE（BEV 世界模型） | 3×C+L | 98.5 | 96.8 | 94.4 | 99.9 | 81.9 | 88.3 |
| Epona | 3×C | 97.9 | 95.1 | 93.8 | 99.9 | 80.4 | 86.2 |
| AdaThinkDrive（VLA） | 1×C | 98.4 | 97.8 | 95.2 | 100.0 | 84.4 | 90.3 |
| DriveVLA-W0（VLA） | 1×C | 98.7 | 99.1 | 95.3 | 99.3 | 83.3 | 90.2 |
| Curious-VLA（VLA） | 1×C | 98.4 | 96.9 | 97.9 | 98.1 | 88.5 | 90.3 |
| **Auto-JEPA** | 1×C | 98.4 | 98.3 | 95.0 | 100.0 | 87.1 | **91.3** |

（表 1 还有 PARA-Drive 84.0、DrivingGPT 82.4、AutoVLA 89.1、RecogDrive 89.6，这里省略。）

### 2. NAVSIM v2（表 2）

| 方法 | NC | DAC | DDC | TL | EP | TTC | LK | HC | EC | EPDMS |
|---|---|---|---|---|---|---|---|---|---|---|
| DiffusionDrive | 98.2 | 95.9 | 99.4 | 99.8 | 87.5 | 97.3 | 96.8 | 98.3 | 87.7 | 84.5 |
| DriveSuprim (ViT-L) | 98.4 | 98.6 | 99.6 | 99.8 | 90.5 | 97.8 | 97.0 | 98.3 | 78.6 | 87.1 |
| DriveWorld-VLA | 98.6 | 99.1 | 99.6 | 99.8 | 87.4 | 97.9 | 97.0 | 97.8 | 78.6 | 86.8 |
| Auto-JEPA（原评估器） | 98.5 | 98.7 | 98.2 | 97.2 | 90.5 | 97.9 | 84.0 | 97.8 | 75.4 | 85.6 |
| Auto-JEPA†（更新后的官方评估器 + 人类行为过滤） | 98.5 | 98.7 | 98.3 | 99.7 | 90.5 | 97.9 | 94.7 | 97.8 | 75.2 | **89.1** |

- 评估器变化主要影响 TL（97.2 → 99.7）和 LK（84.0 → 94.7）。
- 其他方法是论文自报数字；CLOVER（打分器的来源）报告 90.4 EPDMS，高于 Auto-JEPA，作者的说法是"无需参数化候选生成也有竞争力"。

### 3. 消融（表 3、表 4，NAVSIM v1）

| 意图 | 打分器 | 门控 | NC | DAC | TTC | C | EP | PDMS |
|---|---|---|---|---|---|---|---|---|
| ✗（换成固定码本 medoid） | ✓ | ✓ | 83.1 | 85.3 | 76.2 | 86.3 | 37.8 | 52.6 |
| ✓ | ✗ | ✓ | 98.1 | 96.4 | 94.0 | 100.0 | 81.7 | 87.6 |
| ✓ | ✓ | ✗ | 98.5 | 97.9 | 95.0 | 99.9 | 86.9 | 91.0 |
| ✓ | ✓ | ✓ | 98.4 | 98.3 | 95.0 | 100.0 | 87.1 | 91.3 |

- 去掉场景条件的意图检索崩到 52.6；只靠意图检索 + 门控已有 87.6；打分器贡献 3.7 分；门控贡献 0.3 分、DAC +0.4。补充材料提醒这是"条件"比较，不是逐个叠加。
- 候选池大小（表 4）：K = 1 / 200 / 300 → 87.6 / 91.1 / 91.3，200 以后接近饱和。

### 4. 语义遮挡分析（Analysis，图 4、图 5）

- 在 15,364 个验证样本上，4 帧都遮住所有动态交通参与者区域，平均意图变化（1 − cos）0.080；等面积随机遮挡 0.027，**比值 2.97×**；71.1% 的样本里遮动态体的影响更大。
- 单车遮挡（图 1、图 4）：遮住有交互的前车，意图和所选轨迹明显变化（如开阔道路场景终点偏移 0.00 vs 2.09 m，前车交互场景 0.65 vs 3.60 m）；遮住不相关的邻车，几乎不变。作者强调预测器没见过任何物体框或交互标签，这种选择性来自"未来自车轨迹表征"的监督。

## 局限 / 存疑

> 补充材料有 "Limitations and Failure Modes"（不提供场景级预测、受轨迹库覆盖限制、打分器校准误差）；其余是 Claude 的推断，请核对。

- **"世界模型"名不副实的风险**：Auto-JEPA 不预测场景状态、也不做动作条件的动力学展开，本质是"从观测预测未来自车轨迹的嵌入"再检索——更像嵌入空间里的模仿学习规划器。作者自己在局限里也说它不提供交互仿真、反事实环境生成所需的场景级预测。
- **最终性能很依赖 CLOVER 打分器**：打分器从 CLOVER 初始化，只靠意图 + 门控是 87.6，打分器加 3.7 分到 91.3。意图模块的作用看"意图换成码本 medoid"那一行（91.3 → 52.6）很清楚，但只用意图检索 + 门控的 87.6 在表 1 里排不到前列，91.3 的名次有相当一部分来自借来的打分器。
- **v2 结果的可比性需核对**：89.1 用的是更新后的评估器 + 人类行为过滤，而表 2 中其他方法是自报数字（多为原评估器）。在原评估器下 Auto-JEPA 是 85.6，低于 DriveSuprim（87.1）和 DriveWorld-VLA（86.8）；直接拿 89.1 和其他行比不公平。
- **单次评估、无方差**：作者明说 NAVSIM 全量评估太贵，没有多种子。
- **检索上限**：轨迹库里没有的机动就选不出来（作者自承），K 从 200 到 300 已饱和；轨迹库来自训练集真值，长尾或罕见场景的覆盖存疑。
- **"验证集"的口径需核对**：语义遮挡分析用"完整验证集"15,364 个样本，而打分器 / 门控的候选数据集验证集是 8,459 个场景，二者应该不是同一个划分，论文没讲清楚。
- 打分器和门控的训练标签用的是关闭双向 rollout 的 navsim_v1_style 重标注，与官方评估协议不同（作者说明最终结果另用官方协议评估）。
- 只用前视单相机，在需要侧后方信息的场景（并线、路口）可能吃亏，但 NAVSIM 是非反应式的开环式评估，闭环表现未知。

## 与其他论文的关系

- **JEPA 来源**：视觉编码器是冻结的 [[topics/notes/JEPA系列/2-03_V-JEPA2|V-JEPA 2]]；预测目标思路沿用 [[topics/notes/JEPA系列/2-01_I-JEPA|I-JEPA]] / [[topics/notes/JEPA系列/2-02_V-JEPA|V-JEPA]] 的"预测目标表征而不是重建"，只是目标换成了冻结轨迹编码器给出的未来轨迹潜变量（目标编码器冻结，起到类似 stop-gradient 防坍塌的作用，再加 InfoNCE 防止不同场景塌到一起）。
- **驾驶里的 JEPA**：Drive-JEPA（视频 JEPA 预训练 + 多模态轨迹蒸馏）只在训练时用 JEPA；Auto-JEPA 让预测的潜变量在推理时直接当检索键。
- **驾驶潜世界模型**：LAW、World4Drive、DeepSight、DriveWorld-VLA 预测未来场景特征 / BEV；本文改为预测自车运动表征。
- **轨迹词表 + 打分**：VADv2、Hydra-MDP、SparseDriveV2 从离线词表打分；DiffusionDrive、GoalFlow、iPad 生成或细化候选；CLOVER 生成器 + 打分器（本文打分器的初始化来源）。PRANK 在运动预测里做过潜轨迹近邻检索。
- 与本系列其他"意图"工作的对照：[[topics/notes/JEPA系列/4-01_InJePA|InJePA]] 的"意图"是下一步想到达的观测潜状态，由 CVAE 先验采样并与前向 JEPA 闭环；Auto-JEPA 的"意图"是整段未来自车轨迹的潜表示，用于检索。另一篇导航应用是 [[topics/notes/JEPA系列/4-02_JEPTERA|JEPTERA]]（无人机 MPC）。
- 系列总览：[[topics/JEPA系列]]。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Existing autonomous-driving world models typically perform dense prediction of future videos, occupancy states, BEV representations, or agent motion. We argue that planning need not reconstruct the complete future world, but only focus on scene features that affect future ego action. Based on this perspective, we propose Auto-JEPA, an action-oriented latent world model that learns continuous future driving intent through joint-embedding prediction. Given visual observations, ego-motion history, and navigation commands, Auto-JEPA predicts an intent embedding aligned with the latent representation of the future ego trajectory. The predicted intent retrieves executable trajectories from a fixed trajectory memory, which are then ranked by a scene-conditioned candidate selection module. Auto-JEPA keeps the visual encoder frozen, requires no explicit perception annotations, and uses no learned trajectory generator. By optimizing only task-specific modules for trajectory representation, intent prediction, and candidate selection, Auto-JEPA achieves 91.3 PDMS on NAVSIM v1 and 89.1 EPDMS on NAVSIM v2. Semantic occlusion experiments show that masking dynamic-agent regions induces an average intent change 2.97× that of equal-area random masking. Moreover, occluding vehicles that affect future driving substantially changes the predicted intent and selected trajectory, whereas both remain essentially unchanged when non-influential vehicles are occluded. These results show that future-intent prediction encourages the model to focus on planning-relevant visual features and supports high-quality planning without dense future-world modeling.
