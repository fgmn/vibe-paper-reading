---
id: "11"
org: 智元
short: "Unified Embodied VLM Reasoning with Robotic Action via Autoregressive Discretized Pre-training"
title: "Unified Embodied VLM Reasoning with Robotic Action via Autoregressive Discretized Pre-training"
aliases: ["Unified Embodied VLM Reasoning with Robotic Action via Autoregressive Discretized Pre-training"]
date: 2025-12-30
category: "VLA/基础模型"
source: "智元主导"
product: ""
partners: []
authors: ["Yi Liu", "Sukai Wang", "Dafeng Wei", "Xiaowei Cai", "Linqing Zhong", "Jiange Yang", "Guanghui Ren", "Jinyu Zhang", "Maoqing Yao", "Chuankang Li", "Xindong He", "Liliang Chen", "Jianlan Luo"]
arxiv: "2512.24125"
pdf: "[[agibot/papers/11_2512.24125_Unified-Embodied-VLM-Reasoning-with.pdf]]"
code: ""
project: "https://geniereasoner.github.io/GenieReasoner/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# Unified Embodied VLM Reasoning with Robotic Action via Autoregressive Discretized Pre-training

> [!info] 论文信息
> arXiv [2512.24125](https://arxiv.org/abs/2512.24125) · v1 2025-12-30 · 最新 v3（2026-07-26）
> PDF：[[agibot/papers/11_2512.24125_Unified-Embodied-VLM-Reasoning-with.pdf|本地 PDF]]
> [项目页](https://geniereasoner.github.io/GenieReasoner/)
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：GenieReasoner/UniFact：以离散动作 token（FACT）统一 VLM 推理与动作预训练，并提出 ERIQ 推理基准。
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

> General-purpose robotic systems operating in open-world environments must achieve both broad generalization and high-precision action execution, a combination that remains challenging for existing Vision-Language-Action (VLA) models. While large Vision-Language Models (VLMs) improve semantic generalization, insufficient embodied reasoning leads to brittle behavior, and conversely, strong reasoning alone is inadequate without precise control. To provide a decoupled and quantitative assessment of this bottleneck, we introduce Embodied Reasoning Intelligence Quotient (ERIQ), a large-scale embodied reasoning benchmark in robotic manipulation, comprising 6K+ question-answer pairs across four reasoning dimensions. By decoupling reasoning from execution, ERIQ enables systematic evaluation and reveals a strong positive correlation between embodied reasoning capability and end-to-end VLA generalization. To bridge the gap from reasoning to precise execution, we propose FACT, a flow-matching-based action tokenizer that converts continuous control into discrete sequences while preserving high-fidelity trajectory reconstruction. The resulting GenieReasoner jointly optimizes reasoning and action in a unified space, outperforming both continuous-action and prior discrete-action baselines in real-world tasks. Together, ERIQ and FACT provide a principled framework for diagnosing and overcoming the reasoning-precision trade-off, advancing robust, general-purpose robotic manipulation. Project page: this https URL
