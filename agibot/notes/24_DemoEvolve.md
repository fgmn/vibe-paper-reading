---
id: "24"
org: 智元
short: "DemoEvolve"
title: "DemoEvolve: Demonstration-Guided Harness Evolution under Sparse Feedback"
aliases: ["DemoEvolve"]
date: 2026-05-23
category: "其他"
source: "智元主导"
product: ""
partners: []
authors: ["Lirong Che", "Yuzhe yang", "Peiwen lin", "Xu Cao", "Chuang wang", "Xueqian wang", "Jian su"]
arxiv: "2605.24539"
pdf: "[[agibot/papers/24_2605.24539_DemoEvolve.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# DemoEvolve: Demonstration-Guided Harness Evolution under Sparse Feedback

> [!info] 论文信息
> arXiv [2605.24539](https://arxiv.org/abs/2605.24539) · v1 2026-05-23 · 最新 v2（2026-09-29）
> PDF：[[agibot/papers/24_2605.24539_DemoEvolve.pdf|本地 PDF]]
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：DemoEvolve：利用人类示教引导智能体外围程序（harness）演化，适应稀疏反馈长时程任务。
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

> Harness evolution enables frozen language model agents to adapt to unfamiliar tasks by modifying the external programs that govern their behavior. For long-horizon tasks, each rollout is costly, and a limited interaction budget may yield few examples of effective behavior. Sparse, delayed feedback also makes it difficult for a coding agent to diagnose failures and determine which modifications will improve performance. We present DemoEvolve, which uses human demonstrations to guide harness evolution under limited interaction budgets. The coding agent examines demonstrations alongside its own rollout history, extracts strategies and the conditions under which they apply, and turns them into reusable harness components. We compare demonstration guidance with self-rollout evolution and augmentation with retrieved textual knowledge under the same evolution procedure and agent interaction budget. On held-out seeds, DemoEvolve improves mean capped final-round progress from 16.83 to 20.00 in Balatro and mean floor reached from 18.17 to 28.83 in Slay the Spire 2, compared with the respective base harnesses. These results suggest that demonstrations can help harness evolution make better use of limited interaction experience by providing concrete guidance for diagnosis and modification.
