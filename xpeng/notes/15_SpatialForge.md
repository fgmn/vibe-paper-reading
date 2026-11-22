---
id: "15"
org: 小鹏
short: "SpatialForge"
title: "SpatialForge: Bootstrapping 3D-Aware Spatial Reasoning from Open-World 2D Images"
aliases: ["SpatialForge"]
date: 2026-05-12
category: "机器人"
source: "小鹏主导"
product: "通用（空间推理）"
partners: []
authors: ["Zishan Liu", "Ruoxi Zang", "Yanglin Zhang", "Wei Liu", "Yin Zhang", "Jian Yao", "Jiayin Zheng", "Zhengzhe Liu"]
arxiv: "2605.11462"
pdf: "[[xpeng/papers/15_2605.11462_SpatialForge.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# SpatialForge: Bootstrapping 3D-Aware Spatial Reasoning from Open-World 2D Images

> [!info] 论文信息
> arXiv [2605.11462](https://arxiv.org/abs/2605.11462) · v1 2026-05-12
> PDF：[[xpeng/papers/15_2605.11462_SpatialForge.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏主导 · 产品：通用（空间推理）
> 清单里的一句话（Claude 根据摘要写，请核对）：【XPENG Robotics】SpatialForge：从开放世界2D图像自举3D感知空间推理数据。
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

> Recent advancements in Large Vision-Language Models (VLMs) have demonstrated exceptional semantic understanding, yet these models consistently struggle with spatial reasoning, often failing at fundamental geometric tasks such as depth ordering and precise coordinate grounding. Recent efforts introduce spatial supervision from scene-centric datasets (e.g., multi-view scans or indoor video), but are constrained by the limited number of underlying scenes. As a result, the scale and diversity of such data remain significantly smaller than those of web-scale 2D image collections. To address this limitation, we propose SpatialForge, a scalable data synthesis pipeline that transforms in-the-wild 2D images into spatial reasoning supervision. Our approach decomposes spatial reasoning into perception and relation, and constructs structured supervision signals covering depth, layout, and viewpoint-dependent reasoning, with automatic verification to ensure data quality. Based on this pipeline, we build SpatialForge-10M, a large-scale dataset containing 10 million spatial QA pairs. Extensive experiments across multiple spatial reasoning benchmarks demonstrate that training on SpatialForge-10M significantly improves the spatial reasoning ability of standard VLMs, highlighting the effectiveness of scaling 2D data for 3D-aware spatial reasoning.
