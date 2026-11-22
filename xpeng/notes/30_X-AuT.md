---
id: "30"
org: 小鹏
short: "X-AuT"
title: "X-AuT: Progressive Audio-Encoder Compression for Speech LLMs with Cross-Scale Distillation"
aliases: ["X-AuT"]
date: 2026-09-10
category: "基础模型"
source: "小鹏主导"
product: ""
partners: []
authors: ["Haojun Zhang", "Yi Zou", "Min Chen", "Qize Yu", "Lianrui Fan", "Xini Ding", "Hao Li", "Shuchang Zhou", "Xianming Liu", "Shiyu Huang"]
arxiv: "2609.11412"
pdf: "[[xpeng/papers/30_2609.11412_X-AuT.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng"]
---

# X-AuT: Progressive Audio-Encoder Compression for Speech LLMs with Cross-Scale Distillation

> [!info] 论文信息
> arXiv [2609.11412](https://arxiv.org/abs/2609.11412) · v1 2026-09-10
> PDF：[[xpeng/papers/30_2609.11412_X-AuT.pdf|本地 PDF]]
> 方向：基础模型 · 角色：小鹏主导
> 清单里的一句话（Claude 根据摘要写，请核对）：X-AuT：渐进式音频编码器压缩与跨尺度蒸馏，降低语音大模型推理开销。
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

> Reducing audio-encoder depth lowers the inference cost of speech large language models, but removing complete blocks perturbs the embeddings consumed by the decoder and can cause deletion and premature end-of-sequence errors. We introduce X-AuT, a progressive framework that selects layer combinations through short behavioral probes and restores the pruned model through representation alignment, cross-scale distillation, scheduled student-policy supervision, and LoRA finetuning. The language-model backbone remains frozen, while attention LoRA adapters and the tied output embedding adapt during distillation. Training uses the highest-agreement tier from a transcript-consistency pipeline, followed by source reweighting during finetuning. On ten public Chinese--English benchmarks, compressing Qwen3-ASR-0.6B from 18 to 16 audio-encoder layers reduces macro-average error from 5.61% to 5.27%. The 14-layer model reaches 5.75% with 20.7% fewer audio-tower parameters. Under the matched recipe, the 1.7B teacher yields 5.55% mean error, compared with 8.45% for self-distillation, and progressive 18$\rightarrow$14 pruning outperforms direct pruning (5.75% vs. 6.73%). These single-run results establish two practical operating points and show that the accuracy effects vary across benchmarks. Project website: this https URL
