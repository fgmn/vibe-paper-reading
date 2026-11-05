---
title: 无人机视觉语言导航（UAV VLN）
tags: [topic]
paper_count: 103
updated: 2026-11-05
---

# 无人机视觉语言导航（UAV VLN）

> [!info] 这份清单怎么来的
> 收集按语言指令飞行的无人机导航（空中 VLN）及相邻任务的工作，共 103 篇，分五节；第六节对比各基准使用的场景。
> - 检索时间 2026-11-05，来源是 Hugging Face 论文搜索、arXiv API、GitHub 上的 awesome 列表和网页搜索，并合并了 VLN、3DGS、RSI 三个专题里已有的无人机论文。不是穷尽列表。
> - 每篇都对照 arXiv 页面核对过标题和首版日期；"做了什么"依据的摘要原句都在摘要里找到了，"摘要里的关键数字"一栏的每个数字也都出现在摘要中。
> - 发表信息只在 arXiv 备注、项目主页或官方代码仓库写明时才填，"—"表示只有预印本或没找到。每节按首版日期排序。"做了什么"是 Claude 根据摘要写的一句话，读原文时请核对。
> - 18 篇已在其他专题下载过，链接栏直接指向那份；其余 85 篇的 PDF 在 `topics/papers/无人机VLN/`，文件名开头的"节号-序号"和表格顺序一致；下载的是 2026-11-05 时 arXiv 上的最新版本，只存在本地，不进 git。

## 建议的阅读顺序

