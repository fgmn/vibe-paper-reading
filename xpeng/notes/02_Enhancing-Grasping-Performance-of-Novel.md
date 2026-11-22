---
id: "02"
org: 小鹏
short: "Enhancing Grasping Performance of Novel Objects through an Improved Fine-Tuning Process"
title: "Enhancing Grasping Performance of Novel Objects through an Improved Fine-Tuning Process"
aliases: ["Enhancing Grasping Performance of Novel Objects through an Improved Fine-Tuning Process"]
date: 2023-10-28
category: "机器人"
source: "小鹏合作"
product: "通用（抓取）"
partners: []
authors: ["Xiao Hu", "Xiangsheng Chen"]
arxiv: "2310.18569"
pdf: "[[xpeng/papers/02_2310.18569_Enhancing-Grasping-Performance-of-Novel.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# Enhancing Grasping Performance of Novel Objects through an Improved Fine-Tuning Process

> [!info] 论文信息
> arXiv [2310.18569](https://arxiv.org/abs/2310.18569) · v1 2023-10-28
> PDF：[[xpeng/papers/02_2310.18569_Enhancing-Grasping-Performance-of-Novel.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏合作 · 产品：通用（抓取）
> 清单里的一句话（Claude 根据摘要写，请核对）：改进新物体抓取模型的微调流程以提升点云抓取成功率，工作完成于作者在小鹏机器人实习期间。
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

> Grasping algorithms have evolved from planar depth grasping to utilizing point cloud information, allowing for application in a wider range of scenarios. However, data-driven grasps based on models trained on basic open-source datasets may not perform well on novel objects, which are often required in different scenarios, necessitating fine-tuning using new objects. The data driving these algorithms essentially corresponds to the closing region of the hand in 6D pose, and due to the uniqueness of 6D pose, synthetic annotation or real-machine annotation methods are typically employed. Acquiring large amounts of data with real-machine annotation is challenging, making synthetic annotation a common practice. However, obtaining annotated 6D pose data using conventional methods is extremely time-consuming. Therefore, we propose a method to quickly acquire data for novel objects, enabling more efficient fine-tuning. Our method primarily samples grasp orientations to generate and annotate grasps. Experimental results demonstrate that our fine-tuning process for a new object is 400 \% faster than other methods. Furthermore, we propose an optimized grasp annotation framework that accounts for the effects of the gripper closing, making the annotations more reasonable. Upon acceptance of this paper, we will release our algorithm as open-source.
