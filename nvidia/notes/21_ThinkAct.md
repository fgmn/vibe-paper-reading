---
id: "21"
org: 英伟达
short: "ThinkAct"
title: "ThinkAct: Vision-Language-Action Reasoning via Reinforced Visual Latent Planning"
aliases: ["ThinkAct"]
date: 2025-07-22
category: "操作与其他"
source: "英伟达主导"
partners: []
authors: ["Chi-Pin Huang", "Yueh-Hua Wu", "Min-Hung Chen", "Yu-Chiang Frank Wang", "Fu-En Yang"]
arxiv: "2507.16815"
pdf: "[[nvidia/papers/21_2507.16815_ThinkAct.pdf]]"
code: ""
project: "https://jasper0314-huang.github.io/thinkact-vla/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# ThinkAct: Vision-Language-Action Reasoning via Reinforced Visual Latent Planning

> [!info] 论文信息
> arXiv [2507.16815](https://arxiv.org/abs/2507.16815) · v1 2025-07-22 · 最新 v2（2025-09-18） · 发表：NeurIPS 2025
> PDF：[[nvidia/papers/21_2507.16815_ThinkAct.pdf|本地 PDF]]
> [项目页](https://jasper0314-huang.github.io/thinkact-vla/)
> 系列：物理AI · 操作与其他 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：ThinkAct：用强化的视觉潜规划连接高层推理与低层动作执行的双系统 VLA 推理框架。
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

> Vision-language-action (VLA) reasoning tasks require agents to interpret multimodal instructions, perform long-horizon planning, and act adaptively in dynamic environments. Existing approaches typically train VLA models in an end-to-end fashion, directly mapping inputs to actions without explicit reasoning, which hinders their ability to plan over multiple steps or adapt to complex task variations. In this paper, we propose ThinkAct, a dual-system framework that bridges high-level reasoning with low-level action execution via reinforced visual latent planning. ThinkAct trains a multimodal LLM to generate embodied reasoning plans guided by reinforcing action-aligned visual rewards based on goal completion and trajectory consistency. These reasoning plans are compressed into a visual plan latent that conditions a downstream action model for robust action execution on target environments. Extensive experiments on embodied reasoning and robot manipulation benchmarks demonstrate that ThinkAct enables few-shot adaptation, long-horizon planning, and self-correction behaviors in complex embodied AI tasks.
