---
id: "06"
org: 小鹏
short: "Pip-Stereo"
title: "Pip-Stereo: Progressive Iterations Pruner for Iterative Optimization based Stereo Matching"
aliases: ["Pip-Stereo"]
date: 2026-02-24
category: "感知"
source: "小鹏主导"
product: ""
partners: []
authors: ["Jintu Zheng", "Qizhe Liu", "HuangXin Xu", "Zhuojie Chen"]
arxiv: "2602.20496"
pdf: "[[xpeng/papers/06_2602.20496_Pip-Stereo.pdf]]"
code: "https://github.com/XPENG-Aridge-AI"
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng"]
---

# Pip-Stereo: Progressive Iterations Pruner for Iterative Optimization based Stereo Matching

> [!info] 论文信息
> arXiv [2602.20496](https://arxiv.org/abs/2602.20496) · v1 2026-02-24 · 发表：CVPR 2026 (3D vision track)
> PDF：[[xpeng/papers/06_2602.20496_Pip-Stereo.pdf|本地 PDF]]
> [代码](https://github.com/XPENG-Aridge-AI)
> 方向：感知 · 角色：小鹏主导
> 清单里的一句话（Claude 根据摘要写，请核对）：Pip-Stereo：渐进式迭代剪枝，使迭代立体匹配可在边缘端实时部署（小鹏汇天/Aridge）。
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

> While iterative stereo matching achieves high accuracy, its dependence on Recurrent Neural Networks (RNN) hinders edge deployment, a challenge underexplored in existing researches. We analyze iterative refinement and reveal that disparity updates are spatially sparse and temporally redundant. First, we introduce a progressive iteration pruning strategy that suppresses redundant update steps, effectively collapsing the recursive computation into a near-single-pass inference. Second, we propose a collaborative monocular prior transfer framework that implicitly embeds depth priors without requiring a dedicated monocular encoder, thereby eliminating its associated computational burden. Third, we develop FlashGRU, a hardware-aware RNN operator leveraging structured sparsity and I/O-conscious design, achieving a 7.28$\times$ speedup, 76.6\% memory peak reduction and 80.9\% global memory requests reduction over natvie ConvGRUs under 2K resolution. Our PipStereo enables real-time, high-fidelity stereo matching on edge hardware: it processes 320$\times$640 frames in just 75ms on an NVIDIA Jetson Orin NX (FP16) and 19ms on RTX 4090, matching the accuracy of large iterative based models, and our generalization ability and accuracy far exceeds that of existing real-time methods. Our embedded AI projects will be updated at: this https URL.
