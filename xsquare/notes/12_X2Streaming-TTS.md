---
id: "12"
org: 自变量
short: "X2Streaming-TTS"
title: "X2Streaming-TTS: Causal Token-Level Text-to-Speech from Streaming Text with Speech-State Inheritance"
aliases: ["X2Streaming-TTS"]
date: 2026-08-19
category: 语音交互
source: 自变量主导
partners: []
authors: ["Rime Wen", "Zehan Liu", "Shawn Qin", "Lights Shi", "Roy Gan", "Hao Wang", "Qian Wang"]
arxiv: "2608.18661"
pdf: "[[xsquare/papers/12_2608.18661_X2Streaming-TTS.pdf]]"
code: "https://github.com/X-Square-Robot/X2Streaming-TTS"
project: "https://x-square-robot.github.io/X2Streaming-TTS/"
huggingface: ["https://huggingface.co/x-square-robot/X2Streaming-TTS-1.7B"]
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "speech", "tts", "streaming"]
---

# X2Streaming-TTS: Causal Token-Level Text-to-Speech from Streaming Text with Speech-State Inheritance

> [!info] 论文信息
> arXiv [2608.18661](https://arxiv.org/abs/2608.18661) · v1 2026-08-19
> PDF：[[xsquare/papers/12_2608.18661_X2Streaming-TTS.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/X2Streaming-TTS) · [项目页](https://x-square-robot.github.io/X2Streaming-TTS/) · [X2Streaming-TTS-1.7B](https://huggingface.co/x-square-robot/X2Streaming-TTS-1.7B)

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

> Streaming text-to-speech is essential for low-latency spoken dialogue systems, yet many systems wait for sentence-level text and are therefore only pseudo-streaming. True token-level synthesis must generate speech from uncertain prefixes while maintaining perceptual continuity over an unbounded stream with bounded context. We present X2Streaming-TTS, a causal TTS framework that consumes asynchronously arriving text tokens and emits speech without accessing future input. To handle uncertain prefixes, we introduce causal commitment, which keeps ambiguous expressions provisional through uncertainty-aware buffering and performs capacity-adaptive, punctuation-aware segmentation. To preserve acoustic continuity, we further introduce causal speech-state inheritance, which carries the complete Code2Wav state and selected historical Talker states across segment boundaries. Together with an attention prior constraint, it blocks access to future positions while retaining bounded acoustic context. Experiments show that X2Streaming-TTS outperforms existing pseudo-streaming models on most subjective and objective metrics. Further analysis shows that causal commitment stabilizes online segmentation and reduces failures caused by insufficient context, while speech-state inheritance improves boundary continuity without degrading naturalness or speaker identity. X2Streaming-TTS thus achieves strict token-level synthesis with quality comparable to the evaluated offline baselines, a median time to first audio token (TTFT) of 15.8 ms for a single request, and a median TTFT of 260.8 ms at 128 concurrent requests. Our implementation is publicly available at this https URL .
