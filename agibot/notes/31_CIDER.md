---
id: "31"
org: 智元
short: "CIDER"
title: "CIDER: Continual Interactive Distillation for Embodied Reinforcement Learning"
aliases: ["CIDER"]
date: 2026-08-22
category: "VLA/基础模型"
source: "智元主导"
product: ""
partners: []
authors: ["Houlin Li", "Minghui Xu", "Guo Xu", "Xuan Du", "Xiaohan Yan", "Chun Wang", "Yuxiang Yan", "Shukai Yang", "Yongcheng Liu", "Wei Shan", "Maoqing Yao"]
arxiv: "2608.21899"
pdf: "[[agibot/papers/31_2608.21899_CIDER.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# CIDER: Continual Interactive Distillation for Embodied Reinforcement Learning

> [!info] 论文信息
> arXiv [2608.21899](https://arxiv.org/abs/2608.21899) · v1 2026-08-22
> PDF：[[agibot/papers/31_2608.21899_CIDER.pdf|本地 PDF]]
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：CIDER：人在回路真实世界持续强化学习，用交互式蒸馏约束旧行为、缓解灾难性遗忘。
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

> Human-in-the-loop real-world reinforcement learning enables rapid acquisition of effective robotic manipulation policies for individual tasks, often within tens of minutes. Yet it remains unclear how to extend this paradigm to continual learning, where a single policy must acquire new skills without losing previously learned behaviors. Existing real-world continual learning methods do not explicitly constrain prior behaviors, leading to severe catastrophic forgetting. We introduce Continual Interactive Distillation for Embodied Reinforcement Learning (CIDER), a continual reinforcement learning framework that freezes the accumulated historical policy as a teacher before learning each new task and interleaves task learning with distillation-based retention. We further introduce gradient routing to separate the gradients used for acquiring new tasks from those used for preserving prior behaviors. We evaluate our method with a single shared actor on six real-world household and industrial manipulation tasks. Interactive Distillation maintains high measured success on previously learned tasks across our six-task real-robot sequence while acquiring each new task in 10 to 20 minutes, whereas every baseline forgets at least one previous task. Additional ablations reveal the key design choices that govern the tradeoff between stability and plasticity in real-world continual reinforcement learning.
