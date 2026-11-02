---
id: "15"
org: 自变量
short: "ManipArena"
title: "ManipArena: Comprehensive Real-world Evaluation of Reasoning-Oriented Generalist Robot Manipulation"
aliases: ["ManipArena"]
date: 2026-03-30
category: 评测基准
source: 合作
partners: ["中山大学", "MBZUAI", "清华大学"]
authors: ["Yu Sun", "Meng Cao", "Yang Ping", "Kaidong Zhang", "Qingxuan Chen", "Rongtao Xu", "Liangwang Ruan", "Xuecheng Chen", "Dongxiu Liu", "Yunxiao Yan", "Zunnan Xu", "Runze Xu", "Charles Yang", "Peilun Zhang", "Xiaofan Li", "Ruyi Gan", "Liang Ma", "Yuehao Yin", "Jincheng Yu", "Lufang Chen", "Yuxin Liang", "Peng Zhai", "Hao Wang", "Ivan Laptev", "Ian Reid", "Qian Wang", "Xiaodan Liang"]
arxiv: "2603.28545"
pdf: "[[xsquare/papers/15_2603.28545_ManipArena.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY-NC-SA 4.0
status: 未读
rating:
read_date:
tags: ["paper", "benchmark", "real-robot"]
---

# ManipArena: Comprehensive Real-world Evaluation of Reasoning-Oriented Generalist Robot Manipulation

> [!info] 论文信息
> arXiv [2603.28545](https://arxiv.org/abs/2603.28545) · v1 2026-03-30 · 最新 v2（2026-07-01）
> PDF：[[xsquare/papers/15_2603.28545_ManipArena.pdf|本地 PDF]]
> 合作单位：中山大学、MBZUAI、清华大学

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

> Vision-Language-Action (VLA) models and world-action models have emerged as central paradigms for general-purpose robotic intelligence, yet their empirical progress remains constrained by the absence of evaluation protocols that are both physically realistic and diagnostically controlled. Simulator-centric benchmarks provide scale and reproducibility, but cannot fully capture the reality gap induced by perception noise, contact dynamics, latency, calibration error, and hardware constraints. Conversely, real-robot evaluations are often fragmented across platforms, scenes, objects, and scoring rules, making fair comparison and failure attribution difficult. We introduce ManipArena, a standardized real-robot evaluation framework for studying manipulation generalization under matched physical conditions. ManipArena comprises 20 tasks, 10,812 expert trajectories, 13.5M frames, and approximately 188 robot hours across tabletop and mobile manipulation. The framework combines schema-defined task variation, stratified in-domain, visualshift, and semantic-OOD trials, subtask-level partial-credit scoring, three-level language annotations, low-level motor signals, and paired real-to-sim environments reconstructed from physical scenes. Using ManipArena, we evaluate seven tabletop configurations spanning VLA and world-action-model policies. The results show that real-robot conclusions depend not only on architecture, but also on model provenance, fine-tuning regime, data sampling, and annotation granularity. ManipArena thus provides a reproducible and interpretable foundation for diagnosing capability boundaries and failure modes in embodied generalization.
