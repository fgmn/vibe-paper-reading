---
id: "18"
org: 自变量
short: "Full-Duplex-Floor"
title: "Full-Duplex Speech Models Take the Floor When Asked, Not When Needed"
aliases: ["Full-Duplex-Floor"]
date: 2026-09-17
category: 语音交互
source: 合作
partners: ["UConn", "UT Austin", "牛津大学"]
authors: ["Linkai Peng", "Baorian Nuchged", "Kaiqi Fu", "Yuyang Yao"]
arxiv: "2609.19596"
pdf: "[[xsquare/papers/18_2609.19596_Full-Duplex-Speech-Models-Take-the-Floor.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "speech", "full-duplex", "dialogue"]
---

# Full-Duplex Speech Models Take the Floor When Asked, Not When Needed

> [!info] 论文信息
> arXiv [2609.19596](https://arxiv.org/abs/2609.19596) · v1 2026-09-17
> PDF：[[xsquare/papers/18_2609.19596_Full-Duplex-Speech-Models-Take-the-Floor.pdf|本地 PDF]]
> 合作单位：UConn、UT Austin、牛津大学

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

> Full-duplex speech models listen and speak at once, promising always-on assistants. Yet they must also decide when they should speak. Human listeners speak when addressed or when the speaker stops, but also self-select to correct a false claim, supply a missing word, or warn of danger. We ask whether full-duplex models do the same. To separate the reason to speak from the opportunity, we construct context-matched English monologues in which only the trigger utterance varies within a topic, define 10 conditions from turn-allocation rules, and compress inter-word pauses to limit opportunities created by silence. Across five model families, being addressed and silence are far more reliable triggers than false facts or hazards. Frame-level text-token probabilities in Moshi and PersonaPlex are lower for false facts than for Neutral when averaged over the first 2\,s after trigger end. Pauses or permission to interrupt do not close this gap either. Given the floor, Moshi and PersonaPlex answer most direct questions, yet the proportion of non-empty false-fact replies that challenge the claim is only .14--.15, and the proportion of hazard replies that warn of danger is .04--.07. This paper thus identifies a gap in both speech initiation and response content. Closing it requires genuine content understanding and intervention decisions grounded in it.
