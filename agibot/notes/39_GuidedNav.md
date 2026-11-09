---
id: "39"
org: 智元
short: "GuidedNav"
title: "GuidedNav: Shaping Vision-Language Navigation Representations through Pre-action Attention and Spatial Guidance"
aliases: ["GuidedNav"]
date: 2026-10-09
category: "导航"
source: "智元合作"
product: "灵犀 X2"
partners: []
authors: ["Jingyu Guo", "Jiaxin Huang", "Chengxing Lin", "Xiaoyu Luo", "Cheng Wen", "Shanshan Ye", "Tingjin Chu", "Shaoli Huang", "Mingming Gong"]
arxiv: "2610.13122"
pdf: "[[agibot/papers/39_2610.13122_GuidedNav.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot", "lingxi"]
---

# GuidedNav: Shaping Vision-Language Navigation Representations through Pre-action Attention and Spatial Guidance

> [!info] 论文信息
> arXiv [2610.13122](https://arxiv.org/abs/2610.13122) · v1 2026-10-09
> PDF：[[agibot/papers/39_2610.13122_GuidedNav.pdf|本地 PDF]]
> 角色：智元合作 · 机型：灵犀 X2
> 清单里的一句话（Claude 根据摘要写，请核对）：GuidedNav：用动作前注意力塑造视觉语言导航表征。
> 灵犀依据：GuidedNav runs on an AgiBot X2 humanoid with a forward-facing RGB camera, receiving instructions and streaming egocentric observations.（https://arxiv.org/html/2610.13122 (Appendix D.2 Real-World Setup; affiliation list includes '2 AgiBot')）
> 汇总：[[agibot/智元-论文与报告汇总|智元论文与报告汇总]]

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

> Vision-and-language navigation (VLN) requires an agent to track progress through an extended instruction, identify landmarks relevant to its current objective, and understand the surrounding spatial structure to act. End-to-end navigation policies typically rely on action supervision to implicitly learn these capabilities. Without explicit guidance on the evidence underlying each decision, however, policies can overfit to correlations predictive of training actions rather than learn the task-relevant grounding and geometry needed for generalization. Our insight is to guide the representations that connect instructions to actions: identifying what remains to be done determines which visual evidence matters, while understanding the geometry around that evidence informs how to move. We introduce GuidedNav, a unified framework that explicitly shapes these representations through training-time guidance. Subtask and landmark guidance steer native pre-action attention toward the active instruction segment and relevant visual regions, grounding action prediction in the current objective. Spatial guidance aligns the policy's internal representations with geometric features that capture long-horizon context and local spatial structure. Together, these objectives strengthen navigation capabilities while avoiding the inference overhead of intermediate textual reasoning and online geometric encoding. We also introduce Guided-R2R and Guided-RxR, two annotation-enriched navigation datasets that support more interpretable VLN research. GuidedNav establishes state-of-the-art performance among the compared monocular RGB policies, improving success rates by 8.1% and 13.1% relative to the strongest prior results on R2R-CE and RxR-CE val-unseen, respectively, while achieving faster inference. Extensive experiments further demonstrate the effectiveness and real-world transferability of our approach.
