---
id: "20"
org: 自变量
short: "WSM-Aware-HRI"
title: "WSM-Aware HRI: An IoT-Enhanced Framework for Early Detection and Norm-Guided Repair of Failures with LLM Guidance"
aliases: ["WSM-Aware-HRI"]
date: 2026-09-26
category: 人机交互
source: 合作
partners: ["香港中文大学（深圳）", "深圳市人工智能与机器人研究院"]
authors: ["Hanlin Zhang", "Yuquan Wang", "Tianwei Zhang", "Zhenglong Sun"]
arxiv: "2609.32336"
pdf: "[[xsquare/papers/20_2609.32336_WSM-Aware-HRI.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "hri", "llm", "failure-recovery"]
---

# WSM-Aware HRI: An IoT-Enhanced Framework for Early Detection and Norm-Guided Repair of Failures with LLM Guidance

> [!info] 论文信息
> arXiv [2609.32336](https://arxiv.org/abs/2609.32336) · v1 2026-09-26 · 最新 v2（2026-10-07）
> PDF：[[xsquare/papers/20_2609.32336_WSM-Aware-HRI.pdf|本地 PDF]]
> [ACM THRI](https://doi.org/10.1145/3858343)
> 合作单位：香港中文大学（深圳）、深圳市人工智能与机器人研究院

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

> Human-robot interaction (HRI) failures remain a major barrier to deploying robots in real-world environments. Prior work often treats failures as isolated technical faults or focuses on post-hoc recovery behaviors. In practice, many breakdowns arise because humans and robots operate under inconsistent assumptions about the current world state. We propose WSM-Aware HRI, an IoT-enhanced modular framework that unifies diverse HRI breakdowns as World-State Mismatches (WSMs) between a human's instruction-implied assumptions and a robot's grounded world model built from multimodal perception and digital augmentation. A Large Language Model (LLM) is used to make implicit assumptions explicit, map them to a small set of mismatch types, and specify the evidence needed for verification against the robot's world state. WSM-Aware HRI shifts failure handling from execution-time recovery to proactive mismatch detection during intention formation, enabling interventions guided by safety, norm compliance, and multi-user coordination with transparent explanations. We evaluate mismatch identification in ten everyday cases spanning both visual and latent-state mismatches. The system can accurately produce the expected output results, and ablations show that reliable identification depends on appropriate grounding representations and verification-oriented refinement. These results indicate that treating interaction breakdowns as explicit world-state mismatches enables earlier detection of impending failures and offers a principled mechanism for integrating external evidence and social constraints into human-robot interaction.
