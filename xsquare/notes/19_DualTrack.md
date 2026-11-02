---
id: "19"
org: 自变量
short: "DualTrack"
title: "DualTrack: Synchronized speech-gesture generation via symmetric coupling of pretrained priors"
aliases: ["DualTrack"]
date: 2026-09-29
category: 语音交互
source: 合作
partners: ["香港中文大学（深圳）"]
authors: ["Yuanzhuo Hu", "Zehan Liu", "Xiaoyi Qin", "Ming Li"]
arxiv: "2609.36624"
pdf: "[[xsquare/papers/19_2609.36624_DualTrack.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "speech", "gesture-generation", "tts"]
---

# DualTrack: Synchronized speech-gesture generation via symmetric coupling of pretrained priors

> [!info] 论文信息
> arXiv [2609.36624](https://arxiv.org/abs/2609.36624) · v1 2026-09-29
> PDF：[[xsquare/papers/19_2609.36624_DualTrack.pdf|本地 PDF]]
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

> Joint speech-gesture synthesis must coordinate two modalities despite limited paired data. Existing approaches often lack bidirectional interaction, have limited language coverage, or simplify body and finger representations. We present DualTrack, which couples pretrained speech and motion priors on a shared 12.5 Hz timeline. Causal adapters exchange previous-packet information, while current-state fusion coordinates the streams before they separately complete sixteen-codebook packets. We evaluate 43 BEAT2 recordings in four languages, with speakers held out from joint training and validation. On the shared English/Spanish inputs, without speech or motion prefixes, DualTrack achieves lower word error rate and full-motion Fréchet Gesture Distance, higher beat consistency and speech naturalness than the evaluated GELINA baseline.
