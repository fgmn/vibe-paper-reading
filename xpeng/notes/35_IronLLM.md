---
id: "35"
org: 小鹏
short: "IronLLM"
title: "IronLLM: Forging Compact Edge-Native Language Models for Real-Time Embodied Intelligence"
aliases: ["IronLLM"]
date: 2026-09-29
category: "机器人"
source: "小鹏主导"
product: "IRON（基础模型）"
partners: []
authors: ["Changdi Yang", "Fengquan Jiao", "Haochih Lin", "Haoran Yang", "Jing Xiao", "Liangyu Huo", "Suxin Lu", "Tiance Chen", "Wei Liu", "Yinggan Xu", "Yunxiang Lu", "Zai Zheng", "Zhirui Xie", "Zhongyang Che", "Ziyan Tang", "Zuoxiang Zhao", "Jian Yao"]
arxiv: "2609.36860"
pdf: "[[xpeng/papers/35_2609.36860_IronLLM.pdf]]"
code: ""
project: "https://xpeng-robotics.github.io/iron-fm"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# IronLLM: Forging Compact Edge-Native Language Models for Real-Time Embodied Intelligence

> [!info] 论文信息
> arXiv [2609.36860](https://arxiv.org/abs/2609.36860) · v1 2026-09-29
> PDF：[[xpeng/papers/35_2609.36860_IronLLM.pdf|本地 PDF]]
> [项目页](https://xpeng-robotics.github.io/iron-fm)
> 方向：机器人 · 角色：小鹏主导 · 产品：IRON（基础模型）
> 清单里的一句话（Claude 根据摘要写，请核对）：【机器人基础模型团队】IronLLM-0.6B：混合注意力+X-MTP的端侧实时具身语言模型。
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

> We present IronLLM-0.6B, a 654M-parameter language model designed for efficient on-device inference. IronLLM-0.6B combines a hybrid attention architecture with X-MTP, a lightweight shared-KV multi-token prediction design that eliminates per-depth KV-cache replay and employs a lightweight verification head for rollback-free drafting, achieving a 1.48x decoding speedup. The model is pretrained on approximately 6.2 trillion tokens using a quality-oriented data pipeline and is further post-trained with Multi-Domain On-Policy Distillation to integrate capabilities from domain-specialized teachers. To better meet the low-latency requirements of on-device scenarios, IronLLM-0.6B adopts an Instruct-Only design. Evaluations show that IronLLM-0.6B achieves competitive performance relative to larger models such as Qwen3.5-0.8B and MiniCPM5-1B, while producing more concise responses on many tasks. We further present IronLLM-0.6B-Light, which replaces RMSNorm with Dynamic Tanh and simplifies several computationally expensive components to improve inference and quantization efficiency. Together, the IronLLM models provide an effective performance-efficiency trade-off for resource-constrained deployment.
