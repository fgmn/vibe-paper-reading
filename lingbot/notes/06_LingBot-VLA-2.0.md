---
id: "06"
org: 蚂蚁灵波
short: "LingBot-VLA 2.0"
title: "From Foundation to Application: Improving VLA Models in Practice"
aliases: ["LingBot-VLA 2.0"]
date: 2026-07-07
category: "VLA"
source: "蚂蚁灵波主导"
partners: []
authors: ["Wei Wu", "Fangjing Wang", "Fan Lu", "He Sun", "Shi Liu", "Yunnan Wang", "Yibin Yan", "Yong Wang", "Shuailei Ma", "Xinyang Wang", "Yibin Liu", "Shuai Yang", "Tianxiang Zhou", "Kejia Zhang", "Lei Zhou", "Cheng Su", "Nan Xue", "Bin Tan", "Han Zhang", "Youchao Zhang", "Fei Liao", "Xing Zhu", "Yujun Shen", "Kecheng Zheng"]
arxiv: "2607.06403"
pdf: "[[lingbot/papers/06_2607.06403_LingBot-VLA-2.0.pdf]]"
code: "https://github.com/robbyant/lingbot-vla-v2"
project: "https://technology.robbyant.com/lingbot-vla-v2"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "lingbot"]
---

# From Foundation to Application: Improving VLA Models in Practice

> [!info] 论文信息
> arXiv [2607.06403](https://arxiv.org/abs/2607.06403) · v1 2026-07-07
> PDF：[[lingbot/papers/06_2607.06403_LingBot-VLA-2.0.pdf|本地 PDF]]
> [github.com](https://github.com/robbyant/lingbot-vla-v2) · [huggingface.co](https://huggingface.co/collections/robbyant/lingbot-vla-v2) · [technology.robbyant.com](https://technology.robbyant.com/lingbot-vla-v2) · [technology.robbyant.com](https://technology.robbyant.com/lingbot-depth)
> 方向：VLA · 角色：蚂蚁灵波主导
> 汇总：[[lingbot/蚂蚁灵波-论文汇总|蚂蚁灵波论文汇总]]

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

> Despite recent progress of VLA foundation models, the disparity between laboratory conditions and real-world applications continues to impede their practical implementation. To bridge this gap, we present LingBot-VLA 2.0, which advances LingBot-VLA through improvements in three functional domains. (1) Generalization across tasks and embodiments. Compared to the previous version, we revamp the data processing pipeline and curate around 60,000 hours of data for pretraining, including 50,000 hours of robot trajectories spanning 20 robot configurations and 10,000 hours of egocentric human videos. (2) Expanded action space in addition to dual-arm hardware platforms. In particular, our system accommodates degrees of freedom for the heads, waists, mobile bases, and dexterous hands, thereby empowering the robots to tackle more complex tasks in practical scenarios. (3) Predictive dynamics modeling for improved temporal reasoning. Specifically, we formulate future prediction as a proxy task, facilitated by a video representation model for semantic priors and a depth estimation model for geometric cues. Evaluations on the GM-100 benchmark, conducted in a generalist setting, validate the beneficial impact of these proposed modifications. Furthermore, benefiting from the expanded pretraining data that covers whole-body degrees of freedom, LingBot-VLA-2.0 demonstrates strong cross-embodiment long-horizon mobile manipulation capability across the two robotic platforms.
