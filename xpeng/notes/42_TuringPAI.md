---
id: "42"
org: 小鹏
short: "TuringPAI"
title: "TuringPAI: A Foundation for On-Device Physical AI"
aliases: ["TuringPAI"]
date: 2026-11-19
category: "机器人"
source: "小鹏主导"
product: "通用（车+具身）"
partners: []
authors: ["Qiman Wu", "Hanlin Chen", "Yuhua Wei", "Mingyuan Wang", "Shaman Tang", "Minghao Li", "Rui Xin", "Xingye Liu", "Zhichao Yang", "Yiqi Yu", "Hongyan Pei", "Xiaowen Tian", "YingYing Liu", "Shiwen Liu", "Jiahui Hu", "Yizhao Wang", "Yuheng Zhang", "Anhua Liu", "Yue He", "Shuang Su", "Da Zhu", "Hua Zhou", "Pengfei Diao", "Haojie Yang", "Weichao Huang", "Hang Zhang", "Honggou Yang", "Xianming Liu"]
arxiv: "2611.25474"
pdf: "[[xpeng/papers/42_2611.25474_TuringPAI.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# TuringPAI: A Foundation for On-Device Physical AI

> [!info] 论文信息
> arXiv [2611.25474](https://arxiv.org/abs/2611.25474) · v1 2026-11-19
> PDF：[[xpeng/papers/42_2611.25474_TuringPAI.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏主导 · 产品：通用（车+具身）
> 清单里的一句话（Claude 根据摘要写，请核对）：TuringPAI：端侧物理AI模型家族，含VL、驾驶与具身操作三类模型。
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

> Physical AI requires models that understand spatial relationships and dynamic environments and translate observations into actions under limited onboard compute. We present TuringPAI, a family of models for on-device Physical AI comprising TuringPAI-VL for shared vision-language understanding, TuringPAI-Drive for autonomous driving, and TuringPAI-Embodied for robotic manipulation. TuringPAI-VL is a 0.65B model built on HybridViT-MLQ, which combines convolutional local aggregation with Transformer-based global modeling. Multi-scale Latent Queries integrate spatial features and observation history within the same visual Transformer, providing a compact, structured interface to the language model. Training combines general vision-language data with geometric, cross-view, and temporal supervision. TuringPAI-VL supports general multimodal understanding and improves quantitative geometric perception over Qwen2-VL-2B, while providing a shared initialization for the two downstream VLA models. For autonomous driving, TuringPAI-Drive maintains all evaluated ADE/FDE metrics within 1.2\% of a full-token HybridViT baseline using the MLQ interface and achieves comparable aggregate scores in an in-house simulation evaluation. Using XPeng Native Runtime (XNRT) on a single NVIDIA Orin-X SoC, TuringPAI-Drive generates trajectories at 12\,Hz in on-vehicle operation. For robotic manipulation, TuringPAI-Embodied achieves a 96.8\% average success rate across the four LIBERO suites. These results demonstrate a shared vision-language foundation for driving and robotic manipulation under practical on-device constraints.
