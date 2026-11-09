---
id: "09"
org: 智元
short: "WholeBodyVLA"
title: "WholeBodyVLA: Towards Unified Latent VLA for Whole-Body Loco-Manipulation Control"
aliases: ["WholeBodyVLA"]
date: 2025-12-11
category: "运动控制"
source: "智元合作"
product: "灵犀 X2"
partners: []
authors: ["Haoran Jiang", "Jin Chen", "Qingwen Bu", "Li Chen", "Modi Shi", "Yanjie Zhang", "Delong Li", "Chuanzhe Suo", "Chuang Wang", "Zhihui Peng", "Hongyang Li"]
arxiv: "2512.11047"
pdf: "[[agibot/papers/09_2512.11047_WholeBodyVLA.pdf]]"
code: "https://github.com/OpenDriveLab/WholebodyVLA"
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot", "lingxi"]
---

# WholeBodyVLA: Towards Unified Latent VLA for Whole-Body Loco-Manipulation Control

> [!info] 论文信息
> arXiv [2512.11047](https://arxiv.org/abs/2512.11047) · v1 2025-12-11 · 最新 v2（2025-12-15） · 发表：ICLR 2026（据 GitHub README）
> PDF：[[agibot/papers/09_2512.11047_WholeBodyVLA.pdf|本地 PDF]]
> [代码](https://github.com/OpenDriveLab/WholebodyVLA)
> 角色：智元合作 · 机型：灵犀 X2
> 清单里的一句话（Claude 根据摘要写，请核对）：WholeBodyVLA：用人类第一视角视频学潜在动作，结合 RL 底层控制实现人形全身移动操作。
> 灵犀依据：Comprehensive experiments on the Agibot X2 show that WholeBodyVLA surpasses prior baselines by 21.3% and 24.0%, while demonstrating strong generalization and broad task coverage.（https://arxiv.org/html/2512.11047 (Introduction; authors from Fudan, OpenDriveLab/HKU, AgiBot incl. Zhihui Peng)）
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

> Humanoid robots require precise locomotion and dexterous manipulation to perform challenging loco-manipulation tasks. Yet existing approaches, modular or end-to-end, are deficient in manipulation-aware locomotion. This confines the robot to a limited workspace, preventing it from performing large-space loco-manipulation. We attribute this to: (1) the challenge of acquiring loco-manipulation knowledge due to the scarcity of humanoid teleoperation data, and (2) the difficulty of faithfully and reliably executing locomotion commands, stemming from the limited precision and stability of existing RL controllers. To acquire richer loco-manipulation knowledge, we propose a unified latent learning framework that enables Vision-Language-Action (VLA) system to learn from low-cost action-free egocentric videos. Moreover, an efficient human data collection pipeline is devised to augment the dataset and scale the benefits. To execute the desired locomotion commands more precisely, we present a loco-manipulation-oriented (LMO) RL policy specifically tailored for accurate and stable core loco-manipulation movements, such as advancing, turning, and squatting. Building on these components, we introduce WholeBodyVLA, a unified framework for humanoid loco-manipulation. To the best of our knowledge, WholeBodyVLA is one of its kind enabling large-space humanoid loco-manipulation. It is verified via comprehensive experiments on the AgiBot X2 humanoid, outperforming prior baseline by 21.3%. It also demonstrates strong generalization and high extensibility across a broad range of tasks.
