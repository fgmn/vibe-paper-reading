---
id: "37"
org: 英伟达
short: "SoftMimicGen"
title: "SoftMimicGen: A Data Generation System for Scalable Robot Learning in Deformable Object Manipulation"
aliases: ["SoftMimicGen"]
date: 2026-03-26
category: "合成数据与世界模型"
source: "英伟达主导"
partners: []
authors: ["Masoud Moghani", "Mahdi Azizian", "Animesh Garg", "Yuke Zhu", "Sean Huver", "Ajay Mandlekar"]
arxiv: "2603.25725"
pdf: "[[nvidia/papers/37_2603.25725_SoftMimicGen.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# SoftMimicGen: A Data Generation System for Scalable Robot Learning in Deformable Object Manipulation

> [!info] 论文信息
> arXiv [2603.25725](https://arxiv.org/abs/2603.25725) · v1 2026-03-26
> PDF：[[nvidia/papers/37_2603.25725_SoftMimicGen.pdf|本地 PDF]]
> 系列：物理AI · 合成数据与世界模型 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：SoftMimicGen：将 MimicGen 式自动数据生成扩展到可变形物体操作任务。
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

> Large-scale robot datasets have facilitated the learning of a wide range of robot manipulation skills, but these datasets remain difficult to collect and scale further, owing to the intractable amount of human time, effort, and cost required. Simulation and synthetic data generation have proven to be an effective alternative to fuel this need for data, especially with the advent of recent work showing that such synthetic datasets can dramatically reduce real-world data requirements and facilitate generalization to novel scenarios unseen in real-world demonstrations. However, this paradigm has been limited to rigid-body tasks, which are easy to simulate. Deformable object manipulation encompasses a large portion of real-world manipulation and remains a crucial gap to address towards increasing adoption of the synthetic simulation data paradigm. In this paper, we introduce SoftMimicGen, an automated data generation pipeline for deformable object manipulation tasks. We introduce a suite of high-fidelity simulation environments that encompasses a wide range of deformable objects (stuffed animal, rope, tissue, towel) and manipulation behaviors (high-precision threading, dynamic whipping, folding, pick-and-place), across four robot embodiments: a single-arm manipulator, bimanual arms, a humanoid, and a surgical robot. We apply SoftMimicGen to generate datasets across the task suite, train high-performing policies from the data, and systematically analyze the data generation system. Project website: \href{this https URL}{this http URL}.
