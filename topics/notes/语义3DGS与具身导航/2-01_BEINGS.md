---
id: "2-01"
org: 专题·语义3DGS与具身导航
short: "BEINGS"
title: "BEINGS: Bayesian Embodied Image-goal Navigation with Gaussian Splatting"
aliases: ["BEINGS"]
date: 2024-09-16
category: "目标/图像目标导航"
venue: ""
affiliation: "Hong Kong University of Science and Technology"
semantic: false
authors: ["Wugang Meng", "Tianfu Wu", "Huan Yin", "Fumin Zhang"]
arxiv: "2409.10216"
pdf: "[[topics/papers/语义3DGS与具身导航/2-01_2409.10216_BEINGS.pdf]]"
code: ""
project: ""
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation"]
---

# BEINGS: Bayesian Embodied Image-goal Navigation with Gaussian Splatting

> [!info] 论文信息
> arXiv [2409.10216](https://arxiv.org/abs/2409.10216) · v1 2024-09-16
> 第一作者单位：Hong Kong University of Science and Technology
> PDF：[[topics/papers/语义3DGS与具身导航/2-01_2409.10216_BEINGS.pdf|本地 PDF]]
> 专题：[[topics/语义3DGS与具身导航#二、高斯地图导航（高斯不带语义）|语义3DGS与具身导航 · 二、高斯地图导航（高斯不带语义）]]
> 清单里的一句话（Claude 根据摘要写，请核对）：把图像目标导航建模为MPC最优控制问题，以3DGS为场景先验预测未来观测，并用贝叶斯更新在线修正策略。

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

> Image-goal navigation enables a robot to reach the location where a target image was captured, using visual cues for guidance. However, current methods either rely heavily on data and computationally expensive learning-based approaches or lack efficiency in complex environments due to insufficient exploration strategies. To address these limitations, we propose Bayesian Embodied Image-goal Navigation Using Gaussian Splatting, a novel method that formulates ImageNav as an optimal control problem within a model predictive control framework. BEINGS leverages 3D Gaussian Splatting as a scene prior to predict future observations, enabling efficient, real-time navigation decisions grounded in the robot's sensory experiences. By integrating Bayesian updates, our method dynamically refines the robot's strategy without requiring extensive prior experience or data. Our algorithm is validated through extensive simulations and physical experiments, showcasing its potential for embodied robot systems in visually complex scenarios.
