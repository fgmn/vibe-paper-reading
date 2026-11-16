---
id: "25"
org: 英伟达
short: "PLD"
title: "Self-Improving Vision-Language-Action Models with Data Generation via Residual RL"
aliases: ["PLD"]
date: 2025-10-30
category: "操作与其他"
source: "英伟达合作"
partners: []
authors: ["Wenli Xiao", "Haotian Lin", "Andy Peng", "Haoru Xue", "Tairan He", "Yuqi Xie", "Fengyuan Hu", "Jimmy Wu", "Zhengyi Luo", "Linxi \"Jim\" Fan", "Guanya Shi", "Yuke Zhu"]
arxiv: "2511.00091"
pdf: "[[topics/papers/递归自我改进RSI/2-07_2511.00091_PLD.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# Self-Improving Vision-Language-Action Models with Data Generation via Residual RL

> [!info] 论文信息
> arXiv [2511.00091](https://arxiv.org/abs/2511.00091) · v1 2025-10-30
> PDF：[[topics/papers/递归自我改进RSI/2-07_2511.00091_PLD.pdf|本地 PDF]]
> 系列：物理AI · 操作与其他 · 角色：英伟达合作
> 清单里的一句话（Claude 根据摘要写，请核对）：PLD：用残差 RL 探测-学习-蒸馏三阶段自我改进 VLA，并生成分布感知数据回灌训练。
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

> Supervised fine-tuning (SFT) has become the de facto post-training strategy for large vision-language-action (VLA) models, but its reliance on costly human demonstrations limits scalability and generalization. We propose Probe, Learn, Distill (PLD), a three-stage plug-and-play framework that improves VLAs through residual reinforcement learning (RL) and distribution-aware data collection. In Stage 1, we train lightweight residual actors to probe failure regions of the VLA generalist. In Stage 2, we use a hybrid rollout scheme that aligns collected trajectories with the generalist's deployment distribution while capturing recovery behaviors. In Stage 3, we distill the curated trajectories back into the generalist with standard SFT. PLD achieves near-saturated 99% task success on LIBERO, over 50% gains in SimplerEnv, and 100% success on real-world Franka and YAM arm manipulation tasks. Ablations show that residual probing and distribution-aware replay are key to collecting deployment-aligned data that improves both seen and unseen tasks, offering a scalable path toward self-improving VLA models.
