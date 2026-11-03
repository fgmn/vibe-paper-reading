---
id: "2-14"
org: 专题·语义3DGS与具身导航
short: "GS-PRM"
title: "GS-PRM: Gaussian Visual Roadmap for Image-Goal Navigation"
aliases: ["GS-PRM"]
date: 2026-10-14
category: "目标/图像目标导航"
venue: ""
affiliation: ""
semantic: false
authors: ["Ashraf Siddique", "Kyung Min Han", "Young J. Kim"]
arxiv: "2610.19541"
pdf: "[[topics/papers/语义3DGS与具身导航/2-14_2610.19541_GS-PRM.pdf]]"
code: ""
project: ""
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation"]
---

# GS-PRM: Gaussian Visual Roadmap for Image-Goal Navigation

> [!info] 论文信息
> arXiv [2610.19541](https://arxiv.org/abs/2610.19541) · v1 2026-10-14 · 最新 v2（2026-10-15）
> PDF：[[topics/papers/语义3DGS与具身导航/2-14_2610.19541_GS-PRM.pdf|本地 PDF]]
> 专题：[[topics/语义3DGS与具身导航#二、高斯地图导航（高斯不带语义）|语义3DGS与具身导航 · 二、高斯地图导航（高斯不带语义）]]
> 清单里的一句话（Claude 根据摘要写，请核对）：提出高斯视觉路标图GS-PRM，直接通过3DGS渲染构建路标点、局部连接和视觉参考，不需占据栅格或SDF，用于长程图像目标导航。

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

> Image-goal navigation requires a global planner that connects visually specified endpoints while providing observations that a local policy can follow. Three-dimensional Gaussian Splatting (3DGS) provides map-registered RGB, opacity, and depth renderings, but does not explicitly encode navigable topology. We introduce GS-PRM, a Gaussian visual roadmap whose milestones, local connections, and visual references are constructed directly through 3DGS rendering without deriving an occupancy grid or signed distance field. We define render-based collision-free (RC-free) configurations and paths. Panoramic depth supplies conservative clearance for milestone validation and adaptive coverage, while edge-aligned orthographic rendering tests the robot's swept volume. We establish conditional soundness and sufficient conditions for deterministic query completeness and probabilistic construction completeness of GS-PRM. To validate the performance of GS-PRM, we conduct experiments in both simulated and real-world environments, demonstrating long-horizon navigation using goal-conditioned policies guided by GS-PRM. Compared with a state-of-the-art 3DGS-based navigation system, our GS-PRM-based navigation system achieves up to a twice higher average success rate and reduces travel time by up to 57.2% when both systems complete the navigation task.
