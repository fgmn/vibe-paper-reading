---
id: "07"
org: 英伟达
short: "DexMimicGen"
title: "DexMimicGen: Automated Data Generation for Bimanual Dexterous Manipulation via Imitation Learning"
aliases: ["DexMimicGen"]
date: 2024-10-31
category: "合成数据与世界模型"
source: "英伟达合作"
partners: []
authors: ["Zhenyu Jiang", "Yuqi Xie", "Kevin Lin", "Zhenjia Xu", "Weikang Wan", "Ajay Mandlekar", "Linxi Fan", "Yuke Zhu"]
arxiv: "2410.24185"
pdf: "[[nvidia/papers/07_2410.24185_DexMimicGen.pdf]]"
code: ""
project: "https://dexmimicgen.github.io/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# DexMimicGen: Automated Data Generation for Bimanual Dexterous Manipulation via Imitation Learning

> [!info] 论文信息
> arXiv [2410.24185](https://arxiv.org/abs/2410.24185) · v1 2024-10-31 · 最新 v2（2025-03-06） · 发表：ICRA 2025
> PDF：[[nvidia/papers/07_2410.24185_DexMimicGen.pdf|本地 PDF]]
> [项目页](https://dexmimicgen.github.io/)
> 系列：物理AI · 合成数据与世界模型 · 角色：英伟达合作
> 清单里的一句话（Claude 根据摘要写，请核对）：DexMimicGen：面向双臂灵巧（人形）操作的自动数据生成系统，从少量演示合成大量轨迹。
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

> Imitation learning from human demonstrations is an effective means to teach robots manipulation skills. But data acquisition is a major bottleneck in applying this paradigm more broadly, due to the amount of cost and human effort involved. There has been significant interest in imitation learning for bimanual dexterous robots, like humanoids. Unfortunately, data collection is even more challenging here due to the challenges of simultaneously controlling multiple arms and multi-fingered hands. Automated data generation in simulation is a compelling, scalable alternative to fuel this need for data. To this end, we introduce DexMimicGen, a large-scale automated data generation system that synthesizes trajectories from a handful of human demonstrations for humanoid robots with dexterous hands. We present a collection of simulation environments in the setting of bimanual dexterous manipulation, spanning a range of manipulation behaviors and different requirements for coordination among the two arms. We generate 21K demos across these tasks from just 60 source human demos and study the effect of several data generation and policy learning decisions on agent performance. Finally, we present a real-to-sim-to-real pipeline and deploy it on a real-world humanoid can sorting task. Generated datasets, simulation environments and additional results are at this https URL
