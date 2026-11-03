---
id: "2-11"
org: 专题·语义3DGS与具身导航
short: "POINav"
title: "POINav: Benchmarking and Enhancing Final-Meters Arrival in Real-World Vision-Language Navigation"
aliases: ["POINav"]
date: 2026-05-27
category: "视觉语言导航"
venue: ""
affiliation: ""
semantic: false
authors: ["Ruiyan Gong", "Meisheng Zhang", "Yuxiang Zhao", "Mingchao Sun", "Yanfen Shen", "Zedong Chu", "Zhining Gu", "Wei Guo", "Xiaolong Cheng", "Qiming Li", "Kangning Niu", "Yanqing Zhu", "Xiaolong Wu", "Tianlun Li", "Mu Xu"]
arxiv: "2605.28237"
pdf: "[[topics/papers/语义3DGS与具身导航/2-11_2605.28237_POINav.pdf]]"
code: ""
project: ""
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation"]
---

# POINav: Benchmarking and Enhancing Final-Meters Arrival in Real-World Vision-Language Navigation

> [!info] 论文信息
> arXiv [2605.28237](https://arxiv.org/abs/2605.28237) · v1 2026-05-27
> PDF：[[topics/papers/语义3DGS与具身导航/2-11_2605.28237_POINav.pdf|本地 PDF]]
> 专题：[[topics/语义3DGS与具身导航#二、高斯地图导航（高斯不带语义）|语义3DGS与具身导航 · 二、高斯地图导航（高斯不带语义）]]
> 清单里的一句话（Claude 根据摘要写，请核对）：面向真实世界POI最后几米到达的VLN闭环基准，11个商业区由3DGS重建。

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

> Real-world navigation is fundamentally driven by Points of Interest (POIs), yet reaching a precise POI remains a critical "final-meters" challenge. Existing Vision-Language Navigation (VLN) benchmarks of POI-goal navigation often suffer from coarse granularity or significant sim-to-real gaps due to generated scene. To bridge this gap, we present POINav-Bench, the first benchmark designed for closed-loop evaluation of real-world POI-goal navigation. It comprises 11 commercial areas reconstructed from real-world captures using 3D Gaussian Splatting (3DGS), covering 126,398 $m^{2}$ in total and spanning 163 distinct POIs. With traversability-aware annotations and reference trajectories, POINav-Bench enables high-fidelity evaluation of navigation agents in realistic, POI-rich real-world environments. Building on this, we propose the POINav Brain-Action Framework where a Brain module performs POI-grounded reasoning to guide an Action module in predicting continuous waypoints for real-world execution. We further curate the POINav-Dataset, containing 70K real-world signage-entrance pairs. Experiments show that our framework provides a viable path toward refining real-world POI-goal navigation.
