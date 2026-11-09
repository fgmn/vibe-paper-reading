---
id: "06"
org: 智元
short: "DualTHOR"
title: "DualTHOR: A Dual-Arm Humanoid Simulation Platform for Contingency-Aware Planning"
aliases: ["DualTHOR"]
date: 2025-06-19
category: "仿真"
source: "智元合作"
product: "灵犀 X1"
partners: []
authors: ["Boyu Li", "Siyuan He", "Hang Xu", "Haoqi Yuan", "Yu Zang", "Liwei Hu", "Junpeng Yue", "Zhenxiong Jiang", "Pengbo Hu", "Börje F. Karlsson", "Yehui Tang", "Zongqing Lu"]
arxiv: "2506.16012"
pdf: "[[agibot/papers/06_2506.16012_DualTHOR.pdf]]"
code: "https://github.com/ds199895/DualTHOR.git"
project: ""
huggingface: []
license: 
status: 未读
rating:
read_date:
tags: ["paper", "agibot", "lingxi"]
---

# DualTHOR: A Dual-Arm Humanoid Simulation Platform for Contingency-Aware Planning

> [!info] 论文信息
> arXiv [2506.16012](https://arxiv.org/abs/2506.16012) · v1 2025-06-19 · 最新 v2（2025-10-13）
> PDF：[[agibot/papers/06_2506.16012_DualTHOR.pdf|本地 PDF]]
> [代码](https://github.com/ds199895/DualTHOR.git)
> 角色：智元合作 · 机型：灵犀 X1
> 清单里的一句话（Claude 根据摘要写，请核对）：DualTHOR：面向双臂人形机器人的物理仿真平台，引入执行随机失败以研究应变规划（已撤稿）。
> 灵犀依据：DualTHOR mainly explores the long-horizon planning and adaptation capabilities for humanoid robots, including pre-defined Unitree H1 ( Unitree, 2024a ) and Agibot X1 ( Agibot, 2024 ) robots.（https://arxiv.org/html/2506.16012v1 (Sec. 3; affiliations include AgiBot). NOTE: arXiv abs page marks the paper as withdrawn）
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

> Developing embodied agents capable of performing complex interactive tasks in real-world scenarios remains a fundamental challenge in embodied AI. Although recent advances in simulation platforms have greatly enhanced task diversity to train embodied Vision Language Models (VLMs), most platforms rely on simplified robot morphologies and bypass the stochastic nature of low-level execution, which limits their transferability to real-world robots. To address these issues, we present a physics-based simulation platform DualTHOR for complex dual-arm humanoid robots, built upon an extended version of AI2-THOR. Our simulator includes real-world robot assets, a task suite for dual-arm collaboration, and inverse kinematics solvers for humanoid robots. We also introduce a contingency mechanism that incorporates potential failures through physics-based low-level execution, bridging the gap to real-world scenarios. Our simulator enables a more comprehensive evaluation of the robustness and generalization of VLMs in household environments. Extensive evaluations reveal that current VLMs struggle with dual-arm coordination and exhibit limited robustness in realistic environments with contingencies, highlighting the importance of using our simulator to develop more capable VLMs for embodied tasks. The code is available at this https URL.
