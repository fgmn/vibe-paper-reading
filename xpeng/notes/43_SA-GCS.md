---
id: "43"
org: 小鹏
short: "SA-GCS"
title: "SA-GCS: Semantic-Aware Gaussian Curriculum Scheduling for UAV Vision-Language Navigation"
aliases: ["SA-GCS"]
date: 2025-08-01
category: "其他"
source: "小鹏合作"
product: ""
partners: []
authors: ["Hengxing Cai", "Jinhan Dong", "Yijie Rao", "Jingcheng Deng", "Jingjun Tan", "Qien Chen", "Haidong Wang", "Zhen Wang", "Shiyu Huang", "Agachai Sumalee", "Renxin Zhong"]
arxiv: "2508.00390"
pdf: "[[xpeng/papers/43_2508.00390_SA-GCS.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "vln"]
---

# SA-GCS: Semantic-Aware Gaussian Curriculum Scheduling for UAV Vision-Language Navigation

> [!info] 论文信息
> arXiv [2508.00390](https://arxiv.org/abs/2508.00390) · v1 2025-08-01
> PDF：[[xpeng/papers/43_2508.00390_SA-GCS.pdf|本地 PDF]]
> 方向：其他 · 角色：小鹏合作
> 清单里的一句话（Claude 根据摘要写，请核对）：SA-GCS：语义感知高斯课程调度，用于无人机视觉语言导航的强化学习训练。
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

> Unmanned Aerial Vehicle (UAV) Vision-Language Navigation (VLN) aims to enable agents to accurately localize targets and plan flight paths in complex environments based on natural language instructions, with broad applications in intelligent inspection, disaster rescue, and urban monitoring. Recent progress in Vision-Language Models (VLMs) has provided strong semantic understanding for this task, while reinforcement learning (RL) has emerged as a promising post-training strategy to further improve generalization. However, existing RL methods often suffer from inefficient use of training data, slow convergence, and insufficient consideration of the difficulty variation among training samples, which limits further performance improvement. To address these challenges, we propose Semantic-Aware Gaussian Curriculum Scheduling (SA-GCS), a novel training framework that systematically integrates Curriculum Learning (CL) into RL. SA-GCS employs a Semantic-Aware Difficulty Estimator (SA-DE) to quantify the complexity of training samples and a Gaussian Curriculum Scheduler (GCS) to dynamically adjust the sampling distribution, enabling a smooth progression from easy to challenging tasks. This design significantly improves training efficiency, accelerates convergence, and enhances overall model performance. Extensive experiments on the CityNav benchmark demonstrate that SA-GCS consistently outperforms strong baselines across all metrics, achieves faster and more stable convergence, and generalizes well across models of different scales, highlighting its robustness and scalability. The implementation of our approach is publicly available.
