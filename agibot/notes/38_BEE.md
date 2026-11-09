---
id: "38"
org: 智元
short: "BEE"
title: "BEE: Intervention-Adaptive Real-World Reinforcement Learning with Vision-Language-Action Models"
aliases: ["BEE"]
date: 2026-09-23
category: "VLA/基础模型"
source: "智元主导"
product: ""
partners: []
authors: ["Weihui Zhao", "Xiaohan Yan", "Zunian Wan", "Xuan Du", "Zhaozhan Chi", "Jianbo Mao", "Ruipu Wu", "Rushuai Yang", "Houlin Li", "Shukai Yang", "Jing Wu", "Yuxiang Yan", "Yongcheng Liu", "Chuankang Li", "Guanghui Ren", "Wei Shan", "Maoqing Yao"]
arxiv: "2609.27450"
pdf: "[[agibot/papers/38_2609.27450_BEE.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# BEE: Intervention-Adaptive Real-World Reinforcement Learning with Vision-Language-Action Models

> [!info] 论文信息
> arXiv [2609.27450](https://arxiv.org/abs/2609.27450) · v1 2026-09-23
> PDF：[[agibot/papers/38_2609.27450_BEE.pdf|本地 PDF]]
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：BEE：干预自适应的 VLA 真实世界强化学习。
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

> Vision-language-action (VLA) models handle long-horizon manipulation, yet success hinges on a few precision-critical phases where millimeter-scale errors undo all prior progress. Online reinforcement learning (RL) can optimize exactly these actions, but free exploration is far too costly on real robots, which makes human corrections indispensable. However, existing online RL methods for VLAs either cannot incorporate such corrections or fold them into undifferentiated supervision. Yet human corrections are not uniformly noisy but reliable along some action dimensions and variable along others. Building on this, we introduce BEE, an intervention-adaptive framework for real-world RL on a frozen VLA that lets the policy go BEyond Expert imitation. We formulate human corrections not as actions to reproduce but as evidence about a constraint: a Correction Model predicts how a human would correct a given VLA proposal and how consistent the correction is along each action dimension. This predicted consistency sets the per-dimension tightness of a constraint on policy optimization. Where corrections are consistent the policy stays close to the human, and where they vary, the constraint relaxes. We evaluate BEE on three real-world manipulation tasks and one LIBERO-Pro simulation task at a matched online-data budget. BEE attains the highest success rate on every task, 91.2% on average against 57.5% for RLT and 42.1% for DSRL, and the lowest human intervention rate on all real-world tasks.
