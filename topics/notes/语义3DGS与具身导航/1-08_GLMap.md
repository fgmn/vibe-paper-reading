---
id: "1-08"
org: 专题·语义3DGS与具身导航
short: "GLMap"
title: "Multi-Scale Gaussian-Language Map for Zero-shot Embodied Navigation and Reasoning"
aliases: ["GLMap"]
date: 2026-05-03
category: "目标/图像目标导航"
venue: "CVPR 2026"
affiliation: "Institute of Computing Technology, Chinese Academy of Sciences"
semantic: true
authors: ["Sixian Zhang", "Yiyao Wang", "Xinhang Song", "Keming Zhang", "Zijian Xu", "Shuqiang Jiang"]
arxiv: "2605.01736"
pdf: "[[topics/papers/语义3DGS与具身导航/1-08_2605.01736_GLMap.pdf]]"
code: "https://github.com/sx-zhang/GLMap"
project: ""
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation", "semantic-gaussian"]
---

# Multi-Scale Gaussian-Language Map for Zero-shot Embodied Navigation and Reasoning

> [!info] 论文信息
> arXiv [2605.01736](https://arxiv.org/abs/2605.01736) · v1 2026-05-03
> 发表：CVPR 2026 · 第一作者单位：Institute of Computing Technology, Chinese Academy of Sciences
> PDF：[[topics/papers/语义3DGS与具身导航/1-08_2605.01736_GLMap.pdf|本地 PDF]]
> [代码](https://github.com/sx-zhang/GLMap)
> 专题：[[topics/语义3DGS与具身导航#一、语义高斯直接用于导航|语义3DGS与具身导航 · 一、语义高斯直接用于导航]]
> 清单里的一句话（Claude 根据摘要写，请核对）：提出多尺度高斯-语言地图GLMap，每个语义单元同时存自然语言描述与3D高斯，用解析估计器免梯度增量构建，零样本支持导航与问答。

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

> Understanding the geometric and semantic structure of environments is essential for embodied navigation and reasoning. Existing semantic mapping methods trade off between explicit geometry and multi-scale semantics, and lack a native interface for large models, thus requiring additional training of feature projection for semantic alignment. To this end, we propose the multi-scale Gaussian-Language Map (GLMap), which introduces three key designs: (1) explicit geometry, (2) multi-scale semantics covering both instance and region concepts, and (3) a dual-modality interface where each semantic unit jointly stores a natural language description and a 3D Gaussian representation. The 3D Gaussians enable compact storage and fast rendering of task-relevant images via Gaussian splatting. To enable efficient incremental construction, we further propose a Gaussian Estimator that analytically derives Gaussian parameters from dense point clouds without gradient-based optimization. Experiments on ObjectNav, InstNav, and SQA tasks show that GLMap effectively enhances target navigation and contextual reasoning, while remaining compatible with large-model-based methods in a zero-shot manner. The code is available at this https URL.
