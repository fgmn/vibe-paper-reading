---
id: "25"
org: 小鹏
short: "R2S-EGO"
title: "R2S-EGO: Dual-Proxy Refinement for Sparse-Capture Real-to-Sim"
aliases: ["R2S-EGO"]
date: 2026-08-07
category: "机器人"
source: "小鹏主导"
product: "通用（Real-to-Sim）"
partners: []
authors: ["Shuai Fang", "Xin Deng", "Yuchen Kang", "Zhenjiang Li", "Jie Chen"]
arxiv: "2608.06827"
pdf: "[[xpeng/papers/25_2608.06827_R2S-EGO.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# R2S-EGO: Dual-Proxy Refinement for Sparse-Capture Real-to-Sim

> [!info] 论文信息
> arXiv [2608.06827](https://arxiv.org/abs/2608.06827) · v1 2026-08-07
> PDF：[[xpeng/papers/25_2608.06827_R2S-EGO.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏主导 · 产品：通用（Real-to-Sim）
> 清单里的一句话（Claude 根据摘要写，请核对）：【XPENG Robotics】R2S-EGO：双代理精炼的稀疏采集Real-to-Sim场景重建。
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

> Real-to-sim (R2S) depends on scene representations that render observations along robot ego trajectories, yet dense multi-view capture limits per-environment real-image capture-count efficiency, and sparse human capture can leave behavior-scoped robot views under-supported. Camera-controlled synthesis can fill missing views, but its use in R2S requires behavior-admissible queries and capture-anchored structural conditioning. We present R2S-EGO, which couples a simulator-derived robot proxy that represents the behavior-scoped executable query domain with a capture-anchored geometry proxy that supplies scene-specific structural conditions. Within this domain, fixed- budget selection targets current support deficits for which geometry support is available. The generated observations are assimilated as pseudo-observations to refine the visual asset, while real captures remain anchors. The fused geometry proxy also supplies the scene collision surface, which is refreshed between rounds. Together, these updates refine the existing simulation scene while its robot dynamics and control stack stay fixed. Across 48 frozen Unitree G1 ego views in three Replica scenes, six-view R2S-EGO reaches 19.062 dB PSNR, compared with 14.226 dB for the strongest reported R2S baseline. Across five paired policy-training seeds, R2S-EGO achieves 82.5% +/- 6.8% real-G1 sitting success, compared with 10.0% +/- 10.5% for GaussGym.
