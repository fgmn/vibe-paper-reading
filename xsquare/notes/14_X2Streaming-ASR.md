---
id: "14"
org: 自变量
short: "X2Streaming-ASR"
title: "X2Streaming-ASR: wait when uncertain, emit when ready for streaming ASR"
aliases: ["X2Streaming-ASR"]
date: 2026-09-08
category: 语音交互
source: 自变量主导
partners: []
authors: ["Zhiwei Lin", "Kaiqi Fu", "Rime Wen", "Zehan Liu", "Shawn Qin", "Roy Gan", "Hao Wang"]
arxiv: "2609.08672"
pdf: "[[xsquare/papers/14_2609.08672_X2Streaming-ASR.pdf]]"
code: "https://github.com/X-Square-Robot/X2Streaming-ASR"
project: ""
huggingface: ["https://huggingface.co/x-square-robot/X2Streaming-ASR-4B-1009"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "speech", "asr", "streaming"]
---

# X2Streaming-ASR: wait when uncertain, emit when ready for streaming ASR

> [!info] 论文信息
> arXiv [2609.08672](https://arxiv.org/abs/2609.08672) · v1 2026-09-08 · 最新 v4（2026-10-12）
> PDF：[[xsquare/papers/14_2609.08672_X2Streaming-ASR.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/X2Streaming-ASR) · [X2Streaming-ASR-4B-1009](https://huggingface.co/x-square-robot/X2Streaming-ASR-4B-1009)

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

> Streaming automatic speech recognition (ASR) for real-time voice agents and full-duplex dialogue must provide accurate partial transcripts with low commit latency. Existing systems commonly use a fixed chunk size, look-ahead, or target delay, or encourage emissions near estimated acoustic boundaries. These approaches do not directly optimize how much additional context to use at each output position under a single-pass, hard-commit constraint. We propose X2Streaming-ASR, which decomposes streaming recognition into when to commit and what to commit. Its three-stage training procedure first establishes streaming recognition ability, then warm-starts the commit policy with automatically probed trajectories, and finally refines the policy using character-level, segment-assigned group-relative rewards for recognition accuracy and latency. Across ten Chinese and English test sets, X2Streaming-ASR attains the lowest mean commit latency relative to forced-aligned endpoints, 32--109ms on Chinese characters and 12--85ms on English words, while recognition accuracy remains comparable to existing this http URL is available at this https URL.
