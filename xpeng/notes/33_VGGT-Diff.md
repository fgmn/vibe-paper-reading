---
id: "33"
org: 小鹏
short: "VGGT-Diff"
title: "VGGT-Diff: Visual Geometry Meets Diffusion for Sparse-View Novel View Synthesis"
aliases: ["VGGT-Diff"]
date: 2026-09-27
category: "仿真与数据"
source: "小鹏主导"
product: ""
partners: []
authors: ["Kangjie Chen", "Xiangyu Li", "Dongbin Zhang", "Chaoda Zheng", "Shijia Chen", "Jinhao Deng", "Hongbin Lin", "Choo Sin Wai", "Minqi Wang", "Minghao Yang", "Dake Zhong", "Guorui Song", "Yu Zhang", "Xianming Liu", "Boyang Wang"]
arxiv: "2609.33253"
pdf: "[[xpeng/papers/33_2609.33253_VGGT-Diff.pdf]]"
code: "https://github.com/chenkangjie1123/VGGT-Diff"
project: "https://chenkangjie1123.github.io/VGGT-Diff"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng"]
---

# VGGT-Diff: Visual Geometry Meets Diffusion for Sparse-View Novel View Synthesis

> [!info] 论文信息
> arXiv [2609.33253](https://arxiv.org/abs/2609.33253) · v1 2026-09-27 · 最新 v2（2026-10-14）
> PDF：[[xpeng/papers/33_2609.33253_VGGT-Diff.pdf|本地 PDF]]
> [代码](https://github.com/chenkangjie1123/VGGT-Diff) · [项目页](https://chenkangjie1123.github.io/VGGT-Diff)
> 方向：仿真与数据 · 角色：小鹏主导
> 清单里的一句话（Claude 根据摘要写，请核对）：VGGT-Diff：几何路由的多视图扩散模型，用于稀疏视角新视角合成。
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

> We present VGGT-Diff, a geometry-routed multi-view diffusion model for sparse-view novel view synthesis. Existing novel view synthesis (NVS) methods face a fundamental trade-off: reconstruction-based approaches preserve observed geometry but struggle to synthesize unseen regions, while diffusion-based methods provide strong generative priors yet rely on implicit source-to-query correspondence. VGGT-Diff bridges these regimes by routing visual geometry latents from VGGT-{\Omega} into a pretrained video diffusion model. Each visual token is associated with a 3D point and confidence, then transformed into query-aligned latent conditions through a confidence-aware Visual Geometry Router (VGR) that preserves front and back surface evidence. These conditions guide joint target-view denoising, while Point-Track Residual Consistency (PTRC) regularizes predicted-clean residuals along reliable 3D tracks, improving multi-view stability. We further introduce robust geometry conditioning, combining training-time regularization with inference-time guidance for improved robustness. Experiments show competitive or state-of-the-art performance across interpolation and extrapolation under different viewpoint difficulties. Our code is available at this https URL.
