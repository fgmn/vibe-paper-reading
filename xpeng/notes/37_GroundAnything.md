---
id: "37"
org: 小鹏
short: "GroundAnything"
title: "GroundAnything: Reconciling Parallel Decoding with Precise Visual Grounding at Flash Speed"
aliases: ["GroundAnything"]
date: 2026-09-30
category: "基础模型"
source: "小鹏主导"
product: ""
partners: []
authors: ["Qize Yu", "Lianrui Fan", "Bowen Ping", "Xini Ding", "Zetian Song", "Junbo Niu", "Kaixuan Wang", "Tianxing Chen", "Yue Chen", "Minghua He", "Yuran Wang", "Jie Huang", "Haojun Zhang", "Min Chen", "Hao Li", "Wenxuan Song", "Ruihai Wu", "Xianming Liu", "Shilong Liu", "Shuchang Zhou", "Ping Luo", "Shiyu Huang"]
arxiv: "2609.39600"
pdf: "[[xpeng/papers/37_2609.39600_GroundAnything.pdf]]"
code: "https://github.com/groundingpi/GroundAnything"
project: "https://groundingpi.github.io/groundanything/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng"]
---

# GroundAnything: Reconciling Parallel Decoding with Precise Visual Grounding at Flash Speed

> [!info] 论文信息
> arXiv [2609.39600](https://arxiv.org/abs/2609.39600) · v1 2026-09-30 · 最新 v3（2026-11-19）
> PDF：[[xpeng/papers/37_2609.39600_GroundAnything.pdf|本地 PDF]]
> [代码](https://github.com/groundingpi/GroundAnything) · [项目页](https://groundingpi.github.io/groundanything/)
> 方向：基础模型 · 角色：小鹏主导
> 清单里的一句话（Claude 根据摘要写，请核对）：GroundAnything：以并行（双向）解码实现高速且精确的视觉定位。
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

> Autoregressive (AR) grounding models serialize spatial predictions, introducing sequential latency and imposing a causal order on output tokens. We view grounding as visual evidence extraction: objects, locations, and spatial relations are jointly constrained by the image and query, yet their dependencies do not imply an intrinsic left-to-right generation order. This distinction makes bidirectional diffusion a natural fit, allowing spatial hypotheses to emerge in parallel and be jointly refined through iterative denoising. We introduce GroundAnything, a 4B-parameter grounding foundation model that reconciles fast parallel decoding with precise localization through blockwise denoising. Training combines grounding pretraining from public datasets and dedicated data engines, direct AR-to-diffusion conversion with joint AR and diffusion objectives, supervised fine-tuning, and GRPO-based reinforcement post-training. Across 30 grounding benchmarks, our autoregressive variant, GroundAnything-VLM, establishes a new overall state of the art among similarly sized models at 72.42%, remaining competitive with GPT-6 Astra (71.35%). With entropy-guided decoding, GroundAnything also surpasses the prior state of the art at this scale, averaging 61.75% versus 53.32% for the fast MTP-based LocateAnything model. We further explore decoding strategies, showing that an optional self-speculative mode achieves a 4.51$\times$ speedup over the AR counterpart with a 0.74 percentage-point drop in COCO F1mIoU. Infrastructure experiments show that progressive inference optimizations translate parallel decoding into practical speedups. These gains support efficient visual grounding in latency-sensitive real-world systems.
