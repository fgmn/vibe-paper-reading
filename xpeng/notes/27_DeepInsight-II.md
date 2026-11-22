---
id: "27"
org: 小鹏
short: "DeepInsight II"
title: "DeepInsight II: One Trace from Benchmark to Robot"
aliases: ["DeepInsight II"]
date: 2026-08-17
category: "机器人"
source: "小鹏主导"
product: "通用（人形评测）"
partners: []
authors: ["Siyi Li", "Yuchen Kang", "Wuliang Wang", "Zhengjie Zhang", "Jiangpin Liu", "Jianhao Yao", "Jie Chen"]
arxiv: "2608.16556"
pdf: "[[xpeng/papers/27_2608.16556_DeepInsight-II.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# DeepInsight II: One Trace from Benchmark to Robot

> [!info] 论文信息
> arXiv [2608.16556](https://arxiv.org/abs/2608.16556) · v1 2026-08-17
> PDF：[[xpeng/papers/27_2608.16556_DeepInsight-II.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏主导 · 产品：通用（人形评测）
> 清单里的一句话（Claude 根据摘要写，请核对）：【XPENG Robotics】DeepInsight II：从基准到真机的一体化评测追踪。
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

> Across a Physical AI stack, evaluation maturity is inversely aligned with deployment risk: foundation models enjoy mature, standardized harnesses, while the embodied layers on which deployment actually turns remain fragmented across benchmark-specific simulators, embodiments, and interfaces. The first DeepInsight report (v1) unified evaluation across this stack behind three abstractions---task, resource, and result---but its quantitative evidence centered on the foundation-model layer; navigation and manipulation (System 1) and whole-body control (System 0) remained simulation case studies, and physical execution was outside its empirical scope. DeepInsight II keeps that substrate fixed and quantifies the embodied half. First, it reproduces released-checkpoint references across two navigation and four manipulation benchmarks under their native protocols. Second, MotionBench places four released whole-body controllers under one workload and metric contract, then carries a qualified within-family cohort from parallel simulation to matched real-robot trials in which simulated and physical rollouts share a parent trace identity while retaining execution-domain-specific records, making the sim-to-real gap a native reduction rather than a reconciliation across toolchains. Third, a composed System 2--1--0 study extends trace localization into five evidence-grounded handoff labels, each mapped to a concrete repair action, with a measured repairability criterion and physical episodes testing the same attribution under hardware-observable state. The contribution is therefore not a new evaluation architecture, but empirical continuity from benchmark execution to matched robot evidence and repair-oriented diagnosis.
