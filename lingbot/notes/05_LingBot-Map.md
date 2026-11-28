---
id: "05"
org: 蚂蚁灵波
short: "LingBot-Map"
title: "LingBot-Map: Geometric Context Transformer for Streaming 3D Reconstruction"
aliases: ["LingBot-Map"]
date: 2026-04-15
category: "感知与三维"
source: "蚂蚁灵波主导"
partners: []
authors: ["Lin-Zhuo Chen", "Jian Gao", "Shangzhan Zhang", "Yihang Chen", "Ka Leong Cheng", "Yipengjing Sun", "Liangxiao Hu", "Nan Xue", "Xing Zhu", "Yujun Shen", "Yao Yao", "Yinghao Xu"]
arxiv: "2604.14141"
pdf: "[[lingbot/papers/05_2604.14141_LingBot-Map.pdf]]"
code: "https://github.com/robbyant/lingbot-map"
project: "https://technology.robbyant.com/lingbot-map"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "lingbot"]
---

# LingBot-Map: Geometric Context Transformer for Streaming 3D Reconstruction

> [!info] 论文信息
> arXiv [2604.14141](https://arxiv.org/abs/2604.14141) · v1 2026-04-15 · 最新 v3（2026-09-08）
> PDF：[[lingbot/papers/05_2604.14141_LingBot-Map.pdf|本地 PDF]]
> [github.com](https://github.com/robbyant/lingbot-map) · [technology.robbyant.com](https://technology.robbyant.com/lingbot-map)
> 方向：感知与三维 · 角色：蚂蚁灵波主导
> 汇总：[[lingbot/蚂蚁灵波-论文汇总|蚂蚁灵波论文汇总]]

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

> Streaming 3D reconstruction aims to recover 3D information, such as camera poses and point clouds, from a video stream, which necessitates geometric accuracy, temporal consistency, and computational efficiency. Motivated by the principles of Simultaneous Localization and Mapping (SLAM), we introduce LingBot-Map, a feed-forward 3D foundation model for reconstructing scenes from streaming data, built upon a geometric context transformer (GCT) architecture. A defining aspect of LingBot-Map lies in its carefully designed attention mechanism, which integrates an anchor context, a pose-reference window, and a trajectory memory to address coordinate grounding, dense geometric cues, and long-range drift correction, respectively. This design keeps the streaming state compact while retaining rich geometric context, enabling stable efficient inference at around 20 FPS on 518 x 378 resolution inputs over long sequences exceeding 10,000 frames. Extensive evaluations across a variety of benchmarks demonstrate that our approach achieves superior performance compared to both existing streaming and iterative optimization-based approaches.
