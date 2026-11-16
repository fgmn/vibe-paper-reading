---
id: "39"
org: 英伟达
short: "MotionBricks"
title: "MotionBricks: Scalable Real-Time Motions with Modular Latent Generative Model and Smart Primitives"
aliases: ["MotionBricks"]
date: 2026-04-27
category: "人形全身控制"
source: "英伟达主导"
partners: []
authors: ["Tingwu Wang", "Olivier Dionne", "Michael De Ruyter", "David Minor", "Davis Rempe", "Kaifeng Zhao", "Mathis Petrovich", "Ye Yuan", "Chenran Li", "Zhengyi Luo", "Brian Robison", "Xavier Blackwell", "Bernardo Antoniazzi", "Xue Bin Peng", "Yuke Zhu", "Simon Yuen"]
arxiv: "2604.24833"
pdf: "[[nvidia/papers/39_2604.24833_MotionBricks.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# MotionBricks: Scalable Real-Time Motions with Modular Latent Generative Model and Smart Primitives

> [!info] 论文信息
> arXiv [2604.24833](https://arxiv.org/abs/2604.24833) · v1 2026-04-27 · 发表：SIGGRAPH 2026 (ACM TOG)
> PDF：[[nvidia/papers/39_2604.24833_MotionBricks.pdf|本地 PDF]]
> 系列：物理AI · 人形全身控制 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：MotionBricks：模块化潜生成模型+智能原语的实时运动生成框架，可规模化生成大量技能用于角色与人形控制。
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

> Despite transformative advances in generative motion synthesis, real-time interactive motion control remains dominated by traditional techniques. In this work, we identify two key challenges in bridging research and production: 1) Real-time scalability: Industry applications demand real-time generation of a vast repertoire of motion skills, while generative methods exhibit significant degradation in quality and scalability under real-time computation constraints, and 2) Integration: Industry applications demand fine-grained multi-modal control involving velocity commands, style selection, and precise keyframes, a need largely unmet by existing text- or tag-driven models. To overcome these limitations, we introduce MotionBricks: a large-scale, real-time generative framework with a two-fold solution. First, we propose a large-scale modular latent generative backbone tailored for robust real-time motion generation, effectively modeling a dataset of over 350,000 motion clips with a single model. Second, we introduce smart primitives that provide a unified, robust, and intuitive interface for authoring both navigation and object interaction. Applications can be designed in a plug-and-play manner like assembling bricks without expert animation knowledge. Quantitatively, we show that MotionBricks produces state-of-the-art motion quality on open-source and proprietary datasets of various scales, while also achieving a real-time throughput of 15,000 FPS with 2ms latency. We demonstrate the flexibility and robustness of MotionBricks in a complete production-level animation demo, covering navigation and object-scene interaction across various styles with a unified model. To showcase our framework's application beyond animation, we deploy MotionBricks on the Unitree G1 humanoid robot to demonstrate its flexibility and generalization for real-time robotic control.
