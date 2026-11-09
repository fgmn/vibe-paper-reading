---
id: "44"
org: 智元
short: "Whole-Body Elasto-Geometrical Calibration of Wheeled Humanoid Robots Using a Shared-Waist Dual-Chain Model"
title: "Whole-Body Elasto-Geometrical Calibration of Wheeled Humanoid Robots Using a Shared-Waist Dual-Chain Model"
aliases: ["Whole-Body Elasto-Geometrical Calibration of Wheeled Humanoid Robots Using a Shared-Waist Dual-Chain Model"]
date: 2026-11-05
category: "运动控制"
source: "智元主导"
product: ""
partners: []
authors: ["Pengxin Zha", "Yi Lu", "Haojun Ma", "Jun Zhu", "Minghao Qiu", "Xiaoyan Wang", "Wei Shan", "Maoqing Yao"]
arxiv: "2611.07560"
pdf: "[[agibot/papers/44_2611.07560_Whole-Body-Elasto-Geometrical.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# Whole-Body Elasto-Geometrical Calibration of Wheeled Humanoid Robots Using a Shared-Waist Dual-Chain Model

> [!info] 论文信息
> arXiv [2611.07560](https://arxiv.org/abs/2611.07560) · v1 2026-11-05
> PDF：[[agibot/papers/44_2611.07560_Whole-Body-Elasto-Geometrical.pdf|本地 PDF]]
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：轮式人形机器人基于共享腰部的全身弹性-几何标定。
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

> Wheeled humanoid robots carry both arms on one actuated waist, usually without torque sensors, so the accuracy of both end-effectors depends on a single waist model. After a first stage that estimates the tracker and target extrinsics, we identify the waist and both arms in one problem from the target positions on both flanges, measured by an optical tracker. The kinematic model is complete, with waist-base, parallel-axis, and branch parameters; arm compliances are driven by measured torques and waist compliances by gravity torques of the robot's mass model; and Gaussian priors with evidence-maximizing scales stabilize the estimate. Independent and sequential single-chain calibration are restrictions of this problem, and its waist information is the sum of the single-chain Schur complements. On two robots with different waists, each without and with a payload, calibration reduces the mean errors on held-out poses from 11.3-31.1 mm to 0.50-1.11 mm. For every training-set size from 20 poses to all, the method has 17-63% lower mean errors than adaptations of two published whole-body calibration methods, mainly through the waist compliance. Independent calibration yields two waist models; using either for both arms raises the other arm's error to up to 3.21 mm.
