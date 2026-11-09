---
id: "40"
org: 智元
short: "ReSight"
title: "ReSight: Task-Driven Self-Improving Memory for Embodied Agents"
aliases: ["ReSight"]
date: 2026-10-24
category: "其他"
source: "智元主导"
product: ""
partners: []
authors: ["Lirong Che", "Yang Chen", "Yimeng Su", "Daqi Liu", "Zhenyu Huang", "Jiong Wang", "Yuzhe Yang", "Xu Cao", "Chuang Wang", "Jian Su", "Xueqian Wang"]
arxiv: "2610.33487"
pdf: "[[agibot/papers/40_2610.33487_ReSight.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# ReSight: Task-Driven Self-Improving Memory for Embodied Agents

> [!info] 论文信息
> arXiv [2610.33487](https://arxiv.org/abs/2610.33487) · v1 2026-10-24
> PDF：[[agibot/papers/40_2610.33487_ReSight.pdf|本地 PDF]]
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：ReSight：任务驱动、可自我扩展的具身智能体记忆系统。
> 汇总：[[agibot/智元-论文与报告汇总|智元论文与报告汇总]]

## 一句话总结

## 要解决什么问题

## 方法

## 实验与关键数字

## 局限 / 存疑

## 与其他论文的关系

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> Robots can use historical observations to answer spatiotemporal queries in familiar environments, but the presence of relevant evidence does not imply that existing tools support the operations a task requires. We introduce ReSight, a task-driven self-improving memory system for embodied agents that expands the capabilities for processing and accessing historical observations as task demands arise. ReSight retains keyframes and their spatiotemporal associations, separating observation evidence from extensible derived fields so that stored observations can be reprocessed for new needs. An execution agent and a coding agent share this memory through different interfaces: the former calls registered tools within a bounded online budget, while the latter uses a programmable workspace and a larger exploration budget to inspect evidence, write programs, and acquire models as needed. To realize capability expansion in ReSight, we develop Explore-Distill-Mount (EDM), which identifies capability gaps from execution and exploration records without task reference answers and converts exploration-derived solutions into reusable memory builders, query tools, and skills, extending memory representations and access capabilities as needed. Experiments on three public benchmarks demonstrate effective base memory access and capability expansion. With the execution model and online budget held fixed within each benchmark, EDM reduces mean position error on OC-NaVQA from 33.10 m to 24.72 m and improves high-level success on FindingDory from 38.3% to 63.8%. With the tools and skill frozen, success still improves by 28.3 percentage points on FindingDory episodes excluded from exploration and distillation. Experiments on real robot patrol memories further demonstrate reuse of these capabilities for subsequent queries and new memories, with fewer online tool calls on average.
