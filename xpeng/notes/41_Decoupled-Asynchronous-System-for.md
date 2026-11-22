---
id: "41"
org: 小鹏
short: "Decoupled Asynchronous System for Humanoids (DASH): Latency-Agnostic Scaling of Vision-Language-Action Models for Humanoid Manipulation"
title: "Decoupled Asynchronous System for Humanoids (DASH): Latency-Agnostic Scaling of Vision-Language-Action Models for Humanoid Manipulation"
aliases: ["Decoupled Asynchronous System for Humanoids (DASH): Latency-Agnostic Scaling of Vision-Language-Action Models for Humanoid Manipulation"]
date: 2026-11-09
category: "机器人"
source: "小鹏主导"
product: "人形（通用）"
partners: []
authors: ["Bingzhang Wang", "Nathan Zhao", "Jialeng Ni", "Jiayin Zheng", "Yin Zhang", "Kehua Chen", "Jian Yao"]
arxiv: "2611.11854"
pdf: "[[xpeng/papers/41_2611.11854_Decoupled-Asynchronous-System-for.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# Decoupled Asynchronous System for Humanoids (DASH): Latency-Agnostic Scaling of Vision-Language-Action Models for Humanoid Manipulation

> [!info] 论文信息
> arXiv [2611.11854](https://arxiv.org/abs/2611.11854) · v1 2026-11-09 · 最新 v2（2026-11-12）
> PDF：[[xpeng/papers/41_2611.11854_Decoupled-Asynchronous-System-for.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏主导 · 产品：人形（通用）
> 清单里的一句话（Claude 根据摘要写，请核对）：DASH解耦异步系统让VLA主干推理不阻塞控制回路，实现人形灵巧操作中与延迟无关的模型规模扩展。
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

> Vision-language-action (VLA) models pair a vision-language backbone with an action head, but in closed-loop control the backbone sits on the control-critical path: while it computes, the robot keeps moving, so each executed action is conditioned on an increasingly stale observation. A larger backbone therefore directly blocks reactivity, especially in humanoid dexterous manipulation. We present DASH, a Decoupled Asynchronous System for Humanoids that removes this coupling. DASH splits the policy into a slow vision-language model (System 2) and a fast flow-matching action head (System 1) that run as concurrent processes over the LCM communication protocol, so the control rate is set by the action head alone, independent of backbone size. The action head fuses stale semantics from a frozen backbone with fresh vision from its own ResNet encoder, desynchronized training exposes it to the staleness it meets at deployment, and an adaptive temporal aggregator aligns overlapping action chunks under variable inference latency. On an asynchronous RoboTwin benchmark that charges inference latency in simulated time, DASH holds 20 Hz control rate from 0.8B to 8B backbones while the synchronous rate falls from 9.7 to 4.1 Hz, with higher success at every size. On a real humanoid with dexterous hands, DASH achieves clearly higher pick-and-place success than the synchronous pipeline.
