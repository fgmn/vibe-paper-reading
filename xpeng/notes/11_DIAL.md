---
id: "11"
org: 小鹏
short: "DIAL"
title: "DIAL: Decoupling Intent and Action via Latent World Modeling for End-to-End VLA"
aliases: ["DIAL"]
date: 2026-03-31
category: "机器人"
source: "小鹏主导"
product: "通用（人形VLA）"
partners: []
authors: ["Yi Chen", "Yuying Ge", "Hui Zhou", "Mingyu Ding", "Yixiao Ge", "Xihui Liu"]
arxiv: "2603.29844"
pdf: "[[xpeng/papers/11_2603.29844_DIAL.pdf]]"
code: ""
project: "https://xpeng-robotics.github.io/dial"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# DIAL: Decoupling Intent and Action via Latent World Modeling for End-to-End VLA

> [!info] 论文信息
> arXiv [2603.29844](https://arxiv.org/abs/2603.29844) · v1 2026-03-31 · 最新 v2（2026-04-28）
> PDF：[[xpeng/papers/11_2603.29844_DIAL.pdf|本地 PDF]]
> [项目页](https://xpeng-robotics.github.io/dial)
> 方向：机器人 · 角色：小鹏主导 · 产品：通用（人形VLA）
> 清单里的一句话（Claude 根据摘要写，请核对）：【XPENG Robotics】DIAL：用潜在世界建模解耦意图与动作的端到端VLA。
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

> The development of Vision-Language-Action (VLA) models has been significantly accelerated by pre-trained Vision-Language Models (VLMs). However, most existing end-to-end VLAs treat the VLM primarily as a multimodal encoder, directly mapping vision-language features to low-level actions. This paradigm underutilizes the VLM's potential in high-level decision making and introduces training instability, frequently degrading its rich semantic representations. To address these limitations, we introduce DIAL, a framework bridging high-level decision making and low-level motor execution through a differentiable latent intent bottleneck. Specifically, a VLM-based System-2 performs latent world modeling by synthesizing latent visual foresight within the VLM's native feature space; this foresight explicitly encodes intent and serves as the structural bottleneck. A lightweight System-1 policy then decodes this predicted intent together with the current observation into precise robot actions via latent inverse dynamics. To ensure optimization stability, we employ a two-stage training paradigm: a decoupled warmup phase where System-2 learns to predict latent futures while System-1 learns motor control under ground-truth future guidance within a unified feature space, followed by seamless end-to-end joint optimization. This enables action-aware gradients to refine the VLM backbone in a controlled manner, preserving pre-trained knowledge. Extensive experiments on the RoboCasa GR1 Tabletop benchmark show that DIAL establishes a new state-of-the-art, achieving superior performance with 10x fewer demonstrations than prior methods. Furthermore, by leveraging heterogeneous human demonstrations, DIAL learns physically grounded manipulation priors and exhibits robust zero-shot generalization to unseen objects and novel configurations during real-world deployment on a humanoid robot.
