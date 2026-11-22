---
id: "34"
org: 小鹏
short: "Principal Steering Subspaces for Online Adaptation of Frozen Generative Robot Policies"
title: "Principal Steering Subspaces for Online Adaptation of Frozen Generative Robot Policies"
aliases: ["Principal Steering Subspaces for Online Adaptation of Frozen Generative Robot Policies"]
date: 2026-09-27
category: "机器人"
source: "小鹏主导"
product: "通用（人形策略适配）"
partners: []
authors: ["Jialeng Ni", "Nathan Zhao", "Kunpeng Song"]
arxiv: "2609.33765"
pdf: "[[xpeng/papers/34_2609.33765_Principal-Steering-Subspaces-for-Online.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# Principal Steering Subspaces for Online Adaptation of Frozen Generative Robot Policies

> [!info] 论文信息
> arXiv [2609.33765](https://arxiv.org/abs/2609.33765) · v1 2026-09-27
> PDF：[[xpeng/papers/34_2609.33765_Principal-Steering-Subspaces-for-Online.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏主导 · 产品：通用（人形策略适配）
> 清单里的一句话（Claude 根据摘要写，请核对）：提出主转向子空间PSS，通过控制初始噪声在线适配冻结的生成式机器人策略，并做人形适配探索。
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

> Generative robot policies provide expressive behavior priors, but updating a large diffusion or flow-matching model through online interaction is costly. Latent-space reinforcement learning avoids updating the pretrained generator by controlling its initial sampling noise, yet high-dimensional noise can have strongly anisotropic effects on decoded actions. We introduce Principal Steering Subspaces (PSS), a forward-query interface that constructs a fixed low-dimensional control basis from finite-difference decoder responses. Soft Actor-Critic controls the leading response directions, while the orthogonal complement is independently resampled from the Gaussian prior at each query. On three RoboMimic tasks with diffusion and flow-matching policies, response spectra reveal substantial concentration. Across five matched task-generator pairs, the training curves indicate that PSS generally converges faster and exhibits more stable late-training behavior than full-latent control, while achieving stronger final performance overall. Controlled Diffusion-Square ablations further show that leading-response directions outperform random and least-responsive subspaces of equal dimension. We further integrate PSS with a frozen, closed-source 3B-parameter vision-language-action (VLA) policy in a humanoid learning system with synchronous transition collection, reset-time optimization, and latency-aware asynchronous deployment. In an exploratory screwdriver-placement evaluation, success is observed in 2/10 trials for the frozen VLA policy and 6/10 after SAC+PSS adaptation. These results support decoder-response geometry as a practical basis for online adaptation of frozen generative robot policies.
