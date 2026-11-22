---
id: "26"
org: 小鹏
short: "XCoT-VLA"
title: "XCoT-VLA: Executable Chain-of-Thought for Vision-Language-Action Driving"
aliases: ["XCoT-VLA"]
date: 2026-08-11
category: "端到端与VLA"
source: "小鹏主导"
product: ""
partners: []
authors: ["Foundation Model Team", "XPeng Inc"]
arxiv: "2608.10976"
pdf: "[[xpeng/papers/26_2608.10976_XCoT-VLA.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng"]
---

# XCoT-VLA: Executable Chain-of-Thought for Vision-Language-Action Driving

> [!info] 论文信息
> arXiv [2608.10976](https://arxiv.org/abs/2608.10976) · v1 2026-08-11
> PDF：[[xpeng/papers/26_2608.10976_XCoT-VLA.pdf|本地 PDF]]
> 方向：端到端与VLA · 角色：小鹏主导
> 清单里的一句话（Claude 根据摘要写，请核对）：XCoT-VLA：以可执行思维链替代冗长自然语言CoT，用于实时驾驶VLA。
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

> Vision-Language-Action (VLA) models can connect scene understanding, semantic reasoning, and trajectory generation for autonomous driving. However, verbose natural-language Chain-of-Thought (CoT) is poorly suited to real-time control because it is open-ended, costly to decode, and difficult to optimize as an action-facing representation. We propose XCoT-VLA, which replaces descriptive rationales with compact executable CoT tokens learned from automatically constructed Reason-Action supervision. Logged trajectories provide action evidence, while scene context supplies causal semantics. The predicted XCoT sequence remains in context and conditions fixed trajectory queries through shared multimodal self-attention. Deterministic token-function routing applies the Reason FFN to XCoT tokens and the Control FFN to trajectory queries for flow-matching trajectory generation. We further introduce XCoT Policy Optimization (XCPO) as an optional refinement extension in the same executable token space. XCoT-VLA reduces longitudinal ADE from 1.645 to 1.323 on a general-distribution set and lateral FDE from 1.616 to 0.648 in lane-change scenarios. By representing driving-oriented reasoning with only 2-6 executable XCoT tokens, our method substantially reduces autoregressive reasoning overhead and remains within the real-time planning budget. These results demonstrate that driving-oriented reasoning can be compact, executable, and directly connected to trajectory generation.
