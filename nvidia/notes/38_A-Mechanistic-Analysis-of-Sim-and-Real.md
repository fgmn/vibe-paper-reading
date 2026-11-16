---
id: "38"
org: 英伟达
short: "A Mechanistic Analysis of Sim-and-Real Co-Training in Generative Robot Policies"
title: "A Mechanistic Analysis of Sim-and-Real Co-Training in Generative Robot Policies"
aliases: ["A Mechanistic Analysis of Sim-and-Real Co-Training in Generative Robot Policies"]
date: 2026-04-15
category: "合成数据与世界模型"
source: "英伟达合作"
partners: []
authors: ["Yu Lei", "Minghuan Liu", "Abhiram Maddukuri", "Zhenyu Jiang", "Yuke Zhu"]
arxiv: "2604.13645"
pdf: "[[nvidia/papers/38_2604.13645_A-Mechanistic-Analysis-of-Sim-and-Real.pdf]]"
code: ""
project: "https://science-of-co-training.github.io/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# A Mechanistic Analysis of Sim-and-Real Co-Training in Generative Robot Policies

> [!info] 论文信息
> arXiv [2604.13645](https://arxiv.org/abs/2604.13645) · v1 2026-04-15
> PDF：[[nvidia/papers/38_2604.13645_A-Mechanistic-Analysis-of-Sim-and-Real.pdf|本地 PDF]]
> [项目页](https://science-of-co-training.github.io/)
> 系列：物理AI · 合成数据与世界模型 · 角色：英伟达合作
> 清单里的一句话（Claude 根据摘要写，请核对）：对生成式机器人策略中仿真-真实协同训练做机理分析，解释其何时、为何有效。
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

> Co-training, which combines limited in-domain real-world data with abundant surrogate data such as simulation or cross-embodiment robot data, is widely used for training generative robot policies. Despite its empirical success, the mechanisms that determine when and why co-training is effective remain poorly understood. We investigate the mechanism of sim-and-real co-training through theoretical analysis and empirical study, and identify two intrinsic effects governing performance. The first, ``structured representation alignment", reflects a balance between cross-domain representation alignment and domain discernibility, and plays a primary role in downstream performance. The second, the ``importance reweighting effect", arises from domain-dependent modulation of action weighting and operates at a secondary level. We validate these effects with controlled experiments on a toy model and extensive sim-and-sim and sim-and-real robot manipulation experiments. Our analysis offers a unified interpretation of recent co-training techniques and motivates a simple method that consistently improves upon prior approaches. More broadly, our aim is to examine the inner workings of co-training and to facilitate research in this direction.
