---
id: "33"
org: 智元
short: "FOCUS"
title: "FOCUS: Foot Observation Confidence for Robust Humanoid Proprioceptive Odometry"
aliases: ["FOCUS"]
date: 2026-09-02
category: "运动控制"
source: "智元主导"
product: ""
partners: []
authors: ["Kaixin Feng", "Angsong Li", "Shaopeng Zhang", "Enyu Li", "Peiwen Lin", "Chuang Wang", "You Li", "Haiyu Lan"]
arxiv: "2609.02222"
pdf: "[[agibot/papers/33_2609.02222_FOCUS.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# FOCUS: Foot Observation Confidence for Robust Humanoid Proprioceptive Odometry

> [!info] 论文信息
> arXiv [2609.02222](https://arxiv.org/abs/2609.02222) · v1 2026-09-02
> PDF：[[agibot/papers/33_2609.02222_FOCUS.pdf|本地 PDF]]
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：FOCUS：以足端观测置信度替代二值接触判断，提升人形本体里程计鲁棒性。
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

> Foot forward kinematics (FK) is widely used to improve proprioceptive legged odometry by providing reliable velocity constraints during foot support. Existing contact-aided estimators generally rely on binary contact decisions to determine whether the FK measurements of an entire foot should be trusted. However, contact does not necessarily imply FK reliability. Dynamic locomotion often involves partial support, toe dragging, and foot slip, causing binary contact decisions to accumulate significant drift over long trajectories. To address this limitation, we propose FOCUS (Foot Observation Confidence from Unannotated Simulation), which predicts a continuous FK reliability weight for each foot instead of estimating binary foot contact. Rather than replacing the model-based estimator, the predicted reliability weights are used to blend FK velocity observations with IMU-propagated body velocity and to adapt the observation covariance of an extended Kalman filter (EKF), enabling smooth reliability-aware fusion without hard contact switching. The network is trained from automatically generated simulation signals using an FK-weighted velocity consistency loss with lightweight simulator-contact regularization, without manually annotated continuous FK-reliability labels. The deployed model relies only on IMU and joint kinematic measurements, making it suitable for hardware platforms with unreliable torque sensing. Experiments demonstrate that FOCUS reduces absolute trajectory error (ATE) by 83.7% on simulated walking episodes, preserves simulated dynamic-motion fidelity in motion scale and spectral energy, reduces ATE by 70.8% across 19 real walking segments, and reduces mean ATE by 42.7% across four real dynamic-motion routines.
