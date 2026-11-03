---
id: "03"
org: 自变量
short: "WALL-WM"
title: "WALL-WM: Carving World Action Modeling at the Event Joints"
aliases: ["WALL-WM"]
date: 2026-06-01
category: 世界模型
source: 自变量主导
partners: []
authors: ["Shalfun Li", "Victor Yao", "Charles Yang", "Truth Qu", "Regis Cheng", "Ryan Yu", "Howard Lu", "Newton Von", "Vincent Chen", "Yohann Tang", "Maeve Zhang", "Ellie Ma", "Gody Li", "Starrick Liu", "Sage Yang", "Lorien Shu", "J. W. Gao", "Ethan Chen", "Colin Ye", "Yu Sun", "Elise Mon", "PS Zhang", "Neo Li", "Lily Li", "James Wang", "Ping Yang", "Chris Pan", "Lucy Liang", "Hang Su", "Roy Gan", "Hao Wang", "Qian Wang"]
arxiv: "2606.01955"
pdf: "[[xsquare/papers/03_2606.01955_WALL-WM.pdf]]"
code: "https://github.com/X-Square-Robot/wall-wm"
project: "https://x2robot.com/pages/wm"
huggingface: []
license: CC BY-NC-ND 4.0
status: 未读
rating:
read_date:
tags: ["paper", "world-model", "world-action-model"]
---

# WALL-WM: Carving World Action Modeling at the Event Joints

