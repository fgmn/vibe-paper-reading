---
id: "1-10"
org: 专题·语义3DGS与具身导航
short: "Uncertainty-Aware Gaussian Map for Vision-Language Navigation"
title: "Uncertainty-Aware Gaussian Map for Vision-Language Navigation"
aliases: ["Uncertainty-Aware Gaussian Map for Vision-Language Navigation"]
date: 2026-05-26
category: "视觉语言导航"
venue: ""
affiliation: "Zhejiang University"
semantic: true
authors: ["Jianzhe Gao", "Rui Liu", "Yuxuan Xu", "Tongtong Cao", "Yingxue Zhang", "Zhanguang Zhang", "Sida Peng", "Yi Yang", "Wenguan Wang"]
arxiv: "2605.26503"
pdf: "[[topics/papers/语义3DGS与具身导航/1-10_2605.26503_Uncertainty-Aware-Gaussian-Map-for.pdf]]"
code: "https://github.com/Gaozzzz/Uncertainty-Aware-VLN"
project: ""
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation", "semantic-gaussian"]
---

# Uncertainty-Aware Gaussian Map for Vision-Language Navigation

> [!info] 论文信息
> arXiv [2605.26503](https://arxiv.org/abs/2605.26503) · v1 2026-05-26
> 第一作者单位：Zhejiang University
> PDF：[[topics/papers/语义3DGS与具身导航/1-10_2605.26503_Uncertainty-Aware-Gaussian-Map-for.pdf|本地 PDF]]
> [代码](https://github.com/Gaozzzz/Uncertainty-Aware-VLN)
> 专题：[[topics/语义3DGS与具身导航#一、语义高斯直接用于导航|语义3DGS与具身导航 · 一、语义高斯直接用于导航]]
> 清单里的一句话（Claude 根据摘要写，请核对）：构建语义高斯地图并显式估计几何、语义和外观三类感知不确定性，扩展为3D价值地图来支持更可靠的VLN决策。

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

> Vision-Language Navigation (VLN) requires an agent to navigate 3D environments following natural language instructions. During navigation, existing agents commonly encounter perceptual uncertainty, such as insufficient evidence for reliable grounding or ambiguity in interpreting spatial cues, yet they typically ignore such information when predicting actions. In this work, we explicitly model three forms of perceptual uncertainty (i.e., geometric, semantic, and appearance uncertainty) and integrate them into the agent's observation space to enable informed decision-making. Concretely, our agent first constructs a Semantic Gaussian Map (SGM), composed of differentiable 3D Gaussian primitives initialized from panoramic observations, that encodes both the geometric structure and semantic content of the environment. On top of SGM, geometric uncertainty is estimated through variational perturbations of Gaussian position and scale to assess structural reliability; semantic uncertainty is captured by perturbing Gaussian semantic attributes to reveal ambiguous interpretations; and appearance uncertainty is characterized by Fisher Information, which measures the sensitivity of rendered observations to Gaussian-level variations. These uncertainties are incorporated into SGM, extending it into a unified 3D Value Map, which grounds them as affordances and constraints that support reliable navigation. Comprehensive evaluations across multiple VLN benchmarks show the effectiveness of our agent.
