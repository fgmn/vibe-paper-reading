---
id: "13"
org: 智元
short: "SOP"
title: "SOP: A Scalable Online Post-Training System for Vision-Language-Action Models"
aliases: ["SOP"]
date: 2026-01-06
category: "VLA/基础模型"
source: "智元主导"
product: ""
partners: []
authors: ["Mingjie Pan", "Siyuan Feng", "Qinglin Zhang", "Xinchen Li", "Jianheng Song", "Chendi Qu", "Yi Wang", "Chuankang Li", "Ziyu Xiong", "Zhi Chen", "Yi Liu", "Jianlan Luo"]
arxiv: "2601.03044"
pdf: "[[agibot/papers/13_2601.03044_SOP.pdf]]"
code: ""
project: "https://www.agibot.com/research/sop"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# SOP: A Scalable Online Post-Training System for Vision-Language-Action Models

> [!info] 论文信息
> arXiv [2601.03044](https://arxiv.org/abs/2601.03044) · v1 2026-01-06
> PDF：[[agibot/papers/13_2601.03044_SOP.pdf|本地 PDF]]
> [项目页](https://www.agibot.com/research/sop)
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：SOP：在真实世界在线、分布式、多任务地后训练通用 VLA 的规模化系统。
> 汇总：[[agibot/智元-论文与报告汇总|智元论文与报告汇总]]

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

> Vision-language-action (VLA) models achieve strong generalization through large-scale pre-training, but real-world deployment requires expert-level task proficiency in addition to broad generality. Existing post-training approaches for VLA models are typically offline, single-robot, or task-specific, limiting effective on-policy adaptation and scalable learning from real-world interaction. We introduce a Scalable Online Post-training (SOP) system that enables online, distributed, multi-task post-training of generalist VLA models directly in the physical world. SOP tightly couples execution and learning through a closed-loop architecture in which a fleet of robots continuously streams on-policy experience and human intervention signals to a centralized cloud learner, and asynchronously receives updated policies. This design supports prompt on-policy correction, scales experience collection through parallel deployment, and preserves generality during adaptation. SOP is agnostic to the choice of post-training algorithm; we instantiate it with both interactive imitation learning (HG-DAgger) and reinforcement learning (RECAP). Across a range of real-world manipulation tasks including cloth folding, box assembly, and grocery restocking, we show that SOP substantially improves the performance of large pretrained VLA models while maintaining a single shared policy across tasks. Effective post-training can be achieved within hours of real-world interaction, and performance scales near-linearly with the number of robots in the fleet. These results suggest that tightly coupling online learning with fleet-scale deployment is instrumental to enabling efficient, reliable, and scalable post-training of generalist robot policies in the physical world.
