---
id: "1-05"
org: 专题·语义3DGS与具身导航
short: "VISTA"
title: "VISTA: Open-Vocabulary, Task-Relevant Robot Exploration with Online Semantic Gaussian Splatting"
aliases: ["VISTA"]
date: 2025-07-01
category: "物体搜索/定位"
venue: ""
affiliation: "Stanford University"
semantic: true
authors: ["Keiko Nagami", "Timothy Chen", "Javier Yu", "Ola Shorinwa", "Maximilian Adang", "Carlyn Dougherty", "Eric Cristofalo", "Mac Schwager"]
arxiv: "2507.01125"
pdf: "[[topics/papers/语义3DGS与具身导航/1-05_2507.01125_VISTA.pdf]]"
code: ""
project: ""
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation", "semantic-gaussian"]
---

# VISTA: Open-Vocabulary, Task-Relevant Robot Exploration with Online Semantic Gaussian Splatting

> [!info] 论文信息
> arXiv [2507.01125](https://arxiv.org/abs/2507.01125) · v1 2025-07-01
> 第一作者单位：Stanford University
> PDF：[[topics/papers/语义3DGS与具身导航/1-05_2507.01125_VISTA.pdf|本地 PDF]]
> 专题：[[topics/语义3DGS与具身导航#一、语义高斯直接用于导航|语义3DGS与具身导航 · 一、语义高斯直接用于导航]]
> 清单里的一句话（Claude 根据摘要写，请核对）：给定开放词汇搜索指令，机器人一边实时构建语义3DGS一边规划兼顾语义相关性与未知区域探索的轨迹来找目标。

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

> We present VISTA (Viewpoint-based Image selection with Semantic Task Awareness), an active exploration method for robots to plan informative trajectories that improve 3D map quality in areas most relevant for task completion. Given an open-vocabulary search instruction (e.g., "find a person"), VISTA enables a robot to explore its environment to search for the object of interest, while simultaneously building a real-time semantic 3D Gaussian Splatting reconstruction of the scene. The robot navigates its environment by planning receding-horizon trajectories that prioritize semantic similarity to the query and exploration of unseen regions of the environment. To evaluate trajectories, VISTA introduces a novel, efficient viewpoint-semantic coverage metric that quantifies both the geometric view diversity and task relevance in the 3D scene. On static datasets, our coverage metric outperforms state-of-the-art baselines, FisherRF and Bayes' Rays, in computation speed and reconstruction quality. In quadrotor hardware experiments, VISTA achieves 6x higher success rates in challenging maps, compared to baseline methods, while matching baseline performance in less challenging maps. Lastly, we show that VISTA is platform-agnostic by deploying it on a quadrotor drone and a Spot quadruped robot. Open-source code will be released upon acceptance of the paper.
