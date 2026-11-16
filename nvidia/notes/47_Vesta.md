---
id: "47"
org: 英伟达
short: "Vesta"
title: "Vesta: A Generalist Embodied Reasoning Model"
aliases: ["Vesta"]
date: 2026-06-18
category: "GR00T"
source: "英伟达主导"
partners: []
authors: ["Johan Bjorck", "Zhiqi Li", "Yunze Man", "Jing Wang", "An-Chieh Cheng", "Sifei Liu", "Shihao Wang", "Zhiding Yu", "Abhishek Badki", "Stan Birchfield", "Valts Blukis", "Yevgen Chebotar", "Siyi Chen", "Sicong Leng", "Yu-Cheng Chou", "Tianli Ding", "Boyi Li", "Zhengyi Luo", "Hang Su", "Jonathan Tremblay", "Tingwu Wang", "Bowen Wen", "Jimmy Wu", "Xianghui Xie", "Hanrong Ye", "Hongxu Yin", "K.R. Zentner", "Liangyan Gui", "Yu-Xiong Wang", "Yuke Zhu", "Linxi \"Jim\" Fan", "Jan Kautz"]
arxiv: "2606.20905"
pdf: "[[nvidia/papers/47_2606.20905_Vesta.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY-NC-ND 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# Vesta: A Generalist Embodied Reasoning Model

> [!info] 论文信息
> arXiv [2606.20905](https://arxiv.org/abs/2606.20905) · v1 2026-06-18
> PDF：[[nvidia/papers/47_2606.20905_Vesta.pdf|本地 PDF]]
> 系列：物理AI · GR00T · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：Vesta：将定位、导航、具身推理与动作规划统一到单一基础模型的通用具身推理模型。
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

> Robots operating in open-world environments must seamlessly integrate localization, spatial reasoning, navigation, and long-horizon planning. While specialist models excel at individual tasks, deploying a multi-model stack is computationally expensive and prone to cascading errors. We present Vesta, a unified embodied generalist that consolidates these capabilities into a single foundation model. Our approach combines a diverse and massive curated corpus designed to induce spatial grounding and a simple multimodal memory harness that enables reasoning over extended time horizons. Across diverse benchmarks, Vesta on average beats individual SOTA baselines by >$20\%$ and beats an ensemble of per-category-best baselines by $>10\%$ -- thus demonstrating that a generalist model can match or exceed specialists. On real-world robotic tasks requiring memory and reasoning, Vesta improves task success by >35\%. Our work thus demonstrates that a single generalist is a feasible, scalable, and arguably preferable alternative to combining specialists.
