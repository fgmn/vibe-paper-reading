---
id: "30"
org: 智元
short: "OVIP-SG"
title: "OVIP-SG: Open-Vocabulary Instance-Preserving Scene Graphs for Mapping and Retrieval of Small, Fine-Grained Objects"
aliases: ["OVIP-SG"]
date: 2026-08-18
category: "导航"
source: "智元主导"
product: ""
partners: []
authors: ["Tianjing Hao", "Haiyu Lan", "Angsong Li", "Cheng Chen", "Enyu Li", "Jiarui Yang", "Yuning Su", "Peiwen Lin", "Wang Chuang"]
arxiv: "2608.17633"
pdf: "[[agibot/papers/30_2608.17633_OVIP-SG.pdf]]"
code: "https://github.com/Agibot-Spatial-Intelligence/OVIP-SG"
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# OVIP-SG: Open-Vocabulary Instance-Preserving Scene Graphs for Mapping and Retrieval of Small, Fine-Grained Objects

> [!info] 论文信息
> arXiv [2608.17633](https://arxiv.org/abs/2608.17633) · v1 2026-08-18 · 最新 v5（2026-09-02）
> PDF：[[agibot/papers/30_2608.17633_OVIP-SG.pdf|本地 PDF]]
> [代码](https://github.com/Agibot-Spatial-Intelligence/OVIP-SG)
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：OVIP-SG：保持实例一致的开放词汇 3D 场景图，用于小物体建图与检索。
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

> Integrating open-vocabulary perception into object-level 3D scene graphs is a double-edged sword. While vision-language detectors recover long-tail categories and small, fine-grained objects overlooked by closed-set models, they also tend to fragment large surfaces and merge small objects into larger neighboring objects, compromising instance-level consistency and undermining mapping fidelity. Moreover, existing methods struggle to retrieve previously unmapped targets or determine whether a queried object is absent, hindering robust embodied open-world navigation and exploration. We present OVIP-SG, a unified framework for instance-preserving semantic mapping, functional scene partitioning, and language-guided small, fine-grained object retrieval. OVIP-SG uses a vision-language model (VLM) to enumerate scene-specific categories for robust open-world detection. Symmetric 3D Intersection over Union (IoU) association and area-weighted feature fusion preserve small independent instances, while VLM-inferred object functions partition scenes into compact functional search regions. A four-stage cascaded retrieval pipeline further incorporates voxel voting and determines target absence from exploration coverage. Under a unified evaluation protocol on Replica, OVIP-SG outperforms ConceptGraphs by 6.31 points in class-mean accuracy (mAcc) and 5.15 points in frequency-weighted mIoU (F-mIoU) while achieving a class-agnostic native-instance Panoptic Quality (PQ) of 0.398. It reduces the search area to 21.8% of the indoor floor space and reaches 0.773 balanced accuracy for object-presence classification. Real-world robotic experiments further demonstrate its practical effectiveness. Code is available at this https URL.
