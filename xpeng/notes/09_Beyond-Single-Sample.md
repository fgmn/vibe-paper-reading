---
id: "09"
org: 小鹏
short: "Beyond Single-Sample"
title: "Beyond Single-Sample: Reliable Multi-Sample Distillation for Video Understanding"
aliases: ["Beyond Single-Sample"]
date: 2026-03-12
category: "机器人"
source: "小鹏主导"
product: "通用（多模态）"
partners: []
authors: ["Songlin Li", "Xin Zhu", "Zechao Guan", "Peipeng Chen", "Jian Yao"]
arxiv: "2603.11423"
pdf: "[[xpeng/papers/09_2603.11423_Beyond-Single-Sample.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# Beyond Single-Sample: Reliable Multi-Sample Distillation for Video Understanding

> [!info] 论文信息
> arXiv [2603.11423](https://arxiv.org/abs/2603.11423) · v1 2026-03-12
> PDF：[[xpeng/papers/09_2603.11423_Beyond-Single-Sample.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏主导 · 产品：通用（多模态）
> 清单里的一句话（Claude 根据摘要写，请核对）：【小鹏机器人中心】R-MSD：多样本可靠蒸馏，建模教师采样方差以改进视频理解LVLM蒸馏。
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

> Traditional black-box distillation for Large Vision-Language Models (LVLMs) typically relies on a single teacher response per input, which often yields high-variance responses and format inconsistencies in multimodal or temporal scenarios. To mitigate this unreliable supervision, we propose R-MSD (Reliable Multi-Sample Distillation), a framework that explicitly models teacher sampling variance to enhance distillation stability. Rather than relying on a single teacher response, our approach leverages a task-adaptive teacher pool to provide robust supervision tailored to both closed-ended and open-ended reasoning. By integrating quality-aware signal matching with an adversarial distillation objective, our approach effectively filters teacher noise while maximizing knowledge transfer. Extensive evaluations across comprehensive video understanding benchmarks demonstrate that R-MSD consistently outperforms single sample distillation methods. We additionally include an original SFT+RL 4B baseline under the same training budget, which shows only marginal gains, while our method achieves significant improvements. With a 4B student model, our approach delivers gains on VideoMME (+1.5%), Video-MMMU (+3.2%), and MathVerse (+3.6%).
