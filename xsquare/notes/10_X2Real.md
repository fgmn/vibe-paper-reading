---
id: "10"
org: 自变量
short: "X2Real"
title: "X2Real: an eXtensive simulation benchmark for real-world generalist policies"
aliases: ["X2Real"]
date: 2026-09-23
category: 评测基准
source: 自变量主导
partners: []
authors: ["Lian Ruan", "Jade Yang", "Sherphylan Gao", "Felix Gao", "Kyson Liang", "Galen Liu", "Ligo Wu", "Lane Jin", "Guu Gu", "Bevan Xie", "Cloud Yan", "Zongzi Yuan", "Kino Luo", "Emma Chen", "Shuwen Chen", "Yang Ping", "Miles Guo", "Rain Sun", "Kayden Zhang", "Alex Du", "Ruihai Wu", "Liang Hao", "Zhaoshuo Li", "Roy Gan", "Hao Wang", "Qian Wang"]
arxiv: "2609.27449"
pdf: "[[xsquare/papers/10_2609.27449_X2Real.pdf]]"
code: "https://github.com/X-Square-Robot/x2real"
project: "https://x2robot.com/en/pages/x2real"
huggingface: ["https://huggingface.co/datasets/x-square-robot/X2Real-Dataset"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "benchmark", "simulation", "sim2real"]
---

# X2Real: an eXtensive simulation benchmark for real-world generalist policies

> [!info] 论文信息
> arXiv [2609.27449](https://arxiv.org/abs/2609.27449) · v1 2026-09-23 · 最新 v2（2026-10-13）
> PDF：[[xsquare/papers/10_2609.27449_X2Real.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/x2real) · [项目页](https://x2robot.com/en/pages/x2real) · [X2Real-Dataset](https://huggingface.co/datasets/x-square-robot/X2Real-Dataset)

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

> Generalist robot manipulation policies have developed rapidly, yet their reliable evaluation remains challenging due to fundamental flaws in existing simulation benchmarks: prominent sim-to-real gaps, narrow task coverage, and unfair evaluation caused by ambiguous training-test pipelines. Prior works only partially resolve these issues and lack simultaneous faithfulness, diversity, and fairness, while static benchmark designs fail to sustain long-term policy development. We present X2Real, an evolvable simulation benchmark for faithfully evaluating the real-world performance of robotic manipulation policies based on Nvidia Isaac Lab-Arena. Following three core principles (faithfulness, diversity, and fairness), X2Real calibrates simulation visual and physical properties to align with real hardware, achieving a 0.84 linear correlation between simulated and real-robot evaluation results. It features a comprehensive taxonomy with 10 capability dimensions and 44 hierarchical long-horizon tasks, covering basic manipulation skills and advanced capacities such as visual grounding, language understanding, and bimanual control. We further adopt multi-axis domain randomization and strictly disjoint training-evaluation pipelines to mitigate benchmark exploitation and ensure credible evaluation. Powered by a custom physical domain-specific language, the Mana simulation ecosystem supports modular task design and iterative performance analysis, alongside a nearly 300-hour annotated simulation trajectory dataset. X2Real offers a faithful, diverse, and fair evolving evaluation infrastructure, effectively bridging the sim-to-real evaluation gap and supporting the advancement of generalist robotic manipulation policies.
