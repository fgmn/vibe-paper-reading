---
id: "10"
org: 英伟达
short: "Sim-to-Real Reinforcement Learning for Vision-Based Dexterous Manipulation on Humanoids"
title: "Sim-to-Real Reinforcement Learning for Vision-Based Dexterous Manipulation on Humanoids"
aliases: ["Sim-to-Real Reinforcement Learning for Vision-Based Dexterous Manipulation on Humanoids"]
date: 2025-02-27
category: "人形全身控制"
source: "英伟达合作"
partners: []
authors: ["Toru Lin", "Kartik Sachdev", "Linxi Fan", "Jitendra Malik", "Yuke Zhu"]
arxiv: "2502.20396"
pdf: "[[nvidia/papers/10_2502.20396_Sim-to-Real-Reinforcement-Learning-for.pdf]]"
code: ""
project: "https://toruowo.github.io/recipe"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# Sim-to-Real Reinforcement Learning for Vision-Based Dexterous Manipulation on Humanoids

> [!info] 论文信息
> arXiv [2502.20396](https://arxiv.org/abs/2502.20396) · v1 2025-02-27 · 最新 v2（2025-09-01） · 发表：CoRL 2025
> PDF：[[nvidia/papers/10_2502.20396_Sim-to-Real-Reinforcement-Learning-for.pdf|本地 PDF]]
> [项目页](https://toruowo.github.io/recipe)
> 系列：物理AI · 人形全身控制 · 角色：英伟达合作
> 清单里的一句话（Claude 根据摘要写，请核对）：面向人形灵巧手的视觉 sim-to-real 强化学习配方：自动 real-to-sim 调参、奖励设计与分治蒸馏，完成抓取、搬箱与双手交接。
> 汇总：[[nvidia/英伟达-论文与报告汇总|英伟达论文与报告汇总]]

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

> Learning generalizable robot manipulation policies, especially for complex multi-fingered humanoids, remains a significant challenge. Existing approaches primarily rely on extensive data collection and imitation learning, which are expensive, labor-intensive, and difficult to scale. Sim-to-real reinforcement learning (RL) offers a promising alternative, but has mostly succeeded in simpler state-based or single-hand setups. How to effectively extend this to vision-based, contact-rich bimanual manipulation tasks remains an open question. In this paper, we introduce a practical sim-to-real RL recipe that trains a humanoid robot to perform three challenging dexterous manipulation tasks: grasp-and-reach, box lift and bimanual handover. Our method features an automated real-to-sim tuning module, a generalized reward formulation based on contact and object goals, a divide-and-conquer policy distillation framework, and a hybrid object representation strategy with modality-specific augmentation. We demonstrate high success rates on unseen objects and robust, adaptive policy behaviors -- highlighting that vision-based dexterous manipulation via sim-to-real RL is not only viable, but also scalable and broadly applicable to real-world humanoid manipulation tasks.
