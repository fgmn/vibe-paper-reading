---
id: "14"
org: 小鹏
short: "Done, But Not Sure"
title: "Done, But Not Sure: Disentangling World Completion from Self-Termination in Embodied Agents"
aliases: ["Done, But Not Sure"]
date: 2026-05-09
category: "机器人"
source: "小鹏主导"
product: "通用（具身评测）"
partners: []
authors: ["Ying Chen", "Lihuang Fang", "Rui Jiang", "Mingxu Wang", "Zhifeng Gu", "Lei Yi", "Jie Chen"]
arxiv: "2605.08747"
pdf: "[[xpeng/papers/14_2605.08747_Done-But-Not-Sure.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# Done, But Not Sure: Disentangling World Completion from Self-Termination in Embodied Agents

> [!info] 论文信息
> arXiv [2605.08747](https://arxiv.org/abs/2605.08747) · v1 2026-05-09 · 最新 v4（2026-06-02）
> PDF：[[xpeng/papers/14_2605.08747_Done-But-Not-Sure.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏主导 · 产品：通用（具身评测）
> 清单里的一句话（Claude 根据摘要写，请核对）：【XPENG Robotics】VIGIL：解耦具身智能体任务完成与自我终止判定的评测框架。
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

> Standard embodied evaluations do not independently score whether an agent correctly commits to task completion at episode closure, a capacity we call terminal commitment. Behaviorally distinct failures--never completing the task, completing it but failing to stop, and reporting success without sufficient evidence--collapse into the same benchmark failure. We introduce VIGIL, an evaluation framework that makes terminal commitment independently measurable. Under VIGIL's default protocol, agents observe only egocentric RGB, receive no action-success signals, and must end each episode with a semantic report checked deterministically against hidden world state. This yields two separate scores: world-state completion (W) and benchmark success (B), where B additionally requires a correct terminal report. This decoupling makes four outcome categories distinguishable: missed execution, post-attainment drift, unsupported commitment, and verified success. Across 20 models on 1,000 frozen episodes, systems with comparable W differ by up to 19.7 pp in B: one model converts achieved states into correct reports, while another with near-identical execution drifts past the goal without closing. An action-feedback intervention further tests the separation: execution-oriented signals improve W broadly, yet commitment failures persist in models that do not already ground terminal reports in the achieved state. VIGIL provides a protocol that makes terminal commitment independently visible and scorable.
