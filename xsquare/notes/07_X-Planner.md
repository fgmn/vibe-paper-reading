---
id: "07"
org: 自变量
short: "X-Planner"
title: "X-Planner: Event-Structured Task Planning for Embodied Intelligence"
aliases: ["X-Planner"]
date: 2026-09-21
category: 任务规划
source: 自变量主导
partners: []
authors: ["Howard Lu", "Shalfun Li", "Porter Pan", "Cris", "Lumen", "Cyril", "Eric Hu", "Lily Li", "Maeve Zhang", "Rain Sun", "Robert Wang", "KZ Zheng", "Viggo Chen", "Tim Ding", "Regsis Cheng", "YJ Xiao", "Kian", "Hai Lin", "Alan Song", "Elise Ma", "Gody Li", "Victor Yao", "Yohann Tang", "Ingrid Yu", "Jason He", "James Wang", "Ryan Yu", "Ping Yang", "Chris Pan", "Vincent Chen", "Roy Gan", "Hao Wang", "Qian Wang"]
arxiv: "2609.25187"
pdf: "[[xsquare/papers/07_2609.25187_X-Planner.pdf]]"
code: "https://github.com/X-Square-Robot/Xplanner"
project: "https://x-square-robot.github.io/Xplanner/"
huggingface: ["https://huggingface.co/x-square-robot/X-Planner-9B-0916", "https://huggingface.co/datasets/x-square-robot/xplanner-benchmark"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "task-planning", "vlm"]
---

# X-Planner: Event-Structured Task Planning for Embodied Intelligence

