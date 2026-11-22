---
id: "23"
org: 小鹏
short: "Be Faithful When Response"
title: "Be Faithful When Response: Returning Fluent and Grounded Answers for Vision-Language Models Reinforcement Learning"
aliases: ["Be Faithful When Response"]
date: 2026-06-29
category: "机器人"
source: "小鹏合作"
product: "通用（VLM强化学习）"
partners: []
authors: ["Peng Gao", "Yujian Lee", "Yin Zhang", "Yanglin Zhang", "Haonan Wu", "Zishan Liu", "Ruoxi Zang", "Xin Zhu", "Jiayin Zheng", "Jian Yao", "Zefeng Ji", "Fei Ma"]
arxiv: "2606.29984"
pdf: "[[xpeng/papers/23_2606.29984_Be-Faithful-When-Response.pdf]]"
code: ""
project: ""
huggingface: []
license: zero/1.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# Be Faithful When Response: Returning Fluent and Grounded Answers for Vision-Language Models Reinforcement Learning

> [!info] 论文信息
> arXiv [2606.29984](https://arxiv.org/abs/2606.29984) · v1 2026-06-29 · 最新 v2（2026-10-31）
> PDF：[[xpeng/papers/23_2606.29984_Be-Faithful-When-Response.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏合作 · 产品：通用（VLM强化学习）
> 清单里的一句话（Claude 根据摘要写，请核对）：【XPENG Robotics】在VLM强化学习中约束回答忠实于视觉证据，兼顾流畅与可溯源。
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

> Reinforcement Learning (RL) is an important paradigm for improving the reasoning capabilities of Vision-Language Models (VLMs). However, directly applying RL to rollout multimodal reasoning can lead to instability, due to the exploitation of language priors, the neglect of visual evidence, and the generation of reasoning traces that are fluent yet not visually grounded. The question arises: Can initially steer the policy toward visually faithful reasoning regime before applying reinforcement learning? To this end, we propose a Faithful Warm-Start (FWS) strategy that first curates samples with explicit vision-language causal relationships from six general VQA benchmarks to construct the FaithfulQA dataset, where each of the image-question pairs gains a certain degree of visual observations, question requirements, commonsense knowledge, domain knowledge, and the final answer. Subsequently, a VLM-based judge is employed to further purify the dataset, ensuring strong causal consistency and visual faithfulness. This warm-start stage equips the model with the capability to understand causally grounded vision-language patterns before subsequent RL optimization under sparse answer-level rewards. Experimental results show that such faithful supervision improves answer accuracy, stabilizes RL training, and reduces visually unsupported reasoning.
