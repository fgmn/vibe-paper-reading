---
id: "2-04"
org: 专题·语义3DGS与具身导航
short: "WoMAP"
title: "WoMAP: World Models For Embodied Open-Vocabulary Object Localization"
aliases: ["WoMAP"]
date: 2025-06-02
category: "物体搜索/定位"
venue: ""
affiliation: "Princeton University"
semantic: false
authors: ["Tenny Yin", "Zhiting Mei", "Tao Sun", "Lihan Zha", "Emily Zhou", "Jeremy Bao", "Miyu Yamane", "Ola Shorinwa", "Anirudha Majumdar"]
arxiv: "2506.01600"
pdf: "[[topics/papers/语义3DGS与具身导航/2-04_2506.01600_WoMAP.pdf]]"
code: ""
project: "https://robot-womap.github.io"
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation"]
---

# WoMAP: World Models For Embodied Open-Vocabulary Object Localization

> [!info] 论文信息
> arXiv [2506.01600](https://arxiv.org/abs/2506.01600) · v1 2025-06-02
> 第一作者单位：Princeton University
> PDF：[[topics/papers/语义3DGS与具身导航/2-04_2506.01600_WoMAP.pdf|本地 PDF]]
> [项目页](https://robot-womap.github.io)
> 专题：[[topics/语义3DGS与具身导航#二、高斯地图导航（高斯不带语义）|语义3DGS与具身导航 · 二、高斯地图导航（高斯不带语义）]]
> 清单里的一句话（Claude 根据摘要写，请核对）：用GS重建的real-to-sim-to-real管线生成数据、检测器蒸馏奖励和潜空间世界模型，训练开放词汇主动物体定位策略。

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

> Language-instructed active object localization is a critical challenge for robots, requiring efficient exploration of partially observable environments. However, state-of-the-art approaches either struggle to generalize beyond demonstration datasets (e.g., imitation learning methods) or fail to generate physically grounded actions (e.g., VLMs). To address these limitations, we introduce WoMAP (World Models for Active Perception): a recipe for training open-vocabulary object localization policies that: (i) uses a Gaussian Splatting-based real-to-sim-to-real pipeline for scalable data generation without the need for expert demonstrations, (ii) distills dense rewards signals from open-vocabulary object detectors, and (iii) leverages a latent world model for dynamics and rewards prediction to ground high-level action proposals at inference time. Rigorous simulation and hardware experiments demonstrate WoMAP's superior performance in a broad range of zero-shot object localization tasks, with more than 9x and 2x higher success rates compared to VLM and diffusion policy baselines, respectively. Further, we show that WoMAP achieves strong generalization and sim-to-real transfer on a TidyBot.