1. [AerialVLN](https://arxiv.org/abs/2308.06735)：第一个城市级无人机 VLN 基准：UE4 + AirSim 里的 25 个合成城市，平均航程 661.8 m，后面不少工作沿用它的动作或评测设定。
2. [AVDN](https://arxiv.org/abs/2205.12219)：用对话指挥无人机；场景是从卫星图裁剪俯视画面的模拟器，没有三维。
3. [CityNav](https://arxiv.org/abs/2406.14240)：第一个基于真实城市的空中 VLN 数据集：剑桥、伯明翰的三维点云，32,637 条人类示范。
4. [OpenUAV](https://arxiv.org/abs/2410.07087)：连续 6-DoF 轨迹、接入真实飞控的平台和目标导向基准，后续论文常用它的 TravelUAV 设定做对比。
5. [Openfly](https://arxiv.org/abs/2502.18041)：把 UE、GTA V、Google Earth 和 3DGS 实景接进同一个平台，10 万条轨迹，还在 23 个真实户外场景实飞。
6. [STMR](https://arxiv.org/abs/2410.08500)：零样本：把和指令相关的语义投影成俯视的语义-拓扑-度量表示，作为提示交给大模型决策。
7. [CityNavAgent](https://arxiv.org/abs/2505.05622)：大模型智能体：分层语义规划拆解长程任务，用拓扑图记忆复用走过的路。
8. [See, Point, Fly](https://arxiv.org/abs/2509.22653)：不训练：让视觉语言模型在图像上标出下一个航点，再换算成三维位移。
9. [FlightGPT](https://arxiv.org/abs/2505.12835)：视觉语言模型先监督微调，再用复合奖励做 GRPO 强化学习。
10. [AerialVLA](https://arxiv.org/abs/2603.14363)：极简端到端 VLA，在 TravelUAV 未见场景上成功率约为此前最好方法的 3 倍。
11. [WorldVLN](https://arxiv.org/abs/2605.15964)：世界-动作模型：先预测短时的潜在世界状态，再解码航点。
12. [OpenFlyV2](https://arxiv.org/abs/2610.39287)：完全机载运行的 VLA，零样本迁移到四个真实环境，成功率 48%。
13. [UAV-Flow Colosseo](https://arxiv.org/abs/2505.15725)：真机采集的细粒度语言飞控数据，30,692 条轨迹。
14. [Vision-and-Language Navigation for UAVs: Progress, Challenges, and a Research Roadmap](https://arxiv.org/abs/2604.13654)：综述：方法分类、模拟器、数据集、评测指标和研究路线图。

| 节 | 篇数 |
|---|---|
| [[#一、基准、数据集与平台]] | 29 |
| [[#二、相关任务：目标搜索、问答与空地协同]] | 11 |
| [[#三、方法]] | 57 |
| [[#四、同时支持无人机的通用导航模型]] | 2 |
| [[#五、综述]] | 4 |
| [[#六、各基准使用的场景]] | — |

## 一、基准、数据集与平台

按语言指令飞行的评测基准、数据集、仿真平台和真机基准。各基准用的场景在第六节对比。

### 基准与数据集

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2022-05 | [**AVDN**](https://arxiv.org/abs/2205.12219)<br>Aerial Vision-and-Dialog Navigation | ACL 2023 Findings | 提出用自然语言对话控制无人机的 AVDN 任务，收集 3k 多条带指挥者-跟随者异步对话的飞行轨迹。 | over 3k recorded navigation trajectories | [[topics/papers/视觉语言导航VLN/4-23_2205.12219_AVDN.pdf\|PDF]]（VLN 专题） · [代码](https://github.com/eric-ai-lab/Aerial-Vision-and-Dialog-Navigation) · [主页](https://sites.google.com/view/aerial-vision-and-dialog/home) |
| 2023-08 | [**AerialVLN**](https://arxiv.org/abs/2308.06735)<br>Vision-and-Language Navigation for UAVs | ICCV 2023 | 提出面向无人机的户外城市级 VLN 任务 AerialVLN，搭建含 25 个城市场景、支持连续飞行的近真实模拟器。 | 25 city-level scenarios | [[topics/papers/视觉语言导航VLN/4-24_2308.06735_AerialVLN.pdf\|PDF]]（VLN 专题） · [代码](https://github.com/AirVLN/AirVLN) |
| 2024-06 | [**CityNav**](https://arxiv.org/abs/2406.14240)<br>A Large-Scale Dataset for Real-World Aerial Navigation | ICCV 2025 | 首个基于真实城市（剑桥、伯明翰）的大规模空中 VLN 数据集 CityNav，要求结合真实地标与地理信息推理目的地。 | 32,637 human demonstration trajectories covering 4.65 km^2 across two real cities | [[topics/papers/视觉语言导航VLN/4-25_2406.14240_CityNav.pdf\|PDF]]（VLN 专题） · [代码](https://github.com/water-cookie/citynav) · [主页](https://water-cookie.github.io/city-nav-proj/) |
| 2024-08 | [**AeroVerse**](https://arxiv.org/abs/2408.15511)<br>UAV-Agent Benchmark Suite for Simulating, Pre-training, Finetuning, and Evaluating Aerospace Embodied World Models | — | 无人机具身世界模型基准套件：图文预训练数据加感知、推理、导航、规划、决策五类下游数据。 | AerialAgent-Ego10k; CyberAgent Ego500k; 5 downstream tasks | [[topics/papers/无人机VLN/1-04_2408.15511_AeroVerse.pdf\|PDF]] |
| 2024-10 | [**OpenUAV**](https://arxiv.org/abs/2410.07087)<br>Towards Realistic UAV Vision-Language Navigation: Platform, Benchmark, and Methodology | — | 提出真实飞控的 OpenUAV 平台、约 1.2 万条轨迹的 UAV VLN 数据集与辅助引导式 UAV-Need-Help 基准。 | approximately 12k trajectories | [[topics/papers/视觉语言导航VLN/4-26_2410.07087_OpenUAV.pdf\|PDF]]（VLN 专题） · [代码](https://github.com/prince687028/TravelUAV) · [主页](https://prince687028.github.io/Travel/) |
| 2025-03 | [**CognitiveDrone**](https://arxiv.org/abs/2503.01378)<br>A VLA Model and Evaluation Benchmark for Real-Time Cognitive Task Solving and Reasoning in UAVs | — | 面向人物识别、符号理解与推理的无人机 VLA 模型，并发布首个无人机认知任务评测基准。 | over 8,000 simulated flight trajectories; RaceVLA) achieves an overall success rate of 31.3%, the base CognitiveDrone model reaches 59.6%, and CognitiveDrone-R1 attains a success rate of 77.2% | [[topics/papers/无人机VLN/1-06_2503.01378_CognitiveDrone.pdf\|PDF]] · [主页](http://cognitivedrone.github.io) |
| 2025-03 | [**UrbanVideo-Bench**](https://arxiv.org/abs/2503.06157)<br>Benchmarking Vision-Language Models on Embodied Intelligence with Video Data in Urban Spaces | ACL 2025 | 用人工操控无人机在真实与仿真城市采集第一人称运动视频，评测 Video-LLM 在城市空间的回忆、感知、推理与导航能力。 | 1.5k video clips; 5.2k multiple-choice questions; 17 widely-used Video-LLMs | [[topics/papers/无人机VLN/1-07_2503.06157_UrbanVideo-Bench.pdf\|PDF]] · [代码](https://github.com/EmbodiedCity/UrbanVideo-Bench.code) · [主页](https://embodiedcity.github.io/UrbanVideo-Bench/) |
| 2025-03 | [**Open3D-VQA**](https://arxiv.org/abs/2503.11094)<br>A Benchmark for Comprehensive Spatial Reasoning with Multimodal Large Language Model in Open Space | ACM MM 2025 | 从空中视角评测 MLLM 空间推理的开放空间 VQA 基准，73k 问答覆盖 7 类任务，含点云模态。 | 73k QA pairs spanning 7 general spatial reasoning tasks; 13 popular MLLMs | [[topics/papers/无人机VLN/1-08_2503.11094_Open3D-VQA.pdf\|PDF]] · [代码](https://github.com/EmbodiedCity/Open3D-VQA.code) |
| 2025-05 | [**BEDI**](https://arxiv.org/abs/2505.18229)<br>A Comprehensive Benchmark for Evaluating Embodied Agents on UAVs | — | 无人机具身智能体系统化评测基准，按感知-决策-行动环拆为六项子技能，并提供虚实混合测试平台与开放接口。 | six core sub-skills | [[topics/papers/无人机VLN/1-09_2505.18229_BEDI.pdf\|PDF]] · [代码](https://github.com/lostwolves/BEDI) |
| 2025-08 | [**AeroDuo**](https://arxiv.org/abs/2508.15232)<br>Aerial Duo for UAV-based Vision and Language Navigation | ACM MM 2025 | 提出高低空双机协同 DuAl-VLN 任务，构建 13,838 条协同示范轨迹的 HaL-13k 数据集与基线。 | 13,838 collaborative high-low UAV demonstration trajectories | [[topics/papers/无人机VLN/1-10_2508.15232_AeroDuo.pdf\|PDF]] · [代码](https://github.com/buaa-colalab/AeroDuo) |
| 2025-11 | [**SpatialSky-Bench**](https://arxiv.org/abs/2511.13269)<br>Is your VLM Sky-Ready? A Comprehensive Spatial Intelligence Benchmark for UAV Navigation | CVPR 2026 | 评测 VLM 在无人机导航中空间智能的基准（13 个子类），并发布百万样本数据集与 Sky-VLM。 | 13 subcategories; 1M samples | [[topics/papers/无人机VLN/1-11_2511.13269_SpatialSky-Bench.pdf\|PDF]] · [代码](https://github.com/linglingxiansen/SpatialSKy) |
| 2025-12 | [**IndoorUAV**](https://arxiv.org/abs/2512.19024)<br>Benchmarking Vision-Language UAV Navigation in Continuous Indoor Environments | AAAI 2026 | 基于 Habitat 千余室内场景构建室内无人机连续 VLN 基准，分长程 VLN 与短程 VLA 两个子集。 | over 1,000 diverse and structurally rich 3D indoor scenes; over 16,000 high-quality trajectories | [[topics/papers/无人机VLN/1-12_2512.19024_IndoorUAV.pdf\|PDF]] · [代码](https://github.com/valyentinee/IndoorUAV-Agent) |
| 2026-01 | [**AirNav**](https://arxiv.org/abs/2601.03707)<br>A Large-Scale UAV Vision-and-Language Navigation Dataset with Natural and Diverse Instructions | — | 基于真实城市航拍构建 13.7 万样本的 UAV VLN 基准，指令由人-LLM 协作结合 10 种用户画像生成。 | 137K navigation samples; AirVLN-R1 achieves a 51.82% success rate on the test-unseen split | [[topics/papers/视觉语言导航VLN/4-27_2601.03707_AirNav.pdf\|PDF]]（VLN 专题） · [代码](https://github.com/nopride03/AirNav) · [主页](https://littlelucifer1.github.io/AirNav/) |
| 2026-03 | [**HUGE-Bench**](https://arxiv.org/abs/2603.19822)<br>A Benchmark for High-Level UAV Vision-Language-Action Tasks | — | 高层UAV视觉-语言-动作任务基准，基于对齐的3DGS-网格数字孪生做碰撞感知评测。 | — | [[topics/papers/语义3DGS与具身导航/2-10_2603.19822_HUGE-Bench.pdf\|PDF]]（3DGS 专题） |
| 2026-04 | [**LinkS²Bench**](https://arxiv.org/abs/2604.02020)<br>Are VLMs Lost Between Sky and Space? LinkS$^2$Bench for UAV-Satellite Dynamic Cross-View Spatial Intelligence | — | 关联无人机动态视频与卫星影像，评测 VLM 的无人机-卫星跨视角动态空间智能（17.9k 问答）。 | 1,022 minutes of dynamic UAV footage; over 200 km$^2$; 17.9k high-quality question-answer pairs comprising 12 fine-grained tasks; 18 representative VLMs | [[topics/papers/无人机VLN/1-15_2604.02020_LinkS2Bench.pdf\|PDF]] |
| 2026-04 | [**How Far Are Large Multimodal Models from Human-Level Spatial Action? A Benchmark for Goal-Oriented Embodied Navigation in Urban Airspace**](https://arxiv.org/abs/2604.07973) | — | 城市空域目标导向具身导航基准，5,037 条强调垂直动作的样本，评测 17 个模型与人类差距。 | 5,037 high-quality goal-oriented navigation samples; 17 representative models | [[topics/papers/无人机VLN/1-16_2604.07973_How-Far-Are-Large-Multimodal-Models-from.pdf\|PDF]] · [代码](https://github.com/serenditipy-AC/Embodied-Navigation-Bench) |
| 2026-06 | [**Think Like a Pilot**](https://arxiv.org/abs/2606.06836)<br>Fine-Grained Long-Horizon UAV Navigation | — | 细粒度长程指令引导的无人机导航基准 FLIGHT，多阶段指令配稠密 6-DoF 轨迹，含两个数据划分。 | — | [[topics/papers/无人机VLN/1-17_2606.06836_Think-Like-a-Pilot.pdf\|PDF]] · [代码](https://github.com/buaa-colalab/FLIGHT) · [主页](https://buaa-colalab.github.io/FLIGHT/) |
| 2026-06 | [**SpatialUAV**](https://arxiv.org/abs/2606.27876)<br>Benchmarking Spatial Intelligence for Low-Altitude UAV Perception, Collaboration, and Motion | — | 真实低空无人机空间智能基准，覆盖语义判别、空间关系、空-空与空-地协同、运动理解等 14 类细粒度任务。 | 4,331 curated instances across 14 fine-grained task types | [[topics/papers/无人机VLN/1-18_2606.27876_SpatialUAV.pdf\|PDF]] · [代码](https://github.com/Hyu-Zhang/SpatialUAV) |
| 2026-07 | [**Self in Space**](https://arxiv.org/abs/2607.12477)<br>Benchmarking Self-Awareness and Spatial Cognition in UAV Embodied Intelligence | ACM MM 2026 | 以“自我在空间中”框架评测无人机具身空间智能，覆盖空间与自我两个维度、感知-记忆-推理三个层级，数据来自真实航拍视频。 | 4,856 question--answer pairs across 13 tasks derived from 1,646 real-world UAV videos | [[topics/papers/无人机VLN/1-19_2607.12477_Self-in-Space.pdf\|PDF]] · [代码](https://github.com/IntelliSensing/Self-in-Space) · [主页](https://choucisan.github.io/publications/self-in-space) |
| 2026-07 | [**UAV-DualCog**](https://arxiv.org/abs/2607.16193)<br>A Dual-Cognition Benchmark for Grounded UAV Agent-World Reasoning with MLLMs | — | 首个联合评测无人机“自身状态推理”与“外部世界状态推理”双认知能力的 MLLM 基准，含多视角图像与第一视角视频。 | 4,096 image and 2,048 video samples from 12 scenes; 45 models | [[topics/papers/无人机VLN/1-20_2607.16193_UAV-DualCog.pdf\|PDF]] · [代码](https://github.com/SmartDianLab/UAV-DualCog) · [主页](https://smartdianlab.github.io/UAV-DualCog/) |
| 2026-07 | [**MissionBench**](https://arxiv.org/abs/2607.22014)<br>Zero-Shot Mission-Level Evaluation for Aerial MLLM Agents | — | 空中 MLLM 智能体任务级零样本评测基准，只给一条高层指令，要求自主规划、导航并汇报。 | 120 missions across five simulated 3D environments and four task families; the strongest model succeeds on fewer than 35% of missions compared to 84.4% human performance | [[topics/papers/无人机VLN/1-21_2607.22014_MissionBench.pdf\|PDF]] |
| 2026-09 | [**SatNav**](https://arxiv.org/abs/2609.31507)<br>A Scalable Benchmark for Long-Horizon UAV Vision-Language Navigation from Satellite Imagery | NeurIPS 2026 (Track on Evaluations and Datasets) | 用卫星影像近似无人机俯视观测，自动构建城市级长程 UAV VLN 基准，考察长期记忆与地理推理。 | 118K episodes from 59 scenes across 18 cities, with an average trajectory length of 379 m | [[topics/papers/视觉语言导航VLN/4-28_2609.31507_SatNav.pdf\|PDF]]（VLN 专题） · [代码](https://github.com/Eku127/SatNav) · [主页](https://eku127.github.io/SatNav/) |
| 2026-10 | [**CrossFly**](https://arxiv.org/abs/2610.18381)<br>Benchmarking Interaction-Oriented Aerial Mobility across Heterogeneous Environments | — | 跨室内外长程空中移动基准 CrossFly，15K 条轨迹，并以交互就绪率评测空中 VLA 智能体。 | 15K trajectories across more than 20 reconstructed scenes; the highest success rate reaching 9.7% on unseen scenes | [[topics/papers/无人机VLN/1-23_2610.18381_CrossFly.pdf\|PDF]] |

### 仿真平台与工具链

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2024-10 | [**EmbodiedCity**](https://arxiv.org/abs/2410.09604)<br>A Benchmark Platform for Embodied Agent in Real-world City Environment | — | 基于真实城市建筑与道路构建的高逼真具身智能评测平台，含人车流仿真、多类评测任务与标准接口，并评测 LLM 的具身能力。 | — | [[topics/papers/无人机VLN/1-24_2410.09604_EmbodiedCity.pdf\|PDF]] · [代码](https://github.com/tsinghua-fib-lab/EmbodiedCity) · [主页](https://embodied-city.fiblab.net) |
| 2025-02 | [**Openfly**](https://arxiv.org/abs/2502.18041)<br>A comprehensive platform for aerial vision-language navigation | ICLR 2026 | 空中VLN平台，集成UE、GTA V、Google Earth与3DGS等渲染引擎，提供10万条轨迹基准与OpenFly-Agent。 | — | [[topics/papers/语义3DGS与具身导航/2-02_2502.18041_Openfly.pdf\|PDF]]（3DGS 专题） |
| 2026-03 | [**CARLA-Air**](https://arxiv.org/abs/2603.28032)<br>Fly Drones Inside a CARLA World -- A Unified Infrastructure for Air-Ground Embodied Intelligence | — | 在单个 UE 进程中统一 CARLA 驾驶与 AirSim 飞行的开源空地具身仿真平台，支持导航与 VLA。 | up to 18 sensor modalities | [[topics/papers/无人机VLN/1-26_2603.28032_CARLA-Air.pdf\|PDF]] · [代码](https://github.com/louiszengCN/CarlaAir) · [主页](https://carla-air.com/) |
| 2026-05 | [**FlyMirage**](https://arxiv.org/abs/2605.19600)<br>A Fully Automated Generation Pipeline for Diverse and Scalable UAV Flight Data via Generative World Model | — | 用 LLM 设计场景、世界模型生成 3DGS 场景并自动规划轨迹的空中 VLN 数据生成流水线。 | — | [[topics/papers/无人机VLN/1-27_2605.19600_FlyMirage.pdf\|PDF]] · [主页](https://lij1500.github.io/flymirage_website/) |

### 真机基准

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2025-05 | [**UAV-Flow Colosseo**](https://arxiv.org/abs/2505.15725)<br>A Real-World Benchmark for Flying-on-a-Word UAV Imitation Learning | NeurIPS 2025 | 提出 Flow 细粒度语言控制任务，发布首个真机采集的语言条件无人机模仿学习基准，含数据集、部署框架与仿真评测。 | — | [[topics/papers/无人机VLN/1-28_2505.15725_UAV-Flow-Colosseo.pdf\|PDF]] · [代码](https://github.com/buaa-colalab/UAV-Flow) · [主页](https://prince687028.github.io/UAV-Flow) |
| 2026-09 | [**DroneCATS**](https://arxiv.org/abs/2609.01404)<br>Evaluating Multimodal LLMs as Generalist Vision-Language-Action Agents for Drone Control: Commanding, Approaching, Tracking and Searching | — | 让 MLLM 独立用四种动作控制无人机，覆盖指令、接近、跟踪、搜索，并扩展到多机指挥与真机飞行评测。 | ten MLLMs; its success rate rises from 0% to 31% in simulation | [[topics/papers/无人机VLN/1-29_2609.01404_DroneCATS.pdf\|PDF]] · [代码](https://github.com/naver-ai/DroneCATS) · [主页](https://naver-ai.github.io/DroneCATS/) |

## 二、相关任务：目标搜索、问答与空地协同

和 VLN 相邻的空中具身任务：开放词汇目标搜索、具身问答、空地协同导航与搜索。

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2025-02 | [**CityEQA**](https://arxiv.org/abs/2502.12532)<br>A Hierarchical LLM Agent on Embodied Question Answering Benchmark in City Space | — | 城市空间具身问答任务与首个基准 CityEQA-EC（1,412 个人工标注任务、6 类），并提出分层智能体 PMA。 | 1,412 human-annotated tasks across six categories; PMA achieves 60.7% of human-level answering accuracy | [[topics/papers/无人机VLN/2-01_2502.12532_CityEQA.pdf\|PDF]] · [代码](https://github.com/BiluYong/CityEQA) |
| 2025-05 | [**CityAVOS**](https://arxiv.org/abs/2505.08765)<br>Towards Autonomous UAV Visual Object Search in City Space: Benchmark and Agentic Methodology | — | 城市无人机视觉目标搜索首个基准 CityAVOS（2,420 个任务、6 类目标），附智能体 PRPSearcher。 | 2,420 tasks across six object categories; +37.69% SR, +28.96% SPL | [[topics/papers/无人机VLN/2-02_2505.08765_CityAVOS.pdf\|PDF]] · [代码](https://anonymous.4open.science/r/CityAVOS-3DF8) |
| 2025-06 | [**FlySearch**](https://arxiv.org/abs/2506.02896)<br>Exploring how vision-language models explore | NeurIPS 2025 Datasets and Benchmarks track | 在 3D 户外逼真环境中做目标搜索与导航的基准，检验 VLM 主动探索能力，发现其连最简单场景也难以可靠完成。 | — | [[topics/papers/无人机VLN/2-03_2506.02896_FlySearch.pdf\|PDF]] · [代码](https://github.com/gmum/FlySearch) |
| 2025-08 | [**UAV-ON**](https://arxiv.org/abs/2508.00288)<br>A Benchmark for Open-World Object Goal Navigation with Aerial Agents | ACM MM 2025 | 开放世界无人机目标导航基准：14 个 UE 环境、1270 个带实例级语义描述的目标，以语义目标取代逐步式导航指令。 | 14 high-fidelity Unreal Engine environments; 1270 annotated target objects | [[topics/papers/无人机VLN/2-04_2508.00288_UAV-ON.pdf\|PDF]] · [代码](https://github.com/Kyaren/UAV_ON) |
| 2026-05 | [**ESARBench**](https://arxiv.org/abs/2605.01371)<br>A Benchmark for Agentic UAV Embodied Search and Rescue | — | 提出具身搜救任务与首个 MLLM 无人机搜救基准，基于真实 GIS 建四个大场景、600 个任务。 | four high-fidelity, large-scale open environments; 600 tasks | [[topics/papers/无人机VLN/2-05_2605.01371_ESARBench.pdf\|PDF]] · [代码](https://github.com/4amGodvzx/ESAR) · [主页](https://4amgodvzx.github.io/ESAR.github.io) |
| 2026-05 | [**Can Aerial VLA Models Cooperate? Evaluating Closed-Loop Air-Ground Coordination with CARLA-Air**](https://arxiv.org/abs/2605.31066) | — | 在 CARLA-Air 中设计移动平台降落与遮挡恢复护航两项诊断任务，评测空中 VLA 模型能否形成稳定的空地闭环协同。 | — | [[topics/papers/无人机VLN/2-06_2605.31066_Can-Aerial-VLA-Models-Cooperate.pdf\|PDF]] · [代码](https://github.com/louiszengCN/CarlaAir) |
| 2026-06 | [**AirGroundBench**](https://arxiv.org/abs/2606.28049)<br>Probing Spatial Intelligence in Multimodal Large Models under Heterogeneous Multi-View Embodied Collaboration | — | 异构 UAV-UGV 多视角空间智能诊断基准，含约 6.2 万道双视角 VQA 与 115 个闭环 VLN 任务。 | 11 high-fidelity simulated environments with 1,021 synchronized air-ground observation pairs; approximately 62,000 dual-view, four-option single-choice visual question answering instances; 115 closed-loop vision-language navigation episodes | [[topics/papers/无人机VLN/2-07_2606.28049_AirGroundBench.pdf\|PDF]] |
| 2026-07 | [**ActiveFly-Bench**](https://arxiv.org/abs/2607.10180)<br>Aligning Embodied Question Answering with Vision-Language-Action for Aerial Embodied Perception | — | 将主动感知拆成空中具身问答、观测行为规划与细粒度语言控制三层任务，并在真机部署验证。 | — | [[topics/papers/无人机VLN/2-08_2607.10180_ActiveFly-Bench.pdf\|PDF]] |
| 2026-09 | [**AGOS**](https://arxiv.org/abs/2609.08402)<br>Towards Embodied Air-Ground Cooperative Object Search: Benchmark, Dataset and Agentic Method | — | 城市空地协同目标搜索基准与 7.7k 条示范数据，评测 VLM 结合无人机发现与地面核验的能力。 | 7.7k episodes; the SR and SPL of Gemini-3.6-Flash increase from 8.6% to 55.7% and from 7.6% to 44.0% | [[topics/papers/无人机VLN/2-09_2609.08402_AGOS.pdf\|PDF]] |
| 2026-09 | [**AerialDojo-200K**](https://arxiv.org/abs/2609.36066)<br>A Large-Scale Benchmark Suite for Open-World Aerial Object-Goal Search | — | 开放世界空中目标搜索大规模基准套件：42 个仿真场景、20 万余任务实例，覆盖语义目标与图像目标两类设定。 | 3 times as many scenes and 18.7 times as many task instances as the largest existing benchmark; 42 simulation scenes; 205,732 task instances | [[topics/papers/无人机VLN/2-10_2609.36066_AerialDojo-200K.pdf\|PDF]] · [代码](https://github.com/fengtt42/AerialDojo) · [主页](https://fengtt42.github.io/AerialDojo/) |
| 2026-10 | [**AirGroundVLN**](https://arxiv.org/abs/2610.10421)<br>A Large-Scale Benchmark for Goal-Oriented Air-Ground Collaborative Vision-and-Language Navigation | — | 目标导向空地协同 VLN 基准：19 个 UE 场景、10,281 条 episode，附 AG-CoNAV 参考框架。 | 10,281 navigation episodes and 955 target instances across 19 Unreal Engine environments | [[topics/papers/无人机VLN/2-11_2610.10421_AirGroundVLN.pdf\|PDF]] · [代码](https://github.com/ASGO-MM-Lab/AirGroundVLN) · [主页](https://peakpang.github.io/AirGroundVLN-Project/) |

## 三、方法

按语言指令飞行的导航方法，按做法分组。

### 零样本大模型智能体

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2024-10 | [**STMR**](https://arxiv.org/abs/2410.08500)<br>Exploring Spatial Representation to Enhance LLM Reasoning in Aerial Vision-Language Navigation | — | 免训练零样本空中VLN：把指令相关语义投影成俯视语义-拓扑-度量表示（STMR）矩阵，作为提示让LLM预测动作。 | absolute success rate improvements of 26.8% and 5.8% over current state-of-the-art methods on simple and complex navigation tasks | [[topics/papers/无人机VLN/3-01_2410.08500_STMR.pdf\|PDF]] |
| 2025-05 | [**CityNavAgent**](https://arxiv.org/abs/2505.05622)<br>Aerial Vision-and-Language Navigation with Hierarchical Semantic Planning and Global Memory | ACL 2025 | 城市无人机VLN的LLM智能体：分层语义规划把长程任务拆成不同语义层级的子目标，并以拓扑图全局记忆复用历史轨迹。 | — | [[topics/papers/视觉语言导航VLN/2-10_2505.05622_CityNavAgent.pdf\|PDF]]（VLN 专题） · [代码](https://github.com/VinceOuti/CityNavAgent) |
| 2025-09 | [**See, Point, Fly**](https://arxiv.org/abs/2509.22653)<br>A Learning-Free VLM Framework for Universal Unmanned Aerial Navigation | CoRL 2025 | 把无人机VLN的动作预测视为2D空间定位：VLM在图像上迭代标注路点并估计飞行距离，转为3D位移指令，无需训练即可闭环飞行。 | DRL simulation benchmark: +63% absolute over previous best | [[topics/papers/视觉语言导航VLN/2-14_2509.22653_See-Point-Fly.pdf\|PDF]]（VLN 专题） · [代码](https://github.com/Hu-chih-yao/see-point-fly) · [主页](https://spf-web.pages.dev) |
| 2026-01 | [**AirHunt**](https://arxiv.org/abs/2601.12742)<br>Bridging VLM Semantics and Continuous Planning for Efficient Aerial Object Navigation | — | 户外开放集目标搜索：双通路异步架构衔接VLM语义推理与连续路径规划，选择性调用VLM，零样本泛化。 | — | [[topics/papers/无人机VLN/3-04_2601.12742_AirHunt.pdf\|PDF]] |
| 2026-02 | [**Fly0**](https://arxiv.org/abs/2602.15875)<br>Persistent Metric Anchoring for Zero-Shot Aerial Vision-Language Navigation | — | 解耦语义与几何：MLLM把指令定位到像素，借深度投影为持久3D目标，几何规划器生成无碰撞轨迹。 | improving the Success Rate by over 20% and reducing Navigation Error (NE) by approximately 50% in unstructured environments | [[topics/papers/无人机VLN/3-05_2602.15875_Fly0.pdf\|PDF]] · [代码](https://github.com/xuzhenxing1/Fly0) |
| 2026-03 | [**ViSA-Enhanced Aerial VLN**](https://arxiv.org/abs/2603.08007)<br>A Visual-Spatial Reasoning Enhanced Framework for Aerial Vision-Language Navigation | — | 用结构化视觉提示让VLM直接在图像平面做视觉-空间推理，三阶段协作、免训练，无需文本场景图。 | 70.3% improvement in success rate compared to the fully trained state-of-the-art (SOTA) method (CityNav) | [[topics/papers/无人机VLN/3-06_2603.08007_ViSA-Enhanced-Aerial-VLN.pdf\|PDF]] |
| 2026-04 | [**QuadAgent**](https://arxiv.org/abs/2604.02786)<br>A Responsive Agent System for Vision-Language Guided Quadrotor Agile Flight | — | 免训练异步多智能体：前台处理指令、后台前瞻推理，稀疏关键帧拓扑图作记忆，实现室内语言引导敏捷飞行。 | navigate cluttered indoor spaces at speeds up to 5 m/s | [[topics/papers/无人机VLN/3-07_2604.02786_QuadAgent.pdf\|PDF]] |
| 2026-04 | [**FineCog-Nav**](https://arxiv.org/abs/2604.16298)<br>Integrating Fine-grained Cognitive Modules for Zero-shot Multimodal UAV Navigation | CVPR 2026 Findings | 受人类认知启发，把零样本无人机VLN拆成语言、感知、记忆、想象、推理等细粒度模块，由中等规模模型分工协作。 | — | [[topics/papers/无人机VLN/3-08_2604.16298_FineCog-Nav.pdf\|PDF]] · [代码](https://github.com/SmartDianLab/FineCogNav) · [主页](https://smartdianlab.github.io/projects-FineCogNav) |
| 2026-04 | [**LookasideVLN**](https://arxiv.org/abs/2604.17190)<br>Direction-Aware Aerial Vision-and-Language Navigation | CVPR 2026 | 利用指令中的方向线索：旁视图编码地标及其方向关系，结合地标知识库与MLLM智能体规划，效率更高。 | — | [[topics/papers/无人机VLN/3-09_2604.17190_LookasideVLN.pdf\|PDF]] |
| 2026-06 | [**CLOSER-VLN**](https://arxiv.org/abs/2606.28397)<br>Closed-Loop Self-Verified Retrieval-Augmented Reasoning for Aerial Vision-Language Navigation | — | 闭环自验证检索增强推理：分层推理器给候选动作，验证器评估可靠性，失败时才检索记忆范例纠正。 | CLOSER-VLN achieves 32.01% SR and 21.28% SPL on the test-unseen split (CityNav) | [[topics/papers/无人机VLN/3-10_2606.28397_CLOSER-VLN.pdf\|PDF]] |
| 2026-07 | [**Parse, Search, and Confirmation**](https://arxiv.org/abs/2607.11529)<br>Training-Free Aerial Vision-and-Dialog Navigation with Chain-of-Thought Reasoning and Structured Spatial Memory | CVPR 2026 | 免训练空中视觉对话导航：LLM解析对话为方向与目的地线索，搜索/确认两段思维链配合结构化空间记忆。 | — | [[topics/papers/无人机VLN/3-11_2607.11529_Parse-Search-and-Confirmation.pdf\|PDF]] · [代码](https://github.com/QY6616/PSC-AVDN) |
| 2026-09 | [**AirAnchor**](https://arxiv.org/abs/2609.08442)<br>Bridging Local and Global Spatial Information for Zero-Shot Aerial Vision-and-Language Navigation | — | 以空间锚点桥接在线局部空间表示与持久全局物体记忆，二者共同输入导航智能体，实现零样本空中VLN。 | — | [[topics/papers/无人机VLN/3-12_2609.08442_AirAnchor.pdf\|PDF]] |
| 2026-10 | [**Beyond Trial-and-Error**](https://arxiv.org/abs/2610.41446)<br>A Geospatial-Guided Active Reasoning Framework for Robust Aerial Vision-and-Language Navigation | — | GeoReasoner：先推导地理区域先验，再假设驱动主动探索，最后一致性验证后停止，取代被动试错式搜索。 | — | [[topics/papers/无人机VLN/3-13_2610.41446_Beyond-Trial-and-Error.pdf\|PDF]] |

### 训练的VLM/VLA

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2025-06 | [**GRaD-Nav++**](https://arxiv.org/abs/2506.14009)<br>Vision-Language Model Enabled Visual Drone Navigation with Gaussian Radiance Fields and Differentiable Dynamics | IEEE RA-L 2026 | 轻量级机载无人机VLA框架，在3DGS逼真模拟器中用可微强化学习训练，执行自然语言指令飞行，并以MoE动作头提升泛化。 | — | [[topics/papers/语义3DGS与具身导航/2-05_2506.14009_GRaD-Nav++.pdf\|PDF]]（3DGS 专题） · [代码](https://github.com/Qianzhong-Chen/grad_nav) · [主页](https://qianzhong-chen.github.io/gradnavpp.github.io/) |
| 2025-09 | [**SINGER**](https://arxiv.org/abs/2509.18610)<br>An Onboard Generalist Vision-Language Navigation Policy for Drones | — | 面向无人机的机载开放词汇语言导航策略：用语言嵌入的高斯泼溅飞行模拟器生成大规模数据，训练轻量端到端视觉运动策略并零样本迁移实机。 | — | [[topics/papers/语义3DGS与具身导航/1-06_2509.18610_SINGER.pdf\|PDF]]（3DGS 专题） |
| 2025-12 | [**Aerial Vision-Language Navigation with a Unified Framework for Spatial, Temporal and Embodied Reasoning**](https://arxiv.org/abs/2512.08639) | — | 仅用单目RGB的统一空中VLN：把导航视为下一token预测，多任务联合训练空间感知、轨迹推理与动作预测。 | — | [[topics/papers/无人机VLN/3-16_2512.08639_Aerial-Vision-Language-Navigation-with-a.pdf\|PDF]] · [代码](https://github.com/return-sleep/AeroAct) |
| 2026-02 | [**AutoFly**](https://arxiv.org/abs/2602.09657)<br>Vision-Language-Action Model for UAV Autonomous Navigation in the Wild | ICLR 2026 | 面向仅有粗略方位指引的野外导航，端到端VLA加伪深度编码器与两阶段训练，并构建含真实数据的自主导航数据集。 | AutoFly achieves a 3.9% higher success rate compared to state-of-the-art VLA baselines | [[topics/papers/无人机VLN/3-17_2602.09657_AutoFly.pdf\|PDF]] · [代码](https://github.com/xiaolousun/AutoFly-VLA) · [主页](https://xiaolousun.github.io/AutoFly/) |
| 2026-03 | [**AerialVLA**](https://arxiv.org/abs/2603.14363)<br>A Vision-Language-Action Model for UAV Navigation via Minimalist End-to-End Control | ECCV 2026 | 极简端到端无人机VLA（后更名AeroVLA）：双视角感知+机载传感器生成的模糊方向提示，直接输出3自由度控制与降落信号。 | TravelUAV unseen: nearly 3x the success rate of leading baselines | [[topics/papers/视觉语言导航VLN/3-31_2603.14363_AerialVLA.pdf\|PDF]]（VLN 专题） · [代码](https://github.com/XuPeng23/AeroVLA) |
| 2026-06 | [**DynFly**](https://arxiv.org/abs/2606.31654)<br>Dynamic-Aware Continuous Trajectory Generation for UAV Vision-Language Navigation in Urban Environments | — | 在B样条控制点空间用Spline-DiT流匹配生成连续轨迹，加入速度、加速度、航向等动力学监督，可接入现有框架。 | On the Test Unseen Full split, DynFly improves the strongest baseline by 4.69 NDTW, 2.40 SDTW, 2.14 SR points and 4.87 OSR points, while reducing NE by 4.51 m. | [[topics/papers/无人机VLN/3-19_2606.31654_DynFly.pdf\|PDF]] |
| 2026-07 | [**FSD-VLN**](https://arxiv.org/abs/2607.08359)<br>Fast-Slow Dual-System Modeling for Aerial Long-Horizon Vision-Language Navigation | — | 快慢双系统：慢流用预训练VLM提供语义先验，快流用扩散Transformer异步输出低延迟平滑飞行指令。 | FSD-VLN achieves up to 2X higher navigation success rates on unseen scenes than SOTA methods, while cutting single-action inference delay and total task runtime by over 50% | [[topics/papers/无人机VLN/3-20_2607.08359_FSD-VLN.pdf\|PDF]] |
| 2026-08 | [**FreqNav**](https://arxiv.org/abs/2608.00970)<br>Stage-Wise Frequency Routing for Object-Oriented Aerial Vision-Language Navigation | — | 面向搜索并精准降落的空中VLN，按导航阶段在低频布局与高频细节间重分配视觉token，扩散头输出轨迹。 | approximately 3x faster inference | [[topics/papers/无人机VLN/3-21_2608.00970_FreqNav.pdf\|PDF]] |
| 2026-08 | [**Deliberate Before You Fly**](https://arxiv.org/abs/2608.04825)<br>Vision-Guided Spatial Deliberation for UAV See-and-Reach Navigation | — | 面向目标已在视野内的看见即到达任务，在航点生成前做方向锚定-空间诊断-机动决策推理，并改进停止判断。 | DBFly improves the success rate over the SOTA baseline by an average of 25.07 percentage points | [[topics/papers/无人机VLN/3-22_2608.04825_Deliberate-Before-You-Fly.pdf\|PDF]] · [代码](https://github.com/xuefanfu/DBFly) · [主页](https://xuefanfu.github.io/DBFly-Page) |
| 2026-08 | [**From Semantic Grounding to Decision Optimization: A Unified Framework for Long-Horizon UAV Vision-Language Navigation**](https://arxiv.org/abs/2608.09564) | ACM MM 2026 | 语义到决策统一框架：物体级语义增强、相关性感知的历史聚合，以及结合局部最优认知与GRPO的拓扑决策。 | — | [[topics/papers/无人机VLN/3-23_2608.09564_From-Semantic-Grounding-to-Decision.pdf\|PDF]] |
| 2026-08 | [**DreamFly**](https://arxiv.org/abs/2608.12308)<br>Causal Memory and Receding-Horizon Diffusion Planning for Aerial Vision-Language Navigation | — | 基于Dream-VLA的扩散式空中VLN：因果历史记忆、规划K步执行1步的滚动时域规划，以及LiteStop停止判断。 | DreamFly achieves 32.04%/29.46% SR and 28.22%/23.54% SPL on the test-seen/test-unseen splits (OpenFly) | [[topics/papers/无人机VLN/3-24_2608.12308_DreamFly.pdf\|PDF]] |

### 世界模型与想象

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2026-05 | [**WorldVLN**](https://arxiv.org/abs/2605.15964)<br>Autoregressive World Action Model for Aerial Vision-Language Navigation | — | 首个空中VLN自回归世界-动作模型：预测短时潜在世界状态并直接解码航点，用Action-aware GRPO强化微调。 | 12%+ success-rate gains over Vision-Language-Action baselines | [[topics/papers/无人机VLN/3-25_2605.15964_WorldVLN.pdf\|PDF]] · [代码](https://github.com/EmbodiedCity/WorldVLN.code) · [主页](https://embodiedcity.github.io/WorldVLN/) |
| 2026-05 | [**ImagineUAV**](https://arxiv.org/abs/2606.01205)<br>Aerial Vision-Language Navigation via World-Action Modeling and Kinodynamic Planning | — | 级联世界-动作模型：视频扩散想象指令条件的未来观测，从中提取6-DoF运动，再由动力学规划器生成无碰撞轨迹。 | — | [[topics/papers/无人机VLN/3-26_2606.01205_ImagineUAV.pdf\|PDF]] |
| 2026-06 | [**WorldFly**](https://arxiv.org/abs/2606.06147)<br>A World-Model-Based Vision-Language-Action Model for UAV Navigation | — | 基于世界模型的 VLA：双分支耦合流匹配同时生成未来视频与导航动作，用“空间想象”应对城市峡谷中的严重遮挡与视角突变。 | — | [[topics/papers/无人机VLN/3-27_2606.06147_WorldFly.pdf\|PDF]] |
| 2026-07 | [**AeroAct**](https://arxiv.org/abs/2607.14997)<br>Action-Centered World-Action Models for Language-Conditioned Quadrotor Flight | — | 以动作为中心的世界-动作模型：视频扩散Transformer由视觉历史与语言预测轨迹动作块，并在真实四旋翼上验证。 | — | [[topics/papers/无人机VLN/3-28_2607.14997_AeroAct.pdf\|PDF]] |
| 2026-08 | [**AirForesight**](https://arxiv.org/abs/2608.12835)<br>Current-to-Future Spatial Map Imagination with Cross-Space Planning Consistency for UAV-VLN | ACM MM 2026 | 当前到未来的空间地图想象：从多视角观测学习结构化当前地图，经因果注意力推理未来地图，并用跨空间规划一致性损失约束下一航点预测。 | — | [[topics/papers/无人机VLN/3-29_2608.12835_AirForesight.pdf\|PDF]] |
| 2026-09 | [**ForeFly**](https://arxiv.org/abs/2609.33581)<br>A Dual-Horizon World Action Model for Aerial Vision-Language Navigation | — | 双时域潜在世界动作模型：同时预测近端未来（局部连续）与路线关键的远期未来（长程引导），并用前瞻引导动作精炼（FGAR）修正动作。 | — | [[topics/papers/无人机VLN/3-30_2609.33581_ForeFly.pdf\|PDF]] · [代码](https://github.com/kunhuiW/ForeFly) |
| 2026-10 | [**SearchWorld**](https://arxiv.org/abs/2610.09335)<br>Spatial Value-Grounded Imagination for UAV Object Search via World Models | — | 无人机目标搜索的循环状态空间世界模型：维护BEV探索/障碍记忆，用空间价值引导的想象rollout改进策略。 | On UAV-ON, SearchWorld improves the success rate to 23.8% (19.5% for the strongest published agent) and raises oracle success to 35.5% | [[topics/papers/无人机VLN/3-31_2610.09335_SearchWorld.pdf\|PDF]] |

### 地图、记忆与空间表示

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2025-04 | [**GeoNav**](https://arxiv.org/abs/2504.09587)<br>Empowering MLLMs with dual-scale geospatial reasoning for language-goal aerial navigation | Pattern Recognition 2026 | 多模态智能体动态构建全局认知地图与局部场景图双尺度表示，配合空间思维链由粗到细定位语言目标。 | GeoNav surpasses the current SOTA up to 18.4% in success rate (CityNav) | [[topics/papers/无人机VLN/3-32_2504.09587_GeoNav.pdf\|PDF]] |
| 2025-12 | [**HETT**](https://arxiv.org/abs/2512.14222)<br>History-Enhanced Two-Stage Transformer for Aerial Vision-and-Language Navigation | — | 由粗到细两阶段Transformer：先融合地标与历史预测粗目标，再细粒度视觉修正动作，并用历史网格地图记忆。 | — | [[topics/papers/无人机VLN/3-33_2512.14222_HETT.pdf\|PDF]] |
| 2025-12 | [**LongFly**](https://arxiv.org/abs/2512.22010)<br>Long-Horizon UAV Vision-and-Language Navigation with Spatiotemporal Context Integration | — | 面向长程无人机VLN的时空上下文建模：槽位式历史图像压缩、轨迹时空编码与提示引导多模态融合，把冗余历史变成紧凑表示用于航点预测。 | LongFly outperforms state-of-the-art UAV VLN baselines by 7.89% in success rate and 6.33% in success weighted by path length | [[topics/papers/无人机VLN/3-34_2512.22010_LongFly.pdf\|PDF]] |
| 2026-01 | [**NeuroKalman**](https://arxiv.org/abs/2602.11183)<br>Mitigating Error Accumulation in Continuous Navigation via Memory-Augmented Kalman Filtering | ICML 2026 | 把逐步航点预测建模为递归贝叶斯状态估计：基于运动动力学的先验预测加上以注意力检索历史锚点的似然校正，抑制连续导航中的状态漂移。 | — | [[topics/papers/无人机VLN/3-35_2602.11183_NeuroKalman.pdf\|PDF]] |
| 2026-01 | [**APEX**](https://arxiv.org/abs/2602.00551)<br>A Decoupled Memory-based Explorer for Asynchronous Aerial Object Goal Navigation | — | 分层异步空中目标导航：VLM零样本构建3D吸引/探索/障碍地图作记忆，RL决策模块执行，开放词汇检测确认目标。 | +4.2% SR and +2.8% SPL over the previous state of the art on UAV-ON | [[topics/papers/无人机VLN/3-36_2602.00551_APEX.pdf\|PDF]] · [代码](https://github.com/4amGodvzx/apex) |
| 2026-03 | [**OmniVLN**](https://arxiv.org/abs/2603.17351)<br>Omnidirectional 3D Perception and Token-Efficient LLM Reasoning for Visual-Language Navigation across Air and Ground Platforms | — | 空地通用零样本VLN：激光雷达+全景视觉构建五层动态场景图，转成智能体中心八分体表示供LLM省token推理。 | spatial referring accuracy from 77.27% to 93.18%; prompt tokens reduced by up to 61.7%; navigation success improved by up to 11.68% over a flat-list baseline | [[topics/papers/无人机VLN/3-37_2603.17351_OmniVLN.pdf\|PDF]] · [代码](https://github.com/qiyuanlanniao/OmniVLN) |
| 2026-09 | [**Map the Possibilities**](https://arxiv.org/abs/2609.05841)<br>Spatial Belief Fields for Language-Goal Aerial Navigation | — | 用语言条件的空间信念场表示目标位置的多假设分布，随观测更新后选出与指令最一致的度量航点，避免过早坍缩为单点预测。 | On the Test Unseen split, our method improves SR from 25.91% to 32.29% and SPL from 19.63% to 30.43%. | [[topics/papers/无人机VLN/3-38_2609.05841_Map-the-Possibilities.pdf\|PDF]] |
| 2026-09 | [**AeroBelief**](https://arxiv.org/abs/2609.08164)<br>Dual-Layer Semantic-Spatial Belief Mapping for Aerial Object Goal Navigation | — | 双层语义-空间信念地图：直觉层累积场景级语义线索驱动探索，证据层保存目标证据用于接近与确认，把瞬时的 VLM 输出变成持久空间引导。 | SR 21.61%, OSR 35.57%, SPL 10.62 on UAV-ON | [[topics/papers/无人机VLN/3-39_2609.08164_AeroBelief.pdf\|PDF]] |

### 强化学习与自我改进

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2025-05 | [**FlightGPT**](https://arxiv.org/abs/2505.12835)<br>Towards Generalizable and Interpretable UAV Vision-and-Language Navigation with Vision-Language Models | EMNLP 2025 | 基于VLM的无人机VLN：先SFT，再用目标精度、推理质量与格式的复合奖励做GRPO，并以CoT提升可解释性。 | CityNav unseen: +9.22% SR over the strongest baseline | [[topics/papers/视觉语言导航VLN/3-10_2505.12835_FlightGPT.pdf\|PDF]]（VLN 专题） · [代码](https://github.com/Uavln/FlightGPT) |
| 2025-11 | [**OpenVLN**](https://arxiv.org/abs/2511.06182)<br>Open-world Aerial Vision-Language Navigation | — | 数据高效的开放世界空中VLN：重构 RL 框架、用基于规则的策略在少量数据下微调 VLM，并引入基于价值奖励的长程轨迹规划器。 | performance gains of up to 4.34% in Success Rate, 6.19% in Oracle Success Rate, and 4.07% in Success weighted by Path Length over baseline methods (TravelUAV) | [[topics/papers/无人机VLN/3-41_2511.06182_OpenVLN.pdf\|PDF]] |
| 2026-03 | [**FreeFly-Thinking**](https://arxiv.org/abs/2603.07181)<br>Aligning Chain-of-Thought Reasoning with Continuous UAV Navigation | — | 在 OpenFly 城市场景上构建带自然语言思维链的无人机导航数据，先 SFT 再强化微调，让端到端 VLN 模型具备显式推理过程。 | — | [[topics/papers/无人机VLN/3-42_2603.07181_FreeFly-Thinking.pdf\|PDF]] |
| 2026-06 | [**EG-GRPO**](https://arxiv.org/abs/2606.02313)<br>Towards Precise Intent-Aligned VLA Aerial Navigation via Expert-Guided GRPO | — | 面向复杂人类意图指令的VLA空中导航强化微调：EG-GRPO用少量专家数据增强在线rollout，并并行化仿真推理。 | EG-GRPO improves the success rate to 2.13x that of the SFT baseline, while improving intent alignment performance by 60.9%; rollout time reduced by 43.5% | [[topics/papers/无人机VLN/3-43_2606.02313_EG-GRPO.pdf\|PDF]] |
| 2026-06 | [**AgenticRL**](https://arxiv.org/abs/2606.03963)<br>Agentic Reinforcement Learning with Self-Refinement for Complex UAV Navigation | — | 多角色智能体生成可执行奖励、训练 PPO 策略后诊断其行为失败，据此给出修改指令并重写奖励，闭环迭代提升无人机导航。 | Reward refinement increases mean simulation success from 37.2% to 96.4%, while the resulting policies achieve a collective real-world success rate of 90.0% and a sim-to-real accuracy of 93.4%. | [[topics/papers/递归自我改进RSI/1-16_2606.03963_AgenticRL.pdf\|PDF]]（RSI 专题） |
| 2026-08 | [**AeroDPO**](https://arxiv.org/abs/2608.07557)<br>Unleashing Lightweight UAV Navigation with High-Fidelity Perception and Automated Preference Optimization | — | 无人机碰撞时回滚仿真状态，以出错动作为负样本、特权干预合成的避碰动作为正样本，自动构建偏好数据做 DPO。 | AeroDPO boosts success rates to 49.16% on unmapped scenarios while drastically suppressing collision rates | [[topics/papers/递归自我改进RSI/1-21_2608.07557_AeroDPO.pdf\|PDF]]（RSI 专题） · [代码](https://github.com/XuPeng23/AeroDPO) |
| 2026-08 | [**RefineFly**](https://arxiv.org/abs/2608.09467)<br>Failure-Aware Post-Training for Aerial Vision-Language Navigation | — | 端到端UAV-VLA的失败感知RL后训练：token级PPO、两阶段场景课程中的动态失败记忆，以及参考正则防漂移。 | improving success rate over AerialVLA by 3.12 to 8.37 percentage points with a total rollout budget of about 30% of the training-set size (TravelUAV) | [[topics/papers/无人机VLN/3-46_2608.09467_RefineFly.pdf\|PDF]] |
| 2026-10 | [**X-Fly**](https://arxiv.org/abs/2610.21450)<br>Learning to Reach and Stop in Full-Chunk Aerial Vision-Language Navigation | — | 整块执行动作的空中VLN：Recovery DAgger标注恢复与停止，再用Flow-GRPO联合优化动作块与停止策略。 | X-Fly reaches 74.18% SR on test-seen and 51.73% on test-unseen | [[topics/papers/无人机VLN/3-47_2610.21450_X-Fly.pdf\|PDF]] · [主页](https://juliusju572.github.io/x-fly/) |

### 机载与真机部署

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2025-06 | [**VLFly**](https://arxiv.org/abs/2506.10756)<br>Grounded Vision-Language Navigation for UAVs with Open-Vocabulary Goal Understanding | — | 单目语言引导飞行：LLM重构指令为结构化提示，VLM检索目标图像，航点规划器输出连续速度指令。 | — | [[topics/papers/无人机VLN/3-48_2506.10756_VLFly.pdf\|PDF]] |
| 2025-11 | [**HALO**](https://arxiv.org/abs/2511.17497)<br>High-Altitude Language-Conditioned Monocular Aerial Exploration and Navigation | — | 单目相机加 GPS/IMU 的高空实时度量-语义建图与探索系统，能规划信息路径完成自然语言指定的多项任务，所有模块机载运行。 | up to 68% higher competitive ratio in terms of the distance traveled; real-world missions covering up to 24,600 sq. m. area at an altitude of 40 m | [[topics/papers/无人机VLN/3-49_2511.17497_HALO.pdf\|PDF]] · [代码](https://github.com/KumarRobotics/HALO) · [主页](https://tyuezhan.github.io/halo/) |
| 2025-12 | [**VLA-AN**](https://arxiv.org/abs/2512.15258)<br>An Efficient and Onboard Vision-Language-Action Framework for Aerial Navigation in Complex Environments | — | 机载高效空中导航VLA：3DGS高保真数据、三阶段渐进训练、轻量动作模块加几何安全校正与部署优化。 | 8.3x improvement in inference throughput; maximum single-task success rate of 98.1% | [[topics/papers/无人机VLN/3-50_2512.15258_VLA-AN.pdf\|PDF]] |
| 2026-03 | [**OnFly**](https://arxiv.org/abs/2603.10682)<br>Onboard Zero-Shot Aerial Vision-Language Navigation toward Safety and Efficiency | — | 完全机载的零样本空中VLN：双智能体解耦目标生成与进度监控，配合语义-几何校验和滚动时域规划兼顾安全效率。 | OnFly improves task success from 26.4% to 67.8%, compared with the strongest state-of-the-art baseline | [[topics/papers/无人机VLN/3-51_2603.10682_OnFly.pdf\|PDF]] · [代码](https://github.com/Robotics-STAR-Lab/OnFly) |
| 2026-08 | [**VLN on the Fly**](https://arxiv.org/abs/2609.20191)<br>An Onboard Vision-Language Navigation Stack for Aerial Robots | IMAV 2026 | 模块化机载VLN栈：量化VLM把指令定位到图像网格，深度提升为3D目标，B样条规划加RL策略跟踪执行。 | the stack reaches the target in 13 of 15 trials with 5.72 cm mean goal error and 39.3% average GPU utilization | [[topics/papers/无人机VLN/3-52_2609.20191_VLN-on-the-Fly.pdf\|PDF]] · [代码](https://github.com/peDrontonio/VLNontheFly) · [主页](https://vln-on-the-fly.github.io/) |
| 2026-09 | [**VLM-MPPI**](https://arxiv.org/abs/2609.18451)<br>Grounding Natural Language in Behaviorally Diverse Trajectories for Aerial Navigation | — | 并行六个行为条件MPPI规划器生成多样候选轨迹，投影到第一视角图像上由VLM挑选，室内真机验证。 | achieving 100% task success in our evaluated scenarios | [[topics/papers/无人机VLN/3-53_2609.18451_VLM-MPPI.pdf\|PDF]] |
| 2026-10 | [**LightVLN**](https://arxiv.org/abs/2610.05024)<br>Efficient Aerial Vision-and-Language Navigation with Compact Memory and History-Guided Local Aggregation | — | 轻量空中VLN：0.5B语言骨干，每帧历史压成1个token、当前观测压到32个token，可机载实时运行。 | 50.93% Test-Seen and 36.14% Test-Unseen SR on OpenFly; 25.83% SR on AerialVLN-S Val-Seen; 14.61 Hz model inference onboard | [[topics/papers/无人机VLN/3-54_2610.05024_LightVLN.pdf\|PDF]] |
| 2026-10 | [**AeroDASH**](https://arxiv.org/abs/2610.25407)<br>Asynchronous Vision-Language-Action Control for Continuous UAV Flight | — | 异步VLA连续飞行：B样条策略输出连续参考，轨迹融合剔除推理期间过期前缀，再用执行感知GRPO微调。 | On the UAV-Flow test set, AeroDASH achieves a success rate of 76.56%, exceeding OpenVLA-UAV and AeroDASH w/o GRPO by 38.1 and 20.1 percentage points | [[topics/papers/无人机VLN/3-55_2610.25407_AeroDASH.pdf\|PDF]] |
| 2026-10 | [**OpenFlyV2**](https://arxiv.org/abs/2610.39287)<br>An onboard vision-language-action model for aerial perception and navigation | — | 统一机载VLA：共享视觉-语言表示兼顾语义理解、指代感知、空间推理与连续控制，Orin NX上10Hz输出航点块。 | 48% navigation success rate across four real-world environments; action chunks generated onboard at 10 Hz on Jetson Orin NX | [[topics/papers/无人机VLN/3-56_2610.39287_OpenFlyV2.pdf\|PDF]] · [代码](https://github.com/Ideal-ljl/AeroBrain) |

### 其他

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2026-10 | [**TGIT**](https://arxiv.org/abs/2610.10635)<br>Speaking the Navigator's Language: Trajectory-Grounded Instruction Translation for Frozen Aerial VLN Agents | — | 在冻结的空中VLN导航器前加轨迹落地的指令翻译器，把用户简短意图指令改写成导航器可执行的指令。 | Weak-input SR raised to 37.93%; zero-shot transfer to real human instructions 11.33% -> 32.51% (frozen OpenFly navigator) | [[topics/papers/无人机VLN/3-57_2610.10635_TGIT.pdf\|PDF]] |

## 四、同时支持无人机的通用导航模型

不专为无人机设计，但训练或部署覆盖了空中平台的跨本体导航模型。

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2025-09 | [**NavFoM**](https://arxiv.org/abs/2509.12129)<br>Embodied Navigation Foundation Model | — | 跨具身、跨任务导航基础模型NavFoM，用800万样本覆盖四足、无人机、轮式与车辆，统一VLN、搜索、跟踪与驾驶。 | — | [[topics/papers/视觉语言导航VLN/3-19_2509.12129_NavFoM.pdf\|PDF]]（VLN 专题） · [主页](https://pku-epic.github.io/NavFoM-Web/) |
| 2026-07 | [**Robostral Navigate**](https://arxiv.org/abs/2607.20785) | — | 8B单目RGB VLM，以在当前画面“指点”下一目标位置输出航点，配合前缀缓存打包训练与RL，可跨轮式/腿式/空中部署。 | R2R-CE 77.4% SR; RxR-CE 75.1% SR | [[topics/papers/视觉语言导航VLN/3-34_2607.20785_Robostral-Navigate.pdf\|PDF]]（VLN 专题） |

## 五、综述

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2025-01 | [**UAVs Meet LLMs**](https://arxiv.org/abs/2501.02341)<br>Overviews and Perspectives Toward Agentic Low-Altitude Mobility | Information Fusion, Volume 122, 2025 | 梳理 LLM 与无人机融合：系统组成、多模态数据资源、关键任务与应用，及 agentic UAV 路线图。 | — | [[topics/papers/无人机VLN/5-01_2501.02341_UAVs-Meet-LLMs.pdf\|PDF]] · [代码](https://github.com/Hub-Tian/UAVs_Meet_LLMs) |
| 2026-04 | [**Vision-Language Navigation for Aerial Robots: Towards the Era of Large Language Models**](https://arxiv.org/abs/2604.07705) | — | 空中 VLN 综述：区分单指令与对话式两种范式，按五类架构归纳方法，并评估现有数据集、仿真平台与指标的不足。 | — | [[topics/papers/无人机VLN/5-02_2604.07705_Vision-Language-Navigation-for-Aerial.pdf\|PDF]] |
| 2026-04 | [**Vision-and-Language Navigation for UAVs: Progress, Challenges, and a Research Roadmap**](https://arxiv.org/abs/2604.13654) | — | UAV-VLN 综述：从任务定义到 VLM/VLA/世界模型方法的分类，梳理模拟器、数据集与评测指标，并提出研究路线图。 | — | [[topics/papers/无人机VLN/5-03_2604.13654_Vision-and-Language-Navigation-for-UAVs.pdf\|PDF]] |
| 2026-09 | [**UAVs Meet Embodied Intelligence**](https://arxiv.org/abs/2609.18326)<br>Bridging Human Intents and Flying Dynamics Via Harnessing Physical-Digital AI Agents | — | 提出无人机具身智能 5+5 框架，系统回顾具身感知、世界模型、规划、VLN、操作与协同等方向的进展与挑战。 | — | [[topics/papers/无人机VLN/5-04_2609.18326_UAVs-Meet-Embodied-Intelligence.pdf\|PDF]] |

## 六、各基准使用的场景

对第一、二节里的 40 个基准、数据集和平台，逐篇读了正文、数据集构建、模拟器和附录部分，记录它们的场景从哪来、有多少、多大、怎么划分、是否上过真机。下面每个格子都能在论文里找到原句，原句和所在位置见 [[topics/无人机VLN场景依据|场景依据]]。"—"表示论文没写。

### 6.1 闭环导航类基准

智能体在环境里实际移动、按步决策的基准，按首版日期排序。

| 基准 | 任务 | 场景来源 / 引擎 | 场景数 · 面积 | 地域 | 轨迹长度 | 动作空间 | 未见场景 | 真机 |
|---|---|---|---|---|---|---|---|---|
| AVDN（2022） | 对话导航 | 从 xView 卫星图裁剪俯视画面的模拟器 | 训练 350 张、未见 30 + 65 张卫星图；平均 1.2 km² | xView 城乡（未列城市） | 平均 287 m | 连续航点 (x, y, h) | 与训练区相距 100 km 以上 | 无 |
| AerialVLN（2023） | VLN | UE4 + AirSim 合成城市 | 25 个；平均半径约 3.9 km | — | 平均 661.8 m | 离散 8 动作（4 DoF） | 8 个 | 无 |
| CityNav（2024） | VLN | SensatUrban 点云（Potree 渲染，对齐 OpenStreetMap） | 34 个；4.65 km² | 英国剑桥、伯明翰 | 典型约 200 m | 离散 6 动作 | 4 + 6 个 | — |
| EmbodiedCity（2024） | 平台（多任务） | UE5.3 + AirSim；参照地图和街景用 Blender 手工建模 | 1 个商业区；2.8 × 2.4 km | 北京 | — | 连续 | — | — |
| AeroVerse（2024） | 多任务 | UE4 + AirSim 载入 UrbanScene3D 重建场景 | 4 个 | 上海、深圳、校园、住宅区 | 平均 82 步 | 离散 8 动作 | 未说明 | 称有初步部署，未给数量 |
| OpenUAV（2024） | 目标导向 VLN | UE4 + AirSim；部分城市场景迁自 CARLA | 22 个 | 城市、城镇、乡村、森林、沙漠 | 起点到目标 50–400 m | 连续 6-DoF 轨迹 | 2 个，另有未见物体 | — |
| CityEQA（2025） | 具身问答 | EmbodiedCity | 1 个 | — | 起点距目标 200 m 内 | 移动到指定位姿 | 零样本评测 | — |
| OpenFly（2025） | VLN | UE4/UE5、GTA V、Google Earth、3DGS 实景 | 18 个；UE 部分超 100 km² | 上海、广州、仿洛杉矶、Berkeley 等，5 个校园 | 平均 99.1 m | 离散（前进 3/6/9 m 等） | 3 个 | 23 个真实户外场景实飞 |
| CognitiveDrone（2025） | 细粒度飞控 | Gazebo 竞速赛道 | — | — | — | 连续 4D 速度 | 训练 / 测试 | — |
| CityAVOS（2025） | 目标搜索 | EmbodiedCity 改造 | 6 个；单个 0.56–8.28 公顷 | — | 平均 174.7 m | 未列出 | 无划分 | — |
| UAV-Flow（2025） | 细粒度飞控 | 真机实飞 + UE 校园仿真 | 3 个真实校园（5.02 km²）+ 1 个仿真 | 三所大学（未具名） | 多数 20 m 以内 | 连续 6-DoF | — | 30,692 条真机轨迹；真机部署仅定性演示 |
| BEDI（2025） | 多任务 | UE4.27 + AirSim；真实图像和视频 | 3 个虚拟 + 2 个真实动态场景 | — | 按决策步计 | 结构化动作字典 | — | 真实视频（开环） |
| FlySearch（2025） | 目标搜索 | UE5 程序化生成森林和城市 | 2 类环境，可无限生成；城市约 4 × 4 km | 美式城市 + 森林 | 最多 10 / 20 步 | 连续相对位移 | 森林训练、城市评测 | — |
| UAV-ON（2025） | 目标搜索 | UE + AirSim | 14 个 | 村庄、城镇、城市、森林、雪山等类型 | 目标在 50 units 内 | 离散原语 + 连续幅度 | 4 个新环境 | — |
| HaL-13k / AeroDuo（2025） | 双机协同 VLN | OpenUAV 平台环境 | 14 个 | — | — | 连续航点或速度 | 2 个，另有未见物体 | — |
| IndoorUAV（2025） | 室内 VLN | Habitat（MP3D、Gibson、HM3D、Replica） | 1,075 个室内 | — | VLN 平均 21.6 m | 离散 4-DoF，两种步长 | seen / unseen 环境 | — |
| AirNav（2026） | VLN | CityFlight（与 CityNav 同一套点云） | — | 英国剑桥、伯明翰 | 按长度分三档 | 离散 4 动作，固定高度 | 新环境 | Tello 实机 200 个任务 |
| HUGE-Bench（2026） | 任务级 VLA | Isaac Sim + 实拍重建的 3DGS–mesh 数字孪生 | 4 个；约 6.45 km² | 办公楼、街区、沼泽农田、施工道路 | — | 连续速度 / 状态 | 留出地标 | 场景实拍，评测在仿真 |
| CARLA-Air（2026） | 平台 | UE4.26 单进程集成 CARLA + AirSim | CARLA 自带地图 | — | — | 连续 | — | — |
| 城市空域导航基准（2026，2604.07973） | 目标导向导航 | EmbodiedCity（UE + AirSim） | 1 座城市 | 基于真实城市（未点名） | 平均约 203 m | 离散，含升降 | — | 无 |
| ESARBench（2026） | 搜救 | UE5 + AirSim；用 DEM 和卫星图生成真实地形 | 4 个；边长 2–5 km | 鳌太线、罗布泊、K2、大鹏半岛 | — | 未统一规定 | 按难度分档 | — |
| FlyMirage（2026） | 数据生成 | 世界模型（Marble）生成 3DGS | 1,100 个 | — | 平均 4.83 m | 连续 | 在 ScanNet++ 和真实环境评测 | 室内、室外各 10 次 |
| AirGroundBench（2026） | 空地协同 | UE + AirSim | 11 个 | 城市 / 野外两类 | — | 离散 | 零样本评测 | — |
| CARLA-Air 协同评测（2026） | 空地协同 | CARLA-Air | — | CARLA 地图 | 按时长 60 / 90 s | 沿用各基线接口 | 零样本评测 | 无 |
| FLIGHT（2026） | 细粒度飞控 | UnrealZoo 场景 | — | 城市、工业、乡村 | 平均 154.5 m（细粒度子集） | 连续 6-DoF | — | — |
| ActiveFly-Bench（2026） | 具身问答 + 飞控 | UE（Beijing、Citypark）+ 真机 | 2 个仿真 + 2 个真实 | — | 多数 10–40 m | 连续 5-DoF | 80% / 20% 划分 | 约 3.8k 条真实轨迹，真机闭环 |
| MissionBench（2026） | 任务级评测 | UE5 + Cosys-AirSim | 5 个 | 森林、社区、城市、草原等 | 中位 93 m | 方向原语 + 连续幅度 | 留出 80 个任务 | 无 |
| DroneCATS（2026） | 大模型直接控制 | AirSim 3 张图 + Isaac Sim 1 个 + 真实房间 2 个 | — | — | — | 离散，带连续参数 | 无训练集 | Tello 实飞 100 个 episode |
| AGOS（2026） | 空地协同搜索 | CARLA-Air（CARLA towns） | 6 个城镇 | — | — | 网格航点，固定 80 m 高 | 未见城镇 Town03 | 无 |
| SatNav（2026） | 长程 VLN | 卫星图 + OpenStreetMap 自建环境 | 59 个；813 km² | 五大洲 18 个城市 | 平均 379 m | 离散 4 动作，固定高度 | 3 个新城市的 3 个场景 | Matrice 4D 实飞 18 个 episode |
| AerialDojo-200K（2026） | 目标搜索 | UE + ProjectAirSim | 42 个 | 城市、自然、基础设施、灾害 21 类 | 5–100 m | 离散 4-DoF | 21 个 OOD 场景 | — |
| AirGroundVLN（2026） | 空地协同 VLN | UE + AirSim | 19 个 | 城市、城镇、工业区 | UAV 平均 79.0 m | 每步预测航点 | 2 个 | — |
| CrossFly（2026） | 室内外 VLN | Isaac Sim + 手持扫描重建的 3DGS | 23 个 | 室内外连通 | 多数 20 m 以内 | 连续 6-DoF | 5 个 | 无 |

### 6.2 静态问答类基准

不让智能体动，而是拿无人机拍到的图像或视频出题。

| 基准 | 数据来源 | 地域 | 规模 |
|---|---|---|---|
| UrbanVideo-Bench（2025） | 真机实拍视频 + EmbodiedCity、AerialVLN 仿真 | 深圳、肇庆（真实），北京（仿真） | 1,547 段视频，5.2k 道选择题 |
| Open3D-VQA（2025） | 真实航拍 + UrbanScene3D + EmbodiedCity 数字孪生 | 深圳、北京、武汉、罗马尼亚 | 1,168 张图，73,324 个问答 |
| SpatialSky-Bench（2025） | UAVScenes 数据集（图像、LiDAR、位姿） | — | 约 1,000 个问答 |
| LinkS²Bench（2026） | 真实无人机视频 + Google Earth 卫星图 | 全球 16 座城市 | 1,500 段视频，17,903 个问答 |
| SpatialUAV（2026） | 复用 BEDI、MAVREC 等 5 个真实数据集 | — | 4,331 个实例 |
| SIS-Bench（2026） | 复用 AirScape、UrbanVideo-Bench、VisDrone 视频 | 深圳（部分） | 4,856 道选择题 |
| UAV-DualCog（2026） | 扩展 AirSim 平台；3DGS 真实场景试点 | — | 4,096 个图像 + 2,048 个视频样本 |

### 6.3 几点观察

1. **场景主要来自游戏引擎，AirSim 一家独大。** 40 个里 18 个完全在仿真器里合成（17 个用游戏引擎，CognitiveDrone 用 Gazebo），12 个混合了多种来源；有 24 个用到 AirSim 或它的分支（Cosys-AirSim、ProjectAirSim、Colosseum）。场景直接来自真实三维数据的不多：CityNav 和 AirNav（共用同一套 SensatUrban 点云）、AeroVerse（载入 UrbanScene3D 重建场景）、用实拍 3DGS 的 HUGE-Bench 和 CrossFly，以及 OpenFly 的一部分；ESARBench 则用真实高程和卫星图生成地形。
2. **场景被反复复用。**
   - EmbodiedCity 的北京城区被 CityEQA、CityAVOS、城市空域导航基准、ActiveFly-Bench、UrbanVideo-Bench、Open3D-VQA 复用。
   - AerialVLN 的场景出现在 OpenFly、ActiveFly-Bench 和 UrbanVideo-Bench 里。
   - OpenUAV 被 HaL-13k 沿用；CARLA 的城镇地图被 OpenUAV、CARLA-Air、AGOS 和 CARLA-Air 协同评测用到；UrbanVideo-Bench 的视频又被 LinkS²Bench 和 SIS-Bench 复用。

   这意味着在一个基准上训练、在另一个基准上测"未见场景"时，场景可能其实见过。
3. **未见场景很少。** 多数基准只留 2–10 个未见场景（OpenUAV 2、AirGroundVLN 2、HaL-13k 2、OpenFly 3、SatNav 3、CrossFly 5、AerialVLN 8、CityNav 10），泛化结论受少数几个场景影响很大。场景数明显多的只有室内的 IndoorUAV（1,075）、生成式的 FlyMirage（1,100）、AerialDojo-200K（42，其中 21 个 OOD）、SatNav（59 个，18 座城市），以及可以程序化无限生成的 FlySearch。
4. **真实地理覆盖窄。** 写了真实地名的大多集中在少数几处：英国两座城市（CityNav、AirNav）、北京（EmbodiedCity 系）、深圳和肇庆（UrbanVideo-Bench 系）、上海和广州（OpenFly）。覆盖最广的是 SatNav：五大洲 18 个城市，但它用卫星图近似无人机视角，并且固定了飞行高度。
5. **尺度和动作空间很难横向比较。**
   - 轨迹长度从几米（FlyMirage 平均 4.83 m，UAV-Flow 多数 20 m 内）到数百米（SatNav 平均 379 m，AerialVLN 平均 661.8 m）。
   - 动作空间一半是离散步长（以 AerialVLN 的"前进 5 m、转 15°、升降 2 m"为代表），一半是连续的 6-DoF 位姿或速度。AirNav、SatNav、AGOS 还固定了飞行高度。
   - 大多数论文没写飞行高度。写了的有 CityNav（最高 200 m）、OpenFly（0–210 m）、AGOS（固定 80 m）。
6. **大多是静态场景。** 天气、光照或行人车流明确可调的只有 AerialVLN、AeroVerse、CARLA-Air 系、ESARBench、EmbodiedCity 系、FlySearch 等少数几个。HUGE-Bench、MissionBench 和 CityEQA 的作者把缺少动态因素列为局限，AirNav 的作者指出没覆盖季节变化和极端光照。
7. **真机验证规模小。** 有定量真机闭环评测的只有 OpenFly（23 个场景）、AirNav（200 个任务）、DroneCATS（100 个 episode）、FlyMirage（20 次）、SatNav（18 个 episode）和 ActiveFly-Bench；AeroVerse 称做过初步部署但没给数量。UAV-Flow 是唯一以大规模真机数据（3 万条轨迹）为主体的基准，但真机部署只做了定性演示。室内场景也少：IndoorUAV、CrossFly、FlyMirage、DroneCATS、ActiveFly-Bench 和 EmbodiedCity 涉及室内，AirNav 的实机测试有一半在室内。

### 6.4 对自建基准的启示

- **未见场景要多、要按场景切分。** 现有基准常只留几个未见场景；参数化生成场景的方法正适合补这一点（参考 FlyMirage、FlySearch 的生成方式）。
- **和现有场景库去重。** 如果训练或测试用到 AerialVLN、EmbodiedCity、CARLA towns、SensatUrban、UrbanScene3D 这类常见场景库，要写清楚，并检查和其他基准有没有重叠。
- **把容易缺的设定写全：** 飞行高度范围、轨迹长度分布、动作空间、动态因素（天气、光照、行人车流）、未见场景的定义。
- **留一份真实测试。** 可以像 HUGE-Bench、CrossFly 那样用实拍 3DGS 数字孪生加物理仿真，也可以像 OpenFly、AirNav 那样做小规模真机实飞，用来衡量仿真到真实的差距。

## 附：检索中看到、没有放进正文的

标题已对照 arXiv 核对，没有下载 PDF。多数和正文同类，或者语言指令只是次要部分（目标跟踪、协同感知、通用无人机多模态评测等），想扩充时可以从这里挑：

**方法**

- [ASMA: An Adaptive Safety Margin Algorithm for Vision-Language Drone Navigation via Scene-Aware Control Barrier Functions](https://arxiv.org/abs/2409.10283)（2024-09）
- [UAV-VLRR: Vision-Language Informed NMPC for Rapid Response in UAV Search and Rescue](https://arxiv.org/abs/2503.02465)（2025-03）
- [Aerial Vision-and-Language Navigation with Grid-based View Selection and Map Construction](https://arxiv.org/abs/2503.11091)（2025-03）
- [UAV-VLN: End-to-End Vision Language guided Navigation for UAVs](https://arxiv.org/abs/2504.21432)（2025-04）
- [LogisticsVLN: Vision-Language Navigation For Low-Altitude Terminal Delivery Based on Agentic UAVs](https://arxiv.org/abs/2505.03460)（2025-05）
- ["Hi AirStar, Guide Me to the Badminton Court."](https://arxiv.org/abs/2507.04430)（2025-07）
- [SkyVLN: Vision-and-Language Navigation and NMPC Control for UAVs in Urban Environments](https://arxiv.org/abs/2507.06564)（2025-07）
- [SA-GCS: Semantic-Aware Gaussian Curriculum Scheduling for UAV Vision-Language Navigation](https://arxiv.org/abs/2508.00390)（2025-08）
- [RAVEN: Resilient Aerial Navigation via Open-Set Semantic Memory and Behavior Adaptation](https://arxiv.org/abs/2509.23563)（2025-09）
- [SoraNav: Adaptive UAV Task-Centric Navigation via Zeroshot VLM Reasoning](https://arxiv.org/abs/2510.25191)（2025-10）
- [Aerial World Model for Long-horizon Visual Generation and Navigation in 3D Space](https://arxiv.org/abs/2512.21887)（2025-12）
- [USS-Nav: Unified Spatio-Semantic Scene Graph for Lightweight UAV Zero-Shot Object Navigation](https://arxiv.org/abs/2602.00708)（2026-01）
- [VLN-Pilot: Large Vision-Language Model as an Autonomous Indoor Drone Operator](https://arxiv.org/abs/2602.05552)（2026-02）
- [SpatialFly: Implicit 3D Prior-Guided Visual Reparameterization for Continuous UAV Vision-and-Language Navigation](https://arxiv.org/abs/2603.21046)（2026-03）
- [LLM-Enabled Low-Altitude UAV Natural Language Navigation via Signal Temporal Logic Specification Translation and Repair](https://arxiv.org/abs/2603.27583)（2026-03）
- [HTNav: A Hybrid Navigation Framework with Tiered Structure for Urban Aerial Vision-and-Language Navigation](https://arxiv.org/abs/2604.08883)（2026-04）
- [AeroBridge-TTA: Test-Time Adaptive Language-Conditioned Control for UAVs](https://arxiv.org/abs/2604.19059)（2026-04）
- [LiteVLA-H: Dual-Rate Vision-Language-Action Inference for Onboard Aerial Guidance and Semantic Perception](https://arxiv.org/abs/2605.00884)（2026-04）
- [Uni-LaViRA: Language-Vision-Robot Actions Translation for Unified Embodied Navigation](https://arxiv.org/abs/2605.27582)（2026-05）
- [AgenticDiffusion: Multi-View Reasoning with View-Conditioned Diffusion Planning for Vision-Based UAV Navigation](https://arxiv.org/abs/2606.04111)（2026-06）
- [ScoutVLA: UAV-Centric Active Perception via a Dual-Expert VLA Model for Open-World Embodied Question Answering](https://arxiv.org/abs/2606.14772)（2026-06）
- [See-and-Reach: Precise Vision-Language Navigation for UAVs within the Field of View](https://arxiv.org/abs/2606.20045)（2026-06）
- [Exp2VLA: Enabling Vision-Language-Action for Drone Navigation from Expert Demonstrations](https://arxiv.org/abs/2607.03146)（2026-07）
- [No Training, Better Flights: Test-Time Scaled VLMs for UAV Navigation](https://arxiv.org/abs/2607.19288)（2026-07）
- [RACO: Reliability-Aware Coarse-Goal Optimization for Inspection-Oriented UAV Vision-Language Navigation](https://arxiv.org/abs/2608.22678)（2026-08）
- [Spatial-Semantic Reasoning using Large Language Models for Efficient UAV Search Operations](https://arxiv.org/abs/2608.28270)（2026-08）
- [TADreamer: Zero-Shot Language-Guided 3D Navigation for Terrestrial-Aerial Bimodal Robots via Video Imagination](https://arxiv.org/abs/2609.19824)（2026-09）
- [WareFly-VLA: A Vision-Language-Action Framework for UAV Navigation and Human Tracking in Smart Warehouses](https://arxiv.org/abs/2610.08526)（2026-10）
- [BGC-Nav: Cross-Altitude Multi-UAV Collaborative Navigation via Belief-Guided Coupling](https://arxiv.org/abs/2610.14702)（2026-10）
- [SP-Guide: Enhancing Aerial Vision-Language Navigation with Spatial Priors](https://arxiv.org/abs/2610.32697)（2026-10）
- [Extended LASMP: Language Aided Subset Sampling Based Motion Planner for Drone Navigation](https://arxiv.org/abs/2610.34054)（2026-10）

**基准与平台**

- [Towards Natural Language-Guided Drones: GeoText-1652 Benchmark with Spatial Relation Matching](https://arxiv.org/abs/2311.12751)（2023-11）
- [LogisticsVLN: Vision-Language Navigation For Low-Altitude Terminal Delivery Based on Agentic UAVs](https://arxiv.org/abs/2505.03460)（2025-05）
- ["Hi AirStar, Guide Me to the Badminton Court."](https://arxiv.org/abs/2507.04430)（2025-07）
- [U2UData+: A Scalable Swarm UAVs Autonomous Flight Dataset for Embodied Long-horizon Tasks](https://arxiv.org/abs/2509.00055)（2025-08）
- [AirCopBench: A Benchmark for Multi-drone Collaborative Embodied Perception and Reasoning](https://arxiv.org/abs/2511.11025)（2025-11）
- [UAVBench: An Open Benchmark Dataset for Autonomous and Agentic AI UAV Systems via LLM-Generated Flight Scenarios](https://arxiv.org/abs/2511.11252)（2025-11）
- [AirSim360: A Panoramic Simulation Platform within Drone View](https://arxiv.org/abs/2512.02009)（2025-12）
- [Embodied4C: Measuring What Matters for Embodied Vision-Language Navigation](https://arxiv.org/abs/2512.18028)（2025-12）
- [MM-UAVBench: How Well Do Multimodal Large Language Models See, Think, and Plan in Low-Altitude UAV Scenarios?](https://arxiv.org/abs/2512.23219)（2025-12）
- [AIR-VLA: Vision-Language-Action Systems for Aerial Manipulation](https://arxiv.org/abs/2601.21602)（2026-01）
- [SkySim: A ROS2-based Simulation Environment for Natural Language Control of Drone Swarms using Large Language Models](https://arxiv.org/abs/2602.01226)（2026-02）
- [AirSimAG: A High-Fidelity Simulation Platform for Air-Ground Collaborative Robotics](https://arxiv.org/abs/2603.23079)（2026-03）
- [DeTrack: A Benchmark and Altitude-Aware Dual World Model for Drone-embodied Tracking](https://arxiv.org/abs/2605.17451)（2026-05）
- [DisasterBench: A Multimodal Benchmark for UAV-Based Disaster Response in Complex Environments](https://arxiv.org/abs/2606.06217)（2026-06）
- [MultiUAV-Plat: An LLM-Oriented Platform, Benchmark and Framework for Multi-UAV Collaborative Task Planning](https://arxiv.org/abs/2606.31073)（2026-06）
- [Lingjing: A Simulation Testbed for Multi-Agent Embodied Tasks in Open-Ended Cities](https://arxiv.org/abs/2608.08045)（2026-08）
- [AeroGround: A Comprehensive Benchmark for Aerial-Ground Collaborative Reasoning](https://arxiv.org/abs/2608.14721)（2026-08）
- [Air-Ground Collaborative Vision-and-Language Navigation via Shared Bird's-Eye Maps](https://arxiv.org/abs/2609.03483)（2026-09）
- [NavGen: Visual Generative Models as a Scalable Data Engine for Embodied 3D Navigation](https://arxiv.org/abs/2609.30770)（2026-09）

**综述**

- [Large Language Models for UAVs: Current State and Pathways to the Future](https://arxiv.org/abs/2405.01745)（2024-05）
- [UAVs Meet Agentic AI: A Multidomain Survey of Autonomous Aerial Intelligence and Agentic UAVs](https://arxiv.org/abs/2506.08045)（2025-06）
- [Next-Generation LLM for UAV: From Natural Language to Autonomous Flight](https://arxiv.org/abs/2510.21739)（2025-10）
- [Large Language Model-Assisted UAV Operations and Communications: A Multifaceted Survey and Tutorial](https://arxiv.org/abs/2602.19534)（2026-02）
- [Vision Language Action (VLA) Models for Unmanned Aerial Robotics and Bimanual Manipulation: A Review](https://arxiv.org/abs/2607.06706)（2026-07）
