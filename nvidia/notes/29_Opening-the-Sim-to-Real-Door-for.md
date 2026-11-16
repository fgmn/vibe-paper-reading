---
id: "29"
org: 英伟达
short: "Opening the Sim-to-Real Door for Humanoid Pixel-to-Action Policy Transfer"
title: "Opening the Sim-to-Real Door for Humanoid Pixel-to-Action Policy Transfer"
aliases: ["Opening the Sim-to-Real Door for Humanoid Pixel-to-Action Policy Transfer"]
date: 2025-11-30
category: "人形全身控制"
source: "英伟达主导"
partners: []
authors: ["Haoru Xue", "Tairan He", "Zi Wang", "Qingwei Ben", "Wenli Xiao", "Zhengyi Luo", "Xingye Da", "Fernando Castañeda", "Guanya Shi", "Shankar Sastry", "Linxi \"Jim\" Fan", "Yuke Zhu"]
arxiv: "2512.01061"
pdf: "[[nvidia/papers/29_2512.01061_Opening-the-Sim-to-Real-Door-for.pdf]]"
code: ""
project: "https://doorman-humanoid.github.io/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# Opening the Sim-to-Real Door for Humanoid Pixel-to-Action Policy Transfer

> [!info] 论文信息
> arXiv [2512.01061](https://arxiv.org/abs/2512.01061) · v1 2025-11-30
> PDF：[[nvidia/papers/29_2512.01061_Opening-the-Sim-to-Real-Door-for.pdf|本地 PDF]]
> [项目页](https://doorman-humanoid.github.io/)
> 系列：物理AI · 人形全身控制 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：DoorMan：仅用 RGB 的人形开门策略，完全在 Isaac 仿真中训练并零样本迁移到真实机器人，展示像素到动作的 sim-to-real。
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

> Recent progress in GPU-accelerated, photorealistic simulation has opened a scalable data-generation path for robot learning, where massive physics and visual randomization allow policies to generalize beyond curated environments. Building on these advances, we develop a teacher-student-bootstrap learning framework for vision-based humanoid loco-manipulation, using articulated-object interaction as a representative high-difficulty benchmark. Our approach introduces a staged-reset exploration strategy that stabilizes long-horizon privileged-policy training, and a GRPO-based fine-tuning procedure that mitigates partial observability and improves closed-loop consistency in sim-to-real RL. Trained entirely on simulation data, the resulting policy achieves robust zero-shot performance across diverse door types and outperforms human teleoperators by up to 31.7% in task completion time under the same whole-body control stack. This represents the first humanoid sim-to-real policy capable of diverse articulated loco-manipulation using pure RGB perception.
