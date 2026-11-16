---
id: "01"
org: 英伟达
short: "Isaac Gym"
title: "Isaac Gym: High Performance GPU-Based Physics Simulation For Robot Learning"
aliases: ["Isaac Gym"]
date: 2021-08-24
category: "仿真平台"
source: "英伟达主导"
partners: []
authors: ["Viktor Makoviychuk", "Lukasz Wawrzyniak", "Yunrong Guo", "Michelle Lu", "Kier Storey", "Miles Macklin", "David Hoeller", "Nikita Rudin", "Arthur Allshire", "Ankur Handa", "Gavriel State"]
arxiv: "2108.10470"
pdf: "[[nvidia/papers/01_2108.10470_Isaac-Gym.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# Isaac Gym: High Performance GPU-Based Physics Simulation For Robot Learning

> [!info] 论文信息
> arXiv [2108.10470](https://arxiv.org/abs/2108.10470) · v1 2021-08-24 · 最新 v2（2021-08-25）
> PDF：[[nvidia/papers/01_2108.10470_Isaac-Gym.pdf|本地 PDF]]
> 系列：物理AI · 仿真平台 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：Isaac Gym：物理仿真与策略训练全在 GPU 上运行的高性能机器人学习平台，开启大规模并行 RL 训练范式。
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

> Isaac Gym offers a high performance learning platform to train policies for wide variety of robotics tasks directly on GPU. Both physics simulation and the neural network policy training reside on GPU and communicate by directly passing data from physics buffers to PyTorch tensors without ever going through any CPU bottlenecks. This leads to blazing fast training times for complex robotics tasks on a single GPU with 2-3 orders of magnitude improvements compared to conventional RL training that uses a CPU based simulator and GPU for neural networks. We host the results and videos at \url{this https URL} and isaac gym can be downloaded at \url{this https URL}.
