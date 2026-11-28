---
title: JEPA系列
tags: [topic]
paper_count: 26
updated: 2026-11-28
---

# JEPA系列

> [!info] 这份清单怎么来的
> 2026-11-28 新开，起点是 [[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|When JEPA Learns Latent Maps]]（NYU Mengye Ren 组 + LeCun 的技术报告）。收的是 **JEPA（Joint Embedding Predictive Architecture）及其世界模型**：防坍塌办法（stop-gradient 还是分布正则）、潜空间几何与规划、JEPA 的理论（可辨识性、Koopman、因果）、JEPA 在导航 / 驾驶 / 机器人上的应用。
> - 来源：那篇报告的参考文献 + 2026-11-28 的网页搜索。所有 arXiv 号、标题、作者、首版日期都对照 arXiv API 核对过。
> - **26 篇都有单篇笔记**（`topics/notes/JEPA系列/`，总览里有"JEPA系列"视图）。1-01 由 Claude 读全文写；其余 25 篇由 5 个 Claude 子任务各读 5 篇全文写初稿，表里的"做法"取自各笔记。笔记里写着"需核对"的地方是论文自己前后不一致或 PDF 文字提取乱序的数字。
> - PDF 在 `topics/papers/JEPA系列/`，文件名开头的"节号-序号"和表格一致（下载的是 2026-11-28 时 arXiv 上的最新版本，只存在本地，不进 git）。1-01 没有 arXiv，PDF 从 alphaXiv 下载（公司网络的 Fortinet 防火墙拦了作者的 CDN）。
> - 没收进来的：**Social-JEPA**（arXiv 2603.02263，独立训练的 JEPA 智能体潜空间之间只差一个线性等距映射）已被作者从 arXiv 撤稿，所有版本都下载不到。[[xsquare/notes/23_EgoJEPA|EgoJEPA]]（自我中心视频 → 灵巧操作）笔记在自变量文件夹，列在第四节末尾。

## 一句话脉络

1. **奠基**：I-JEPA（2023）→ V-JEPA（2024）→ V-JEPA 2（2025）：在表示空间里做掩码预测，靠 stop-gradient + EMA 防坍塌；V-JEPA 2-AC 第一次把冻结的 JEPA 特征拿来做机器人潜空间 MPC。
2. **世界模型与规划**：DINO-WM 用冻结 DINOv2 特征 + CEM 零样本规划；What Drives Success 系统梳理这类模型的设计选择；PLDM、LeWM 改成从像素端到端训练、不用 stop-gradient（VICReg 式 / SIGReg）。
3. **防坍塌正则本身成了研究对象**：LeJEPA 证明各向同性高斯最优并提出 SIGReg；VISReg 用 Sliced Wasserstein 替换协方差项。早在 2022 年 Sobal 等就发现 JEPA 偏爱慢特征（静态背景）；MotionJEPA 发现 SIGReg 世界模型会压掉快变物体，加帧差预测补回来。
4. **潜空间几何决定规划**：Temporal Straightening（曲率正则）、Content–Geometry Tradeoff（SVReg / Slow SVReg，潜在地图）、CommuteTimeWM（潜距离 = commute time）、SD-JEPA（拆出"进度"子空间）、LpWM（稀疏码）都在回答"什么样的潜空间好规划"。
5. **理论**：When Does LeJEPA Learn a World Model?（高斯世界下线性可辨识）→ Beyond Gaussian Worlds（推广到黎曼流形）；I Act Therefore I Am（动作足够多样时可辨识因果隐变量）；Koopman Invariants（时间序列聚类 = Koopman 不变子空间）。
6. **应用**：InJePA（视觉导航）、JEPTERA（无人机）、Auto-JEPA（自动驾驶），大多是在冻结的 V-JEPA 2 特征上接规划器。

## 建议的阅读顺序

