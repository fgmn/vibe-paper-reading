---
id: "14"
org: 英伟达
short: "Sim-and-Real Co-Training"
title: "Sim-and-Real Co-Training: A Simple Recipe for Vision-Based Robotic Manipulation"
aliases: ["Sim-and-Real Co-Training"]
date: 2025-03-31
category: "合成数据与世界模型"
source: "英伟达合作"
partners: []
authors: ["Abhiram Maddukuri", "Zhenyu Jiang", "Lawrence Yunliang Chen", "Soroush Nasiriany", "Yuqi Xie", "Yu Fang", "Wenqi Huang", "Zu Wang", "Zhenjia Xu", "Nikita Chernyadev", "Scott Reed", "Ken Goldberg", "Ajay Mandlekar", "Linxi Fan", "Yuke Zhu"]
arxiv: "2503.24361"
pdf: "[[nvidia/papers/14_2503.24361_Sim-and-Real-Co-Training.pdf]]"
code: ""
project: "https://co-training.github.io/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# Sim-and-Real Co-Training: A Simple Recipe for Vision-Based Robotic Manipulation

> [!info] 论文信息
> arXiv [2503.24361](https://arxiv.org/abs/2503.24361) · v1 2025-03-31 · 最新 v2（2025-04-02）
> PDF：[[nvidia/papers/14_2503.24361_Sim-and-Real-Co-Training.pdf|本地 PDF]]
> [项目页](https://co-training.github.io/)
> 系列：物理AI · 合成数据与世界模型 · 角色：英伟达合作
> 清单里的一句话（Claude 根据摘要写，请核对）：仿真-真实协同训练：用少量真实数据加大量仿真数据联合训练视觉操作策略的简单配方，显著提升真实成功率。
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

> Large real-world robot datasets hold great potential to train generalist robot models, but scaling real-world human data collection is time-consuming and resource-intensive. Simulation has great potential in supplementing large-scale data, especially with recent advances in generative AI and automated data generation tools that enable scalable creation of robot behavior datasets. However, training a policy solely in simulation and transferring it to the real world often demands substantial human effort to bridge the reality gap. A compelling alternative is to co-train the policy on a mixture of simulation and real-world datasets. Preliminary studies have recently shown this strategy to substantially improve the performance of a policy over one trained on a limited amount of real-world data. Nonetheless, the community lacks a systematic understanding of sim-and-real co-training and what it takes to reap the benefits of simulation data for real-robot learning. This work presents a simple yet effective recipe for utilizing simulation data to solve vision-based robotic manipulation tasks. We derive this recipe from comprehensive experiments that validate the co-training strategy on various simulation and real-world datasets. Using two domains--a robot arm and a humanoid--across diverse tasks, we demonstrate that simulation data can enhance real-world task performance by an average of 38%, even with notable differences between the simulation and real-world data. Videos and additional results can be found at this https URL
