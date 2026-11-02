---
id: "11"
org: 自变量
short: "X2-Turn"
title: "X2-Turn: Frame-Synchronous Dual-Head Modeling for Joint Streaming ASR and Turn State Prediction"
aliases: ["X2-Turn"]
date: 2026-08-11
category: 语音交互
source: 自变量主导
partners: []
authors: ["Kaiqi Fu", "Rime Wen", "Altman Lin", "Shawn Qin", "Roy Gan", "Hao Wang", "Qian Wang"]
arxiv: "2608.10878"
pdf: "[[xsquare/papers/11_2608.10878_X2-Turn.pdf]]"
code: "https://github.com/X-Square-Robot/X2-Turn"
project: ""
huggingface: ["https://huggingface.co/x-square-robot/X2-Turn-4B-0812", "https://huggingface.co/spaces/x-square-robot/x2-turn-4b-demo"]
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "speech", "asr", "turn-taking"]
---

# X2-Turn: Frame-Synchronous Dual-Head Modeling for Joint Streaming ASR and Turn State Prediction

> [!info] 论文信息
> arXiv [2608.10878](https://arxiv.org/abs/2608.10878) · v1 2026-08-11 · 最新 v3（2026-09-08）
> PDF：[[xsquare/papers/11_2608.10878_X2-Turn.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/X2-Turn) · [X2-Turn-4B-0812](https://huggingface.co/x-square-robot/X2-Turn-4B-0812) · [x2-turn-4b-demo](https://huggingface.co/spaces/x-square-robot/x2-turn-4b-demo)

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

> Accurate and responsive turn-taking is essential for spoken dialogue systems, which must distinguish in real time between user interruptions, backchannels that should be ignored, and the completion of an utterance. Prior modular approaches typically optimize turn state prediction at the utterance or fixed-chunk level, creating a mismatch with the continuous turn state estimate, and often depend on an auxiliary ASR model, which limits responsiveness and increases overall system complexity. Therefore, we present X2-Turn, a frame-synchronous turn state prediction method via delayed-stream modeling. Specifically, building on the pretrained Voxtral Realtime model, we introduce a frame-synchronous turn state head that operates in parallel with the ASR head on shared streaming representations, jointly predicting ASR tokens and fine-grained turn states at the frame level. Experiments on bilingual EasyTurn and Full-Duplex-Bench demonstrate that the proposed method achieves an effective trade-off between turn state accuracy and decision latency.
