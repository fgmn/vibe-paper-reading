---
id: "17"
org: 英伟达
short: "FLARE"
title: "FLARE: Robot Learning with Implicit World Modeling"
aliases: ["FLARE"]
date: 2025-05-21
category: "合成数据与世界模型"
source: "英伟达主导"
partners: []
authors: ["Ruijie Zheng", "Jing Wang", "Scott Reed", "Johan Bjorck", "Yu Fang", "Fengyuan Hu", "Joel Jang", "Kaushil Kundalia", "Zongyu Lin", "Loic Magne", "Avnish Narayan", "You Liang Tan", "Guanzhi Wang", "Qi Wang", "Jiannan Xiang", "Yinzhen Xu", "Seonghyeon Ye", "Jan Kautz", "Furong Huang", "Yuke Zhu", "Linxi Fan"]
arxiv: "2505.15659"
pdf: "[[nvidia/papers/17_2505.15659_FLARE.pdf]]"
code: ""
project: "https://research.nvidia.com/labs/gear/flare"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# FLARE: Robot Learning with Implicit World Modeling

> [!info] 论文信息
> arXiv [2505.15659](https://arxiv.org/abs/2505.15659) · v1 2025-05-21
> PDF：[[nvidia/papers/17_2505.15659_FLARE.pdf|本地 PDF]]
> [项目页](https://research.nvidia.com/labs/gear/flare)
> 系列：物理AI · 合成数据与世界模型 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：FLARE：在扩散策略中加入未来潜表征对齐的隐式世界建模目标，提升策略性能并可从无动作人类视频学习。
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

> We introduce $F$uture $LA$tent $RE$presentation Alignment ($FLARE$), a novel framework that integrates predictive latent world modeling into robot policy learning. By aligning features from a diffusion transformer with latent embeddings of future observations, $FLARE$ enables a diffusion transformer policy to anticipate latent representations of future observations, allowing it to reason about long-term consequences while generating actions. Remarkably lightweight, $FLARE$ requires only minimal architectural modifications -- adding a few tokens to standard vision-language-action (VLA) models -- yet delivers substantial performance gains. Across two challenging multitask simulation imitation learning benchmarks spanning single-arm and humanoid tabletop manipulation, $FLARE$ achieves state-of-the-art performance, outperforming prior policy learning baselines by up to 26%. Moreover, $FLARE$ unlocks the ability to co-train with human egocentric video demonstrations without action labels, significantly boosting policy generalization to a novel object with unseen geometry with as few as a single robot demonstration. Our results establish $FLARE$ as a general and scalable approach for combining implicit world modeling with high-frequency robotic control.
