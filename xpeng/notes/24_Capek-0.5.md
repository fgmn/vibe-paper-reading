---
id: "24"
org: 小鹏
short: "Capek 0.5"
title: "Capek 0.5: An Execution-Centric Vision-Language Model for Embodied Intelligence"
aliases: ["Capek 0.5"]
date: 2026-08-07
category: "机器人"
source: "小鹏主导"
product: "通用（具身VLM）"
partners: []
authors: ["Ying Chen", "Weizhen Li", "Zhe Hu", "Zhenjiang Li", "Rui Jiang", "Zhifeng Gu", "Lihuang Fang", "Jiangping Liu", "Lei Yi", "Jie Chen"]
arxiv: "2608.06756"
pdf: "[[xpeng/papers/24_2608.06756_Capek-0.5.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# Capek 0.5: An Execution-Centric Vision-Language Model for Embodied Intelligence

> [!info] 论文信息
> arXiv [2608.06756](https://arxiv.org/abs/2608.06756) · v1 2026-08-07
> PDF：[[xpeng/papers/24_2608.06756_Capek-0.5.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏主导 · 产品：通用（具身VLM）
> 清单里的一句话（Claude 根据摘要写，请核对）：【XPENG Robotics】Capek 0.5：面向具身执行的视觉语言模型。
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

> Vision-language models are increasingly serving as the reasoning core of embodied agents. Robot execution is inherently iterative: each action reshapes the scene and physical state, continually renewing what must be perceived, reasoned about, and verified. Meeting these demands requires complementary capabilities that differ in supervision signals, prediction formats, and verification criteria. Existing approaches typically develop these capabilities against isolated, task-specific objectives, leaving open how they should be organized and integrated around execution as a whole. We present Capek 0.5, an embodied vision-language model built around an execution-centric capability taxonomy. Rather than organizing training by datasets or tasks, the taxonomy groups embodied capabilities according to their functional roles throughout execution and comprises four capability families: Spatial Reasoning, Temporal Understanding, Action Guidance, and State Verification. Each capability is first acquired by a dedicated specialist through reinforcement learning with verifiable rewards from a shared backbone, and the specialists are then consolidated into a single inference-time model through weight-space merging followed by routed policy-space distillation. We instantiate Capek 0.5 at the 2B and 35B-A3B scales and evaluate it from three complementary perspectives: comprehensive benchmark suites including Capek-StateBench, a new benchmark for state verification; a controlled study of capability retention from specialists to the unified model; and closed-loop evaluation in simulated embodied environments. Capek 0.5 improves the large majority of matched benchmark rows over its initialization, retains all four specialized capabilities in one checkpoint with quantified losses, and transfers to closed-loop embodied task execution.
