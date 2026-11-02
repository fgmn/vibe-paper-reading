---
id: "06"
org: 自变量
short: "DMuon"
title: "DMuon: Efficient Distributed Muon Training with Near-Adam Overhead"
aliases: ["DMuon"]
date: 2026-06-25
category: 训练基础设施
source: 自变量主导
partners: []
authors: ["Vincent Chen", "Starrick Liu", "Regis Cheng", "Dance Yang", "Shalfun Li", "Ryan Yu", "Lucy Liang", "Hang Su", "Roy Gan", "Hao Wang", "Qian Wang"]
arxiv: "2606.27153"
pdf: "[[xsquare/papers/06_2606.27153_DMuon.pdf]]"
code: "https://github.com/X-Square-Robot/dmuon"
project: "https://x-square-robot.github.io/dmuon/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "optimizer", "distributed-training"]
---

# DMuon: Efficient Distributed Muon Training with Near-Adam Overhead

> [!info] 论文信息
> arXiv [2606.27153](https://arxiv.org/abs/2606.27153) · v1 2026-06-25
> PDF：[[xsquare/papers/06_2606.27153_DMuon.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/dmuon) · [项目页](https://x-square-robot.github.io/dmuon/)

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

> Matrix-orthogonalization-based optimizers, exemplified by Muon, have demonstrated strong convergence behavior across a wide range of modern deep learning workloads. The matrix-aware updates offer a compelling alternative to conventional element-wise optimization, particularly as model architectures continue to grow in scale and heterogeneity. Yet contemporary distributed training infrastructure built around the assumption of element-wise optimizers is poorly matched to matrix-level optimizers such as Muon, whose updates couple entire weight matrices and require costly Newton-Schulz iterations. Vanilla Muon implementations incur more than 2x the cost of forward and backward passes. To close this gap, we present DMuon, an open-source distributed Muon implementation that integrates into existing training pipelines as a drop-in module, with no framework-level modifications. Across both embodied foundation model and large language model (LLM) training workloads, DMuon achieves a 1.48x-3.01x speedup in end-to-end step time and a 6.85x-163.00x speedup in optimizer-step time, bringing per-step latency to near-AdamW levels and enabling efficient scaling in our model training.
