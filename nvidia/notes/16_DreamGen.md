---
id: "16"
org: 英伟达
short: "DreamGen"
title: "DreamGen: Unlocking Generalization in Robot Learning through Video World Models"
aliases: ["DreamGen"]
date: 2025-05-19
category: "合成数据与世界模型"
source: "英伟达主导"
partners: []
authors: ["Joel Jang", "Seonghyeon Ye", "Zongyu Lin", "Jiannan Xiang", "Johan Bjorck", "Yu Fang", "Fengyuan Hu", "Spencer Huang", "Kaushil Kundalia", "Yen-Chen Lin", "Loic Magne", "Ajay Mandlekar", "Avnish Narayan", "You Liang Tan", "Guanzhi Wang", "Jing Wang", "Qi Wang", "Yinzhen Xu", "Xiaohui Zeng", "Kaiyuan Zheng", "Ruijie Zheng", "Ming-Yu Liu", "Luke Zettlemoyer", "Dieter Fox", "Jan Kautz", "Scott Reed", "Yuke Zhu", "Linxi Fan"]
arxiv: "2505.12705"
pdf: "[[nvidia/papers/16_2505.12705_DreamGen.pdf]]"
code: "https://github.com/NVIDIA/GR00T-Dreams"
project: "https://research.nvidia.com/labs/gear/dreamgen"
huggingface: ["nvidia/Cosmos-Predict2-14B-Sample-GR00T-Dreams-GR1", "nvidia/Cosmos-Predict2-14B-Sample-GR00T-Dreams-DROID"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia", "cosmos"]
---

# DreamGen: Unlocking Generalization in Robot Learning through Video World Models

> [!info] 论文信息
> arXiv [2505.12705](https://arxiv.org/abs/2505.12705) · v1 2025-05-19 · 最新 v2（2025-06-17）
> PDF：[[nvidia/papers/16_2505.12705_DreamGen.pdf|本地 PDF]]
> [代码](https://github.com/NVIDIA/GR00T-Dreams) · [项目页](https://research.nvidia.com/labs/gear/dreamgen)
> 系列：物理AI · 合成数据与世界模型 · 角色：英伟达主导 · 用到 Cosmos
> 清单里的一句话（Claude 根据摘要写，请核对）：DreamGen：微调视频世界模型生成“神经轨迹”并用 IDM/潜动作伪标注，让机器人策略泛化到新行为与新环境。
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

> We introduce DreamGen, a simple yet highly effective 4-stage pipeline for training robot policies that generalize across behaviors and environments through neural trajectories - synthetic robot data generated from video world models. DreamGen leverages state-of-the-art image-to-video generative models, adapting them to the target robot embodiment to produce photorealistic synthetic videos of familiar or novel tasks in diverse environments. Since these models generate only videos, we recover pseudo-action sequences using either a latent action model or an inverse-dynamics model (IDM). Despite its simplicity, DreamGen unlocks strong behavior and environment generalization: a humanoid robot can perform 22 new behaviors in both seen and unseen environments, while requiring teleoperation data from only a single pick-and-place task in one environment. To evaluate the pipeline systematically, we introduce DreamGen Bench, a video generation benchmark that shows a strong correlation between benchmark performance and downstream policy success. Our work establishes a promising new axis for scaling robot learning well beyond manual data collection. Code available at this https URL.
