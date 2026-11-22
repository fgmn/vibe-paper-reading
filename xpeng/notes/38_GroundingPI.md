---
id: "38"
org: 小鹏
short: "GroundingPI"
title: "GroundingPI: A Grounding Foundation Model towards Physical Intelligence with Visual Primitives"
aliases: ["GroundingPI"]
date: 2026-09-30
category: "基础模型"
source: "小鹏主导"
product: ""
partners: []
authors: ["Qize Yu", "Lianrui Fan", "Boyu Chen", "Jiaqi Liang", "Xini Ding", "Yue Chen", "Zetian Song", "Yuran Wang", "Yi Zou", "Kaixuan Wang", "Tianxing Chen", "Wenxuan Song", "Bohan Zhou", "Mingleyang Li", "Siqiao Huang", "Yuqi Ye", "Caigao Jiang", "Wei Wei", "Ruihai Wu", "Hang Zhang", "Yixiao Ge", "Shuchang Zhou", "Shilong Liu", "Xianming Liu", "Ping Luo", "Shiyu Huang"]
arxiv: "2609.39601"
pdf: "[[xpeng/papers/38_2609.39601_GroundingPI.pdf]]"
code: "https://github.com/groundingpi/GroundingPI"
project: "https://groundingpi.github.io/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng"]
---

# GroundingPI: A Grounding Foundation Model towards Physical Intelligence with Visual Primitives

> [!info] 论文信息
> arXiv [2609.39601](https://arxiv.org/abs/2609.39601) · v1 2026-09-30 · 最新 v3（2026-11-19）
> PDF：[[xpeng/papers/38_2609.39601_GroundingPI.pdf|本地 PDF]]
> [代码](https://github.com/groundingpi/GroundingPI) · [项目页](https://groundingpi.github.io/)
> 方向：基础模型 · 角色：小鹏主导
> 清单里的一句话（Claude 根据摘要写，请核对）：GroundingPI：面向物理智能的4B视觉定位基础模型，支持视觉提示与实例粒度。
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

> Precise grounding matters. It specifies which object is the target and where that object is, even in clutter and for tiny objects, and it has to be fast enough for closed-loop control. Yet vision-language-action (VLA) and world-action models (WAMs) take perception from general-purpose vision-language and video-generation backbones, which still fail in these settings. We introduce GroundingPI, a 4B grounding foundation model that generates points and boxes as quantized coordinates in a shared vocabulary. Training combines multimodal and spatial pretraining, supervised fine-tuning, and reinforcement learning with GRPO, using supervision from public datasets and dedicated data engines. Against 44 baselines across 34 grounding benchmarks spanning 11 perceptual capabilities, GroundingPI establishes a new state of the art, averaging 73.68%, above the larger GPT-6 Astra (71.54%). As a downstream visual backbone, GroundingPI improves performance on robotic manipulation and autonomous driving. Across RoboTwin 2.0 and RoboCasa-GR1, it outperforms all evaluated backbones in all four out-of-distribution settings, with relative gains of up to 24.8% over the strongest baseline. On RoboCasa-GR1, GroundingPI trained with 50% of the demonstrations outperforms those baselines trained with 75%. Its mean open-loop L2 error on nuScenes is 0.296 m. We systematically analyze GroundingPI's pretraining in scale and data composition. Grounding quality and downstream manipulation improve with pretraining scale, with generalization tracking perceptual gains most closely. Analyzing the data recipe across these 11 perceptual capabilities shows dense grounding's substantial benefits for both, and OCR's potential as a catalyst for perceptual learning. These results support grounding as a perceptual foundation, and dedicated perceptual pretraining as a promising direction for foundation models of physical intelligence.
