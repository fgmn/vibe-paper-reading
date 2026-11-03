---
id: "2-05"
org: 专题·语义3DGS与具身导航
short: "GRaD-Nav++"
title: "GRaD-Nav++: Vision-Language Model Enabled Visual Drone Navigation with Gaussian Radiance Fields and Differentiable Dynamics"
aliases: ["GRaD-Nav++"]
date: 2025-06-16
category: "视觉语言导航"
venue: "IEEE RA-L 2026"
affiliation: "Stanford University"
semantic: false
authors: ["Qianzhong Chen", "Naixiang Gao", "Suning Huang", "JunEn Low", "Timothy Chen", "Jiankai Sun", "Mac Schwager"]
arxiv: "2506.14009"
pdf: "[[topics/papers/语义3DGS与具身导航/2-05_2506.14009_GRaD-Nav++.pdf]]"
code: "https://github.com/Qianzhong-Chen/grad_nav"
project: "https://qianzhong-chen.github.io/gradnavpp.github.io/"
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation"]
---

# GRaD-Nav++: Vision-Language Model Enabled Visual Drone Navigation with Gaussian Radiance Fields and Differentiable Dynamics

> [!info] 论文信息
> arXiv [2506.14009](https://arxiv.org/abs/2506.14009) · v1 2025-06-16 · 最新 v2（2026-05-15）
> 发表：IEEE RA-L 2026 · 第一作者单位：Stanford University
> PDF：[[topics/papers/语义3DGS与具身导航/2-05_2506.14009_GRaD-Nav++.pdf|本地 PDF]]
> [代码](https://github.com/Qianzhong-Chen/grad_nav) · [项目页](https://qianzhong-chen.github.io/gradnavpp.github.io/)
> 专题：[[topics/语义3DGS与具身导航#二、高斯地图导航（高斯不带语义）|语义3DGS与具身导航 · 二、高斯地图导航（高斯不带语义）]]
> 清单里的一句话（Claude 根据摘要写，请核对）：轻量级机载无人机VLA框架，在3DGS逼真模拟器中用可微强化学习训练，执行自然语言指令飞行，并以MoE动作头提升泛化。

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

> Autonomous drones capable of interpreting and executing high-level language instructions in unstructured environments remain a long-standing goal. Yet existing approaches are constrained by their dependence on hand-crafted skills, extensive parameter tuning, or computationally intensive models unsuitable for onboard use. We introduce GRaD-Nav++, a lightweight Vision-Language-Action (VLA) framework that runs fully onboard and follows natural-language commands in real time. Our policy is trained in a photorealistic 3D Gaussian Splatting (3DGS) simulator via Differentiable Reinforcement Learning (DiffRL), enabling efficient learning of low-level control from visual and linguistic inputs. At its core is a Mixture-of-Experts (MoE) action head, which adaptively routes computation to improve generalization while mitigating forgetting. In multi-task generalization experiments, GRaD-Nav++ achieves a success rate of 83% on trained tasks and 75% on unseen tasks in simulation. When deployed on real hardware, it attains 67% success on trained tasks and 50% on unseen ones. In multi-environment adaptation experiments, GRaD-Nav++ achieves an average success rate of 81% across diverse simulated environments and 67% across varied real-world settings. These results establish a new benchmark for fully onboard Vision-Language-Action (VLA) flight and demonstrate that compact, efficient models can enable reliable, language-guided navigation without relying on external infrastructure.
