---
id: "44"
org: 英伟达
short: "T-Rex"
title: "T-Rex: Tactile-Reactive Dexterous Manipulation"
aliases: ["T-Rex"]
date: 2026-06-15
category: "操作与其他"
source: "英伟达合作"
partners: []
authors: ["Dantong Niu", "Zhuoyang Liu", "Zekai Wang", "Boning Shao", "Zhao-Heng Yin", "Anirudh Pai", "Yuvan Sharma", "Stefano Saravalle", "Ruijie Zheng", "Jing Wang", "Ryan Punamiya", "Mengda Xu", "Yuqi Xie", "Yunfan Jiang", "Letian Fu", "Konstantinos Kallidromitis", "Matteo Gioia", "Junyi Zhang", "Jiaxin Ge", "Haiwen Feng", "Fabio Galasso", "Wei Zhan", "David M. Chan", "Yutong Bai", "Roei Herzig", "Jiahui Lei", "Li Fei-Fei", "Ken Goldberg", "Jitendra Malik", "Pieter Abbeel", "Yuke Zhu", "Danfei Xu", "Linxi Fan", "Trevor Darrell"]
arxiv: "2606.17055"
pdf: "[[nvidia/papers/44_2606.17055_T-Rex.pdf]]"
code: ""
project: "https://tactile-rex.github.io/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# T-Rex: Tactile-Reactive Dexterous Manipulation

> [!info] 论文信息
> arXiv [2606.17055](https://arxiv.org/abs/2606.17055) · v1 2026-06-15 · 最新 v2（2026-06-18）
> PDF：[[nvidia/papers/44_2606.17055_T-Rex.pdf|本地 PDF]]
> [项目页](https://tactile-rex.github.io/)
> 系列：物理AI · 操作与其他 · 角色：英伟达合作
> 清单里的一句话（Claude 根据摘要写，请核对）：T-Rex：触觉反应式灵巧操作框架，结合触觉反馈实现接触丰富任务的闭环反应。
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

> The ability to react dynamically to tactile signals has long been considered crucial to agile human-level dexterity. Yet contemporary learning-based Vision-Language-Action (VLA) models for robotic manipulation generally either overlook the tactile modality or are limited to encoders with static cues, due in part to the scarcity of diverse training data and standardized evaluation, architectural constraints in current VLA models, and limitations of static tactile encoders. In this paper, we push the frontier of tactile-reactive manipulation by addressing all of these limitations. We propose a large-scale, 100-hour tactile-rich dataset collected via a novel, data-efficient recipe that prioritizes elementary motor primitives. To effectively exploit naturally high-frequency touch signals without sacrificing the existing capabilities of existing VLAs, we introduce a variable-rate Mixture-of-Transformers (MoT) architecture equipped with a novel temporal tactile VQ-VAE encoder. We demonstrate the effectiveness of tactile-reactive policies on 12 manipulation tasks requiring delicate force control and deformable object manipulation, achieving over 30% higher average success rate than the strongest baseline.
