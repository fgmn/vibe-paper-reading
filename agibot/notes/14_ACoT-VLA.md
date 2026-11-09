---
id: "14"
org: 智元
short: "ACoT-VLA"
title: "ACoT-VLA: Action Chain-of-Thought for Vision-Language-Action Models"
aliases: ["ACoT-VLA"]
date: 2026-01-16
category: "VLA/基础模型"
source: "智元主导"
product: ""
partners: []
authors: ["Linqing Zhong", "Yi Liu", "Yifei Wei", "Ziyu Xiong", "Maoqing Yao", "Si Liu", "Guanghui Ren"]
arxiv: "2601.11404"
pdf: "[[agibot/papers/14_2601.11404_ACoT-VLA.pdf]]"
code: "https://github.com/AgibotTech/ACoT-VLA"
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# ACoT-VLA: Action Chain-of-Thought for Vision-Language-Action Models

> [!info] 论文信息
> arXiv [2601.11404](https://arxiv.org/abs/2601.11404) · v1 2026-01-16 · 最新 v2（2026-03-30） · 发表：CVPR 2026
> PDF：[[agibot/papers/14_2601.11404_ACoT-VLA.pdf|本地 PDF]]
> [代码](https://github.com/AgibotTech/ACoT-VLA)
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：ACoT-VLA：以动作链式思维（显式/隐式动作推理）指导 VLA 动作生成。
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

> Vision-Language-Action models have emerged as essential generalist robot policies for diverse manipulation tasks, conventionally relying on directly translating multimodal inputs into actions via Vision-Language Model embeddings. Recent advancements have introduced explicit intermediary reasoning-such as sub-task prediction (language) or goal image synthesis (vision)-to guide action generation. However, these intermediate reasoning are often indirect and inherently limited in their capacity to convey the full, granular information required for precise action execution. Instead, we posit that the most effective form of reasoning is one that deliberates directly in the action space. We introduce Action Chain-of-Thought (ACoT), a paradigm where the reasoning process itself is formulated as a structured sequence of coarse action intents that guide the final policy. In this paper, we propose ACoT-VLA, a novel architecture that materializes the ACoT paradigm. Specifically, we introduce two complementary components: an Explicit Action Reasoner (EAR) and Implicit Action Reasoner (IAR). The former proposes coarse reference trajectories as explicit action-level reasoning steps, while the latter extracts latent action priors from internal representations of multimodal input, co-forming an ACoT that conditions the downstream action head to enable grounded policy learning. Extensive experiments in real-world and simulation environments demonstrate the superiority of our proposed method. Code is available at: this https URL.
