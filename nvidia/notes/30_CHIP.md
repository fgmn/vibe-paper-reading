---
id: "30"
org: 英伟达
short: "CHIP"
title: "CHIP: Adaptive Compliance for Humanoid Control through Hindsight Perturbation"
aliases: ["CHIP"]
date: 2025-12-16
category: "人形全身控制"
source: "英伟达主导"
partners: []
authors: ["Sirui Chen", "Zi-ang Cao", "Zhengyi Luo", "Fernando Castañeda", "Chenran Li", "Tingwu Wang", "Ye Yuan", "Linxi \"Jim\" Fan", "C. Karen Liu", "Yuke Zhu"]
arxiv: "2512.14689"
pdf: "[[nvidia/papers/30_2512.14689_CHIP.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# CHIP: Adaptive Compliance for Humanoid Control through Hindsight Perturbation

> [!info] 论文信息
> arXiv [2512.14689](https://arxiv.org/abs/2512.14689) · v1 2025-12-16 · 最新 v2（2026-02-09）
> PDF：[[nvidia/papers/30_2512.14689_CHIP.pdf|本地 PDF]]
> 系列：物理AI · 人形全身控制 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：CHIP：通过事后扰动训练可调末端刚度的即插即用模块，让人形在敏捷跟踪的同时实现自适应柔顺交互。
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

> Recent progress in humanoid robots has unlocked agile locomotion skills, including backflipping, running, and crawling. Yet it remains challenging for a humanoid robot to perform forceful manipulation tasks such as moving objects, wiping, and pushing a cart. We propose adaptive Compliance Humanoid control through hIsight Perturbation (CHIP), a plug-and-play module that enables controllable end-effector stiffness while preserving agile tracking of dynamic reference motions. CHIP is easy to implement and requires neither data augmentation nor additional reward tuning. We show that a generalist motion-tracking controller trained with CHIP can perform a diverse set of forceful manipulation tasks that require different end-effector compliance, such as multi-robot collaboration, wiping, box delivery, and door opening.
