---
id: "1-04"
org: 专题·JEPA系列
short: "Temporal Straightening"
title: "Temporal Straightening for Latent Planning"
aliases: ["Temporal Straightening", "时间拉直", "Curvature Regularizer"]
date: 2026-03-12
category: "JEPA 世界模型与规划"
venue: "ICML 2026"
source: "arXiv"
affiliation: "NYU；Brown University；University of Toronto"
partners: []
authors: ["Ying Wang", "Oumayma Bounou", "Gaoyue Zhou", "Randall Balestriero", "Tim G. J. Rudner", "Yann LeCun", "Mengye Ren"]
arxiv: "2603.12231"
pdf: "[[topics/papers/JEPA系列/1-04_2603.12231_TemporalStraightening.pdf]]"
code: ""
project: "https://agenticlearning.ai/temporal-straightening/"
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "latent-planning", "latent-geometry", "curvature-regularization", "gradient-based-planning", "stop-gradient"]
---

# Temporal Straightening for Latent Planning

> [!info] 论文信息
> arXiv [2603.12231](https://arxiv.org/abs/2603.12231) · v3 2026-08-11（v1 2026-03-12）· ICML 2026（PMLR 306）· 29 页（正文 9 页 + 附录）
> [项目页 / 代码入口](https://agenticlearning.ai/temporal-straightening/)（摘要写 "Our code is available at" 这个地址）
> PDF：[[topics/papers/JEPA系列/1-04_2603.12231_TemporalStraightening.pdf|本地 PDF]]
> 作者：Ying Wang、Oumayma Bounou、Gaoyue Zhou（NYU）、Randall Balestriero（Brown）、Tim G. J. Rudner（Toronto）、Yann LeCun\*、Mengye Ren\*（NYU）。\* 共同指导
> 专题：[[topics/JEPA系列#一、JEPA 世界模型与规划|JEPA系列 · 一]]

> [!note] 下面各节是 Claude 根据 PDF 全文（含附录 B 的 GD/CEM 对比、维度与余弦变体消融，附录 C 的证明）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 动机："While pretrained visual encoders produce strong semantic visual features, they are not tailored to planning and contain information irrelevant—or even detrimental—to planning."（Abstract，p.1）
> - 弯曲轨迹让欧氏距离失真："when latent trajectories are highly curved, straight-line distances in embedding space misrepresent the geodesic distance along feasible transitions."（§1，p.1）
> - 灵感来源："Inspired by the perceptual straightening hypothesis in human vision (Hénaff et al., 2019)…"（§1，p.2）
> - 隐式拉直："We find that the JEPA prediction objective alone induces implicit straightening to some extent, and introducing an explicit curvature regularizer further strengthens and stabilizes this effect."（§1，p.2）
> - 汇总增益："open-loop planning success improves by 20–60% and MPC by 20–30% with a simple gradient-based planner."（§1，p.2）
> - 防坍塌用 SG："We use stop-grad for major experiments due to its simplicity and efficiency"（§3.3，p.4）
> - 理论结论："Theorem 4.4 shows that ε-straight transitions control the condition number of the planning Hessian"（§4，p.5）
> - 距离热图："Straightening results in a distance heatmap that closely aligns with the geodesic distance."（§5.2，p.7）
> - CEM vs GD："Overall, CEM achieves higher success rates but requires substantially longer time than GD. With straightening, GD achieves a better success–latency trade-off."（§5.3，p.8）
> - 局限："Our current formulation focuses on continuous goal-conditioned latent planning with a symmetric Euclidean goal cost, which may be suboptimal under asymmetric or irreversible dynamics."（§5.3 末，p.9）

## 一句话总结

借鉴人类视觉的"感知拉直假说"，在 JEPA 世界模型训练时加一个**曲率正则** L_curv = 1 − cos(z_{t+1}−z_t, z_{t+2}−z_{t+1})，让相邻潜速度方向一致、潜轨迹变直。编码器可以是冻结 DINOv2 + 可训练小投影头，也可以是从零训练的 ResNet；防坍塌用 stop-gradient。理论上（线性动力学）A 越接近 I，规划 Hessian 的条件数越小，梯度下降收敛越快；实验上拉直后潜欧氏距离接近真实测地距离，**用简单的梯度下降（GD）规划**就能在 Wall / UMaze 上 MPC 达到 100%，比 DINO-WM 基线开环提升 20–60%、MPC 提升 20–30%，并且大幅缩小 GD 与 CEM 的差距（CEM 约慢 10 倍）。

## 要解决什么问题

- 潜空间规划的目标函数通常高度非凸，梯度规划器容易卡住，所以 DINO-WM、PLDM、TD-MPC2 等都用 CEM / MPPI 这种采样搜索，算力和延迟很重。
- 常用的欧氏距离目标代价在潜空间没有被约束时会误导：**潜轨迹很弯时，两点直线距离不等于沿可行转移的测地距离**。
- 预训练视觉编码器（DINOv2）语义强，但不是为环境动力学设计的，保留了大量与规划无关的低层细节；DINO-WM 的 DINOv2 特征空间里轨迹高度弯曲（图 1、2），MSE 不随"靠近目标"单调下降。
- 作者认为好的规划表征应当：①足以预测动力学、但去掉任务无关信息；②经过适当正则，让嵌入距离反映测地距离、梯度优化可靠。

## 方法

### 世界模型（§3.1，§5.1）

| 组件 | 做法 |
|---|---|
| 视觉编码器（两种） | ①冻结 DINOv2 + 可训练轻量 CNN 投影头（可降空间分辨率和/或通道，如 196×384 → 196×8，或全局 1×384）；②从零训练的 ResNet |
| 动作 / 本体感受编码 | 小编码器，嵌入拼接到每个视觉空间特征上 |
| 预测器 | ViT，帧级时间因果掩码（沿用 DINO-WM），历史 3 帧，frameskip 5 |

### 训练目标（§3.2–3.3）

- 预测：L_pred = ‖ẑ_{t+1} − sg(z_{t+1})‖²，目标分支 **stop-gradient** 防坍塌（作者说曲率正则与防坍塌方式正交，可以和 VICReg/SIGReg 等组合，主实验选 SG 因为简单、不加超参）。
- 拉直：v_t = z_{t+1} − z_t，L_curv = 1 − cos(v_t, v_{t+1})。
- 总损失 L_total = L_pred + λ·L_curv，主实验 λ 多为 0.1（全局特征有的用 0.01 / 0.001）。
- 空间特征上怎么算余弦，比较了四种（附录 B.6）：逐 patch 再平均、先平均 patch、展平、**可学习聚合头**（MLP，输出 128 维）。主实验用聚合头：预测损失作用在空间特征上，曲率损失作用在聚合后的全局特征上——这样全局轨迹被拉直，但不强迫每个 patch 都直（物体运动、遮挡下 patch 级速度本来就不对齐）。

### 理论（§4，附录 C）

- 线性潜动力学 z_{t+1} = A z_t + B a_t，终态 MSE 代价 L(a) = ‖z_K − z_g‖²。
- 定义 **ε-straight**：‖A − I‖₂ ≤ ε（ε→0 时状态只按控制输入直线移动）。
- **定理 4.4**：规划 Hessian H = 2J_Φᵀ J_Φ 的有效条件数等于有限时域可控性 Gramian W_K 的条件数，且 κ_eff(H) ≤ κ(B)²·((1+ε)/(1−ε))^{2(K−1)}；ε ≤ 1/2 时 ≤ κ(B)²·e^{6εK}。即越"直"，条件数随时域增长越慢，GD 线性收敛越快。
- **命题 C.9**：在"潜速度模长恒定 + 动作平滑"的假设下，高余弦相似度意味着 (A−I) 在**访问过的速度方向**上小；要推到谱范数需要访问方向张满空间的覆盖条件。
- 非线性预测器没有理论保证，作者用动作空间损失地形图（图 4，PushT）展示拉直后更接近凸。

### 规划

- 主实验用 **GD** 优化动作（Adam 式更新：动作零初始化，学习率 0.1，100 步），子规划时域 25 环境步（= 5 次 frameskip 展开）。
- 开环：只用终态 MSE。MPC：每步重规划、执行前若干动作，迷宫用对中间状态加权的代价（能在用满时域前到达目标）；PushT 在时域内只用终态代价（接触的"模式切换"让中间代价有误导）。

## 实验与关键数字

环境（沿用 DINO-WM 数据）：Wall（1,920 条 × 50 步）、PointMaze UMaze（2,000 条）、PointMaze Medium（4,000 条）、PushT（18,500 条，长 100–300）。起点和目标取自测试轨迹，保证 25 步内可达；PushT 给目标图像 + 本体感受，其余只给目标图像。每个设置 50 个测试回合，3 个评估数据种子的均值 ± 标准差。

### 1. 主结果：GD 规划成功率（表 1，%，节选空间特征行）

| 编码器 | 维度 | L_curv | Wall 开环 | Wall MPC | UMaze 开环 | UMaze MPC | Medium 开环 | Medium MPC | PushT 开环 | PushT MPC |
|---|---|---|---|---|---|---|---|---|---|---|
| DINOv2 patch（=DINO-WM） | 14×14×384 | ✗ | 52.67 | 76.67 | 35.33 | 80.67 | 40.83 | 76.67 | 56.00 | 66.00 |
| DINOv2 patch + 投影 | 14×14×8 | ✗ | 80.00 | 90.67 | 44.00 | 81.33 | 72.00 | 96.67 | 70.00 | 78.67 |
| DINOv2 patch + 投影 | 14×14×8 | ✓ | **90.67** | **100.00** | **94.00** | **100.00** | **82.67** | 98.67 | **77.33** | 85.33 |
| ResNet（从零） | 14×14×8 | ✗ | 1.33 | 6.67 | 14.67 | 66.00 | 18.67 | 57.33 | 71.33 | 70.67 |
| ResNet（从零） | 14×14×8 | ✓ | 84.67 | **100.00** | 64.67 | 98.67 | 80.67 | **99.33** | 70.67 | **91.33** |

全局特征行（1×384；DINOv2 CLS 基线：Wall 28.67/66.67、UMaze 25.33/82.67、Medium 20.00/67.50、PushT 19.33/28.00）：

| 编码器 | L_curv | Wall | UMaze | Medium | PushT |
|---|---|---|---|---|---|
| DINOv2 patch + 全局投影 | ✗ | 28.67 / 76.00 | 34.67 / 79.33 | 18.00 / 46.00 | 2.00 / 11.33 |
| DINOv2 patch + 全局投影 | ✓ | 32.00 / 77.33 | 38.67 / 96.00 | 22.67 / 78.00 | 2.00 / 8.67 |
| ResNet 全局 | ✗ | 58.67 / 68.00 | 58.00 / 88.67 | 73.33 / 89.33 | 40.00 / 70.00 |
| ResNet 全局 | ✓ | 86.67 / 97.33 | 63.33 / 97.33 | 79.33 / 93.33 | 58.67 / 83.33 |

（格式：开环 / MPC。全局特征这几行在 PDF 抽取的文本里列顺序被打乱，上面是 Claude 按"✗/✓ 成对交替"还原的，需对照原表核对。）

要点：
- **只训练投影头、不加拉直**也会涨（隐式拉直：JEPA 目标偏好时间上好预测的表征，会减少方向突变）；加显式拉直后很多设置再涨 10% 以上。
- 从零训练的 ResNet 空间特征不加拉直时在 Wall/UMaze/Medium 上异常差（Wall 开环 1.33），作者归因于曲率极高、特征退化；加拉直后恢复到 84–100%。
- 保留空间结构比保留通道重要：通道从 384 压到 8 不掉点；压成单个全局向量预测变难。全局特征里，从零训的 ResNet 明显好于在冻结 DINO patch 上训全局投影头。
- 全局投影头 + 拉直在 PushT 上几乎没用（2.00 → 2.00 / 11.33 → 8.67）。

### 2. 嵌入空间（§5.2，图 2、5、6）

- 曲率（相邻速度余弦）：预训练 DINOv2 最弯；训练后即使 λ=0 也变直，显式拉直更直；从零 ResNet 一般比冻结骨干 + 投影更直。
- 距离热图（PointMaze）：DINOv2 CLS 的潜距离不反映迷宫结构；拉直后的 ResNet（14×14×8）潜距离贴近 A* 测地距离——训练数据是**非专家的次优轨迹**，模型没有记住低效路径，而是近似出最少步数。空间特征给细粒度局部距离，聚合特征给更平滑的长程信号。
- 解码器（单独训练、梯度截断）显示压缩到很低维度后仍能高保真重建（简单视觉环境）。

### 3. GD vs CEM（附录 B.3，表 5，开环 %；CEM 200 样本 × 10 轮）

| 编码器 | L_curv | Wall GD / CEM | UMaze GD / CEM | Medium GD / CEM | PushT GD / CEM |
|---|---|---|---|---|---|
| DINOv2 patch 384 | ✗ | 52.67 / 87.33 | 35.33 / 88.00 | 40.83 / 88.00 | 56.00 / 71.33 |
| + 投影 8 | ✗ | 80.00 / 92.00 | 44.00 / 75.33 | 72.00 / 92.67 | 70.00 / 71.33 |
| + 投影 8 | ✓ | 90.67 / 100.00 | 94.00 / 94.00 | 82.67 / 86.67 | 77.33 / 80.00 |
| ResNet 8 | ✗ | 1.33 / 1.33 | 14.67 / 20.67 | 18.67 / 24.00 | 71.33 / 56.00 |
| ResNet 8 | ✓ | 84.67 / 90.00 | 64.67 / 83.33 | 80.67 / 89.33 | 70.67 / 72.67 |

- CEM 至少要 200 样本 × 10 轮才强，墙钟时间约为 GD 的 10 倍（L40S，PushT 50 条开环）。
- 拉直后 GD 和 CEM 的差距大幅缩小（UMaze 两者都是 94.00）。
- 注意：拉直对 CEM 并不总是有利——Medium 上 "投影 + 拉直" 的 CEM 86.67 低于 "投影不拉直" 的 92.67；正文说"straightening consistently improves both GD and CEM"，与这一格不一致，需核对。

### 4. 长时域（表 2，目标 50 步外，空间特征，开环 / MPC，%）

| 模型 | PushT | PointMaze Medium |
|---|---|---|
| DINO-WM | 3.33 / 27.33 | 35.00 / 65.33 |
| + 投影 ✗ | 6.67 / 26.67 | 60.00 / 72.00 |
| + 投影 ✓ | 13.33 / 24.00 | 68.00 / 88.00 |
| ResNet ✗ | 13.33 / 29.33 | 14.67 / 48.00 |
| ResNet ✓ | 10.67 / 33.33 | 76.00 / 98.67 |
| + 投影 ✓，组合代价 | 20.00 / 33.33 | 66.67 / 92.00 |
| ResNet ✓，组合代价 | 13.33 / 36.00 | 68.67 / 98.67 |

- 组合代价 L_plan = L_spatial + 0.1·L_agg（空间特征的目标距离 + 聚合头空间的目标距离），MPC 下普遍更好。
- 这张表在抽取文本里也是按列堆叠的，上面是 Claude 的还原。按此还原，"投影 ✓" 的 PushT MPC（24.00）低于 DINO-WM（27.33），与正文"consistently outperforms the baseline across all settings"不符；ResNet ✓ 的 Medium MPC 加组合代价前后都是 98.67，也谈不上"improves"。需对照原表核对。
- PushT 长时域整体很低（≤36%），失败例子里解码的想象轨迹变模糊、与仿真错位——误差累积仍是瓶颈。

### 5. 消融

- **通道数**（附录 B.4，图 11）：d_v=2 太小；8 或 32 最好；128 反而一致变差（高维潜变量不利于梯度规划）。
- **与其他时间正则比较**（附录 B.5，图 12，PushT 开环）：平滑项 ‖z_{t+1}−z_t‖² 和时间对比（InfoNCE，窗口 k=2/5）都没带来提升，权重大时还伤性能；作者解释平滑过强会坍塌，时间对比在次优轨迹上会把测地距离近、但时间上远的状态推开。
- **余弦变体**（附录 B.6，图 14）：所有变体都好于不拉直，聚合头最好。
- **Teleported-PointMaze**（§5.3）：碰右墙瞬移到左侧，像素上远但时间上近；拉直模型能利用瞬移规划到目标（图 27，只给了代表性成功例子，没有统计数字）。

## 局限 / 存疑

> 论文 §5.3 末自述：只考虑连续的目标条件规划和对称欧氏代价，不对称或不可逆动力学可能需要拟度量（quasimetric）类代价；长时域的提升说明正则和规划目标未必要在预测潜空间里。其余条目是 Claude 的推断，请核对。

- **环境都是 2D 简单仿真**（Wall、两个 PointMaze、PushT），视觉也很简单；没有 3D、第一人称或真机。
- **防坍塌只靠 stop-gradient**：作者也承认理论上仍可能坍塌；[[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 正好拿 "SG + straightening" 当基线，发现它在部分任务上锯齿度仍高、第一人称迷宫上不如无 SG 的 SVReg。
- **理论只覆盖线性动力学**，而且从余弦相似度到 ‖A−I‖ 小需要"速度模长恒定 + 动作平滑 + 方向覆盖"等假设；非线性情形只给了一张损失地形图。
- **几处正文表述与表格不一致**（见上：CEM 在 Medium 上拉直后反而降；长时域 PushT 的 "投影 ✓" MPC 低于基线），且表 1 全局行、表 2 的抽取文本排列混乱，需核对原 PDF。
- **λ 和编码器学习率需要调**：全局特征的 λ 在 0.1 / 0.01 / 0.001 之间按 MPC 验证种子选；不拉直时编码器要用更小学习率（1e-6）否则严重退化（表 3 脚注）。
- 汇总增益"开环 20–60%、MPC 20–30%"没有说明是绝对百分点还是相对、和哪一行比，需核对。

## 与其他论文的关系

- **直接改进 DINO-WM**：同样的环境、数据、frameskip 和 ViT 预测器；区别是编码器可训练（投影头或 ResNet）、加曲率正则、改用 GD 规划。见 [[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]]。
- **潜几何这条线**：和 [[topics/notes/JEPA系列/1-01_ContentGeometryTradeoff|Content–Geometry Tradeoff]] 同组（Ying Wang、Mengye Ren、LeCun），那篇把本文的曲率罚项作为 "SG + straightening" 基线，并论证不加 SG 的 SVReg 不需要曲率项也能得到平滑路径。
- **与 PLDM 的平滑项**：[[topics/notes/JEPA系列/1-03_PLDM|PLDM]] 的 L_time-sim 惩罚相邻潜变量距离（"慢"），本文惩罚速度方向变化（"直"），附录 B.5 显示单纯平滑项在 PushT 上无效。
- **与 LeWM / 其他 JEPA 世界模型**：[[topics/notes/JEPA系列/1-05_LeWM|LeWM]] 从像素端到端训练、用 SIGReg 防坍塌、CEM 规划；本文作者说曲率正则可以和 SIGReg 等组合，但没有做这个实验。[[topics/notes/JEPA系列/1-06_WhatDrivesSuccess|What Drives Success]]（脚注引用为 Terver et al., 2025）的结论是 DINOv2 在 2D 导航规划上好于 DINOv3 和 V-JEPA 2，本文据此选 DINOv2。
- **线性化 / Koopman**：附录 D 讨论了与 E2C、局部线性控制、Koopman 方法的区别——本文约束的是轨迹曲率（几何性质），不是要求动力学线性。相关可看 [[topics/notes/JEPA系列/3-01_KoopmanJEPA|Koopman-JEPA]]。
- **感知拉直**：Hénaff et al. 2019 的人类视觉假说；作者称此前没人研究拉直对世界模型和规划的影响。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Learning good representations is essential for latent planning with world models. While pretrained visual encoders produce strong semantic visual features, they are not tailored to planning and contain information irrelevant—or even detrimental—to planning. Inspired by the perceptual straightening hypothesis in human visual processing, we introduce temporal straightening to improve representation learning for latent planning. Using a curvature regularizer that encourages locally straightened latent trajectories, we jointly learn an encoder and a predictor of a Joint-Embedding Predictive Architecture (JEPA) world model. We show that reducing curvature this way makes the Euclidean distance in latent space a better proxy for the geodesic distance and improves the conditioning of the planning objective. We demonstrate empirically that temporal straightening makes gradient-based planning more stable and yields significantly higher success rates across a suite of goal-reaching tasks. Our code is available at https://agenticlearning.ai/temporal-straightening/.
