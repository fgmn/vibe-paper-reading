---
id: "49"
org: 英伟达
short: "ASPIRE"
title: "ASPIRE: Agentic /Skills Discovery for Robotics"
aliases: ["ASPIRE"]
date: 2026-06-30
category: "操作与其他"
source: "英伟达主导"
partners: []
authors: ["Runyu Lu", "Yubo Wu", "Ethan Kou", "Haotian Lin", "Letian Fu", "Wenli Xiao", "Ajay Mandlekar", "Yinzhen Xu", "Guanya Shi", "Ken Goldberg", "Ang Chen", "Mosharaf Chowdhury", "Jan Kautz", "Yuke Zhu", "Linxi \"Jim\" Fan", "Guanzhi Wang"]
arxiv: "2607.00272"
pdf: "[[nvidia/papers/49_2607.00272_ASPIRE.pdf]]"
code: ""
project: "https://research.nvidia.com/labs/gear/aspire/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# ASPIRE: Agentic /Skills Discovery for Robotics

> [!info] 论文信息
> arXiv [2607.00272](https://arxiv.org/abs/2607.00272) · v1 2026-06-30 · 最新 v2（2026-10-20）
> PDF：[[nvidia/papers/49_2607.00272_ASPIRE.pdf|本地 PDF]]
> [项目页](https://research.nvidia.com/labs/gear/aspire/)
> 系列：物理AI · 操作与其他 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：ASPIRE：编码智能体持续编写与修复 code-as-policy 程序并沉淀可复用技能库的机器人持续学习系统。
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

> Traditional robot programming is notoriously challenging: it requires orchestrating multimodal perception, managing physical contact dynamics, and handling diverse environment configurations and execution failures. We introduce ASPIRE (Agentic Skill Programming through Iterative Robot Exploration), a continual learning system that autonomously writes and refines robot control programs in a code-as-policy paradigm while compounding experience into a reusable skill library. ASPIRE operates in an open-ended learning loop, consisting of three components: (1) a closed-loop robot execution engine that exposes fine-grained multimodal traces, enabling the agent to autonomously diagnose failures, synthesize repairs, and validate outcomes; (2) a continually expanding skill library that distills validated fixes into reusable, transferable robotic knowledge; and (3) an evolutionary search procedure that generates diverse programs, systematically debugging them to explore beyond single-trajectory refinement. ASPIRE surpasses prior methods by up to 77% on manipulation tasks under perturbation, 72% on Robosuite's bimanual handover task, and up to 32% on long-horizon household tasks. The accumulated skill library further enables zero-shot generalization: on representative unseen long-horizon tasks, ASPIRE achieves 31% success, outperforming the 4% success rate of prior methods. Performance scales with the capabilities of frontier models. With Claude Opus 5.5, ASPIRE nearly saturates these benchmarks, achieving 99% average success across all 80 LIBERO-Pro tasks and 100% success on representative Robosuite and BEHAVIOR-1K tasks. Beyond simulation, skills discovered in simulation reduce real-world robot programming effort across embodiments and robot APIs, while skills acquired through online interaction with physical robots enable ASPIRE to solve a Rubik's Cube with progressively improving efficiency.
