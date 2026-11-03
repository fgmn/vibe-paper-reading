---
id: "2-07"
org: 专题·语义3DGS与具身导航
short: "SplatSearch"
title: "SplatSearch: Instance Image Goal Navigation for Mobile Robots using 3D Gaussian Splatting and Diffusion Models"
aliases: ["SplatSearch"]
date: 2025-11-17
category: "目标/图像目标导航"
venue: ""
affiliation: "University of Toronto"
semantic: false
authors: ["Siddarth Narasimhan", "Matthew Lisondra", "Haitong Wang", "Goldie Nejat"]
arxiv: "2511.12972"
pdf: "[[topics/papers/语义3DGS与具身导航/2-07_2511.12972_SplatSearch.pdf]]"
code: "https://github.com/Quest2GM/SplatSearch"
project: "https://splat-search.github.io/"
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation"]
---

# SplatSearch: Instance Image Goal Navigation for Mobile Robots using 3D Gaussian Splatting and Diffusion Models

> [!info] 论文信息
> arXiv [2511.12972](https://arxiv.org/abs/2511.12972) · v1 2025-11-17 · 最新 v2（2026-07-20）
> 第一作者单位：University of Toronto
> PDF：[[topics/papers/语义3DGS与具身导航/2-07_2511.12972_SplatSearch.pdf|本地 PDF]]
> [代码](https://github.com/Quest2GM/SplatSearch) · [项目页](https://splat-search.github.io/)
> 专题：[[topics/语义3DGS与具身导航#二、高斯地图导航（高斯不带语义）|语义3DGS与具身导航 · 二、高斯地图导航（高斯不带语义）]]
> 清单里的一句话（Claude 根据摘要写，请核对）：在稀疏视角在线3DGS地图上围绕候选物体渲染多视图，并用多视图扩散模型补全缺失区域，再与目标图像匹配完成实例图像导航。

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

> The Instance Image Goal Navigation (IIN) problem requires mobile robots deployed in unknown environments to search for specific objects or people of interest using only a single reference goal image of the target. This problem can be especially challenging when: 1) the reference image is captured from an arbitrary viewpoint, and 2) the robot must operate with sparse-view scene reconstructions. In this paper, we address the IIN problem, by introducing SplatSearch, a novel architecture that leverages sparse-view 3D Gaussian Splatting (3DGS) reconstructions. SplatSearch renders multiple viewpoints around candidate objects using a sparse online 3DGS map and uses a multi-view diffusion model to complete missing regions of the rendered images, enabling robust feature matching against the goal image. A novel frontier exploration policy is introduced which uses visual context from the synthesized viewpoints with semantic context from the goal image to evaluate frontier locations, allowing the robot to prioritize frontiers that are semantically and visually relevant to the goal image. Extensive experiments in photorealistic home and real-world environments validate the higher performance of SplatSearch against current state-of-the-art methods in terms of Success Rate and Success Path Length. An ablation study confirms the design choices of SplatSearch.
