---
id: "13"
org: 小鹏
short: "X-Cache"
title: "X-Cache: Cross-Chunk Block Caching for Few-Step Autoregressive World Models Inference"
aliases: ["X-Cache"]
date: 2026-04-22
category: "世界模型"
source: "小鹏主导"
product: ""
partners: []
authors: ["Yixiao Zeng", "Jianlei Zheng", "Chaoda Zheng", "Shijia Chen", "Mingdian Liu", "Tongping Liu", "Tengwei Luo", "Yu Zhang", "Boyang Wang", "Linkun Xu", "Siyuan Lu", "Bo Tian", "Xianming Liu"]
arxiv: "2604.20289"
pdf: "[[xpeng/papers/13_2604.20289_X-Cache.pdf]]"
code: ""
project: "https://x-cache-1.github.io/"
huggingface: []
license: CC BY-NC-ND 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng"]
---

# X-Cache: Cross-Chunk Block Caching for Few-Step Autoregressive World Models Inference

> [!info] 论文信息
> arXiv [2604.20289](https://arxiv.org/abs/2604.20289) · v1 2026-04-22 · 最新 v2（2026-05-05）
> PDF：[[xpeng/papers/13_2604.20289_X-Cache.pdf|本地 PDF]]
> [项目页](https://x-cache-1.github.io/)
> 方向：世界模型 · 角色：小鹏主导
> 清单里的一句话（Claude 根据摘要写，请核对）：X-Cache：跨块块级缓存，加速少步自回归驾驶世界模型推理。
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

> Real-time world simulation is becoming a key infrastructure for scalable evaluation and online reinforcement learning of autonomous driving systems. Recent driving world models built on autoregressive video diffusion achieve high-fidelity, controllable multi-camera generation, but their inference cost remains a bottleneck for interactive deployment. However, existing diffusion caching methods are designed for offline video generation with multiple denoising steps, and do not transfer to this scenario. Few-step distilled models have no inter-step redundancy left for these methods to reuse, and sequence-level parallelization techniques require future conditioning that closed-loop interactive generation does not provide. We present X-Cache, a training-free acceleration method that caches along a different axis: across consecutive generation chunks rather than across denoising steps. X-Cache maintains per-block residual caches that persist across chunks, and applies a dual-metric gating mechanism over a structure- and action-aware block-input fingerprint to independently decide whether each block should recompute or reuse its cached residual. To prevent approximation errors from permanently contaminating the autoregressive KV cache, X-Cache identifies KV update chunks (the forward passes that write clean keys and values into the persistent cache) and unconditionally forces full computation on these chunks, cutting off error propagation. We implement X-Cache on X-world, a production multi-camera action-conditioned driving world model built on multi-block causal DiT with few-step denoising and rolling KV cache. X-Cache achieves 71% block skip rate with 2.6x wall-clock speedup while maintaining minimum degradation.
