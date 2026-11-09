---
id: "41"
org: 智元
short: "OVM-Occ"
title: "OVM-Occ: Open-Vocabulary Monocular Occupancy Prediction via Geometry-Aware Vision-Language Distillation"
aliases: ["OVM-Occ"]
date: 2026-10-26
category: "其他"
source: "智元主导"
product: ""
partners: []
authors: ["Shuyang Yu", "Haibo Qin", "Shaohan Hu", "Wei Shan", "Xiaoqing Guan", "You Wang", "Guang Li"]
arxiv: "2610.35312"
pdf: "[[agibot/papers/41_2610.35312_OVM-Occ.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# OVM-Occ: Open-Vocabulary Monocular Occupancy Prediction via Geometry-Aware Vision-Language Distillation

> [!info] 论文信息
> arXiv [2610.35312](https://arxiv.org/abs/2610.35312) · v1 2026-10-26
> PDF：[[agibot/papers/41_2610.35312_OVM-Occ.pdf|本地 PDF]]
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：OVM-Occ：几何感知视觉语言蒸馏的开放词汇单目占用预测。
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

> Monocular occupancy prediction in indoor scenes aims to recover a scene's 3D geometry and semantics from a single RGB image. Existing methods are restricted to a closed set of predefined categories, limiting their ability to generalize to unseen categories. This limitation is particularly critical in indoor scenes, where objects exhibit highly diverse and fine-grained semantic categories. We study open-vocabulary monocular occupancy prediction for indoor scenes and present OVM-Occ, a Gaussian-based occupancy framework with an instance-aware vision-language teacher. Specifically, we adopt Language-Embedded Gaussians as the intermediate scene representation, propose a geometry-aware deformable attention module to refine Gaussian semantic features, and construct instance-level vision-language embeddings to provide reliable semantic supervision. We further introduce geometry-aware decoupled semantic distillation to mitigate the interference between geometry learning and semantic learning. To evaluate open-vocabulary occupancy prediction performance, we introduce OpenOcc-ScanNet and OpenOcc-Replica, two extended benchmarks with more diverse and fine-grained semantic categories. Experiments show that our method achieves state-of-the-art performance in open-vocabulary monocular occupancy prediction for indoor scenes, outperforming the previous state-of-the-art approach by 12.2 mIoU and 0.6 IoU on the Occ-ScanNet dataset, with consistent gains under new open-vocabulary evaluation protocols.
