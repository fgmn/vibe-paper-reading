---
id: "02"
org: 亮源
short: "LightNav-0"
title: "LightNav-0: Eliciting VLM Spatial Intelligence for Generalist Embodied Navigation"
aliases: ["LightNav-0"]
date: 2026-08-31
category: 导航
source: 亮源主导
partners: []
authors: ["Shaoan Wang", "Aocheng Luo", "Fei Huang", "Jingyi Xu", "Xiaoyang Wang", "Yueyu Wang", "Qianli Ma", "Fan Yang", "Ran Mei", "Jia Wei", "Jiangpeng Hu", "Xuhao Liu", "Hongming Chen", "Yuanbin Shao", "Yiyang Lin", "Ziliang Li", "Liang Pan", "Xinhang Liu", "Yuntao Ma", "Tingxiang Fan"]
arxiv: "2608.30935"
pdf: "[[lightorigins/papers/02_2608.30935_LightNav-0.pdf]]"
code: "https://github.com/lightorigins/LightNav-0"
project: "https://www.lightorigins.com/blog/lightnav-0"
huggingface: ["https://huggingface.co/LightOriginsHQ/LightNav-0", "https://huggingface.co/datasets/LightOriginsHQ/Light-INSIGHT-Bench"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "navigation", "vlm", "real2sim2real", "benchmark"]
---

# LightNav-0: Eliciting VLM Spatial Intelligence for Generalist Embodied Navigation

> [!info] 论文信息
> arXiv [2608.30935](https://arxiv.org/abs/2608.30935) · v1 2026-08-31 · 最新 v2（2026-09-09）
> PDF：[[lightorigins/papers/02_2608.30935_LightNav-0.pdf|本地 PDF]]
> [代码](https://github.com/lightorigins/LightNav-0) · [项目页](https://www.lightorigins.com/blog/lightnav-0) · [LightNav-0](https://huggingface.co/LightOriginsHQ/LightNav-0) · [Light-INSIGHT-Bench](https://huggingface.co/datasets/LightOriginsHQ/Light-INSIGHT-Bench) · [INSIGHT-Bench](https://github.com/lightorigins/Light-INSIGHT-Bench) · [官网 PDF](https://static.lightorigins.com/website/reports/lightnav-0-technical-report_02cfc2f.pdf)

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

> Embodied navigation requires agents to translate heterogeneous goals and visual observations into actions across tasks, environments, and robot embodiments. Modern vision-language models (VLMs) already encode spatial priors for visual grounding, spatial reasoning, and pointing, but these capabilities are rarely elicited directly for robot control. Existing navigation systems instead rely on task- or embodiment-specific components, fragmenting perception, reasoning, and action while offering limited generalization. Here we present LightNav-0, a compact generalist embodied navigation model that elicits the spatial intelligence of a pretrained VLM and aligns it with navigation, without task-specific prediction heads. LightNav-0 represents diverse navigation tasks through a unified token interface: dual-channel pointing expresses task-, scene-, and embodiment-agnostic spatial intent, while a residual vector-quantized action tokenizer maps this intent to precise, embodiment-specific trajectories. Together with temporally aware visual history compression, ER mid-training, supervised fine-tuning, and reinforcement learning, this formulation supports instruction following, open-vocabulary object navigation, and visual tracking within a single model. The navigation training corpus spans 2K+ scenes and 4K+ hours of embodied navigation data. LightNav-ER, the embodied-reasoning checkpoint used to initialize LightNav-0, attains the highest complete-set average across 8 embodied-reasoning benchmarks, while LightNav-0 achieves state-of-the-art monocular success rates across all 10 public navigation simulation settings. Real-world evaluations further demonstrate zero-shot generalization across robot embodiments, diverse scenes, and static and dynamic targets. These results establish compact VLMs as a unified and transferable backbone for generalist embodied navigation.
