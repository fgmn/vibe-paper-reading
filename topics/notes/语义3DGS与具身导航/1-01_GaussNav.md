---
id: "1-01"
org: 专题·语义3DGS与具身导航
short: "GaussNav"
title: "GaussNav: Gaussian Splatting for Visual Navigation"
aliases: ["GaussNav"]
date: 2024-03-18
category: "目标/图像目标导航"
venue: "TPAMI"
affiliation: "University of Science and Technology of China"
semantic: true
authors: ["Xiaohan Lei", "Min Wang", "Wengang Zhou", "Houqiang Li"]
arxiv: "2403.11625"
pdf: "[[topics/papers/语义3DGS与具身导航/1-01_2403.11625_GaussNav.pdf]]"
code: "https://github.com/XiaohanLei/GaussNav"
project: "https://xiaohanlei.github.io/projects/GaussNav/"
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation", "semantic-gaussian"]
---

# GaussNav: Gaussian Splatting for Visual Navigation

> [!info] 论文信息
> arXiv [2403.11625](https://arxiv.org/abs/2403.11625) · v1 2024-03-18 · 最新 v3（2025-02-04）
> 发表：TPAMI · 第一作者单位：University of Science and Technology of China
> PDF：[[topics/papers/语义3DGS与具身导航/1-01_2403.11625_GaussNav.pdf|本地 PDF]]
> [代码](https://github.com/XiaohanLei/GaussNav) · [项目页](https://xiaohanlei.github.io/projects/GaussNav/)
> 专题：[[topics/语义3DGS与具身导航#一、语义高斯直接用于导航|语义3DGS与具身导航 · 一、语义高斯直接用于导航]]
> 清单里的一句话（Claude 根据摘要写，请核对）：面向实例图像目标导航，先探索建图再构建按语义标签聚类成实例的语义高斯，渲染候选物体视图与目标图像匹配后规划到达。

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

> In embodied vision, Instance ImageGoal Navigation (IIN) requires an agent to locate a specific object depicted in a goal image within an unexplored environment. The primary challenge of IIN arises from the need to recognize the target object across varying viewpoints while ignoring potential distractors. Existing map-based navigation methods typically use Bird's Eye View (BEV) maps, which lack detailed texture representation of a scene. Consequently, while BEV maps are effective for semantic-level visual navigation, they are struggling for instance-level tasks. To this end, we propose a new framework for IIN, Gaussian Splatting for Visual Navigation (GaussNav), which constructs a novel map representation based on 3D Gaussian Splatting (3DGS). The GaussNav framework enables the agent to memorize both the geometry and semantic information of the scene, as well as retain the textural features of objects. By matching renderings of similar objects with the target, the agent can accurately identify, ground, and navigate to the specified object. Our GaussNav framework demonstrates a significant performance improvement, with Success weighted by Path Length (SPL) increasing from 0.347 to 0.578 on the challenging Habitat-Matterport 3D (HM3D) dataset. The source code is publicly available at the link: this https URL.
