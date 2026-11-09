---
id: "26"
org: 智元
short: "SSR"
title: "SSR: Scaling Surefooted and Symmetric Humanoid Traversal to the Open World"
aliases: ["SSR"]
date: 2026-05-29
category: "运动控制"
source: "其他团队使用"
product: "灵犀 X2"
partners: []
authors: ["Ruiqi Yu", "Yiwen Wang", "Yuan Hao", "Jun WU", "Qiuguo Zhu"]
arxiv: "2605.30770"
pdf: "[[agibot/papers/26_2605.30770_SSR.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot", "lingxi"]
---

# SSR: Scaling Surefooted and Symmetric Humanoid Traversal to the Open World

> [!info] 论文信息
> arXiv [2605.30770](https://arxiv.org/abs/2605.30770) · v1 2026-05-29
> PDF：[[agibot/papers/26_2605.30770_SSR.pdf|本地 PDF]]
> 角色：其他团队使用 · 机型：灵犀 X2
> 清单里的一句话（Claude 根据摘要写，请核对）：基于自我中心视觉的端到端人形地形穿越框架，含想象落脚点引导与等变对称，部署于智元X2。
> 灵犀依据：We deploy our policy on the AgiBot X2 humanoid robot, which has 29 joints, stands 1.31 m tall, and weighs approximately 39 kg.（https://arxiv.org/html/2605.30770 (Real-world deployment section; Zhejiang Univ.; acknowledges AgiBot hardware support)）
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

> Extending humanoid traversal to the open world is key to practical deployment in human environments, but remains challenging. The robot must use vision to ensure safe and reliable foot placement on heterogeneous terrain under highly dynamic motion, while producing coordinated, natural whole-body behaviors. We propose SSR, an efficient end-to-end framework for egocentric vision-based humanoid traversal that jointly learns these capabilities. SSR introduces imagined foothold guidance, which learns to model forthcoming swing-foot contacts and evaluates their support to guide pre-touchdown swings toward stable regions, reducing edge slips. It further employs equivariant latent-space symmetry augmentation to efficiently induce bilateral coordination under high-dimensional visual observations, and uses terrain-specific multi-discriminator motion priors to encourage human-like behavior across scenes. Extensive experiments show that SSR achieves safe, stable, and high-quality locomotion on diverse real-world terrains, including stairs with varied structures and extreme challenges such as wide gaps and high platforms, while enabling reliable long-horizon traversal in open outdoor environments.
