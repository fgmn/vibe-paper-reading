---
id: "04"
org: 小鹏
short: "Speaker Disentanglement of Speech Pre-trained Model Based on Interpretability"
title: "Speaker Disentanglement of Speech Pre-trained Model Based on Interpretability"
aliases: ["Speaker Disentanglement of Speech Pre-trained Model Based on Interpretability"]
date: 2025-07-19
category: "其他"
source: "小鹏主导"
product: ""
partners: []
authors: ["Junhua Li", "Xiaoxu Zhu", "Aaron J. Li"]
arxiv: "2507.17851"
pdf: "[[xpeng/papers/04_2507.17851_Speaker-Disentanglement-of-Speech.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng"]
---

# Speaker Disentanglement of Speech Pre-trained Model Based on Interpretability

> [!info] 论文信息
> arXiv [2507.17851](https://arxiv.org/abs/2507.17851) · v1 2025-07-19 · 最新 v4（2026-09-20）
> PDF：[[xpeng/papers/04_2507.17851_Speaker-Disentanglement-of-Speech.pdf|本地 PDF]]
> 方向：其他 · 角色：小鹏主导
> 清单里的一句话（Claude 根据摘要写，请核对）：基于可解释性（SHAP）对语音预训练模型做说话人解耦，兼顾内容任务与隐私。
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

> Self-supervised speech models learn representations that capture both content and speaker information. Yet this entanglement creates problems: content tasks suffer from speaker bias, and privacy concerns arise when speaker identity leaks through supposedly anonymized representations. We present two contributions to address these challenges. First, we develop InterpTRQE-SptME (Timbre Residual Quantitative Evaluation Benchmark of Speech pre-training Models Encoding via Interpretability), a benchmark that directly measures residual speaker information in content embeddings using SHAP-based interpretability analysis. Unlike existing indirect metrics, our approach quantifies the exact proportion of speaker information remaining after disentanglement. Second, we propose InterpTF-SptME, which uses these interpretability insights to filter speaker information from embeddings. Testing on VCTK with seven models including HuBERT, WavLM, and ContentVec, we find that SHAP Noise filtering reduces speaker residuals from 18.05% to nearly zero while maintaining recognition accuracy (CTC loss increase under 1%). The method is model-agnostic and requires no retraining.
