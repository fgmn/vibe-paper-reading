---
id: "01"
org: 自变量
short: "WALL-OSS"
title: "Igniting VLMs toward the Embodied Space"
aliases: ["WALL-OSS"]
date: 2025-09-15
category: 基础模型
source: 自变量主导
partners: []
authors: ["Andy Zhai", "Brae Liu", "Bruno Fang", "Chalse Cai", "Ellie Ma", "Ethan Yin", "Hao Wang", "Hugo Zhou", "James Wang", "Lights Shi", "Lucy Liang", "Make Wang", "Qian Wang", "Roy Gan", "Ryan Yu", "Shalfun Li", "Starrick Liu", "Sylas Chen", "Vincent Chen", "Zach Xu"]
arxiv: "2509.11766"
pdf: "[[xsquare/papers/01_2509.11766_WALL-OSS_Igniting-VLMs-toward-the-Embodied-Space.pdf]]"
code: "https://github.com/X-Square-Robot/wall-x"
project: "https://x2robot.com/en/research/68bc2cde8497d7f238dde690"
huggingface: ["https://huggingface.co/x-square-robot/wall-oss-flow", "https://huggingface.co/x-square-robot/wall-oss-fast"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "vla", "foundation-model"]
---

# Igniting VLMs toward the Embodied Space

