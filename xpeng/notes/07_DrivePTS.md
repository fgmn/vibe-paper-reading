---
id: "07"
org: 小鹏
short: "DrivePTS"
title: "DrivePTS: A Progressive Learning Framework with Textual and Structural Enhancement for Driving Scene Generation"
aliases: ["DrivePTS"]
date: 2026-02-26
category: "仿真与数据"
source: "小鹏主导"
product: ""
partners: []
authors: ["Zhechao Wang", "Yiming Zeng", "Lufan Ma", "Zeqing Fu", "Chen Bai", "Ziyao Lin", "Cheng Lu"]
arxiv: "2602.22549"
pdf: "[[xpeng/papers/07_2602.22549_DrivePTS.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng"]
---

# DrivePTS: A Progressive Learning Framework with Textual and Structural Enhancement for Driving Scene Generation

> [!info] 论文信息
> arXiv [2602.22549](https://arxiv.org/abs/2602.22549) · v1 2026-02-26
> PDF：[[xpeng/papers/07_2602.22549_DrivePTS.pdf|本地 PDF]]
> 方向：仿真与数据 · 角色：小鹏主导
> 清单里的一句话（Claude 根据摘要写，请核对）：DrivePTS：文本与结构增强的渐进式学习框架，用于可控驾驶场景生成。
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

> Synthesis of diverse driving scenes serves as a crucial data augmentation technique for validating the robustness and generalizability of autonomous driving systems. Current methods aggregate high-definition (HD) maps and 3D bounding boxes as geometric conditions in diffusion models for conditional scene generation. However, implicit inter-condition dependency causes generation failures when control conditions change independently. Additionally, these methods suffer from insufficient details in both semantic and structural aspects. Specifically, brief and view-invariant captions restrict semantic contexts, resulting in weak background modeling. Meanwhile, the standard denoising loss with uniform spatial weighting neglects foreground structural details, causing visual distortions and blurriness. To address these challenges, we propose DrivePTS, which incorporates three key innovations. Firstly, our framework adopts a progressive learning strategy to mitigate inter-dependency between geometric conditions, reinforced by an explicit mutual information constraint. Secondly, a Vision-Language Model is utilized to generate multi-view hierarchical descriptions across six semantic aspects, providing fine-grained textual guidance. Thirdly, a frequency-guided structure loss is introduced to strengthen the model's sensitivity to high-frequency elements, improving foreground structural fidelity. Extensive experiments demonstrate that our DrivePTS achieves state-of-the-art fidelity and controllability in generating diverse driving scenes. Notably, DrivePTS successfully generates rare scenes where prior methods fail, highlighting its strong generalization ability.
