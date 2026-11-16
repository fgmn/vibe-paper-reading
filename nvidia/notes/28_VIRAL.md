---
id: "28"
org: 英伟达
short: "VIRAL"
title: "VIRAL: Visual Sim-to-Real at Scale for Humanoid Loco-Manipulation"
aliases: ["VIRAL"]
date: 2025-11-19
category: "人形全身控制"
source: "英伟达主导"
partners: []
authors: ["Tairan He", "Zi Wang", "Haoru Xue", "Qingwei Ben", "Zhengyi Luo", "Wenli Xiao", "Ye Yuan", "Xingye Da", "Fernando Castañeda", "Shankar Sastry", "Changliu Liu", "Guanya Shi", "Linxi Fan", "Yuke Zhu"]
arxiv: "2511.15200"
pdf: "[[nvidia/papers/28_2511.15200_VIRAL.pdf]]"
code: ""
project: "https://viral-humanoid.github.io/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# VIRAL: Visual Sim-to-Real at Scale for Humanoid Loco-Manipulation

> [!info] 论文信息
> arXiv [2511.15200](https://arxiv.org/abs/2511.15200) · v1 2025-11-19 · 最新 v2（2025-11-27）
> PDF：[[nvidia/papers/28_2511.15200_VIRAL.pdf|本地 PDF]]
> [项目页](https://viral-humanoid.github.io/)
> 系列：物理AI · 人形全身控制 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：VIRAL：完全在仿真中以大规模视觉特权蒸馏学习人形移动操作，零样本部署到真实 Unitree G1。
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

> A key barrier to the real-world deployment of humanoid robots is the lack of autonomous loco-manipulation skills. We introduce VIRAL, a visual sim-to-real framework that learns humanoid loco-manipulation entirely in simulation and deploys it zero-shot to real hardware. VIRAL follows a teacher-student design: a privileged RL teacher, operating on full state, learns long-horizon loco-manipulation using a delta action space and reference state initialization. A vision-based student policy is then distilled from the teacher via large-scale simulation with tiled rendering, trained with a mixture of online DAgger and behavior cloning. We find that compute scale is critical: scaling simulation to tens of GPUs (up to 64) makes both teacher and student training reliable, while low-compute regimes often fail. To bridge the sim-to-real gap, VIRAL combines large-scale visual domain randomization over lighting, materials, camera parameters, image quality, and sensor delays--with real-to-sim alignment of the dexterous hands and cameras. Deployed on a Unitree G1 humanoid, the resulting RGB-based policy performs continuous loco-manipulation for up to 54 cycles, generalizing to diverse spatial and appearance variations without any real-world fine-tuning, and approaching expert-level teleoperation performance. Extensive ablations dissect the key design choices required to make RGB-based humanoid loco-manipulation work in practice.
