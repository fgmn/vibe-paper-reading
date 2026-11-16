---
id: "06"
org: 英伟达
short: "HOVER"
title: "HOVER: Versatile Neural Whole-Body Controller for Humanoid Robots"
aliases: ["HOVER"]
date: 2024-10-28
category: "人形全身控制"
source: "英伟达合作"
partners: []
authors: ["Tairan He", "Wenli Xiao", "Toru Lin", "Zhengyi Luo", "Zhenjia Xu", "Zhenyu Jiang", "Jan Kautz", "Changliu Liu", "Guanya Shi", "Xiaolong Wang", "Linxi Fan", "Yuke Zhu"]
arxiv: "2410.21229"
pdf: "[[nvidia/papers/06_2410.21229_HOVER.pdf]]"
code: "https://github.com/NVlabs/HOVER"
project: "https://hover-versatile-humanoid.github.io/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# HOVER: Versatile Neural Whole-Body Controller for Humanoid Robots

> [!info] 论文信息
> arXiv [2410.21229](https://arxiv.org/abs/2410.21229) · v1 2024-10-28 · 最新 v2（2025-03-06） · 发表：ICRA 2025
> PDF：[[nvidia/papers/06_2410.21229_HOVER.pdf|本地 PDF]]
> [代码](https://github.com/NVlabs/HOVER) · [项目页](https://hover-versatile-humanoid.github.io/)
> 系列：物理AI · 人形全身控制 · 角色：英伟达合作
> 清单里的一句话（Claude 根据摘要写，请核对）：HOVER：以全身运动模仿为统一抽象，蒸馏出支持多种控制模式（根速度、关节、末端等）的人形通用控制器。
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

> Humanoid whole-body control requires adapting to diverse tasks such as navigation, loco-manipulation, and tabletop manipulation, each demanding a different mode of control. For example, navigation relies on root velocity tracking, while tabletop manipulation prioritizes upper-body joint angle tracking. Existing approaches typically train individual policies tailored to a specific command space, limiting their transferability across modes. We present the key insight that full-body kinematic motion imitation can serve as a common abstraction for all these tasks and provide general-purpose motor skills for learning multiple modes of whole-body control. Building on this, we propose HOVER (Humanoid Versatile Controller), a multi-mode policy distillation framework that consolidates diverse control modes into a unified policy. HOVER enables seamless transitions between control modes while preserving the distinct advantages of each, offering a robust and scalable solution for humanoid control across a wide range of modes. By eliminating the need for policy retraining for each control mode, our approach improves efficiency and flexibility for future humanoid applications.
