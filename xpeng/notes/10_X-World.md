---
id: "10"
org: 小鹏
short: "X-World"
title: "X-World: Controllable Ego-Centric Multi-Camera World Models for Scalable End-to-End Driving"
aliases: ["X-World"]
date: 2026-03-20
category: "世界模型"
source: "小鹏主导"
product: ""
partners: []
authors: ["Chaoda Zheng", "Sean Li", "Jinhao Deng", "Zhennan Wang", "Shijia Chen", "Liqiang Xiao", "Ziheng Chi", "Hongbin Lin", "Kangjie Chen", "Boyang Wang", "Yu Zhang", "Xianming Liu"]
arxiv: "2603.19979"
pdf: "[[xpeng/papers/10_2603.19979_X-World.pdf]]"
code: ""
project: "https://x-world-1.github.io"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng"]
---

# X-World: Controllable Ego-Centric Multi-Camera World Models for Scalable End-to-End Driving

> [!info] 论文信息
> arXiv [2603.19979](https://arxiv.org/abs/2603.19979) · v1 2026-03-20 · 最新 v2（2026-03-31）
> PDF：[[xpeng/papers/10_2603.19979_X-World.pdf|本地 PDF]]
> [项目页](https://x-world-1.github.io)
> 方向：世界模型 · 角色：小鹏主导
> 清单里的一句话（Claude 根据摘要写，请核对）：X-World：可控自车多相机生成式世界模型，用于端到端驾驶VLA的可扩展评测。
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

> Scalable and reliable evaluation is increasingly critical in the end-to-end era of autonomous driving, where vision--language--action (VLA) policies directly map raw sensor streams to driving actions. Yet, current evaluation pipelines still rely heavily on real-world road testing, which is costly, biased toward limited scenario coverage, and difficult to reproduce. These challenges motivate a real-world simulator that can generate realistic future observations under proposed actions, while remaining controllable and stable over long horizons. We present X-World, an action-conditioned multi-camera generative world model that simulates future observations directly in video space. Given synchronized multi-view camera history and a future action sequence, X-World generates future multi-camera video streams that follow the commanded actions. To ensure reproducible and editable scene rollouts, X-World further supports optional controls over dynamic traffic agents and static road elements, and retains a text-prompt interface for appearance-level control (e.g., weather and time of day). Beyond world simulation, X-World also enables video style transfer by conditioning on appearance prompts while preserving the underlying action and scene dynamics. At the core of X-World is a multi-view latent video generator designed to explicitly encourage cross-view geometric consistency and temporal coherence under diverse control signals. Experiments show that X-World achieves high-quality multi-view video generation with (i) strong view consistency across cameras, (ii) stable temporal dynamics over long rollouts, and (iii) high controllability with strict action following and faithful adherence to optional scene controls. These properties make X-World a practical foundation for scalable and reproducible evaluation.
