---
id: "44"
org: 小鹏
short: "Dual-Anchoring"
title: "Dual-Anchoring: Addressing State Drift in Vision-Language Navigation"
aliases: ["Dual-Anchoring"]
date: 2026-04-19
category: "其他"
source: "小鹏合作"
product: ""
partners: []
authors: ["Kangyi Wu", "Pengna Li", "Kailin Lyu", "Xi Lin", "Lin Zhao", "Qingrong He", "Jinjun Wang", "Jianyi Liu"]
arxiv: "2604.17473"
pdf: "[[xpeng/papers/44_2604.17473_Dual-Anchoring.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "vln"]
---

# Dual-Anchoring: Addressing State Drift in Vision-Language Navigation

> [!info] 论文信息
> arXiv [2604.17473](https://arxiv.org/abs/2604.17473) · v1 2026-04-19 · 最新 v4（2026-06-23） · 发表：Lecture notes in computer science
> PDF：[[xpeng/papers/44_2604.17473_Dual-Anchoring.pdf|本地 PDF]]
> 方向：其他 · 角色：小鹏合作
> 清单里的一句话（Claude 根据摘要写，请核对）：Dual-Anchoring：解决视觉语言导航中的状态漂移问题。
> 汇总：[[xpeng/小鹏-论文与报告汇总|小鹏论文与报告汇总]]

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

> Vision-Language Navigation(VLN) requires an agent to navigate through 3D environments by following natural language instructions. While recent Video Large Language Models(Video-LLMs) have largely advanced VLN, they remain highly susceptible to State Drift in long scenarios. In these cases, the agent's internal state drifts away from the true task execution state, leading to aimless wandering and failure to execute essential maneuvers in the instruction. We attribute this failure to two distinct cognitive deficits: Progress Drift, where the agent fails to distinguish completed sub-goals from remaining ones, and Memory Drift, where the agent's history representations degrade, making it lose track of visited landmarks. In this paper, we propose a Dual-Anchoring Framework that explicitly anchors the instruction progress and history representations. First, to address progress drift, we introduce Instruction Progress Anchoring, which supervises the agent to generate structured text tokens that delineate completed versus remaining sub-goals. Second, to mitigate memory drift, we propose Memory Landmark Anchoring, which utilizes a Landmark-Centric World Model to retrospectively predict object-centric embeddings extracted by the Segment Anything Model, compelling the agent to explicitly verify past observations and preserve distinct representations of visited landmarks. Facilitating this framework, we curate two extensive datasets: 3.6 million samples with explicit progress descriptions, and 937k grounded landmark data for retrospective verification. Extensive experiments in both simulation and real-world environments demonstrate the superiority of our method, achieving a 15.2% improvement in Success Rate and a remarkable 24.7% gain on long-horizon trajectories. To facilitate further research, we will release our code, data generation pipelines, and the collected datasets.
