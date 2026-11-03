---
id: "2-06"
org: 专题·语义3DGS与具身导航
short: "IGL-Nav"
title: "IGL-Nav: Incremental 3D Gaussian Localization for Image-goal Navigation"
aliases: ["IGL-Nav"]
date: 2025-08-01
category: "目标/图像目标导航"
venue: "ICCV 2025"
affiliation: "Tsinghua University"
semantic: false
authors: ["Wenxuan Guo", "Xiuwei Xu", "Hang Yin", "Ziwei Wang", "Jianjiang Feng", "Jie Zhou", "Jiwen Lu"]
arxiv: "2508.00823"
pdf: "[[topics/papers/语义3DGS与具身导航/2-06_2508.00823_IGL-Nav.pdf]]"
code: "https://github.com/GWxuan/IGL-Nav"
project: "https://gwxuan.github.io/IGL-Nav/"
license: CC BY-NC-SA 4.0
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation"]
---

# IGL-Nav: Incremental 3D Gaussian Localization for Image-goal Navigation

> [!info] 论文信息
> arXiv [2508.00823](https://arxiv.org/abs/2508.00823) · v1 2025-08-01
> 发表：ICCV 2025 · 第一作者单位：Tsinghua University
> PDF：[[topics/papers/语义3DGS与具身导航/2-06_2508.00823_IGL-Nav.pdf|本地 PDF]]
> [代码](https://github.com/GWxuan/IGL-Nav) · [项目页](https://gwxuan.github.io/IGL-Nav/)
> 专题：[[topics/语义3DGS与具身导航#二、高斯地图导航（高斯不带语义）|语义3DGS与具身导航 · 二、高斯地图导航（高斯不带语义）]]
> 清单里的一句话（Claude 根据摘要写，请核对）：用前馈单目预测增量构建3DGS，先以离散空间匹配粗定位目标图像，近处再用可微渲染精解6-DoF目标位姿。

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

> Visual navigation with an image as goal is a fundamental and challenging problem. Conventional methods either rely on end-to-end RL learning or modular-based policy with topological graph or BEV map as memory, which cannot fully model the geometric relationship between the explored 3D environment and the goal image. In order to efficiently and accurately localize the goal image in 3D space, we build our navigation system upon the renderable 3D gaussian (3DGS) representation. However, due to the computational intensity of 3DGS optimization and the large search space of 6-DoF camera pose, directly leveraging 3DGS for image localization during agent exploration process is prohibitively inefficient. To this end, we propose IGL-Nav, an Incremental 3D Gaussian Localization framework for efficient and 3D-aware image-goal navigation. Specifically, we incrementally update the scene representation as new images arrive with feed-forward monocular prediction. Then we coarsely localize the goal by leveraging the geometric information for discrete space matching, which can be equivalent to efficient 3D convolution. When the agent is close to the goal, we finally solve the fine target pose with optimization via differentiable rendering. The proposed IGL-Nav outperforms existing state-of-the-art methods by a large margin across diverse experimental configurations. It can also handle the more challenging free-view image-goal setting and be deployed on real-world robotic platform using a cellphone to capture goal image at arbitrary pose. Project page: this https URL.
