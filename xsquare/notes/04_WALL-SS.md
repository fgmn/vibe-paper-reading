---
id: "04"
org: 自变量
short: "WALL-SS"
title: "WALL-SS: Scaling Long-horizon World Models via Next-Scale Autoregression"
aliases: ["WALL-SS"]
date: 2026-08-26
category: 世界模型
source: 自变量主导
partners: []
authors: ["Maeve Zhang", "Rain Sun", "Xiang Wang", "Cyril Zhang", "Shalfun Li", "Meng Cao", "Howard Lu", "Ethan Chen", "Harry Jhou", "KZ Zheng", "Lights Shi", "Regis Cheng", "Lorenzin", "Robert Wang", "Victor Yao", "Gody Li", "Elise Mon", "Yohann Tang", "Ryan Yu", "PS Zhang", "Vincent Chen", "Hang Su", "Roy Gan", "Hao Wang", "Qian Wang"]
arxiv: "2608.26239"
pdf: "[[xsquare/papers/04_2608.26239_WALL-SS.pdf]]"
code: "https://github.com/X-Square-Robot/wall-ss"
project: "https://x2robot.com/pages/ss"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "world-model", "simulation", "policy-evaluation"]
---

# WALL-SS: Scaling Long-horizon World Models via Next-Scale Autoregression

