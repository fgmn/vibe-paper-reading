---
id: "1-09"
org: 专题·语义3DGS与具身导航
short: "3D Gaussian Map with Open-Set Semantic Grouping for Vision-Language Navigation"
title: "3D Gaussian Map with Open-Set Semantic Grouping for Vision-Language Navigation"
aliases: ["3D Gaussian Map with Open-Set Semantic Grouping for Vision-Language Navigation"]
date: 2026-05-26
category: "视觉语言导航"
venue: ""
affiliation: "Zhejiang University"
semantic: true
authors: ["Jianzhe Gao", "Rui Liu", "Wenguan Wang"]
arxiv: "2605.26500"
pdf: "[[topics/papers/语义3DGS与具身导航/1-09_2605.26500_3D-Gaussian-Map-with-Open-Set-Semantic.pdf]]"
code: "https://github.com/Gaozzzz/3D-Gaussian-Map-VLN"
project: ""
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation", "semantic-gaussian"]
---

# 3D Gaussian Map with Open-Set Semantic Grouping for Vision-Language Navigation

> [!info] 论文信息
> arXiv [2605.26500](https://arxiv.org/abs/2605.26500) · v1 2026-05-26
> 第一作者单位：Zhejiang University
> PDF：[[topics/papers/语义3DGS与具身导航/1-09_2605.26500_3D-Gaussian-Map-with-Open-Set-Semantic.pdf|本地 PDF]]
> [代码](https://github.com/Gaozzzz/3D-Gaussian-Map-VLN)
> 专题：[[topics/语义3DGS与具身导航#一、语义高斯直接用于导航|语义3DGS与具身导航 · 一、语义高斯直接用于导航]]
> 清单里的一句话（Claude 根据摘要写，请核对）：在线从伪激光点云初始化3D高斯构建自我中心场景地图，并通过开放集语义分组把高斯归入实例/背景类别，结合多层级动作预测做VLN。

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

> Vision-language navigation (VLN) requires an agent to traverse complex 3D environments based on natural language instructions, necessitating a thorough scene understanding. While existing works equip agents with various scene representations to enhance spatial awareness, they often neglect the complex 3D geometry and rich semantics in VLN scenarios, limiting the ability to generalize across diverse and unseen environments. To address these challenges, this work proposes a 3D Gaussian Map that represents the environment as a set of differentiable 3D Gaussians and accordingly develops a navigation strategy for VLN. Specifically, Egocentric Scene Map is constructed online by initializing 3D Gaussians from sparse pseudo-lidar point clouds, providing informative geometric priors for scene understanding. Each Gaussian primitive is further enriched through Open-Set Semantic Grouping operation, which groups 3D Gaussians based on their membership in object instances or stuff categories within the open world, resulting in a unified 3D Gaussian Map. Building on this map, Multi-Level Action Prediction strategy, which combines spatial-semantic cues at multiple granularities, is designed to assist agents in decision-making. Extensive experiments conducted on three public benchmarks (i.e., R2R, R4R, and REVERIE) validate the effectiveness of our method.
