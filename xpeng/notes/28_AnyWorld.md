---
id: "28"
org: 小鹏
short: "AnyWorld"
title: "AnyWorld: Factorized Egocentric World Models for Cross-Embodiment Generalization"
aliases: ["AnyWorld"]
date: 2026-08-29
category: "机器人"
source: "小鹏合作"
product: "IRON"
partners: []
authors: ["Cheng Chen", "Jerry Bai", "Jiacheng Wei", "Boyu Chen", "Xiaoji Zheng", "Fan Wu", "Minghao Yang", "Tianrun Chen", "Ruibo Li", "Xiaoyu Yue", "Xiaoyang Guo", "Yixiao Ge", "Guosheng Lin", "Fayao Liu"]
arxiv: "2608.29242"
pdf: "[[xpeng/papers/28_2608.29242_AnyWorld.pdf]]"
code: ""
project: "https://xpeng-robotics.github.io/anyworld/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# AnyWorld: Factorized Egocentric World Models for Cross-Embodiment Generalization

> [!info] 论文信息
> arXiv [2608.29242](https://arxiv.org/abs/2608.29242) · v1 2026-08-29 · 最新 v2（2026-09-01）
> PDF：[[xpeng/papers/28_2608.29242_AnyWorld.pdf|本地 PDF]]
> [项目页](https://xpeng-robotics.github.io/anyworld/)
> 方向：机器人 · 角色：小鹏合作 · 产品：IRON
> 清单里的一句话（Claude 根据摘要写，请核对）：【XPENG Robotics】AnyWorld：分解式第一视角世界模型实现跨本体泛化。
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

> Collecting contact-rich robot experiences at scale remains a major bottleneck for generalizable manipulation. Beyond data quantity, robot learning also requires diverse experiences across embodiments, viewpoints, and scenes. Human egocentric videos provide abundant physical interactions, but each video captures only a narrow slice of experience under a single body, camera trajectory, and environment. We propose AnyWorld, a cross-embodiment world modeling framework that expands a single human interaction into diverse robot-native rollouts without paired human-robot demonstrations. Our model factorizes an interaction into action, camera, and embodiment: action controls capture the motion structure, camera controls specify viewpoint evolution, and the target embodiment context defines the acting body and its interaction geometry. This formulation enables independent recomposition of embodiment, viewpoint, and scene factors, allowing a single model to generate many robot-domain experiences while preserving the underlying dynamics and object interactions. We train the model with large-scale human interaction pretraining followed by mixed-embodiment fine-tuning. Experiments show that our model supports controllable recomposition across embodiments, viewpoints, and scenes, and we further demonstrate that the generated data can improve manipulation performance on the RoboCasa GR1 tabletop benchmark and a real IRON humanoid robot. Beyond aggregate gains, we test whether unpaired human experience can be recomposed into robot-native video-action pairs that target a policy gap. Controlled IRON interventions correct a spurious completion prior and establish language-grounded spatial target selection; an action-only counterfactual intervention fails to learn the latter reliably, showing that both action calibration and visual recomposition are necessary.
