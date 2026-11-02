---
id: "01"
org: 亮源
short: "Light-Loco-Parkour"
title: "Light-Loco-Parkour: Versatile Perceptive Whole-Body Locomotion via Multi-Skill Distillation"
aliases: ["Light-Loco-Parkour"]
date: 2026-08-01
category: 运动控制
source: 亮源主导
partners: []
authors: ["Hongming Chen", "Zhuoran Li", "Hongxi Wang", "Jiangpeng Hu", "Ziliang Li", "Peize Liu", "QingRui Zhao", "Xuhao Liu", "Liang Pan", "Ximin Lyu", "Yuntao Ma", "Tingxiang Fan"]
arxiv: "2608.02653"
pdf: "[[lightorigins/papers/01_2608.02653_Light-Loco-Parkour.pdf]]"
code: ""
project: "https://light-loco-parkour.github.io/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "humanoid", "parkour", "whole-body-control", "real2sim2real", "distillation"]
---

# Light-Loco-Parkour: Versatile Perceptive Whole-Body Locomotion via Multi-Skill Distillation

> [!info] 论文信息
> arXiv [2608.02653](https://arxiv.org/abs/2608.02653) · v1 2026-08-01
> PDF：[[lightorigins/papers/01_2608.02653_Light-Loco-Parkour.pdf|本地 PDF]]
> [项目页](https://light-loco-parkour.github.io/) · [技术博客](https://www.lightorigins.com/blog/lightparkour) · [官网 PDF](https://static.lightorigins.com/website/reports/lightparkour-technical-report_687a744.pdf)

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

> Existing humanoid whole-body control systems still fall short of the way humans move through cluttered terrain: they either track expressive whole-body references without terrain generalization, or react to terrain online while leaving the arms, torso, and knees largely unused. We present \texttt{Light-Loco-Parkour} (LLP), an end-to-end perceptive whole-body locomotion system that closes this gap with a single deployable policy. Conditioned only on onboard depth and a velocity command, the policy decides when to walk, balance, climb, step down, or vault, with no reference input, skill label, hand-coded gate, or runtime motion graph. Compared with prior humanoid systems, LLP makes three contributions. First, it introduces a whole-body perceptive-control pipeline that extends an RL-trained, velocity-tracking locomotion policy with parkour skills learned from object-interacting motions, so the same policy tracks velocity in open terrain, executes whole-body traversal at obstacles, and resumes locomotion afterward. Second, it acquires terrain-conditioned skills from sparse seeds by expanding a single motion into dynamically feasible, terrain-paired references across obstacle geometry, rather than relying on a large motion corpus. Third, it learns autonomous skill transitions from reward, letting the policy decide when and which whole-body skill to invoke from depth and command alone, with no one-hot skill label, hand-coded state machine, or runtime motion generator. Simulation and real-world experiments show high success across both benchmarked terrains and unseen obstacle variations, and the same policy transfers zero-shot to indoor and outdoor hardware experiments. These results demonstrate autonomous perceptive whole-body locomotion on a humanoid in outdoor settings, using only onboard sensing and a single deployable policy.
