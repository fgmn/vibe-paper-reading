---
id: "1-03"
org: 专题·语义3DGS与具身导航
short: "ATLAS Navigator"
title: "ATLAS Navigator: Active Task-driven LAnguage-embedded Gaussian Splatting"
aliases: ["ATLAS Navigator"]
date: 2025-02-27
category: "物体搜索/定位"
venue: "IEEE T-FR 2026"
affiliation: "University of Pennsylvania"
semantic: true
authors: ["Dexter Ong", "Yuezhan Tao", "Varun Murali", "Igor Spasojevic", "Vijay Kumar", "Pratik Chaudhari"]
arxiv: "2502.20386"
pdf: "[[topics/papers/语义3DGS与具身导航/1-03_2502.20386_ATLAS-Navigator.pdf]]"
code: "https://github.com/grasp-lyrl/atlasnav"
project: "https://ongdexter.github.io/atlasnav"
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation", "semantic-gaussian"]
---

# ATLAS Navigator: Active Task-driven LAnguage-embedded Gaussian Splatting

> [!info] 论文信息
> arXiv [2502.20386](https://arxiv.org/abs/2502.20386) · v1 2025-02-27 · 最新 v2（2026-09-10）
> 发表：IEEE T-FR 2026 · 第一作者单位：University of Pennsylvania
> PDF：[[topics/papers/语义3DGS与具身导航/1-03_2502.20386_ATLAS-Navigator.pdf|本地 PDF]]
> [代码](https://github.com/grasp-lyrl/atlasnav) · [项目页](https://ongdexter.github.io/atlasnav)
> 专题：[[topics/语义3DGS与具身导航#一、语义高斯直接用于导航|语义3DGS与具身导航 · 一、语义高斯直接用于导航]]
> 清单里的一句话（Claude 根据摘要写，请核对）：基于语言嵌入高斯泼溅的分层表示，兼顾稀疏语义规划与稠密几何避障，在未知室内外大场景中执行自然语言任务导航。

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

> We address the challenge of task-oriented navigation in unstructured and unknown environments, where robots must incrementally build and reason on informative metric-semantic maps in real time. Since tasks may require clarification or re-specification, it is necessary for the information in the map to be rich enough to enable generalization across a wide range of tasks. To effectively execute tasks specified in natural language, we propose a hierarchical representation built on language-embedded Gaussian splatting that enables both sparse semantic planning that lends itself to online operation and dense geometric representation for collision-free navigation. We validate the effectiveness of our method through real-world robot experiments on a ground robot equipped with only vision-based sensing. The experiments are conducted in both cluttered indoor and kilometer-scale outdoor environments, covering more than 2 km and 47,000 square meters of area. We achieve a competitive ratio of about 59% relative to the shortest possible path, demonstrating efficient exploration and semantic navigation in challenging real-world environments. Experiment videos and more details can be found on our project page: this https URL.
