---
id: "03"
org: 小鹏
short: "NavigScene"
title: "NavigScene: Bridging Local Perception and Global Navigation for Beyond-Visual-Range Autonomous Driving"
aliases: ["NavigScene"]
date: 2025-07-07
category: "端到端与VLA"
source: "小鹏主导"
product: ""
partners: []
authors: ["Qucheng Peng", "Chen Bai", "Guoxiang Zhang", "Bo Xu", "Xiaotong Liu", "Xiaoyin Zheng", "Chen Chen", "Cheng Lu"]
arxiv: "2507.05227"
pdf: "[[xpeng/papers/03_2507.05227_NavigScene.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY-NC-SA 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng"]
---

# NavigScene: Bridging Local Perception and Global Navigation for Beyond-Visual-Range Autonomous Driving

> [!info] 论文信息
> arXiv [2507.05227](https://arxiv.org/abs/2507.05227) · v1 2025-07-07 · 发表：ACM Multimedia 2025
> PDF：[[xpeng/papers/03_2507.05227_NavigScene.pdf|本地 PDF]]
> 方向：端到端与VLA · 角色：小鹏主导
> 清单里的一句话（Claude 根据摘要写，请核对）：NavigScene：引入导航引导的自然语言数据，将全局导航信息融入超视距自动驾驶。
> 汇总：[[xpeng/小鹏-论文与报告汇总|小鹏论文与报告汇总]]

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

> Autonomous driving systems have made significant advances in Q&A, perception, prediction, and planning based on local visual information, yet they struggle to incorporate broader navigational context that human drivers routinely utilize. We address this critical gap between local sensor data and global navigation information by proposing NavigScene, an auxiliary navigation-guided natural language dataset that simulates a human-like driving environment within autonomous driving systems. Moreover, we develop three complementary paradigms to leverage NavigScene: (1) Navigation-guided Reasoning, which enhances vision-language models by incorporating navigation context into the prompting approach; (2) Navigation-guided Preference Optimization, a reinforcement learning method that extends Direct Preference Optimization to improve vision-language model responses by establishing preferences for navigation-relevant summarized information; and (3) Navigation-guided Vision-Language-Action model, which integrates navigation guidance and vision-language models with conventional driving models through feature fusion. Extensive experiments demonstrate that our approaches significantly improve performance across perception, prediction, planning, and question-answering tasks by enabling reasoning capabilities beyond visual range and improving generalization to diverse driving scenarios. This work represents a significant step toward more comprehensive autonomous driving systems capable of navigating complex, unfamiliar environments with greater reliability and safety.
