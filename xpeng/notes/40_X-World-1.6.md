---
id: "40"
org: 小鹏
short: "X-World 1.6"
title: "X-World 1.6: Building Controllable Virtual Cities with World Models"
aliases: ["X-World 1.6"]
date: 2026-10-31
category: "世界模型"
source: "小鹏主导"
product: ""
partners: []
authors: ["XPeng: Boyang Wang", "Boyi Sun", "Chaoda Zheng", "Dongbin Zhang", "Guangfeng Jiang", "Hanlong Chen", "Hongbin Lin", "Jianlei Zheng", "Jinhao Deng", "Kai Yang", "Kangjie Chen", "Linkun Xu", "Minqi Wang", "Puyi Wang", "Rongliang Cheng", "Ruixin Liu", "Shijia Chen", "Shuang Deng", "Sijia Chen", "Sin Wai Choo", "Tianyuan Xie", "Xiangyu Li", "Xianming Liu", "Xingjie Liu", "Xinlong Zheng", "Xuejie Lv", "Xuezhi Yang", "Yi Guo", "Yixiao Zeng", "Yu Zhang", "Yuecheng Ma", "Yuhao Wang", "Yuqi Zhang", "Yuxin Peng"]
arxiv: "2611.00596"
pdf: "[[xpeng/papers/40_2611.00596_X-World-1.6.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng"]
---

# X-World 1.6: Building Controllable Virtual Cities with World Models

> [!info] 论文信息
> arXiv [2611.00596](https://arxiv.org/abs/2611.00596) · v1 2026-10-31
> PDF：[[xpeng/papers/40_2611.00596_X-World-1.6.pdf|本地 PDF]]
> 方向：世界模型 · 角色：小鹏主导
> 清单里的一句话（Claude 根据摘要写，请核对）：X-World 1.6：升级驾驶世界模型，构建可控虚拟城市，支撑VLA 2.0闭环仿真与强化学习。
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

> Deploying generative world models for end-to-end closed-loop evaluation and policy learning requires precise scenario control, consistent observations, and sustained generation quality during extended interactions. This report presents X-World~1.6, advancing X-World~1.0 toward a more reliable and versatile driving simulator. The upgraded base model offers finer-grained control over traffic semantics, including traffic lights and road markings, together with improved spatial consistency across cameras. Virtual City capabilities broaden scenario construction through a family of models conditioned on diverse 2D and 3D references, including support for generating multi-camera future videos from a single image. An enhanced post-training framework enables efficient causal, few-step generation with stronger temporal coherence, better quality retention over longer rollouts, and improved alignment with human preferences. We also introduce a dedicated evaluation suite to support systematic assessment and guide model iteration. Together, these upgrades expand the scenarios X-World can simulate and improve the efficiency and reliability of its generated observations, supporting broader use in autonomous-driving development.
