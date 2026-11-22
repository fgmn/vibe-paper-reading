---
id: "08"
org: 小鹏
short: "Towards Motion Turing Test"
title: "Towards Motion Turing Test: Evaluating Human-Likeness in Humanoid Robots"
aliases: ["Towards Motion Turing Test"]
date: 2026-03-06
category: "机器人"
source: "其他团队使用小鹏机器人"
product: "IRON"
partners: []
authors: ["Mingzhe Li", "Mengyin Liu", "Zekai Wu", "Xincheng Lin", "Junsheng Zhang", "Ming Yan", "Zengye Xie", "Changwang Zhang", "Chenglu Wen", "Lan Xu", "Siqi Shen", "Cheng Wang"]
arxiv: "2603.06181"
pdf: "[[xpeng/papers/08_2603.06181_Towards-Motion-Turing-Test.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY-NC-ND 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# Towards Motion Turing Test: Evaluating Human-Likeness in Humanoid Robots

> [!info] 论文信息
> arXiv [2603.06181](https://arxiv.org/abs/2603.06181) · v1 2026-03-06
> PDF：[[xpeng/papers/08_2603.06181_Towards-Motion-Turing-Test.pdf|本地 PDF]]
> 方向：机器人 · 角色：其他团队使用小鹏机器人 · 产品：IRON
> 清单里的一句话（Claude 根据摘要写，请核对）：提出“运动图灵测试”评估人形机器人动作拟人度，并在小鹏IRON动作上做分布外评估。
> 汇总：[[xpeng/小鹏-论文与报告汇总|小鹏论文与报告汇总]]

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

> Humanoid robots have achieved significant progress in motion generation and control, exhibiting movements that appear increasingly natural and human-like. Inspired by the Turing Test, we propose the Motion Turing Test, a framework that evaluates whether human observers can discriminate between humanoid robot and human poses using only kinematic information. To facilitate this evaluation, we present the Human-Humanoid Motion (HHMotion) dataset, which consists of 1,000 motion sequences spanning 15 action categories, performed by 11 humanoid models and 10 human subjects. All motion sequences are converted into SMPL-X representations to eliminate the influence of visual appearance. We recruited 30 annotators to rate the human-likeness of each pose on a 0-5 scale, resulting in over 500 hours of annotation. Analysis of the collected data reveals that humanoid motions still exhibit noticeable deviations from human movements, particularly in dynamic actions such as jumping, boxing, and running. Building on HHMotion, we formulate a human-likeness evaluation task that aims to automatically predict human-likeness scores from motion data. Despite recent progress in multimodal large language models, we find that they remain inadequate for assessing motion human-likeness. To address this, we propose a simple baseline model and demonstrate that it outperforms several contemporary LLM-based methods. The dataset, code, and benchmark will be publicly released to support future research in the community.
