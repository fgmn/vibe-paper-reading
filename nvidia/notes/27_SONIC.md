---
id: "27"
org: 英伟达
short: "SONIC"
title: "SONIC: Supersizing Motion Tracking for Natural Humanoid Whole-Body Control"
aliases: ["SONIC"]
date: 2025-11-11
category: "人形全身控制"
source: "英伟达主导"
partners: []
authors: ["Zhengyi Luo", "Ye Yuan", "Tingwu Wang", "Chenran Li", "Fernando Castañeda", "Sirui Chen", "Zi-Ang Cao", "Jiefeng Li", "David Minor", "Qingwei Ben", "Jinhyung Park", "David Sami", "Zi Wang", "Xingye Da", "Runyu Ding", "Cyrus Hogg", "Lina Song", "Edy Lim", "Eugene Jeong", "Tairan He", "Haoru Xue", "Wenli Xiao", "Simon Yuen", "Jan Kautz", "Yan Chang", "Umar Iqbal", "Linxi \"Jim\" Fan", "Yuke Zhu"]
arxiv: "2511.07820"
pdf: "[[nvidia/papers/27_2511.07820_SONIC.pdf]]"
code: ""
project: "https://nvlabs.github.io/SONIC/"
huggingface: []
license: CC BY-SA 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# SONIC: Supersizing Motion Tracking for Natural Humanoid Whole-Body Control

> [!info] 论文信息
> arXiv [2511.07820](https://arxiv.org/abs/2511.07820) · v1 2025-11-11 · 最新 v4（2026-08-13）
> PDF：[[nvidia/papers/27_2511.07820_SONIC.pdf|本地 PDF]]
> [项目页](https://nvlabs.github.io/SONIC/)
> 系列：物理AI · 人形全身控制 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：SONIC：将运动跟踪规模化（亿帧数据、42M 参数）作为人形控制基础任务，统一支持 VR 遥操作、规划器与 VLA 驱动。
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

> Despite the rise of billion-parameter foundation models trained across thousands of graphical processing units (GPUs), similar scaling gains have not been shown for humanoid control. Current neural controllers for humanoids remain modest in size, target a limited set of behaviors, and are trained on a handful of GPUs. We show that scaling model capacity, data, and compute yields a generalist humanoid controller capable of natural, robust whole-body movements. We position motion tracking as a scalable task for humanoid control, leveraging dense supervision from diverse motion-capture data to acquire human motion priors without manual reward engineering. We build a foundation model for motion tracking by scaling along three axes: network size (1.2M to 42M parameters), dataset volume (100M+ frames from 700 hours of motion capture), and compute (21k GPU hours). Beyond demonstrating the benefits of scale, we further show downstream utility through a real-time kinematic planner that bridges motion tracking to tasks such as navigation, enabling natural and interactive control, as well as a unified token space that supports virtual reality (VR) teleoperation and vision-language-action (VLA) models with a single policy. Through this interface, we demonstrate autonomous VLA-driven whole-body loco-manipulation requiring coordinated hand and foot placement. Scaling motion tracking exhibits favorable properties: performance improves steadily with compute and data diversity, and learned policies generalize to unseen motions, establishing motion tracking at scale as a practical foundation for humanoid control.
