---
id: "09"
org: 英伟达
short: "ASAP"
title: "ASAP: Aligning Simulation and Real-World Physics for Learning Agile Humanoid Whole-Body Skills"
aliases: ["ASAP"]
date: 2025-02-03
category: "人形全身控制"
source: "英伟达合作"
partners: []
authors: ["Tairan He", "Jiawei Gao", "Wenli Xiao", "Yuanhang Zhang", "Zi Wang", "Jiashun Wang", "Zhengyi Luo", "Guanqi He", "Nikhil Sobanbab", "Chaoyi Pan", "Zeji Yi", "Guannan Qu", "Kris Kitani", "Jessica Hodgins", "Linxi \"Jim\" Fan", "Yuke Zhu", "Changliu Liu", "Guanya Shi"]
arxiv: "2502.01143"
pdf: "[[nvidia/papers/09_2502.01143_ASAP.pdf]]"
code: "https://github.com/LeCAR-Lab/ASAP"
project: "https://agile.human2humanoid.com/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# ASAP: Aligning Simulation and Real-World Physics for Learning Agile Humanoid Whole-Body Skills

> [!info] 论文信息
> arXiv [2502.01143](https://arxiv.org/abs/2502.01143) · v1 2025-02-03 · 最新 v3（2025-04-26） · 发表：RSS 2025
> PDF：[[nvidia/papers/09_2502.01143_ASAP.pdf|本地 PDF]]
> [代码](https://github.com/LeCAR-Lab/ASAP) · [项目页](https://agile.human2humanoid.com/)
> 系列：物理AI · 人形全身控制 · 角色：英伟达合作
> 清单里的一句话（Claude 根据摘要写，请核对）：ASAP：先在仿真预训练运动跟踪策略，再用真实数据学习残差动作模型对齐仿真与现实动力学，实现敏捷人形全身技能。
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

> Humanoid robots hold the potential for unparalleled versatility in performing human-like, whole-body skills. However, achieving agile and coordinated whole-body motions remains a significant challenge due to the dynamics mismatch between simulation and the real world. Existing approaches, such as system identification (SysID) and domain randomization (DR) methods, often rely on labor-intensive parameter tuning or result in overly conservative policies that sacrifice agility. In this paper, we present ASAP (Aligning Simulation and Real-World Physics), a two-stage framework designed to tackle the dynamics mismatch and enable agile humanoid whole-body skills. In the first stage, we pre-train motion tracking policies in simulation using retargeted human motion data. In the second stage, we deploy the policies in the real world and collect real-world data to train a delta (residual) action model that compensates for the dynamics mismatch. Then, ASAP fine-tunes pre-trained policies with the delta action model integrated into the simulator to align effectively with real-world dynamics. We evaluate ASAP across three transfer scenarios: IsaacGym to IsaacSim, IsaacGym to Genesis, and IsaacGym to the real-world Unitree G1 humanoid robot. Our approach significantly improves agility and whole-body coordination across various dynamic motions, reducing tracking error compared to SysID, DR, and delta dynamics learning baselines. ASAP enables highly agile motions that were previously difficult to achieve, demonstrating the potential of delta action learning in bridging simulation and real-world dynamics. These results suggest a promising sim-to-real direction for developing more expressive and agile humanoids.
