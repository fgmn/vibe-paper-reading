---
id: "02"
org: 英伟达
short: "Orbit"
title: "Orbit: A Unified Simulation Framework for Interactive Robot Learning Environments"
aliases: ["Orbit"]
date: 2023-01-10
category: "仿真平台"
source: "英伟达合作"
partners: []
authors: ["Mayank Mittal", "Calvin Yu", "Qinxi Yu", "Jingzhou Liu", "Nikita Rudin", "David Hoeller", "Jia Lin Yuan", "Ritvik Singh", "Yunrong Guo", "Hammad Mazhar", "Ajay Mandlekar", "Buck Babich", "Gavriel State", "Marco Hutter", "Animesh Garg"]
arxiv: "2301.04195"
pdf: "[[nvidia/papers/02_2301.04195_Orbit.pdf]]"
code: ""
project: "https://isaac-orbit.github.io/"
huggingface: []
license: CC BY-SA 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# Orbit: A Unified Simulation Framework for Interactive Robot Learning Environments

> [!info] 论文信息
> arXiv [2301.04195](https://arxiv.org/abs/2301.04195) · v1 2023-01-10 · 最新 v2（2024-02-16）
> PDF：[[nvidia/papers/02_2301.04195_Orbit.pdf|本地 PDF]]
> [项目页](https://isaac-orbit.github.io/)
> 系列：物理AI · 仿真平台 · 角色：英伟达合作
> 清单里的一句话（Claude 根据摘要写，请核对）：Orbit：基于 Isaac Sim 的统一模块化机器人学习框架，Isaac Lab 的前身。
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

> We present Orbit, a unified and modular framework for robot learning powered by NVIDIA Isaac Sim. It offers a modular design to easily and efficiently create robotic environments with photo-realistic scenes and high-fidelity rigid and deformable body simulation. With Orbit, we provide a suite of benchmark tasks of varying difficulty -- from single-stage cabinet opening and cloth folding to multi-stage tasks such as room reorganization. To support working with diverse observations and action spaces, we include fixed-arm and mobile manipulators with different physically-based sensors and motion generators. Orbit allows training reinforcement learning policies and collecting large demonstration datasets from hand-crafted or expert solutions in a matter of minutes by leveraging GPU-based parallelization. In summary, we offer an open-sourced framework that readily comes with 16 robotic platforms, 4 sensor modalities, 10 motion generators, more than 20 benchmark tasks, and wrappers to 4 learning libraries. With this framework, we aim to support various research areas, including representation learning, reinforcement learning, imitation learning, and task and motion planning. We hope it helps establish interdisciplinary collaborations in these communities, and its modularity makes it easily extensible for more tasks and applications in the future.
