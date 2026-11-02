---
id: "13"
org: 自变量
short: "X2-NativeCursor"
title: "X2-NativeCursor: Native-Token Text Progress Tracking for Incremental-Text Streaming Codec TTS"
aliases: ["X2-NativeCursor"]
date: 2026-09-09
category: 语音交互
source: 自变量主导
partners: []
authors: ["Zehan Liu", "Carl Chen", "Rime Wen", "Kaiqi Fu", "Altman Lin", "Shawn Qin", "Lights Shi", "Roy Gan", "Hao Wang", "Qian Wang"]
arxiv: "2609.09677"
pdf: "[[xsquare/papers/13_2609.09677_X2-NativeCursor.pdf]]"
code: "https://github.com/X-Square-Robot/X2Streaming-TTS"
project: ""
huggingface: ["https://huggingface.co/x-square-robot/X2-NativeCursor-Qwen3TTS-12Hz"]
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "speech", "tts", "streaming"]
---

# X2-NativeCursor: Native-Token Text Progress Tracking for Incremental-Text Streaming Codec TTS

> [!info] 论文信息
> arXiv [2609.09677](https://arxiv.org/abs/2609.09677) · v1 2026-09-09
> PDF：[[xsquare/papers/13_2609.09677_X2-NativeCursor.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/X2Streaming-TTS) · [X2-NativeCursor-Qwen3TTS-12Hz](https://huggingface.co/x-square-robot/X2-NativeCursor-Qwen3TTS-12Hz)

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

> Incremental-text streaming text-to-speech (TTS) needs online text progress tracking for synchronized highlighting, interruption handling, and dialogue-history updates. Input text arrives before it is spoken, so text arrival alone cannot indicate speech progress. Existing waveform-based alignment requires complete audio or adds acoustic processing during streaming. We propose X2-NativeCursor, a lightweight observer that tracks progress from native speech tokens before waveform decoding without changing the TTS generator. Its normalization plan links spoken labels to their original-text spans. Text and native-token encoders feed a local matcher that estimates the current label position. A separate output rule converts revisable position estimates into a cursor that never moves backward. Mean absolute error against an automatic reference is 0.151 Chinese characters with 80-ms lookahead, versus 1.253 characters with 320-ms lookahead for an online waveform baseline. Alignment real-time factor also decreases from 0.3598 to 0.0180 relative to this baseline. Lower tracking error is retained under a second automatic alignment reference. We evaluate X2-NativeCursor on Qwen3-TTS and validate its adaptation to CosyVoice2 by training a separate observer for each backbone. Code is publicly available at this https URL.
