---
id: "20"
org: 自变量
short: "WSM-Aware-HRI"
title: "WSM-Aware HRI: An IoT-Enhanced Framework for Early Detection and Norm-Guided Repair of Failures with LLM Guidance"
aliases: ["WSM-Aware-HRI"]
date: 2026-09-26
category: 人机交互
source: 合作
partners: ["香港中文大学（深圳）", "深圳市人工智能与机器人研究院"]
authors: ["Hanlin Zhang", "Yuquan Wang", "Tianwei Zhang", "Zhenglong Sun"]
arxiv: "2609.32336"
pdf: "[[xsquare/papers/20_2609.32336_WSM-Aware-HRI.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "hri", "llm", "failure-recovery"]
---

# WSM-Aware HRI: An IoT-Enhanced Framework for Early Detection and Norm-Guided Repair of Failures with LLM Guidance

> [!info] 论文信息
> arXiv [2609.32336](https://arxiv.org/abs/2609.32336) · v1 2026-09-26 · 最新 v2（2026-10-07）
> PDF：[[xsquare/papers/20_2609.32336_WSM-Aware-HRI.pdf|本地 PDF]]
> [ACM THRI](https://doi.org/10.1145/3858343)
> 合作单位：香港中文大学（深圳）、深圳市人工智能与机器人研究院

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 把 HRI 中断统一为世界状态不匹配：“We propose WSM-Aware HRI, an IoT-enhanced modular framework that unifies diverse HRI breakdowns as World-State Mismatches (WSMs) between a human’s instruction-implied assumptions and a robot’s grounded world model”（Abstract）
> - 从执行时恢复转向意图形成阶段的主动检测：“WSM-Aware HRI shifts failure handling from execution-time recovery to proactive mismatch detection during intention formation”（Abstract）
> - 五类不匹配的分类：“these interaction-facing failures can be understood as world-state mismatches that fall into a small and reusable taxonomy: instruction–logic mismatches, perceptual/affordance mismatches, temporal/sequence mismatches, social/ethical norm mismatches, and multi-user conflicts.”（§1）
> - 后端 LLM 为 GPT-4 Turbo：“We use GPT-4 Turbo as the backend LLM, with the prompts provided in the Appendix.”（§3.6）
> - LLM 只做假设生成，不做最终决策：“The LLM is used as a hypothesis-generation module within a grounded verification loop, rather than as an end-to-end decision maker.”（§3.6）
> - 10 个场景共 50 次试验：“we conducted a human-referenced evaluation on the 50 trial records from the 10 experimental scenes.”（§4.2）
> - 完整系统四个维度的匹配数：“Full WSM-Aware HRI achieved the strongest alignment across all four dimensions, with 44/50 matches for WSM type, 43/50 for evidence coverage, 43/50 for pre-execution intervention, and 42/50 for repair decision.”（§4.2）
> - 去掉 IoT 证据：58/60 降到 10/60：“With IoT evidence included, LLM-Revise identified the expected WSMs in 58/60 prompt trials; after removing this evidence, accuracy dropped to 10/60”（§4.3）
> - 去掉轨迹细化：3/5 vs 5/5：“Without refinement, the system identifies mismatches in 3/5 trials, whereas the full system identifies them in 5/5.”（§4.3）
> - 多用户冲突案例更难：“The lower correctness in the multi-user cases indicates that stakeholder identification and role-priority reasoning are more difficult than single-user physical or temporal mismatch detection”（§4.3）

## 一句话总结

把人机交互失败统一看作“世界状态不匹配”，用 LLM 提假设、借感知和 IoT 证据核验，在执行前发现并修复。

## 要解决什么问题

人机交互（HRI）中的失败是机器人落地的主要障碍，但已有工作多把失败当作孤立的技术故障，或只关注事后的恢复行为。实际上很多失败源于人和机器人对当前世界状态的假设不一致，而且这种不一致在指令发出时往往就已存在、只是尚未显现；把 IoT 等外部信息纳入机器人世界模型来提前预防和修复失败，也还很少有人研究。

## 方法

- 世界状态不匹配（World-State Mismatch, WSM）：把人类指令隐含的假设（意图、物理情境、规范情境）与机器人的增强世界状态（多模态感知、来自 IoT 和外部服务的数字增强、规范与角色约束）对比，用差异分数和可执行性谓词（admissibility predicate）触发告警（§3.1–3.3）。
- 五类不匹配：指令逻辑、感知/可供性、时序/顺序、社会/伦理规范、多用户冲突；由已有 HRI 失败研究映射而来，每类对应所需证据和修复路径（§3.4–3.5，表 1–2）。
- 两阶段 LLM 识别（后端为 GPT-4 Turbo）：LLM-Hypothesize 显式提取假设，给出候选类型和可执行的证据请求；系统采集证据（感知、IoT、策略、执行状态）后，LLM-Revise 只保留有证据支持的类型。LLM 只负责生成假设，不做最终判定（§3.6，提示词见附录 A、B）。
- 四模块流水线：世界状态构建（World-State Builder）、人类假设估计（Human-Assumption Estimator）、WSM 监测（WSM Monitor）、规范引导的修复规划（Norm-Guided Repair Planner）；按“安全 > 规范/伦理 > 多用户协调 > 效率”的优先级裁决，并输出自然语言解释（§3.7）。
- 三个算法阶段：执行前在计划中插入验证探针（WSM probes）、执行中在线监测、按不匹配类型和严重程度做处理（§3.8）。

## 实验与关键数字

- 设置：10 个日常场景、共 50 次试验（每个场景跑五次，每次带受控的小扰动），覆盖视觉可见的不匹配（如玩具放不进杯子、往带孔容器倒水）和需要主动感知的隐藏状态不匹配（如不透明杯子里的水量）（§4.1）。
- 与人工参考标签对比：完整系统在 WSM 类型、证据覆盖、执行前干预、修复决策上分别达到 44/50、43/50、43/50、42/50，优于 LLM-only 等三个内部消融和事后恢复、可供性/动作落地两个代理基线（§4.2、表 3）。
- IoT 证据消融（离线、提示级，只用依赖 IoT 的场景）：带 IoT 证据时 LLM-Revise 识别正确 58/60，去掉后降到 10/60（§4.3、表 5）。
- 去掉 WSM 感知的轨迹细化后，非视觉不匹配场景只识别出 3/5，完整系统为 5/5；视觉落地输出的消融表明不同类型的不匹配依赖不同的落地表征（§4.3、表 6–7）。
- 多用户冲突案例的正确率较低，作者认为利益相关者识别和角色优先级推理比单用户的物理或时序不匹配更难（§4.3、表 4）。

## 局限 / 存疑

## 与其他论文的关系

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 9 条

> We propose WSM-Aware HRI, an IoT-enhanced modular framework that uni!es diverse HRI breakdowns as World-State Mismatches (WSMs) between a human’s instruction-implied assumptions and a robot’s grounded world model
> 批注：Claude：把 HRI 中断统一为世界状态不匹配
> — [[xsquare/papers/20_2609.32336_WSM-Aware-HRI.pdf#page=1|p.1]]

> WSM-Aware HRI shifts failure handling from execution-time recovery to proactive mismatch detection during intention formation
> 批注：Claude：从执行时恢复转向意图形成阶段的主动检测
> — [[xsquare/papers/20_2609.32336_WSM-Aware-HRI.pdf#page=1|p.1]]

> We use GPT-4 Turbo as the backend LLM, with the prompts provided in the Appendix.
> 批注：Claude：后端 LLM 为 GPT-4 Turbo
> — [[xsquare/papers/20_2609.32336_WSM-Aware-HRI.pdf#page=12|p.12]]

> The LLM is used as a hypothesis-generation module within a grounded veri!cation loop, rather than as an end-to-end decision maker.
> 批注：Claude：LLM 只做假设生成，不做最终决策
> — [[xsquare/papers/20_2609.32336_WSM-Aware-HRI.pdf#page=12|p.12]]

> we conducted a human-referenced evaluation on the 50 trial records from the 10 experimental scenes.
> 批注：Claude：10 个场景共 50 次试验
> — [[xsquare/papers/20_2609.32336_WSM-Aware-HRI.pdf#page=17|p.17]]

> Full WSM-Aware HRI achieved the strongest alignment across all four dimensions, with 44/50 matches for WSM type, 43/50 for evidence coverage, 43/50 for pre-execution intervention, and 42/50 for repair decision.
> 批注：Claude：完整系统四个维度的匹配数
> — [[xsquare/papers/20_2609.32336_WSM-Aware-HRI.pdf#page=18|p.18]]

> The lower correctness in the multi-user cases indicates that stakeholder identi!cation and role-priority reasoning are more di$cult than single-user physical or temporal mismatch detection
> 批注：Claude：多用户冲突案例更难
> — [[xsquare/papers/20_2609.32336_WSM-Aware-HRI.pdf#page=20|p.20]]

> With IoT evidence included, LLM-Revise identi!ed the expected WSMs in 58/60 prompt trials; after removing this evidence, accuracy dropped to 10/60
> 批注：Claude：去掉 IoT 证据：58/60 降到 10/60
> — [[xsquare/papers/20_2609.32336_WSM-Aware-HRI.pdf#page=21|p.21]]

> Without re!nement, the system identi!es mismatches in 3/5 trials, whereas the full system identi!es them in 5/5.
> 批注：Claude：去掉轨迹细化：3/5 vs 5/5
> — [[xsquare/papers/20_2609.32336_WSM-Aware-HRI.pdf#page=22|p.22]]
<!-- highlights:end -->

## 摘要（中文）

人机交互（HRI）中的失败仍是机器人在真实环境中部署的主要障碍。已有工作通常把失败当作孤立的技术故障，或者侧重于事后的恢复行为。而在实践中，许多交互中断的起因是人和机器人对当前世界状态持有不一致的假设。

我们提出 WSM-Aware HRI，一个由 IoT 增强的模块化框架，它把各种 HRI 中断统一为世界状态不匹配（World-State Mismatch，WSM），即人类指令所隐含的假设与机器人基于多模态感知和数字增强构建的落地世界模型之间的不一致。框架用大语言模型（LLM）把隐含假设显式化，把它们映射到少数几类不匹配类型，并指明需要哪些证据来对照机器人的世界状态进行核验。WSM-Aware HRI 把失败处理从执行时的恢复前移到意图形成阶段的主动不匹配检测，从而能在安全、规范遵从和多用户协调的指导下进行干预，并给出透明的解释。

我们在十个日常案例上评估了不匹配识别，这些案例既包括视觉可见的不匹配，也包括隐藏状态的不匹配。系统能够准确产生预期的输出结果，消融实验表明，可靠的识别依赖于合适的落地表征和以核验为导向的修正步骤。这些结果说明，把交互中断视为显式的世界状态不匹配，可以更早地发现即将发生的失败，并为在人机交互中整合外部证据和社会约束提供一种有原则的机制。

## 摘要（原文）

> Human-robot interaction (HRI) failures remain a major barrier to deploying robots in real-world environments. Prior work often treats failures as isolated technical faults or focuses on post-hoc recovery behaviors. In practice, many breakdowns arise because humans and robots operate under inconsistent assumptions about the current world state. We propose WSM-Aware HRI, an IoT-enhanced modular framework that unifies diverse HRI breakdowns as World-State Mismatches (WSMs) between a human's instruction-implied assumptions and a robot's grounded world model built from multimodal perception and digital augmentation. A Large Language Model (LLM) is used to make implicit assumptions explicit, map them to a small set of mismatch types, and specify the evidence needed for verification against the robot's world state. WSM-Aware HRI shifts failure handling from execution-time recovery to proactive mismatch detection during intention formation, enabling interventions guided by safety, norm compliance, and multi-user coordination with transparent explanations. We evaluate mismatch identification in ten everyday cases spanning both visual and latent-state mismatches. The system can accurately produce the expected output results, and ablations show that reliable identification depends on appropriate grounding representations and verification-oriented refinement. These results indicate that treating interaction breakdowns as explicit world-state mismatches enables earlier detection of impending failures and offers a principled mechanism for integrating external evidence and social constraints into human-robot interaction.
