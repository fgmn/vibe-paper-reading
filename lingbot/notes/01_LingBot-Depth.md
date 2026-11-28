---
id: "01"
org: 蚂蚁灵波
short: "LingBot-Depth"
title: "Masked Depth Modeling for Spatial Perception"
aliases: ["LingBot-Depth"]
date: 2026-01-25
category: "感知与三维"
source: "蚂蚁灵波主导"
partners: []
authors: ["Bin Tan", "Changjiang Sun", "Xiage Qin", "Hanat Adai", "Zelin Fu", "Tianxiang Zhou", "Han Zhang", "Yinghao Xu", "Xing Zhu", "Yujun Shen", "Nan Xue"]
arxiv: "2601.17895"
pdf: "[[lingbot/papers/01_2601.17895_LingBot-Depth.pdf]]"
code: "https://github.com/robbyant/lingbot-depth"
project: "https://technology.robbyant.com/lingbot-depth"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "lingbot"]
---

# Masked Depth Modeling for Spatial Perception

> [!info] 论文信息
> arXiv [2601.17895](https://arxiv.org/abs/2601.17895) · v1 2026-01-25
> PDF：[[lingbot/papers/01_2601.17895_LingBot-Depth.pdf|本地 PDF]]
> [github.com](https://github.com/robbyant/lingbot-depth) · [technology.robbyant.com](https://technology.robbyant.com/lingbot-depth)
> 方向：感知与三维 · 角色：蚂蚁灵波主导
> 汇总：[[lingbot/蚂蚁灵波-论文汇总|蚂蚁灵波论文汇总]]

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

> Spatial visual perception is a fundamental requirement in physical-world applications like autonomous driving and robotic manipulation, driven by the need to interact with 3D environments. Capturing pixel-aligned metric depth using RGB-D cameras would be the most viable way, yet it usually faces obstacles posed by hardware limitations and challenging imaging conditions, especially in the presence of specular or texture-less surfaces. In this work, we argue that the inaccuracies from depth sensors can be viewed as "masked" signals that inherently reflect underlying geometric ambiguities. Building on this motivation, we present LingBot-Depth, a depth completion model which leverages visual context to refine depth maps through masked depth modeling and incorporates an automated data curation pipeline for scalable training. It is encouraging to see that our model outperforms top-tier RGB-D cameras in terms of both depth precision and pixel coverage. Experimental results on a range of downstream tasks further suggest that LingBot-Depth offers an aligned latent representation across RGB and depth modalities. We release the code, checkpoint, and 3M RGB-depth pairs (including 2M real data and 1M simulated data) to the community of spatial perception.
