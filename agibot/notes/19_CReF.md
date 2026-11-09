---
id: "19"
org: 智元
short: "CReF"
title: "CReF: Cross-modal and Recurrent Fusion for Depth-conditioned Humanoid Locomotion"
aliases: ["CReF"]
date: 2026-03-31
category: "运动控制"
source: "其他团队使用"
product: "灵犀 X2（X2 Ultra）"
partners: []
authors: ["Yuan Hao", "Ruiqi Yu", "Shixin Luo", "Guoteng Zhang", "Jun Wu", "Qiuguo Zhu"]
arxiv: "2603.29452"
pdf: "[[agibot/papers/19_2603.29452_CReF.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot", "lingxi"]
---

# CReF: Cross-modal and Recurrent Fusion for Depth-conditioned Humanoid Locomotion

> [!info] 论文信息
> arXiv [2603.29452](https://arxiv.org/abs/2603.29452) · v1 2026-03-31 · 最新 v3（2026-07-27）
> PDF：[[agibot/papers/19_2603.29452_CReF.pdf|本地 PDF]]
> 角色：其他团队使用 · 机型：灵犀 X2（X2 Ultra）
> 清单里的一句话（Claude 根据摘要写，请核对）：单阶段深度条件人形行走框架，直接从原始深度学习落脚相关特征，在X2 Ultra上零样本越障。
> 灵犀依据：Our deployment platform is an AGIBOT X2 Ultra humanoid [ 28 ] , which is approximately 1.31 m tall, weighs 39 kg.（https://arxiv.org/html/2603.29452 (Sec. III-A Experimental Setup; Zhejiang Univ.; IEEE RA-L)）
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

> Stable traversal over geometrically complex terrain increasingly requires exteroceptive perception, yet prior perceptive humanoid locomotion methods often remain tied to explicit geometric abstractions, either by mediating control through robot-centric 2.5D terrain representations or by shaping depth learning with auxiliary geometry-related targets. While effective, these approaches introduce additional map-construction procedures or multi-stage skill-transfer processes beyond direct depth-to-control learning. We propose CReF (Cross-modal and Recurrent Fusion), a single-stage depth-conditioned humanoid locomotion framework that learns locomotion-relevant features directly from raw forward-facing depth without explicit geometric intermediates. CReF couples proprioception and depth tokens through proprioception-queried cross-modal attention, fuses the resulting representation with a gated residual fusion block, and performs temporal integration with a Gated Recurrent Unit (GRU) regulated by a highway-style output gate for state-dependent blending of recurrent and feedforward features. To further improve terrain interaction, we introduce a terrain-aware foothold placement reward that extracts supportable foothold candidates from foot-end point-cloud samples and rewards touchdown locations that lie close to the nearest supportable candidate. Experiments in simulation and on a physical humanoid demonstrate robust traversal over diverse terrains and effective zero-shot transfer to real-world scenes containing handrails, hollow pallet assemblies, severe reflective interference, and visually cluttered outdoor surroundings.