1. [[topics/notes/JEPA系列/2-01_I-JEPA|I-JEPA]] → [[topics/notes/JEPA系列/2-03_V-JEPA2|V-JEPA 2]]：JEPA 是什么，怎么扩到视频和机器人。
2. [[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]]：潜空间世界模型 + CEM 规划的基本套路，后面几乎都用它的基准。
3. [[topics/notes/JEPA系列/2-05_LeJEPA|LeJEPA]] → [[topics/notes/JEPA系列/1-05_LeWM|LeWM]]：SIGReg，以及从像素端到端、不用 stop-gradient 的世界模型。
4. [[topics/notes/JEPA系列/1-04_TemporalStraightening|Temporal Straightening]] → [[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]]：同一组人，从"拉直潜轨迹"到"潜在地图 + 内容–几何权衡"。
5. [[topics/notes/JEPA系列/2-07_MotionJEPA|MotionJEPA]]、[[topics/notes/JEPA系列/1-10_CommuteTimeWM|CommuteTimeWM]]：同一时期对 LeWM 的两种改法。
6. [[topics/notes/JEPA系列/3-02_WhenLeJEPAWorldModel|When Does LeJEPA Learn a World Model?]]：理论收尾。

| 节 | 篇数 |
|---|---|
| [[#一、JEPA 世界模型与规划]] | 12 |
| [[#二、JEPA 奠基与防坍塌正则]] | 7 |
| [[#三、JEPA 理论]] | 4 |
| [[#四、导航、驾驶与机器人应用]] | 4 |

## 一、JEPA 世界模型与规划

用 JEPA 学潜动力学、在潜空间里规划。按首版日期排序。

| 日期 | 工作 | 机构 | 做法 | 链接 |
|---|---|---|---|---|
| 2024-11 | [**DINO-WM**](https://arxiv.org/abs/2411.04983)<br>World Models on Pre-trained Visual Features enable Zero-shot Planning | NYU、Meta（Gaoyue Zhou、Lerrel Pinto、Yann LeCun） | 用冻结的 DINOv2 patch 特征作潜状态，训练帧级因果 ViT 预测下一帧特征（不重建像素、不用奖励）。测试时用 CEM+MPC 最小化预测终态与目标图潜变量的 MSE，零样本规划。PushT 成功率 0.90，DreamerV3 只有 0.30；导航任务与 DreamerV3 持平。缺点是一次规划要 53 s。 | [[topics/notes/JEPA系列/1-02_DINO-WM\|笔记]] · [[topics/papers/JEPA系列/1-02_2411.04983_DINO-WM.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2411.04983) |
| 2025-02 | [**PLDM**](https://arxiv.org/abs/2502.14819)<br>Learning from Reward-Free Offline Data: A Case for Planning with Latent Dynamics Models | NYU、Meta FAIR 等（Vlad Sobal、Wancong Zhang、Randall Balestriero、Yann LeCun） | 端到端训练 JEPA 潜动力学模型（VICReg 方差/协方差 + 时间平滑 + 逆动力学防坍塌），用 MPPI 加集成不确定性项规划。在 23 个无奖励离线导航数据集上与 5 种离线 RL 方法对比，PLDM 是唯一各项都有竞争力的方法，迁移到没见过的迷宫布局最好。弱项是拼接："数据从不穿门"时只有 34.4%，HILP 为 100%。NeurIPS 2025。 | [[topics/notes/JEPA系列/1-03_PLDM\|笔记]] · [[topics/papers/JEPA系列/1-03_2502.14819_PLDM.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2502.14819) |
| 2025-12 | [**What Drives Success**](https://arxiv.org/abs/2512.24497)<br>What Drives Success in Physical Planning with Joint-Embedding Predictive World Models? | Meta FAIR、Inria、ENS、NYU（Basile Terver、Adrien Bardes、Jean Ponce、Yann LeCun） | 系统对比冻结编码器式 JEPA 世界模型的设计选择：规划器、多步展开损失、本体感受、上下文长度、编码器、动作条件、模型与数据规模。CEM+L2 最好，DINO 系编码器优于 V-JEPA 系，仿真里加大模型无益而真实数据有益。组合配方在 8 项中 7 项超过 DINO-WM 和 V-JEPA-2-AC（DROID 48.2 对 39.4/42.9）。TMLR 2026。 | [[topics/notes/JEPA系列/1-06_WhatDrivesSuccess\|笔记]] · [[topics/papers/JEPA系列/1-06_2512.24497_WhatDrivesSuccess.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2512.24497) |
| 2026-01 | [**VJEPA**](https://arxiv.org/abs/2601.14354)<br>Variational Joint Embedding Predictive Architectures as Probabilistic World Models | University of Aberdeen（据邮箱推断；Yongchao Huang 单作者） | 把 JEPA 的 MSE 读成固定方差高斯似然，推广为预测潜变量分布的 VJEPA（NLL + KL），证明全局最优不坍塌、预测充分时潜状态足以做最优控制；BJEPA 用 Product of Experts 组合动力学专家和先验专家。唯一实验是 4 维线性"Noisy TV"系统：σ=8 时 VAE / 像素 AR 的信号 R² 掉到 0.50 / 0.58，JEPA 一族在 0.84 以上，但确定性 JEPA（0.93）反而最高。没有规划实验 | [[topics/notes/JEPA系列/1-12_VJEPA\|笔记]] · [[topics/papers/JEPA系列/1-12_2601.14354_VJEPA.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2601.14354) |
| 2026-02 | [**Causal-JEPA**](https://arxiv.org/abs/2602.11389)<br>Learning World Models through Object-Level Latent Masking | Brown、GalilAI、NYU、Mila（Heejeong Nam、Lucas Maes、Yann LeCun、Randall Balestriero） | 在冻结的 VideoSAUR slot 上训练双向 JEPA 预测器，训练时遮住若干物体在整个历史窗口里的 slot（只保留最早一帧作身份锚点），逼模型从其他物体和动作推断被遮物体。CLEVRER 反事实题比不遮历史的同架构高约 20 个百分点（47.68 → 68.81）。Push-T 上只用 DINO-WM 1.02% 的潜输入达到 88.67%（DINO-WM 91.33%），规划快 8 倍以上。ICML 2026。 | [[topics/notes/JEPA系列/1-11_Causal-JEPA\|笔记]] · [[topics/papers/JEPA系列/1-11_2602.11389_Causal-JEPA.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2602.11389) |
| 2026-03 | [**Temporal Straightening**](https://arxiv.org/abs/2603.12231)<br>Temporal Straightening for Latent Planning | NYU、Brown、Toronto（Ying Wang、Gaoyue Zhou、Yann LeCun、Mengye Ren） | 训练 JEPA 世界模型时加曲率正则 1−cos(v_t, v_{t+1})，让潜轨迹变直，防坍塌用 stop-gradient。线性情形下证明这能降低规划 Hessian 的条件数。拉直后潜距离贴近测地距离，梯度下降规划在 Wall/UMaze 的 MPC 达 100%；UMaze 开环从 DINO-WM 的 35.3% 升到 94.0%。ICML 2026。 | [[topics/notes/JEPA系列/1-04_TemporalStraightening\|笔记]] · [[topics/papers/JEPA系列/1-04_2603.12231_TemporalStraightening.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2603.12231) |
| 2026-03 | [**LeWM**](https://arxiv.org/abs/2603.19312)<br>LeWorldModel: Stable End-to-End JEPA from Pixels | Mila、NYU、Brown（Lucas Maes、Quentin Le Lidec、Yann LeCun、Randall Balestriero） | 从像素端到端训练 JEPA 世界模型：ViT-Tiny 输出单个 [CLS]，经 BN 投影得 192 维潜变量，预测器用 AdaLN 注入动作。损失只有下一帧 MSE + SIGReg，不用 stop-gradient、EMA 或预训练编码器，15M 参数。一次规划 0.98 s，DINO-WM 47 s（约 48 倍）。PushT 96% 对 PLDM 78%，但 Two-Room 和 OGBench-Cube 不如基线。 | [[topics/notes/JEPA系列/1-05_LeWM\|笔记]] · [[topics/papers/JEPA系列/1-05_2603.19312_LeWM.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2603.19312) |
| 2026-05 | [**SD-JEPA**](https://arxiv.org/abs/2605.31111)<br>Subspace-Decomposed JEPAs: Disentangling Progression and Content in Latent World Models | LIX École Polytechnique、IRT SystemX、Safran Tech（Lucas Thil、Jesse Read、Rim Kaddah、Guillaume Doquet） | 在 LeWM 上把 192 维潜向量切成两块：k≤8 维的"进度子空间"用余弦三元组损失约束，其余"内容子空间"只加 SIGReg，不增加参数。四个 LeWM 基准上规划与 LeWM 持平（差异小于种子标准差）。8 维进度坐标的回合内进度探针 R² 达 0.91–0.95，进度角在抓取/释放附近变化最快，场景被替换后会跳到新的区间。 | [[topics/notes/JEPA系列/1-08_SD-JEPA\|笔记]] · [[topics/papers/JEPA系列/1-08_2605.31111_SD-JEPA.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2605.31111) |
| 2026-06 | [**AdaJEPA**](https://arxiv.org/abs/2606.32026)<br>AdaJEPA: An Adaptive Latent World Model | NYU、AMI Labs（Ying Wang、Oumayma Bounou、Yann LeCun、Mengye Ren） | 把测试时适配放进 MPC 闭环：每执行一个动作块，就用刚观察到的转移（缓冲区保留最近 5 条），以预训练时同样的潜预测损失，对编码器最后一级和预测器最后一块做一步梯度更新，再重新规划。每次重规划只多 0.01–0.03 s。PushObj 未见形状上成功率接近翻倍；只用 1k 条轨迹加适配达到 60.8%，高于 16 倍数据的冻结模型（43.5%）。 | [[topics/notes/JEPA系列/1-07_AdaJEPA\|笔记]] · [[topics/papers/JEPA系列/1-07_2606.32026_AdaJEPA.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2606.32026) |
| 2026-08 | [**LpWM**](https://arxiv.org/abs/2608.22764)<br>LpWM: A Case for Sparse Representations in World Models | NYU、AMI Labs、Duke、Mila、Brown（Yilun Kuang、Lucas Maes、Randall Balestriero、Yann LeCun） | 用 RDMReg 把编码器输出匹配到 Rectified Laplace 分布，得到非负稀疏码（约 30–65% 非零）。动机是一个理论结果：足够高维的 one-hot 编码能让 Lipschitz 动力学变成动作条件的线性转移。PushT 上中等容量预测器（MLP∘LTI 等）的规划成功率比稠密 LeWM 高 11%–57%（从图读出，需核对），高容量 DiT 下两者持平。支撑集编码离散动力学区域（Piecewise 环境里可解码 94–99%）。 | [[topics/notes/JEPA系列/1-09_LpWM\|笔记]] · [[topics/papers/JEPA系列/1-09_2608.22764_LpWM.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2608.22764) |
| 2026-10 | [**CommuteTimeWM**](https://arxiv.org/abs/2610.01373)<br>Learning Commute-Time-Preserving World Models for Planning | FMI Basel、巴塞尔大学（Michael Hauri、Peter Buttaroni、Fabian A. Mikulasch、Friedemann Zenke） | CTWM 用"预测潜位移 + 位移惩罚"加 log-det 正则替换 SIGReg。论文证明在确定性动力学、预测器处于不动点时，学到的是按特征值缩放的拉普拉斯表征，潜距离平方等于 commute time。参数减半（9M vs 18M），六个基准上持平或超过 LeWM（作者重跑：Cube 89.8 vs 64.8，Pointmaze 100 vs 68.5）。目标拉远到 100 步时，Two-Room 上 CTWM 98.3%，LeWM 只有 17.3%。 | [[topics/notes/JEPA系列/1-10_CommuteTimeWM\|笔记]] · [[topics/papers/JEPA系列/1-10_2610.01373_CommuteTimeWM.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2610.01373) |
| 2026-11 | [**Content–Geometry Tradeoff**](https://agenticlearning.ai/content-geometry-tradeoff/)<br>The Content–Geometry Tradeoff in World Models: When JEPA Learns Latent Maps | NYU Agentic Learning AI Lab、AMI Labs（Mengye Ren, Ying Wang, Christopher Hoang, Yilun Kuang, Yann LeCun） | 不加 SG，用切片方差正则 SVReg（沿随机方向给潜变量标准差设单边下限）学平滑的潜在地图；Slow SVReg 加慢通道和门控残差预测器保住慢变物体。五个视觉控制任务困难设置规划最好（第一人称 Medium 难目标 92.9% vs SG 21.2%），城市街区第一人称漫步的主成分直接成图（地图 R² 0.88）。技术报告，无 arXiv、无代码 | [[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff\|笔记]] · [[topics/papers/JEPA系列/1-01_ContentGeometryTradeoff.pdf\|PDF]] · [alphaXiv](https://www.alphaxiv.org/abs/2611.jepa-latent-maps-content-geometry) |

## 二、JEPA 奠基与防坍塌正则

JEPA 本身和它的防坍塌办法：stop-gradient / EMA、VICReg、SIGReg 及其变体。

| 日期 | 工作 | 机构 | 做法 | 链接 |
|---|---|---|---|---|
| 2022-11 | [**JEPA Slow Features**](https://arxiv.org/abs/2211.10831)<br>Joint Embedding Predictive Architectures Focus on Slow Features | NYU、Meta AI（Vlad Sobal, Nicolas Carion, Kyunghyun Cho, Yann LeCun） | 在"移动的点 + 背景干扰"玩具数据上，比较 VICReg / SimCLR 防坍塌的动作条件 JEPA 与像素重建、逆动力学。干扰每帧变化时 JEPA 不输重建；干扰在序列内固定时 JEPA 只编码背景（复制静态噪声能让损失为零），即偏好慢特征。三点实验中 VICReg 对受控点的 RMSE 0.277，接近随机网络的 0.235 | [[topics/notes/JEPA系列/2-04_JEPASlowFeatures\|笔记]] · [[topics/papers/JEPA系列/2-04_2211.10831_JEPASlowFeatures.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2211.10831) |
| 2023-01 | [**I-JEPA**](https://arxiv.org/abs/2301.08243)<br>Self-Supervised Learning from Images with a Joint-Embedding Predictive Architecture | Meta AI (FAIR)、McGill、Mila、NYU（Mahmoud Assran, Pascal Vincent, Yann LeCun, Nicolas Ballas） | JEPA 在图像上的第一个大规模实例：从一个大上下文块预测 4 个目标块在 EMA 目标编码器输出空间里的表示，不用手工增强、不重建像素，关键是 multi-block 掩码。ViT-H/14 在 16 张 A100 上不到 72 小时训完，ImageNet 线性探针 79.3%（ViT-H/16@448 达 81.1%），好于 MAE / data2vec | [[topics/notes/JEPA系列/2-01_I-JEPA\|笔记]] · [[topics/papers/JEPA系列/2-01_2301.08243_I-JEPA.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2301.08243) |
| 2024-02 | [**V-JEPA**](https://arxiv.org/abs/2404.08471)<br>Revisiting Feature Prediction for Learning Visual Representations from Video | FAIR at Meta、Inria、ENS、NYU（Adrien Bardes, Quentin Garrido, Mahmoud Assran, Nicolas Ballas） | 把 I-JEPA 搬到视频：约 200 万段视频上只用掩码特征预测训练（L1 + EMA / stop-gradient），3D multi-block 掩码遮掉约 90%。ViT-H/16@384 冻结评估 K400 81.9%、SSv2 72.2%，SSv2 比 DINOv2 / OpenCLIP 等图像模型高 21 个点以上；预训练样本数比其他方法少一个数量级 | [[topics/notes/JEPA系列/2-02_V-JEPA\|笔记]] · [[topics/papers/JEPA系列/2-02_2404.08471_V-JEPA.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2404.08471) |
| 2025-06 | [**V-JEPA 2**](https://arxiv.org/abs/2506.09985)<br>Self-Supervised Video Models Enable Understanding, Prediction and Planning | FAIR at Meta、Mila（Mahmoud Assran, Adrien Bardes, Yann LeCun, Nicolas Ballas） | V-JEPA 放大到 100 万小时以上视频、1B 参数 ViT-g，SSv2 77.3，EK100 动作预期 R@5 39.7。再冻结编码器，用不到 62 小时的无标签 Droid 视频训 300M 动作条件预测器 V-JEPA 2-AC，CEM 潜空间 MPC。两个新实验室的 Franka 上零样本 pick-and-place 成功率 65–80%（Octo 10–15%），每步规划 16 秒（Cosmos 4 分钟） | [[topics/notes/JEPA系列/2-03_V-JEPA2\|笔记]] · [[topics/papers/JEPA系列/2-03_2506.09985_V-JEPA2.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2506.09985) |
| 2025-11 | [**LeJEPA**](https://arxiv.org/abs/2511.08544)<br>Provable and Scalable Self-Supervised Learning Without the Heuristics | Brown、NYU、Meta FAIR（Randall Balestriero、Yann LeCun） | 先证明在总方差固定时，各向同性高斯是线性 / k-NN / 核探针下游风险的唯一最优嵌入分布；再提出 SIGReg：随机一维投影 + Epps–Pulley 特征函数检验，O(N)、梯度有界。LeJEPA = 多视图预测损失 + SIGReg，只有一个超参 λ，不用 stop-gradient、EMA teacher、predictor。ImageNet-1k 上 ViT-L 77.1%、ConvNeXt-V2-H 78.5%（摘要里的 ViT-H 79% 正文找不到，需核对） | [[topics/notes/JEPA系列/2-05_LeJEPA\|笔记]] · [[topics/papers/JEPA系列/2-05_2511.08544_LeJEPA.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2511.08544) |
| 2026-06 | [**VISReg**](https://arxiv.org/abs/2606.02572)<br>Variance-Invariance-Sketching Regularization for JEPA training | Altos Labs、Brown（Haiyu Wu、Randall Balestriero、Morgan Levine） | 保留 VICReg 的逐维方差项控尺度，把协方差项换成 Sliced Wasserstein 形状项（排序后对齐高斯分位数），O(NDK)。ImageNet-1K 上 ViT-B/16 75.7%，域内不如 DINO / iBOT，但 6 个 OOD 数据集平均最好；IN-22K 预训练的 ViT-L 在 OOD 平均上与用 10 倍数据的 DINOv2 持平（72.94 vs 72.93） | [[topics/notes/JEPA系列/2-06_VISReg\|笔记]] · [[topics/papers/JEPA系列/2-06_2606.02572_VISReg.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2606.02572) |
| 2026-09 | [**MotionJEPA**](https://arxiv.org/abs/2609.23881)<br>Preventing Temporal Feature Collapse by Capturing Visual Changes in Latent Space | Oxford、vivo、Brown、CSHL 等（Markus Karmann、Shile Li、Randall Balestriero、Philip Torr） | 针对 SIGReg 型世界模型偏爱慢特征、压掉快变物体（如 Pong 的球），提出 DISReg：单独编码帧差图，要求从相邻两帧嵌入预测它，两路都加 SIGReg，不需要动作标签也不重建像素。加木纹静态背景的四个 LeWM 任务上 25 步规划平均 81.8%（LeWM 20.4%），加 IDM 后 86.4% | [[topics/notes/JEPA系列/2-07_MotionJEPA\|笔记]] · [[topics/papers/JEPA系列/2-07_2609.23881_MotionJEPA.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2609.23881) |

## 三、JEPA 理论

JEPA 什么时候能学到真实的隐变量 / 世界模型。

| 日期 | 工作 | 机构 | 做法 | 链接 |
|---|---|---|---|---|
| 2025-11 | [**Koopman Invariants**](https://arxiv.org/abs/2511.09783)<br>Koopman Invariants as Drivers of Emergent Time-Series Clustering in JEPAs | KU Leuven（Pablo Ruiz-Morales、Mathias Verbeke 等） | 用 Koopman 算子解释 JEPA 在时间序列上按动力学区制自动聚类：区制指示函数是特征值 1 的不变特征函数，理想化 JEPA 损失在编码器张成它们、预测器为恒等时取零。18 个合成区制上 JEPA 的 K-Means 簇纯度 65.48%，自编码器 38.81%。AAAI 2026 | [[topics/notes/JEPA系列/3-01_KoopmanJEPA\|笔记]] · [[topics/papers/JEPA系列/3-01_2511.09783_KoopmanJEPA.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2511.09783) |
| 2026-05 | [**When Does LeJEPA Learn a World Model?**](https://arxiv.org/abs/2605.26379)<br>LeJEPA 的线性可辨识性 | CSHL、NYU、Brown（David Klindt、Yann LeCun、Randall Balestriero） | JEPA 的第一个可辨识性结果：高斯潜变量 + OU 转移的世界里，满足"对齐 + h(z)~N(0,I)"的最优表示当且仅当是真实潜变量的正交旋转；在独立、平稳、加性噪声这一类世界里高斯是唯一满足这一点的分布。附近似误差界和潜空间规划等价，推理链有 Lean 4 形式化（部分引理公理化）。合成数据 R²>0.999，Reacher 真实 RL 轨迹 R² ≤ 0.5。NeurIPS 2026 | [[topics/notes/JEPA系列/3-02_WhenLeJEPAWorldModel\|笔记]] · [[topics/papers/JEPA系列/3-02_2605.26379_WhenLeJEPAWorldModel.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2605.26379) |
| 2026-09 | [**Beyond Gaussian Worlds**](https://arxiv.org/abs/2609.21656)<br>Latent Geometry Matters for JEPAs | Université Paris-Saclay / ENS Paris-Saclay Centre Borelli、Advanced Track and Trace（Léo Nicollier, Enric Meinhardt-Llopis, Pablo Musé, Gabriele Facciolo） | 把 Klindt et al. 的 World–Learner 可辨识性理论从欧氏空间推广到嵌入黎曼流形（正样本对由流形上的 Langevin 扩散生成），给出"对齐 + 精确分布匹配 → 线性恢复"的充要条件（密度、嵌入几何、谱排序三条）。球面均匀世界也只差一个正交变换就能恢复。实验中目标几何匹配时恢复最好：球面世界 R² 0.998，换成高斯目标只有 0.669；128 维 Clifford 环面上匹配目标 0.967，高斯 0.795 | [[topics/notes/JEPA系列/3-03_BeyondGaussianWorlds\|笔记]] · [[topics/papers/JEPA系列/3-03_2609.21656_BeyondGaussianWorlds.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2609.21656) |
| 2026-09 | [**I Act Therefore I Am**](https://arxiv.org/abs/2609.31161)<br>When is JEPA's Action-Conditioning Enough to Learn Causal Mechanisms? | Adelaide University AIML、Responsible AI Research Centre（Yuhang Liu, Zhuo Huang, Javen Qinfeng Shi） | 用"隐因果状态 + 动作调制的时序 SCM 转移"建模 JEPA，提出"条件似然 + 熵"目标。证明只要动作足够多样地改变转移机制（2d+1 个动作使导数矩阵满秩），就能把隐状态恢复到置换 + 逐分量可逆变换。据此提出 A-JEPA：合成数据 MCC 约 0.90–0.96；RoboNet 零样本换到新机器人，20 步 rollout R² 仍 >0.90（Franka 0.910，LeWM 0.012） | [[topics/notes/JEPA系列/3-04_IActTherefore\|笔记]] · [[topics/papers/JEPA系列/3-04_2609.31161_IActTherefore.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2609.31161) |

## 四、导航、驾驶与机器人应用

| 日期 | 工作 | 机构 | 做法 | 链接 |
|---|---|---|---|---|
| 2026-07 | [**Auto-JEPA**](https://arxiv.org/abs/2607.29031)<br>A Latent World Model of Continuous Intent for End-to-End Autonomous Driving | 清华大学车辆与运载学院（Jiwei Yang, Zhengxian Chen, Chaosheng Huang, Jun Li） | 先训练轨迹自编码器得到"未来自车轨迹潜空间"，再用冻结的 V-JEPA 2 编码前视图像，以 JEPA 方式预测这个连续驾驶意图潜变量；推理时检索 11 万条轨迹库 Top-300，由 CLOVER 初始化的打分器排序。单前视相机 NAVSIM v1 91.3 PDMS、v2 89.1 EPDMS（新评估器；原评估器 85.6，需核对可比性） | [[topics/notes/JEPA系列/4-03_Auto-JEPA\|笔记]] · [[topics/papers/JEPA系列/4-03_2607.29031_Auto-JEPA.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2607.29031) |
| 2026-09 | [**InJePA**](https://arxiv.org/abs/2610.23896)<br>Intention-First Latent Planning with Coupled JEPA World Models for Visual Navigation | 电子科技大学、西安建筑科技大学（Siming Zhou, Pengcheng Zheng, Fan Mo, Chaoning Zhang） | 意图优先的潜空间规划，全部在冻结 V-JEPA 2.1 特征上：目标条件的 Proposal JEPA 提出下一步想到达的潜状态，动作模型把"意图 − 当前状态"翻译成离散动作，Forward JEPA 预测后果并喂回，K=8 个候选各展开 4 步后打分。Habitat MP3D 图像目标导航 Clean150 上 SR 65.33%，同编码器的 LWM-VJEPA 42.44%，但仍低于 LWM-CroCo 的 70.22% | [[topics/notes/JEPA系列/4-01_InJePA\|笔记]] · [[topics/papers/JEPA系列/4-01_2610.23896_InJePA.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2610.23896) |
| 2026-11 | [**JEPTERA**](https://arxiv.org/abs/2611.20593)<br>A Platform Agnostic JEPA-Assisted Model Predictive Planner for Urban UAV Navigation | Universitas Muhammadiyah Yogyakarta、KFUPM（Gibran Fathoni Belva, Mansur Arief, Ahmad Alfan Alfian Irfan） | 城市无人机 LiDAR 导航栈：JEPA 在体素观测上预测候选速度指令下的运动响应，交给 SLSQP-MPC，再加安全层和级联 PID，用适配器接入 PyBullet、MuJoCo、Gazebo、CARLA。180 次消融里完整架构 28/30 最高，但不含 JEPA 的 MPC–PID + 安全层也有 27/30，JEPA 的贡献很难看出 | [[topics/notes/JEPA系列/4-02_JEPTERA\|笔记]] · [[topics/papers/JEPA系列/4-02_2611.20593_JEPTERA.pdf\|PDF]] · [arXiv](https://arxiv.org/abs/2611.20593) |
| 2026-10 | [**EgoJEPA**](https://arxiv.org/abs/2610.20904)<br>Beyond Retargeting for Dexterous Manipulation from Egocentric Videos | MBZUAI、上海交大、Xense Robotics、自变量（Meng Cao, Xiaodan Liang 等） | JEPA 式视觉预测从人手视频学潜动作，再联合预测视觉动态与潜动作；五个真机任务、三种本体，域外平均成功率 74%（重定向基线 65%）。笔记在自变量文件夹 | [[xsquare/notes/23_EgoJEPA\|笔记]] · [arXiv](https://arxiv.org/abs/2610.20904) |
