---
id: "23"
org: 自变量
short: "EgoJEPA"
title: "EgoJEPA: Beyond Retargeting for Dexterous Manipulation from Egocentric Videos"
aliases: ["EgoJEPA"]
date: 2026-10-14
category: 技能学习
source: 合作
partners: ["MBZUAI", "上海交通大学", "Xense Robotics"]
authors: ["Meng Cao", "Can Zhao", "Jinjie Wei", "Haonan Zhao", "Yulong Zhang", "Duo Han", "Xiaofan Li", "Ziwu Song", "Rongtao Xu", "Ruyi Gan", "Hao Wang", "Qian Wang", "Daolin Ma", "Ian Reid", "Xiaodan Liang"]
arxiv: "2610.20904"
pdf: "[[xsquare/papers/23_2610.20904_EgoJEPA.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY-NC-ND 4.0
status: 未读
rating:
read_date:
tags: ["paper", "egocentric-video", "dexterous", "jepa"]
---

# EgoJEPA: Beyond Retargeting for Dexterous Manipulation from Egocentric Videos

> [!info] 论文信息
> arXiv [2610.20904](https://arxiv.org/abs/2610.20904) · v1 2026-10-14
> PDF：[[xsquare/papers/23_2610.20904_EgoJEPA.pdf|本地 PDF]]
> 合作单位：MBZUAI、上海交通大学、Xense Robotics

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

> Egocentric human videos offer a scalable alternative to costly robot demonstra- tions, yet transferring their manipulation priors to robot control remains chal- lenging. The commonly adopted retargeting-based approaches convert human wrist and finger poses into embodiment-specific action commands through hand- crafted geometric mappings. However, such mappings require meticulous recal- ibration across different embodiments and risk propagating hand-tracking errors into downstream robot control pipelines. To this end, we propose EgoJEPA, a three-stage framework that learns embodiment-agnostic representations from ego- centric human videos without rule-based human-to-robot retargeting: 1) Human- action pre-training learns effect-aware latent actions through JEPA-style visual prediction conditioned on hand-motion differences; 2) Latent-action-based world modeling jointly predicts future visual dynamics and latent actions, which decou- ples human prior pre-training from robot-specific control parameterizations; 3) Embodiment-specific tuning adapts the pretrained model to diverse robots through lightweight action adapters. Experiments on five real-world manipulation tasks across three robot embodiments demonstrate the effectiveness and efficiency of EgoJEPA. It achieves a 74% average success rate under the out-of-domain evalu- ation, compared with 65% for the retargeting baseline, while reducing cumulative cross-embodiment wall-clock cost by 47.2%, from 743.2 to 392.7 hours.
