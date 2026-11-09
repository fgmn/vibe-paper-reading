---
id: "35"
org: 智元
short: "FreqFM"
title: "Frequency-Conditioned Flow Matching for Vision-Language-Action Models"
aliases: ["FreqFM"]
date: 2026-09-09
category: "VLA/基础模型"
source: "智元主导"
product: ""
partners: []
authors: ["Haochen Niu", "Shengye Dong", "Hao Liu", "Peiwen Lin", "Wang Chuang"]
arxiv: "2609.10405"
pdf: "[[agibot/papers/35_2609.10405_FreqFM.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# Frequency-Conditioned Flow Matching for Vision-Language-Action Models

> [!info] 论文信息
> arXiv [2609.10405](https://arxiv.org/abs/2609.10405) · v1 2026-09-09
> PDF：[[agibot/papers/35_2609.10405_FreqFM.pdf|本地 PDF]]
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：FreqFM：频率条件流匹配，让 VLA 显式利用动作轨迹的频域异质性。
> 汇总：[[agibot/智元-论文与报告汇总|智元论文与报告汇总]]

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

> Robot actions are temporally correlated trajectories whose frequency components encode motion at different scales with highly non-uniform energy distributions. Yet Flow Matching--based vision-language-action (VLA) models typically generate actions in temporal coordinates, without explicitly modeling or systematically leveraging this frequency heterogeneity. We introduce FreqFM, a frequency-conditioned Flow Matching framework for VLA models. It raises action frequency from an implicit trajectory property to an explicit conditioning dimension that spans the entire generation pipeline. Concretely, in DCT frequency coordinates, FreqFM constructs a spectrum-matched source distribution, adaptively balances the objective across frequencies, and constrains per-frequency guidance residuals using the corresponding reference transport scales. FreqFM integrates into existing Flow Matching action experts without changing the VLA backbone. Across LIBERO, LIBERO-Plus, and VLA-Arena, FreqFM consistently improves performance, including a 9.3-point gain on LIBERO-Plus, and further demonstrates its effectiveness on six real-robot tasks.
