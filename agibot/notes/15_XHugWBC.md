---
id: "15"
org: 智元
short: "XHugWBC"
title: "Scalable and General Whole-Body Control for Cross-Humanoid Locomotion"
aliases: ["XHugWBC"]
date: 2026-02-05
category: "运动控制"
source: "其他团队使用"
product: "灵犀 X2"
partners: []
authors: ["Yufei Xue", "YunFeng Lin", "Wentao Dong", "Yang Tang", "Jingbo Wang", "Jiangmiao Pang", "Ming Zhou", "Minghuan Liu", "Weinan Zhang"]
arxiv: "2602.05791"
pdf: "[[agibot/papers/15_2602.05791_XHugWBC.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "agibot", "lingxi"]
---

# Scalable and General Whole-Body Control for Cross-Humanoid Locomotion

> [!info] 论文信息
> arXiv [2602.05791](https://arxiv.org/abs/2602.05791) · v1 2026-02-05 · 最新 v3（2026-06-09）
> PDF：[[agibot/papers/15_2602.05791_XHugWBC.pdf|本地 PDF]]
> 角色：其他团队使用 · 机型：灵犀 X2
> 清单里的一句话（Claude 根据摘要写，请核对）：跨本体人形全身控制框架XHugWBC，一次训练零样本泛化到含智元X2在内的多款真实人形。
> 灵犀依据：Interestingly, Fourier N1 and Agibot X2 also exhibit relatively large gaps despite having sizes comparable to Unitree G1, indicating that sim-to-real performance is influenced not only by robot scale but also by platform-specific actuation and mechanical characteristics.（https://arxiv.org/html/2602.05791 (Sec. 4 real-world velocity tracking results; SJTU / Shanghai AI Lab)）
> 汇总：[[agibot/智元-论文与报告汇总|智元论文与报告汇总]]

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

> Learning-based whole-body controllers have become a key driver for humanoid robots, yet most existing approaches require robot-specific training. In this paper, we study the problem of cross-embodiment humanoid control and show that a single policy can robustly generalize across a wide range of humanoid robot designs with one-time training. We introduce XHugWBC, a novel cross-embodiment training framework that enables generalist humanoid control through: (1) physics-consistent morphological randomization, (2) semantically aligned observation and action spaces across diverse humanoid robots, and (3) effective policy architectures modeling morphological and dynamical properties. XHugWBC is not tied to any specific robot. Instead, it internalizes a broad distribution of morphological and dynamical characteristics during training. By learning motion priors from diverse randomized embodiments, the policy acquires a strong structural bias that supports zero-shot transfer to previously unseen robots. Experiments on twelve simulated humanoids and seven real-world robots demonstrate the strong generalization and robustness of the resulting universal controller.
