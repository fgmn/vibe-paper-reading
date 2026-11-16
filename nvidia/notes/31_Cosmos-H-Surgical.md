---
id: "31"
org: 英伟达
short: "Cosmos-H-Surgical"
title: "Cosmos-H-Surgical: Learning Surgical Robot Policies from Videos via World Modeling"
aliases: ["Cosmos-H-Surgical"]
date: 2025-12-29
category: "Cosmos · 其他"
source: "英伟达主导"
partners: []
authors: ["Yufan He", "Pengfei Guo", "Mengya Xu", "Zhaoshuo Li", "Andriy Myronenko", "Dillan Imans", "Bingjie Liu", "Dongren Yang", "Mingxue Gu", "Yongnan Ji", "Yueming Jin", "Ren Zhao", "Baiyong Shen", "Daguang Xu"]
arxiv: "2512.23162"
pdf: "[[nvidia/papers/31_2512.23162_Cosmos-H-Surgical.pdf]]"
code: "https://github.com/NVIDIA-Medtech/Cosmos-H-Surgical"
project: ""
huggingface: ["https://huggingface.co/nvidia/Cosmos-H-Surgical"]
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "nvidia", "cosmos"]
---

# Cosmos-H-Surgical: Learning Surgical Robot Policies from Videos via World Modeling

> [!info] 论文信息
> arXiv [2512.23162](https://arxiv.org/abs/2512.23162) · v1 2025-12-29 · 最新 v4（2026-03-11）
> PDF：[[nvidia/papers/31_2512.23162_Cosmos-H-Surgical.pdf|本地 PDF]]
> [代码](https://github.com/NVIDIA-Medtech/Cosmos-H-Surgical)
> 系列：Cosmos · 其他 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：构建手术世界模型 Cosmos-H-Surgical 与 SATA 数据集，用逆动力学从合成手术视频推断伪运动学，扩充 VLA 训练数据。
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

> Data scarcity remains a fundamental barrier to achieving fully autonomous surgical robots. While large scale vision language action (VLA) models have shown impressive generalization in household and industrial manipulation by leveraging paired video action data from diverse domains, surgical robotics suffers from the paucity of datasets that include both visual observations and accurate robot kinematics. In contrast, vast corpora of surgical videos exist, but they lack corresponding action labels, preventing direct application of imitation learning or VLA training. In this work, we aim to alleviate this problem by learning policy models from Cosmos-H-Surgical, a world model designed for surgical physical AI. We curated the Surgical Action Text Alignment (SATA) dataset with detailed action description specifically for surgical robots. Then we built Cosmos-H-Surgical based on the most advanced physical AI world model and SATA. It's able to generate diverse, generalizable and realistic surgery videos. We are also the first to use an inverse dynamics model to infer pseudokinematics from synthetic surgical videos, producing synthetic paired video action data. We demonstrate that a surgical VLA policy trained with these augmented data significantly outperforms models trained only on real demonstrations on a real surgical robot platform. Our approach offers a scalable path toward autonomous surgical skill acquisition by leveraging the abundance of unlabeled surgical video and generative world modeling, thus opening the door to generalizable and data efficient surgical robot policies.
