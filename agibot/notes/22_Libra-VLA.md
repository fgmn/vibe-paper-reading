---
id: "22"
org: 智元
short: "Libra-VLA"
title: "Libra-VLA: Achieving Learning Equilibrium via Asynchronous Coarse-to-Fine Dual-System"
aliases: ["Libra-VLA"]
date: 2026-04-27
category: "VLA/基础模型"
source: "智元主导"
product: ""
partners: []
authors: ["Yifei Wei", "Linqing Zhong", "Yi Liu", "Yuxiang Lu", "Xindong He", "Maoqing Yao", "Guanghui Ren"]
arxiv: "2604.24921"
pdf: "[[agibot/papers/22_2604.24921_Libra-VLA.pdf]]"
code: ""
project: "https://libra-vla.github.io/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# Libra-VLA: Achieving Learning Equilibrium via Asynchronous Coarse-to-Fine Dual-System

> [!info] 论文信息
> arXiv [2604.24921](https://arxiv.org/abs/2604.24921) · v1 2026-04-27 · 发表：ACL 2026
> PDF：[[agibot/papers/22_2604.24921_Libra-VLA.pdf|本地 PDF]]
> [项目页](https://libra-vla.github.io/)
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：Libra-VLA：粗到细异步双系统 VLA，在离散宏方向与连续微调动作间取得学习均衡。
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

> Vision-Language-Action (VLA) models are a promising paradigm for generalist robotic manipulation by grounding high-level semantic instructions into executable physical actions. However, prevailing approaches typically adopt a monolithic generation paradigm, directly mapping visual-linguistic features to high-frequency motor commands in a flat, non-hierarchical fashion. This strategy overlooks the inherent hierarchy of robotic manipulation, where complex actions can be naturally modeled in a Hybrid Action Space, decomposing into discrete macro-directional reaching and continuous micro-pose alignment, severely widening the semantic-actuation gap and imposing a heavy representational burden on grounding high-level semantics to continuous actions. To address this, we introduce Libra-VLA, a novel Coarse-to-Fine Dual-System VLA architecture. We explicitly decouple the learning complexity into a coarse-to-fine hierarchy to strike a training equilibrium, while simultaneously leveraging this structural modularity to implement an asynchronous execution strategy. The Semantic Planner predicts discrete action tokens capturing macro-directional intent, while the Action Refiner conditions on coarse intent to generate high-frequency continuous actions for precise alignment. Crucially, our empirical analysis reveals that performance follows an inverted-U curve relative to action decomposition granularity, peaking exactly when the learning difficulty is balanced between the two sub-systems. With the asynchronous design, our approach offers a scalable, robust, and responsive solution for open-world manipulation.
