---
id: "20"
org: 小鹏
short: "DeepInsight"
title: "DeepInsight: A Unified Evaluation Infrastructure Across the Physical AI Stack"
aliases: ["DeepInsight"]
date: 2026-06-16
category: "机器人"
source: "小鹏主导"
product: "通用（人形评测）"
partners: []
authors: ["Siyi Li", "Chunyu Sun", "Jiahao Zhang", "Yuchen Kang", "Wuliang Wang", "Yu Qiu", "Rui Jiang", "Haitao Cui", "Jie Chen"]
arxiv: "2606.17574"
pdf: "[[xpeng/papers/20_2606.17574_DeepInsight.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# DeepInsight: A Unified Evaluation Infrastructure Across the Physical AI Stack

> [!info] 论文信息
> arXiv [2606.17574](https://arxiv.org/abs/2606.17574) · v1 2026-06-16
> PDF：[[xpeng/papers/20_2606.17574_DeepInsight.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏主导 · 产品：通用（人形评测）
> 清单里的一句话（Claude 根据摘要写，请核对）：【XPENG Robotics】DeepInsight：横跨物理AI栈的统一评测基础设施。
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

> Evaluating a Physical AI stack spans operators that differ by more than three orders of magnitude -- from a single foundation-model decoding step to thousands of physics ticks of whole-body control -- varying orthogonally in modality, reward semantics, and resource profile. No existing framework spans this range, so the stack is evaluated today by stitching together separate harnesses that share neither runtime nor scoring, preserving each segment's local validity but losing the shared identity needed to diagnose cross-layer regressions. We present DeepInsight, an evaluation infrastructure that serves this full spectrum on a single runtime. Rather than homogenize the regimes, it preserves their heterogeneity behind three narrow abstractions -- task, resource, and result -- each realized as one invariant shared by every subsystem: one episode driver, one resource-handle protocol implemented by every expensive backend (LLM inference and sandboxed runtimes alike), and one trace identity scheme under which every event is written. Deployed in production across all three layers of an embodied humanoid stack, this single set of invariants onboards new benchmarks largely by configuration. Where mature peer orchestrators exist -- at the foundation-model end -- it reproduces published references and peer-framework readings within their own spread, runs the same suites faster on a single node, and scales near-linearly across nodes. Its distinctive return is diagnostic: because every layer writes into one shared trace, a regression that begins in one layer and surfaces in another stays localizable on that trace -- a cross-layer payoff no federation of per-segment harnesses can reproduce.
