---
id: "16"
org: 自变量
short: "IK-Hierarchical-Decision"
title: "Integrated Hierarchical Decision-Making in Inverse Kinematic Planning and Control"
aliases: ["IK-Hierarchical-Decision"]
date: 2024-12-02
category: 运动控制
source: 合作
partners: ["西交利物浦大学", "CNRS"]
authors: ["Kai Pfeiffer", "Quan Zhang", "Yuqing Chen", "Gordon Boateng", "Yuquan Wang", "Vincent Bonnet", "Abderrahmane Kheddar"]
arxiv: "2412.01324"
pdf: "[[xsquare/papers/16_RSS2026-p185_Integrated-Hierarchical-Decision-Making-IK.pdf]]"
code: ""
project: ""
huggingface: []
license: RSS 论文集版本
status: 未读
rating:
read_date:
tags: ["paper", "inverse-kinematics", "whole-body-control"]
---

# Integrated Hierarchical Decision-Making in Inverse Kinematic Planning and Control

> [!info] 论文信息
> arXiv [2412.01324](https://arxiv.org/abs/2412.01324) · v1 2024-12-02 · 最新 v5（2026-06-06）
> PDF：[[xsquare/papers/16_RSS2026-p185_Integrated-Hierarchical-Decision-Making-IK.pdf|本地 PDF]]
> [RSS 2026](https://doi.org/10.15607/rss.2026.xxii.185)
> 合作单位：西交利物浦大学、CNRS

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

> This work presents a novel and efficient nonlinear programming framework that tightly integrates hierarchical decision-making with whole-body inverse kinematic planning and control. Decision-making plays a central role in many aspects of robotics, from sparse inverse kinematic control with a minimal number of joints, to inverse kinematic planning while simultaneously selecting a discrete end-effector location from multiple candidates. Current approaches often rely on heavy computations using mixed-integer nonlinear programming, separate decision-making from inverse kinematics (some times approximated by reachability methods), or employ efficient but less versatile $\ell_1$-norm formulations of linear sparse programming, without addressing the underlying nonlinear problem formulations. In contrast, the proposed sparse hierarchical nonlinear programming solver is efficient, versatile, and accurate by exploiting sparse hierarchical structure and leveraging the $\ell_0$-norm which is rarely used in robotics. The solver efficiently tackles complex nonlinear hierarchical decision-making problems previously unaddressed in the literature, such as inverse kinematic planning with simultaneous prioritized selection of end-effector locations from a large set of candidates, or inverse kinematic control with simultaneous selection of bi-manual grasp locations on a randomly rotated box.
