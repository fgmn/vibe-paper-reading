---
id: "33"
org: 英伟达
short: "DreamDojo"
title: "DreamDojo: A Generalist Robot World Model from Large-Scale Human Videos"
aliases: ["DreamDojo"]
date: 2026-02-06
category: "合成数据与世界模型"
source: "英伟达主导"
partners: []
authors: ["Shenyuan Gao", "William Liang", "Kaiyuan Zheng", "Ayaan Malik", "Seonghyeon Ye", "Sihyun Yu", "Wei-Cheng Tseng", "Yuzhu Dong", "Kaichun Mo", "Chen-Hsuan Lin", "Qianli Ma", "Seungjun Nah", "Loic Magne", "Jiannan Xiang", "Yuqi Xie", "Ruijie Zheng", "Dantong Niu", "You Liang Tan", "K.R. Zentner", "George Kurian", "Suneel Indupuru", "Pooya Jannaty", "Jinwei Gu", "Jun Zhang", "Jitendra Malik", "Pieter Abbeel", "Ming-Yu Liu", "Yuke Zhu", "Joel Jang", "Linxi \"Jim\" Fan"]
arxiv: "2602.06949"
pdf: "[[nvidia/papers/33_2602.06949_DreamDojo.pdf]]"
code: ""
project: "https://dreamdojo-world.github.io/"
huggingface: ["nvidia/DreamDojo"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia", "cosmos"]
---

# DreamDojo: A Generalist Robot World Model from Large-Scale Human Videos

> [!info] 论文信息
> arXiv [2602.06949](https://arxiv.org/abs/2602.06949) · v1 2026-02-06
> PDF：[[nvidia/papers/33_2602.06949_DreamDojo.pdf|本地 PDF]]
> [项目页](https://dreamdojo-world.github.io/)
> 系列：物理AI · 合成数据与世界模型 · 角色：英伟达主导 · 用到 Cosmos
> 清单里的一句话（Claude 根据摘要写，请核对）：DreamDojo：在 Cosmos-Predict2.5 上用大规模人类视频预训练的通用机器人世界模型，支持动作条件模拟与策略评估。
> 汇总：[[nvidia/英伟达-论文与报告汇总|英伟达论文与报告汇总]]

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

> Being able to simulate the outcomes of actions in varied environments will revolutionize the development of generalist agents at scale. However, modeling these world dynamics, especially for dexterous robotics tasks, poses significant challenges due to limited data coverage and scarce action labels. As an endeavor towards this end, we introduce DreamDojo, a foundation world model that learns diverse interactions and dexterous controls from 44k hours of egocentric human videos. Our data mixture represents the largest video dataset to date for world model pretraining, spanning a wide range of daily scenarios with diverse objects and skills. To address the scarcity of action labels, we introduce continuous latent actions as unified proxy actions, enhancing interaction knowledge transfer from unlabeled videos. After post-training on small-scale target robot data, DreamDojo demonstrates a strong understanding of physics and precise action controllability. We also devise a distillation pipeline that accelerates DreamDojo to a real-time speed of 10.81 FPS and further improves context consistency. Our work enables several important applications based on generative world models, including live teleoperation, policy evaluation, and model-based planning. Systematic evaluation on multiple challenging out-of-distribution (OOD) benchmarks verifies the significance of our method for simulating open-world, contact-rich tasks, paving the way for general-purpose robot world models.
