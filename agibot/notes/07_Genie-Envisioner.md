---
id: "07"
org: 智元
short: "Genie Envisioner"
title: "Genie Envisioner: A Unified World Foundation Platform for Robotic Manipulation"
aliases: ["Genie Envisioner"]
date: 2025-08-07
category: "世界模型"
source: "智元主导"
product: "精灵 G1"
partners: []
authors: ["Yue Liao", "Pengfei Zhou", "Siyuan Huang", "Donglin Yang", "Shengcong Chen", "Yuxin Jiang", "Yue Hu", "Jingbin Cai", "Si Liu", "Jianlan Luo", "Liliang Chen", "Shuicheng Yan", "Maoqing Yao", "Guanghui Ren"]
arxiv: "2508.05635"
pdf: "[[agibot/papers/07_2508.05635_Genie-Envisioner.pdf]]"
code: "https://github.com/AgibotTech/Genie-Envisioner-V1"
project: "https://genie-envisioner.github.io/"
huggingface: ["https://huggingface.co/agibot-world/Genie-Envisioner-v1.0"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# Genie Envisioner: A Unified World Foundation Platform for Robotic Manipulation

> [!info] 论文信息
> arXiv [2508.05635](https://arxiv.org/abs/2508.05635) · v1 2025-08-07 · 最新 v3（2025-11-04） · 发表：ICLR 2026（据 agibot.com/research）
> PDF：[[agibot/papers/07_2508.05635_Genie-Envisioner.pdf|本地 PDF]]
> [代码](https://github.com/AgibotTech/Genie-Envisioner-V1) · [项目页](https://genie-envisioner.github.io/)
> 角色：智元主导 · 机型：精灵 G1
> 清单里的一句话（Claude 根据摘要写，请核对）：Genie Envisioner：以视频生成为核心，统一策略学习（GE-Act）、评测与仿真（GE-Sim）的世界基础平台。
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

> We introduce Genie Envisioner (GE), a unified world foundation platform for robotic manipulation that integrates policy learning, evaluation, and simulation within a single video-generative framework. At its core, GE-Base is a large-scale, instruction-conditioned video diffusion model that captures the spatial, temporal, and semantic dynamics of real-world robotic interactions in a structured latent space. Built upon this foundation, GE-Act maps latent representations to executable action trajectories through a lightweight, flow-matching decoder, enabling precise and generalizable policy inference across diverse embodiments with minimal supervision. To support scalable evaluation and training, GE-Sim serves as an action-conditioned neural simulator, producing high-fidelity rollouts for closed-loop policy development. The platform is further equipped with EWMBench, a standardized benchmark suite measuring visual fidelity, physical consistency, and instruction-action alignment. Together, these components establish Genie Envisioner as a scalable and practical foundation for instruction-driven, general-purpose embodied intelligence. All code, models, and benchmarks will be released publicly.
