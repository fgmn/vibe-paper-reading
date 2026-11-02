---
id: "02"
org: 自变量
short: "WALL-OSS-0.5"
title: "Wall-OSS-0.5 Technical Report"
aliases: ["WALL-OSS-0.5"]
date: 2026-05-29
category: 基础模型
source: 自变量主导
partners: []
authors: ["Ryan Yu", "Pushi Zhang", "Starrick Liu", "Brae Liu", "Miracle Kang", "Shalfun Li", "Lights Shi", "Ellie Ma", "Ping Yang", "Chris Pan", "Jerry Chen", "Dongxiu Liu", "Rain Sun", "Miles Guo", "Byron Zhang", "Hugo Zhou", "Zach Xu", "Vincent Chen", "Harrison Huang", "James Wang", "Dance Kuzi", "Andy Zhai", "Hang Su", "Roy Gan", "Lucy Liang", "Hao Wang", "Qian Wang"]
arxiv: "2605.30877"
pdf: "[[xsquare/papers/02_2605.30877_Wall-OSS-0.5_Technical-Report.pdf]]"
code: "https://github.com/X-Square-Robot/wall-x"
project: "https://x2robot.com/oss"
huggingface: ["https://huggingface.co/x-square-robot/wall-oss-0.5"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "vla", "foundation-model"]
---

# Wall-OSS-0.5 Technical Report

> [!info] 论文信息
> arXiv [2605.30877](https://arxiv.org/abs/2605.30877) · v1 2026-05-29 · 最新 v2（2026-06-01）
> PDF：[[xsquare/papers/02_2605.30877_Wall-OSS-0.5_Technical-Report.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/wall-x) · [项目页](https://x2robot.com/oss) · [wall-oss-0.5](https://huggingface.co/x-square-robot/wall-oss-0.5) · [官网 PDF](https://x2robot.com/api/files/file/WALL-OSS_0.5.pdf)

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

> Large-scale Vision-Language-Action (VLA) pretraining is increasingly adopted as the foundation for robot policies, yet the evidence for pretrained VLAs is almost invariably reported after task-specific fine-tuning. This leaves a foundational question unanswered: does VLA pretraining itself yield executable robot behavior, or does it merely furnish a better initialization for downstream policy learning? We present Wall-OSS-0.5, an open-source 4B VLA built upon a 3B VLM backbone augmented with action-generation components, designed so that pretrained robotic capability is directly measurable on physical hardware. The model is pretrained across more than 20 embodiments, processing over one million robot trajectories per epoch alongside a grounded multimodal corpus. We adopt a gradient-bridged co-training recipe in which three objectives play distinct and complementary roles: discrete action prediction routes strong VLM-native gradients into the backbone, multimodal prediction preserves grounded vision-language understanding, and continuous flow matching serves as the deployment-time action interface. Before task-specific fine-tuning, the pretrained checkpoint achieves non-trivial zero-shot real-robot behavior, completing several tasks, including a held-out deformable manipulation task, at high task progress on a 17-task suite. After fine-tuning, the same checkpoint serves as a stronger adaptation prior, reaching 60.5% average task progress on 15 real-robot tasks and outperforming \pi_0.5 by 17.5%. Multimodal evaluations further confirm that action training does not erode grounded vision-language competence: the model preserves broad vision-language ability while strengthening embodied grounding. Together, these results reposition VLA pretraining from an initialization strategy to a directly testable, already useful source of robot capability.
