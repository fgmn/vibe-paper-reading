---
id: "02"
org: 自变量
short: "WALL-OSS-0.5"
title: "Wall-OSS-0.5 Technical Report"
aliases: ["WALL-OSS-0.5"]
date: 2026-05-29
category: 基础模型
source: 自变量主导
partners: []
authors: ["Ryan Yu", "Pushi Zhang", "Starrick Liu", "Brae Liu", "Miracle Kang", "Shalfun Li", "Lights Shi", "Ellie Ma", "Ping Yang", "Chris Pan", "Jerry Chen", "Dongxiu Liu", "Rain Sun", "Miles Guo", "Byron Zhang", "Hugo Zhou", "Zach Xu", "Vincent Chen", "Harrison Huang", "James Wang", "Dance Kuzi", "Andy Zhai", "Hang Su", "Roy Gan", "Lucy Liang", "Hao Wang", "Qian Wang"]
arxiv: "2605.30877"
pdf: "[[xsquare/papers/02_2605.30877_Wall-OSS-0.5_Technical-Report.pdf]]"
code: "https://github.com/X-Square-Robot/wall-x"
project: "https://x2robot.com/oss"
huggingface: ["https://huggingface.co/x-square-robot/wall-oss-0.5"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "vla", "foundation-model"]
---

# Wall-OSS-0.5 Technical Report

