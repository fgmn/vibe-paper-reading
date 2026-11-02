---
id: "03"
org: 自变量
short: "WALL-WM"
title: "WALL-WM: Carving World Action Modeling at the Event Joints"
aliases: ["WALL-WM"]
date: 2026-06-01
category: 世界模型
source: 自变量主导
partners: []
authors: ["Shalfun Li", "Victor Yao", "Charles Yang", "Truth Qu", "Regis Cheng", "Ryan Yu", "Howard Lu", "Newton Von", "Vincent Chen", "Yohann Tang", "Maeve Zhang", "Ellie Ma", "Gody Li", "Starrick Liu", "Sage Yang", "Lorien Shu", "J. W. Gao", "Ethan Chen", "Colin Ye", "Yu Sun", "Elise Mon", "PS Zhang", "Neo Li", "Lily Li", "James Wang", "Ping Yang", "Chris Pan", "Lucy Liang", "Hang Su", "Roy Gan", "Hao Wang", "Qian Wang"]
arxiv: "2606.01955"
pdf: "[[xsquare/papers/03_2606.01955_WALL-WM.pdf]]"
code: "https://github.com/X-Square-Robot/wall-wm"
project: "https://x2robot.com/pages/wm"
huggingface: []
license: CC BY-NC-ND 4.0
status: 未读
rating:
read_date:
tags: ["paper", "world-model", "world-action-model"]
---

# WALL-WM: Carving World Action Modeling at the Event Joints

> [!info] 论文信息
> arXiv [2606.01955](https://arxiv.org/abs/2606.01955) · v1 2026-06-01 · 最新 v2（2026-09-06）
> PDF：[[xsquare/papers/03_2606.01955_WALL-WM.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/wall-wm) · [项目页](https://x2robot.com/pages/wm) · [官网 PDF](https://x2robot.com/api/files/file/WALL-WM.pdf)

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

> WALL-WM is a World Action Model that shifts video-action learning from chunk-centric optimization to event-grounded Vision-Language-Action pretraining, using semantically coherent action events as the atomic unit of learning. Existing WAMs commonly initialize from multimodal or video foundation models and then optimize fixed-length action chunks conditioned directly on the current observation and instruction. Although convenient, this chunk-centric formulation creates a fundamental granularity mismatch. Language describes semantic goals and events, vision evolves through continuous scene dynamics, and actions operate at control-level timescales; forcing all three into the same fixed-length prediction window turns VLA training into short-horizon correlation fitting. WALL-WM addresses this mismatch by organizing both supervision and data around semantic events. Specifically, it pairs event-grounded VLA pretraining with a data ecosystem built from event-level captions and cluster-balanced sampling, enabling scalable learning over diverse behaviors, scenes, and task structures. From the same event-pretrained backbone, WALL-WM supports two complementary inference modes. The event mode consumes next-event descriptions and enables variable-length execution chunks, while the unified mode uses a VLM with Staircase Decoding to condition conventional fixed-length chunk inference while preserving a gradient-continuous VLA path. Together with Muon-optimizer-based large-scale pretraining infrastructure, WALL-WM provides a practical scale-up recipe for general-purpose WAMs. Experiments show that WALL-WM generalizes broadly across language, scenes, and tasks, achieving state-of-the-art performance in large-scale real-world generalization evaluation.