> [!info] 论文信息
> arXiv [2509.11766](https://arxiv.org/abs/2509.11766) · v1 2025-09-15
> PDF：[[xsquare/papers/01_2509.11766_WALL-OSS_Igniting-VLMs-toward-the-Embodied-Space.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/wall-x) · [项目页](https://x2robot.com/en/research/68bc2cde8497d7f238dde690) · [wall-oss-flow](https://huggingface.co/x-square-robot/wall-oss-flow) · [wall-oss-fast](https://huggingface.co/x-square-robot/wall-oss-fast)

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 静态路由的紧耦合 MoE：“a static router directs action-centric features to an Action FFN and vision–language features to a Vision–Language FFN, instead of a learned softmax/top-k router.”（§3）
> - Uni-CoT 可走完整推理链或直接映射到动作：“supporting flexible forward arbitrary mapping where the model can adaptively leverage full intermediate reasoning steps or directly map instructions to actions based on task complexity and contextual demands”（§3）
> - 语料超过 10,000 小时：“The corpus exceeds 10,000 hours and comprises three complementary components”（§4）
> - Embodied VQA 三项结果：“Model Object Grounding Scene Captioning Action Planning Qwen2.5-VL-3B 46.1% 57.7% 59.8% WALL-OSS 91.6% 87.6% 69.0%”（Table 2）
> - 零样本指令跟随 85% / 61%：“The model achieves an average task progress of 85% on seen-object instructions and maintains a performance of 61% on novel-object instructions.”（§5.2.2）
> - Collect-Waste 分布内 100% 对 DP 80%：“achieve a 100% success rate on the in-distribution (ID) task, while the non-pre-trained DP model reaches only 80%”（§5.2.3）
> - 新环境下 DP 从 80% 跌到 0%：“In the out-of-distribution (OOD) generalization test—performing Collect-Waste in a novel environment—DP’s success rate falls from 80% to 0%, completely failing to complete the task.”（§5.2.3）
> - 仅 1% 数据带子任务标注：“Despite having only 1% of the training data labeled with subtasks, the model consistently learns to generate high-quality subtask instructions.”（§5.2.4）
> - Block-Spell 指令跟随准确率：“Letter 87% 26% 9% Number 95% 80% 35% Table 3: Instruction-following accuracy in block-spell task.”（Table 3）
> - 精细操作上 π0 仍更强：“competitive action generation with stronger OOD generalization than DP, though Pi-0 remains superior for precise manipulation”（§6.1）

## 一句话总结

WALL-OSS 用紧耦合 MoE 和“先离散后连续”两阶段训练，把 VLM 扩展为能理解具身场景、输出连续动作的基础模型。

## 要解决什么问题

现有 VLM 的空间与具身理解有限，迁移到动作域时存在模态与数据规模、预训练分布、训练目标三方面的差距。直接给 VLM 接动作头微调会造成严重的权重漂移、侵蚀原有的视觉语言先验；而“知识隔离”这类松耦合设计又削弱了语义与控制之间的绑定，导致指令跟随能力不足。

## 方法

- 紧耦合混合专家架构（Mixture-of-Experts, MoE）：以 Qwen2.5-VL-3B 为骨干，用静态路由（而非学习式 top-k 路由）把动作相关特征送入 Action FFN、视觉语言特征送入 Vision–Language FFN（见 §3、图 3）。
- 两阶段训练（见 §3、图 4）：
  1. 激发阶段（Inspiration）：复用原 FFN，用具身 VQA 增强空间推理，同时以 FAST tokenization 得到的离散动作 token 注入粗粒度动作先验；
  2. 融合阶段（Integration）：改用 flow matching 建模连续动作，先冻结 VLM、只训练 Action FFN 下的 flow head，再解冻 VLM 联合优化。
- 统一跨层级思维链（Unified Cross-Level CoT, Uni-CoT）：在单个可微模型内贯通“指令 → 推理 → 子任务规划 → 连续动作”，训练时用 path-drop 目标允许跳过中间步骤，推理时可自适应决定是否调用 CoT/子任务分解（见 §3）。
- 数据：超过 10,000 小时的多源语料，包括自采机器人动作数据、按统一规范处理的开源动作数据（DROID、BC-Z、BRIDGE 等）以及通用与具身多模态 VQA（见 §4、表 1）。

## 实验与关键数字

- 评测设置：自建 Embodied VQA 基准（场景描述、物体定位、动作规划）加一组真机操作任务，覆盖指令跟随与推理、长程规划、动作精度三个维度；基线为 π0 和 Diffusion-Policy，由不知道模型版本的第三方盲测（见 §5.1）。
- Embodied VQA（表 2）：相比底座 Qwen2.5-VL-3B，物体定位 46.1% → 91.6%，场景描述 57.7% → 87.6%，动作规划 59.8% → 69.0%。
- 零样本指令跟随：见过的物体平均任务进度 85%，新物体 61%（见 §5.2.2）。
- 动作精度：Collect-Waste 分布内任务上预训练模型（WALL-OSS、π0）成功率 100%，从头训练的 DP 只有 80%；换到新环境后 DP 从 80% 跌到 0%，而预训练模型仍保持较高成功率。作者也承认精细操作上 π0 仍更强（见 §5.2.3、§6.1）。
- 长程与推理：只有 1% 的训练数据带子任务标注，模型仍能学会生成子任务，在 Set-Table、Tidy-Bedroom、Block-Spell 等任务上明显优于基线；Block-Spell 指令跟随准确率字母块 87%（多模态协同训练）对 9%（π0，仅动作），数字块 95% 对 35%（见 §5.2.4–5.2.6、表 3）。

## 局限 / 存疑

## 与其他论文的关系

- [[02_WALL-OSS-0.5]]：后续技术报告，引用了本文；同样以 Qwen2.5-VL-3B 为骨干，但用学习式的视觉对齐 RVQ 动作 tokenizer 取代了本文使用的 FAST

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 9 条

> a static router directs action-centric features to an Action FFN and vision–language features to a Vision–Language FFN, instead of a learned softmax/top-k router.
> 批注：Claude：静态路由的紧耦合 MoE
> — [[xsquare/papers/01_2509.11766_WALL-OSS_Igniting-VLMs-toward-the-Embodied-Space.pdf#page=5|p.5]]

> supporting flexible forward arbitrary mapping where the model can adaptively leverage full intermediate reasoning steps or directly map instructions to actions based on task complexity and contextual demands
> 批注：Claude：Uni-CoT 可走完整推理链或直接映射到动作
> — [[xsquare/papers/01_2509.11766_WALL-OSS_Igniting-VLMs-toward-the-Embodied-Space.pdf#page=6|p.6]]

> The corpus exceeds 10,000 hours and comprises three complementary components
> 批注：Claude：语料超过 10,000 小时
> — [[xsquare/papers/01_2509.11766_WALL-OSS_Igniting-VLMs-toward-the-Embodied-Space.pdf#page=6|p.6]]

> Model Object Grounding Scene Captioning Action Planning Qwen2.5-VL-3B 46.1% 57.7% 59.8% WALL-OSS 91.6% 87.6% 69.0%
> 批注：Claude：Embodied VQA 三项结果
> — [[xsquare/papers/01_2509.11766_WALL-OSS_Igniting-VLMs-toward-the-Embodied-Space.pdf#page=11|p.11]]

> achieve a 100% success rate on the in-distribution (ID) task, while the non-pre- trained DP model reaches only 80
> 批注：Claude：Collect-Waste 分布内 100% 对 DP 80%
> — [[xsquare/papers/01_2509.11766_WALL-OSS_Igniting-VLMs-toward-the-Embodied-Space.pdf#page=12|p.12]]

> In the out-of-distribution (OOD) generalization test—performing Collect-Waste in a novel environment—DP’s success rate falls from 80% to 0%, completely failing to complete the task.
> 批注：Claude：新环境下 DP 从 80% 跌到 0%
> — [[xsquare/papers/01_2509.11766_WALL-OSS_Igniting-VLMs-toward-the-Embodied-Space.pdf#page=12|p.12]]

> Despite having only 1% of the training data labeled with subtasks, the model consistently learns to generate high-quality subtask instructions.
> 批注：Claude：仅 1% 数据带子任务标注
> — [[xsquare/papers/01_2509.11766_WALL-OSS_Igniting-VLMs-toward-the-Embodied-Space.pdf#page=12|p.12]]

> Letter 87% 26% 9% Number 95% 80% 35% Table 3 Instruction-following accuracy in block-spell task
> 批注：Claude：Block-Spell 指令跟随准确率
> — [[xsquare/papers/01_2509.11766_WALL-OSS_Igniting-VLMs-toward-the-Embodied-Space.pdf#page=14|p.14]]

> competitive action generation with stronger OOD generalization than DP, though Pi-0 remains superior for precise manipulation
> 批注：Claude：精细操作上 π0 仍更强
> — [[xsquare/papers/01_2509.11766_WALL-OSS_Igniting-VLMs-toward-the-Embodied-Space.pdf#page=14|p.14]]
<!-- highlights:end -->

## 摘要（中文）

尽管基础模型在语言和视觉上进展显著，现有视觉-语言模型（VLM）的空间理解和具身理解能力仍然有限。把 VLM 迁移到具身领域时，会暴露出模态、预训练分布和训练目标之间的根本性错配，使动作的理解与生成成为通往 AGI 路上的核心瓶颈。

我们提出 WALL-OSS，一个端到端的具身基础模型，借助大规模多模态预训练实现：(1) 具身感知的视觉-语言理解；(2) 强的语言-动作关联；(3) 稳健的操作能力。我们的方法采用紧耦合架构和多策略训练课程，实现统一跨层级思维链（Unified Cross-Level CoT）——在单一可微框架内无缝统一指令推理、子目标分解和细粒度动作合成。

结果表明，WALL-OSS 在复杂的长程操作任务上取得高成功率，展现出强的指令跟随能力以及复杂的理解与推理能力，并超越了强基线，从而为从 VLM 走向具身基础模型提供了一条可靠且可扩展的路径。

## 摘要（原文）

> While foundation models show remarkable progress in language and vision, existing vision-language models (VLMs) still have limited spatial and embodiment understanding. Transferring VLMs to embodied domains reveals fundamental mismatches between modalities, pretraining distributions, and training objectives, leaving action comprehension and generation as a central bottleneck on the path to AGI. We introduce WALL-OSS, an end-to-end embodied foundation model that leverages large-scale multimodal pretraining to achieve (1) embodiment-aware vision-language understanding, (2) strong language-action association, and (3) robust manipulation capability. Our approach employs a tightly coupled architecture and multi-strategies training curriculum that enables Unified Cross-Level CoT-seamlessly unifying instruction reasoning, subgoal decomposition, and fine-grained action synthesis within a single differentiable framework. Our results show that WALL-OSS attains high success on complex long-horizon manipulations, demonstrates strong instruction-following capabilities, complex understanding and reasoning, and outperforms strong baselines, thereby providing a reliable and scalable path from VLMs to embodied foundation models.
