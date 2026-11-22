---
id: "32"
org: 小鹏
short: "IronViT"
title: "IronViT: Toward Efficient Generalist Visual Representation Learning"
aliases: ["IronViT"]
date: 2026-09-24
category: "机器人"
source: "小鹏主导"
product: "IRON（基础模型）"
partners: []
authors: ["Jiaxi Huang", "Yueqi Hu", "Xin Zhu", "Xiaopeng Zhang", "Huiting Qiao", "Yanglin Zhang", "Zefeng Ji", "Rongxue Li", "Yifei Xu", "Huiying Yu", "Wei Liu", "Jiayin Zheng", "Yinggan Xu", "Peipeng Chen", "Yin Zhang", "Jian Yao"]
arxiv: "2609.29252"
pdf: "[[xpeng/papers/32_2609.29252_IronViT.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# IronViT: Toward Efficient Generalist Visual Representation Learning

> [!info] 论文信息
> arXiv [2609.29252](https://arxiv.org/abs/2609.29252) · v1 2026-09-24
> PDF：[[xpeng/papers/32_2609.29252_IronViT.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏主导 · 产品：IRON（基础模型）
> 清单里的一句话（Claude 根据摘要写，请核对）：【机器人基础模型团队】IronViT：多教师蒸馏到高效架构的通用视觉编码器。
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

> A generalist vision encoder must capture semantic, spatial, language-aligned, and action-relevant cues within a unified representation, yet softmax attention underlying today's most capable visual backbones becomes prohibitively expensive at high resolution. A natural attempt to address both challenges is to distill multiple specialist teachers directly into an efficient architecture. We find that directly coupling these objectives degrades representation quality, as the student must simultaneously reconcile heterogeneous capabilities and adapt them to a different token-mixing architecture. We introduce IronViT, built on a simple principle: consolidate capabilities before constraining computation. IronViT first distills complementary specialists into a softmax attention capability bridge, then progressively transfers the consolidated representation to a hybrid softmax-linear attention encoder. A purpose-built data pipeline further curates the distillation corpus for higher information density and broader domain coverage. Across recognition, retrieval, dense prediction, multimodal understanding, and robotic learning, IronViT is competitive with leading specialist and generalist vision encoders. The softmax bridge achieves the strongest aggregate performance in multimodal understanding and robotic learning among the evaluated backbones, while the hybrid encoder retains broad transfer performance with an efficiency advantage that grows with input resolution. Together, these results show that consolidating capabilities before architectural conversion can yield a generalist visual encoder without inheriting the prohibitive high-resolution cost of conventional softmax attention.
