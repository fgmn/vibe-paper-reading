---
id: "19"
org: 小鹏
short: "ROVE"
title: "ROVE: Unlocking Human Interventions for Humanoid Manipulation via Reinforcement Learning"
aliases: ["ROVE"]
date: 2026-06-15
category: "机器人"
source: "小鹏主导"
product: "IRON"
partners: []
authors: ["Wei Xiao", "Weiliang Tang", "Yuying Ge", "Hui Zhou", "Yao Mu", "Li Zhang", "Yixiao Ge"]
arxiv: "2606.17011"
pdf: "[[xpeng/papers/19_2606.17011_ROVE.pdf]]"
code: ""
project: "https://xpeng-robotics.github.io/rove"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# ROVE: Unlocking Human Interventions for Humanoid Manipulation via Reinforcement Learning

> [!info] 论文信息
> arXiv [2606.17011](https://arxiv.org/abs/2606.17011) · v1 2026-06-15 · 最新 v2（2026-10-02）
> PDF：[[xpeng/papers/19_2606.17011_ROVE.pdf|本地 PDF]]
> [项目页](https://xpeng-robotics.github.io/rove)
> 方向：机器人 · 角色：小鹏主导 · 产品：IRON
> 清单里的一句话（Claude 根据摘要写，请核对）：【XPENG Robotics/人形】ROVE：用强化学习利用人类干预数据后训练人形操作VLA。
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

> Human interventions provide crucial corrective signals for post-training Vision-Language-Action (VLA) models. However, enabling seamless humanoid interventions is a formidable systems challenge due to complex whole-body kinematics and dexterous-hand control. Consequently, the collected intervention trajectories are often suboptimal, and methods that rely on human interventions as expert supervision can absorb hesitant, inefficient, or even erroneous behaviors. To address both the system and algorithmic challenges, we propose ROVE, a reinforcement learning framework for humanoid VLA post-training with imperfect human interventions. First, ROVE introduces a human-in-the-loop pipeline capable of collecting deployment and intervention data for humanoid manipulation. Second, it utilizes Optimistic Value Estimation (OVE) to prioritize high-value behaviors from mixed-quality trajectories. To further robustify value estimation, we incorporate cross-embodiment human experience videos to provide rich supervision for long-tailed failure and recovery modes. The resulting critic yields informative advantage signals, steering the VLA actor to focus on high-value behaviors rather than indiscriminately imitating all actions. On challenging real-world contact-rich and fine-grained humanoid manipulation tasks, ROVE outperforms experience-learning baselines and consistently improves across multiple rollout-intervention iterations.
