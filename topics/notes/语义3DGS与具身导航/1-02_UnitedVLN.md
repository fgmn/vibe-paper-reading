---
id: "1-02"
org: 专题·语义3DGS与具身导航
short: "UnitedVLN"
title: "UnitedVLN: Generalizable Gaussian Splatting for Continuous Vision-Language Navigation"
aliases: ["UnitedVLN"]
date: 2024-11-25
category: "视觉语言导航"
venue: ""
affiliation: "Nanjing University of Science and Technology"
semantic: true
authors: ["Guangzhao Dai", "Jian Zhao", "Yuantao Chen", "Yusen Qin", "Hao Zhao", "Guosen Xie", "Yazhou Yao", "Xiangbo Shu", "Xuelong Li"]
arxiv: "2411.16053"
pdf: "[[topics/papers/语义3DGS与具身导航/1-02_2411.16053_UnitedVLN.pdf]]"
code: ""
project: ""
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation", "semantic-gaussian"]
---

# UnitedVLN: Generalizable Gaussian Splatting for Continuous Vision-Language Navigation

> [!info] 论文信息
> arXiv [2411.16053](https://arxiv.org/abs/2411.16053) · v1 2024-11-25 · 最新 v2（2025-03-16）
> 第一作者单位：Nanjing University of Science and Technology
> PDF：[[topics/papers/语义3DGS与具身导航/1-02_2411.16053_UnitedVLN.pdf|本地 PDF]]
> 专题：[[topics/语义3DGS与具身导航#一、语义高斯直接用于导航|语义3DGS与具身导航 · 一、语义高斯直接用于导航]]
> 清单里的一句话（Claude 根据摘要写，请核对）：提出可泛化3DGS预训练范式UnitedVLN，联合渲染360°高保真图像与语义特征来“想象”未来环境，提升连续环境VLN。

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

> Vision-and-Language Navigation (VLN), where an agent follows instructions to reach a target destination, has recently seen significant advancements. In contrast to navigation in discrete environments with predefined trajectories, VLN in Continuous Environments (VLN-CE) presents greater challenges, as the agent is free to navigate any unobstructed location and is more vulnerable to visual occlusions or blind spots. Recent approaches have attempted to address this by imagining future environments, either through predicted future visual images or semantic features, rather than relying solely on current observations. However, these RGB-based and feature-based methods lack intuitive appearance-level information or high-level semantic complexity crucial for effective navigation. To overcome these limitations, we introduce a novel, generalizable 3DGS-based pre-training paradigm, called UnitedVLN, which enables agents to better explore future environments by unitedly rendering high-fidelity 360 visual images and semantic features. UnitedVLN employs two key schemes: search-then-query sampling and separate-then-united rendering, which facilitate efficient exploitation of neural primitives, helping to integrate both appearance and semantic information for more robust navigation. Extensive experiments demonstrate that UnitedVLN outperforms state-of-the-art methods on existing VLN-CE benchmarks.