> [!info] 论文信息
> arXiv [2605.30877](https://arxiv.org/abs/2605.30877) · v1 2026-05-29 · 最新 v2（2026-06-01）
> PDF：[[xsquare/papers/02_2605.30877_Wall-OSS-0.5_Technical-Report.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/wall-x) · [项目页](https://x2robot.com/oss) · [wall-oss-0.5](https://huggingface.co/x-square-robot/wall-oss-0.5) · [官网 PDF](https://x2robot.com/api/files/file/WALL-OSS_0.5.pdf)

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 梯度桥接协同训练的三个目标：“We adopt a gradient-bridged co-training recipe in which three objectives play distinct and complementary roles”（Abstract）
> - 20 多种本体、每 epoch 超百万轨迹：“The model is pretrained across more than 20 embodiments, processing over one million robot trajectories per epoch alongside a grounded multimodal corpus.”（Abstract）
> - 约 9000 万多模态样本、1200 万桥接样本：“The multimodal corpus totals approximately 90 million samples, consisting of 78 million open-source samples and 12 million embodied bridge samples constructed directly from action trajectories.”（§3.2）
> - 零样本高分任务：“completes several tasks with high task progress in the absence of any task-specific fine-tuning: Block Sorting (100%), Fruit Sorting (96%), Ring Stacking (86%), and the held-out deformable task Rope Tightening (82%).”（§1）
> - 400k 检查点未见/已见任务平均：“both improve overall despite checkpoint-level fluctuations, with unseen tasks (53.6%) slightly exceeding seen tasks (50.0%) at 400k.”（§4.1.2）
> - 微调后 15 任务平均 60.5%：“We also find that the model continues to serve as a stronger prior after fine-tuning: on a 15-task real-robot suite, Wall-OSS-0.5 attains an average task progress of 60.5%, surpassing”（§1）
> - 对 π0.5 与 DreamZero 的领先幅度：“(43.0%) by 17.5% and DreamZero (33.4%) by 27.1%, with the highest score on 10 of 15 tasks.”（§4.2.1）
> - Embodied Grounding +21.8：“The most pronounced improvement is in robot manipulation-oriented target localization (Embodied Grounding, +21.8)”（§4.3）
> - 协同训练策略消融：“co-training reaches an average task progress of 57.0%, outperforming flow-only (36.6%), stop-gradient (31.9%), and stop-gradient to co-training (49.6%) on 5 ablation tasks”（§5.1）
> - RVQ tokenizer 对比 FAST：“our proposed RVQ Action Tokenizer improves average task progress from 29.3% to 48.1%”（§5.3）

## 一句话总结

开源 4B VLA，用梯度桥接协同训练让预训练检查点不经微调就能在真机上干活，微调后也是更强的初始化。

## 要解决什么问题

预训练 VLA 的效果几乎都在任务微调之后才报告，因此不清楚 VLA 预训练本身能否产生可执行的机器人行为，还是只提供了更好的初始化。训练上还有一个张力：连续 flow matching 适合部署，但只能弱地更新 VLM 骨干；离散动作 token 的交叉熵能强力塑造骨干，但解码出的动作太粗；冻结或截断梯度虽能保住 VLM 先验，却让精确的动作目标无法塑造骨干。

## 方法

- 梯度桥接协同训练（gradient-bridged co-training），单阶段联合三个目标：动作 token 交叉熵充当“梯度桥”，把 VLM 原生的强梯度送入骨干；多模态交叉熵作为锚点，保住指令跟随和视觉落地能力；连续 flow matching 训练部署时真正使用的动作生成器（见 §2.2.1）。
- 混合 Transformer（Mixture-of-Transformers, MoT）骨干：由 Qwen2.5-VL-3B-Instruct 初始化，原 3B VLM 作为 VL Expert，新增 Action Expert 处理带噪连续动作；两者共享注意力、梯度端到端流通，不采用 π0.5 的 stop-gradient 设计；离散与连续两条动作通路通过注意力掩码互不可见（见 §2.1.1）。
- 视觉对齐 RVQ 动作 tokenizer（Vision-Aligned RVQ Action Tokenizer）：取代规则式的 FAST，在 delta 动作空间做 Encoder–RVQ–Decoder，并加入视觉-动作对齐、下一帧预测和 DCT 域重建目标（见 §2.1.2）。
- 动作空间监督（Action-Space Supervision）：网络仍输出速度场，但损失定义在恢复出的动作上，等价于对高噪声步加权（见 §2.2.2）。
- 数据与工程：20 多种本体、每个 epoch 超过一百万条轨迹，外加约 9000 万条多模态样本（其中 1200 万条是由动作轨迹自动合成的“具身桥接数据”）；用 DMuon 让 Muon 优化器可规模化，推理端用 CUDA Graph 和融合 CUDA 算子加速（见 §2.2.4、§2.3、§3）。

## 实验与关键数字

- 零样本真机（不做任何任务微调，覆盖语义理解、刚体、可形变、精细和长程操作）：Block Sorting 100%、Fruit Sorting 96%、Ring Stacking 86%，未见过的可形变任务 Rope Tightening 82%；400k 检查点上未见任务平均 53.6%，略高于已见任务的 50.0%。Towel Folding、Charger Plugging 等可形变/精细任务仍基本做不到（见 §4.1、表 2/3）。
- 微调后真机对比（15 个任务）：平均任务进度 60.5%，π0.5 为 43.0%（高 17.5%），DreamZero 为 33.4%（高 27.1%），15 个任务中 10 个得分最高（见 §4.2.1、表 4）。
- 多模态理解：相对 Qwen2.5-VL-3B 骨干，Embodied Grounding 提升 +21.8，Where2Place、EO-Bench 也有提升，但 RealWorld VQA、ERQA 等通用 VQA 有所退化（见 §4.3）。
- 消融（5 个真机消融任务）：完整协同训练平均任务进度 57.0%，flow-only 36.6%、stop-gradient 31.9%、先 stop-gradient 再协同 49.6%（见 §5.1）；把 FAST 换成 RVQ tokenizer，任务进度从 29.3% 升到 48.1%（见 §5.3）；动作空间损失在 LIBERO 上收敛更快、峰值更高（见 §5.2）。
- 多任务微调中逐步扩大任务集，共享任务的表现不降反升（见 §4.2.2）。

## 局限 / 存疑

## 与其他论文的关系

- [[01_WALL-OSS]]：前作（被引用）；两者都以 Qwen2.5-VL-3B 为骨干，本文把 WALL-OSS 使用的 FAST 换成了学习式 RVQ 动作 tokenizer
- [[08_XRZero-G0]]：自采数据中加入了 XRZero-G0 免本体采集设备的数据（§3.1.1）
- [[06_DMuon]]：训练中用 DMuon 实现分布式 Muon 优化器（§2.2.4）

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 9 条

> The model is pretrained across more than 20 embodiments, processing over one million robot trajectories per epoch alongside a grounded multimodal corpus.
> 批注：Claude：20 多种本体、每 epoch 超百万轨迹
> — [[xsquare/papers/02_2605.30877_Wall-OSS-0.5_Technical-Report.pdf#page=1|p.1]]

> We adopt a gradient-bridged co-training recipe in which three objectives play distinct and complementary roles
> 批注：Claude：梯度桥接协同训练的三个目标
> — [[xsquare/papers/02_2605.30877_Wall-OSS-0.5_Technical-Report.pdf#page=1|p.1]]

> We also find that the model continues to serve as a stronger prior after fine-tuning: on a 15-task real-robot suite, Wall-OSS-0.5 attains an average task progress of 60.5%, surpassing
> 批注：Claude：微调后 15 任务平均 60.5%
> — [[xsquare/papers/02_2605.30877_Wall-OSS-0.5_Technical-Report.pdf#page=2|p.2]]

> The multimodal corpus totals approximately 90 million samples, consisting of 78 million open-source samples and 12 million embodied bridge samples constructed directly from action trajectories.
> 批注：Claude：约 9000 万多模态样本、1200 万桥接样本
> — [[xsquare/papers/02_2605.30877_Wall-OSS-0.5_Technical-Report.pdf#page=10|p.10]]

> both improve overall despite checkpoint-level fluctuations, with unseen tasks (53.6%) slightly exceeding seen tasks (50.0%) at 400k.
> 批注：Claude：400k 检查点未见/已见任务平均
> — [[xsquare/papers/02_2605.30877_Wall-OSS-0.5_Technical-Report.pdf#page=13|p.13]]

> (43.0%) by 17.5% and DreamZero (33.4%) by 27.1%, with the highest score on 10 of 15 tasks.
> 批注：Claude：对 π0.5 与 DreamZero 的领先幅度
> — [[xsquare/papers/02_2605.30877_Wall-OSS-0.5_Technical-Report.pdf#page=14|p.14]]

> The most pronounced improvement is in robot manipulation- oriented target localization (Embodied Grounding, +21.8
> 批注：Claude：Embodied Grounding +21.8
> — [[xsquare/papers/02_2605.30877_Wall-OSS-0.5_Technical-Report.pdf#page=17|p.17]]

> co-training reaches an average task progress of 57.0%, outperforming flow-only (36.6%), stop-gradient (31.9%), and stop-gradient to co-training (49.6%) on 5 ablation tasks
> 批注：Claude：协同训练策略消融
> — [[xsquare/papers/02_2605.30877_Wall-OSS-0.5_Technical-Report.pdf#page=18|p.18]]

> our proposed RVQ Action Tokenizer improves average task progress from 29.3% to 48.1%
> 批注：Claude：RVQ tokenizer 对比 FAST
> — [[xsquare/papers/02_2605.30877_Wall-OSS-0.5_Technical-Report.pdf#page=21|p.21]]
<!-- highlights:end -->

## 摘要（中文）

大规模视觉-语言-动作（VLA）预训练正越来越多地被用作机器人策略的基础，但预训练 VLA 的效果几乎总是在任务特定微调之后才报告。这留下了一个根本问题：VLA 预训练本身能否产生可执行的机器人行为，还是只为下游策略学习提供了更好的初始化？

我们提出 Wall-OSS-0.5，一个开源的 4B VLA，基于 3B VLM 骨干并加入动作生成组件，其设计目标是让预训练得到的机器人能力可以直接在实体硬件上测量。模型在 20 多种本体上预训练，每个 epoch 处理超过一百万条机器人轨迹，并配合一个落地（grounded）多模态语料。我们采用梯度桥接协同训练（gradient-bridged co-training）方案，其中三个目标各自承担不同且互补的角色：离散动作预测把强的、VLM 原生的梯度引入骨干；多模态预测保留落地的视觉-语言理解；连续 flow matching 则作为部署时的动作接口。

在任务特定微调之前，预训练检查点就已展现出不平凡的零样本真机行为：在一个 17 任务套件上，它以较高的任务进度完成了若干任务，其中包括一个未见过的可形变物体操作任务。微调之后，同一检查点作为更强的适配先验，在 15 个真机任务上达到 60.5% 的平均任务进度，比 π0.5 高 17.5%。多模态评测进一步确认，动作训练不会侵蚀落地的视觉-语言能力：模型保持了广泛的视觉-语言能力，同时增强了具身落地能力。

综上，这些结果把 VLA 预训练从一种初始化策略，重新定位为一种可直接检验、并且已经有用的机器人能力来源。

## 摘要（原文）

> Large-scale Vision-Language-Action (VLA) pretraining is increasingly adopted as the foundation for robot policies, yet the evidence for pretrained VLAs is almost invariably reported after task-specific fine-tuning. This leaves a foundational question unanswered: does VLA pretraining itself yield executable robot behavior, or does it merely furnish a better initialization for downstream policy learning? We present Wall-OSS-0.5, an open-source 4B VLA built upon a 3B VLM backbone augmented with action-generation components, designed so that pretrained robotic capability is directly measurable on physical hardware. The model is pretrained across more than 20 embodiments, processing over one million robot trajectories per epoch alongside a grounded multimodal corpus. We adopt a gradient-bridged co-training recipe in which three objectives play distinct and complementary roles: discrete action prediction routes strong VLM-native gradients into the backbone, multimodal prediction preserves grounded vision-language understanding, and continuous flow matching serves as the deployment-time action interface. Before task-specific fine-tuning, the pretrained checkpoint achieves non-trivial zero-shot real-robot behavior, completing several tasks, including a held-out deformable manipulation task, at high task progress on a 17-task suite. After fine-tuning, the same checkpoint serves as a stronger adaptation prior, reaching 60.5% average task progress on 15 real-robot tasks and outperforming \pi_0.5 by 17.5%. Multimodal evaluations further confirm that action training does not erode grounded vision-language competence: the model preserves broad vision-language ability while strengthening embodied grounding. Together, these results reposition VLA pretraining from an initialization strategy to a directly testable, already useful source of robot capability.
