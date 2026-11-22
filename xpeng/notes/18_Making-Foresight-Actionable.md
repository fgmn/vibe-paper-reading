---
id: "18"
org: 小鹏
short: "Making Foresight Actionable"
title: "Making Foresight Actionable: Repurposing Representation Alignment in World Action Models"
aliases: ["Making Foresight Actionable"]
date: 2026-06-10
category: "机器人"
source: "小鹏主导"
product: "IRON"
partners: []
authors: ["Lu Qiu", "Yizhuo Li", "Yi Chen", "Yuying Ge", "Yixiao Ge", "Xihui Liu"]
arxiv: "2606.12217"
pdf: "[[xpeng/papers/18_2606.12217_Making-Foresight-Actionable.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# Making Foresight Actionable: Repurposing Representation Alignment in World Action Models

> [!info] 论文信息
> arXiv [2606.12217](https://arxiv.org/abs/2606.12217) · v1 2026-06-10
> PDF：[[xpeng/papers/18_2606.12217_Making-Foresight-Actionable.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏主导 · 产品：IRON
> 清单里的一句话（Claude 根据摘要写，请核对）：AGRA以动作对齐的表征对齐目标连接世界动作模型中的视频预测与控制，并在IRON人形上真机验证。
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

> World Action Models (WAMs) offer a promising route for robot manipulation by using video generation models to model future scene evolution before producing control actions. However, our empirical observations reveal a phenomenon: generating plausible visual futures does not always guarantee the extraction of accurate actions. To diagnose this failure, we conduct action-head attention analysis and causal interventions. We find that the action decoder fails to focus on task-relevant interaction regions and remains sensitive to perturbations in task-irrelevant areas. This reveals a representation mismatch: hidden states optimized for visual reconstruction are not inherently organized in a form useful for low-level action control. In this paper, we propose AGRA, an Action-Grounded Representation Alignment objective that regularizes the world-action interface by aligning intermediate video diffusion features with spatially coherent semantic representations from a foundation visual encoder. We evaluate AGRA on real-world manipulation tasks. Experiments show that AGRA makes world model representations more action-grounded: by focusing the action decoder on the correct interaction regions, it improves object localization accuracy and affordance understanding, and makes the policy more robust to perturbations in task-irrelevant regions. As a result, AGRA consistently improves both in-distribution performance and out-of-distribution generalization over the baseline world action model.
