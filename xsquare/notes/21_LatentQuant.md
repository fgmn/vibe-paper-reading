---
id: "21"
org: 自变量
short: "LatentQuant"
title: "LatentQuant: Preserving the Policy-Facing Latent Contract under NVFP4 VAE Quantization"
aliases: ["LatentQuant"]
date: 2026-10-02
category: 世界模型
source: 合作
partners: ["UCSD", "中山大学", "中国科学院大学", "香港科技大学（广州）"]
authors: ["Ziye Deng", "Lufang Chen", "Shuyu Feng", "Zhenwei Duan", "Zicong Ye", "Yu Sun", "Xiaofan Li", "Ruyi Gan", "Hao Wang", "Hao Zhang"]
arxiv: "2610.03959"
pdf: "[[xsquare/papers/21_2610.03959_LatentQuant.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "quantization", "world-action-model"]
---

# LatentQuant: Preserving the Policy-Facing Latent Contract under NVFP4 VAE Quantization

> [!info] 论文信息
> arXiv [2610.03959](https://arxiv.org/abs/2610.03959) · v1 2026-10-02
> PDF：[[xsquare/papers/21_2610.03959_LatentQuant.pdf|本地 PDF]]
> 合作单位：UCSD、中山大学、中国科学院大学、香港科技大学（广州）

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

> Recent world action models (WAMs) reuse pretrained video VAEs whose encoder latents directly condition downstream action policies. Quantization must therefore preserve not only reconstruction fidelity but also the policy-facing latent contract expected by the frozen policy. Direct NVFP4 leaves W4A4 quantization error uncompensated, whereas joint quantization-aware training (QAT) can recover reconstruction by moving this representation. On Wan2.1, joint QAT nearly matches FP32 VBench-7 (0.7403 versus 0.7409), yet LIBERO success collapses from 95.5% to 10.5%. Controlled decoder-only experiments show that activation quantize-dequantize operations alter the reconstruction signal and decoder Jacobian, redirecting the gradient returned to the encoder and inducing persistent latent drift. Based on this mechanism, we introduce LatentQuant, a two-stage NVFP4 QAT framework that first aligns the quantized encoder with its high-precision counterpart, then freezes it while adapting the decoder. Across Wan2.1 and Wan2.2, LatentQuant preserves near-baseline control and high reconstruction quality, achieving 95.75% success on LIBERO and 68.8% on RoboTwin. On NVIDIA B300 GPUs, NVFP4 execution achieves 1.17x-1.26x end-to-end VAE speedups over BF16 cuDNN.
