---
id: "05"
org: 英伟达
short: "MaskedMimic"
title: "MaskedMimic: Unified Physics-Based Character Control Through Masked Motion Inpainting"
aliases: ["MaskedMimic"]
date: 2024-09-22
category: "人形全身控制"
source: "英伟达主导"
partners: []
authors: ["Chen Tessler", "Yunrong Guo", "Ofir Nabati", "Gal Chechik", "Xue Bin Peng"]
arxiv: "2409.14393"
pdf: "[[nvidia/papers/05_2409.14393_MaskedMimic.pdf]]"
code: ""
project: "https://research.nvidia.com/labs/par/maskedmimic/"
huggingface: []
license: CC BY-NC-SA 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# MaskedMimic: Unified Physics-Based Character Control Through Masked Motion Inpainting

> [!info] 论文信息
> arXiv [2409.14393](https://arxiv.org/abs/2409.14393) · v1 2024-09-22 · 发表：SIGGRAPH Asia 2024 (ACM TOG)
> PDF：[[nvidia/papers/05_2409.14393_MaskedMimic.pdf|本地 PDF]]
> [项目页](https://research.nvidia.com/labs/par/maskedmimic/)
> 系列：物理AI · 人形全身控制 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：MaskedMimic：把基于物理的角色控制统一建模为运动修补问题，单一策略支持多种条件控制。
> 汇总：[[nvidia/英伟达-论文与报告汇总|英伟达论文与报告汇总]]

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

> Crafting a single, versatile physics-based controller that can breathe life into interactive characters across a wide spectrum of scenarios represents an exciting frontier in character animation. An ideal controller should support diverse control modalities, such as sparse target keyframes, text instructions, and scene information. While previous works have proposed physically simulated, scene-aware control models, these systems have predominantly focused on developing controllers that each specializes in a narrow set of tasks and control modalities. This work presents MaskedMimic, a novel approach that formulates physics-based character control as a general motion inpainting problem. Our key insight is to train a single unified model to synthesize motions from partial (masked) motion descriptions, such as masked keyframes, objects, text descriptions, or any combination thereof. This is achieved by leveraging motion tracking data and designing a scalable training method that can effectively utilize diverse motion descriptions to produce coherent animations. Through this process, our approach learns a physics-based controller that provides an intuitive control interface without requiring tedious reward engineering for all behaviors of interest. The resulting controller supports a wide range of control modalities and enables seamless transitions between disparate tasks. By unifying character control through motion inpainting, MaskedMimic creates versatile virtual characters. These characters can dynamically adapt to complex scenes and compose diverse motions on demand, enabling more interactive and immersive experiences.
