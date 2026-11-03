---
id: "2-02"
org: 专题·语义3DGS与具身导航
short: "Openfly"
title: "Openfly: A comprehensive platform for aerial vision-language navigation"
aliases: ["Openfly"]
date: 2025-02-25
category: "视觉语言导航"
venue: "ICLR 2026"
affiliation: ""
semantic: false
authors: ["Yunpeng Gao", "Chenhui Li", "Zhongrui You", "Junli Liu", "Zhen Li", "Pengan Chen", "Qizhi Chen", "Zhonghan Tang", "Liansheng Wang", "Penghui Yang", "Yiwen Tang", "Yuhang Tang", "Shuai Liang", "Songyi Zhu", "Ziqin Xiong", "Yifei Su", "Xinyi Ye", "Jianan Li", "Yan Ding", "Dong Wang", "Xuelong Li", "Zhigang Wang", "Bin Zhao"]
arxiv: "2502.18041"
pdf: "[[topics/papers/语义3DGS与具身导航/2-02_2502.18041_Openfly.pdf]]"
code: ""
project: ""
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation"]
---

# Openfly: A comprehensive platform for aerial vision-language navigation

> [!info] 论文信息
> arXiv [2502.18041](https://arxiv.org/abs/2502.18041) · v1 2025-02-25 · 最新 v7（2026-03-01）
> 发表：ICLR 2026
> PDF：[[topics/papers/语义3DGS与具身导航/2-02_2502.18041_Openfly.pdf|本地 PDF]]
> 专题：[[topics/语义3DGS与具身导航#二、高斯地图导航（高斯不带语义）|语义3DGS与具身导航 · 二、高斯地图导航（高斯不带语义）]]
> 清单里的一句话（Claude 根据摘要写，请核对）：空中VLN平台，集成UE、GTA V、Google Earth与3DGS等渲染引擎，提供10万条轨迹基准与OpenFly-Agent。

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

> Vision-Language Navigation (VLN) aims to guide agents by leveraging language instructions and visual cues, playing a pivotal role in embodied AI. Indoor VLN has been extensively studied, whereas outdoor aerial VLN remains underexplored. The potential reason is that outdoor aerial view encompasses vast areas, making data collection more challenging, which results in a lack of benchmarks. To address this problem, we propose OpenFly, a platform comprising various rendering engines, a versatile toolchain, and a large-scale benchmark for aerial VLN. Firstly, we integrate diverse rendering engines and advanced techniques for environment simulation, including Unreal Engine, GTA V, Google Earth, and 3D Gaussian Splatting (3D GS). Particularly, 3D GS supports real-to-sim rendering, further enhancing the realism of our environments. Secondly, we develop a highly automated toolchain for aerial VLN data collection, streamlining point cloud acquisition, scene semantic segmentation, flight trajectory creation, and instruction generation. Thirdly, based on the toolchain, we construct a large-scale aerial VLN dataset with 100k trajectories, covering diverse heights and lengths across 18 scenes. Moreover, we propose OpenFly-Agent, a keyframe-aware VLN model emphasizing key observations during flight. For benchmarking, extensive experiments and analyses are conducted, evaluating several recent VLN methods and showcasing the superiority of our OpenFly platform and agent. The toolchain, dataset, and codes will be open-sourced.
