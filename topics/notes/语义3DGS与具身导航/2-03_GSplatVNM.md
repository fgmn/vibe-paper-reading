---
id: "2-03"
org: 专题·语义3DGS与具身导航
short: "GSplatVNM"
title: "GSplatVNM: Point-of-View Synthesis for Visual Navigation Models Using Gaussian Splatting"
aliases: ["GSplatVNM"]
date: 2025-03-07
category: "目标/图像目标导航"
venue: ""
affiliation: ""
semantic: false
authors: ["Kohei Honda", "Takeshi Ishita", "Yasuhiro Yoshimura", "Ryo Yonetani"]
arxiv: "2503.05152"
pdf: "[[topics/papers/语义3DGS与具身导航/2-03_2503.05152_GSplatVNM.pdf]]"
code: ""
project: ""
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation"]
---

# GSplatVNM: Point-of-View Synthesis for Visual Navigation Models Using Gaussian Splatting

> [!info] 论文信息
> arXiv [2503.05152](https://arxiv.org/abs/2503.05152) · v1 2025-03-07 · 最新 v3（2025-07-26）
> PDF：[[topics/papers/语义3DGS与具身导航/2-03_2503.05152_GSplatVNM.pdf|本地 PDF]]
> 专题：[[topics/语义3DGS与具身导航#二、高斯地图导航（高斯不带语义）|语义3DGS与具身导航 · 二、高斯地图导航（高斯不带语义）]]
> 清单里的一句话（Claude 根据摘要写，请核对）：用3DGS合成中间视点补全稀疏图像库，为视觉导航模型提供连续的图像目标序列。

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

> This paper presents a novel approach to image-goal navigation by integrating 3D Gaussian Splatting (3DGS) with Visual Navigation Models (VNMs), a method we refer to as GSplatVNM. VNMs offer a promising paradigm for image-goal navigation by guiding a robot through a sequence of point-of-view images without requiring metrical localization or environment-specific training. However, constructing a dense and traversable sequence of target viewpoints from start to goal remains a central challenge, particularly when the available image database is sparse. To address these challenges, we propose a 3DGS-based viewpoint synthesis framework for VNMs that synthesizes intermediate viewpoints to seamlessly bridge gaps in sparse data while significantly reducing storage overhead. Experimental results in a photorealistic simulator demonstrate that our approach not only enhances navigation efficiency but also exhibits robustness under varying levels of image database sparsity.
