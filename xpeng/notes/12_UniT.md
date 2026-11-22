---
id: "12"
org: 小鹏
short: "UniT"
title: "UniT: Toward a Unified Physical Language for Human-to-Humanoid Policy Learning and World Modeling"
aliases: ["UniT"]
date: 2026-04-21
category: "机器人"
source: "小鹏主导"
product: "通用（人形）"
partners: []
authors: ["Boyu Chen", "Yi Chen", "Lu Qiu", "Jerry Bai", "Yuying Ge", "Yixiao Ge"]
arxiv: "2604.19734"
pdf: "[[xpeng/papers/12_2604.19734_UniT.pdf]]"
code: ""
project: "https://xpeng-robotics.github.io/unit/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# UniT: Toward a Unified Physical Language for Human-to-Humanoid Policy Learning and World Modeling

> [!info] 论文信息
> arXiv [2604.19734](https://arxiv.org/abs/2604.19734) · v1 2026-04-21 · 最新 v2（2026-10-11）
> PDF：[[xpeng/papers/12_2604.19734_UniT.pdf|本地 PDF]]
> [项目页](https://xpeng-robotics.github.io/unit/)
> 方向：机器人 · 角色：小鹏主导 · 产品：通用（人形）
> 清单里的一句话（Claude 根据摘要写，请核对）：【XPENG Robotics/人形】UniT：统一潜在动作分词器，打通人到人形的策略学习与世界建模。
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

> Scaling humanoid foundation models is bottlenecked by the scarcity of robotic data. While massive egocentric human data offers a scalable alternative, bridging the cross-embodiment chasm remains a fundamental challenge due to kinematic mismatches. We introduce UniT (Unified Latent Action Tokenizer via Visual Anchoring), a framework that establishes a unified physical language for human-to-humanoid transfer. Grounded in the philosophy that heterogeneous kinematics share universal visual consequences, UniT employs a tri-branch cross-reconstruction mechanism: actions predict vision to anchor kinematics to physical outcomes, while vision reconstructs actions to filter out irrelevant visual confounders. Concurrently, a fusion branch synergies these purified modalities into a shared discrete latent space of embodiment-agnostic physical intents. We validate UniT across two paradigms: 1) Policy Learning (VLA-UniT): By predicting these unified tokens, it effectively leverages diverse human data to achieve state-of-the-art data efficiency and robust out-of-distribution (OOD) generalization on both humanoid simulation benchmark and real-world deployments, notably demonstrating zero-shot task transfer. 2) World Modeling (WM-UniT): By aligning cross-embodiment dynamics via unified tokens as conditions, it realizes direct human-to-humanoid action transfer. This alignment ensures that human data seamlessly translates into enhanced action controllability for humanoid video generation. Ultimately, by inducing a highly aligned cross-embodiment representation (empirically verified by t-SNE visualizations revealing the convergence of human and humanoid features into a shared manifold), UniT offers a scalable path to distill vast human knowledge into general-purpose humanoid capabilities.
