---
id: "18"
org: 智元
short: "RoboClaw"
title: "RoboClaw: An Agentic Framework for Scalable Long-Horizon Robotic Tasks"
aliases: ["RoboClaw"]
date: 2026-03-12
category: "VLA/基础模型"
source: "智元主导"
product: ""
partners: []
authors: ["Ruiying Li", "Yunlang Zhou", "YuYao Zhu", "Kylin Chen", "Jingyuan Wang", "Sukai Wang", "Kongtao Hu", "Minhui Yu", "Bowen Jiang", "Zhan Su", "Jiayao Ma", "Xin He", "Yongjian Shen", "Yang Yang", "Guanghui Ren", "Maoqing Yao", "Wenhao Wang", "Yao Mu"]
arxiv: "2603.11558"
pdf: "[[agibot/papers/18_2603.11558_RoboClaw.pdf]]"
code: "https://github.com/RoboClaw-Robotics/RoboClaw"
project: "https://roboclaw-agibot.github.io/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# RoboClaw: An Agentic Framework for Scalable Long-Horizon Robotic Tasks

> [!info] 论文信息
> arXiv [2603.11558](https://arxiv.org/abs/2603.11558) · v1 2026-03-12 · 最新 v3（2026-04-01） · 发表：ECCV 2026（据 agibot.com/research）
> PDF：[[agibot/papers/18_2603.11558_RoboClaw.pdf|本地 PDF]]
> [代码](https://github.com/RoboClaw-Robotics/RoboClaw) · [项目页](https://roboclaw-agibot.github.io/)
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：RoboClaw：由单一 VLM 控制器统一数据采集、策略学习与执行的长时程机器人智能体框架。
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

> Vision-Language-Action (VLA) systems have shown strong potential for language-driven robotic manipulation. However, scaling them to long-horizon tasks remains challenging. Existing pipelines typically separate data collection, policy learning, and deployment, resulting in heavy reliance on manual environment resets and brittle multi-policy execution. We present RoboClaw, an agentic robotics framework that unifies data collection, policy learning, and task execution under a single VLM-driven controller. At the policy level, RoboClaw introduces Entangled Action Pairs (EAP), which couple forward manipulation behaviors with inverse recovery actions to form self-resetting loops for autonomous data collection. This mechanism enables continuous on-policy data acquisition and iterative policy refinement with minimal human intervention. During deployment, the same agent performs high-level reasoning and dynamically orchestrates learned policy primitives to accomplish long-horizon tasks. By maintaining consistent contextual semantics across collection and execution, RoboClaw reduces mismatch between the two phases and improves multi-policy robustness. Experiments in real-world manipulation tasks demonstrate improved stability and scalability compared to conventional open-loop pipelines, while significantly reducing human effort throughout the robot lifecycle, achieving a 25% improvement in success rate over baseline methods on long-horizon tasks and reducing human time investment by 53.7%.
