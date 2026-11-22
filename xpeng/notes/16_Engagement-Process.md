---
id: "16"
org: 小鹏
short: "Engagement Process"
title: "Engagement Process: Rethinking the Temporal Interface of Action and Observation"
aliases: ["Engagement Process"]
date: 2026-05-12
category: "机器人"
source: "小鹏主导"
product: "通用（具身交互）"
partners: []
authors: ["Jialian Li", "Yuchen Cao", "Junhong Liu", "Weiran Guo", "Xutao Wang", "Jiaming Song", "Jiahao Zhang", "Jie Chen"]
arxiv: "2605.11484"
pdf: "[[xpeng/papers/16_2605.11484_Engagement-Process.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# Engagement Process: Rethinking the Temporal Interface of Action and Observation

> [!info] 论文信息
> arXiv [2605.11484](https://arxiv.org/abs/2605.11484) · v1 2026-05-12 · 最新 v2（2026-06-08）
> PDF：[[xpeng/papers/16_2605.11484_Engagement-Process.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏主导 · 产品：通用（具身交互）
> 清单里的一句话（Claude 根据摘要写，请核对）：【XPENG Robotics】Engagement Process：显式建模时间的动作-观测交互形式化。
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

> Task completion in digital and physical environments increasingly involves complex temporal interaction, where actions and observations unfold over different time scales rather than align with fixed observation--action steps. To model such interactions, we propose Engagement Process (EP), an interaction formalism that inherits the decision-theoretic structure of POMDPs while making time explicit in the action--observation interface. EP represents actions and observations as decoupled event streams along time, rather than updates paired at fixed decision steps. This interface captures single-agent timing issues such as deliberation latency, delayed feedback, and persistent actions, while supporting richer agent-side organization, multi-rate coordination, and compositional interaction among subsystems. Across toy, LLM-agent, and learning experiments, EP exposes temporal behaviors hidden by step-based interfaces and enables policies to adapt under explicit time costs.
