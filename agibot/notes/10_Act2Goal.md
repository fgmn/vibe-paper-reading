---
id: "10"
org: 智元
short: "Act2Goal"
title: "Act2Goal: From World Model To General Goal-conditioned Policy"
aliases: ["Act2Goal"]
date: 2025-12-29
category: "世界模型"
source: "智元主导"
product: ""
partners: []
authors: ["Pengfei Zhou", "Liliang Chen", "Shengcong Chen", "Di Chen", "Wenzhi Zhao", "Rongjun Jin", "Guanghui Ren", "Jianlan Luo"]
arxiv: "2512.23541"
pdf: "[[agibot/papers/10_2512.23541_Act2Goal.pdf]]"
code: ""
project: "https://act2goal.github.io/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# Act2Goal: From World Model To General Goal-conditioned Policy

> [!info] 论文信息
> arXiv [2512.23541](https://arxiv.org/abs/2512.23541) · v1 2025-12-29 · 发表：RSS 2026（据 agibot.com/research）
> PDF：[[agibot/papers/10_2512.23541_Act2Goal.pdf|本地 PDF]]
> [项目页](https://act2goal.github.io/)
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：Act2Goal：目标条件视觉世界模型结合多尺度时间控制的通用目标条件操作策略，并支持在线自适应。
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

> Specifying robotic manipulation tasks in a manner that is both expressive and precise remains a central challenge. While visual goals provide a compact and unambiguous task specification, existing goal-conditioned policies often struggle with long-horizon manipulation due to their reliance on single-step action prediction without explicit modeling of task progress. We propose Act2Goal, a general goal-conditioned manipulation policy that integrates a goal-conditioned visual world model with multi-scale temporal control. Given a current observation and a target visual goal, the world model generates a plausible sequence of intermediate visual states that captures long-horizon structure. To translate this visual plan into robust execution, we introduce Multi-Scale Temporal Hashing (MSTH), which decomposes the imagined trajectory into dense proximal frames for fine-grained closed-loop control and sparse distal frames that anchor global task consistency. The policy couples these representations with motor control through end-to-end cross-attention, enabling coherent long-horizon behavior while remaining reactive to local disturbances. Act2Goal achieves strong zero-shot generalization to novel objects, spatial layouts, and environments. We further enable reward-free online adaptation through hindsight goal relabeling with LoRA-based finetuning, allowing rapid autonomous improvement without external supervision. Real-robot experiments demonstrate that Act2Goal improves success rates from 30% to 90% on challenging out-of-distribution tasks within minutes of autonomous interaction, validating that goal-conditioned world models with multi-scale temporal control provide structured guidance necessary for robust long-horizon manipulation. Project page: this https URL
