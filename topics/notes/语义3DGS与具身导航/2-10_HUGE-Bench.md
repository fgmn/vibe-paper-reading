---
id: "2-10"
org: 专题·语义3DGS与具身导航
short: "HUGE-Bench"
title: "HUGE-Bench: A Benchmark for High-Level UAV Vision-Language-Action Tasks"
aliases: ["HUGE-Bench"]
date: 2026-03-20
category: "视觉语言导航"
venue: ""
affiliation: ""
semantic: false
authors: ["Jingyu Guo", "Ziye Chen", "Ziwen Li", "Zhengqing Gao", "Jiaxin Huang", "Hanlue Zhang", "Fengming Huang", "Yu Yao", "Tongliang Liu", "Mingming Gong"]
arxiv: "2603.19822"
pdf: "[[topics/papers/语义3DGS与具身导航/2-10_2603.19822_HUGE-Bench.pdf]]"
code: ""
project: ""
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation"]
---

# HUGE-Bench: A Benchmark for High-Level UAV Vision-Language-Action Tasks

> [!info] 论文信息
> arXiv [2603.19822](https://arxiv.org/abs/2603.19822) · v1 2026-03-20 · 最新 v4（2026-07-03）
> PDF：[[topics/papers/语义3DGS与具身导航/2-10_2603.19822_HUGE-Bench.pdf|本地 PDF]]
> 专题：[[topics/语义3DGS与具身导航#二、高斯地图导航（高斯不带语义）|语义3DGS与具身导航 · 二、高斯地图导航（高斯不带语义）]]
> 清单里的一句话（Claude 根据摘要写，请核对）：高层UAV视觉-语言-动作任务基准，基于对齐的3DGS-网格数字孪生做碰撞感知评测。

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

> Existing UAV vision-language navigation (VLN) benchmarks have enabled language-guided flight, but they largely focus on long, step-wise route descriptions with goal-centric evaluation, making them less diagnostic for real operations where brief, high-level commands must be grounded into safe multi-stage behaviors. We present HUGE-Bench, a benchmark for High-Level UAV Vision-Language-Action (HL-VLA) tasks that tests whether an agent can interpret concise language and execute complex, process-oriented trajectories with safety awareness. HUGE-Bench comprises 4 real-world digital twin scenes, 8 high-level tasks, and 2.56M meters of trajectories, and is built on an aligned 3D Gaussian Splatting (3DGS)-Mesh representation that combines photorealistic rendering with collision-capable geometry for scalable generation and collision-aware evaluation. We introduce process-oriented and collision-aware metrics to assess process fidelity, terminal accuracy, and safety. Experiments on representative state-of-the-art VLA models reveal significant gaps in high-level semantic completion and safe execution, highlighting HUGE-Bench as a diagnostic testbed for high-level UAV autonomy.
