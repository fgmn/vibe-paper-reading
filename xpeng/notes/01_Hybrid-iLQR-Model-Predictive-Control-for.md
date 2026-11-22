---
id: "01"
org: 小鹏
short: "Hybrid iLQR Model Predictive Control for Contact Implicit Stabilization on Legged Robots"
title: "Hybrid iLQR Model Predictive Control for Contact Implicit Stabilization on Legged Robots"
aliases: ["Hybrid iLQR Model Predictive Control for Contact Implicit Stabilization on Legged Robots"]
date: 2022-07-11
category: "机器人"
source: "小鹏合作"
product: "足式机器人（四足）"
partners: []
authors: ["Nathan J. Kong", "Chuanzheng Li", "Aaron M. Johnson"]
arxiv: "2207.04591"
pdf: "[[xpeng/papers/01_2207.04591_Hybrid-iLQR-Model-Predictive-Control-for.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# Hybrid iLQR Model Predictive Control for Contact Implicit Stabilization on Legged Robots

> [!info] 论文信息
> arXiv [2207.04591](https://arxiv.org/abs/2207.04591) · v1 2022-07-11 · 最新 v2（2023-11-06）
> PDF：[[xpeng/papers/01_2207.04591_Hybrid-iLQR-Model-Predictive-Control-for.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏合作 · 产品：足式机器人（四足）
> 清单里的一句话（Claude 根据摘要写，请核对）：将混合iLQR扩展为接触隐式MPC，用于足式机器人稳定控制，作者含小鹏机器人（鹏行）美国团队，发表于T-RO。
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

> Model Predictive Control (MPC) is a popular strategy for controlling robots but is difficult for systems with contact due to the complex nature of hybrid dynamics. To implement MPC for systems with contact, dynamic models are often simplified or contact sequences fixed in time in order to plan trajectories efficiently. In this work, we extend Hybrid iterative Linear Quadratic Regulator to work in a MPC fashion (HiLQR MPC) by 1) modifying how the cost function is computed when contact modes do not align, 2) utilizing parallelizations when simulating rigid body dynamics, and 3) using efficient analytical derivative computations of the rigid body dynamics. The result is a system that can modify the contact sequence of the reference behavior and plan whole body motions cohesively -- which is crucial when dealing with large perturbations. HiLQR MPC is tested on two systems: first, the hybrid cost modification is validated on a simple actuated bouncing ball hybrid system. Then HiLQR MPC is compared against methods that utilize centroidal dynamic assumptions on a quadruped robot (Unitree A1). HiLQR MPC outperforms the centroidal methods in both simulation and hardware tests.
