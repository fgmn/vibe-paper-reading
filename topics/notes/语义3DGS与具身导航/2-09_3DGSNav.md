---
id: "2-09"
org: 专题·语义3DGS与具身导航
short: "3DGSNav"
title: "3DGSNav: Enhancing Vision-Language Model Reasoning for Object Navigation via Active 3D Gaussian Splatting"
aliases: ["3DGSNav"]
date: 2026-02-12
category: "目标/图像目标导航"
venue: ""
affiliation: "Zhejiang University of Technology"
semantic: false
authors: ["Wancai Zheng", "Hao Chen", "Xianlong Lu", "Linlin Ou", "Xinyi Yu"]
arxiv: "2602.12159"
pdf: "[[topics/papers/语义3DGS与具身导航/2-09_2602.12159_3DGSNav.pdf]]"
code: ""
project: "https://aczheng-cai.github.io/3dgsnav.github.io/"
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "3dgs", "navigation"]
---

# 3DGSNav: Enhancing Vision-Language Model Reasoning for Object Navigation via Active 3D Gaussian Splatting

> [!info] 论文信息
> arXiv [2602.12159](https://arxiv.org/abs/2602.12159) · v1 2026-02-12
> 第一作者单位：Zhejiang University of Technology
> PDF：[[topics/papers/语义3DGS与具身导航/2-09_2602.12159_3DGSNav.pdf|本地 PDF]]
> [项目页](https://aczheng-cai.github.io/3dgsnav.github.io/)
> 专题：[[topics/语义3DGS与具身导航#二、高斯地图导航（高斯不带语义）|语义3DGS与具身导航 · 二、高斯地图导航（高斯不带语义）]]
> 清单里的一句话（Claude 根据摘要写，请核对）：零样本物体导航框架：主动增量构建3DGS作为VLM的持久记忆，渲染前沿相关的第一人称视图并结合CoT提示与视角切换复核目标。

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

> Object navigation is a core capability of embodied intelligence, enabling an agent to locate target objects in unknown environments. Recent advances in vision-language models (VLMs) have facilitated zero-shot object navigation (ZSON). However, existing methods often rely on scene abstractions that convert environments into semantic maps or textual representations, causing high-level decision making to be constrained by the accuracy of low-level perception. In this work, we present 3DGSNav, a novel ZSON framework that embeds 3D Gaussian Splatting (3DGS) as persistent memory for VLMs to enhance spatial reasoning. Through active perception, 3DGSNav incrementally constructs a 3DGS representation of the environment, enabling trajectory-guided free-viewpoint rendering of frontier-aware first-person views. Moreover, we design structured visual prompts and integrate them with Chain-of-Thought (CoT) prompting to further improve VLM reasoning. During navigation, a real-time object detector filters potential targets, while VLM-driven active viewpoint switching performs target re-verification, ensuring efficient and reliable recognition. Extensive evaluations across multiple benchmarks and real-world experiments on a quadruped robot demonstrate that our method achieves robust and competitive performance against state-of-the-art this http URL Project Page:this https URL
