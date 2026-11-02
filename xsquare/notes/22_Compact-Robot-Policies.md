---
id: "22"
org: 自变量
short: "Compact-Robot-Policies"
title: "Compact Robot Policies Need Fine-Grained Visual Representations"
aliases: ["Compact-Robot-Policies"]
date: 2026-10-06
category: 策略学习
source: 合作
partners: ["KTH"]
authors: ["Nanhe Chen", "Runqiu Yang", "Jiawei Tang", "Sichao Liu", "Yuquan Wang"]
arxiv: "2610.08183"
pdf: "[[xsquare/papers/22_2610.08183_Compact-Robot-Policies-Fine-Grained-Visual-Representations.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "visual-representation", "policy-learning"]
---

# Compact Robot Policies Need Fine-Grained Visual Representations

> [!info] 论文信息
> arXiv [2610.08183](https://arxiv.org/abs/2610.08183) · v1 2026-10-06
> PDF：[[xsquare/papers/22_2610.08183_Compact-Robot-Policies-Fine-Grained-Visual-Representations.pdf|本地 PDF]]
> 合作单位：KTH

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

> Multi-task manipulation policies differ in architecture, scale, and pretrained priors all at once, so published comparisons cannot attribute performance to any single component. We argue that most of it comes from the visual representation, and that parameter scale and generative priors are largely incidental. To test this, we build CoRP (Compressed Representation Policy), a deliberately compact policy (48.9M parameters, no vision-language model and no video-generative prior) that factorizes into a representation extractor and a flow-matching action generator. It reaches 97.0% on LIBERO and 75.78%/73.36% on RoboTwin 2.0 Clean/Randomized, matching systems 40.9-163.6x larger. Holding the action generator fixed, we then vary one extractor property at a time. Pretrained initialization is decisive: a random ViT-S/14 drops to 78.1% and an ImageNet ResNet-34 to 74.5% on LIBERO. Pretraining alone is not enough, as freezing the encoder costs 19.8 points. Compression matters as much: resampling each view to 48 tokens beats passing all patch tokens (97.0% vs 83.2%), and a variational information bottleneck over those tokens is worse than a hard token budget, cutting LIBERO-Goal from 95.8% to 33.0% by suppressing the instruction-dependent token selection the policy relies on. Language conditioning contributes only where the observation leaves the goal ambiguous (LIBERO-Goal: 9.2% to 95.8%), while on RoboTwin 2.0, where observations are unambiguous, removing it slightly improves success. Therefore, we argue that a compact policy works when its representation is pretrained, task-adapted, and compressed. Project page: this https URL
