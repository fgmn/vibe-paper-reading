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

> Task planning bridges high-level instructions and executable behavior in long-horizon manipulation, yet modern Vision-Language-Action (VLA) systems often leave this intermediate structure implicit. Existing chain-of-thought (CoT) planners also tend to rely on coarse task-level annotations or serialize long reasoning traces token by token. We present X-Planner, a planning front-end that addresses both the supervision and representation of embodied reasoning. Our planning data combine Ego, UMI, and teleoperation under a hierarchy granularity with source-dependent annotation depth. Takeover-time annotations and human-designed failures supervise ongoing error recognition. On the model side, a shared VLM backbone exposes two event-structured plan forms: a discrete interface that emits interpretable event states and a latent interface that relays continuous CoT states across staggered Transformer depths through Staircase Decoding. A frozen latent-to-text reconstruction objective provides a semantic anchor for the latent representation. Offline two-step planning evaluation places X-Planner second among four evaluated models on both BERTScore-F1 and a judge-based Overall score. In real-robot experiments, respectively, outperforming the evaluated baselines. These results characterize planning-text quality and downstream execution.
