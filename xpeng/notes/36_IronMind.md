---
id: "36"
org: 小鹏
short: "IronMind"
title: "IronMind: Scaling Humanoid Dexterous Manipulation via Camera-Space Ego-Centric Pretraining"
aliases: ["IronMind"]
date: 2026-09-30
category: "机器人"
source: "小鹏主导"
product: "IRON"
partners: []
authors: ["Huimin Pan", "Yufan Ren", "Kunpeng Song", "Siyang Wang", "Xiwen Zhang", "Xiaoyun Hu", "Zhuoxu Duan", "Hanrui Zheng", "Jialeng Ni", "Nathan Zhao", "Sibo Ma", "Zhenxuan Fan", "Zhongyang Che", "Danny Bao", "Jiacheng Wei", "Jerry Bai", "Xiaoyu Yue", "Xiaoyang Guo", "Chenyi Chen"]
arxiv: "2609.39403"
pdf: "[[xpeng/papers/36_2609.39403_IronMind.pdf]]"
code: ""
project: "https://xpeng-robotics.github.io/ironmind/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# IronMind: Scaling Humanoid Dexterous Manipulation via Camera-Space Ego-Centric Pretraining

> [!info] 论文信息
> arXiv [2609.39403](https://arxiv.org/abs/2609.39403) · v1 2026-09-30
> PDF：[[xpeng/papers/36_2609.39403_IronMind.pdf|本地 PDF]]
> [项目页](https://xpeng-robotics.github.io/ironmind/)
> 方向：机器人 · 角色：小鹏主导 · 产品：IRON
> 清单里的一句话（Claude 根据摘要写，请核对）：【XPENG Robotics/人形】IronMind：相机空间第一视角预训练扩展人形灵巧操作。
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

> Egocentric human video offers a scalable data source for dexterous manipulation, yet using it to train humanoid robots presents two challenges: (1) an embodiment gap, as human hands differ structurally from robot end-effectors and low-cost egocentric recordings lack the torso kinematics required by conventional retargeting; and (2) heterogeneous data quality, including noisy hand-pose tracking and weakly aligned text annotations. We introduce IronMind, a vision-language-action (VLA) model that uses egocentric human video and heterogeneous robot data to pretrain policies for humanoid dexterous manipulation. To bridge the embodiment gap, IronMind bypasses explicit body-retargeting by using a camera-space action representation, the native reference space of egocentric video, and semantically aligning robot and human action dimensions. Across total pretraining budgets from 250 to 10,000 hours, validation loss decreases approximately log-linearly with data scale. Larger pretraining budgets also improve out-of-distribution real-robot manipulation after post-training: across six challenging tasks with unseen objects, affordances, and reasoning prompts, the 10,000-hour model achieves a 55.0% success rate, compared with at most 11.7% for every pretraining budget up to 5,000 hours and 5.0% without pretraining. At the same pretraining budget, the camera-space action representation also outperforms the torso-frame baseline. Together, these findings support pretraining with a camera-space action representation on large-scale human egocentric data as a scalable foundation for humanoid robot manipulation.
