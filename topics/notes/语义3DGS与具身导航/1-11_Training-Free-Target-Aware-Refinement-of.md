---
id: "1-11"
org: 专题·语义3DGS与具身导航
short: "Training-Free Target-Aware Refinement of 3D Gaussian Language Map"
title: "Training-Free Target-Aware Refinement of 3D Gaussian Language Map"
aliases: ["Training-Free Target-Aware Refinement of 3D Gaussian Language Map"]
date: 2026-10-15
category: "物体搜索/定位"
venue: ""
affiliation: "Sungkyunkwan University"
semantic: true
authors: ["Sibaek Lee", "Kyeongsu Kang", "Seongbo Ha", "Yewon Jeon", "Joonyeol Choi", "Daegeol Ko", "Jaehyuk Hur", "Taemin Choi", "Minsu Kim", "Hyungjoo Ahn", "Wonsok Yoo", "Hyeonwoo Yu"]
arxiv: "2610.21619"
pdf: "[[topics/papers/语义3DGS与具身导航/1-11_2610.21619_Training-Free-Target-Aware-Refinement-of.pdf]]"
code: "https://github.com/Lab-of-AI-and-Robotics/target-aware-langmap"
project: "https://lab-of-ai-and-robotics.github.io/target-aware-langmap/"
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation", "semantic-gaussian"]
---

# Training-Free Target-Aware Refinement of 3D Gaussian Language Map

> [!info] 论文信息
> arXiv [2610.21619](https://arxiv.org/abs/2610.21619) · v1 2026-10-15
> 第一作者单位：Sungkyunkwan University
> PDF：[[topics/papers/语义3DGS与具身导航/1-11_2610.21619_Training-Free-Target-Aware-Refinement-of.pdf|本地 PDF]]
> [代码](https://github.com/Lab-of-AI-and-Robotics/target-aware-langmap) · [项目页](https://lab-of-ai-and-robotics.github.io/target-aware-langmap/)
> 专题：[[topics/语义3DGS与具身导航#一、语义高斯直接用于导航|语义3DGS与具身导航 · 一、语义高斯直接用于导航]]
> 清单里的一句话（Claude 根据摘要写，请核对）：对已蒸馏的3D高斯语言地图做免训练的目标感知精修，以闭式系数把目标文本嵌入注入目标区域，提升语言目标定位且保留开放词汇查询。

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

> Distilling vision-language features into 3D Gaussian Splatting yields a language map that can be queried with arbitrary text. In deployment, however, a small set of user-specified targets must be reliably located, which current distilled maps often miss, while open-vocabulary queryability for other words must remain intact. We propose a training-free, target-aware refinement of an already-distilled language map. Guided by a text-promptable segmenter, the visual embedding inside each detected target region is blended with the target text embedding, a convex combination whose coefficient sets the amount of injected prior, while non-target regions are left untouched. Injecting too much overwrites appearance cues and general queryability, so we seek, for each target, the smallest coefficient that still lets it win, and we obtain every coefficient in closed form, leaving no hyperparameters to tune. We further identify a failure mode of injection in language-goal localization. Text embeddings share a common component, and injecting them makes the standard cosine read-out query-agnostic, which a centering step in the read-out removes. Across three benchmarks, the refinement consistently improves open-vocabulary segmentation, roughly doubling the base mIoU on Replica, and localizes language goals more reliably than the base map. It also transfers as a plug-in to off-the-shelf field-based and object-level language maps and supports a real-world demonstration in which a legged robot navigates to natural-language goals. Project page and code: this https URL
