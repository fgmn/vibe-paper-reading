---
id: "50"
org: 英伟达
short: "RoboTTT"
title: "RoboTTT: Context Scaling for Robot Policies"
aliases: ["RoboTTT"]
date: 2026-07-16
category: "操作与其他"
source: "英伟达主导"
partners: []
authors: ["Yunfan Jiang", "Yevgen Chebotar", "Ruijie Zheng", "Fengyuan Hu", "Yunhao Ge", "Jimmy Wu", "Tianyuan Dai", "Scott Reed", "Li Fei-Fei", "Yuke Zhu", "Linxi \"Jim\" Fan"]
arxiv: "2607.15275"
pdf: "[[nvidia/papers/50_2607.15275_RoboTTT.pdf]]"
code: ""
project: "http://research.nvidia.com/labs/gear/robottt/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# RoboTTT: Context Scaling for Robot Policies

> [!info] 论文信息
> arXiv [2607.15275](https://arxiv.org/abs/2607.15275) · v1 2026-07-16
> PDF：[[nvidia/papers/50_2607.15275_RoboTTT.pdf|本地 PDF]]
> [项目页](http://research.nvidia.com/labs/gear/robottt/)
> 系列：物理AI · 操作与其他 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：RoboTTT：用测试时训练层把视觉运动上下文扩展到 8K 步，不增加推理延迟地提升长时程策略。
> 汇总：[[nvidia/英伟达-论文与报告汇总|英伟达论文与报告汇总]]

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

> Recent robot foundation models operate with single-step or short-history visuomotor context. We introduce Test-Time-Training Robot Policies (RoboTTT), a robot model and training recipe that scale visuomotor context to 8K timesteps, three orders of magnitude beyond state-of-the-art policies, without growing inference latency. At this context length, we unlock new robot capabilities: one-shot in-context imitation from human video demonstrations, on-the-fly policy improvement, robustness to perturbations, and stronger performance on multi-stage, long-horizon tasks. We also observe, for the first time, steady gains in closed-loop performance as pretraining context length scales. At its core, RoboTTT integrates Test-Time Training into robot foundation models such as Vision-Language-Action policies, yielding a sequence model whose recurrent state consists of fast weights, parameters updated by gradient descent during both training and inference, compressing histories into weight space and retrieving contextual information for long-context conditioning. To scale training context length, the recipe combines sequence action forcing with truncated backpropagation through time. On challenging real-robot manipulation tasks, RoboTTT improves overall performance by 87% over the single-step context baseline and fully completes a five-minute, ten-stage assembly task, which no baseline ever does. RoboTTT trained with 8K-timestep context outperforms the same model pretrained with 1K timesteps by 62%, suggesting context length as a new scaling axis for robot foundation models. Videos are available at this https URL
