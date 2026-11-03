---
title: 语义 3DGS 与具身导航
tags: [topic]
seed_arxiv: "2503.18052"
paper_count: 132
updated: 2026-11-03
---

# 语义 3DGS 与具身导航

> [!info] 这份清单怎么来的
> 以 [SceneSplat](https://arxiv.org/abs/2503.18052)（arXiv 2503.18052）为起点，收集"给 3D 高斯泼溅加上语义，并服务于具身导航"的相关工作，共 132 篇，按与导航的远近分成七节。
> - 检索时间 2026-11-03，来源是 arXiv 搜索、Hugging Face 论文搜索、GitHub 上的 awesome 列表和网页搜索。Semantic Scholar 当天限流，没能按引用关系完整追溯，所以这不是穷尽列表。
> - 每篇都对照 arXiv 页面核对过标题和首版日期，"做了什么"一栏依据的摘要原句也都在摘要里找到了。
> - 发表信息只在 arXiv 备注、项目主页或官方代码仓库写明时才填，"—"表示只有预印本或没找到。
> - PDF 在 `topics/papers/语义3DGS与具身导航/`，文件名开头的"节号-序号"和表格顺序一致；下载的是 2026-11-03 时 arXiv 上的最新版本，只存在本地，不进 git。
> - 每节按首版日期排序。"做了什么"是 Claude 根据摘要写的一句话，读原文时请核对。

## 建议的阅读顺序

从表示方法读到导航系统，每步一两篇：

1. [LangSplat](https://arxiv.org/abs/2312.16084)：把 CLIP 语言特征放进高斯，后面很多语言高斯工作拿它做基线。
2. [Feature 3DGS](https://arxiv.org/abs/2312.03203)：把任意 2D 基础模型特征蒸馏进高斯的通用做法。
3. [SceneSplat](https://arxiv.org/abs/2503.18052)：种子论文：不再逐场景优化，直接在高斯上前馈预测语义。
4. [SceneSplat++](https://arxiv.org/abs/2506.08710)：同一团队的大规模数据集和基准，方便比较各类语言高斯。
5. [LEGS](https://arxiv.org/abs/2409.18108)：在移动机器人上边走边建房间尺度的语言高斯，用开放词汇查询定位物体。
6. [Online Language Splatting](https://arxiv.org/abs/2503.09447)：在线、实时地建语言高斯地图。
7. [GaussNav](https://arxiv.org/abs/2403.11625)：用同时记住几何和语义的高斯地图做实例图像目标导航，HM3D 上 SPL 从 0.347 提到 0.578。
8. [IGL-Nav](https://arxiv.org/abs/2508.00823)：图像目标导航中边探索边增量建高斯，并在高斯里定位目标图像（ICCV 2025）。
9. [GLMap](https://arxiv.org/abs/2605.01736)：每个语义单元同时存文字描述和 3D 高斯，可直接接大模型，用于零样本导航与推理（CVPR 2026）。
10. [GSMem](https://arxiv.org/abs/2603.19137)：把高斯当作零样本探索与推理的持久空间记忆，漏看的目标可以事后重新渲染查找。
11. [Habitat-GS](https://arxiv.org/abs/2604.12626)：在 Habitat-Sim 里接入高斯渲染和可驱动的高斯人体，面向导航的仿真器（ECCV 2026）。

| 节 | 篇数 |
|---|---|
| [[#一、语义高斯直接用于导航]] | 11 |
| [[#二、高斯地图导航（高斯不带语义）]] | 14 |
| [[#三、在高斯地图里做规划与安全]] | 11 |
| [[#四、高斯仿真、sim-to-real 与基准]] | 24 |
| [[#五、空间推理、问答与记忆]] | 8 |
| [[#六、在线语义高斯建图与 SLAM]] | 33 |
| [[#七、语义 3DGS 表示（种子论文所在方向）]] | 31 |

## 一、语义高斯直接用于导航

高斯上带语义、语言或实例信息，并且论文本身做的是导航、物体搜索或视觉语言导航任务。这是和种子论文最接近的交集。

| 日期 | 论文 | 发表 | 做了什么 | 链接 |
|---|---|---|---|---|
| 2024-03 | [**GaussNav**](https://arxiv.org/abs/2403.11625)<br>Gaussian Splatting for Visual Navigation | TPAMI | 面向实例图像目标导航，先探索建图再构建按语义标签聚类成实例的语义高斯，渲染候选物体视图与目标图像匹配后规划到达。 | [[topics/notes/语义3DGS与具身导航/1-01_GaussNav\|笔记]] · [[topics/papers/语义3DGS与具身导航/1-01_2403.11625_GaussNav.pdf\|PDF]] · [代码](https://github.com/XiaohanLei/GaussNav) · [主页](https://xiaohanlei.github.io/projects/GaussNav/) |
| 2024-11 | [**UnitedVLN**](https://arxiv.org/abs/2411.16053)<br>Generalizable Gaussian Splatting for Continuous Vision-Language Navigation | — | 提出可泛化3DGS预训练范式UnitedVLN，联合渲染360°高保真图像与语义特征来“想象”未来环境，提升连续环境VLN。 | [[topics/notes/语义3DGS与具身导航/1-02_UnitedVLN\|笔记]] · [[topics/papers/语义3DGS与具身导航/1-02_2411.16053_UnitedVLN.pdf\|PDF]] |
| 2025-02 | [**ATLAS Navigator**](https://arxiv.org/abs/2502.20386)<br>Active Task-driven LAnguage-embedded Gaussian Splatting | IEEE T-FR 2026 | 基于语言嵌入高斯泼溅的分层表示，兼顾稀疏语义规划与稠密几何避障，在未知室内外大场景中执行自然语言任务导航。 | [[topics/notes/语义3DGS与具身导航/1-03_ATLAS-Navigator\|笔记]] · [[topics/papers/语义3DGS与具身导航/1-03_2502.20386_ATLAS-Navigator.pdf\|PDF]] · [代码](https://github.com/grasp-lyrl/atlasnav) · [主页](https://ongdexter.github.io/atlasnav) |
| 2025-06 | [**Hierarchical Scoring with 3D Gaussian Splatting for Instance Image-Goal Navigation**](https://arxiv.org/abs/2506.07338) | — | 针对实例图像目标导航提出层次化评分：先用CLIP相关性场做跨层级语义评分锁定区域，再做局部几何评分精确估计视点。 | [[topics/notes/语义3DGS与具身导航/1-04_Hierarchical-Scoring-with-3D-Gaussian\|笔记]] · [[topics/papers/语义3DGS与具身导航/1-04_2506.07338_Hierarchical-Scoring-with-3D-Gaussian.pdf\|PDF]] |
| 2025-07 | [**VISTA**](https://arxiv.org/abs/2507.01125)<br>Open-Vocabulary, Task-Relevant Robot Exploration with Online Semantic Gaussian Splatting | — | 给定开放词汇搜索指令，机器人一边实时构建语义3DGS一边规划兼顾语义相关性与未知区域探索的轨迹来找目标。 | [[topics/notes/语义3DGS与具身导航/1-05_VISTA\|笔记]] · [[topics/papers/语义3DGS与具身导航/1-05_2507.01125_VISTA.pdf\|PDF]] |
| 2025-09 | [**SINGER**](https://arxiv.org/abs/2509.18610)<br>An Onboard Generalist Vision-Language Navigation Policy for Drones | — | 面向无人机的机载开放词汇语言导航策略：用语言嵌入的高斯泼溅飞行模拟器生成大规模数据，训练轻量端到端视觉运动策略并零样本迁移实机。 | [[topics/notes/语义3DGS与具身导航/1-06_SINGER\|笔记]] · [[topics/papers/语义3DGS与具身导航/1-06_2509.18610_SINGER.pdf\|PDF]] |
| 2025-10 | [**LagMemo**](https://arxiv.org/abs/2510.24118)<br>Language 3D Gaussian Splatting Memory for Multi-modal Open-vocabulary Multi-goal Visual Navigation | — | 一次探索构建语言3DGS记忆，查询记忆预测候选目标并局部验证，实现多模态开放词汇多目标导航。 | [[topics/notes/语义3DGS与具身导航/1-07_LagMemo\|笔记]] · [[topics/papers/语义3DGS与具身导航/1-07_2510.24118_LagMemo.pdf\|PDF]] · [代码](https://github.com/weekgoodday/LagMemo) · [主页](https://weekgoodday.github.io/lagmemo) |
| 2026-05 | [**GLMap**](https://arxiv.org/abs/2605.01736)<br>Multi-Scale Gaussian-Language Map for Zero-shot Embodied Navigation and Reasoning | CVPR 2026 | 提出多尺度高斯-语言地图GLMap，每个语义单元同时存自然语言描述与3D高斯，用解析估计器免梯度增量构建，零样本支持导航与问答。 | [[topics/notes/语义3DGS与具身导航/1-08_GLMap\|笔记]] · [[topics/papers/语义3DGS与具身导航/1-08_2605.01736_GLMap.pdf\|PDF]] · [代码](https://github.com/sx-zhang/GLMap) |
| 2026-05 | [**3D Gaussian Map with Open-Set Semantic Grouping for Vision-Language Navigation**](https://arxiv.org/abs/2605.26500) | — | 在线从伪激光点云初始化3D高斯构建自我中心场景地图，并通过开放集语义分组把高斯归入实例/背景类别，结合多层级动作预测做VLN。 | [[topics/notes/语义3DGS与具身导航/1-09_3D-Gaussian-Map-with-Open-Set-Semantic\|笔记]] · [[topics/papers/语义3DGS与具身导航/1-09_2605.26500_3D-Gaussian-Map-with-Open-Set-Semantic.pdf\|PDF]] · [代码](https://github.com/Gaozzzz/3D-Gaussian-Map-VLN) |
| 2026-05 | [**Uncertainty-Aware Gaussian Map for Vision-Language Navigation**](https://arxiv.org/abs/2605.26503) | — | 构建语义高斯地图并显式估计几何、语义和外观三类感知不确定性，扩展为3D价值地图来支持更可靠的VLN决策。 | [[topics/notes/语义3DGS与具身导航/1-10_Uncertainty-Aware-Gaussian-Map-for\|笔记]] · [[topics/papers/语义3DGS与具身导航/1-10_2605.26503_Uncertainty-Aware-Gaussian-Map-for.pdf\|PDF]] · [代码](https://github.com/Gaozzzz/Uncertainty-Aware-VLN) |
| 2026-10 | [**Training-Free Target-Aware Refinement of 3D Gaussian Language Map**](https://arxiv.org/abs/2610.21619) | — | 对已蒸馏的3D高斯语言地图做免训练的目标感知精修，以闭式系数把目标文本嵌入注入目标区域，提升语言目标定位且保留开放词汇查询。 | [[topics/notes/语义3DGS与具身导航/1-11_Training-Free-Target-Aware-Refinement-of\|笔记]] · [[topics/papers/语义3DGS与具身导航/1-11_2610.21619_Training-Free-Target-Aware-Refinement-of.pdf\|PDF]] · [代码](https://github.com/Lab-of-AI-and-Robotics/target-aware-langmap) · [主页](https://lab-of-ai-and-robotics.github.io/target-aware-langmap/) |

## 二、高斯地图导航（高斯不带语义）

用 3DGS 做图像目标导航、物体定位或视觉导航，但高斯本身不存语义。方法上常和第一节互相借鉴。

| 日期 | 论文 | 发表 | 做了什么 | 链接 |
|---|---|---|---|---|
| 2024-09 | [**BEINGS**](https://arxiv.org/abs/2409.10216)<br>Bayesian Embodied Image-goal Navigation with Gaussian Splatting | — | 把图像目标导航建模为MPC最优控制问题，以3DGS为场景先验预测未来观测，并用贝叶斯更新在线修正策略。 | [[topics/notes/语义3DGS与具身导航/2-01_BEINGS\|笔记]] · [[topics/papers/语义3DGS与具身导航/2-01_2409.10216_BEINGS.pdf\|PDF]] |
| 2025-02 | [**Openfly**](https://arxiv.org/abs/2502.18041)<br>A comprehensive platform for aerial vision-language navigation | ICLR 2026 | 空中VLN平台，集成UE、GTA V、Google Earth与3DGS等渲染引擎，提供10万条轨迹基准与OpenFly-Agent。 | [[topics/notes/语义3DGS与具身导航/2-02_Openfly\|笔记]] · [[topics/papers/语义3DGS与具身导航/2-02_2502.18041_Openfly.pdf\|PDF]] |
| 2025-03 | [**GSplatVNM**](https://arxiv.org/abs/2503.05152)<br>Point-of-View Synthesis for Visual Navigation Models Using Gaussian Splatting | — | 用3DGS合成中间视点补全稀疏图像库，为视觉导航模型提供连续的图像目标序列。 | [[topics/notes/语义3DGS与具身导航/2-03_GSplatVNM\|笔记]] · [[topics/papers/语义3DGS与具身导航/2-03_2503.05152_GSplatVNM.pdf\|PDF]] |
| 2025-06 | [**WoMAP**](https://arxiv.org/abs/2506.01600)<br>World Models For Embodied Open-Vocabulary Object Localization | — | 用GS重建的real-to-sim-to-real管线生成数据、检测器蒸馏奖励和潜空间世界模型，训练开放词汇主动物体定位策略。 | [[topics/notes/语义3DGS与具身导航/2-04_WoMAP\|笔记]] · [[topics/papers/语义3DGS与具身导航/2-04_2506.01600_WoMAP.pdf\|PDF]] · [主页](https://robot-womap.github.io) |
| 2025-06 | [**GRaD-Nav++**](https://arxiv.org/abs/2506.14009)<br>Vision-Language Model Enabled Visual Drone Navigation with Gaussian Radiance Fields and Differentiable Dynamics | IEEE RA-L 2026 | 轻量级机载无人机VLA框架，在3DGS逼真模拟器中用可微强化学习训练，执行自然语言指令飞行，并以MoE动作头提升泛化。 | [[topics/notes/语义3DGS与具身导航/2-05_GRaD-Nav++\|笔记]] · [[topics/papers/语义3DGS与具身导航/2-05_2506.14009_GRaD-Nav++.pdf\|PDF]] · [代码](https://github.com/Qianzhong-Chen/grad_nav) · [主页](https://qianzhong-chen.github.io/gradnavpp.github.io/) |
| 2025-08 | [**IGL-Nav**](https://arxiv.org/abs/2508.00823)<br>Incremental 3D Gaussian Localization for Image-goal Navigation | ICCV 2025 | 用前馈单目预测增量构建3DGS，先以离散空间匹配粗定位目标图像，近处再用可微渲染精解6-DoF目标位姿。 | [[topics/notes/语义3DGS与具身导航/2-06_IGL-Nav\|笔记]] · [[topics/papers/语义3DGS与具身导航/2-06_2508.00823_IGL-Nav.pdf\|PDF]] · [代码](https://github.com/GWxuan/IGL-Nav) · [主页](https://gwxuan.github.io/IGL-Nav/) |
| 2025-11 | [**SplatSearch**](https://arxiv.org/abs/2511.12972)<br>Instance Image Goal Navigation for Mobile Robots using 3D Gaussian Splatting and Diffusion Models | — | 在稀疏视角在线3DGS地图上围绕候选物体渲染多视图，并用多视图扩散模型补全缺失区域，再与目标图像匹配完成实例图像导航。 | [[topics/notes/语义3DGS与具身导航/2-07_SplatSearch\|笔记]] · [[topics/papers/语义3DGS与具身导航/2-07_2511.12972_SplatSearch.pdf\|PDF]] · [代码](https://github.com/Quest2GM/SplatSearch) · [主页](https://splat-search.github.io/) |
| 2025-12 | [**YOPO-Nav**](https://arxiv.org/abs/2512.09903)<br>Visual Navigation using 3DGS Graphs from One-Pass Videos | — | 把探索视频编码为互连的局部3DGS图，先VPR粗定位再用局部3DGS精化位姿，实现图像目标导航，并发布YOPO-Campus数据集。 | [[topics/notes/语义3DGS与具身导航/2-08_YOPO-Nav\|笔记]] · [[topics/papers/语义3DGS与具身导航/2-08_2512.09903_YOPO-Nav.pdf\|PDF]] |
| 2026-02 | [**3DGSNav**](https://arxiv.org/abs/2602.12159)<br>Enhancing Vision-Language Model Reasoning for Object Navigation via Active 3D Gaussian Splatting | — | 零样本物体导航框架：主动增量构建3DGS作为VLM的持久记忆，渲染前沿相关的第一人称视图并结合CoT提示与视角切换复核目标。 | [[topics/notes/语义3DGS与具身导航/2-09_3DGSNav\|笔记]] · [[topics/papers/语义3DGS与具身导航/2-09_2602.12159_3DGSNav.pdf\|PDF]] · [主页](https://aczheng-cai.github.io/3dgsnav.github.io/) |
| 2026-03 | [**HUGE-Bench**](https://arxiv.org/abs/2603.19822)<br>A Benchmark for High-Level UAV Vision-Language-Action Tasks | — | 高层UAV视觉-语言-动作任务基准，基于对齐的3DGS-网格数字孪生做碰撞感知评测。 | [[topics/notes/语义3DGS与具身导航/2-10_HUGE-Bench\|笔记]] · [[topics/papers/语义3DGS与具身导航/2-10_2603.19822_HUGE-Bench.pdf\|PDF]] |
| 2026-05 | [**POINav**](https://arxiv.org/abs/2605.28237)<br>Benchmarking and Enhancing Final-Meters Arrival in Real-World Vision-Language Navigation | — | 面向真实世界POI最后几米到达的VLN闭环基准，11个商业区由3DGS重建。 | [[topics/notes/语义3DGS与具身导航/2-11_POINav\|笔记]] · [[topics/papers/语义3DGS与具身导航/2-11_2605.28237_POINav.pdf\|PDF]] |
| 2026-06 | [**GN0**](https://arxiv.org/abs/2606.03682)<br>Toward a Unified Paradigm for Generation, Evaluation, and Policy Learning in Visual-Language Navigation | — | GN-Matrix数据+3DGS仿真平台+RL导航基础模型，统一VLN的数据生成、评测与策略学习。 | [[topics/notes/语义3DGS与具身导航/2-12_GN0\|笔记]] · [[topics/papers/语义3DGS与具身导航/2-12_2606.03682_GN0.pdf\|PDF]] |
| 2026-08 | [**HumanoidVLN**](https://arxiv.org/abs/2608.12860)<br>A Physics-Grounded Simulator and Benchmark for Vision-Language Navigation Across Diverse Humanoid Embodiments | — | 面向多种人形机器人的物理仿真VLN基准，环境部分来自3DGS重建。 | [[topics/notes/语义3DGS与具身导航/2-13_HumanoidVLN\|笔记]] · [[topics/papers/语义3DGS与具身导航/2-13_2608.12860_HumanoidVLN.pdf\|PDF]] · [主页](https://humanoid-vln.github.io/) |
| 2026-10 | [**GS-PRM**](https://arxiv.org/abs/2610.19541)<br>Gaussian Visual Roadmap for Image-Goal Navigation | — | 提出高斯视觉路标图GS-PRM，直接通过3DGS渲染构建路标点、局部连接和视觉参考，不需占据栅格或SDF，用于长程图像目标导航。 | [[topics/notes/语义3DGS与具身导航/2-14_GS-PRM\|笔记]] · [[topics/papers/语义3DGS与具身导航/2-14_2610.19541_GS-PRM.pdf\|PDF]] |

## 三、在高斯地图里做规划与安全

把高斯地图当成规划用的环境表示：避障、安全约束、可通行性、主动探索。

| 日期 | 论文 | 发表 | 语义 | 做了什么 | 链接 |
|---|---|---|---|---|---|
| 2024-03 | [**Splat-Nav**](https://arxiv.org/abs/2403.02751)<br>Safe Real-Time Robot Navigation in Gaussian Splatting Maps | — | ✓ | 在高斯泼溅地图中实时安全导航：基于高斯碰撞约束构建安全走廊生成平滑轨迹，并仅用RGB做位姿估计。 | [[topics/papers/语义3DGS与具身导航/3-01_2403.02751_Splat-Nav.pdf\|PDF]] · [代码](https://github.com/chengine/splatnav) · [主页](https://chengine.github.io/splatnav/) |
| 2024-09 | [**SAFER-Splat**](https://arxiv.org/abs/2409.09868)<br>A Control Barrier Function for Safe Navigation with Online Gaussian Splatting Maps | ICRA |  | 提出覆盖所有高斯基元的控制屏障函数安全滤波器，在在线构建GS地图的同时实时修正不安全动作。 | [[topics/papers/语义3DGS与具身导航/3-02_2409.09868_SAFER-Splat.pdf\|PDF]] · [代码](https://github.com/chengine/safer-splat) · [主页](https://chengine.github.io/safer-splat) |
| 2025-05 | [**Gaussian Splatting as a Unified Representation for Autonomy in Unstructured Environments**](https://arxiv.org/abs/2505.11794) | — | ✓ | 论证高斯泼溅可作为大规模非结构化户外环境自主导航的统一表示，并在地图中嵌入语义实现任务驱动导航，总结经验与挑战。 | [[topics/papers/语义3DGS与具身导航/3-03_2505.11794_Gaussian-Splatting-as-a-Unified.pdf\|PDF]] |
| 2025-11 | [**Splatblox**](https://arxiv.org/abs/2511.18525)<br>Traversability-Aware Gaussian Splatting for Outdoor Robot Navigation | — | ✓ | 融合语义分割图像与LiDAR点云的高斯泼溅构建可通行性感知ESDF，区分可穿越植被与刚性障碍，用于户外四足/轮式机器人导航。 | [[topics/papers/语义3DGS与具身导航/3-04_2511.18525_Splatblox.pdf\|PDF]] · [主页](https://splatblox.github.io) |
| 2026-05 | [**LiftNav**](https://arxiv.org/abs/2605.31376)<br>Path Planning via Semantic Lifting in TSDF-Guided Gaussian Splatting | — | ✓ | 在TSDF+GS双地图上把2D检测结果提升到3D并做B样条轨迹优化，实现无需稠密嵌入的物体级语义导航。 | [[topics/papers/语义3DGS与具身导航/3-05_2605.31376_LiftNav.pdf\|PDF]] |
| 2026-06 | [**PolyMerge**](https://arxiv.org/abs/2606.16232)<br>Compressing 3D Gaussian Splats with Polytope Coverings for Provably Safe Resource-Constrained Navigation | IEEE RA-L 2026 |  | 把大规模3DGS压缩为可证明外包所有障碍的凸多面体集合，结合CBF在算力受限无人机上安全规划。 | [[topics/papers/语义3DGS与具身导航/3-06_2606.16232_PolyMerge.pdf\|PDF]] · [主页](https://athlon76.github.io/PolyMerge-website/) |
| 2026-09 | [**SemSafe-3DGS**](https://arxiv.org/abs/2609.19330)<br>Semantic Risk-Aware Active Navigation in Uncertain 3D Gaussian Splatting Maps | IROS 2026 SeMaNa Workshop | ✓ | 在带语义属性的不确定3D高斯地图中，用类别风险加权的CBF避障，并结合主动感知降低地图不确定性。 | [[topics/papers/语义3DGS与具身导航/3-07_2609.19330_SemSafe-3DGS.pdf\|PDF]] |
| 2026-09 | [**AirSplan**](https://arxiv.org/abs/2609.21226)<br>Risk-Aware Motion Planning for Quadrotors in Cluttered 3D Gaussian Splats | IROS 2026 |  | 用归一化3DGS表示高保真几何，并基于四旋翼微分平坦性做可达性运动规划，计算连续时间碰撞约束。 | [[topics/papers/语义3DGS与具身导航/3-08_2609.21226_AirSplan.pdf\|PDF]] |
| 2026-09 | [**Splat-CBF**](https://arxiv.org/abs/2609.23100)<br>Safe Next-Best-View Control in 3D Gaussian-Splat Maps | — |  | 在高斯泼溅地图中用风险感知CBF保证安全，同时以Fisher信息引导下一最佳视角的主动感知。 | [[topics/papers/语义3DGS与具身导航/3-09_2609.23100_Splat-CBF.pdf\|PDF]] |
| 2026-09 | [**CollisionSplatting**](https://arxiv.org/abs/2609.35619)<br>Collision-Aware Motion Planning in 3DGS Scenes with Image-Conditioned Objectives and Adjustable Conservatism | — |  | 提出直接作用于标准3DGS的可调保守度碰撞距离度量，结合图像条件奖励用于MPPI/RRT规划。 | [[topics/papers/语义3DGS与具身导航/3-10_2609.35619_CollisionSplatting.pdf\|PDF]] |
| 2026-10 | [**2DGS-Planner**](https://arxiv.org/abs/2610.11752)<br>Rasterization-based Path Planning in 2D Gaussian Splatting Map | — |  | 通过光栅化从2DGS地图读取规划相关几何，构建路标图并估计间隙，用于地面机器人路径规划。 | [[topics/papers/语义3DGS与具身导航/3-11_2610.11752_2DGS-Planner.pdf\|PDF]] · [主页](https://2dgs-planner.github.io/) |

## 四、高斯仿真、sim-to-real 与基准

用 3DGS 重建真实场景，作为训练或评测导航策略的仿真环境。

| 日期 | 论文 | 发表 | 语义 | 做了什么 | 链接 |
|---|---|---|---|---|---|
| 2024-06 | [**Gaussian Splatting to Real World Flight Navigation Transfer with Liquid Networks**](https://arxiv.org/abs/2406.15149) | — |  | 集成高斯泼溅与四旋翼动力学的模拟器中用液态神经网络模仿学习，实现飞行导航sim-to-real。 | [[topics/papers/语义3DGS与具身导航/4-01_2406.15149_Gaussian-Splatting-to-Real-World-Flight.pdf\|PDF]] |
| 2024-12 | [**SOUS VIDE**](https://arxiv.org/abs/2412.16346)<br>Cooking Visual Drone Navigation Policies in a Gaussian Splatting Vacuum | — |  | 构建结合简单无人机动力学与高斯泼溅重建的模拟器FiGS，蒸馏特权MPC专家为端到端视觉运动策略SV-Net，零样本迁移实机。 | [[topics/papers/语义3DGS与具身导航/4-02_2412.16346_SOUS-VIDE.pdf\|PDF]] · [代码](https://github.com/StanfordMSL/SousVide) · [主页](https://stanfordmsl.github.io/SousVide/) |
| 2025-01 | [**Vid2Sim**](https://arxiv.org/abs/2501.06693)<br>Realistic and Interactive Simulation from Video for Urban Navigation | CVPR 2025 |  | 从单目视频重建逼真且可物理交互的城市数字孪生（GS+网格混合表示），用于强化学习训练城市视觉导航智能体。 | [[topics/papers/语义3DGS与具身导航/4-03_2501.06693_Vid2Sim.pdf\|PDF]] · [代码](https://github.com/Vid2Sim/Vid2Sim) · [主页](https://metadriverse.github.io/vid2sim/) |
| 2025-02 | [**VR-Robo**](https://arxiv.org/abs/2502.01536)<br>A Real-to-Sim-to-Real Framework for Visual Robot Navigation and Locomotion | RA-L 2025 |  | 用3DGS重建逼真且可物理交互的数字孪生，训练足式机器人仅用RGB的视觉导航与运动策略并迁移实机。 | [[topics/papers/语义3DGS与具身导航/4-04_2502.01536_VR-Robo.pdf\|PDF]] · [代码](https://github.com/zst1406217/VR-Robo) · [主页](https://vr-robo.github.io/) |
| 2025-03 | [**GRaD-Nav**](https://arxiv.org/abs/2503.03984)<br>Efficiently Learning Visual Drone Navigation with Gaussian Radiance Fields and Differentiable Dynamics | — |  | 将3DGS与可微深度强化学习结合训练无人机视觉导航策略，零样本迁移实机。 | [[topics/papers/语义3DGS与具身导航/4-05_2503.03984_GRaD-Nav.pdf\|PDF]] · [代码](https://github.com/Qianzhong-Chen/grad_nav) |
| 2025-07 | [**S2E**](https://arxiv.org/abs/2507.22028)<br>From Seeing to Experiencing: Scaling Navigation Foundation Models with Reinforcement Learning | — |  | 先用离线视频预训练导航基础模型再在仿真中强化学习后训练，并建立基于3DGS真实场景的评测基准NavBench-GS。 | [[topics/papers/语义3DGS与具身导航/4-06_2507.22028_S2E.pdf\|PDF]] · [主页](https://vail-ucla.github.io/S2E) |
| 2025-09 | [**EmbodiedSplat**](https://arxiv.org/abs/2509.17430)<br>Personalized Real-to-Sim-to-Real Navigation with Gaussian Splats from a Mobile Device | ICCV 2025 |  | 用手机采集部署场景并经GS重建接入Habitat-Sim，对图像导航策略做个性化微调，显著提升真实世界成功率。 | [[topics/papers/语义3DGS与具身导航/4-07_2509.17430_EmbodiedSplat.pdf\|PDF]] · [代码](https://github.com/gchhablani/embodied-splat-v1) · [主页](https://gchhablani.github.io/embodied-splat) |
| 2025-10 | [**FalconGym 2.0**](https://arxiv.org/abs/2510.02248)<br>Performance-Guided Refinement for Visual Aerial Navigation using Editable Gaussian Splatting in FalconGym 2.0 | — |  | 基于GSplat且可编辑赛道的空中导航仿真FalconGym 2.0，配合性能引导精修训练视觉策略。 | [[topics/papers/语义3DGS与具身导航/4-08_2510.02248_FalconGym-2.0.pdf\|PDF]] |
| 2025-10 | [**GaussGym**](https://arxiv.org/abs/2510.15352)<br>An open-source real-to-sim framework for learning locomotion from pixels | — |  | 把3DGS作为即插即用渲染器接入IsaacGym等向量化物理仿真，实现10万步/秒的逼真仿真，从像素学习足式运动与导航。 | [[topics/papers/语义3DGS与具身导航/4-09_2510.15352_GaussGym.pdf\|PDF]] · [代码](https://github.com/escontra/gauss_gym) · [主页](https://escontrela.me/gauss_gym/) |
| 2025-10 | [**Towards Physically Executable 3D Gaussian for Embodied Navigation**](https://arxiv.org/abs/2510.21307) | — | ✓ | 为3DGS补充物体级语义标注与碰撞物理接口，发布InteriorGS数据集和首个基于3DGS的VLN基准SAGE-Bench。 | [[topics/papers/语义3DGS与具身导航/4-10_2510.21307_Towards-Physically-Executable-3D.pdf\|PDF]] · [代码](https://github.com/Galery23/SAGE-3D_Official) · [主页](https://sage-3d.github.io/) |
| 2025-10 | [**NVSim**](https://arxiv.org/abs/2510.24335)<br>Novel View Synthesis Simulator for Large Scale Indoor Navigation | — |  | 从普通图像序列自动构建大规模室内导航仿真，提出地面感知高斯泼溅与免网格可通行性检查。 | [[topics/papers/语义3DGS与具身导航/4-11_2510.24335_NVSim.pdf\|PDF]] |
| 2025-11 | [**RoboTidy**](https://arxiv.org/abs/2511.14161)<br>A 3D Gaussian Splatting Household Tidying Benchmark for Embodied Navigation and Action | — |  | 500个带碰撞的3DGS家居场景的整理任务基准，支持VLA与VLN训练评测。 | [[topics/papers/语义3DGS与具身导航/4-12_2511.14161_RoboTidy.pdf\|PDF]] |
| 2025-11 | [**Wanderland**](https://arxiv.org/abs/2511.20620)<br>Geometrically Grounded Simulation for Open-World Embodied AI | CVPR 2026 |  | 多传感器采集的real-to-sim框架，构建几何可靠的城市室内外场景，用于可复现的具身导航闭环评测。 | [[topics/papers/语义3DGS与具身导航/4-13_2511.20620_Wanderland.pdf\|PDF]] · [主页](https://ai4ce.github.io/wanderland/) |
| 2025-12 | [**Flying in Clutter on Monocular RGB by Learning in 3D Radiance Fields with Domain Adaptation**](https://arxiv.org/abs/2512.17349) | — |  | 在3DGS环境中结合对抗域适应训练单目RGB无人机避障飞行策略并零样本迁移。 | [[topics/papers/语义3DGS与具身导航/4-14_2512.17349_Flying-in-Clutter-on-Monocular-RGB-by.pdf\|PDF]] |
| 2026-02 | [**Zero-Shot UAV Navigation in Forests via Relightable 3D Gaussian Splatting**](https://arxiv.org/abs/2602.07101) | — |  | 提出可重光照3DGS做光照增广，训练端到端RL策略实现森林中无人机零样本导航。 | [[topics/papers/语义3DGS与具身导航/4-15_2602.07101_Zero-Shot-UAV-Navigation-in-Forests-via.pdf\|PDF]] |
| 2026-02 | [**ReaDy-Go**](https://arxiv.org/abs/2602.11575)<br>Real-to-Sim Dynamic 3D Gaussian Splatting Simulation for Environment-Specific Visual Navigation with Moving Obstacles | IEEE RA-L |  | 在静态GS重建场景中插入可动画的高斯人体化身合成动态场景，生成导航数据并训练对移动障碍与sim-to-real鲁棒的视觉导航策略。 | [[topics/papers/语义3DGS与具身导航/4-16_2602.11575_ReaDy-Go.pdf\|PDF]] · [代码](https://github.com/syeon-yoo/ready-go) · [主页](https://syeon-yoo.github.io/ready-go-site/) |
| 2026-03 | [**NavGSim**](https://arxiv.org/abs/2603.15186)<br>High-Fidelity Gaussian Splatting Simulator for Large-Scale Navigation | — |  | 基于分层3DGS的大规模高保真导航模拟器，用高斯切片技术直接提取可通行区域做碰撞，并提供训练评测API，用于训练导航VLA。 | [[topics/papers/语义3DGS与具身导航/4-17_2603.15186_NavGSim.pdf\|PDF]] · [代码](https://github.com/2003jiahang/NavGSim) |
| 2026-04 | [**GaussFly**](https://arxiv.org/abs/2604.05062)<br>Contrastive Reinforcement Learning for Visuomotor Policies in 3D Gaussian Fields | — |  | 在几何约束3DGS重建场景中做对比表征学习，再训练空中视觉运动策略，零样本迁移实机。 | [[topics/papers/语义3DGS与具身导航/4-18_2604.05062_GaussFly.pdf\|PDF]] |
| 2026-04 | [**Habitat-GS**](https://arxiv.org/abs/2604.12626)<br>A High-Fidelity Navigation Simulator with Dynamic Gaussian Splatting | ECCV 2026 |  | 在Habitat-Sim中集成3DGS场景渲染与可驱动高斯人体化身，保持Habitat生态兼容，支持人感知导航训练。 | [[topics/papers/语义3DGS与具身导航/4-19_2604.12626_Habitat-GS.pdf\|PDF]] · [代码](https://github.com/zju3dv/habitat-gs) · [主页](https://zju3dv.github.io/habitat-gs/) |
| 2026-04 | [**GS-Playground**](https://arxiv.org/abs/2604.25459)<br>A High-Throughput Photorealistic Simulator for Vision-Informed Robot Learning | RSS 2026 |  | 并行物理引擎+批量3DGS渲染的高吞吐仿真框架，覆盖运动、导航与操作。 | [[topics/papers/语义3DGS与具身导航/4-20_2604.25459_GS-Playground.pdf\|PDF]] · [主页](https://gsplayground.github.io) |
| 2026-06 | [**QuadVerse**](https://arxiv.org/abs/2606.07118)<br>An Integrated Framework Aligning Visual-Physical Reality for Quadruped Simulation | — |  | 用重建3DGS场景对齐视觉、接触与执行器动力学的四足仿真框架，零样本部署视觉导航策略。 | [[topics/papers/语义3DGS与具身导航/4-21_2606.07118_QuadVerse.pdf\|PDF]] |
| 2026-07 | [**SONG**](https://arxiv.org/abs/2607.25219)<br>A Photorealistic 3D Gaussian Simulation Platform for Benchmarking Social Navigation | — |  | 基于3DGS场景与高斯人体的社交导航仿真平台与SONG-Bench评测。 | [[topics/papers/语义3DGS与具身导航/4-22_2607.25219_SONG.pdf\|PDF]] |
| 2026-09 | [**NavArena**](https://arxiv.org/abs/2609.04602)<br>Automated Construction of Goal-Oriented Navigation Benchmarks from 3D Gaussian Splatting Reconstructions | — | ✓ | 自动把固定3DGS重建转为目标导向导航基准：渲染RGB-D、由高斯密度与高度统计生成占据代价图，并从开放词汇掩码提升语义目标候选。 | [[topics/papers/语义3DGS与具身导航/4-23_2609.04602_NavArena.pdf\|PDF]] |
| 2026-10 | [**AirPlayground**](https://arxiv.org/abs/2610.29699)<br>Benchmarking Aerial Navigation across Diverse Reconstructed Environments | — |  | 构建94个带对齐碰撞几何的3DGS室内/城市/植被环境与94K条专家飞行示范，提供统一的空中导航策略训练与闭环评测基准。 | [[topics/papers/语义3DGS与具身导航/4-24_2610.29699_AirPlayground.pdf\|PDF]] |

## 五、空间推理、问答与记忆

把高斯当作智能体的三维记忆，回答空间问题或支持长期推理。

| 日期 | 论文 | 发表 | 语义 | 做了什么 | 链接 |
|---|---|---|---|---|---|
| 2025-03 | [**SplatTalk**](https://arxiv.org/abs/2503.06271)<br>3D VQA with Gaussian Splatting | ICCV 2025 | ✓ | 用可泛化3DGS框架从仅有位姿的多视图图像生成可直接输入预训练LLM的3D token，实现零样本3D视觉问答。 | [[topics/papers/语义3DGS与具身导航/5-01_2503.06271_SplatTalk.pdf\|PDF]] · [代码](https://github.com/ngailapdi/SplatTalk) · [主页](https://splat-talk.github.io/) |
| 2025-03 | [**M3**](https://arxiv.org/abs/2503.16413)<br>3D-Spatial MultiModal Memory | ICLR 2025 | ✓ | 结合3DGS与基础模型的3D空间多模态记忆，可渲染多粒度特征，并部署于四足机器人。 | [[topics/papers/语义3DGS与具身导航/5-02_2503.16413_M3.pdf\|PDF]] · [代码](https://github.com/MaureenZOU/m3-spatial) · [主页](https://m3-spatial-memory.github.io) |
| 2025-07 | [**GaussianVLM**](https://arxiv.org/abs/2507.00886)<br>Scene-centric 3D Vision-Language Models using Language-aligned Gaussian Splats for Embodied Reasoning and Beyond | — | ✓ | 首个基于高斯泼溅的场景级3D VLM：为每个高斯关联语言特征，并用双路稀疏器蒸馏为任务相关token，用于具身推理等任务。 | [[topics/papers/语义3DGS与具身导航/5-03_2507.00886_GaussianVLM.pdf\|PDF]] · [主页](https://insait-institute.github.io/gaussianvlm.github.io/) |
| 2026-01 | [**SplatReasoner**](https://arxiv.org/abs/2601.13132)<br>Enhancing Embodied Reasoning and Grounding by Novel View Synthesis | ECCV 2026 |  | 在VLM推理中引入3DGS新视角合成，按查询生成揭示证据的视点以提升具身推理与3D定位。 | [[topics/papers/语义3DGS与具身导航/5-04_2601.13132_SplatReasoner.pdf\|PDF]] · [主页](https://splatreasoner.github.io/) |
| 2026-03 | [**GSMem**](https://arxiv.org/abs/2603.19137)<br>3D Gaussian Splatting as Persistent Spatial Memory for Zero-Shot Embodied Exploration and Reasoning | — | ✓ | 以3DGS作为持久空间记忆，结合物体级场景图与语言场检索目标区域，渲染最优新视角供VLM推理，用于零样本探索、EQA与终身导航。 | [[topics/papers/语义3DGS与具身导航/5-05_2603.19137_GSMem.pdf\|PDF]] · [代码](https://github.com/vulab-AI/GSMem) · [主页](https://vulab-ai.github.io/GSMem/) |
| 2026-04 | [**E3VS-Bench**](https://arxiv.org/abs/2604.17969)<br>A Benchmark for Viewpoint-Dependent Active Perception in 3D Gaussian Splatting Scenes | ECCV 2026 |  | 提出具身3D视觉搜索基准：在99个3DGS重建场景中，智能体需5-DoF主动控制视点收集视角相关证据回答问题。 | [[topics/papers/语义3DGS与具身导航/5-06_2604.17969_E3VS-Bench.pdf\|PDF]] · [代码](https://github.com/K0uya/E3VS-BENCH) · [主页](https://k0uya.github.io/e3vs-proj/) |
| 2026-10 | [**Rendering-Free Lookahead for Question-Guided Active Vision**](https://arxiv.org/abs/2610.11039) | — |  | 训练时在3DGS场景中渲染候选未来视图计算可答性，蒸馏出免渲染的视角选择策略用于主动问答。 | [[topics/papers/语义3DGS与具身导航/5-07_2610.11039_Rendering-Free-Lookahead-for.pdf\|PDF]] · [主页](https://k0uya.github.io/rfl-proj/) |
| 2026-10 | [**GEMS**](https://arxiv.org/abs/2610.33158)<br>Gaussian Episodic Memory for Long-Term Spatiotemporal Reasoning | — |  | 持久时空3DGS地图+智能体推理管线，按需渲染回答半静态环境中的时空问题，并发布GEMS-Bench。 | [[topics/papers/语义3DGS与具身导航/5-08_2610.33158_GEMS.pdf\|PDF]] · [主页](https://abwerby.github.io/GEMS/) |

## 六、在线语义高斯建图与 SLAM

机器人边走边建带语义的高斯地图，是导航系统的地图前端。

| 日期 | 论文 | 发表 | 做了什么 | 和导航的关系 | 链接 |
|---|---|---|---|---|---|
| 2024-02 | [**SGS-SLAM**](https://arxiv.org/abs/2402.03246)<br>Semantic Gaussian Splatting For Neural Dense SLAM | ECCV 2024 | 首个基于3DGS的语义视觉SLAM，多通道联合优化外观、几何与语义，并用语义引导关键帧选择抑制累积误差。 | 从RGB-D流在线构建带语义的高斯地图，是室内导航机器人语义建图的基线方法。 | [[topics/papers/语义3DGS与具身导航/6-01_2402.03246_SGS-SLAM.pdf\|PDF]] · [代码](https://github.com/ShuhongLL/SGS-SLAM) |
| 2024-03 | [**SemGauss-SLAM**](https://arxiv.org/abs/2403.07494)<br>Dense Semantic Gaussian Splatting SLAM | IROS 2025 | 将语义特征嵌入3D高斯，提出特征级损失与语义引导的光束法平差，联合优化相机位姿与语义高斯地图。 | 低漂移跟踪加稠密语义建图，可为移动机器人提供精确的室内语义地图。 | [[topics/papers/语义3DGS与具身导航/6-02_2403.07494_SemGauss-SLAM.pdf\|PDF]] · [代码](https://github.com/IRMVLab/SemGauss-SLAM) |
| 2024-03 | [**NEDS-SLAM**](https://arxiv.org/abs/2403.11679)<br>A Neural Explicit Dense Semantic SLAM Framework using 3D Gaussian Splatting | RA-L | 用空间一致特征融合降低分割头误差，轻量编解码器压缩高维语义特征，并以虚拟视角剪枝去除离群高斯。 | 实时语义高斯建图且内存占用低，适合算力受限的移动机器人在线使用。 | [[topics/papers/语义3DGS与具身导航/6-03_2403.11679_NEDS-SLAM.pdf\|PDF]] |
| 2024-09 | [**Hier-SLAM**](https://arxiv.org/abs/2409.12518)<br>Scaling-up Semantics in SLAM with a Hierarchically Categorical Gaussian Splatting | ICRA 2025 | 借助LLM构建层级类别树，把语义紧凑编码进3DGS，可扩展到500多个类别并显著降低存储与训练时间。 | 层级语义压缩让类别繁多的真实复杂场景也能在线建语义地图，利于机器人长期部署。 | [[topics/papers/语义3DGS与具身导航/6-04_2409.12518_Hier-SLAM.pdf\|PDF]] · [代码](https://github.com/LeeBY68/Hier-SLAM) |
| 2024-09 | [**LEGS**](https://arxiv.org/abs/2409.18108)<br>Language-Embedded Gaussian Splats (LEGS): Incrementally Building Room-Scale Representations with a Mobile Robot | IROS 2024 | 移动机器人行进中在线训练语言嵌入高斯，实现房间尺度开放词汇物体查询，训练速度比LERF快3.5倍以上。 | 在真实移动机器人上增量建语言地图，用于办公室、仓库等场景的物体搜索。 | [[topics/papers/语义3DGS与具身导航/6-05_2409.18108_LEGS.pdf\|PDF]] · [代码](https://github.com/uynitsuj/LEGS) |
| 2024-11 | [**Open-Vocabulary Online Semantic Mapping for SLAM**](https://arxiv.org/abs/2411.15043) | RA-L | 在线检测并跟踪3D片段，用神经网络融合多视角CLIP描述子，可接入Gaussian-SLAM实现带回环的开放词汇建图。 | 计算与内存开销低的在线开放词汇3D地图，可直接支撑机器人的语言物体查询。 | [[topics/papers/语义3DGS与具身导航/6-06_2411.15043_Open-Vocabulary-Online-Semantic-Mapping.pdf\|PDF]] · [代码](https://github.com/tberriel/OVO) |
| 2024-12 | [**EmbodiedOcc**](https://arxiv.org/abs/2412.04380)<br>Embodied 3D Occupancy Prediction for Vision-based Online Scene Understanding | ICCV 2025 | 提出具身3D占据预测任务，以全局3D语义高斯为记忆，随探索逐步更新局部区域，再经高斯到体素渲染得到全局占据。 | 与智能体渐进探索一致的在线语义占据地图，可直接作为具身导航的环境表示。 | [[topics/papers/语义3DGS与具身导航/6-07_2412.04380_EmbodiedOcc.pdf\|PDF]] · [代码](https://github.com/YkiWu/EmbodiedOcc) |
| 2024-12 | [**PanoSLAM**](https://arxiv.org/abs/2501.00352)<br>Panoptic 3D Scene Reconstruction via Gaussian SLAM | — | 首个在统一高斯SLAM框架内同时完成几何重建、3D语义与实例分割的系统，用在线时空提升模块把2D全景预测转入3D。 | 从RGB-D视频在线得到实例级全景地图，便于机器人做物体级查询与目标导航。 | [[topics/papers/语义3DGS与具身导航/6-08_2501.00352_PanoSLAM.pdf\|PDF]] · [代码](https://github.com/runnanchen/PanoSLAM) |
| 2025-01 | [**HAMMER**](https://arxiv.org/abs/2501.14147)<br>Heterogeneous, Multi-Robot Semantic Gaussian Splatting | RA-L 2025 | 基于ROS的服务器端多机器人协同高斯建图，无需初始相对位姿即可对齐异构机器人数据流，在线训练蒸馏CLIP的语义3DGS。 | 多机器人共建开放词汇地图，并用于语义目标导航（如“go to the couch”）。 | [[topics/papers/语义3DGS与具身导航/6-09_2501.14147_HAMMER.pdf\|PDF]] · [主页](http://hammer-project.github.io) |
| 2025-02 | [**Hier-SLAM++**](https://arxiv.org/abs/2502.14931)<br>Neuro-Symbolic Semantic SLAM with a Hierarchically Categorical Gaussian Splatting | — | 神经符号式层级类别3DGS SLAM，结合LLM与3D生成模型，同时支持RGB-D与单目输入，号称首个语义单目高斯SLAM。 | 仅需单目相机即可构建语义高斯地图，降低导航机器人的传感器门槛。 | [[topics/papers/语义3DGS与具身导航/6-10_2502.14931_Hier-SLAM++.pdf\|PDF]] · [主页](https://hierslampp.github.io/) |
| 2025-02 | [**DynamicGSG**](https://arxiv.org/abs/2502.15309)<br>Dynamic 3D Gaussian Scene Graphs for Environment Adaptation | IROS 2025 | 基于高斯的动态开放词汇层级场景图，用VLM建模物体关系、联合特征损失监督实例分组，并按环境变化局部更新。 | 作为长期任务机器人的可更新环境记忆，支持语言引导的物体检索。 | [[topics/papers/语义3DGS与具身导航/6-11_2502.15309_DynamicGSG.pdf\|PDF]] · [代码](https://github.com/GeLuzhou/Dynamic-GSG) |
| 2025-03 | [**OpenGS-SLAM**](https://arxiv.org/abs/2503.01646)<br>Open-Set Dense Semantic SLAM with 3D Gaussian Splatting for Object-Level Scene Understanding | ICRA 2025 | 把2D基础模型给出的显式开放集标签融入3D高斯，提出高斯投票渲染与置信度标签共识，实现物体级场景理解。 | 开放集物体级语义地图且语义渲染快10倍，便于机器人按物体定位与交互。 | [[topics/papers/语义3DGS与具身导航/6-12_2503.01646_OpenGS-SLAM.pdf\|PDF]] · [代码](https://github.com/YOUNG-bit/open_semantic_slam) · [主页](https://young-bit.github.io/opengs-github.github.io/) |
| 2025-03 | [**Online Language Splatting**](https://arxiv.org/abs/2503.09447) | ICCV 2025 | 首个在3DGS-SLAM中在线、近实时完成开放词汇语言建图的框架，含高分辨率CLIP模块与两阶段在线自编码器。 | 无需离线预处理即可边走边建语言地图，支持智能体用自然语言与环境交互。 | [[topics/papers/语义3DGS与具身导航/6-13_2503.09447_Online-Language-Splatting.pdf\|PDF]] · [代码](https://github.com/rpng/online_lang_splatting) · [主页](https://saimouli.github.io/onlineLang/) |
| 2025-03 | [**GS-LTS**](https://arxiv.org/abs/2503.17733)<br>3D Gaussian Splatting-Based Adaptive Modeling for Long-Term Service Robots | — | 面向长期服务机器人的3DGS系统，检测场景变化并以高斯编辑高效更新，含导航评估。 | 可持续更新的3DGS支撑长期导航等任务。 | [[topics/papers/语义3DGS与具身导航/6-14_2503.17733_GS-LTS.pdf\|PDF]] · [主页](https://vipl-vsu.github.io/3DGS-LTS)（2026-11-03 打不开） |
| 2025-06 | [**LEG-SLAM**](https://arxiv.org/abs/2506.03073)<br>Real-Time Language-Enhanced Gaussian Splatting for SLAM | — | 把优化的高斯渲染与DINOv2视觉-语言特征及PCA特征压缩器结合，实现实时在线的语言增强稠密SLAM。 | 实时生成语义标注地图，无需预先给定位姿或静态语义图，面向自主机器人应用。 | [[topics/papers/语义3DGS与具身导航/6-15_2506.03073_LEG-SLAM.pdf\|PDF]] · [代码](https://github.com/Titrom025/LEG-SLAM) · [主页](https://titrom025.github.io/LEG-SLAM/) |
| 2025-06 | [**GS4**](https://arxiv.org/abs/2506.06517)<br>Generalizable Sparse Splatting Semantic SLAM | — | 首个可泛化的高斯语义SLAM，用前馈网络逐帧预测稀疏高斯并增量合并，速度快10倍、高斯数少10倍。 | 免逐场景优化且可零样本迁移，适合机器人进入新环境时快速建语义地图。 | [[topics/papers/语义3DGS与具身导航/6-16_2506.06517_GS4.pdf\|PDF]] · [主页](https://mingqij.github.io/projects/gs4/) |
| 2025-08 | [**OpenGS-Fusion**](https://arxiv.org/abs/2508.01150)<br>Open-Vocabulary Dense Mapping with Hybrid 3D Gaussian Splatting for Refined Object-Level Understanding | IROS 2025 | 3D高斯与TSDF混合表示实现语义特征在线无损融合，并用MLLM辅助的自适应阈值细化3D物体分割。 | 在线开放词汇稠密建图并支持语言引导的场景交互，可服务机器人物体级查询。 | [[topics/papers/语义3DGS与具身导航/6-17_2508.01150_OpenGS-Fusion.pdf\|PDF]] · [代码](https://github.com/YOUNG-bit/OpenGS-Fusion) · [主页](https://young-bit.github.io/opengs-fusion.github.io/) |
| 2025-09 | [**OmniMap**](https://arxiv.org/abs/2509.07500)<br>A General Mapping Framework Integrating Optics, Geometry, and Semantics | T-RO | 首个同时捕获光学、几何与开放词汇语义的实时在线建图框架，采用3DGS-体素紧耦合混合表示与概率实例融合。 | 下游应用包括地图辅助导航与感知引导操作，直接面向机器人部署。 | [[topics/papers/语义3DGS与具身导航/6-18_2509.07500_OmniMap.pdf\|PDF]] · [代码](https://github.com/BIT-DYN/omnimap) · [主页](https://omni-map.github.io/) |
| 2025-11 | [**LEGO-SLAM**](https://arxiv.org/abs/2511.16144)<br>Language-Embedded Gaussian Optimization SLAM | — | 用场景自适应自编码器把语言特征压到16维并在线适应新场景，加入语言引导剪枝和语言回环检测，约15FPS。 | 为机器人交互提供实时开放词汇地图，语言回环提升长轨迹建图一致性。 | [[topics/papers/语义3DGS与具身导航/6-19_2511.16144_LEGO-SLAM.pdf\|PDF]] · [代码](https://github.com/Lab-of-AI-and-Robotics/LEGO-SLAM) · [主页](https://lab-of-ai-and-robotics.github.io/LEGO-SLAM/) |
| 2025-12 | [**OpenMonoGS-SLAM**](https://arxiv.org/abs/2512.08625)<br>Monocular Gaussian Splatting SLAM with Open-set Semantics | — | 首个单目开放集语义3DGS SLAM，结合MASt3R几何与SAM/CLIP语义，并设计管理高维语义特征的记忆机制。 | 不依赖深度传感器即可构建开放集语义高斯地图，降低机器人硬件要求。 | [[topics/papers/语义3DGS与具身导航/6-20_2512.08625_OpenMonoGS-SLAM.pdf\|PDF]] · [主页](https://jisang1528.github.io/OpenMonoGS-SLAM/) |
| 2026-01 | [**LangGS-SLAM**](https://arxiv.org/abs/2602.06991)<br>Real-Time Language-Feature Gaussian Splatting SLAM | — | 提出Top-K渲染高效渲染高维特征、多准则地图管理与混合场优化，在15FPS下在线重建未压缩的语言对齐特征场。 | 说明在线SLAM可直接维护稠密语言特征，便于机器人基于地图做语言推理。 | [[topics/papers/语义3DGS与具身导航/6-21_2602.06991_LangGS-SLAM.pdf\|PDF]] |
| 2026-02 | [**LatentAM**](https://arxiv.org/abs/2602.12314)<br>Real-Time, Large-Scale Latent Gaussian Attention Mapping via Online Dictionary Learning | RA-L | 每个高斯存紧凑查询向量，经注意力与在线学习的字典还原VLM嵌入，模型无关；体素哈希分局部/全局地图以扩展到大场景。 | 以有界显存支撑长轨迹、大范围环境的开放词汇机器人感知地图。 | [[topics/papers/语义3DGS与具身导航/6-22_2602.12314_LatentAM.pdf\|PDF]] · [代码](https://github.com/UMich-SSI-Lab/latentam) · [主页](https://junwoonlee.github.io/projects/LatentAM/) |
| 2026-03 | [**EmbodiedSplat**](https://arxiv.org/abs/2603.04254)<br>Online Feed-Forward Semantic 3DGS for Open-Vocabulary 3D Scene Understanding | CVPR 2026 | 在线前馈语义3DGS，从300多张流式图像同时重建并理解场景，用稀疏系数场加CLIP全局码本绑定语义。 | 面向具身探索中边看边理解的需求，可泛化到新场景并近实时完成语义重建。 | [[topics/papers/语义3DGS与具身导航/6-23_2603.04254_EmbodiedSplat.pdf\|PDF]] · [代码](https://github.com/0nandon/EmbodiedSplat) · [主页](https://0nandon.github.io/EmbodiedSplat/) |
| 2026-03 | [**OGScene3D**](https://arxiv.org/abs/2603.16301)<br>Incremental Open-Vocabulary 3D Gaussian Scene Graph Mapping for Scene Understanding | — | 增量式开放词汇高斯场景图建图：置信度高斯语义表示加层级语义优化，渐进创建并更新节点与语义关系。 | 面向机器人增量探索环境的场景理解，支撑导航与操作等下游任务。 | [[topics/papers/语义3DGS与具身导航/6-24_2603.16301_OGScene3D.pdf\|PDF]] · [代码](https://github.com/IRMVLab/OGScene3D) |
| 2026-03 | [**OnlinePG**](https://arxiv.org/abs/2603.18510)<br>Online Open-Vocabulary Panoptic Mapping with 3D Gaussian Splatting | CVPR 2026 | 滑窗式局部到全局的在线开放词汇全景建图，局部用3D片段聚类图融合实例，全局用双向二分匹配合并高斯实例。 | 实时在线的实例级开放词汇地图，面向机器人感知与交互任务。 | [[topics/papers/语义3DGS与具身导航/6-25_2603.18510_OnlinePG.pdf\|PDF]] |
| 2026-03 | [**GS3LAM**](https://arxiv.org/abs/2603.27781)<br>Gaussian Semantic Splatting SLAM | ACM MM 2024 | 把场景建模为语义高斯场并用多模态误差联合优化位姿，辅以深度自适应尺度正则与随机采样关键帧缓解遗忘。 | 实时输出一致的稠密语义地图，可作为机器人语义定位与导航的地图层（ACM MM 2024 论文，2026 年才上 arXiv）。 | [[topics/papers/语义3DGS与具身导航/6-26_2603.27781_GS3LAM.pdf\|PDF]] · [代码](https://github.com/lif314/GS3LAM) |
| 2026-04 | [**FreeOcc**](https://arxiv.org/abs/2604.28115)<br>Training-Free Embodied Open-Vocabulary Occupancy Prediction | RSS 2026 | 免训练的开放词汇占据预测：SLAM估计位姿，几何一致的高斯更新建稠密地图，VLM语义关联到高斯后投影为体素占据。 | 无需3D标注和真值位姿即可增量构建开放词汇占据地图，可零样本迁移到新环境。 | [[topics/papers/语义3DGS与具身导航/6-27_2604.28115_FreeOcc.pdf\|PDF]] · [代码](https://github.com/the-masses/FreeOcc) · [主页](https://the-masses.github.io/freeocc-web/) |
| 2026-06 | [**VCS-SLAM**](https://arxiv.org/abs/2606.29494)<br>Geometry-Validated Semantic Evidence Fusion for 3D Gaussian SLAM | — | 在RGB-D高斯SLAM中按可见性一致性、表面边界证据与射线冲突不确定性评估2D语义可靠性，抑制遮挡更新与语义溢出。 | 提升在线语义地图在遮挡复杂的真实环境中的可靠性，减少下游导航中的语义误标。 | [[topics/papers/语义3DGS与具身导航/6-28_2606.29494_VCS-SLAM.pdf\|PDF]] |
| 2026-06 | [**GaussLite**](https://arxiv.org/abs/2606.30809)<br>Online Task-Conditioned 3D Gaussian Splatting for Real-Time Robotic Mapping | — | 以自然语言任务为条件的在线3DGS建图：LLM解析目标物体、开放词汇检测生成相关性掩码，按任务相关性分配高斯容量。 | 在资源受限机器人上4Hz实时建图，把算力集中到任务相关区域，并支持多智能体地图融合。 | [[topics/papers/语义3DGS与具身导航/6-29_2606.30809_GaussLite.pdf\|PDF]] |
| 2026-07 | [**GEM-Occ**](https://arxiv.org/abs/2607.05543)<br>From Visual Geometry Evidence to Embodied Semantic Occupancy Memory | — | 高斯证据记忆框架：把局部预测转为语义高斯与自由空间射线证据，层级记忆支持从房间到整栋楼的在线语义占据建图。 | 为室内探索智能体提供跨房间/楼宇持续更新、可快速查询的语义占据记忆。 | [[topics/papers/语义3DGS与具身导航/6-30_2607.05543_GEM-Occ.pdf\|PDF]] · [代码](https://github.com/zhuhu00/GEM-Occ) · [主页](https://zhuhu00.top/GEM-Occ/) |
| 2026-09 | [**ArborSplat**](https://arxiv.org/abs/2609.26315)<br>Online Semantic Gaussian Splatting SLAM for Orchards | — | 果园场景的在线语义3DGS SLAM，用LiDAR里程计跟踪，在高斯地图上直接优化语义，并以地面高度带约束树干等细结构。 | 为户外果园机器人提供保留树干、棚架、果实的语义地图，服务作业与导航。 | [[topics/papers/语义3DGS与具身导航/6-31_2609.26315_ArborSplat.pdf\|PDF]] |
| 2026-10 | [**OpenSplatGraph**](https://arxiv.org/abs/2610.07569)<br>From Dense Semantic Maps to Structured Scene Graphs for Open-Vocabulary Robot Perception | ACCV 2026 | 直接从在线高斯开放词汇语义地图构建持久3D场景图，加入可靠性感知语义场做置信度感知、按查询的物体提取。 | 支持语言引导物体定位与关系推理，并在真实机器人实验中验证。 | [[topics/papers/语义3DGS与具身导航/6-32_2610.07569_OpenSplatGraph.pdf\|PDF]] · [代码](https://github.com/csiro-robotics/OpenSplatGraph) · [主页](https://csiro-robotics.github.io/OpenSplatGraph/) |
| 2026-11 | [**UniGS-SLAM**](https://arxiv.org/abs/2611.02051)<br>Monocular Gaussian SLAM with Enhanced Geometry and Open-Vocabulary Semantics | — | 仅用RGB的单目高斯SLAM，把开放词汇语义融合进带观测溯源的独立稀疏体素图，几何更新后可修正历史语义。 | 单目相机即可在线构建可修正的开放词汇语义地图，适合低成本移动机器人。 | [[topics/papers/语义3DGS与具身导航/6-33_2611.02051_UniGS-SLAM.pdf\|PDF]] · [主页](https://3dagentworld.github.io/UniGS-SLAM/) |

## 七、语义 3DGS 表示（种子论文所在方向）

给高斯附上语义或语言特征的表示方法本身，大多不做导航，但提供了导航要用的开放词汇语义地图。

### 通用 / 前馈模型

| 日期 | 论文 | 发表 | 做了什么 | 和导航的关系 | 链接 |
|---|---|---|---|---|---|
| 2024-10 | [**LSM**](https://arxiv.org/abs/2410.18956)<br>Large Spatial Model: End-to-end Unposed Images to Semantic 3D | NeurIPS 2024 | 从无位姿图像单次前馈同时估计几何、外观与语义，输出语义高斯，可用语言在新视角生成标签图。 | 实时从少量图像构建可语言查询的语义 3D 场景，是前馈语义 3DGS 的代表性基线。 | [[topics/papers/语义3DGS与具身导航/7-01_2410.18956_LSM.pdf\|PDF]] · [代码](https://github.com/NVlabs/LSM) · [主页](https://largespatialmodel.github.io) |
| 2024-12 | [**GSemSplat**](https://arxiv.org/abs/2412.16932)<br>Generalizable Semantic 3D Gaussian Splatting from Uncalibrated Image Pairs | — | 基于Splatt3R，从稀疏未标定图像对前馈学习绑定到3D高斯的开放词汇语义，无需逐场景优化。 | 摘要明确把机器人导航列为动机应用；可在 ScanNet++ 室内场景快速生成语义高斯场。 | [[topics/papers/语义3DGS与具身导航/7-02_2412.16932_GSemSplat.pdf\|PDF]] · [代码](https://github.com/wxrui182/GSemSplat) |
| 2024-12 | [**OVGaussian**](https://arxiv.org/abs/2501.00326)<br>Generalizable 3D Gaussian Segmentation with Open Vocabularies | — | 构建带高斯级语义标注的SegGaussian数据集，训练3D网络为每个高斯预测开放词汇语义，可跨场景泛化。 | 与 SceneSplat 同属“在 3DGS 原语上原生学习语义”的路线，可对新场景零样本生成语义地图。 | [[topics/papers/语义3DGS与具身导航/7-03_2501.00326_OVGaussian.pdf\|PDF]] · [代码](https://github.com/runnanchen/OVGaussian) |
| 2025-03 | [**SceneSplat**](https://arxiv.org/abs/2503.18052)（种子）<br>Gaussian Splatting-based Scene Understanding with Vision-Language Pretraining | ICCV 2025 Oral | 直接在 3DGS 上做开放词汇语义理解的前馈模型，配自监督预训练，并发布 7916 个室内场景的 SceneSplat-7K 数据集。 | 种子论文：一次前馈就能给整个室内场景的高斯赋予语义，可作为导航用的开放词汇语义地图。 | [[topics/papers/语义3DGS与具身导航/7-04_2503.18052_SceneSplat.pdf\|PDF]] · [代码](https://github.com/unique1i/SceneSplat) · [主页](https://unique1i.github.io/SceneSplat_webpage/) |
| 2025-05 | [**SpatialSplat**](https://arxiv.org/abs/2505.23044)<br>Efficient Semantic 3D from Sparse Unposed Images | ICCV 2025 | 前馈语义3DGS，用粗细双语义场与选择性高斯去冗余，在更少参数下学到准确语义与实例先验。 | 紧凑的语义高斯降低存储与显存开销，便于在机器人端部署语义地图。 | [[topics/papers/语义3DGS与具身导航/7-05_2505.23044_SpatialSplat.pdf\|PDF]] · [代码](https://github.com/shengyuuu/SpatialSplat) |
| 2025-06 | [**SemanticSplat**](https://arxiv.org/abs/2506.09565)<br>Feed-Forward 3D Scene Understanding with Language-Aware Gaussian Fields | — | 融合LSeg、SAM等特征场与代价体，前馈预测带潜在语义属性的高斯，联合建模几何-外观-语义。 | 摘要提到机器人交互应用；支持可提示分割与开放词汇分割，可在稀疏视角下构建语义地图。 | [[topics/papers/语义3DGS与具身导航/7-06_2506.09565_SemanticSplat.pdf\|PDF]] · [主页](https://semanticsplat.github.io) |
| 2025-08 | [**Uni3R**](https://arxiv.org/abs/2508.03643)<br>Unified 3D Reconstruction and Semantic Understanding via Generalizable Gaussian Splatting from Unposed Multi-View Images | CVPR 2026 | 跨视角Transformer从任意数量无位姿图像回归带语义特征场的高斯，一次前向完成渲染、分割与深度。 | 可从多视角观测快速得到几何+开放词汇语义统一的高斯表示（ScanNet 55.84 mIoU），适合作为语义地图前端。 | [[topics/papers/语义3DGS与具身导航/7-07_2508.03643_Uni3R.pdf\|PDF]] · [代码](https://github.com/HorizonRobotics/Uni3R) |
| 2025-11 | [**SegSplat**](https://arxiv.org/abs/2511.18386)<br>Feed-forward Gaussian Splatting and Open-Set Semantic Segmentation | — | 构建紧凑语义记忆库，前馈为每个高斯预测离散语义索引，无需逐场景优化即可开放集分割。 | 摘要明确称其对推进机器人交互至关重要，可即时生成可查询的语义 3D 环境。 | [[topics/papers/语义3DGS与具身导航/7-08_2511.18386_SegSplat.pdf\|PDF]] |
| 2025-12 | [**FLEG**](https://arxiv.org/abs/2512.17541)<br>Feed-Forward Language Embedded Gaussian Splatting from Any Views via Compact Semantic Representation | ECCV 2026 | 支持任意数量无位姿视图的前馈语言高斯，用稀疏语义高斯解耦语言表示，仅需5%语言嵌入。 | 支持可变视角输入与紧凑语言存储，适合机器人边采集边构建可语言查询的地图。 | [[topics/papers/语义3DGS与具身导航/7-09_2512.17541_FLEG.pdf\|PDF]] · [主页](https://fangzhou2000.github.io/projects/fleg) |
| 2025-12 | [**Chorus**](https://arxiv.org/abs/2512.17817)<br>Multi-Teacher Pretraining for Holistic 3D Gaussian Scene Encoding | CVPR 2026 | SceneSplat团队续作：多教师（语言/通用/物体）蒸馏预训练前馈3DGS场景编码器，支持开放词汇分割与问答。 | 可直接从重建好的 3DGS 场景前馈提取通用语义特征，适合作为机器人开放词汇语义地图的骨干编码器。 | [[topics/papers/语义3DGS与具身导航/7-10_2512.17817_Chorus.pdf\|PDF]] · [代码](https://github.com/GaussianWorld/Chorus) · [主页](https://gaussianworld.github.io/Chorus) |
| 2026-03 | [**SemGS**](https://arxiv.org/abs/2603.02548)<br>Feed-Forward Semantic 3D Gaussian Splatting from Sparse Views for Generalizable Scene Understanding | ICRA 2026 | 颜色/语义双分支加相机感知注意力，从稀疏视图前馈重建双高斯语义场，推理快、泛化强。 | 摘要明确以机器人在复杂环境中安全运行为动机，推理快且能泛化到合成与真实场景。 | [[topics/papers/语义3DGS与具身导航/7-11_2603.02548_SemGS.pdf\|PDF]] |
| 2026-04 | [**UniSplat**](https://arxiv.org/abs/2604.10573)<br>Learning 3D Representations for Spatial Intelligence from Unposed Multi-View Images | CVPR 2026 | UniSplat：双重掩码+由粗到细泼溅+位姿重校准，从无位姿稀疏视图前馈学习统一几何语义表示。 | 摘要明确将其定位为场景理解与具身 AI 的感知基础表示。 | [[topics/papers/语义3DGS与具身导航/7-12_2604.10573_UniSplat.pdf\|PDF]] · [代码](https://github.com/bobochow/UniSplat) |
| 2026-05 | [**LangFlash**](https://arxiv.org/abs/2605.23287)<br>Feed-forward 3D Language Gaussian Splatting from Sparse Unposed Images | CVPRF 2026 | 从稀疏无位姿图像前馈重建语言高斯，用全局语义字典加逐原语稀疏权重压缩语言特征。 | 单次前向、低延迟地构建语言一致的 3D 场景，可用于快速建立开放词汇地图。 | [[topics/papers/语义3DGS与具身导航/7-13_2605.23287_LangFlash.pdf\|PDF]] · [代码](https://github.com/liylo/LangFlash) · [主页](https://liylo.github.io/langflash.github.io/) |
| 2026-07 | [**COVScene**](https://arxiv.org/abs/2607.01633)<br>Bridging 3D Gaussians and Semantic Occupancy for Comprehensive Open-Vocabulary Scene Understanding from Unposed Images | — | COVScene：把前馈语义高斯与稠密语义占据场可微耦合，同时支持渲染、开放词汇查询与占据预测。 | 同时输出开放词汇语义与自由/占据空间，天然契合导航所需的“可通行性+语义”地图。 | [[topics/papers/语义3DGS与具身导航/7-14_2607.01633_COVScene.pdf\|PDF]] · [代码](https://github.com/zhuhu00/COVScene) |

### 数据集与基准

| 日期 | 论文 | 发表 | 做了什么 | 和导航的关系 | 链接 |
|---|---|---|---|---|---|
| 2025-06 | [**SceneSplat++**](https://arxiv.org/abs/2506.08710)<br>A Large Dataset and Comprehensive Benchmark for Language Gaussian Splatting | NeurIPS 2025 | SceneSplat续作：在3D空间直接评测三类语言高斯方法的千场景基准，并发布约4.9万场景的3DGS数据集。 | 提供大规模室内 3DGS 语义训练与评测数据，结论表明前馈可泛化范式最适合在新场景快速构建开放词汇语义地图。 | [[topics/papers/语义3DGS与具身导航/7-15_2506.08710_SceneSplat++.pdf\|PDF]] · [代码](https://github.com/GaussianWorld/SceneSplat_Benchmark) · [主页](https://scenesplatpp.gaussianworld.ai/) |
| 2026-03 | [**Holi-Spatial**](https://arxiv.org/abs/2603.07660)<br>Evolving Video Streams into Holistic 3D Spatial Intelligence | — | 从原始视频自动构建Holi-Spatial-4M，含1.2万个3DGS场景及掩码、3D框、实例描述与空间问答标注。 | 提供大规模带物体级语义标注的 3DGS 场景，可用于训练与评测语义高斯表示。 | [[topics/papers/语义3DGS与具身导航/7-16_2603.07660_Holi-Spatial.pdf\|PDF]] · [代码](https://github.com/Visionary-Laboratory/Holi-Spatial) · [主页](https://visionary-laboratory.github.io/holi-spatial/) |

### 逐场景优化的语言高斯（基础工作）

| 日期 | 论文 | 发表 | 做了什么 | 和导航的关系 | 链接 |
|---|---|---|---|---|---|
| 2023-11 | [**LEGaussians**](https://arxiv.org/abs/2311.18482)<br>Language Embedded 3D Gaussians for Open-Vocabulary Scene Understanding | CVPR 2024 | 用量化方案压缩高维语义特征并平滑嵌入，在实时渲染下实现高精度开放词汇查询。 | 早期开放词汇高斯表示，摘要指出服务于物体定位与分割等场景理解任务。 | [[topics/papers/语义3DGS与具身导航/7-17_2311.18482_LEGaussians.pdf\|PDF]] · [代码](https://github.com/buaavrcg/LEGaussians) |
| 2023-12 | [**Feature 3DGS**](https://arxiv.org/abs/2312.03203)<br>Supercharging 3D Gaussian Splatting to Enable Distilled Feature Fields | CVPR 2024 | 把任意维度2D基础模型特征（SAM、LSeg等）蒸馏进3D高斯，形成可实时渲染的特征场。 | 通用的“基础模型特征→高斯”蒸馏框架，是给高斯附着语义特征的基础方法。 | [[topics/papers/语义3DGS与具身导航/7-18_2312.03203_Feature-3DGS.pdf\|PDF]] · [代码](https://github.com/ShijieZhou-UCLA/feature-3dgs) · [主页](https://feature-3dgs.github.io/) |
| 2023-12 | [**LangSplat**](https://arxiv.org/abs/2312.16084)<br>3D Language Gaussian Splatting | CVPR 2024 | 用3D高斯承载压缩后的CLIP特征并借SAM学习层级语义，构建精确高效的3D语言场。 | 逐场景语言高斯的奠基工作与主要基线，其开放词汇查询能力可直接用于语义地图。 | [[topics/papers/语义3DGS与具身导航/7-19_2312.16084_LangSplat.pdf\|PDF]] · [代码](https://github.com/minghanqin/LangSplat) · [主页](https://langsplat.github.io/) |
| 2024-01 | [**FMGS**](https://arxiv.org/abs/2401.01970)<br>Foundation Model Embedded 3D Gaussian Splatting for Holistic 3D Scene Understanding | IJCV 2024 | 将视觉语言基础模型特征蒸馏到“高斯+哈希编码”混合表示，实现多视角一致的开放词汇检测。 | 摘要以增强现实与机器人应用为动机，推理比此前方法快 851 倍。 | [[topics/papers/语义3DGS与具身导航/7-20_2401.01970_FMGS.pdf\|PDF]] · [代码](https://github.com/google-research/foundation-model-embedded-3dgs) · [主页](https://xingxingzuo.github.io/fmgs) |
| 2024-03 | [**Semantic Gaussians**](https://arxiv.org/abs/2403.15624)<br>Open-Vocabulary Scene Understanding with 3D Gaussian Splatting | — | 把2D预训练特征免训练投影到高斯语义分量，并训练3D网络直接从原始高斯预测语义。 | 摘要明确提到具身智能体应用；其“从原始高斯直接预测语义”的 3D 网络思路与 SceneSplat 接近。 | [[topics/papers/语义3DGS与具身导航/7-21_2403.15624_Semantic-Gaussians.pdf\|PDF]] · [代码](https://github.com/sharinka0715/semantic-gaussians) · [主页](https://semantic-gaussians.github.io) |
| 2024-12 | [**Occam's LGS**](https://arxiv.org/abs/2412.01807)<br>An Efficient Approach for Language Gaussian Splatting | BMVC 2025 | 基于概率化表述的加权多视角特征聚合，免复杂训练地把语言特征提升到高斯，提速两个数量级。 | 与 SceneSplat 同属 INSAIT 团队；快速的免优化语言提升适合为大量 3DGS 场景批量生成语义特征。 | [[topics/papers/语义3DGS与具身导航/7-22_2412.01807_Occam-s-LGS.pdf\|PDF]] · [代码](https://github.com/insait-institute/OccamLGS) · [主页](https://insait-institute.github.io/OccamLGS/) |
| 2025-02 | [**Dr. Splat**](https://arxiv.org/abs/2502.16652)<br>Directly Referring 3D Gaussian Splatting via Direct Language Embedding Registration | CVPR 2025 | 不经渲染，直接把CLIP嵌入注册到射线上的主导高斯并用乘积量化压缩，做3D开放词汇理解。 | 直接在 3D 高斯上做语言查询而非 2D 渲染视图，更贴合机器人对 3D 语义地图的需求。 | [[topics/papers/语义3DGS与具身导航/7-23_2502.16652_Dr.-Splat.pdf\|PDF]] · [代码](https://github.com/kaist-ami/Dr-Splat) · [主页](https://drsplat.github.io/) |
| 2025-05 | [**SLAG**](https://arxiv.org/abs/2505.08124)<br>Scalable Language-Augmented Gaussian Splatting | RA-L 2025 | 多GPU可扩展语言高斯：由高斯参数加权平均直接求语言嵌入，无需损失优化，配向量数据库检索。 | 摘要明确面向搜救、矿山等大规模机器人应用及算力受限的机器人部署。 | [[topics/papers/语义3DGS与具身导航/7-24_2505.08124_SLAG.pdf\|PDF]] · [主页](https://slag-project.github.io/) |
| 2025-07 | [**LangSplatV2**](https://arxiv.org/abs/2507.07136)<br>High-dimensional 3D Language Gaussian Splatting with 450+ FPS | NeurIPS 2025 | 把每个高斯视为全局字典上的稀疏编码，去掉解码器，以450+FPS渲染高维语言特征。 | 实时高维语言场渲染与查询，满足机器人在线查询语义地图的速度需求。 | [[topics/papers/语义3DGS与具身导航/7-25_2507.07136_LangSplatV2.pdf\|PDF]] · [代码](https://github.com/ZhaoYujie2002/LangSplatV2) · [主页](https://langsplat-v2.github.io) |

### 实例与分组

| 日期 | 论文 | 发表 | 做了什么 | 和导航的关系 | 链接 |
|---|---|---|---|---|---|
| 2023-12 | [**Gaussian Grouping**](https://arxiv.org/abs/2312.00732)<br>Segment and Edit Anything in 3D Scenes | ECCV 2024 | 为每个高斯加紧凑身份编码，用SAM掩码监督把高斯按实例分组，实现3D任意分割与编辑。 | 提供实例级高斯分组，是构建物体级语义地图的常用基础。 | [[topics/papers/语义3DGS与具身导航/7-26_2312.00732_Gaussian-Grouping.pdf\|PDF]] · [代码](https://github.com/lkeab/gaussian-grouping) |
| 2024-06 | [**OpenGaussian**](https://arxiv.org/abs/2406.02058)<br>Towards Point-Level 3D Gaussian-based Open Vocabulary Understanding | NeurIPS 2024 | 用SAM训练3D一致实例特征并两级码本离散化，再关联CLIP特征，实现3D点级开放词汇理解。 | 可直接在 3D 高斯点级别检索物体，适合语义地图中的目标定位。 | [[topics/papers/语义3DGS与具身导航/7-27_2406.02058_OpenGaussian.pdf\|PDF]] · [代码](https://github.com/yanmin-wu/OpenGaussian) · [主页](https://3d-aigc.github.io/OpenGaussian) |
| 2025-03 | [**PanoGS**](https://arxiv.org/abs/2503.18107)<br>Gaussian-based Panoptic Segmentation for 3D Open Vocabulary Scene Understanding | CVPR 2025 | 金字塔三平面建模语言特征，语言引导图割与图聚类得到实例，实现3D全景开放词汇分割。 | 面向大型室内场景的实例级开放词汇语义，可直接用于物体级语义地图。 | [[topics/papers/语义3DGS与具身导航/7-28_2503.18107_PanoGS.pdf\|PDF]] · [代码](https://github.com/zhaihongjia/PanoGS) · [主页](https://zju3dv.github.io/panogs) |
| 2026-08 | [**InstanceSplat**](https://arxiv.org/abs/2608.07144)<br>Instance-Aware Feed-Forward 3D Gaussian Splatting for Scene Understanding | — | 前馈实例感知3DGS，单次前向联合编码外观、几何、实例身份与语言语义，可区分同类实例。 | 前馈获得实例级可查询表示，能区分同类物体，利于实例级目标检索所需的地图。 | [[topics/papers/语义3DGS与具身导航/7-29_2608.07144_InstanceSplat.pdf\|PDF]] · [代码](https://github.com/JamChaos/InsSplat) · [主页](https://jamchaos.github.io/InsSplat/) |
| 2026-08 | [**GroupForward**](https://arxiv.org/abs/2608.17535)<br>Building Referable 3D Scenes via Instance-Grouped Feed-Forward Gaussian Splatting | — | 前馈实例分组高斯，用紧凑实例嵌入聚合高斯成3D实例，并结合场景图与VLM做复杂指代分割。 | 摘要明确称同时重建与理解 3D 环境对具身智能体至关重要。 | [[topics/papers/语义3DGS与具身导航/7-30_2608.17535_GroupForward.pdf\|PDF]] |

### 其他

| 日期 | 论文 | 发表 | 做了什么 | 和导航的关系 | 链接 |
|---|---|---|---|---|---|
| 2026-09 | [**CoRef-GS**](https://arxiv.org/abs/2609.20586)<br>Cooperative Referring Gaussian Splatting for Multi-Agent Scene Understanding | — | 多机器人各建开放词汇实例高斯地图，经几何+语义对齐融合后按查询视角做指代定位。 | 直接面向多机器人语义高斯地图的对齐融合与语言定位，摘要明确针对具身机器人。 | [[topics/papers/语义3DGS与具身导航/7-31_2609.20586_CoRef-GS.pdf\|PDF]] · [代码](https://github.com/ruojiruoli17/CoRef-GS) |

## 附：检索中看到、没有放进正文的

### 没有 arXiv 版本

这些只在会议论文库或项目主页上找到，没有逐篇核对内容：

- **Open-Set Semantic Gaussian Splatting SLAM with Expandable Representation**，ICLR 2026 Poster，[项目主页](https://open-ended-slam.github.io)
- **OVSG-SLAM: Open-Vocabulary Semantic Gaussian Splatting SLAM**，IROS 2025，[DOI](https://doi.org/10.1109/IROS60139.2025.11246404)
- **FOCI: Trajectory Optimization on Gaussian Splats**，IROS 2025，[DOI](https://doi.org/10.1109/iros60139.2025.11245845)
- **Risk-Aware Safe Feedback Motion Planning in Gaussian Splatting World**，ICUS 2024，[DOI](https://doi.org/10.1109/icus61736.2024.10839860)

### 边缘相关

标题已对照 arXiv 核对，但离"语义高斯用于导航"较远，或与正文里的工作高度相似：

- [Segment Any 3D Gaussians](https://arxiv.org/abs/2312.00860)（2023-12）：实例分组
- [CLIP-GS: CLIP-Informed Gaussian Splatting for View-Consistent 3D Indoor Semantic Understanding](https://arxiv.org/abs/2404.14249)（2024-04）：语义表示（与已收录工作相近）
- [Monocular Gaussian SLAM with Language Extended Loop Closure](https://arxiv.org/abs/2405.13748)（2024-05）：高斯 SLAM
- [RT-GS2: Real-Time Generalizable Semantic Segmentation for 3D Gaussian Representations of Radiance Fields](https://arxiv.org/abs/2405.18033)（2024-05）：语义表示（与已收录工作相近）
- [Go-SLAM: Grounded Object Segmentation and Localization with Gaussian Splatting SLAM](https://arxiv.org/abs/2409.16944)（2024-09）：开放词汇查询加路径生成
- [InstanceGaussian: Appearance-Semantic Joint Gaussian Representation for 3D Instance-Level Perception](https://arxiv.org/abs/2411.19235)（2024-11）：实例分组
- [RGBDS-SLAM: A RGB-D Semantic Dense SLAM Based on 3D Multi Level Pyramid Gaussian Splatting](https://arxiv.org/abs/2412.01217)（2024-12）：语义高斯 SLAM
- [GaussTR: Foundation Model-Aligned Gaussian Transformer for Self-Supervised 3D Spatial Understanding](https://arxiv.org/abs/2412.13193)（2024-12）：自动驾驶占据预测
- [SIREN: Semantic, Initialization-Free Registration of Multi-Robot Gaussian Splatting Maps](https://arxiv.org/abs/2502.06519)（2025-02）：多机器人高斯地图语义配准
- [GaussianGraph: 3D Gaussian-based Scene Graph Generation for Open-world Scene Understanding](https://arxiv.org/abs/2503.04034)（2025-03）：离线的高斯场景图
- [EmbodiedOcc++: Boosting Embodied 3D Occupancy Prediction with Plane Regularization and Uncertainty Sampler](https://arxiv.org/abs/2504.09540)（2025-04）：具身占据预测
- [GSFF-SLAM: 3D Semantic Gaussian Splatting SLAM via Feature Field](https://arxiv.org/abs/2504.19409)（2025-04）：语义高斯 SLAM
- [Understanding while Exploring: Semantics-driven Active Mapping](https://arxiv.org/abs/2506.00225)（2025-05）：主动语义建图
- [Hi-LSplat: Hierarchical 3D Language Gaussian Splatting](https://arxiv.org/abs/2506.06822)（2025-06）：离线的分层语言高斯
- [UniForward: Unified 3D Scene and Semantic Field Reconstruction via Feed-Forward Gaussian Splatting from Only Sparse-View Images](https://arxiv.org/abs/2506.09378)（2025-06）：语义表示（与已收录工作相近）
- [HELIOS: Hierarchical Exploration for Language-Grounded Interaction in Open Scenes](https://arxiv.org/abs/2509.22498)（2025-09）：不确定是否为高斯泼溅
- [Gen-LangSplat: Generalized Language Gaussian Splatting with Pre-Trained Feature Compression](https://arxiv.org/abs/2510.22930)（2025-10）：语义表示（与已收录工作相近）
- [What Is The Best 3D Scene Representation for Robotics? From Geometric to Foundation Models](https://arxiv.org/abs/2512.03422)（2025-12）：综述：机器人三维场景表示
- [FeatureSLAM: Feature-enriched 3D gaussian splatting SLAM in real time](https://arxiv.org/abs/2601.05738)（2026-01）：特征高斯 SLAM
- [S2GS: Streaming Semantic Gaussian Splatting for Online Scene Understanding and Reconstruction](https://arxiv.org/abs/2603.14232)（2026-03）：在线前馈语义高斯
- [UniSem: Generalizable Semantic 3D Reconstruction from Sparse Unposed Images](https://arxiv.org/abs/2603.17519)（2026-03）：语义表示（与已收录工作相近）
- [RoSe-SLAM: Robust Semantic-Aware Gaussian Splatting SLAM from Dynamic Monocular Videos](https://arxiv.org/abs/2608.29003)（2026-08）：语义高斯 SLAM
- [AOV-GS: Active Open-Vocabulary Semantic Mapping with 3D Gaussian Splatting](https://arxiv.org/abs/2610.29374)（2026-10）：主动开放词汇建图，只评测建图质量
