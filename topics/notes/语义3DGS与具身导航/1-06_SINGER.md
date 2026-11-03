---
id: "1-06"
org: 专题·语义3DGS与具身导航
short: "SINGER"
title: "SINGER: An Onboard Generalist Vision-Language Navigation Policy for Drones"
aliases: ["SINGER"]
date: 2025-09-23
category: "视觉语言导航"
venue: ""
affiliation: "Stanford University"
semantic: true
authors: ["Maximilian Adang", "JunEn Low", "Ola Shorinwa", "Mac Schwager"]
arxiv: "2509.18610"
pdf: "[[topics/papers/语义3DGS与具身导航/1-06_2509.18610_SINGER.pdf]]"
code: ""
project: ""
license: CC BY-NC-SA 4.0
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation", "semantic-gaussian"]
---

# SINGER: An Onboard Generalist Vision-Language Navigation Policy for Drones

> [!info] 论文信息
> arXiv [2509.18610](https://arxiv.org/abs/2509.18610) · v1 2025-09-23
> 第一作者单位：Stanford University
> PDF：[[topics/papers/语义3DGS与具身导航/1-06_2509.18610_SINGER.pdf|本地 PDF]]
> 专题：[[topics/语义3DGS与具身导航#一、语义高斯直接用于导航|语义3DGS与具身导航 · 一、语义高斯直接用于导航]]
> 清单里的一句话（Claude 根据摘要写，请核对）：面向无人机的机载开放词汇语言导航策略：用语言嵌入的高斯泼溅飞行模拟器生成大规模数据，训练轻量端到端视觉运动策略并零样本迁移实机。

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

> Large vision-language models have driven remarkable progress in open-vocabulary robot policies, e.g., generalist robot manipulation policies, that enable robots to complete complex tasks specified in natural language. Despite these successes, open-vocabulary autonomous drone navigation remains an unsolved challenge due to the scarcity of large-scale demonstrations, real-time control demands of drones for stabilization, and lack of reliable external pose estimation modules. In this work, we present SINGER for language-guided autonomous drone navigation in the open world using only onboard sensing and compute. To train robust, open-vocabulary navigation policies, SINGER leverages three central components: (i) a photorealistic language-embedded flight simulator with minimal sim-to-real gap using Gaussian Splatting for efficient data generation, (ii) an RRT-inspired multi-trajectory generation expert for collision-free navigation demonstrations, and these are used to train (iii) a lightweight end-to-end visuomotor policy for real-time closed-loop control. Through extensive hardware flight experiments, we demonstrate superior zero-shot sim-to-real transfer of our policy to unseen environments and unseen language-conditioned goal objects. When trained on ~700k-1M observation action pairs of language conditioned visuomotor data and deployed on hardware, SINGER outperforms a velocity-controlled semantic guidance baseline by reaching the query 23.33% more on average, and maintains the query in the field of view 16.67% more on average, with 10% fewer collisions.
