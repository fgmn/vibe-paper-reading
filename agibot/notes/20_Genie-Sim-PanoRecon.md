---
id: "20"
org: 智元
short: "Genie Sim PanoRecon"
title: "Genie Sim PanoRecon: Fast Immersive Scene Generation from Single-View Panorama"
aliases: ["Genie Sim PanoRecon"]
date: 2026-04-08
category: "仿真"
source: "智元主导"
product: ""
partners: []
authors: ["Zhijun Li", "Yongxin Su", "Di Yang", "Jichao Wang", "Zheyuan Xing", "Qian Wang", "Maoqing Yao"]
arxiv: "2604.07105"
pdf: "[[agibot/papers/20_2604.07105_Genie-Sim-PanoRecon.pdf]]"
code: "https://github.com/AgibotTech/genie_sim/tree/main/source/geniesim_world"
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# Genie Sim PanoRecon: Fast Immersive Scene Generation from Single-View Panorama

> [!info] 论文信息
> arXiv [2604.07105](https://arxiv.org/abs/2604.07105) · v1 2026-04-08 · 最新 v3（2026-04-28）
> PDF：[[agibot/papers/20_2604.07105_Genie-Sim-PanoRecon.pdf|本地 PDF]]
> [代码](https://github.com/AgibotTech/genie_sim/tree/main/source/geniesim_world)
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：Genie Sim PanoRecon：从单张全景图前馈生成高斯泼溅 3D 场景，用于操作仿真。
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

> We present Genie Sim PanoRecon, a feed-forward Gaussian-splatting pipeline that delivers high-fidelity, low-cost 3D scenes for robotic manipulation simulation. The panorama input is decomposed into six non-overlapping cube-map faces, processed in parallel, and seamlessly reassembled. To guarantee geometric consistency across views, we devise a depth-aware fusion strategy coupled with a training-free depth-injection module that steers the monocular feed-forward network to generate coherent 3D Gaussians. The whole system reconstructs photo-realistic scenes in seconds and has been integrated into Genie Sim - a LLM-driven simulation platform for embodied synthetic data generation and evaluation - to provide scalable backgrounds for manipulation tasks. For code details, please refer to: this https URL.
