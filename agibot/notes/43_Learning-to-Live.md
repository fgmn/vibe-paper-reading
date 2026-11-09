---
id: "43"
org: 智元
short: "Learning to Live"
title: "Learning to Live: A Step Toward Lifelong Embodied Intelligence"
aliases: ["Learning to Live"]
date: 2026-10-30
category: "其他"
source: "智元主导"
product: ""
partners: []
authors: ["Lirong Che", "Peidong Wang", "Yimeng Su", "Jiong Wang", "Yang Chen", "Wenbo Fu", "Zhenyu Huang", "Tiancheng Xu", "Yuzhe Yang", "Dongli Xie", "Xu Cao", "Chuang Wang", "Daqi Liu", "Jian Su"]
arxiv: "2611.00180"
pdf: "[[agibot/papers/43_2611.00180_Learning-to-Live.pdf]]"
code: "https://github.com/AgibotTech/LIFE"
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# Learning to Live: A Step Toward Lifelong Embodied Intelligence

> [!info] 论文信息
> arXiv [2611.00180](https://arxiv.org/abs/2611.00180) · v1 2026-10-30 · 最新 v2（2026-11-04）
> PDF：[[agibot/papers/43_2611.00180_Learning-to-Live.pdf|本地 PDF]]
> [代码](https://github.com/AgibotTech/LIFE)
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：LIFE：机器人持续观察、选择性记忆并把经验转化为新能力的终身具身智能框架。
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

> Embodied agents are usually organized around individual tasks, yet the physical world keeps changing between tasks and during execution. We introduce LIFE (Lifelong Intelligence from Experience), a framework in which a robot observes continuously, remembers selectively, and turns experience into new capabilities. RoboBeats, a family of lightweight streaming gates, tracks conditions set by the agent and discovers new events, deciding when an observation warrants a response or a memory write. Selected observations enter Plastic Memory, a flat store of images and structured records that keeps the source evidence, so new fields and indexes can be added when later questions need them. When existing tools fall short, Explore-Distill-Mount (EDM) turns solutions found during problem solving into validated, reusable tools and skills. Under matched protocols, RoboBeats substantially improves condition tracking over its base models and, at the same writing budget, retains more useful evidence for memory question answering than uniform sampling. A case study of limited scale, replaying 24 hours of continuous video recorded by a real robot, illustrates how the integrated system builds memory from a day of experience and uses it to answer everyday questions. LIFE takes a step toward robots that become more familiar with their surroundings and more capable through experience: learning not only to complete tasks, but to live in the world.
