---
id: "17"
org: 自变量
short: "REAL-2MIX"
title: "Identity-Faithful Audio-Visual Target Speaker Extraction with REAL-2MIX and VOXBLINK2-AVSE"
aliases: ["REAL-2MIX"]
date: 2026-08-04
category: 语音交互
source: 合作
partners: ["香港中文大学（深圳）"]
authors: ["Peijun Yang", "Zhan Jin", "Xiaoyi Qin", "Ruiyi Gan", "Hao Wang", "Juan Liu", "Ming Li"]
arxiv: "2608.03964"
pdf: "[[xsquare/papers/17_2608.03964_REAL-2MIX_AV-Target-Speaker-Extraction.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "speech", "audio-visual", "speaker-extraction"]
---

# Identity-Faithful Audio-Visual Target Speaker Extraction with REAL-2MIX and VOXBLINK2-AVSE

> [!info] 论文信息
> arXiv [2608.03964](https://arxiv.org/abs/2608.03964) · v1 2026-08-04 · 最新 v2（2026-08-06）
> PDF：[[xsquare/papers/17_2608.03964_REAL-2MIX_AV-Target-Speaker-Extraction.pdf|本地 PDF]]
> 合作单位：香港中文大学（深圳）

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

> Audio-visual target speaker extraction should return the speaker indicated by the video, yet a separator can ignore the visual cue and repeatedly output the acoustically dominant voice. We introduce REAL-2MIX, a Mandarin AV-TSE benchmark of jointly recorded real two-speaker mixtures with synchronized multi-view video. Each scene also contains preceding A-only and B-only stages that provide in-scene speaker references. It contains 77 scenes and 7,598 clips (11.84 hours), including 6,042 dual-annotated mixtures. After processing there leave 6,038 evaluable mixtures and 12,076 target-speaker rows. We additionally curate VOXBLINK2-AVSE from VoxBlink2, comprising 250,828 synchronized audio--lip-ROI pairs from 28,421 identities and 766.17 hours of speech. Our extractor uses frozen, 1,280-dimensional projected AV-HuBERT features, target-conditioned training, and layer-wise feature modulation. We jointly evaluate content with Qwen3-ASR-1.7B CER and target identity with WeSpeaker ResNet34 plus Overlapped Speech Detection (OSD). On the complete manifest, the best archived checkpoint obtains 0.2261 CER, 82.22% strict output correctness, and 69.53% both-output strict success.