> [!info] 论文信息
> arXiv [2606.01955](https://arxiv.org/abs/2606.01955) · v1 2026-06-01 · 最新 v2（2026-09-06）
> PDF：[[xsquare/papers/03_2606.01955_WALL-WM.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/wall-wm) · [项目页](https://x2robot.com/pages/wm) · [官网 PDF](https://x2robot.com/api/files/file/WALL-WM.pdf)

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 以语义动作事件为学习的原子单元：“WALL-WM is a World Action Model that shifts video-action learning from chunk-centric optimization to event-grounded Vision-Language-Action pretraining, using semantically coherent action events as the atomic unit of learning.”（Abstract）
> - 定长窗口导致短时程相关拟合：“forcing all three into the same fixed-length prediction window turns VLA training into short-horizon correlation fitting”（Abstract）
> - 事件模式与统一模式：“The event mode consumes next-event descriptions and enables variable-length execution chunks, while the unified mode uses a VLM with Staircase Decoding to condition conventional fixed-length chunk inference”（Abstract）
> - 视频生成基准 200 ID + 50 OOD：“The held-out split contains 200 representative in-distribution tasks and 50 out-of-distribution tasks, covering diverse verbs, object categories, scene layouts, camera configurations, and robot embodiments.”（§7.1）
> - 具身相关维度优于 Wan 基线：“WALL-WM consistently outperforms the Wan-series baselines (Wan2.1 and Wan2.2) on embodied-relevant dimensions, including Motion Quality, Semantic Consistency, and Physical Plausibility.”（§7.1）
> - Diverse Manipulation 75.86 对 63.00：“Fig. 16 reports that event-mode WALL-WM achieves the strongest average Task Progress on the Diverse Manipulation suite, reaching 75.86 compared with 63.00 for WALL-WM -U-Scratch”（§7.2.1）
> - Reasoning Manipulation 71.60 对 59.50：“Fig. 17 indicates that event-mode WALL-WM obtains the strongest average result on reasoning-heavy tasks, reaching 71.60 compared with 59.50 for WALL-WM -U-Scratch”（§7.2.2）
> - Generalization 53.75 对 DreamZero 28.50：“Fig. 19 reports that event-mode WALL-WM obtains the highest average Task Progress on the Generalization suite, reaching 53.75 compared with 28.50 for DreamZero”（§7.2.4）
> - 消融：Reasoning 32.6 → 71.6：“On Reasoning Manipulation, the average Task Progress increases from 32.6 to 71.6.”（§7.2.5）
> - RoboTwin 零样本 15.2%：“WALL-WM achieves an average success rate of 15.2% , corresponding to 76 successful episodes out of 500 , and records at least one successful episode on 26 of the 50 tasks”（§9.5）

## 一句话总结

WALL-WM 把视频-动作学习的基本单元从定长动作块换成语义事件，在 Wan 视频模型上做事件级的世界动作模型预训练。

## 要解决什么问题

现有世界动作模型（WAM）通常从多模态或视频基础模型初始化，再以当前观测和指令预测定长动作块。语言描述的是语义目标与事件，视觉随场景连续演化，动作则在控制级时间尺度上运行；把三者塞进同一个定长窗口会造成粒度错配，使训练退化为短时程的相关性拟合，不仅浪费预训练的视觉语义先验，还可能被动作块特有的捷径覆盖，削弱组合性和长时程泛化。

## 方法

- 以动作落地的语义事件（action-grounded semantic event）为原子训练单元：把长轨迹切成伸手、抓取、放置等事件，事件字幕与对应的视频段、动作段配对，模型在事件对齐的区间上联合去噪未来视频和末端执行器轨迹（见 §1、§3.1）。
- 双塔结构：视频塔继承 Wan 系列文生视频模型，加入零初始化输出投影的跨视角注意力分支、Camera RoPE 和仅在训练时使用的跨视角几何掩码；随机初始化的动作 DiT 在每一层单向交叉注意力读取对应视频层的特征（见 §3.2、§3.3）。
- 训练流程：先在事件 latent 上训练视频塔，再冻结视频塔、只训练动作塔（视频前向固定在一个中等噪声锚点步）；随后训练 VLM 文本条件器和阶梯式解码器，可选再做定长窗口的 next-chunk 适配（见 §5、表 1）。
- 两种推理模式：事件模式（event mode）由 VLM、人或智能体给出下一事件描述，执行可变长度的视频-动作段；统一模式（unified mode）用基于 Qwen3.5-9B 的阶梯式解码（Staircase Decoding）一次并行生成潜在 CoT，驱动常规的定长块推理（见 §3.4、§5.5）。
- 数据与基础设施：互联网视频、第一视角视频、XRZero-G0 免本体 UMI 式采集和遥操作数据，配合 Task/Subtask/Action/Segment 层次化事件字幕与聚类均衡采样；训练用 DMuon，部署用 DMD 蒸馏加 FP8 量化，端到端推理达到 10Hz（见 §4、§6）。

## 实验与关键数字

- 具身视频生成（自建基准：200 个 ID 任务 + 50 个 OOD 任务，遵循 WorldArena 协议；视频塔由 Wan2.2-5B 初始化）：在 Motion Quality、Semantic Consistency、Physical Plausibility 等具身相关维度上稳定优于 Wan2.1、Wan2.2，视觉质量保持相当；CO3Dv2 上的 3D 感知探测也具竞争力（见 §7.1、表 2/3）。
- 真机评测（双臂桌面平台，指标为按评分细则给分的 Task Progress，基线 π0.5、DreamZero、LingBot-VA，另设去掉事件预训练、从头训练的 WALL-WM-U-Scratch）：事件模式在各套件上平均分最高——Diverse Manipulation 75.86（U-Scratch 63.00）、Reasoning Manipulation 71.60（U-Scratch 59.50）、Generalization 53.75（次优为 DreamZero 28.50）（见 §7.2、表 6）。
- Dexterous Manipulation 套件上事件模式同样最高，但与 U-Scratch 差距很小、绝对分数偏低，精细接触控制仍是难点（见 §7.2.3）。
- 事件与视角消融（表 4）：对比去掉跨视角注意力（VI-SA）并改用定长统一解码的预训练基线，Reasoning 套件平均从 32.6 升到 71.6（见 §7.2.5）。
- RoboTwin 零样本（附录 9.5）：50 个任务共 500 回合，平均成功率 15.2%（76 回合成功），26 个任务至少成功一次。

## 局限 / 存疑

## 与其他论文的关系

- [[08_XRZero-G0]]：非本体（UMI 式）数据由自家的 XRZero-G0 采集系统提供（§4.1）
- [[04_WALL-SS]]：同组后续世界模型，引用本文，并以 5 个 WALL-WM 检查点作为外部策略做闭环一致性评测；其真机任务是本文任务的子集，基线相同
- [[21_LatentQuant]]：对 WALL-WM 所用的 Wan2.1/Wan2.2 视频 VAE 做 NVFP4 量化；本文自身对蒸馏后的模型用的是 FP8 量化（§6.2）

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 9 条

> WALL-WM is a World Action Model that shifts video-action learning from chunk-centric optimization to event-grounded Vision-Language-Action pretraining, using semantically coherent action events as the atomic unit of learning.
> 批注：Claude：以语义动作事件为学习的原子单元
> — [[xsquare/papers/03_2606.01955_WALL-WM.pdf#page=1|p.1]]

> forcing all three into the same fixed-length prediction window turns VLA training into short-horizon correlation fitting
> 批注：Claude：定长窗口导致短时程相关拟合
> — [[xsquare/papers/03_2606.01955_WALL-WM.pdf#page=1|p.1]]

> The event mode consumes next-event descriptions and enables variable-length execution chunks, while the unified mode uses a VLM with Staircase Decoding to condition conventional fixed-length chunk inference
> 批注：Claude：事件模式与统一模式
> — [[xsquare/papers/03_2606.01955_WALL-WM.pdf#page=1|p.1]]

> The held-out split contains 200 representative in-distribution tasks and 50 out-of- distribution tasks, covering diverse verbs, object categories, scene layouts, camera configurations, and robot embodiments
> 批注：Claude：视频生成基准 200 ID + 50 OOD
> — [[xsquare/papers/03_2606.01955_WALL-WM.pdf#page=24|p.24]]

> Fig. 16 reports that event-mode WALL-WM achieves the strongest average Task Progress on the Diverse Manipulation suite, reaching 75.86 compared with 63.00 for WALL-WM-U-Scratch
> 批注：Claude：Diverse Manipulation 75.86 对 63.00
> — [[xsquare/papers/03_2606.01955_WALL-WM.pdf#page=27|p.27]]

> Fig. 17 indicates that event-mode WALL-WM obtains the strongest average result on reasoning-heavy tasks, reaching 71.60 compared with 59.50 for WALL-WM-U-Scratch
> 批注：Claude：Reasoning Manipulation 71.60 对 59.50
> — [[xsquare/papers/03_2606.01955_WALL-WM.pdf#page=28|p.28]]

> Fig. 19 reports that event-mode WALL-WM obtains the highest average Task Progress on the General- ization suite, reaching 53.75 compared with 28.50 for DreamZero
> 批注：Claude：Generalization 53.75 对 DreamZero 28.50
> — [[xsquare/papers/03_2606.01955_WALL-WM.pdf#page=29|p.29]]

> On Reasoning Manipulation, the average Task Progress increases from 32.6 to 71.6.
> 批注：Claude：消融：Reasoning 32.6 → 71.6
> — [[xsquare/papers/03_2606.01955_WALL-WM.pdf#page=30|p.30]]

> WALL-WM achieves an average success rate of 15.2%, corresponding to 76 successful episodes out of 500, and records at least one successful episode on 26 of the 50 tasks
> 批注：Claude：RoboTwin 零样本 15.2%
> — [[xsquare/papers/03_2606.01955_WALL-WM.pdf#page=35|p.35]]
<!-- highlights:end -->

## 摘要（中文）

WALL-WM 是一个世界动作模型（World Action Model），它把视频-动作学习从以动作块为中心的优化，转向以事件为落脚点的视觉-语言-动作（VLA）预训练，以语义连贯的动作事件作为学习的原子单元。现有 WAM 通常从多模态或视频基础模型初始化，然后在当前观测和指令条件下优化定长动作块。这种以块为中心的表述虽然方便，却造成了根本性的粒度错配：语言描述的是语义目标与事件，视觉随连续的场景动态演化，而动作在控制级时间尺度上运行；把三者强行塞进同一个定长预测窗口，会让 VLA 训练变成短时程的相关性拟合。这不仅没有充分利用预训练的视觉-语义先验，还可能用特定于动作块的捷径主动覆盖它，削弱组合性和长时程泛化。

WALL-WM 通过围绕语义事件来组织监督和数据，解决这一错配。具体而言，它把事件落地的 VLA 预训练与一个由事件级字幕和聚类均衡采样构建的数据生态结合起来，从而能在多样的行为、场景和任务结构上进行可扩展学习。基于同一个事件预训练骨干，WALL-WM 支持两种互补的推理模式：事件模式接收下一事件的描述，支持可变长度的执行块；统一模式则用带阶梯式解码（Staircase Decoding）的 VLM 为常规的定长块推理提供条件，同时保留一条梯度连续的 VLA 通路。结合基于 Muon 优化器的大规模预训练基础设施，WALL-WM 为通用 WAM 提供了一套实用的规模化方案。

实验表明，WALL-WM 在语言、场景和任务上都具有广泛的泛化能力，在大规模真实世界泛化评测中达到了最先进的性能。

## 摘要（原文）

> WALL-WM is a World Action Model that shifts video-action learning from chunk-centric optimization to event-grounded Vision-Language-Action pretraining, using semantically coherent action events as the atomic unit of learning. Existing WAMs commonly initialize from multimodal or video foundation models and then optimize fixed-length action chunks conditioned directly on the current observation and instruction. Although convenient, this chunk-centric formulation creates a fundamental granularity mismatch. Language describes semantic goals and events, vision evolves through continuous scene dynamics, and actions operate at control-level timescales; forcing all three into the same fixed-length prediction window turns VLA training into short-horizon correlation fitting. WALL-WM addresses this mismatch by organizing both supervision and data around semantic events. Specifically, it pairs event-grounded VLA pretraining with a data ecosystem built from event-level captions and cluster-balanced sampling, enabling scalable learning over diverse behaviors, scenes, and task structures. From the same event-pretrained backbone, WALL-WM supports two complementary inference modes. The event mode consumes next-event descriptions and enables variable-length execution chunks, while the unified mode uses a VLM with Staircase Decoding to condition conventional fixed-length chunk inference while preserving a gradient-continuous VLA path. Together with Muon-optimizer-based large-scale pretraining infrastructure, WALL-WM provides a practical scale-up recipe for general-purpose WAMs. Experiments show that WALL-WM generalizes broadly across language, scenes, and tasks, achieving state-of-the-art performance in large-scale real-world generalization evaluation.