> [!info] 论文信息
> arXiv [2609.25187](https://arxiv.org/abs/2609.25187) · v1 2026-09-21 · 最新 v2（2026-09-29）
> PDF：[[xsquare/papers/07_2609.25187_X-Planner.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/Xplanner) · [项目页](https://x-square-robot.github.io/Xplanner/) · [X-Planner-9B-0916](https://huggingface.co/x-square-robot/X-Planner-9B-0916) · [xplanner-benchmark](https://huggingface.co/datasets/x-square-robot/xplanner-benchmark)

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 以语义事件作为规划单元：“We instead adopt the semantic event as the planning unit: a temporally coherent span of executable behavior, such as reaching, grasping, lifting, or placing, whose boundary follows a change in behavior.”（§1）
> - 接管时刻与人工失败示范监督错误识别：“Takeover-time annotations and human-designed failures supervise ongoing error recognition.”（Abstract）
> - 共享 VLM 的两种计划形式与阶梯解码：“a shared VLM backbone exposes two event-structured plan forms: a discrete interface that emits interpretable event states and a latent interface that relays continuous CoT states across staggered Transformer depths through Staircase Decoding”（Abstract）
> - 阶梯解码：低层共享、高层按推理步专门化：“The lower layers encode shared visual–language context, whereas the upper layers specialize across reasoning steps.”（§4.3）
> - 冻结的潜在到文本重建作语义锚点：“A frozen latent-to-text reconstruction objective provides a semantic anchor for the latent representation.”（Abstract）
> - 离线规划各模型分数：“Qwen 0.8878 1.367 Doubao 0.8846 1.366 kimi3 0.9108 1.434 X-Planner (ours) 0.9011 1.411”（Table 2）
> - 离线规划排名第二：“Table 2 shows that X-Planner ranks second among the four evaluated models on both metrics.”（§6.1）
> - Reasoning Manipulation 逐任务与平均结果：“U-Scratch 84% 82% 18% 43% 70% 59.50% X-Planner 84% 78% 64% 36% 96% 71.60%”（Table 3）
> - Generalization 套件平均 Task Progress：“Figure 5 B reports average Task Progress of 53.75 53.75 for X-Planner , 28.50 28.50 for DreamZero”（§6.2.2）
> - 未证明端到端延迟优势：“Neither evaluation establishes an end-to-end latency advantage. Controlled ablations and timing measurements are required to answer those questions.”（§6.3）

## 一句话总结

X-Planner 以语义事件为规划单元，用同一 VLM 输出可读的事件状态或并行生成的潜在 CoT，作为下游世界-动作模型的条件。

## 要解决什么问题

许多 VLA 把从高层指令到动作之间的任务结构留为隐式。作者指出现有 CoT 规划器有三个缺口：数据上依赖粗粒度的任务级标注，标不出子目标边界和执行错误；粒度上固定在单一的外加层级；解码上逐 token 自回归，串行路径长，且容易误差传播。

## 方法

- 事件结构化规划数据（§3）：融合 Ego、UMI 和遥操作数据，按 L3 任务 / L2 子任务 / L1 动作 / L0 片段的层级标注，深度随来源而异（遥操作四级都有，Ego/UMI 只到 L1）；用接管时刻标注和人工设计的失败示范来监督执行中的错误识别（Failure-Aware Ongoing Supervision）。
- 两种计划形式（§4.1）：离散形式输出结构化事件状态（初始计划、当前/下一事件、归一化进度、是否继续、错误识别、episode 结束标记）；潜在形式输出一串连续推理状态（parallel continuous CoT）。两者共享 VLM 主干，经文本条件接口投影进下游世界-动作模型的交叉注意力（§4.2）。
- 阶梯解码（Staircase Decoding，§4.3）：在中继深度把 Transformer 切开，低层计算共享的视觉-语言上下文，高层由轻量 MoT 分支对各潜在位置并行更新，缩短串行路径。
- 冻结的潜在到文本重建（Frozen Latent-to-Text Reconstruction，§4.4）：把潜在状态投影成一个冻结小语言模型的软前缀，让它重建文本 CoT，为潜在表示提供语义锚点。
- 训练（§5）：对完整 JSON 目标做 SFT，另加与下游原文本编码器特征的对齐损失和阶梯蒸馏；下游世界-动作模型全程冻结。部署分事件模式和统一模式两种（§4.5）。

## 实验与关键数字

- 离线两步规划（§6.1 表 2）：X-Planner 的 BERTScore-F1 为 0.9011，Doubao Judge Overall 为 1.411，在四个模型中排第二，高于 Qwen（0.8878 / 1.367）和 Doubao（0.8846 / 1.366），低于 kimi3（0.9108 / 1.434）。
- 真实机器人（§6.2，双臂桌面，事件模式，指标为按任务细则给部分分的 Task Progress）：Reasoning Manipulation 套件的平均 Task Progress，X-Planner 为 71.60%，最强基线 U-Scratch 为 59.50%；按任务看，按顺序按按钮（64% vs 18%）和挑水果入篮（96% vs 70%）优势明显，形状分类（78% vs 82%）和配对（36% vs 43%）低于 U-Scratch（表 3，逐任务值是图表读数）。
- Generalization 套件（§6.2.2）：X-Planner 平均 Task Progress 为 53.75，最强可用基线 DreamZero 为 28.50。
- 作者强调的限制（§6.3）：机器人实验评估的是完整的事件模式系统，没有分别估计错误监督数据、潜在形式、阶梯调度等组件的贡献，也没有证明端到端延迟优势；图 5 没有误差棒。

## 局限 / 存疑

## 与其他论文的关系

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 9 条

> Takeover-time annotations and human-designed failures supervise ongoing error recognition.
> 批注：Claude：接管时刻与人工失败示范监督错误识别
> — [[xsquare/papers/07_2609.25187_X-Planner.pdf#page=1|p.1]]

> a shared VLM backbone exposes two event-structured plan forms: a discrete interface that emits interpretable event states and a latent interface that relays continuous CoT states across staggered Transformer depths through Staircase Decoding
> 批注：Claude：共享 VLM 的两种计划形式与阶梯解码
> — [[xsquare/papers/07_2609.25187_X-Planner.pdf#page=1|p.1]]

> A frozen latent-to-text reconstruction objective provides a semantic anchor for the latent representation.
> 批注：Claude：冻结的潜在到文本重建作语义锚点
> — [[xsquare/papers/07_2609.25187_X-Planner.pdf#page=1|p.1]]

> We instead adopt the semantic event as the planning unit: a temporally coherent span of executable behavior, such as reaching, grasping, lifting, or placing, whose boundary follows a change in behavior.
> 批注：Claude：以语义事件作为规划单元
> — [[xsquare/papers/07_2609.25187_X-Planner.pdf#page=1|p.1]]

> The lower layers encode shared visual–language context, whereas the upper layers specialize across reasoning steps.
> 批注：Claude：阶梯解码：低层共享、高层按推理步专门化
> — [[xsquare/papers/07_2609.25187_X-Planner.pdf#page=6|p.6]]

> Qwen 0.8878 1.367 Doubao 0.8846 1.366 kimi3 0.9108 1.434 X-P!"##$% (ours) 0.9011 1.411
> 批注：Claude：离线规划各模型分数
> — [[xsquare/papers/07_2609.25187_X-Planner.pdf#page=9|p.9]]

> Table 2 shows that X-P!"##$% ranks second among the four evaluated models on both metrics.
> 批注：Claude：离线规划排名第二
> — [[xsquare/papers/07_2609.25187_X-Planner.pdf#page=9|p.9]]

> U-S&%"’&( 84% 82% 18% 43% 70% 59.50% X-P!"##$% 84% 78% 64% 36% 96% 71.60%
> 批注：Claude：Reasoning Manipulation 逐任务与平均结果
> — [[xsquare/papers/07_2609.25187_X-Planner.pdf#page=10|p.10]]

> Neither evaluation establishes an end-to-end latency advantage. Controlled ablations and timing measurements are required to answer those questions.
> 批注：Claude：未证明端到端延迟优势
> — [[xsquare/papers/07_2609.25187_X-Planner.pdf#page=10|p.10]]
<!-- highlights:end -->

## 摘要（中文）

任务规划在长时程操作中连接高层指令与可执行行为，但现代视觉-语言-动作（VLA）系统往往把这一中间结构留为隐式。现有的思维链（CoT）规划器也往往依赖粗粒度的任务级标注，或逐 token 地串行生成冗长的推理轨迹。我们提出 X-Planner，一个同时处理具身推理的监督与表示问题的规划前端。

我们的规划数据把 Ego、UMI 和遥操作数据纳入同一套层级粒度，标注深度随数据来源而异。接管时刻标注和人工设计的失败示范用于监督执行过程中的错误识别。在模型方面，共享的 VLM 主干提供两种事件结构化的计划形式：一种是输出可解释事件状态的离散接口，另一种是通过阶梯解码（Staircase Decoding）在错开的 Transformer 深度之间传递连续 CoT 状态的潜在接口。冻结的潜在到文本重建目标为潜在表示提供语义锚点。

离线两步规划评测中，X-Planner 在 BERTScore-F1 和基于评判模型的 Overall 分数上，均位列四个被评模型中的第二。在真实机器人实验中，……分别……，优于所评测的基线（原文此句残缺，缺少具体数值）。这些结果刻画了规划文本质量和下游执行表现。

## 摘要（原文）

> Task planning bridges high-level instructions and executable behavior in long-horizon manipulation, yet modern Vision-Language-Action (VLA) systems often leave this intermediate structure implicit. Existing chain-of-thought (CoT) planners also tend to rely on coarse task-level annotations or serialize long reasoning traces token by token. We present X-Planner, a planning front-end that addresses both the supervision and representation of embodied reasoning. Our planning data combine Ego, UMI, and teleoperation under a hierarchy granularity with source-dependent annotation depth. Takeover-time annotations and human-designed failures supervise ongoing error recognition. On the model side, a shared VLM backbone exposes two event-structured plan forms: a discrete interface that emits interpretable event states and a latent interface that relays continuous CoT states across staggered Transformer depths through Staircase Decoding. A frozen latent-to-text reconstruction objective provides a semantic anchor for the latent representation. Offline two-step planning evaluation places X-Planner second among four evaluated models on both BERTScore-F1 and a judge-based Overall score. In real-robot experiments, respectively, outperforming the evaluated baselines. These results characterize planning-text quality and downstream execution.
