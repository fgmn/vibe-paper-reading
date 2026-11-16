---
id: "18"
org: 英伟达
short: "SCIZOR"
title: "SCIZOR: A Self-Supervised Approach to Data Curation for Large-Scale Imitation Learning"
aliases: ["SCIZOR"]
date: 2025-05-28
category: "操作与其他"
source: "英伟达合作"
partners: []
authors: ["Yu Zhang", "Yuqi Xie", "Huihan Liu", "Rutav Shah", "Michael Wan", "Linxi Fan", "Yuke Zhu"]
arxiv: "2505.22626"
pdf: "[[nvidia/papers/18_2505.22626_SCIZOR.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia", "cosmos"]
---

# SCIZOR: A Self-Supervised Approach to Data Curation for Large-Scale Imitation Learning

> [!info] 论文信息
> arXiv [2505.22626](https://arxiv.org/abs/2505.22626) · v1 2025-05-28 · 最新 v2（2025-09-09）
> PDF：[[nvidia/papers/18_2505.22626_SCIZOR.pdf|本地 PDF]]
> 系列：物理AI · 操作与其他 · 角色：英伟达合作 · 用到 Cosmos
> 清单里的一句话（Claude 根据摘要写，请核对）：SCIZOR：自监督的模仿学习数据清洗方法，用 Cosmos 视频编码器去除冗余与次优片段。
> 汇总：[[nvidia/英伟达-论文与报告汇总|英伟达论文与报告汇总]]

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

> Imitation learning advances robot capabilities by enabling the acquisition of diverse behaviors from human demonstrations. However, large-scale datasets used for policy training often introduce substantial variability in quality, which can negatively impact performance. As a result, automatically curating datasets by filtering low-quality samples to improve quality becomes essential. Existing robotic curation approaches rely on costly manual annotations and perform curation at a coarse granularity, such as the dataset or trajectory level, failing to account for the quality of individual state-action pairs. To address this, we introduce SCIZOR, a self-supervised data curation framework that filters out low-quality state-action pairs to improve the performance of imitation learning policies. SCIZOR targets two complementary sources of low-quality data: suboptimal data, which hinders learning with undesirable actions, and redundant data, which dilutes training with repetitive patterns. SCIZOR leverages a self-supervised task progress predictor for suboptimal data to remove samples lacking task progression, and a deduplication module operating on joint state-action representation for samples with redundant patterns. Empirically, we show that SCIZOR enables imitation learning policies to achieve higher performance with less data, yielding an average improvement of 15.4% across multiple benchmarks. More information is available at: this https URL
