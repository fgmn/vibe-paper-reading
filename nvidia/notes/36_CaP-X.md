---
id: "36"
org: 英伟达
short: "CaP-X"
title: "CaP-X: A Framework for Benchmarking and Improving Coding Agents for Robot Manipulation"
aliases: ["CaP-X"]
date: 2026-03-23
category: "操作与其他"
source: "英伟达合作"
partners: []
authors: ["Letian Fu", "Justin Yu", "Karim El-Refai", "Ethan Kou", "Haoru Xue", "Huang Huang", "Wenli Xiao", "Guanzhi Wang", "Dantong Niu", "Fei-Fei Li", "Guanya Shi", "Jiajun Wu", "Shankar Sastry", "Yuke Zhu", "Ken Goldberg", "Linxi \"Jim\" Fan"]
arxiv: "2603.22435"
pdf: "[[nvidia/papers/36_2603.22435_CaP-X.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# CaP-X: A Framework for Benchmarking and Improving Coding Agents for Robot Manipulation

> [!info] 论文信息
> arXiv [2603.22435](https://arxiv.org/abs/2603.22435) · v1 2026-03-23 · 最新 v2（2026-07-02）
> PDF：[[nvidia/papers/36_2603.22435_CaP-X.pdf|本地 PDF]]
> 系列：物理AI · 操作与其他 · 角色：英伟达合作
> 清单里的一句话（Claude 根据摘要写，请核对）：CaP-X：系统评测与改进机器人操作中 Code-as-Policy 编码智能体的开放框架。
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

> "Code-as-Policy" considers how executable code can complement data-intensive Vision-Language-Action (VLA) methods, yet their effectiveness as autonomous controllers for embodied manipulation remains underexplored. We present CaP-X, an open-access framework for systematically studying Code-as-Policy agents in robot manipulation. At its core is CaP-Gym, an interactive environment in which agents control robots by synthesizing and executing programs that compose perception and control primitives. Building on this foundation, CaP-Bench evaluates frontier language and vision-language models across varying levels of abstraction, interaction, and perceptual grounding. Across 12 models, CaP-Bench reveals a consistent trend: performance improves with human-crafted abstractions but degrades as these priors are removed, exposing a dependence on designer scaffolding. At the same time, we observe that this gap can be mitigated through scaling agentic test-time computation--through multi-turn interaction, structured execution feedback, visual differencing, automatic skill synthesis, and ensembled reasoning--substantially improves robustness even when agents operate over low-level primitives. These findings allow us to derive CaP-Agent0, a training-free framework that recovers human-level reliability on several manipulation tasks in simulation and on real embodiments. We further introduce CaP-RL, showing reinforcement learning with verifiable rewards improves success rates and transfers from sim2real with minimal gap. Together, CaP-X provides a principled, open-access platform for advancing embodied coding agents.
