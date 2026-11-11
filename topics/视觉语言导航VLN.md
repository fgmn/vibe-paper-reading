---
title: 视觉语言导航（VLN）
tags: [topic]
anchor_arxiv: ["2305.16986", "2407.12366", "2610.10787"]
paper_count: 135
updated: 2026-11-11
---

# 视觉语言导航（VLN）

> [!info] 这份清单怎么来的
> 以 NavGPT 系列（[NavGPT](https://arxiv.org/abs/2305.16986)、[NavGPT-2](https://arxiv.org/abs/2407.12366)、[NavGPT-3](https://arxiv.org/abs/2610.10787)）为线索，收集视觉语言导航（按语言指令在环境里走到目标）的相关工作，共 135 篇，分五节。
> - 检索时间 2026-11-04，来源是 Hugging Face 论文搜索、arXiv API、GitHub 上的 awesome-VLN 列表和网页搜索。VLN 论文很多，这里收的是各方向的代表作和 2025–2026 年的新工作，不是穷尽列表。
> - 每篇都对照 arXiv 页面核对过标题和首版日期；"做了什么"依据的摘要原句都在摘要里找到了，"摘要里的关键数字"一栏的每个数字也都出现在摘要中。
> - 发表信息只在 arXiv 备注、项目主页或官方代码仓库写明时才填，"—"表示只有预印本或没找到。"环境"里，离散指 R2R 这类在预设节点间跳转，连续指 VLN-CE 这类在仿真里自由移动。
> - 每节按首版日期排序。"做了什么"是 Claude 根据摘要写的一句话，读原文时请核对。
> - PDF 在 `topics/papers/视觉语言导航VLN/`，文件名开头的"节号-序号"和表格顺序一致（2026-11-09 补充的 NavSpace、VTInstructor 编号接在第四节末尾，为 4-34、4-35；2026-11-11 补充的 Compass 1 为 3-40）；下载的是当时 arXiv 上的最新版本，只存在本地，不进 git。

## 建议的阅读顺序

从任务定义读到最新的大模型系统：

1. [R2R](https://arxiv.org/abs/1711.07280)：定义任务：在 Matterport3D 真实室内全景里按自然语言指令走到目的地，VLN 的起点。
2. [VLN-CE](https://arxiv.org/abs/2004.02857)：把 VLN 搬到连续环境：没有预设导航图、不能瞬移，现在的大模型工作多在 R2R-CE / RxR-CE 上评测。
3. [Speaker-Follower](https://arxiv.org/abs/1806.02724)：用"说话者"模型合成指令做数据增强，并引入全景动作空间，后面很多工作沿用。
4. [HAMT](https://arxiv.org/abs/2110.13309)：用 Transformer 编码完整的历史全景观测，取代循环网络的记忆。
5. [DUET](https://arxiv.org/abs/2202.11742)：边走边建拓扑图，用双尺度图 Transformer 兼顾局部细节和全局规划，离散 VLN 的常用强基线。
6. [ETPNav](https://arxiv.org/abs/2304.03047)：连续环境里预测航点、建拓扑图再规划，R2R-CE / RxR-CE 上的经典基线。
7. [ScaleVLN](https://arxiv.org/abs/2307.15644)：用 HM3D 和 Gibson 场景合成 490 万条指令-轨迹对，R2R 测试集单次成功率到 80%。
8. [NavGPT](https://arxiv.org/abs/2305.16986)：系列第一篇：把视觉观测转成文字，让 GPT-4 零样本、逐步显式推理来导航。
9. [MapGPT](https://arxiv.org/abs/2401.07314)：把在线构建的拓扑地图写进提示，让零样本智能体有全局视野。
10. [NaVid](https://arxiv.org/abs/2402.15852)：只看单目 RGB 视频流的视频大模型，逐步输出动作，可以迁移到真机。
11. [NavGPT-2](https://arxiv.org/abs/2407.12366)：把视觉对齐到冻结的大语言模型并接上导航策略网络，保留语言推理，同时追平 VLN 专用模型。
12. [Uni-NaVid](https://arxiv.org/abs/2412.06224)：用一个视频 VLA 统一指令跟随、物体搜索、问答和人体跟踪等导航任务。
13. [StreamVLN](https://arxiv.org/abs/2507.05240)：流式视频大模型导航：快速出动作，慢速更新并压缩历史记忆，降低延迟。
14. [DualVLN](https://arxiv.org/abs/2512.08186)：双系统：视觉语言模型慢速预测像素航点，轻量扩散策略快速生成轨迹；InternNav 开源的 InternVLA-N1 有这一配置。
15. [NavGPT-3](https://arxiv.org/abs/2610.10787)：把推理大模型和 VLA 动作策略接进类操作系统的运行时，RxR-CE 成功率 90.43，与人类的 90.4 持平。

| 节 | 篇数 |
|---|---|
| [[#一、NavGPT 系列]] | 3 |
| [[#二、零样本大模型智能体与分层系统]] | 26 |
| [[#三、训练出来的大模型导航模型]] | 40 |
| [[#四、任务、基准与数据]] | 35 |
| [[#五、经典方法（大模型之前）]] | 31 |

## 一、NavGPT 系列

从零样本 GPT-4 推理，到微调视觉语言模型，再到把推理模型和动作策略接起来的运行时。

| 日期 | 论文 | 发表 | 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2023-05 | [**NavGPT**](https://arxiv.org/abs/2305.16986)<br>Explicit Reasoning in Vision-and-Language Navigation with Large Language Models | AAAI 2024 | 离散 | 纯LLM（GPT-4）指令跟随导航智能体：把视觉观测转成文本，零样本逐步显式推理，完成子目标分解、地标识别与进度追踪。 | — | [[topics/papers/视觉语言导航VLN/1-01_2305.16986_NavGPT.pdf\|PDF]] · [代码](https://github.com/GengzeZhou/NavGPT) |
| 2024-07 | [**NavGPT-2**](https://arxiv.org/abs/2407.12366)<br>Unleashing Navigational Reasoning Capability for Large Vision-Language Models | ECCV 2024 | 离散 | 把视觉内容对齐到冻结LLM并接入导航策略网络，在保留语言化导航推理的同时追平VLN专用模型。 | — | [[topics/papers/视觉语言导航VLN/1-02_2407.12366_NavGPT-2.pdf\|PDF]] · [代码](https://github.com/GengzeZhou/NavGPT-2) |
| 2026-10 | [**NavGPT-3**](https://arxiv.org/abs/2610.10787)<br>Harnessing Context in a Hierarchical Navigation Runtime | — | 连续 | 连接推理LLM与VLA动作策略的Harness及类操作系统运行时：推理、执行、监控作为线程调度、可中断切换，RxR-CE首达人类水平。 | R2R-CE 81.51 SR; RxR-CE 90.43 SR (human 90.4), 78.47 nDTW | [[topics/papers/视觉语言导航VLN/1-03_2610.10787_NavGPT-3.pdf\|PDF]] · [代码](https://github.com/metacognitionai/NavGPT-3) · [主页](https://metacognitionai.github.io/NavGPT3/) |

## 二、零样本大模型智能体与分层系统

不专门训练导航模型，直接用大语言模型或视觉语言模型做决策；包括地图提示、推理链、多专家讨论、想象未来和 agent harness。

| 日期 | 论文 | 发表 | 类型 / 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2023-08 | [**A²Nav**](https://arxiv.org/abs/2308.07997)<br>$A^2$Nav: Action-Aware Zero-Shot Robot Navigation by Exploiting Vision-and-Language Ability of Foundation Models | — | 分层系统与harness<br>连续 | 用GPT-3把复杂指令分解为带动作要求的物体导航子任务，再由动作感知策略逐个执行，实现无需路径-指令标注的零样本VLN。 | — | [[topics/papers/视觉语言导航VLN/2-01_2308.07997_A2Nav.pdf\|PDF]] |
| 2023-08 | [**March in Chat**](https://arxiv.org/abs/2308.10141)<br>Interactive Prompting for Remote Embodied Referring Expression | ICCV 2023 | 分层系统与harness<br>离散 | 面向REVERIE高层指令，智能体在导航中与LLM实时对话、动态规划，并借房间-物体感知模块ROASP按当前观测调整计划。 | — | [[topics/papers/视觉语言导航VLN/2-02_2308.10141_March-in-Chat.pdf\|PDF]] · [代码](https://github.com/YanyuanQiao/MiC) |
| 2023-09 | [**DiscussNav**](https://arxiv.org/abs/2309.11382)<br>Discuss Before Moving: Visual Language Navigation via Multi-expert Discussions | — | 多智能体/讨论<br>离散 | 仿专家会诊：导航智能体每步移动前与多个能力各异的大模型专家讨论指令理解、环境感知和完成度估计，实现零样本VLN。 | — | [[topics/papers/视觉语言导航VLN/2-03_2309.11382_DiscussNav.pdf\|PDF]] · [代码](https://github.com/LYX0501/DiscussNav) |
| 2024-01 | [**MapGPT**](https://arxiv.org/abs/2401.07314)<br>Map-Guided Prompting with Adaptive Path Planning for Vision-and-Language Navigation | ACL 2024 | 地图/记忆提示<br>离散 | 把在线构建的语言化拓扑地图写进GPT-4/GPT-4V提示，并加入基于地图的自适应多步路径规划，让零样本智能体具备全局视野。 | R2R ~10% and REVERIE ~12% SR improvements (zero-shot SOTA) | [[topics/papers/视觉语言导航VLN/2-04_2401.07314_MapGPT.pdf\|PDF]] · [代码](https://github.com/chen-judge/MapGPT) · [主页](https://chen-judge.github.io/MapGPT/) |
| 2024-06 | [**InstructNav**](https://arxiv.org/abs/2406.04882)<br>Zero-shot System for Generic Instruction Navigation in Unexplored Environment | CoRL 2024 | 推理与思维链<br>连续 | 以动态导航链DCoN统一多类指令的LLM规划，并用多源价值图把语言计划转成可执行轨迹，首次零样本完成R2R-CE并上真机。 | zero-shot R2R-CE (first); ObjNav +10.48%, DDN +86.34% over previous SOTA | [[topics/papers/视觉语言导航VLN/2-05_2406.04882_InstructNav.pdf\|PDF]] · [代码](https://github.com/LYX0501/InstructNav) |
| 2024-07 | [**AO-Planner**](https://arxiv.org/abs/2407.05890)<br>Affordances-Oriented Planning using Foundation Models for Continuous Vision-Language Navigation | AAAI 2025 | 分层系统与harness<br>连续 | 用SAM分割可行走地面作视觉可供性提示，让LLM选候选路点并规划低层路径，再由PathAgent做高层决策，零样本完成连续VLN。 | R2R-CE/RxR-CE zero-shot SOTA (8.8% SPL improvement); distilled waypoint predictor 47% SR | [[topics/papers/视觉语言导航VLN/2-06_2407.05890_AO-Planner.pdf\|PDF]] · [代码](https://github.com/chen-judge/AO-Planner) |
| 2024-09 | [**Open-Nav**](https://arxiv.org/abs/2409.18794)<br>Exploring Zero-Shot Vision-and-Language Navigation in Continuous Environment with Open-Source LLMs | ICRA 2025 | 推理与思维链<br>连续 | 用开源LLM做连续环境零样本VLN：时空思维链拆分指令理解、进度估计与决策，并注入细粒度物体与空间知识，仿真与真机验证。 | — | [[topics/papers/视觉语言导航VLN/2-07_2409.18794_Open-Nav.pdf\|PDF]] · [代码](https://github.com/YanyuanQiao/Open-Nav) |
| 2024-12 | [**CA-Nav**](https://arxiv.org/abs/2412.10137)<br>Constraint-Aware Zero-Shot Vision-Language Navigation in Continuous Environments | TPAMI 2025 | 推理与思维链<br>连续 | 把零样本VLN-CE重构为带约束的子指令逐个完成：子指令管理器按完成约束追踪进度，价值地图模块在线生成目标，并部署到真机。 | SR +12% (R2R-CE) and +13% (RxR-CE) over previous best, val-unseen | [[topics/papers/视觉语言导航VLN/2-08_2412.10137_CA-Nav.pdf\|PDF]] · [代码](https://github.com/Chenkehan21/CA-Nav-code) · [主页](https://chenkehan21.github.io/CA-Nav-project/) |
| 2025-03 | [**SmartWay**](https://arxiv.org/abs/2503.10069)<br>Enhanced Waypoint Prediction and Backtracking for Zero-Shot Vision-and-Language Navigation | IROS 2025 | 零样本LLM智能体<br>连续 | 增强路点预测器配合具备历史推理与回溯能力的MLLM导航器，实现零样本VLN-CE，并在Turtlebot 4真机上验证。 | — | [[topics/papers/视觉语言导航VLN/2-09_2503.10069_SmartWay.pdf\|PDF]] · [代码](https://github.com/sxyxs/SmartWay-Code) · [主页](https://sxyxs.github.io/smartway/) |
| 2025-05 | [**CityNavAgent**](https://arxiv.org/abs/2505.05622)<br>Aerial Vision-and-Language Navigation with Hierarchical Semantic Planning and Global Memory | ACL 2025 | 分层系统与harness<br>空中 | 城市无人机VLN的LLM智能体：分层语义规划把长程任务拆成不同语义层级的子目标，并以拓扑图全局记忆复用历史轨迹。 | — | [[topics/papers/视觉语言导航VLN/2-10_2505.05622_CityNavAgent.pdf\|PDF]] · [代码](https://github.com/VinceOuti/CityNavAgent) |
| 2025-07 | [**OpenNav**](https://arxiv.org/abs/2507.18033)<br>Open-World Navigation with Multimodal Large Language Models | IROS 2025 | 地图/记忆提示<br>户外/城市 | 借MLLM的代码生成能力调用开放词汇感知模型，组合出2D鸟瞰价值图并合成轨迹点，实现开放世界零样本语言导航，并在Husky真机验证。 | — | [[topics/papers/视觉语言导航VLN/2-11_2507.18033_OpenNav.pdf\|PDF]] · [主页](https://trailab.github.io/OpenNav-website/) |
| 2025-09 | [**GC-VLN**](https://arxiv.org/abs/2509.10454)<br>Instruction as Graph Constraints for Training-free Vision-and-Language Navigation | CoRL 2025 | 其他<br>连续 | 把指令分解成含路点与物体节点的有向无环图，检索空间约束库构建图约束并求解路点位置，实现连续环境无训练VLN并上真机。 | — | [[topics/papers/视觉语言导航VLN/2-12_2509.10454_GC-VLN.pdf\|PDF]] · [代码](https://github.com/bagh2178/GC-VLN) · [主页](https://bagh2178.github.io/GC-VLN/) |
| 2025-09 | [**DreamNav**](https://arxiv.org/abs/2509.11197)<br>A Trajectory-Based Imaginative Framework for Zero-Shot Vision-and-Language Navigation | ICRA 2026 | 世界模型/想象<br>连续 | 零样本VLN-CE：校正自我视角观测，以轨迹级规划替代点级动作，并用想象预测器做前瞻式长程规划，仅需自我视角输入。 | up to +7.49% SR and +18.15% SPL over the strongest egocentric baseline | [[topics/papers/视觉语言导航VLN/2-13_2509.11197_DreamNav.pdf\|PDF]] · [代码](https://github.com/Yunheng-Wang/DreamNav) · [主页](https://yunheng-wang.github.io/dreamnav-public.github.io/) |
| 2025-09 | [**See, Point, Fly**](https://arxiv.org/abs/2509.22653)<br>A Learning-Free VLM Framework for Universal Unmanned Aerial Navigation | CoRL 2025 | 零样本LLM智能体<br>空中 | 把无人机VLN的动作预测视为2D空间定位：VLM在图像上迭代标注路点并估计飞行距离，转为3D位移指令，无需训练即可闭环飞行。 | DRL simulation benchmark: +63% absolute over previous best | [[topics/papers/视觉语言导航VLN/2-14_2509.22653_See-Point-Fly.pdf\|PDF]] · [代码](https://github.com/Hu-chih-yao/see-point-fly) · [主页](https://spf-web.pages.dev) |
| 2025-10 | [**LaViRA**](https://arxiv.org/abs/2510.19655)<br>Language-Vision-Robot Actions Translation for Zero-Shot Vision Language Navigation in Continuous Environments | ICRA 2026 | 分层系统与harness<br>连续 | 把动作分解为语言（高层规划）、视觉（中层定位）、机器人（低层控制）三级动作，分别调用不同规模MLLM完成零样本VLN-CE。 | — | [[topics/papers/视觉语言导航VLN/2-15_2510.19655_LaViRA.pdf\|PDF]] · [代码](https://github.com/NJU-R-L-Group-Embodied-Lab/lavira-code) · [主页](https://robo-lavira.github.io/lavira-zs-vln/) |
| 2026-01 | [**SpatialNav**](https://arxiv.org/abs/2601.06806)<br>Leveraging Spatial Scene Graphs for Zero-Shot Vision-and-Language Navigation | — | 地图/记忆提示<br>多种 | 允许智能体先探索环境并构建空间场景图SSG，再结合以自身为中心的空间地图、罗盘对齐视觉表示与远程物体定位做零样本导航。 | — | [[topics/papers/视觉语言导航VLN/2-16_2601.06806_SpatialNav.pdf\|PDF]] · [代码](https://github.com/IMNearth/Spatial-X) · [主页](https://imnearth.github.io/Spatial-X/) |
| 2026-01 | [**Spatial-VLN**](https://arxiv.org/abs/2601.12766)<br>Zero-Shot Vision-and-Language Navigation With Explicit Spatial Perception and Exploration | — | 多智能体/讨论<br>连续 | 针对门交互、多房间与模糊指令三类空间难题，用门/区域专家增强感知，并让并行LLM专家推理，分歧时触发查询-探索机制。 | — | [[topics/papers/视觉语言导航VLN/2-17_2601.12766_Spatial-VLN.pdf\|PDF]] · [主页](https://yueluhhxx.github.io/Spatial-VLN-web/) |
| 2026-03 | [**ProFocus**](https://arxiv.org/abs/2603.05530)<br>Proactive Perception and Focused Reasoning in Vision-and-Language Navigation | CVPR 2026 | 多智能体/讨论<br>离散 | 无训练的LLM-VLM协作框架：编排智能体发现缺失视觉信息并指挥感知智能体主动查看，再用分支多样MCTS筛选高价值历史路点聚焦推理。 | — | [[topics/papers/视觉语言导航VLN/2-18_2603.05530_ProFocus.pdf\|PDF]] |
| 2026-03 | [**SpatialAnt**](https://arxiv.org/abs/2603.26837)<br>Autonomous Zero-Shot Robot Navigation via Active Scene Reconstruction and Visual Anticipation | — | 世界模型/想象<br>连续 | 机器人先自主预探索重建场景，恢复度量尺度，并基于噪声点云渲染未来观测做视觉预期与反事实推理，剪除与指令矛盾的路径。 | R2R-CE 66% SR, RxR-CE 50.8% SR; real-world 52% SR | [[topics/papers/视觉语言导航VLN/2-19_2603.26837_SpatialAnt.pdf\|PDF]] · [代码](https://github.com/IMNearth/Spatial-X) · [主页](https://imnearth.github.io/Spatial-X/) |
| 2026-04 | [**Three-Step Nav**](https://arxiv.org/abs/2604.26946)<br>A Hierarchical Global-Local Planner for Zero-Shot Vision-and-Language Navigation | AISTATS 2026 | 推理与思维链<br>连续 | 三视角协议：先“向前看”提取全局地标粗规划，再“看当下”对齐下一子目标，最后“向后看”审视整条轨迹纠偏再停止，即插即用免训练。 | — | [[topics/papers/视觉语言导航VLN/2-20_2604.26946_Three-Step-Nav.pdf\|PDF]] · [代码](https://github.com/ZoeyZheng0/3-step-Nav) |
| 2026-06 | [**AgenticNav**](https://arxiv.org/abs/2606.10577)<br>Zero-Shot Vision-and-Language Navigation as a Tool-Calling Harness | — | 分层系统与harness<br>连续 | 把零样本VLN-CE视为VLM与环境间的工具调用接口：动作、像素深度与记忆回溯都做成可调用工具，VLM直接在RGB图上选目标像素。 | R2R-CE 76% SR, 66.50% SPL | [[topics/papers/视觉语言导航VLN/2-21_2606.10577_AgenticNav.pdf\|PDF]] · [主页](https://agenticnav-vln.github.io/) |
| 2026-07 | [**Embodied Agents Take Control**](https://arxiv.org/abs/2607.26148)<br>Minimal-Interface Zero-Shot Agents Rival Industrial-Scale Policies in Vision-and-Language Navigation | — | 零样本LLM智能体<br>连续 | 在仅给单目RGB与原语动作的极简接口下评测14个前沿多模态模型，让推理模型直接操控每一步，最佳智能体逼近或超过人类测试者。 | R2R-CE 88% SR (with SLAM) | [[topics/papers/视觉语言导航VLN/2-22_2607.26148_Embodied-Agents-Take-Control.pdf\|PDF]] · [代码](https://github.com/jianzhou0420/MIP) · [主页](https://jianzhou0420.github.io/mip/) |
| 2026-07 | [**HAM-VLN**](https://arxiv.org/abs/2607.29600)<br>Harnessing Hierarchical Agentic Memory for Zero-Shot Vision-and-Language Navigation | — | 地图/记忆提示<br>连续 | 决策耦合、由智能体自写的分层记忆：选路点的同一次调用中记录房间、物体、进度与失败笔记，旧历史按相关性检索回上下文。 | VLN-CE R2R 61.0% SR, VLN-CE RxR 52.7% SR, HM3D-v2 ObjectNav 79.7% SR; context length -65% | [[topics/papers/视觉语言导航VLN/2-23_2607.29600_HAM-VLN.pdf\|PDF]] · [代码](https://github.com/an1iu/HAM-VLN) |
| 2026-09 | [**HarnessVLN**](https://arxiv.org/abs/2609.15195)<br>Unifying Training-Free Embodied Navigation through an Agent Harness | — | 分层系统与harness<br>连续 | 免训练统一Harness兼顾指令与物体目标导航：协调感知、记忆与执行工具，派发前校验规划的证据、几何可行性与子目标一致性。 | R2R 59.6%, RxR 51.4%, HM3D-v2 76.0%, HM3D-OVON 59.3% SR | [[topics/papers/视觉语言导航VLN/2-24_2609.15195_HarnessVLN.pdf\|PDF]] · [[topics/notes/视觉语言导航VLN/2-24_HarnessVLN\|笔记]] · [代码](https://github.com/AgibotGeneral/harnessvln) · [主页](https://agibot-harnessvln.netlify.app/) |
| 2026-09 | [**NavHarness**](https://arxiv.org/abs/2609.39915)<br>Adaptive Goals for Agentic Vision-Language Navigation | — | 多智能体/讨论<br>连续 | 多智能体式Agentic VLN：目标智能体设自适应局部目标，验证智能体判定完成，记忆智能体压缩上下文，视觉运动智能体负责执行。 | real-world 83.3% success, 1.51 m NE | [[topics/papers/视觉语言导航VLN/2-25_2609.39915_NavHarness.pdf\|PDF]] · [主页](https://navharness.github.io/) |
| 2026-10 | [**PreAct-Nav**](https://arxiv.org/abs/2610.04916)<br>Agentic Reasoning Before Action for Urban Navigation | — | 世界模型/想象<br>户外/城市 | 城市长程导航中为冻结策略加入前瞻推理：动作条件世界模型预测候选动作的后果，VLM据当前子目标保留或修正动作，并以记忆维护子目标。 | — | [[topics/papers/视觉语言导航VLN/2-26_2610.04916_PreAct-Nav.pdf\|PDF]] · [主页](https://jjingxie.github.io/preact-nav-website/) |

## 三、训练出来的大模型导航模型

在导航数据上训练或微调视觉语言模型、视频大模型、VLA 和导航基础模型，包括强化学习微调、三维记忆和推理加速。

| 日期 | 论文 | 发表 | 类型 / 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2023-10 | [**LangNav**](https://arxiv.org/abs/2310.07889)<br>Language as a Perceptual Representation for Navigation | NAACL 2024 Findings | 视频/多模态大模型导航<br>离散 | 用现成图像描述与检测把全景视图转成文字，微调语言模型选择动作，少样本R2R下优于视觉特征基线。 | — | [[topics/papers/视觉语言导航VLN/3-01_2310.07889_LangNav.pdf\|PDF]] · [代码](https://github.com/pbw-Berwin/LangNav) |
| 2023-12 | [**NaviLLM**](https://arxiv.org/abs/2312.02010)<br>Towards Learning a Generalist Model for Embodied Navigation | CVPR 2024 | 导航基础模型<br>离散 | 首个具身导航通才模型NaviLLM，用基于schema的指令把多种导航与问答任务统一为生成问题联合训练LLM。 | CVDN goal progress +29% over previous SOTA | [[topics/papers/视觉语言导航VLN/3-02_2312.02010_NaviLLM.pdf\|PDF]] · [代码](https://github.com/zd11024/NaviLLM) |
| 2024-02 | [**NaVid**](https://arxiv.org/abs/2402.15852)<br>Video-based VLM Plans the Next Step for Vision-and-Language Navigation | RSS 2024 | 视频/多模态大模型导航<br>连续 | 基于视频的VLM，只用单目RGB视频流逐步输出下一步动作，无需地图、里程计或深度，支持仿真到真机迁移。 | — | [[topics/papers/视觉语言导航VLN/3-03_2402.15852_NaVid.pdf\|PDF]] · [代码](https://github.com/jzhzhang/NaVid-VLN-CE) |
| 2024-03 | [**NavCoT**](https://arxiv.org/abs/2403.07376)<br>Boosting LLM-Based Vision-and-Language Navigation via Learning Disentangled Reasoning | TPAMI 2025 | 视频/多模态大模型导航<br>离散 | 参数高效微调LLM生成导航思维链：想象下一观测、选最匹配候选、再决策，缓解LLM与VLN的领域差距。 | R2R: ~7% relative improvement over a GPT4-based approach | [[topics/papers/视觉语言导航VLN/3-04_2403.07376_NavCoT.pdf\|PDF]] · [代码](https://github.com/expectorlin/NavCoT) |
| 2024-12 | [**NaVILA**](https://arxiv.org/abs/2412.04453)<br>Legged Robot Vision-Language-Action Model for Navigation | RSS 2025 | VLA与双系统<br>真机 | 两级框架：VLA输出“前进75cm”式语言化中层动作，再交给视觉运动RL策略执行，实现腿式机器人VLN。 | — | [[topics/papers/视觉语言导航VLN/3-05_2412.04453_NaVILA.pdf\|PDF]] · [代码](https://github.com/AnjieCheng/NaVILA) · [主页](https://navila-bot.github.io/) |
| 2024-12 | [**Uni-NaVid**](https://arxiv.org/abs/2412.06224)<br>A Video-based Vision-Language-Action Model for Unifying Embodied Navigation Tasks | RSS 2025 | 导航基础模型<br>多种 | 首个视频VLA，统一指令跟随、物体搜索、问答与人体跟踪等导航任务，用360万条样本联合训练。 | — | [[topics/papers/视觉语言导航VLN/3-06_2412.06224_Uni-NaVid.pdf\|PDF]] · [代码](https://github.com/jzhzhang/Uni-NaVid) · [主页](https://pku-epic.github.io/Uni-NaVid/) |
| 2025-02 | [**MapNav**](https://arxiv.org/abs/2502.13451)<br>A Novel Memory Representation via Annotated Semantic Maps for Vision-and-Language Navigation | ACL 2025 | 3D/空间表示与记忆<br>连续 | 用逐步更新、带文字标注的俯视语义地图（ASM）替代历史帧作为VLM记忆输入，降低存储与计算开销。 | — | [[topics/papers/视觉语言导航VLN/3-07_2502.13451_MapNav.pdf\|PDF]] · [代码](https://github.com/linglingxiansen/MapNav) |
| 2025-05 | [**Dynam3D**](https://arxiv.org/abs/2505.11383)<br>Dynamic Layered 3D Tokens Empower VLM for Vision-and-Language Navigation | — | 3D/空间表示与记忆<br>连续 | 把CLIP特征投影为patch-实例-区域三层动态3D token输入3D-VLM，支持在线更新、长期记忆与动态场景。 | SOTA on R2R-CE, REVERIE-CE and NavRAG-CE under monocular settings | [[topics/papers/视觉语言导航VLN/3-08_2505.11383_Dynam3D.pdf\|PDF]] · [代码](https://github.com/MrZihan/Dynam3D) |
| 2025-05 | [**Aux-Think**](https://arxiv.org/abs/2505.11886)<br>Exploring Reasoning Strategies for Data-Efficient Vision-Language Navigation | NeurIPS 2025 | 视频/多模态大模型导航<br>连续 | 系统比较VLN推理策略，发现推理时CoT会“推理崩塌”；提出训练时用CoT辅助监督、推理时直接出动作。 | — | [[topics/papers/视觉语言导航VLN/3-09_2505.11886_Aux-Think.pdf\|PDF]] |
| 2025-05 | [**FlightGPT**](https://arxiv.org/abs/2505.12835)<br>Towards Generalizable and Interpretable UAV Vision-and-Language Navigation with Vision-Language Models | EMNLP 2025 | 强化学习微调<br>空中 | 基于VLM的无人机VLN：先SFT，再用目标精度、推理质量与格式的复合奖励做GRPO，并以CoT提升可解释性。 | CityNav unseen: +9.22% SR over the strongest baseline | [[topics/papers/视觉语言导航VLN/3-10_2505.12835_FlightGPT.pdf\|PDF]] · [代码](https://github.com/Uavln/FlightGPT) |
| 2025-06 | [**EvolveNav**](https://arxiv.org/abs/2506.01551)<br>Empowering LLM-Based Vision-Language Navigation via Self-Improving Embodied Reasoning | TPAMI 2026 | 视频/多模态大模型导航<br>离散 | 两阶段训练LLM导航：先用形式化CoT标签监督微调激活推理，再用模型自身推理结果做自反思后训练。 | — | [[topics/papers/视觉语言导航VLN/3-11_2506.01551_EvolveNav.pdf\|PDF]] · [代码](https://github.com/expectorlin/EvolveNav) |
| 2025-06 | [**OctoNav**](https://arxiv.org/abs/2506.09839)<br>Towards Generalist Embodied Navigation | CVPR 2026 | 强化学习微调<br>连续 | 面向自由形式多模态指令的通才导航VLA，经思考后行动SFT、Nav-GRPO与在线RL三阶段混合训练。 | — | [[topics/papers/视觉语言导航VLN/3-12_2506.09839_OctoNav.pdf\|PDF]] · [代码](https://github.com/buaa-colalab/OctoNav-R1) · [主页](https://buaa-colalab.github.io/OctoNav/) |
| 2025-06 | [**VLN-R1**](https://arxiv.org/abs/2506.17221)<br>Vision-Language Navigation via Reinforcement Fine-Tuning | — | 强化学习微调<br>连续 | LVLM把第一视角视频直接映射为连续动作：先SFT对齐专家动作，再用带时间衰减奖励的GRPO做强化微调。 | — | [[topics/papers/视觉语言导航VLN/3-13_2506.17221_VLN-R1.pdf\|PDF]] · [代码](https://github.com/Qi-Zhangyang/GPT4Scene-and-VLN-R1) · [主页](https://vlnr1.github.io) |
| 2025-06 | [**NavMorph**](https://arxiv.org/abs/2506.23468)<br>A Self-Evolving World Model for Vision-and-Language Navigation in Continuous Environments | ICCV 2025 | 其他<br>连续 | 自演化世界模型：用紧凑潜变量建模环境动态并配合情境演化记忆，在VLN-CE中前瞻规划并在线适应。 | — | [[topics/papers/视觉语言导航VLN/3-14_2506.23468_NavMorph.pdf\|PDF]] · [代码](https://github.com/Feliciaxyao/NavMorph) |
| 2025-07 | [**StreamVLN**](https://arxiv.org/abs/2507.05240)<br>Streaming Vision-and-Language Navigation via SlowFast Context Modeling | ICRA 2026 | 效率与流式<br>连续 | Video-LLM流式VLN：滑窗多轮对话快速出动作，慢更新记忆用3D感知token剪枝压缩历史，复用KV缓存降延迟。 | — | [[topics/papers/视觉语言导航VLN/3-15_2507.05240_StreamVLN.pdf\|PDF]] · [代码](https://github.com/InternRobotics/StreamVLN) · [主页](https://streamvln.github.io/) |
| 2025-08 | [**MonoDream**](https://arxiv.org/abs/2508.02549)<br>Monocular Vision-Language Navigation with Panoramic Dreaming | — | 视频/多模态大模型导航<br>连续 | 轻量单目VLA，以“潜在全景想象”任务预测当前与未来全景RGB-D潜特征，学习统一导航表示，缩小与全景方法差距。 | — | [[topics/papers/视觉语言导航VLN/3-16_2508.02549_MonoDream.pdf\|PDF]] |
| 2025-08 | [**CorrectNav**](https://arxiv.org/abs/2508.10416)<br>Self-Correction Flywheel Empowers Vision-Language-Action Navigation Model | AAAI (README: "AAAI 2025") | VLA与双系统<br>连续 | “自纠错飞轮”后训练：从模型在训练集上的偏航轨迹自动生成感知与动作纠错数据，迭代训练单目VLA导航模型。 | R2R-CE 65.1% SR, RxR-CE 69.3% SR | [[topics/papers/视觉语言导航VLN/3-17_2508.10416_CorrectNav.pdf\|PDF]] · [代码](https://github.com/owlet914/CorrectNav) |
| 2025-09 | [**Nav-R1**](https://arxiv.org/abs/2509.10884)<br>Reasoning and Navigation in Embodied Scenes | — | 强化学习微调<br>多种 | 以导航CoT数据冷启动，再用格式、理解、导航三种奖励做GRPO，并以快慢范式解耦推理与低延迟控制。 | over 8% average improvement in reasoning and navigation performance | [[topics/papers/视觉语言导航VLN/3-18_2509.10884_Nav-R1.pdf\|PDF]] · [代码](https://github.com/AIGeeksGroup/Nav-R1) · [主页](https://aigeeksgroup.github.io/Nav-R1) |
| 2025-09 | [**NavFoM**](https://arxiv.org/abs/2509.12129)<br>Embodied Navigation Foundation Model | — | 导航基础模型<br>多种 | 跨具身、跨任务导航基础模型NavFoM，用800万样本覆盖四足、无人机、轮式与车辆，统一VLN、搜索、跟踪与驾驶。 | — | [[topics/papers/视觉语言导航VLN/3-19_2509.12129_NavFoM.pdf\|PDF]] · [主页](https://pku-epic.github.io/NavFoM-Web/) |
| 2025-09 | [**ActiveVLN**](https://arxiv.org/abs/2509.12618)<br>Towards Active Exploration via Multi-Turn RL in Vision-and-Language Navigation | ICRA 2026 | 强化学习微调<br>连续 | 少量专家轨迹模仿学习启动后，用多轮RL让MLLM主动探索、自采轨迹并以GRPO优化，替代DAgger式后训练。 | — | [[topics/papers/视觉语言导航VLN/3-20_2509.12618_ActiveVLN.pdf\|PDF]] · [代码](https://github.com/arvillion/ActiveVLN) |
| 2025-09 | [**JanusVLN**](https://arxiv.org/abs/2509.22548)<br>Decoupling Semantics and Spatiality with Dual Implicit Memory for Vision-Language Navigation | ICLR 2026 | 3D/空间表示与记忆<br>连续 | 双隐式神经记忆：给MLLM接入空间几何编码器的3D先验，把几何与语义编码器的历史KV缓存作为定长记忆，仅用RGB。 | SR +10.5-35.5 vs. methods using multiple input types; +3.6-10.8 vs. methods using more RGB training data | [[topics/papers/视觉语言导航VLN/3-21_2509.22548_JanusVLN.pdf\|PDF]] · [代码](https://github.com/MIV-XJTU/JanusVLN) · [主页](https://miv-xjtu.github.io/JanusVLN.github.io/) |
| 2025-09 | [**OmniNav**](https://arxiv.org/abs/2509.25687)<br>A Unified Framework for Prospective Exploration and Visual-Language Navigation | ICLR 2026 | VLA与双系统<br>多种 | 快慢系统统一指令、物体、点目标导航与前沿探索：快模块高频预测连续航点，慢模块基于长时观测与前沿选子目标。 | — | [[topics/papers/视觉语言导航VLN/3-22_2509.25687_OmniNav.pdf\|PDF]] · [代码](https://github.com/amap-cvlab/OmniNav) · [主页](https://astra-amap.github.io/omninav.github.io) |
| 2025-10 | [**UrbanVLA**](https://arxiv.org/abs/2510.23576)<br>A Vision-Language-Action Model for Urban Micromobility | ICRA 2026 | VLA与双系统<br>户外/城市 | 面向城市微出行的路线条件VLA，把噪声路线航点与视觉对齐后规划轨迹，经仿真与网络视频SFT再做RFT。 | MetaUrban SocialNav: >55% over strong baselines | [[topics/papers/视觉语言导航VLN/3-23_2510.23576_UrbanVLA.pdf\|PDF]] · [代码](https://github.com/GalaxyGeneralRobotics/UrbanVLA) · [主页](https://pku-epic.github.io/UrbanVLA-Web/) |
| 2025-12 | [**DualVLN**](https://arxiv.org/abs/2512.08186)<br>Ground Slow, Move Fast: A Dual-System Foundation Model for Generalizable Vision-and-Language Navigation | — | VLA与双系统<br>连续 | 双系统VLN基础模型（开源为InternVLA-N1）：VLM慢速预测像素航点，轻量扩散策略快速生成平滑轨迹。 | — | [[topics/papers/视觉语言导航VLN/3-24_2512.08186_DualVLN.pdf\|PDF]] · [代码](https://github.com/InternRobotics/InternNav) · [主页](https://internrobotics.github.io/internvla-n1.github.io/) |
| 2025-12 | [**Efficient-VLN**](https://arxiv.org/abs/2512.10310)<br>A Simple yet Strong Baseline for Efficient Vision-Language Navigation | — | 效率与流式<br>连续 | 高效MLLM导航基线：连续RoPE的KV缓存复用只处理新帧，动作隔离掩码打包训练，自适应DAgger收集纠错数据。 | R2R-CE 73.2% SR, RxR-CE 75.6% SR; 28% latency reduction vs. StreamVLN | [[topics/papers/视觉语言导航VLN/3-25_2512.10310_Efficient-VLN.pdf\|PDF]] |
| 2025-12 | [**D3D-VLP**](https://arxiv.org/abs/2512.12622)<br>Dynamic 3D Vision-Language-Planning Model for Embodied Grounding and Navigation | — | 3D/空间表示与记忆<br>多种 | 动态3D思维链在单个3D-VLM中统一规划、定位、导航与问答，用掩码自回归损失从千万级碎片化标注数据中学习。 | — | [[topics/papers/视觉语言导航VLN/3-26_2512.12622_D3D-VLP.pdf\|PDF]] · [代码](https://github.com/MrZihan/D3D-VLP) |
| 2026-01 | [**VLingNav**](https://arxiv.org/abs/2601.08665)<br>Embodied Navigation with Adaptive Reasoning and Visual-Assisted Linguistic Memory | — | VLA与双系统<br>多种 | 导航VLA引入按需触发的自适应思维链与视觉辅助语言记忆，用Nav-AdaCoT-2.9M训练并加入在线专家引导RL。 | — | [[topics/papers/视觉语言导航VLN/3-27_2601.08665_VLingNav.pdf\|PDF]] · [主页](https://wsakobe.github.io/VLingNav-web/)（2026-11-04 打不开） |
| 2026-02 | [**ABot-N0**](https://arxiv.org/abs/2602.11598)<br>Technical Report on the VLA Foundation Model for Versatile Embodied Navigation | — | 导航基础模型<br>多种 | 统一点目标、物体目标、指令跟随、POI与人体跟随5类任务的VLA基础模型：LLM认知大脑+流匹配动作专家。 | SOTA across 7 benchmarks | [[topics/papers/视觉语言导航VLN/3-28_2602.11598_ABot-N0.pdf\|PDF]] · [代码](https://github.com/amap-cvlab/ABot-Navigation) · [主页](https://amap-cvlab.github.io/ABot-Navigation/ABot-N0/) |
| 2026-03 | [**History-Conditioned Spatio-Temporal Visual Token Pruning for Efficient Vision-Language Navigation**](https://arxiv.org/abs/2603.06480) | IROS 2026 | 效率与流式<br>连续 | 面向VLA式VLN的免训练时空视觉token剪枝：当前视图做空间选择，历史记忆做时空压缩，即插即用并上四足真机。 | — | [[topics/papers/视觉语言导航VLN/3-29_2603.06480_History-Conditioned-Spatio-Temporal.pdf\|PDF]] · [主页](https://wqtwjt1996.github.io/publications/2026-vln.html) |
| 2026-03 | [**VLN-Cache**](https://arxiv.org/abs/2603.07080)<br>Enabling Token Caching for VLN Models with Visual/Semantic Dynamics Awareness | — | 效率与流式<br>连续 | 面向VLN模型的免训练token缓存：视角对齐重映射应对视点移动，任务相关显著性过滤应对语义阶段切换。 | R2R-CE: up to 1.52x speedup | [[topics/papers/视觉语言导航VLN/3-30_2603.07080_VLN-Cache.pdf\|PDF]] |
| 2026-03 | [**AerialVLA**](https://arxiv.org/abs/2603.14363)<br>A Vision-Language-Action Model for UAV Navigation via Minimalist End-to-End Control | ECCV 2026 | VLA与双系统<br>空中 | 极简端到端无人机VLA（后更名AeroVLA）：双视角感知+机载传感器生成的模糊方向提示，直接输出3自由度控制与降落信号。 | TravelUAV unseen: nearly 3x the success rate of leading baselines | [[topics/papers/视觉语言导航VLN/3-31_2603.14363_AerialVLA.pdf\|PDF]] · [代码](https://github.com/XuPeng23/AeroVLA) |
| 2026-06 | [**FutureNav**](https://arxiv.org/abs/2606.30367)<br>Unified World-Action Modeling for Vision-and-Language Navigation | — | 视频/多模态大模型导航<br>连续 | VLM统一世界-动作建模：联合优化动作策略、正/逆动力学与未来空间状态生成四个目标，4B骨干不降推理速度。 | — | [[topics/papers/视觉语言导航VLN/3-32_2606.30367_FutureNav.pdf\|PDF]] · [代码](https://github.com/linglingxiansen/FutureNav) · [主页](https://linglingxiansen.github.io/FutureNav/) |
| 2026-07 | [**ABot-N1**](https://arxiv.org/abs/2607.10383)<br>Toward a General Visual Language Navigation Foundation Model | — | 导航基础模型<br>多种 | 慢速视觉语言推理器做显式CoT并输出像素目标，快速动作专家据文本与像素锚点生成连续航点，强化城市级导航。 | POI arrival +35.0% (to 77.3%); 95.4%/92.9% SR in complex indoor/outdoor scenes | [[topics/papers/视觉语言导航VLN/3-33_2607.10383_ABot-N1.pdf\|PDF]] · [代码](https://github.com/amap-cvlab/ABot-Navigation) · [主页](https://amap-cvlab.github.io/ABot-Navigation/ABot-N1/) |
| 2026-07 | [**Robostral Navigate**](https://arxiv.org/abs/2607.20785) | — | 视频/多模态大模型导航<br>连续 | 8B单目RGB VLM，以在当前画面“指点”下一目标位置输出航点，配合前缀缓存打包训练与RL，可跨轮式/腿式/空中部署。 | R2R-CE 77.4% SR; RxR-CE 75.1% SR | [[topics/papers/视觉语言导航VLN/3-34_2607.20785_Robostral-Navigate.pdf\|PDF]] |
| 2026-08 | [**LightNav-0**](https://arxiv.org/abs/2608.30935)<br>Eliciting VLM Spatial Intelligence for Generalist Embodied Navigation | — | 导航基础模型<br>多种 | 紧凑通才导航模型：双通道“指点”表达空间意图、残差VQ动作tokenizer映射轨迹，经ER中训、SFT与RL统一多任务。 | SOTA monocular success rates across all 10 public navigation simulation settings | [[lightorigins/notes/02_LightNav-0\|笔记]] · [[topics/papers/视觉语言导航VLN/3-35_2608.30935_LightNav-0.pdf\|PDF]] · [代码](https://github.com/lightorigins/LightNav-0) · [主页](https://www.lightorigins.com/en/blog/lightnav-0) |
| 2026-10 | [**GG-Nav**](https://arxiv.org/abs/2610.14541)<br>Goal-oriented Grounding Chain-of-Thought Elicits Reasoning in Navigation Foundation Models | — | 导航基础模型<br>连续 | 为导航基础模型SFT学习目标定位思维链：先从中间帧累积目标证据，再结合当前观测定位目标并输出动作或澄清提问。 | SR +3.1% HM3D ObjectNav, +16.6% VL-LN, +5.3% CoIN | [[topics/papers/视觉语言导航VLN/3-36_2610.14541_GG-Nav.pdf\|PDF]] · [代码](https://github.com/DuangZhu/GG_Nav) · [主页](https://duangzhu.github.io/GG-Nav-Project-Page/) |
| 2026-10 | [**SimpleVLN**](https://arxiv.org/abs/2610.23203)<br>Towards Simple and Frontier Vision-Language Navigation | — | 视频/多模态大模型导航<br>连续 | 不改MLLM架构，用定长全局-局部记忆、动作块输出与IL→DAgger→RL渐进训练释放原生MLLM导航能力。 | R2R-CE 76.7% SR, RxR-CE 80.1% SR | [[topics/papers/视觉语言导航VLN/3-37_2610.23203_SimpleVLN.pdf\|PDF]] · [代码](https://github.com/simplevln/SimpleVLN) · [主页](https://simplevln.github.io/) |
| 2026-10 | [**HAVANA**](https://arxiv.org/abs/2610.24122)<br>A Hierarchical Video-Action Model for Vision-Language Navigation | — | VLA与双系统<br>连续 | 双系统视频-动作模型：慢系统从历史生成语言条件潜在计划，快系统结合最新计划与当前观测异步出局部轨迹，推理时不生成视频。 | — | [[topics/papers/视觉语言导航VLN/3-38_2610.24122_HAVANA.pdf\|PDF]] · [代码](https://github.com/Anastasiawd/HAVANA) |
| 2026-10 | [**MemVLN**](https://arxiv.org/abs/2610.35066)<br>Streaming Episodic Memory for Vision-Language Navigation | — | 3D/空间表示与记忆<br>连续 | VLM流式导航的情景记忆：维护带时间戳与相对位姿的有界压缩特征库，经交叉注意力产出紧凑记忆token。 | Physical held-out episodes: success 17% -> 40% over VLM baseline, 47% after post-training | [[topics/papers/视觉语言导航VLN/3-39_2610.35066_MemVLN.pdf\|PDF]] · [代码](https://github.com/MemVLN/MemVLN) · [主页](https://memvln.github.io/) |
| 2026-11 | [**Compass 1**](https://arxiv.org/abs/2611.12087)<br>Towards Open-World and Persistent Embodied Navigation from Monocular RGB Videos | — | 导航基础模型<br>多种 | 统一语言理解与视频生成的导航基础模型：用稀疏关键帧加显式历史地图保留近 2 分钟视觉历史，配结构化问答监督做长程记忆回溯；开源 500+ 小时真实交互和 2,000+ 小时标注网络视频。 | overall success rate 79.4% vs 17.8% for the strongest baseline; persistent history backtracking 0% → 58% | [[topics/papers/视觉语言导航VLN/3-40_2611.12087_Compass-1.pdf\|PDF]] |

## 四、任务、基准与数据

VLN 评测用的任务和数据集，以及新设定（长程、对话、人群、安全、空中、户外、真机）和数据扩展方法。

### 核心基准

| 日期 | 论文 | 发表 | 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2017-11 | [**R2R**](https://arxiv.org/abs/1711.07280)<br>Vision-and-Language Navigation: Interpreting visually-grounded navigation instructions in real environments | CVPR 2018 | 离散 | 提出基于真实室内全景的 Matterport3D 模拟器，发布首个真实建筑 VLN 基准 R2R，奠定 VLN 任务。 | — | [[topics/papers/视觉语言导航VLN/4-01_1711.07280_R2R.pdf\|PDF]] · [代码](https://github.com/peteanderson80/Matterport3DSimulator) · [主页](https://bringmeaspoon.org/) |
| 2018-11 | [**Touchdown**](https://arxiv.org/abs/1811.12354)<br>Natural Language Navigation and Spatial Reasoning in Visual Street Environments | CVPR 2019 | 户外/城市 | 在真实城市街景中先跟随导航指令到达目标，再按空间描述找到隐藏物体，是户外 VLN 的代表性任务与数据集。 | 9,326 examples of English instructions and spatial descriptions | [[topics/papers/视觉语言导航VLN/4-02_1811.12354_Touchdown.pdf\|PDF]] · [代码](https://github.com/lil-lab/touchdown) |
| 2019-04 | [**REVERIE**](https://arxiv.org/abs/1904.10151)<br>Remote Embodied Visual Referring Expression in Real Indoor Environments | CVPR 2020 | 离散 | 提出远程具身指代表达任务 REVERIE：依据高层指令在未见环境中导航，并定位指令所指的远处目标物体。 | — | [[topics/papers/视觉语言导航VLN/4-03_1904.10151_REVERIE.pdf\|PDF]] · [代码](https://github.com/YuankaiQi/REVERIE) |
| 2019-05 | [**R4R**](https://arxiv.org/abs/1905.12255)<br>Stay on the Path: Instruction Fidelity in Vision-and-Language Navigation | ACL 2019 | 离散 | 指出 R2R 路径多为直达最短路径，拼接短路径构造更长的 R4R 数据集，并提出衡量指令忠实度的 CLS 指标。 | — | [[topics/papers/视觉语言导航VLN/4-04_1905.12255_R4R.pdf\|PDF]] · [代码](https://github.com/google-research/google-research/tree/master/r4r) |
| 2019-07 | [**CVDN**](https://arxiv.org/abs/1907.04957)<br>Vision-and-Dialog Navigation | CoRL 2019 | 离散 | 收集 2k 多段人-人协作导航对话，定义基于对话历史导航（NDH）任务，开创对话式 VLN 基准 CVDN。 | over 2k embodied, human-human dialogs | [[topics/papers/视觉语言导航VLN/4-05_1907.04957_CVDN.pdf\|PDF]] · [代码](https://github.com/mmurray/cvdn) · [主页](https://cvdn.dev/) |
| 2020-04 | [**VLN-CE**](https://arxiv.org/abs/2004.02857)<br>Beyond the Nav-Graph: Vision-and-Language Navigation in Continuous Environments | ECCV 2020 | 连续 | 把 VLN 搬到连续 3D 环境（VLN-CE），智能体执行底层动作，去掉已知拓扑图、瞬移导航与完美定位等假设。 | — | [[topics/papers/视觉语言导航VLN/4-06_2004.02857_VLN-CE.pdf\|PDF]] · [代码](https://github.com/jacobkrantz/VLN-CE) · [主页](https://jacobkrantz.github.io/vlnce/) |
| 2020-10 | [**RxR**](https://arxiv.org/abs/2010.07954)<br>Room-Across-Room: Multilingual Vision-and-Language Navigation with Dense Spatiotemporal Grounding | EMNLP 2020 | 离散 | 发布多语言（英语、印地语、泰卢固语）VLN 数据集 RxR，规模大于 R2R，且指令中每个词都与标注者位姿做了时间对齐。 | — | [[topics/papers/视觉语言导航VLN/4-07_2010.07954_RxR.pdf\|PDF]] · [代码](https://github.com/google-research-datasets/RxR) |
| 2021-03 | [**SOON**](https://arxiv.org/abs/2103.17138)<br>Scenario Oriented Object Navigation with Graph-based Exploration | — | 离散 | 提出场景导向目标导航 SOON：从任意位置出发，依据目标及其周边场景描述找到目标物体，并发布 FAO 数据集。 | — | [[topics/papers/视觉语言导航VLN/4-08_2103.17138_SOON.pdf\|PDF]] · [代码](https://github.com/ZhuFengdaaa/SOON) |

### 新任务与新设定

| 日期 | 论文 | 发表 | 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2022-10 | [**IVLN**](https://arxiv.org/abs/2210.03087)<br>Iterative Vision-and-Language Navigation | CVPR 2023 | 多种 | 提出迭代式 VLN：智能体在持久环境中连续执行多达 100 条 R2R 指令并保留记忆，发布离散/连续 IR2R。 | about 400 tours each in 80 indoor scenes | [[topics/papers/视觉语言导航VLN/4-09_2210.03087_IVLN.pdf\|PDF]] · [代码](https://github.com/Bill1235813/IVLN) · [主页](https://jacobkrantz.github.io/ivln) |
| 2024-06 | [**HA-VLN**](https://arxiv.org/abs/2406.19236)<br>Human-Aware Vision-and-Language Navigation: Bridging Simulation to Reality with Dynamic Human Interactions | NeurIPS 2024 D&B Track | 离散 | 在 Matterport3D 中加入动态人类活动，构建 HA3D 模拟器与 HA-R2R 数据集，研究人群场景 VLN。 | — | [[topics/papers/视觉语言导航VLN/4-10_2406.19236_HA-VLN.pdf\|PDF]] · [代码](https://github.com/lpercc/HA3D_simulator) · [主页](https://lpercc.github.io/HA3D_simulator/) |
| 2024-12 | [**LH-VLN**](https://arxiv.org/abs/2412.09082)<br>Towards Long-Horizon Vision-Language Navigation: Platform, Benchmark and Method | CVPR 2025 | 连续 | 提出长程多阶段 VLN 任务，配套自动数据生成平台 NavGen、LHPR-VLN 基准与细粒度子任务指标。 | 3,260 tasks with an average of 150 task steps | [[topics/papers/视觉语言导航VLN/4-11_2412.09082_LH-VLN.pdf\|PDF]] · [代码](https://github.com/HCPLab-SYSU/LH-VLN) · [主页](https://hcplab-sysu.github.io/LH-VLN/) |
| 2025-10 | [**NavSpace**](https://arxiv.org/abs/2510.08173)<br>How Navigation Agents Follow Spatial Intelligence Instructions | ICRA 2026 | 连续 | 评测导航智能体空间感知与推理能力的基准（Habitat 3.0 + HM3D 场景），6 类任务，评测 22 个导航智能体，并提出空间智能导航模型 SNav 做了真机测试。 | 1,228 trajectory-instruction pairs; 22 navigation agents evaluated | [[topics/papers/视觉语言导航VLN/4-34_2510.08173_NavSpace.pdf\|PDF]] · [主页](https://navspace.github.io/) |
| 2025-12 | [**VLNVerse**](https://arxiv.org/abs/2512.19021)<br>A Benchmark for Vision-Language Navigation with Versatile, Embodied, Realistic Simulation and Evaluation | — | 连续 | 构建带物理引擎与全运动学的大规模可扩展 VLN 基准，把多种碎片化 VLN 任务统一评测。 | — | [[topics/papers/视觉语言导航VLN/4-12_2512.19021_VLNVerse.pdf\|PDF]] · [代码](https://github.com/william13077/IAmGoodNavigator) · [主页](https://sihaoevery.github.io/vlnverse) |
| 2025-12 | [**VL-LN Bench**](https://arxiv.org/abs/2512.22342)<br>Towards Long-horizon Goal-oriented Navigation with Active Dialogs | — | 连续 | 提出交互式实例目标导航：智能体可边找边向 oracle 提问消歧，发布 4.1 万条长程对话轨迹基准。 | over 41k collected long-horizon dialog-augmented trajectories | [[topics/papers/视觉语言导航VLN/4-13_2512.22342_VL-LN-Bench.pdf\|PDF]] · [代码](https://github.com/InternRobotics/VL-LN) · [主页](https://0309hws.github.io/VL-LN.github.io/) |
| 2026-04 | [**VLN-NF**](https://arxiv.org/abs/2604.10533)<br>Feasibility-Aware Vision-and-Language Navigation with False-Premise Instructions | ACL 2026 | 离散 | 提出虚假前提指令基准：目标不在指定房间，智能体需探索取证后输出 NOT-FOUND，并配 REV-SPL 指标。 | — | [[topics/papers/视觉语言导航VLN/4-14_2604.10533_VLN-NF.pdf\|PDF]] · [主页](https://vln-nf.github.io/) |
| 2026-10 | [**VLN-Safe**](https://arxiv.org/abs/2610.14682)<br>Successful but Unsafe: An Analytical Benchmark for Revealing Collisions in Vision-and-Language Navigation | — | 连续 | 在 sliding 与 blocking 两种碰撞机制下评测 R2R-CE 智能体的碰撞安全，揭示成功但不安全的差距。 | Across six published agents on R2R-CE, 38.5-56.8% of successful episodes contain contact under sliding, while switching to blocking decreases success rate by 11.7-36.1 percentage points. | [[topics/papers/视觉语言导航VLN/4-15_2610.14682_VLN-Safe.pdf\|PDF]] |

### 数据生成与扩展

| 日期 | 论文 | 发表 | 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2022-08 | [**HM3D-AutoVLN**](https://arxiv.org/abs/2208.11781)<br>Learning from Unlabeled 3D Environments for Vision-and-Language Navigation | ECCV 2022 | 离散 | 从 900 栋无标注 HM3D 建筑自动生成导航图、伪物体标签与指令，构建大规模 HM3D-AutoVLN 数据集。 | On the SPL metric, our approach improves over state of the art by 7.1% and 8.1% on the unseen validation splits of REVERIE and SOON datasets respectively. | [[topics/papers/视觉语言导航VLN/4-16_2208.11781_HM3D-AutoVLN.pdf\|PDF]] · [代码](https://github.com/cshizhe/HM3DAutoVLN) · [主页](https://cshizhe.github.io/projects/hm3d_autovln.html) |
| 2023-07 | [**ScaleVLN**](https://arxiv.org/abs/2307.15644)<br>Scaling Data Generation in Vision-and-Language Navigation | ICCV 2023 | 多种 | 用 HM3D 与 Gibson 的 1200+ 场景合成 490 万条指令-轨迹对，并系统研究如何用增广数据训练 VLN。 | 4.9 million instruction trajectory pairs; 80% single-run success rate on the R2R test split; seen/unseen gap reduced to less than 1% | [[topics/papers/视觉语言导航VLN/4-17_2307.15644_ScaleVLN.pdf\|PDF]] · [代码](https://github.com/wz0919/ScaleVLN) |
| 2024-12 | [**SRDF**](https://arxiv.org/abs/2412.08467)<br>Bootstrapping Language-Guided Navigation Learning with Self-Refining Data Flywheel | — | 离散 | 提出自精炼数据飞轮 SRDF：指令生成器与导航器迭代互相筛选、改进数据池，无需人工标注即可产出高质量导航数据。 | from 70% to 78% SPL on the classic R2R test set, surpassing human performance (76%); SPICE from 23.5 to 26.2 | [[topics/papers/视觉语言导航VLN/4-18_2412.08467_SRDF.pdf\|PDF]] · [代码](https://github.com/wz0919/VLN-SRDF) |
| 2024-12 | [**RoomTour3D**](https://arxiv.org/abs/2412.08591)<br>Geometry-Aware Video-Instruction Tuning for Embodied Navigation | CVPR 2025 | 离散 | 对网络房间巡游视频做 3D 重建得到人类行走轨迹并生成开放式指令，构建视频-指令数据集 RoomTour3D。 | ~100K open-ended description-enriched trajectories with ~200K instructions, and 17K action-enriched trajectories from 1847 room tour environments | [[topics/papers/视觉语言导航VLN/4-19_2412.08591_RoomTour3D.pdf\|PDF]] · [代码](https://github.com/roomtour3d/roomtour3d-NaviLLM) · [主页](https://roomtour3d.github.io/) |
| 2025-02 | [**NavRAG**](https://arxiv.org/abs/2502.11142)<br>Generating User Demand Instructions for Embodied Navigation through Retrieval-Augmented LLM | — | 离散 | 用 LLM 构建层次化场景描述树，模拟不同用户需求做检索增强生成，产出贴近真实用户表达的需求式导航指令。 | over 2 million navigation instructions across 861 scenes | [[topics/papers/视觉语言导航VLN/4-20_2502.11142_NavRAG.pdf\|PDF]] · [代码](https://github.com/MrZihan/NavRAG) |
| 2026-08 | [**VTInstructor**](https://arxiv.org/abs/2608.15284)<br>Visual Trajectory Prompting for Navigation Instruction Generation in Continuous Environments | ACM MM 2026 | 连续 | 首个连续环境下的 VLN 指令生成框架：把长 RGB 轨迹压缩成关键帧，叠加路径、转弯和终点的视觉提示再生成指令，可用来扩充训练数据。 | +0.357 / +0.109 CIDEr over the strongest baseline on R2R-CE / RxR-CE Val Unseen; frozen follower SR 63.3%; +3 SR from data augmentation | [[topics/papers/视觉语言导航VLN/4-35_2608.15284_VTInstructor.pdf\|PDF]] · [[topics/notes/视觉语言导航VLN/4-35_VTInstructor\|笔记]] |

### 真机与sim-to-real

| 日期 | 论文 | 发表 | 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2020-11 | [**Sim-to-Real Transfer for Vision-and-Language Navigation**](https://arxiv.org/abs/2011.03807) | CoRL 2020 | 真机 | 把仿真训练的 VLN 智能体迁移到实体机器人，建立办公室真实-仿真平行环境，定量比较 sim 与 real。 | success rate of 46.8% vs. 55.9% in sim (with prior occupancy map and navigation graph); 22.5% with no prior mapping | [[topics/papers/视觉语言导航VLN/4-21_2011.03807_Sim-to-Real-Transfer-for.pdf\|PDF]] · [代码](https://github.com/batra-mlp-lab/vln-sim2real) |
| 2025-07 | [**VLN-PE**](https://arxiv.org/abs/2507.13019)<br>Rethinking the Embodied Gap in Vision-and-Language Navigation: A Holistic Study of Physical and Visual Disparities | ICCV 2025 | 连续 | 提出支持人形、四足、轮式机器人的物理真实 VLN 平台 VLN-PE，系统评估现有方法在物理部署条件下的性能退化。 | — | [[topics/papers/视觉语言导航VLN/4-22_2507.13019_VLN-PE.pdf\|PDF]] · [代码](https://github.com/InternRobotics/InternNav) · [主页](https://crystalsixone.github.io/vln_pe.github.io/) |

### 空中/无人机

| 日期 | 论文 | 发表 | 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2022-05 | [**AVDN**](https://arxiv.org/abs/2205.12219)<br>Aerial Vision-and-Dialog Navigation | ACL 2023 Findings | 空中 | 提出用自然语言对话控制无人机的 AVDN 任务，收集 3k 多条带指挥者-跟随者异步对话的飞行轨迹。 | over 3k recorded navigation trajectories | [[topics/papers/视觉语言导航VLN/4-23_2205.12219_AVDN.pdf\|PDF]] · [代码](https://github.com/eric-ai-lab/Aerial-Vision-and-Dialog-Navigation) · [主页](https://sites.google.com/view/aerial-vision-and-dialog/home) |
| 2023-08 | [**AerialVLN**](https://arxiv.org/abs/2308.06735)<br>Vision-and-Language Navigation for UAVs | ICCV 2023 | 空中 | 提出面向无人机的户外城市级 VLN 任务 AerialVLN，搭建含 25 个城市场景、支持连续飞行的近真实模拟器。 | 25 city-level scenarios | [[topics/papers/视觉语言导航VLN/4-24_2308.06735_AerialVLN.pdf\|PDF]] · [代码](https://github.com/AirVLN/AirVLN) |
| 2024-06 | [**CityNav**](https://arxiv.org/abs/2406.14240)<br>A Large-Scale Dataset for Real-World Aerial Navigation | ICCV 2025 | 空中 | 首个基于真实城市（剑桥、伯明翰）的大规模空中 VLN 数据集 CityNav，要求结合真实地标与地理信息推理目的地。 | 32,637 human demonstration trajectories covering 4.65 km^2 across two real cities | [[topics/papers/视觉语言导航VLN/4-25_2406.14240_CityNav.pdf\|PDF]] · [代码](https://github.com/water-cookie/citynav) · [主页](https://water-cookie.github.io/city-nav-proj/) |
| 2024-10 | [**OpenUAV**](https://arxiv.org/abs/2410.07087)<br>Towards Realistic UAV Vision-Language Navigation: Platform, Benchmark, and Methodology | — | 空中 | 提出真实飞控的 OpenUAV 平台、约 1.2 万条轨迹的 UAV VLN 数据集与辅助引导式 UAV-Need-Help 基准。 | approximately 12k trajectories | [[topics/papers/视觉语言导航VLN/4-26_2410.07087_OpenUAV.pdf\|PDF]] · [代码](https://github.com/prince687028/TravelUAV) · [主页](https://prince687028.github.io/Travel/) |
| 2026-01 | [**AirNav**](https://arxiv.org/abs/2601.03707)<br>A Large-Scale UAV Vision-and-Language Navigation Dataset with Natural and Diverse Instructions | — | 空中 | 基于真实城市航拍构建 13.7 万样本的 UAV VLN 基准，指令由人-LLM 协作结合 10 种用户画像生成。 | 137K navigation samples; AirVLN-R1 achieves a 51.82% success rate on the test-unseen split | [[topics/papers/视觉语言导航VLN/4-27_2601.03707_AirNav.pdf\|PDF]] · [代码](https://github.com/nopride03/AirNav) · [主页](https://littlelucifer1.github.io/AirNav/) |
| 2026-09 | [**SatNav**](https://arxiv.org/abs/2609.31507)<br>A Scalable Benchmark for Long-Horizon UAV Vision-Language Navigation from Satellite Imagery | NeurIPS 2026 (Track on Evaluations and Datasets) | 空中 | 用卫星影像近似无人机俯视观测，自动构建城市级长程 UAV VLN 基准，考察长期记忆与地理推理。 | 118K episodes from 59 scenes across 18 cities, with an average trajectory length of 379 m | [[topics/papers/视觉语言导航VLN/4-28_2609.31507_SatNav.pdf\|PDF]] · [代码](https://github.com/Eku127/SatNav) · [主页](https://eku127.github.io/SatNav/) |

### 户外/城市

| 日期 | 论文 | 发表 | 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2025-12 | [**UrbanNav**](https://arxiv.org/abs/2512.09607)<br>Learning Language-Guided Urban Navigation from Web-Scale Human Trajectories | AAAI 2026 | 户外/城市 | 利用网络城市步行视频，自动对齐人类轨迹与以地标为锚的语言指令，构建大规模城市语言导航训练数据 UrbanNav。 | over 1,500 hours of navigation data and 3 million instruction-trajectory-landmark triplets | [[topics/papers/视觉语言导航VLN/4-29_2512.09607_UrbanNav.pdf\|PDF]] · [代码](https://github.com/CASIA-IVA-Lab/UrbanNav) |
| 2026-08 | [**DaViNCi**](https://arxiv.org/abs/2608.11901)<br>A Dataset Towards Outdoor Vision-and-Language Navigation with Continuous Actions and Dynamic Elements | — | 户外/城市 | 首个同时引入连续动作与动态元素的户外 VLN 数据集 DaViNCi，摆脱户外 VLN 对固定离散拓扑图的依赖。 | six distinct maps with a total of 6,933 trajectories; success rate decreased by more than 10% in discrete environments compared to previous datasets | [[topics/papers/视觉语言导航VLN/4-30_2608.11901_DaViNCi.pdf\|PDF]] · [主页](https://xzh0312.github.io/DaViNCi/) |

### 综述

| 日期 | 论文 | 发表 | 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2022-03 | [**Vision-and-Language Navigation**](https://arxiv.org/abs/2203.12667)<br>A Survey of Tasks, Methods, and Future Directions | ACL 2022 | 多种 | 经典 VLN 综述：系统梳理 VLN 的任务、评测指标与方法，分析当前进展与挑战并指出未来方向。 | — | [[topics/papers/视觉语言导航VLN/4-31_2203.12667_Vision-and-Language-Navigation.pdf\|PDF]] |
| 2024-07 | [**Vision-and-Language Navigation Today and Tomorrow: A Survey in the Era of Foundation Models**](https://arxiv.org/abs/2407.07035) | TMLR | 多种 | 基础模型时代的 VLN 综述，以具身规划与推理框架自顶向下梳理基础模型在 VLN 中的方法、挑战与机遇。 | — | [[topics/papers/视觉语言导航VLN/4-32_2407.07035_Vision-and-Language-Navigation-Today-and.pdf\|PDF]] · [代码](https://github.com/zhangyuejoslin/VLN-Survey-with-Foundation-Models) |
| 2026-07 | [**A Comprehensive Survey and Systematic Real-World Evaluation of Embodied Vision-and-Language Navigation**](https://arxiv.org/abs/2607.09792) | IEEE TASE 2026 | 多种 | 按动作范式与模型范式梳理 VLN 方法，并在实体机器人上对代表性方案做十个真实场景的系统评测，量化仿真到真机差距。 | a representative monolithic RGB-only method achieves 61% success in simulation but drops to 22% in real-world deployment, while a hierarchical framework achieves a higher real-world success rate of 51% | [[topics/papers/视觉语言导航VLN/4-33_2607.09792_A-Comprehensive-Survey-and-Systematic.pdf\|PDF]] |

## 五、经典方法（大模型之前）

2018–2024 年的代表性方法，后面的大模型工作大多以它们为基线或沿用其结构。

### 早期序列模型与数据增强

| 日期 | 论文 | 发表 | 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2018-06 | [**Speaker-Follower**](https://arxiv.org/abs/1806.02724)<br>Speaker-Follower Models for Vision-and-Language Navigation | NeurIPS 2018 | 离散 | 提出说话者-跟随者框架：用 speaker 模型合成指令做数据增强并进行语用重排序，同时引入全景动作空间。 | more than doubling the success rate over the best existing approach on a standard benchmark | [[topics/papers/视觉语言导航VLN/5-01_1806.02724_Speaker-Follower.pdf\|PDF]] · [代码](https://github.com/ronghanghu/speaker_follower) · [主页](http://ronghanghu.com/speaker_follower) |
| 2018-11 | [**RCM**](https://arxiv.org/abs/1811.10092)<br>Reinforced Cross-Modal Matching and Self-Supervised Imitation Learning for Vision-Language Navigation | CVPR 2019 (Oral) | 离散 | RCM 用匹配评论家提供内在奖励、以强化学习加强局部与全局跨模态对齐，并提出自监督模仿学习 SIL 探索未见环境。 | significantly outperforms previous methods by 10% on SPL; minimizes the success rate performance gap between seen and unseen environments (from 30.7% to 11.7%) | [[topics/papers/视觉语言导航VLN/5-02_1811.10092_RCM.pdf\|PDF]] |
| 2019-01 | [**Self-Monitoring**](https://arxiv.org/abs/1901.03035)<br>Self-Monitoring Navigation Agent via Auxiliary Progress Estimation | ICLR 2019 | 离散 | 自监控智能体：视觉-文本协同定位当前子指令与方向，并以进度估计作为辅助任务监控导航进度。 | 8% absolute increase in success rate on the unseen test set | [[topics/papers/视觉语言导航VLN/5-03_1901.03035_Self-Monitoring.pdf\|PDF]] · [代码](https://github.com/chihyaoma/selfmonitoring-agent) · [主页](https://chihyaoma.github.io/project/2018/09/27/selfmonitoring.html) |
| 2019-03 | [**Regretful Agent**](https://arxiv.org/abs/1903.01602)<br>The Regretful Agent: Heuristic-Aided Navigation through Progress Estimation | CVPR 2019 (Oral) | 离散 | 把进度估计作为可学习启发式，加入后悔模块学习回退、进度标记提示已访问方向，在贪心解码下实现自我纠错。 | 5% absolute improvement on the test server in success rates, and more importantly 8% on success rates normalized by the path length | [[topics/papers/视觉语言导航VLN/5-04_1903.01602_Regretful-Agent.pdf\|PDF]] · [代码](https://github.com/chihyaoma/regretful-agent) · [主页](https://chihyaoma.github.io/project/2019/02/25/regretful.html) |
| 2019-03 | [**Tactical Rewind**](https://arxiv.org/abs/1903.02547)<br>Self-Correction via Backtracking in Vision-and-Language Navigation | CVPR 2019 (Oral) | 离散 | FAST 解码框架：维护前沿并结合局部与全局信号，贪心前进、必要时回溯，可套用到已有 VLN 模型上。 | a 17% relative gain, an absolute 6% gain on Success rate weighted by Path Length (SPL) | [[topics/papers/视觉语言导航VLN/5-05_1903.02547_Tactical-Rewind.pdf\|PDF]] · [代码](https://github.com/Kelym/FAST) |
| 2019-04 | [**EnvDrop**](https://arxiv.org/abs/1904.04195)<br>Learning to Navigate Unseen Environments: Back Translation with Environmental Dropout | NAACL 2019 | 离散 | EnvDrop：IL+RL 混合训练，并用环境级 dropout 模拟未见环境、配合回译生成新路径与指令进行半监督增强。 | — | [[topics/papers/视觉语言导航VLN/5-06_1904.04195_EnvDrop.pdf\|PDF]] · [代码](https://github.com/airsplay/R2R-EnvDrop) |
| 2019-11 | [**AuxRN**](https://arxiv.org/abs/1911.07883)<br>Vision-Language Navigation with Self-Supervised Auxiliary Reasoning Tasks | — | 离散 | AuxRN 引入四个自监督辅助推理任务（解释历史动作、进度估计、朝向预测、轨迹一致性）提供额外训练信号。 | — | [[topics/papers/视觉语言导航VLN/5-07_1911.07883_AuxRN.pdf\|PDF]] |
| 2022-03 | [**EnvEdit**](https://arxiv.org/abs/2203.15685)<br>Environment Editing for Vision-and-Language Navigation | CVPR 2022 | 离散 | EnvEdit 通过编辑已有环境的风格、物体外观与类别生成新环境做数据增强，提升对未见环境的泛化。 | — | [[topics/papers/视觉语言导航VLN/5-08_2203.15685_EnvEdit.pdf\|PDF]] · [代码](https://github.com/jialuli-luka/EnvEdit) |

### 预训练与Transformer

| 日期 | 论文 | 发表 | 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2020-02 | [**PREVALENT**](https://arxiv.org/abs/2002.10638)<br>Towards Learning a Generic Agent for Vision-and-Language Navigation via Pre-training | CVPR 2020 | 离散 | PREVALENT 首次提出 VLN 预训练-微调范式，在大规模图像-文本-动作三元组上自监督预训练通用表示。 | improves the state-of-the-art from 47% to 51% on success rate weighted by path length | [[topics/papers/视觉语言导航VLN/5-09_2002.10638_PREVALENT.pdf\|PDF]] · [代码](https://github.com/weituo12321/PREVALENT) |
| 2020-04 | [**VLN-BERT**](https://arxiv.org/abs/2004.14973)<br>Improving Vision-and-Language Navigation with Image-Text Pairs from the Web | ECCV 2020 | 离散 | VLN-BERT 用 Transformer 给指令与全景轨迹打兼容分，先在网络图文对上预训练再在路径-指令数据上微调。 | outperforming the prior state-of-the-art in the fully-observed setting by 4 absolute percentage points on success rate | [[topics/papers/视觉语言导航VLN/5-10_2004.14973_VLN-BERT.pdf\|PDF]] · [代码](https://github.com/arjunmajum/vln-bert) |
| 2020-11 | [**Recurrent VLN-BERT**](https://arxiv.org/abs/2011.13922)<br>A Recurrent Vision-and-Language BERT for Navigation | CVPR 2021 (Oral) | 离散 | Recurrent VLN-BERT 为 V&L BERT 加入循环状态以适配部分可观测的序列决策，可替代复杂编码-解码结构。 | — | [[topics/papers/视觉语言导航VLN/5-11_2011.13922_Recurrent-VLN-BERT.pdf\|PDF]] · [代码](https://github.com/YicongHong/Recurrent-VLN-BERT) |
| 2021-08 | [**Airbert**](https://arxiv.org/abs/2108.09105)<br>In-domain Pretraining for Vision-and-Language Navigation | ICCV 2021 | 离散 | Airbert 从租房网站构建大规模域内图文数据 BnB 并自动生成路径-指令对，配合打乱损失做域内预训练。 | — | [[topics/papers/视觉语言导航VLN/5-12_2108.09105_Airbert.pdf\|PDF]] · [代码](https://github.com/airbert-vln/airbert) · [主页](https://airbert-vln.github.io/) |
| 2022-03 | [**HOP**](https://arxiv.org/abs/2203.11591)<br>History-and-Order Aware Pre-training for Vision-and-Language Navigation | CVPR 2022 | 离散 | HOP 在 MLM/TIM 之外加入轨迹顺序、分组顺序建模与带历史的动作预测等 VLN 专用预训练任务。 | — | [[topics/papers/视觉语言导航VLN/5-13_2203.11591_HOP.pdf\|PDF]] · [代码](https://github.com/YanyuanQiao/HOP-VLN) |
| 2023-04 | [**VLN-SIG**](https://arxiv.org/abs/2304.04907)<br>Improving Vision-and-Language Navigation by Generating Future-View Image Semantics | CVPR 2023 | 离散 | VLN-SIG 在预训练与微调中让智能体生成未来视角的图像语义（MPM/MTM/APIG），以预期未来辅助决策。 | — | [[topics/papers/视觉语言导航VLN/5-14_2304.04907_VLN-SIG.pdf\|PDF]] · [代码](https://github.com/jialuli-luka/VLN-SIG) · [主页](https://jialuli-luka.github.io/VLN-SIG) |
| 2023-07 | [**Learning Vision-and-Language Navigation from YouTube Videos**](https://arxiv.org/abs/2307.11984) | ICCV 2023 | 离散 | Lily 从 YouTube 房屋巡览视频自动构建路径-指令对并预训练智能体，加入轨迹判断任务挖掘布局知识。 | — | [[topics/papers/视觉语言导航VLN/5-15_2307.11984_Learning-Vision-and-Language-Navigation.pdf\|PDF]] · [代码](https://github.com/JeremyLinky/YouTube-VLN) |

### 历史与拓扑图

| 日期 | 论文 | 发表 | 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2020-12 | [**Topological Planning with Transformers for Vision-and-Language Navigation**](https://arxiv.org/abs/2012.05292) | — | 连续 | 模块化方法：给定指令与拓扑图，用注意力预测图上导航计划，再由鲁棒控制器以低层动作执行。 | — | [[topics/papers/视觉语言导航VLN/5-16_2012.05292_Topological-Planning-with-Transformers.pdf\|PDF]] |
| 2021-03 | [**SSM**](https://arxiv.org/abs/2103.03454)<br>Structured Scene Memory for Vision-Language Navigation | CVPR 2021 | 离散 | SSM 用结构化场景记忆存储视觉与几何线索，以全部可达位置为动作空间，结合前沿探索做全局规划。 | — | [[topics/papers/视觉语言导航VLN/5-17_2103.03454_SSM.pdf\|PDF]] · [代码](https://github.com/HanqingWangAI/SSM-VLN) |
| 2021-10 | [**HAMT**](https://arxiv.org/abs/2110.13309)<br>History Aware Multimodal Transformer for Vision-and-Language Navigation | NeurIPS 2021 | 离散 | HAMT 用分层 ViT 编码全部历史全景观测，与文本和当前观测联合决策，取代循环状态记忆。 | — | [[topics/papers/视觉语言导航VLN/5-18_2110.13309_HAMT.pdf\|PDF]] · [代码](https://github.com/cshizhe/VLN-HAMT) · [主页](https://cshizhe.github.io/projects/vln_hamt.html) |
| 2022-02 | [**DUET**](https://arxiv.org/abs/2202.11742)<br>Think Global, Act Local: Dual-scale Graph Transformer for Vision-and-Language Navigation | CVPR 2022 | 离散 | DUET 在线构建拓扑图，用双尺度图 Transformer 融合局部细粒度编码与全局粗粒度规划。 | — | [[topics/papers/视觉语言导航VLN/5-19_2202.11742_DUET.pdf\|PDF]] · [代码](https://github.com/cshizhe/VLN-DUET) · [主页](https://cshizhe.github.io/projects/vln_duet.html) |
| 2023-03 | [**Meta-Explore**](https://arxiv.org/abs/2303.04077)<br>Exploratory Hierarchical Vision-and-Language Navigation Using Scene Object Spectrum Grounding | CVPR 2023 | 离散 | Meta-Explore 分层导航：用利用策略选择未访问但可观测的局部目标纠错，并提出场景物体频谱 SOS 特征。 | significantly improves the success rate by 17.1% and SPL by 20.6% for the SOON benchmark | [[topics/papers/视觉语言导航VLN/5-20_2303.04077_Meta-Explore.pdf\|PDF]] · [主页](https://rllab-snu.github.io/projects/Meta-Explore/doc.html) |

### 连续环境与航点

| 日期 | 论文 | 发表 | 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2021-10 | [**Waypoint Models**](https://arxiv.org/abs/2110.02207)<br>Waypoint Models for Instruction-guided Navigation in Continuous Environments | ICCV 2021 (Oral) | 连续 | 在 VLN-CE 中提出语言条件航点预测网络，系统比较从低层动作到连续航点不同表达力的动作空间。 | increasing success rate by 4% with our best model on this challenging task | [[topics/papers/视觉语言导航VLN/5-21_2110.02207_Waypoint-Models.pdf\|PDF]] · [代码](https://github.com/jacobkrantz/VLN-CE) · [主页](https://jacobkrantz.github.io/waypoint-vlnce) |
| 2022-03 | [**Bridging the Gap Between Learning in Discrete and Continuous Environments for Vision-and-Language Navigation**](https://arxiv.org/abs/2203.02764) | CVPR 2022 | 连续 | 提出候选航点预测器（CWP），让离散环境设计的高层动作智能体可迁移到连续环境训练与导航。 | reduces the absolute discrete-to-continuous gap by 11.76% Success Weighted by Path Length (SPL) for the Cross-Modal Matching Agent and 18.24% SPL for the Recurrent VLN-BERT | [[topics/papers/视觉语言导航VLN/5-22_2203.02764_Bridging-the-Gap-Between-Learning-in.pdf\|PDF]] · [代码](https://github.com/YicongHong/Discrete-Continuous-VLN) |
| 2022-04 | [**Sim-2-Sim**](https://arxiv.org/abs/2204.09667)<br>Sim-2-Sim Transfer for Vision-and-Language Navigation in Continuous Environments | ECCV 2022 (Oral) | 连续 | 把离散 VLN 训练的智能体迁移到连续 VLN-CE（sim-2-sim），并逐项分析造成性能下降的差异。 | improving over the prior state of the art in VLN-CE by +12% success rate | [[topics/papers/视觉语言导航VLN/5-23_2204.09667_Sim-2-Sim.pdf\|PDF]] · [代码](https://github.com/jacobkrantz/Sim2Sim-VLNCE) · [主页](https://jacobkrantz.github.io/sim-2-sim) |
| 2023-04 | [**ETPNav**](https://arxiv.org/abs/2304.03047)<br>Evolving Topological Planning for Vision-Language Navigation in Continuous Environments | TPAMI 2024 | 连续 | ETPNav 由预测航点在线构建拓扑图，Transformer 跨模态规划器出计划，再由避障控制器执行。 | ETPNav yields more than 10% and 20% improvements over prior state-of-the-art on R2R-CE and RxR-CE datasets, respectively. | [[topics/papers/视觉语言导航VLN/5-24_2304.03047_ETPNav.pdf\|PDF]] · [代码](https://github.com/MarSaKi/ETPNav) |
| 2023-08 | [**DREAMWALKER**](https://arxiv.org/abs/2308.07498)<br>Mental Planning for Continuous Vision-Language Navigation | ICCV 2023 | 连续 | DreamWalker 构建离散结构化世界模型，在内部想象中模拟并评估候选计划后再执行（心智规划）。 | — | [[topics/papers/视觉语言导航VLN/5-25_2308.07498_DREAMWALKER.pdf\|PDF]] · [代码](https://github.com/hanqingwangai/Dreamwalker) |
| 2024-04 | [**HNR**](https://arxiv.org/abs/2404.01943)<br>Lookahead Exploration with Neural Radiance Representation for Continuous Vision-Language Navigation | CVPR 2024 | 连续 | HNR 预训练分层神经辐射表示预测候选位置的未来语义特征，构建未来路径树进行前瞻评估选择。 | — | [[topics/papers/视觉语言导航VLN/5-26_2404.01943_HNR.pdf\|PDF]] · [代码](https://github.com/MrZihan/HNR-VLN) |

### 地图与环境表示

| 日期 | 论文 | 发表 | 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2022-03 | [**CM2**](https://arxiv.org/abs/2203.05137)<br>Cross-modal Map Learning for Vision and Language Navigation | CVPR 2022 | 连续 | CM2 先在语言引导下预测自我中心俯视语义地图（含未观测区域），再在地图上预测通往目标的航点路径。 | — | [[topics/papers/视觉语言导航VLN/5-27_2203.05137_CM2.pdf\|PDF]] · [代码](https://github.com/ggeorgak11/CM2) · [主页](https://ggeorgak11.github.io/CM2-project/) |
| 2022-12 | [**BEVBert**](https://arxiv.org/abs/2212.04385)<br>Multimodal Map Pre-training for Language-guided Navigation | ICCV 2023 | 多种 | BEVBert 结合局部度量地图与全局拓扑图的混合地图，并在其上做多模态地图预训练。 | — | [[topics/papers/视觉语言导航VLN/5-28_2212.04385_BEVBert.pdf\|PDF]] · [代码](https://github.com/MarSaKi/VLN-BEVBert) |
| 2023-07 | [**GridMM**](https://arxiv.org/abs/2307.12907)<br>Grid Memory Map for Vision-and-Language Navigation | ICCV 2023 | 多种 | GridMM 将历史观测投影到动态增长的俯视网格记忆地图，并按指令相关性聚合各网格的细粒度线索。 | — | [[topics/papers/视觉语言导航VLN/5-29_2307.12907_GridMM.pdf\|PDF]] · [代码](https://github.com/MrZihan/GridMM) |
| 2024-03 | [**VER**](https://arxiv.org/abs/2403.14158)<br>Volumetric Environment Representation for Vision-Language Navigation | CVPR 2024 | 离散 | VER 将环境体素化为 3D 单元聚合多视角特征，多任务预测占据、房间布局与 3D 框，用于导航记忆与决策。 | — | [[topics/papers/视觉语言导航VLN/5-30_2403.14158_VER.pdf\|PDF]] · [代码](https://github.com/DefaultRui/VLN-VER) |

### 其他

| 日期 | 论文 | 发表 | 环境 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2023-03 | [**KERM**](https://arxiv.org/abs/2303.15796)<br>Knowledge Enhanced Reasoning for Vision-and-Language Navigation | CVPR 2023 | 离散 | KERM 按视野局部区域从知识库检索语言化事实，并通过净化、事实交互与指令聚合模块融入导航决策。 | — | [[topics/papers/视觉语言导航VLN/5-31_2303.15796_KERM.pdf\|PDF]] · [代码](https://github.com/XiangyangLi20/KERM) |

## 附：笔记库里已有的 VLN 相关工作

- 亮源 [[lightorigins/notes/02_LightNav-0|LightNav-0]]：已收在第三节，笔记里有初稿和高亮。
- [[topics/语义3DGS与具身导航|语义3DGS与具身导航]] 专题里用 3D 高斯做 VLN 的工作，这里不重复列：
  - [[topics/notes/语义3DGS与具身导航/1-02_UnitedVLN|UnitedVLN]]（2411.16053）
  - [[topics/notes/语义3DGS与具身导航/1-06_SINGER|SINGER]]（2509.18610）
  - [[topics/notes/语义3DGS与具身导航/1-09_3D-Gaussian-Map-with-Open-Set-Semantic|3D Gaussian Map with Open-Set Semantic Grouping for Vision-Language Navigation]]（2605.26500）
  - [[topics/notes/语义3DGS与具身导航/1-10_Uncertainty-Aware-Gaussian-Map-for|Uncertainty-Aware Gaussian Map for Vision-Language Navigation]]（2605.26503）
  - [[topics/notes/语义3DGS与具身导航/2-02_Openfly|Openfly]]（2502.18041）
  - [[topics/notes/语义3DGS与具身导航/2-05_GRaD-Nav++|GRaD-Nav++]]（2506.14009）
  - [[topics/notes/语义3DGS与具身导航/2-10_HUGE-Bench|HUGE-Bench]]（2603.19822）
  - [[topics/notes/语义3DGS与具身导航/2-11_POINav|POINav]]（2605.28237）
  - [[topics/notes/语义3DGS与具身导航/2-12_GN0|GN0]]（2606.03682）
  - [[topics/notes/语义3DGS与具身导航/2-13_HumanoidVLN|HumanoidVLN]]（2608.12860）

## 附：检索中看到、没有放进正文的

标题已对照 arXiv 核对，和正文里的工作同类或较边缘，想扩充时可以从这里挑：

**零样本智能体**

- [CorNav: Autonomous Agent with Self-Corrected Planning for Zero-Shot Vision-and-Language Navigation](https://arxiv.org/abs/2306.10322)（2023-06）
- [VELMA: Verbalization Embodiment of LLM Agents for Vision and Language Navigation in Street View](https://arxiv.org/abs/2307.06082)（2023-07）
- [TINA: Think, Interaction, and Action Framework for Zero-Shot Vision Language Navigation](https://arxiv.org/abs/2403.08833)（2024-03）
- [MC-GPT: Empowering Vision-and-Language Navigation with Memory Map and Reasoning Chains](https://arxiv.org/abs/2405.10620)（2024-05）
- [Mobility VLA: Multimodal Instruction Navigation with Long-Context VLMs and Topological Graphs](https://arxiv.org/abs/2407.07775)（2024-07）
- [Exploring Spatial Representation to Enhance LLM Reasoning in Aerial Vision-Language Navigation](https://arxiv.org/abs/2410.08500)（2024-10）
- [VLN-Zero: Rapid Exploration and Cache-Enabled Neurosymbolic Vision-Language Planning for Zero-Shot Transfer in Robot Navigation](https://arxiv.org/abs/2509.18592)（2025-09）
- [Fast-SmartWay: Panoramic-Free End-to-End Zero-Shot Vision-and-Language Navigation](https://arxiv.org/abs/2511.00933)（2025-11）
- [Run, Ruminate, and Regulate: A Dual-process Thinking System for Vision-and-Language Navigation](https://arxiv.org/abs/2511.14131)（2025-11）
- [DV-VLN: Dual Verification for Reliable LLM-Based Vision-and-Language Navigation](https://arxiv.org/abs/2601.18492)（2026-01）
- [One Agent to Guide Them All: Empowering MLLMs for Vision-and-Language Navigation via Explicit World Representation](https://arxiv.org/abs/2602.15400)（2026-02）
- [OnFly: Onboard Zero-Shot Aerial Vision-Language Navigation toward Safety and Efficiency](https://arxiv.org/abs/2603.10682)（2026-03）
- [HiMemVLN: Enhancing Reliability of Open-Source Zero-Shot Vision-and-Language Navigation with Hierarchical Memory System](https://arxiv.org/abs/2603.14807)（2026-03）
- [FineCog-Nav: Integrating Fine-grained Cognitive Modules for Zero-shot Multimodal UAV Navigation](https://arxiv.org/abs/2604.16298)（2026-04）
- [Uni-LaViRA: Language-Vision-Robot Actions Translation for Unified Embodied Navigation](https://arxiv.org/abs/2605.27582)（2026-05）
- [One MLLM, One Call: Efficient Zero-Shot Vision-and-Language Navigation via Spatial-Aware Waypoints](https://arxiv.org/abs/2609.06476)（2026-09）
- [C$^2$Nav: Compare Before You Commit for Zero-Shot Vision-and-Language Navigation](https://arxiv.org/abs/2609.15142)（2026-09）
- [GPT-6-Astra Lights Up Embodied Navigation: Evaluation in Zero-Shot Vision-and-Language Navigation in Continuous Environments](https://arxiv.org/abs/2609.29861)（2026-09）
- [NavHarness: Towards Lifelong Embodied Navigation](https://arxiv.org/abs/2609.34276)（2026-09）
- [What Should a Navigator Remember? Spatiotemporal Memory for Zero-Shot Vision-Language Navigation](https://arxiv.org/abs/2610.38318)（2026-10）

**训练的导航模型**

- [Learning to Reason and Navigate: Parameter Efficient Action Planning with Large Language Models](https://arxiv.org/abs/2505.07500)（2025-05）
- [OmniVLA: An Omni-Modal Vision-Language-Action Model for Robot Navigation](https://arxiv.org/abs/2509.19480)（2025-09）
- [AdaNav: Adaptive Reasoning with Uncertainty for Vision-Language Navigation](https://arxiv.org/abs/2509.24387)（2025-09）
- [Progress-Think: Semantic Progress Reasoning for Vision-Language Navigation](https://arxiv.org/abs/2511.17097)（2025-11）
- [NavForesee: A Unified Vision-Language World Model for Hierarchical Planning and Dual-Horizon Navigation Prediction](https://arxiv.org/abs/2512.01550)（2025-12）
- [SeeNav-Agent: Enhancing Vision-Language Navigation with Visual Prompt and Step-Level Policy Optimization](https://arxiv.org/abs/2512.02631)（2025-12）
- [ETP-R1: Evolving Topological Planning with Reinforcement Fine-tuning for Vision-Language Navigation in Continuous Environments](https://arxiv.org/abs/2512.20940)（2025-12）
- [FantasyVLN: Unified Multimodal Chain-of-Thought Reasoning for Vision-Language Navigation](https://arxiv.org/abs/2601.13976)（2026-01）
- [\textsc{NaVIDA}: Vision-Language Navigation with Inverse Dynamics Augmentation](https://arxiv.org/abs/2601.18188)（2026-01）
- [TIC-VLA: A Think-in-Control Vision-Language-Action Model for Robot Navigation in Dynamic Environments](https://arxiv.org/abs/2602.02459)（2026-02）
- [AutoFly: Vision-Language-Action Model for UAV Autonomous Navigation in the Wild](https://arxiv.org/abs/2602.09657)（2026-02）
- [PROSPECT: Unified Streaming Vision-Language Navigation via Semantic--Spatial Fusion and Latent Predictive Representation](https://arxiv.org/abs/2603.03739)（2026-03）
- [OmniVLN: Omnidirectional 3D Perception and Token-Efficient LLM Reasoning for Visual-Language Navigation across Air and Ground Platforms](https://arxiv.org/abs/2603.17351)（2026-03）
- [DyGeoVLN: Infusing Dynamic Geometry Foundation Model into Vision-Language Navigation](https://arxiv.org/abs/2603.21269)（2026-03）
- [LatentPilot: Scene-Aware Vision-and-Language Navigation by Dreaming Ahead with Latent Visual Reasoning](https://arxiv.org/abs/2603.29165)（2026-03）
- [FreqCache: Accelerating Embodied VLN Models with Adaptive Frequency-Guided Token Caching](https://arxiv.org/abs/2604.24391)（2026-04）
- [WorldVLN: Autoregressive World Action Model for Aerial Vision-Language Navigation](https://arxiv.org/abs/2605.15964)（2026-05）
- [SEDualVLN: A Spatially-Enhanced Dual-System Framework for Vision-Language Navigation](https://arxiv.org/abs/2605.17249)（2026-05）
- [Qwen-VLA: Unifying Vision-Language-Action Modeling across Tasks, Environments, and Robot Embodiments](https://arxiv.org/abs/2605.30280)（2026-05）
- [VEGA: Learning Navigation VLAs from In-the-Wild Egocentric Video with Geometric Trajectory Supervision](https://arxiv.org/abs/2606.18426)（2026-06）
- [Traj-VLN: Learning Pixel-Space Interaction via Autoregressive Trajectory Generation](https://arxiv.org/abs/2607.10744)（2026-07）
- [ReflectVLN: Training Vision-Language Navigation Agents with Reflective Reasoning](https://arxiv.org/abs/2607.12680)（2026-07）
- [Token-Wise Latent Streaming from Slow Reasoners to Fast Planners for Dynamic Vision Language Navigation](https://arxiv.org/abs/2607.16806)（2026-07）
- [AdaGeoVLN: Selective Geometry Across Representation Depth and Navigation Time for Vision-Language Navigation](https://arxiv.org/abs/2609.18789)（2026-09）
- [GroundingVLN: Reasoning and Acting with Grounding for Vision-Language Navigation](https://arxiv.org/abs/2609.18581)（2026-09）
- [FINE: Future-Informed Navigation Encoding for Data-Efficient Vision-Language Navigation](https://arxiv.org/abs/2609.32855)（2026-09）
- [ForeFly: A Dual-Horizon World Action Model for Aerial Vision-Language Navigation](https://arxiv.org/abs/2609.33581)（2026-09）
- [EdgeVLN: Runtime-Aware Deployment Ready Quantized Vision Language Navigation Model](https://arxiv.org/abs/2609.35570)（2026-09）
- [PanoVLN: Towards Effective Panoramic Vision-and-Language Navigation](https://arxiv.org/abs/2609.34759)（2026-09）
- [GeoScaffold: Learning Compact Geometric Latents via Reconstruction for Efficient Vision-Language Navigation](https://arxiv.org/abs/2610.02697)（2026-10）
- [LightVLN: Efficient Aerial Vision-and-Language Navigation with Compact Memory and History-Guided Local Aggregation](https://arxiv.org/abs/2610.05024)（2026-10）
- [StageVLN: Spatial and Trajectory Auxiliary Guidance for Efficient Vision-Language Navigation](https://arxiv.org/abs/2610.05664)（2026-10）
- [SPW-Nav: A Streaming Panoramic World Model for Language-Guided Navigation](https://arxiv.org/abs/2610.08941)（2026-10）
- [GuidedNav: Shaping Vision-Language Navigation Representations through Pre-action Attention and Spatial Guidance](https://arxiv.org/abs/2610.13122)（2026-10）
- [DR-VLA: Learning Human-Like Quadruped Navigation from Egocentric Web Videos via Domain-Invariant Scene Representations](https://arxiv.org/abs/2610.18373)（2026-10）
- [MemoryVLN: From Ego-Aware Memory Representation to Cross-Context Memory Reuse in Vision-Language Navigation](https://arxiv.org/abs/2610.18478)（2026-10）
- [X-Fly: Learning to Reach and Stop in Full-Chunk Aerial Vision-Language Navigation](https://arxiv.org/abs/2610.21450)（2026-10）
- [MOON: Learning When to Forget and How to Move On in Vision-and-Language Navigation](https://arxiv.org/abs/2610.33546)（2026-10）
- [OpenFlyV2: An onboard vision-language-action model for aerial perception and navigation](https://arxiv.org/abs/2610.39287)（2026-10）

**任务、基准与数据**

- [Generating Landmark Navigation Instructions from Maps as a Graph-to-Text Problem](https://arxiv.org/abs/2012.15329)（2020-12）
- [Vision-Language Navigation: A Survey and Taxonomy](https://arxiv.org/abs/2108.11544)（2021-08）
- [World-Consistent Data Generation for Vision-and-Language Navigation](https://arxiv.org/abs/2412.06413)（2024-12）
- [HA-VLN 2.0: An Open Benchmark and Leaderboard for Human-Aware Navigation in Discrete and Continuous Environments with Dynamic Multi-Human Interactions](https://arxiv.org/abs/2503.14229)（2025-03）
- [UAV-Flow Colosseo: A Real-World Benchmark for Flying-on-a-Word UAV Imitation Learning](https://arxiv.org/abs/2505.15725)（2025-05）
- [IndoorUAV: Benchmarking Vision-Language UAV Navigation in Continuous Indoor Environments](https://arxiv.org/abs/2512.19024)（2025-12）
- [FloorPlan-VLN: A New Paradigm for Floor Plan Guided Vision-Language Navigation](https://arxiv.org/abs/2603.17437)（2026-03）
- [NavTrust: Benchmarking Trustworthiness for Embodied Navigation](https://arxiv.org/abs/2603.19229)（2026-03）
- [NavVerse: Benchmarking Indoor-to-Outdoor Embodied Navigation in Continuous Robot Simulation](https://arxiv.org/abs/2607.19695)（2026-07）
- [DPed-VLN: A Benchmark for Socially Compliant Vision-and-Language Navigation in Dynamic Pedestrian Environments](https://arxiv.org/abs/2609.21504)（2026-09）
- [NavGen: Visual Generative Models as a Scalable Data Engine for Embodied 3D Navigation](https://arxiv.org/abs/2609.30770)（2026-09）
- [Systematic Multi-Agent Vision-and-Language Navigation: Formulation, Benchmark, and Method](https://arxiv.org/abs/2609.35965)（2026-09）
- [Sim-to-Real Transfer of Vision-Language Navigation in Continuous Environments Using an Ackermann-Steered Mobile Robot](https://arxiv.org/abs/2610.07192)（2026-10）
- [AirGroundVLN: A Large-Scale Benchmark for Goal-Oriented Air-Ground Collaborative Vision-and-Language Navigation](https://arxiv.org/abs/2610.10421)（2026-10）

**经典方法**

- [Look Before You Leap: Bridging Model-Free and Model-Based Reinforcement Learning for Planned-Ahead Vision-and-Language Navigation](https://arxiv.org/abs/1803.07729)（2018-03）
- [Language-Aligned Waypoint (LAW) Supervision for Vision-and-Language Navigation in Continuous Environments](https://arxiv.org/abs/2109.15207)（2021-09）
- [ADAPT: Vision-Language Navigation with Modality-Aligned Action Prompts](https://arxiv.org/abs/2205.15509)（2022-05）
- [Bird's-Eye-View Scene Graph for Vision-Language Navigation](https://arxiv.org/abs/2308.04758)（2023-08）
- [Vision-and-Language Navigation via Causal Learning](https://arxiv.org/abs/2404.10241)（2024-04）

**没有 arXiv 版本**

- [InternVLA-N1 技术报告](https://internrobotics.github.io/internvla-n1.github.io/static/pdfs/InternVLA_N1.pdf)：只在项目主页提供 PDF；对应的 arXiv 论文是第三节的 DualVLN（Ground Slow, Move Fast）。
