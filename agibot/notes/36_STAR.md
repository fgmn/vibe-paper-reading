---
id: "36"
org: 智元
short: "STAR"
title: "STAR: Sparse Tactile Representation Learning in Vision-Tactile-Language-Action Models for Dexterous Manipulation"
aliases: ["STAR"]
date: 2026-09-11
category: "灵巧操作"
source: "智元主导"
product: ""
partners: []
authors: ["Xiangcheng Liu", "Tianhao Wu", "Le Zheng", "Yidong Wang", "Bowen Jiang", "Mingjie Pan", "Xinlin Ren", "Yi Liu", "Jianlan Luo"]
arxiv: "2609.12549"
pdf: "[[agibot/papers/36_2609.12549_STAR.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY-NC-ND 4.0
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# STAR: Sparse Tactile Representation Learning in Vision-Tactile-Language-Action Models for Dexterous Manipulation

> [!info] 论文信息
> arXiv [2609.12549](https://arxiv.org/abs/2609.12549) · v1 2026-09-11 · 最新 v2（2026-09-18）
> PDF：[[agibot/papers/36_2609.12549_STAR.pdf|本地 PDF]]
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：STAR：自建 200 小时双手灵巧视触语数据集，在 VTLA 模型中学习稀疏触觉表示。
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

> Dexterous manipulation requires coordinated multi-finger control and effective tactile feedback, yet learning these capabilities remains challenging due to the lack of large-scale real-world data and the difficulty of extracting effective representations from sparse tactile signals. We build a robot platform and teleoperation system to collect a 200-hour bimanual dexterous manipulation dataset with synchronized visual, tactile, and language annotations, comprising 10,576 trajectories across 65 tasks, 69.5% of which involve dexterous multi-finger manipulation. We further propose STAR, an integrated training recipe for vision-tactile-language-action (VTLA) models that addresses the spatial, temporal, and informational sparsity of tactile signals through visual-tactile joint pre-training, sparse-global tactile token representation, and sparse future tactile prediction. Trained on this dataset, STAR achieves a 61% average success rate across four real-world tasks with 100 post-training trajectories per task, demonstrating dexterous performance under task-specific post-training.