> [!info] 论文信息
> arXiv [2608.26239](https://arxiv.org/abs/2608.26239) · v1 2026-08-26
> PDF：[[xsquare/papers/04_2608.26239_WALL-SS.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/wall-ss) · [项目页](https://x2robot.com/pages/ss) · [官网 PDF](https://x2robot-open.oss-cn-shenzhen.aliyuncs.com/ARWM%20OPEN/WALL-SS.pdf)

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 观测与动作交错的因果序列：“WALL-SS represents embodied trajectories as causal sequences of temporally interleaved observations and actions, making action-dependent state transitions explicit while naturally supporting variable-length generation”（Abstract）
> - 尺度压缩的长时程记忆：“Scale-compressed long-horizon memory preserves recent interactions at fine resolution while progressively compressing distant observations and their corresponding action histories under a bounded memory budget”（Abstract）
> - 把逐尺度生成当作随机策略做在线对齐：“on-policy alignment of autoregressive visual dynamics treats next-scale generation as a stochastic policy and optimizes fresh rollouts using action-following and long-term consistency rewards while preserving the pretrained visual distribution”（Abstract）
> - 视频生成基准 200 ID + 100 OOD：“We construct an Embodied Video Generation benchmark from our generalized embodied-data mixture, with 200 in-distribution and 100 out-of-distribution tasks.”（§6.1）
> - 交互质量、指令跟随、轨迹精度最好：“WALL-SS achieves the strongest interaction quality, instruction following, and trajectory accuracy while maintaining competitive visual and semantic quality.”（Table 1 caption）
> - WALL-SS 在表 1 的各项得分（Trajectory Acc. 0.539、Action Following 0.290）：“WALL-SS 0.697 0.453 0.435 0.213 0.715 0.873 0.903 0.912 0.546 0.885 0.471 0.539 0.831 0.290”（Table 1）
> - 长时程 rollout 到 60 秒：“We therefore evaluate long-horizon action-conditioned generation under a temporally segmented replay protocol, with rollouts extending to 60 seconds.”（§6.3）
> - 闭环评测：5 个 WALL-WM 检查点 × 6 任务 × 20 初始配置：“Five WALL-WM checkpoints spanning low to high validation competence are evaluated on six held-out tasks with 20 matched initial configurations”（§6.5）
> - 527 个回合与真机结果一致：“WALL-SS matches the real outcome in 527 episodes, with the remaining optimism concentrated at contact/insertion stages.”（Figure 13 caption）
> - 闭环一致性指标（成对准确率 0.89、Spearman 0.88、平衡准确率 0.88）：“0.84 0.93 0.89 0.025 0.88 0.88 0.90 0.86 0.14 Table 3: Closed-loop outcome alignment.”（Table 3）

## 一句话总结

WALL-SS 用逐尺度自回归生成动作条件下的视频未来，配合压缩记忆与奖励对齐，做动作可控的分钟级机器人世界模拟。

## 要解决什么问题

现有视频世界模型大多围绕片段级（clip-level）未来预测来组织，动作与后果的关联、可变时长、持续交互中的状态维持和奖励优化，往往要靠各自的专用接口。作者希望用一个统一的因果生成式表述把感知、动作、记忆和优化连起来；但自回归生成会把自己的预测当作后续上下文，误差累积不仅带来视觉漂移，还会混淆物体身份、交互结果和对应的动作历史。

## 方法

- 逐尺度自回归（next-scale autoregression）：把具身轨迹表示为时间上交错的观测与动作的因果序列，每个未来观测由粗到细逐尺度生成；视觉生成器由 InfinityStar 初始化（见 §3.1、§3.2）。
- 动作条件的逐尺度预测（action-conditioned next-scale prediction）：确定性渲染器把规定的控制轨迹投影到各相机时间线，经因果动作编码器得到尺度对齐的动作条件，再用尺度对齐的因果掩码只暴露当前区间的动作；目标是连次优、失败的行为也能按规定动作忠实模拟（见 §3.2）。
- 时间-尺度记忆（time–scale memory）：近期片段保留细尺度因果状态、远期片段保留粗尺度状态，初始观测作为身份锚点，整体在固定的 KV 预算内滚动；再用逐尺度梦境强迫（scale-wise dream forcing）在被破坏或自生成的历史上训练，缓解曝光偏差（见 §3.3）。
- 世界动作策略：联合训练一个 flow-matching 动作专家，从已提交的视觉状态预测下一个动作块（见 §3.4）。
- 视觉动态的在线策略对齐（on-policy alignment）：把逐尺度视觉 token 生成看作随机策略，在固定动作条件下用“动作跟随”和“长时一致性”两个冻结打分器做组相对策略优化，并用 KL 约束和真实轨迹自回归回放保持预训练视觉分布；奖励不含任务进度或成功（见 §3.5、§5.2）。
- 数据：AgiBotWorld-Beta 全量、ManipArena 真机演示、自采 X2-Robot 与 UMI 数据，以及单独保留的策略干预/失败恢复轨迹（见 §4）。

## 实验与关键数字

- 具身视频生成（自建基准：200 个 ID + 100 个 OOD 任务，遵循 WorldArena 协议）：相对 InfinityStar 骨干及 Wan2.1、Wan2.2、CogVideoX、Cosmos3-Nano 等基线，Interaction Quality、Instruction Following、Trajectory Acc. 最好，视觉与语义质量保持竞争力；WALL-SS 的 Trajectory Acc. 为 0.539、Action Following 为 0.290（见 §6.1–6.2、表 1）。
- 长时程流式 rollout：最长 60 秒、不回灌真实帧；相比只保留最近片段的变体，轨迹误差累积明显更小，另与去掉梦境强迫、保留全历史 KV 的变体对比（见 §6.3）。
- 在线策略对齐消融：对齐后动作跟随、轨迹精度和跨片段边界误差都有改善，外观指标基本不变；基于对齐后生成器联合训练的动作专家，真机任务进度也更高（见 §6.4）。
- 闭环策略一致性：5 个 WALL-WM 检查点作为外部策略，在 6 个保留任务、每个 20 个匹配初始配置下分别在 WALL-SS 和真机上执行；527 个回合的结果与真机一致，检查点成对排序准确率 0.89、平均 Spearman 0.88、回合级平衡准确率 0.88；残余偏差主要是在接触/插入阶段过于乐观（见 §6.5、表 3）。
- 真机控制：联合训练的动作专家在双臂桌面平台上平均任务进度排名第一，超过 π0.5、DreamZero 和 LingBot-VA，在 Press Button in Order 等依赖历史的任务上优势明显（见 §6.6、图 14）。

## 局限 / 存疑

## 与其他论文的关系

- [[03_WALL-WM]]：引用的同组事件式世界动作模型；闭环一致性实验以 5 个 WALL-WM 检查点作为被评测的外部策略，真机任务与对比基线也与之重合
- [[15_ManipArena]]：训练数据中加入了 ManipArena 的真机操作演示（§4.1）
- [[02_WALL-OSS-0.5]]：动作专家参照的 flow-matching 动作专家之一（与 WALL-OSS 一同被引用，§3.4）

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 9 条

> WALL-SS represents embodied trajectories as causal sequences of temporally interleaved observations and actions, mak- ing action-dependent state transitions explicit while naturally supporting variable-length generation
> 批注：Claude：观测与动作交错的因果序列
> — [[xsquare/papers/04_2608.26239_WALL-SS.pdf#page=1|p.1]]

> Scale-compressed long-horizon memory preserves recent interactions at fine resolution while progressively compressing distant observations and their corre- sponding action histories under a bounded memory budget
> 批注：Claude：尺度压缩的长时程记忆
> — [[xsquare/papers/04_2608.26239_WALL-SS.pdf#page=1|p.1]]

> on-policy alignment of autoregressive visual dynamics treats next-scale generation as a stochastic policy and optimizes fresh rollouts using action-following and long-term consistency rewards while preserving the pretrained visual distribution
> 批注：Claude：把逐尺度生成当作随机策略做在线对齐
> — [[xsquare/papers/04_2608.26239_WALL-SS.pdf#page=1|p.1]]

> We construct an Embodied Video Generation benchmark from our generalized embodied-data mixture, with 200 in-distribution and 100 out-of-distribution tasks.
> 批注：Claude：视频生成基准 200 ID + 100 OOD
> — [[xsquare/papers/04_2608.26239_WALL-SS.pdf#page=14|p.14]]

> WALL-SS 0.697 0.453 0.435 0.213 0.715 0.873 0.903 0.912 0.546 0.885 0.471 0.539 0.831 0.290
> 批注：Claude：WALL-SS 在表 1 的各项得分（Trajectory Acc. 0.539、Action Following 0.290）
> — [[xsquare/papers/04_2608.26239_WALL-SS.pdf#page=15|p.15]]

> WALL-SS achieves the strongest interaction quality, instruction following, and trajectory accuracy while maintaining competitive visual and semantic quality.
> 批注：Claude：交互质量、指令跟随、轨迹精度最好
> — [[xsquare/papers/04_2608.26239_WALL-SS.pdf#page=15|p.15]]

> We therefore evaluate long-horizon action-conditioned generation under a temporally segmented replay protocol, with rollouts extending to 60 seconds.
> 批注：Claude：长时程 rollout 到 60 秒
> — [[xsquare/papers/04_2608.26239_WALL-SS.pdf#page=17|p.17]]

> Five WALL-WM checkpoints spanning low to high validation competence are evaluated on six held-out tasks with 20 matched initial configurations
> 批注：Claude：闭环评测：5 个 WALL-WM 检查点 × 6 任务 × 20 初始配置
> — [[xsquare/papers/04_2608.26239_WALL-SS.pdf#page=20|p.20]]

> WALL-SS matches the real outcome in 527 episodes, with the remaining optimism concentrated at contact/insertion stages.
> 批注：Claude：527 个回合与真机结果一致
> — [[xsquare/papers/04_2608.26239_WALL-SS.pdf#page=21|p.21]]
<!-- highlights:end -->

## 摘要（中文）

生成式世界模型为机器人提供了世界在交互下如何演化的预测模型，在仿真、规划、策略评估和机器人学习方面的潜力日益增长。然而，要超越片段级的未来预测，就需要一种统一的生成式表述：它要能显式地把动作与其后果联系起来，支持灵活时长的预测，在持续交互中维持世界状态，并为奖励驱动的优化提供概率接口。

我们提出 WALL-SS，一个通过逐尺度自回归扩展（Scale-wise autoregressive Scaling）生成视觉未来的世界模型，实现动作可控的长时程机器人仿真。WALL-SS 把具身轨迹表示为时间上交错的观测与动作的因果序列，使依赖于动作的状态转移变得显式，同时自然地支持可变长度生成、借助可复用因果状态的流式扩展，以及通过序列概率进行直接优化。

为了让这一表述在长时程上有效，我们以由粗到细的方式生成每个未来观测，并在同一层级结构内设计了三个互补组件。动作条件的逐尺度预测在整个生成过程中引入尺度对齐的动作表示，加强动作与未来之间的耦合，能够忠实模拟各种规定行为，包括次优和失败的结果。尺度压缩的长时程记忆以高分辨率保留近期交互，同时在有限的记忆预算下逐步压缩较远的观测及其对应的动作历史，并借助逐尺度梦境强迫（scale-wise dream forcing）提升对自生成上下文的鲁棒性。最后，自回归视觉动态的在线策略对齐把逐尺度生成视为随机策略，用动作跟随和长期一致性奖励优化新采样的 rollout，同时保持预训练的视觉分布。

实验表明，WALL-SS 提升了动作跟随和轨迹精度，能在有界记忆下支持连贯的分钟级流式 rollout，并且在线策略对齐能持续减少动作漂移和长时程不一致。此外，把同一个外部机器人策略分别在 WALL-SS 和物理世界中闭环部署，得到了校准良好的任务结果和一致的策略检查点排名，表明学到的世界模型保留了与下游机器人策略评估相关的、依赖于动作的动态。

## 摘要（原文）

> Generative world models provide robots with predictive models of how the world evolves under interaction, with growing potential for simulation, planning, policy evaluation, and robot learning. Beyond clip-level future prediction, a unified generative formulation should relate actions to consequences, support flexible horizons and continuous interaction, and enable reward-driven optimization. We introduce WALL-SS, a world model that generates visual futures through Scale-wise autoregressive Scaling, enabling action-controllable and long-horizon robotic simulation. WALL-SS represents embodied trajectories as causal sequences of temporally interleaved observations and actions, making action-dependent state transitions explicit while naturally supporting variable-length generation, streaming extension through reusable causal states, and direct optimization through sequence probabilities. To make this formulation effective over long horizons, we generate each future observation in a coarse-to-fine manner and develop three complementary components within the same hierarchy. Action-conditioned next-scale prediction injects scale-aligned action representations to improve action-future coupling and model both successful and failed behaviors. Scale-compressed long-horizon memory retains recent interactions at fine resolution while compressing distant observations and actions, with scale-wise dream forcing enhancing robustness to self-generated context. Finally, on-policy alignment optimizes autoregressive visual dynamics with action-following and long-term consistency rewards while preserving the pretrained visual distribution. Experiments show that WALL-SS improves action following and trajectory accuracy, supports coherent minute-long streaming rollout under bounded memory, and consistently benefits from on-policy alignment in reducing action drift and long-horizon inconsistency.
