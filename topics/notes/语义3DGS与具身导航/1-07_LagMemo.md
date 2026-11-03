---
id: "1-07"
org: 专题·语义3DGS与具身导航
short: "LagMemo"
title: "LagMemo: Language 3D Gaussian Splatting Memory for Multi-modal Open-vocabulary Multi-goal Visual Navigation"
aliases: ["LagMemo"]
date: 2025-10-28
category: "目标/图像目标导航"
venue: ""
affiliation: "Peking University"
semantic: true
authors: ["Haotian Zhou", "Xiaole Wang", "He Li", "Zhuo Qi", "Jinrun Yin", "Haiyu Kong", "Jianghuan Xu", "Huijing Zhao"]
arxiv: "2510.24118"
pdf: "[[topics/papers/语义3DGS与具身导航/1-07_2510.24118_LagMemo.pdf]]"
code: "https://github.com/weekgoodday/LagMemo"
project: "https://weekgoodday.github.io/lagmemo"
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation", "semantic-gaussian"]
---

# LagMemo: Language 3D Gaussian Splatting Memory for Multi-modal Open-vocabulary Multi-goal Visual Navigation

> [!info] 论文信息
> arXiv [2510.24118](https://arxiv.org/abs/2510.24118) · v1 2025-10-28 · 最新 v2（2026-03-08）
> 第一作者单位：Peking University
> PDF：[[topics/papers/语义3DGS与具身导航/1-07_2510.24118_LagMemo.pdf|本地 PDF]]
> [代码](https://github.com/weekgoodday/LagMemo) · [项目页](https://weekgoodday.github.io/lagmemo)
> 专题：[[topics/语义3DGS与具身导航#一、语义高斯直接用于导航|语义3DGS与具身导航 · 一、语义高斯直接用于导航]]
> 清单里的一句话（Claude 根据摘要写，请核对）：一次探索构建语言3DGS记忆，查询记忆预测候选目标并局部验证，实现多模态开放词汇多目标导航。

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

> Navigating to a designated goal using visual information is a fundamental capability for intelligent robots. To address the practical demands of multi-modal, open-vocabulary goal queries and multi-goal visual navigation, we propose LagMemo, a navigation system that leverages a language 3D Gaussian Splatting memory. During a one-time exploration, LagMemo constructs a unified 3D language memory with robust spatial-semantic correlations. With incoming task goals, the system efficiently queries the memory, predicts candidate goal locations, and integrates a local perception-based verification mechanism to dynamically match and validate goals. For fair and rigorous evaluation, we curate GOAT-Core, a high-quality core split distilled from GOAT-Bench. Experimental results show that LagMemo's memory module enables effective multi-modal open-vocabulary localization, and significantly outperforms state-of-the-art methods in multi-goal visual navigation. Project page: this https URL
