---
id: "03"
org: 亮源
short: "CleanMDM"
title: "CleanMDM: Clean Motion Diffusion Model for Multimodal Motion Cleanup"
aliases: ["CleanMDM"]
date: 2026-10-04
category: 动作生成
source: 合作
partners: ["北京大学", "阿里巴巴"]
authors: ["Zhe Li", "Shicheng Wang", "Bowen Cai", "Huan Fu"]
arxiv: "2610.05411"
pdf: "[[lightorigins/papers/03_2610.05411_CleanMDM.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "motion-diffusion", "motion-cleanup", "human-motion"]
---

# CleanMDM: Clean Motion Diffusion Model for Multimodal Motion Cleanup

> [!info] 论文信息
> arXiv [2610.05411](https://arxiv.org/abs/2610.05411) · v1 2026-10-04
> PDF：[[lightorigins/papers/03_2610.05411_CleanMDM.pdf|本地 PDF]]
> 合作单位：北京大学、阿里巴巴

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

> Motion capture data is rarely directly usable, as they typically exhibit missing segments, jitter, drift and contact artifacts. Traditionally, corrupted motions are cleaned by animators through the manual identification of keyframes from noisy motion, subsequent keyframe correction, and interpolation between corrected keyframes to reconstruct coherent motion. While the rise of generative motion models has made automatic cleanup feasible, most approaches operate as black box denoisers with limited controllability, making it difficult to preserve reliable segments or enforce specific user intents. Inspired by animation workflows, we present CleanMDM, a unified multimodal motion cleanup framework that formulates cleanup as masked conditional generation with plug-and-play conditions. This single model supports arbitrary combinations of noisy 3D motion, sparse 2D keyframes, sparse 3D keyframes, and text. This design enables both automatic cleanup without additional user annotation and controllable cleanup under multimodal guidance. To further improve motion realism, we incorporate the Latent Motion Quality Discriminator (LMQD) to better match kinematic distributions and reduce skating, jitter, and interpenetration artifacts, and we apply Mesh-Aware Contact Projection as a test-time optimization step to enhance contact and physical consistency. Experiments across multiple datasets demonstrate that CleanMDM consistently outperforms prior cleanup and generation baselines, and that low cost conditions (text and 2D keyframes) provide reliable controllability gains in multimodal cleanup scenarios.
