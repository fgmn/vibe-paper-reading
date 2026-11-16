---
id: "22"
org: 英伟达
short: "Neural Robot Dynamics"
title: "Neural Robot Dynamics"
aliases: ["Neural Robot Dynamics"]
date: 2025-08-21
category: "仿真平台"
source: "英伟达主导"
partners: []
authors: ["Jie Xu", "Eric Heiden", "Iretiayo Akinola", "Dieter Fox", "Miles Macklin", "Yashraj Narang"]
arxiv: "2508.15755"
pdf: "[[nvidia/papers/22_2508.15755_Neural-Robot-Dynamics.pdf]]"
code: "https://github.com/NVlabs/neural-robot-dynamics"
project: "https://neural-robot-dynamics.github.io/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# Neural Robot Dynamics

> [!info] 论文信息
> arXiv [2508.15755](https://arxiv.org/abs/2508.15755) · v1 2025-08-21
> PDF：[[nvidia/papers/22_2508.15755_Neural-Robot-Dynamics.pdf|本地 PDF]]
> [代码](https://github.com/NVlabs/neural-robot-dynamics) · [项目页](https://neural-robot-dynamics.github.io/)
> 系列：物理AI · 仿真平台 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：NeRD：学习机器人专属神经动力学，替换解析仿真器的底层动力学与接触求解，可跨任务泛化并用真实数据微调。
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

> Accurate and efficient simulation of modern robots remains challenging due to their high degrees of freedom and intricate mechanisms. Neural simulators have emerged as a promising alternative to traditional analytical simulators, capable of efficiently predicting complex dynamics and adapting to real-world data; however, existing neural simulators typically require application-specific training and fail to generalize to novel tasks and/or environments, primarily due to inadequate representations of the global state. In this work, we address the problem of learning generalizable neural simulators for robots that are structured as articulated rigid bodies. We propose NeRD (Neural Robot Dynamics), learned robot-specific dynamics models for predicting future states for articulated rigid bodies under contact constraints. NeRD uniquely replaces the low-level dynamics and contact solvers in an analytical simulator and employs a robot-centric and spatially-invariant simulation state representation. We integrate the learned NeRD models as an interchangeable backend solver within a state-of-the-art robotics simulator. We conduct extensive experiments to show that the NeRD simulators are stable and accurate over a thousand simulation steps; generalize across tasks and environment configurations; enable policy learning exclusively in a neural engine; and, unlike most classical simulators, can be fine-tuned from real-world data to bridge the gap between simulation and reality.
