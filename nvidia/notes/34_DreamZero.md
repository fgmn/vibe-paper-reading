---
id: "34"
org: 英伟达
short: "DreamZero"
title: "World Action Models are Zero-shot Policies"
aliases: ["DreamZero"]
date: 2026-02-17
category: "合成数据与世界模型"
source: "英伟达主导"
partners: []
authors: ["Seonghyeon Ye", "Yunhao Ge", "Kaiyuan Zheng", "Shenyuan Gao", "Sihyun Yu", "George Kurian", "Suneel Indupuru", "You Liang Tan", "Chuning Zhu", "Jiannan Xiang", "Ayaan Malik", "Kyungmin Lee", "William Liang", "Nadun Ranawaka", "Jiasheng Gu", "Yinzhen Xu", "Guanzhi Wang", "Fengyuan Hu", "Avnish Narayan", "Johan Bjorck", "Jing Wang", "Gwanghyun Kim", "Dantong Niu", "Ruijie Zheng", "Yuqi Xie", "Jimmy Wu", "Qi Wang", "Ryan Julian", "Danfei Xu", "Yilun Du", "Yevgen Chebotar", "Scott Reed", "Jan Kautz", "Yuke Zhu", "Linxi \"Jim\" Fan", "Joel Jang"]
arxiv: "2602.15922"
pdf: "[[nvidia/papers/34_2602.15922_DreamZero.pdf]]"
code: ""
project: "https://dreamzero0.github.io/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# World Action Models are Zero-shot Policies

> [!info] 论文信息
> arXiv [2602.15922](https://arxiv.org/abs/2602.15922) · v1 2026-02-17
> PDF：[[nvidia/papers/34_2602.15922_DreamZero.pdf|本地 PDF]]
> [项目页](https://dreamzero0.github.io/)
> 系列：物理AI · 合成数据与世界模型 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：DreamZero：基于预训练视频扩散骨干的世界动作模型（WAM），联合预测视频与动作，实现零样本策略泛化。
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

> State-of-the-art Vision-Language-Action (VLA) models excel at semantic generalization but struggle to generalize to unseen physical motions in novel environments. We introduce DreamZero, a World Action Model (WAM) built upon a pretrained video diffusion backbone. Unlike VLAs, WAMs learn physical dynamics by predicting future world states and actions, using video as a dense representation of how the world evolves. By jointly modeling video and action, DreamZero learns diverse skills effectively from heterogeneous robot data without relying on repetitive demonstrations. This results in over 2x improvement in generalization to new tasks and environments compared to state-of-the-art VLAs in real robot experiments. Crucially, through model and system optimizations, we enable a 14B autoregressive video diffusion model to perform real-time closed-loop control at 7Hz. Finally, we demonstrate two forms of cross-embodiment transfer: video-only demonstrations from other robots or humans yield a relative improvement of over 42% on unseen task performance with just 10-20 minutes of data. More surprisingly, DreamZero enables few-shot embodiment adaptation, transferring to a new embodiment with only 30 minutes of play data while retaining zero-shot generalization.
