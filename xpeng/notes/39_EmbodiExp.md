---
id: "39"
org: 小鹏
short: "EmbodiExp"
title: "EmbodiExp: Compositional Experience Transfer for Embodied Agents"
aliases: ["EmbodiExp"]
date: 2026-10-29
category: "机器人"
source: "小鹏合作"
product: "通用（具身智能体）"
partners: []
authors: ["Zhifeng Gu", "Ying Chen", "Rui Jiang", "Lei Yi", "Bing Wang"]
arxiv: "2610.39180"
pdf: "[[xpeng/papers/39_2610.39180_EmbodiExp.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# EmbodiExp: Compositional Experience Transfer for Embodied Agents

> [!info] 论文信息
> arXiv [2610.39180](https://arxiv.org/abs/2610.39180) · v1 2026-10-29 · 最新 v2（2026-11-13）
> PDF：[[xpeng/papers/39_2610.39180_EmbodiExp.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏合作 · 产品：通用（具身智能体）
> 清单里的一句话（Claude 根据摘要写，请核对）：【XPENG Robotics】EmbodiExp：基于子目标经验组合的具身智能体跨任务经验迁移。
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

> Experience from past tasks can help embodied agents perform new tasks, but it may not remain applicable or effective when conditions change. Tasks with different overall goals often share subgoals, providing a basis for cross-task experience transfer. We present EmbodiExp, a framework for constructing outcome-grounded subgoal experiences and composing them in new tasks. Each experience describes how to pursue a subgoal, when the guidance applies, and what outcome must be verified for completion. Verified outcomes from applying one experience can satisfy the conditions for applying another, allowing experiences from different past tasks to be composed online. By examining the actions and observed outcomes at the subgoal level, EmbodiExp retains experience from successful subgoals and uses explicit action failures to identify actions to avoid under specific conditions. Experiments on EmbodiedBench and VIGIL assess cross-task transfer with experiences kept fixed throughout held-out evaluation. EmbodiExp achieves success rates of 68.0% on EB-Habitat and 68.3% on EB-ALFRED, compared with 50.0% and 54.7% for the agent without stored experience.
