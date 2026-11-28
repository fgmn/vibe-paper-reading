---
id: "11"
org: 蚂蚁灵波
short: "HALO"
title: "HALO: Human-Aligned Data Collection for WhoLe-body MObile Manipulation"
aliases: ["HALO"]
date: 2026-11-12
category: "数据采集"
source: "蚂蚁灵波与港科大合作"
partners: ["香港科技大学"]
authors: ["Shuai Yang", "Fangyi Xu", "Yishu Shen", "Kecheng Zheng", "Yinghao Xu"]
arxiv: "2611.16439"
pdf: "[[lingbot/papers/11_2611.16439_HALO.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "lingbot"]
---

# HALO: Human-Aligned Data Collection for WhoLe-body MObile Manipulation

> [!info] 论文信息
> arXiv [2611.16439](https://arxiv.org/abs/2611.16439) · v1 2026-11-12
> PDF：[[lingbot/papers/11_2611.16439_HALO.pdf|本地 PDF]]
> 方向：数据采集 · 角色：蚂蚁灵波与港科大合作
> 汇总：[[lingbot/蚂蚁灵波-论文汇总|蚂蚁灵波论文汇总]]

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

> Learning whole-body mobile manipulation requires demonstrations that coordinate bimanual actions with locomotion across extended workspaces. However, existing interfaces trade off direct robot control, perception and action alignment, and natural operator mobility, making such demonstrations difficult to collect. We introduce HALO, a human-aligned data collection system for whole-body mobile manipulation. The system aligns the operator's perception and action space with the robot while preserving direct physical feedback and natural locomotion. Operators guide the robot end-effectors through kinesthetic teaching and move a low-resistance platform without the deployed mobile base while performing bimanual manipulation. This interface enables more natural whole-body demonstrations, but the close human-robot coupling introduces discrepancies between the demonstration and deployment settings. We address these discrepancies with deployment-aligned demonstration processing, which calibrates and temporally aligns platform motion with the deployed base response and masks and inpaints demonstrator hands in recorded observations. Compared with Mobile ALOHA and VR teleoperation, HALO enables up to 2.9x faster demonstration collection while maintaining comparable or higher success rates. Policies trained with HALO perform precise manipulation tasks, including zip-tie fastening, and achieve a 73.3% success rate on a six-stage long-horizon mobile manipulation task involving repeated coordinated base and arm motion. Project page: this https URL
