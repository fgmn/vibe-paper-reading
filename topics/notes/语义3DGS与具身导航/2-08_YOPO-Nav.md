---
id: "2-08"
org: 专题·语义3DGS与具身导航
short: "YOPO-Nav"
title: "YOPO-Nav: Visual Navigation using 3DGS Graphs from One-Pass Videos"
aliases: ["YOPO-Nav"]
date: 2025-12-10
category: "目标/图像目标导航"
venue: ""
affiliation: ""
semantic: false
authors: ["Ryan Meegan", "Adam D'Souza", "Bryan Bo Cao", "Shubham Jain", "Kristin Dana"]
arxiv: "2512.09903"
pdf: "[[topics/papers/语义3DGS与具身导航/2-08_2512.09903_YOPO-Nav.pdf]]"
code: ""
project: ""
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation"]
---

# YOPO-Nav: Visual Navigation using 3DGS Graphs from One-Pass Videos

> [!info] 论文信息
> arXiv [2512.09903](https://arxiv.org/abs/2512.09903) · v1 2025-12-10
> PDF：[[topics/papers/语义3DGS与具身导航/2-08_2512.09903_YOPO-Nav.pdf|本地 PDF]]
> 专题：[[topics/语义3DGS与具身导航#二、高斯地图导航（高斯不带语义）|语义3DGS与具身导航 · 二、高斯地图导航（高斯不带语义）]]
> 清单里的一句话（Claude 根据摘要写，请核对）：把探索视频编码为互连的局部3DGS图，先VPR粗定位再用局部3DGS精化位姿，实现图像目标导航，并发布YOPO-Campus数据集。

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

> Visual navigation has emerged as a practical alternative to traditional robotic navigation pipelines that rely on detailed mapping and path planning. However, constructing and maintaining 3D maps is often computationally expensive and memory-intensive. We address the problem of visual navigation when exploration videos of a large environment are available. The videos serve as a visual reference, allowing a robot to retrace the explored trajectories without relying on metric maps. Our proposed method, YOPO-Nav (You Only Pass Once), encodes an environment into a compact spatial representation composed of interconnected local 3D Gaussian Splatting (3DGS) models. During navigation, the framework aligns the robot's current visual observation with this representation and predicts actions that guide it back toward the demonstrated trajectory. YOPO-Nav employs a hierarchical design: a visual place recognition (VPR) module provides coarse localization, while the local 3DGS models refine the goal and intermediate poses to generate control actions. To evaluate our approach, we introduce the YOPO-Campus dataset, comprising 4 hours of egocentric video and robot controller inputs from over 6 km of human-teleoperated robot trajectories. We benchmark recent visual navigation methods on trajectories from YOPO-Campus using a Clearpath Jackal robot. Experimental results show YOPO-Nav provides excellent performance in image-goal navigation for real-world scenes on a physical robot. The dataset and code will be made publicly available for visual navigation and scene representation research.
