---
id: "04"
org: 蚂蚁灵波
short: "LingBot-VA"
title: "Causal World Modeling for Robot Control"
aliases: ["LingBot-VA"]
date: 2026-01-29
category: "世界-动作模型"
source: "蚂蚁灵波主导"
partners: []
authors: ["Lin Li", "Qihang Zhang", "Yiming Luo", "Shuai Yang", "Ruilin Wang", "Fei Han", "Mingrui Yu", "Zelin Gao", "Nan Xue", "Xing Zhu", "Yujun Shen", "Yinghao Xu"]
arxiv: "2601.21998"
pdf: "[[lingbot/papers/04_2601.21998_LingBot-VA.pdf]]"
code: "https://github.com/robbyant/lingbot-va"
project: "https://technology.robbyant.com/lingbot-va"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "lingbot"]
---

# Causal World Modeling for Robot Control

> [!info] 论文信息
> arXiv [2601.21998](https://arxiv.org/abs/2601.21998) · v1 2026-01-29 · 最新 v2（2026-03-22）
> PDF：[[lingbot/papers/04_2601.21998_LingBot-VA.pdf|本地 PDF]]
> [github.com](https://github.com/robbyant/lingbot-va) · [technology.robbyant.com](https://technology.robbyant.com/lingbot-va)
> 方向：世界-动作模型 · 角色：蚂蚁灵波主导
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

> This work highlights that video world modeling, alongside vision-language pre-training, establishes a fresh and independent foundation for robot learning. Intuitively, video world models provide the ability to imagine the near future by understanding the causality between actions and visual dynamics. Inspired by this, we introduce LingBot-VA, an autoregressive diffusion framework that learns frame prediction and policy execution simultaneously. Our model features three carefully crafted designs: (1) a shared latent space, integrating vision and action tokens, driven by a Mixture-of-Transformers (MoT) architecture, (2) a closed-loop rollout mechanism, allowing for ongoing acquisition of environmental feedback with ground-truth observations, (3) an asynchronous inference pipeline, parallelizing action prediction and motor execution to support efficient control. We evaluate our model on both simulation benchmarks and real-world scenarios, where it shows significant promise in long-horizon manipulation, data efficiency in post-training, and strong generalizability to novel configurations. The code and model are made publicly available to facilitate the community.
