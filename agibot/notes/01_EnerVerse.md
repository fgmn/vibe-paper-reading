---
id: "01"
org: 智元
short: "EnerVerse"
title: "EnerVerse: Envisioning Embodied Future Space for Robotics Manipulation"
aliases: ["EnerVerse"]
date: 2025-01-03
category: "世界模型"
source: "智元主导"
product: "精灵 G1"
partners: []
authors: ["Siyuan Huang", "Liliang Chen", "Pengfei Zhou", "Shengcong Chen", "Zhengkai Jiang", "Yue Hu", "Yue Liao", "Peng Gao", "Hongsheng Li", "Maoqing Yao", "Guanghui Ren"]
arxiv: "2501.01895"
pdf: "[[agibot/papers/01_2501.01895_EnerVerse.pdf]]"
code: ""
project: "https://sites.google.com/view/enerverse"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# EnerVerse: Envisioning Embodied Future Space for Robotics Manipulation

> [!info] 论文信息
> arXiv [2501.01895](https://arxiv.org/abs/2501.01895) · v1 2025-01-03 · 最新 v3（2025-11-16） · 发表：NeurIPS 2025
> PDF：[[agibot/papers/01_2501.01895_EnerVerse.pdf|本地 PDF]]
> [项目页](https://sites.google.com/view/enerverse)
> 角色：智元主导 · 机型：精灵 G1
> 清单里的一句话（Claude 根据摘要写，请核对）：EnerVerse：分块自回归视频扩散的具身未来空间生成模型，配合 4D 高斯数据引擎用于操作策略。
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

> We introduce EnerVerse, a generative robotics foundation model that constructs and interprets embodied spaces. EnerVerse employs a chunk-wise autoregressive video diffusion framework to predict future embodied spaces from instructions, enhanced by a sparse context memory for long-term reasoning. To model the 3D robotics world, we adopt a multi-view video representation, providing rich perspectives to address challenges like motion ambiguity and 3D grounding. Additionally, EnerVerse-D, a data engine pipeline combining generative modeling with 4D Gaussian Splatting, forms a self-reinforcing data loop to reduce the sim-to-real gap. Leveraging these innovations, EnerVerse translates 4D world representations into physical actions via a policy head (EnerVerse-A), achieving state-of-the-art performance in both simulation and real-world tasks. For efficiency, EnerVerse-A reuses features from the first denoising step and predicts action chunks, achieving about 280 ms per 8-step action chunk on a single RTX 4090. Further video demos, dataset samples could be found in our project page.
