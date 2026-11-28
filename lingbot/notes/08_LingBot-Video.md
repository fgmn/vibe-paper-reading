---
id: "08"
org: 蚂蚁灵波
short: "LingBot-Video"
title: "Scaling Mixture-of-Experts Video Pretraining for Embodied Intelligence"
aliases: ["LingBot-Video"]
date: 2026-07-08
category: "世界模型"
source: "蚂蚁灵波主导"
partners: []
authors: ["Shuailei Ma", "Jiaqi Liao", "Xinyang Wang", "Jingjing Wang", "Chaoran Feng", "Zijing Hu", "Chong Bao", "Zichen Xi", "Yuqi Gan", "Weisen Wang", "Yanhong Zeng", "Qin Zhao", "Zifan Shi", "Wei Wu", "Hao Ouyang", "Qiuyu Wang", "Shangzhan Zhang", "Jiahao Shao", "Yipengjing Sun", "Liangxiao Hu", "Lunke Pan", "Nan Xue", "Kecheng Zheng", "Yinghao Xu", "Xing Zhu", "Yujun Shen", "Ka Leong Cheng"]
arxiv: "2607.07675"
pdf: "[[lingbot/papers/08_2607.07675_LingBot-Video.pdf]]"
code: "https://github.com/robbyant/lingbot-video"
project: "https://technology.robbyant.com/lingbot-video"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "lingbot"]
---

# Scaling Mixture-of-Experts Video Pretraining for Embodied Intelligence

> [!info] 论文信息
> arXiv [2607.07675](https://arxiv.org/abs/2607.07675) · v1 2026-07-08
> PDF：[[lingbot/papers/08_2607.07675_LingBot-Video.pdf|本地 PDF]]
> [technology.robbyant.com](https://technology.robbyant.com/lingbot-video) · [github.com](https://github.com/robbyant/lingbot-video)
> 方向：世界模型 · 角色：蚂蚁灵波主导
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

> Despite the recent promise in robot control, video generative models suffer from a domain mismatch due to their primary focus on content creation. For example, their design inherently prioritizes visual fidelity and creativity over computational efficiency and physical realism. In this work, we present LingBot-Video, a DiT-based video pretraining paradigm specifically tailored for embodied intelligence. From the architecture perspective, we adopt the Mixture-of-Experts (MoE), instead of dense, framework to achieve a better trade-off between modeling capacity and inference efficiency, and manage to scale it up from scratch. From the data perspective, we construct a data profiling engine that augments standard internet videos with extensive robot-oriented footage, encompassing manipulation, navigation, and egocentric perspectives, to equip the base model with an intrinsic understanding of actions and world dynamics. From the training perspective, we develop a multi-dimensional reward system to enforce the alignment regarding physical rationality and task completion, going beyond standard criteria such as aesthetics, prompt-following, and motion consistency. Comprehensive evaluations validate its performance and efficiency as a video foundation model. We contribute LingBot-Video as the inaugural large-scale, open-source MoE video foundation model to the community, in a pioneering effort to bridge digital creativity and physical actuation.
