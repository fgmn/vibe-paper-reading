---
id: "05"
org: 智元
short: "Genie Centurion"
title: "Genie Centurion: Accelerating Scalable Real-World Robot Training with Human Rewind-and-Refine Guidance"
aliases: ["Genie Centurion"]
date: 2025-05-24
category: "数据集"
source: "智元主导"
product: "精灵 G1"
partners: []
authors: ["Wenhao Wang", "Jianheng Song", "Chiming Liu", "Jiayao Ma", "Siyuan Feng", "Jingyuan Wang", "Yuxin Jiang", "Kylin Chen", "Sikang Zhan", "Yi Wang", "Tong Meng", "Modi Shi", "Xindong He", "Guanghui Ren", "Yang Yang", "Maoqing Yao"]
arxiv: "2505.18793"
pdf: "[[agibot/papers/05_2505.18793_Genie-Centurion.pdf]]"
code: ""
project: "https://genie-centurion.github.io"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# Genie Centurion: Accelerating Scalable Real-World Robot Training with Human Rewind-and-Refine Guidance

> [!info] 论文信息
> arXiv [2505.18793](https://arxiv.org/abs/2505.18793) · v1 2025-05-24 · 最新 v2（2026-01-19）
> PDF：[[agibot/papers/05_2505.18793_Genie-Centurion.pdf|本地 PDF]]
> [项目页](https://genie-centurion.github.io)
> 角色：智元主导 · 机型：精灵 G1
> 清单里的一句话（Claude 根据摘要写，请核对）：Genie Centurion：人类“回退-修正”指导的部署期数据采集范式，配合任务哨兵实现一人管多机。
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

> While Vision-Language-Action (VLA) models show strong generalizability in various tasks, real-world deployment of robotic policy still requires large-scale, high-quality human expert demonstrations. However, data collection via human teleoperation requires continuous operator attention, which is costly, hard to scale. To address this, we propose Genie Centurion (GCENT), a scalable and general data collection paradigm based on human rewind-and-refine guidance, enabling robots' interactive learning in deployment. GCENT starts at an imperfect policy and improves over time. When the robot execution failures occur, GCENT allows robots to revert to a previous state with a rewind mechanism, after which a teleoperator provides corrective demonstrations to refine the policy. This framework supports a one-human-to-many-robots supervision scheme with a Task Sentinel module, which autonomously predicts task success and solicits human intervention when necessary. Empirical results show that GCENT achieves up to 40% higher task success rates than state-of-the-art data collection methods, and reaches comparable performance using less than half the data in long-horizon and precise tasks. We also quantify the data yield-to-effort ratio under multi-robot scenarios, demonstrating GCENT's potential for scalable and cost-efficient robot policy training in real-world environments.
