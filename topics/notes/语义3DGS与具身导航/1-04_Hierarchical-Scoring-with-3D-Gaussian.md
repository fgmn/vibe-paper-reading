---
id: "1-04"
org: 专题·语义3DGS与具身导航
short: "Hierarchical Scoring with 3D Gaussian Splatting for Instance Image-Goal Navigation"
title: "Hierarchical Scoring with 3D Gaussian Splatting for Instance Image-Goal Navigation"
aliases: ["Hierarchical Scoring with 3D Gaussian Splatting for Instance Image-Goal Navigation"]
date: 2025-06-09
category: "目标/图像目标导航"
venue: ""
affiliation: "New York University Abu Dhabi"
semantic: true
authors: ["Yijie Deng", "Shuaihang Yuan", "Geeta Chandra Raju Bethala", "Anthony Tzes", "Yu-Shen Liu", "Yi Fang"]
arxiv: "2506.07338"
pdf: "[[topics/papers/语义3DGS与具身导航/1-04_2506.07338_Hierarchical-Scoring-with-3D-Gaussian.pdf]]"
code: ""
project: ""
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation", "semantic-gaussian"]
---

# Hierarchical Scoring with 3D Gaussian Splatting for Instance Image-Goal Navigation

> [!info] 论文信息
> arXiv [2506.07338](https://arxiv.org/abs/2506.07338) · v1 2025-06-09
> 第一作者单位：New York University Abu Dhabi
> PDF：[[topics/papers/语义3DGS与具身导航/1-04_2506.07338_Hierarchical-Scoring-with-3D-Gaussian.pdf|本地 PDF]]
> 专题：[[topics/语义3DGS与具身导航#一、语义高斯直接用于导航|语义3DGS与具身导航 · 一、语义高斯直接用于导航]]
> 清单里的一句话（Claude 根据摘要写，请核对）：针对实例图像目标导航提出层次化评分：先用CLIP相关性场做跨层级语义评分锁定区域，再做局部几何评分精确估计视点。

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

> Instance Image-Goal Navigation (IIN) requires autonomous agents to identify and navigate to a target object or location depicted in a reference image captured from any viewpoint. While recent methods leverage powerful novel view synthesis (NVS) techniques, such as three-dimensional Gaussian splatting (3DGS), they typically rely on randomly sampling multiple viewpoints or trajectories to ensure comprehensive coverage of discriminative visual cues. This approach, however, creates significant redundancy through overlapping image samples and lacks principled view selection, substantially increasing both rendering and comparison overhead. In this paper, we introduce a novel IIN framework with a hierarchical scoring paradigm that estimates optimal viewpoints for target matching. Our approach integrates cross-level semantic scoring, utilizing CLIP-derived relevancy fields to identify regions with high semantic similarity to the target object class, with fine-grained local geometric scoring that performs precise pose estimation within promising regions. Extensive evaluations demonstrate that our method achieves state-of-the-art performance on simulated IIN benchmarks and real-world applicability.
