---
id: "17"
org: 小鹏
short: "X-Foresight"
title: "X-Foresight: A Joint Vision-Action Causal Forecasting Network via Predictive World Modeling"
aliases: ["X-Foresight"]
date: 2026-05-24
category: "世界模型"
source: "小鹏主导"
product: ""
partners: []
authors: ["Baolu Li", "Jingyu Qian", "Rui Guo", "Yilun Chen", "Hanpeng Liu", "Yuan Lin", "Junhong Zhou", "Ruixin Liu", "Liu Yang", "Yutong Zheng", "Zhenli Zhang", "Sean Li", "Chaoda Zheng", "Boyang Wang", "Tenglong (Victor)Gu", "Zhuangzhuang Ding", "Pengkun Zheng", "Yu Zhang", "Xianming Liu"]
arxiv: "2605.24892"
pdf: "[[xpeng/papers/17_2605.24892_X-Foresight.pdf]]"
code: ""
project: "https://x-foresight-1.github.io"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng"]
---

# X-Foresight: A Joint Vision-Action Causal Forecasting Network via Predictive World Modeling

> [!info] 论文信息
> arXiv [2605.24892](https://arxiv.org/abs/2605.24892) · v1 2026-05-24 · 最新 v4（2026-07-07）
> PDF：[[xpeng/papers/17_2605.24892_X-Foresight.pdf|本地 PDF]]
> [项目页](https://x-foresight-1.github.io)
> 方向：世界模型 · 角色：小鹏主导
> 清单里的一句话（Claude 根据摘要写，请核对）：X-Foresight：通过预测式世界建模实现视觉-动作联合因果预测，增强VLA规划。
> 汇总：[[xpeng/小鹏-论文与报告汇总|小鹏论文与报告汇总]]

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

> Physical world knowledge resides mainly in videos. Equipping Vision-Language-Action (VLA) models with such knowledge is fundamental for safe and generalizable planning. Predictive world modeling enables VLA to internalize physical dynamics and long-term causality by predicting future video from past observations. However, naive next-frame prediction faces two challenges: 1) unlike semantically distinct text tokens, video tokens are low-entropy and redundant, causing prediction to degenerate into trivial extrapolation. 2) world modeling poses a temporal dilemma: dense prediction captures instantaneous dynamics, but cannot efficiently model long-horizon causality. To learn world knowledge effectively, we introduce X-Foresight, a predictive world model integrated directly into the VLA architecture to jointly learn world modeling and real-time action control. At its core lies a long-horizon chunk-wise auto-regressive strategy that addresses both challenges: by predicting semantically distant chunks rather than adjacent frames, it escapes trivial extrapolation, while preserving dense intra-chunk frames for instantaneous dynamics and sparse inter-chunk transitions for long-term causality. A curriculum learning schedule progressively extends prediction horizons and stabilizes long-horizon training. To capture long-term causality effectively, we present temporal importance sampling, which concentrates supervision on safety-critical chunks identified by ego-motion and behavioral signals. We further delegate photorealistic synthesis to a diffusion-based multi-view renderer, improving photorealistic appearance. Comprehensive experiments demonstrate that X-Foresight significantly outperforms VLA baselines in planning performance while maintaining strong generative fidelity, establishing a robust paradigm for world-knowledge-driven autonomous systems.
