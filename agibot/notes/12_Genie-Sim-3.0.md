---
id: "12"
org: 智元
short: "Genie Sim 3.0"
title: "Genie Sim 3.0 : A High-Fidelity Comprehensive Simulation Platform for Humanoid Robot"
aliases: ["Genie Sim 3.0"]
date: 2026-01-05
category: "仿真"
source: "智元主导"
product: ""
partners: []
authors: ["Chenghao Yin", "Da Huang", "Di Yang", "Jichao Wang", "Nanshu Zhao", "Chen Xu", "Wenjun Sun", "Linjie Hou", "Zhijun Li", "Junhui Wu", "Zhaobo Liu", "Zhen Xiao", "Sheng Zhang", "Lei Bao", "Rui Feng", "Zhenquan Pang", "Jiayu Li", "Qian Wang", "Maoqing Yao"]
arxiv: "2601.02078"
pdf: "[[agibot/papers/12_2601.02078_Genie-Sim-3.0.pdf]]"
code: "https://github.com/AgibotTech/genie_sim"
project: ""
huggingface: ["https://huggingface.co/datasets/agibot-world/GenieSim3.0-Dataset", "https://huggingface.co/datasets/agibot-world/GenieSimAssets"]
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# Genie Sim 3.0 : A High-Fidelity Comprehensive Simulation Platform for Humanoid Robot

> [!info] 论文信息
> arXiv [2601.02078](https://arxiv.org/abs/2601.02078) · v1 2026-01-05 · 最新 v4（2026-08-14）
> PDF：[[agibot/papers/12_2601.02078_Genie-Sim-3.0.pdf|本地 PDF]]
> [代码](https://github.com/AgibotTech/genie_sim)
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：Genie Sim 3.0：LLM 驱动场景生成、自动化评测与万小时合成数据的人形机器人仿真平台。
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

> The development of robust and generalizable robot learning models is critically contingent upon the availability of large-scale, diverse training data and reliable evaluation benchmarks. Collecting data in the physical world poses prohibitive costs and scalability challenges, and prevailing simulation benchmarks frequently suffer from fragmentation, narrow scope, or insufficient fidelity to enable effective sim-to-real transfer. To address these challenges, we introduce Genie Sim 3.0, a unified simulation platform for robotic manipulation. We present Genie Sim Generator, a large language model (LLM)-powered tool that constructs high-fidelity scenes from natural language instructions. Its principal strength resides in rapid and multi-dimensional generalization, facilitating the synthesis of diverse environments to support scalable data collection and robust policy evaluation. We introduce the first benchmark that pioneers the application of LLM for automated evaluation. It leverages LLM to mass-generate evaluation scenarios and employs Vision-Language Model (VLM) to establish an automated assessment pipeline. We also release an open-source dataset comprising more than 10,000 hours of synthetic data across over 200 tasks. Through systematic experimentation, we validate the robust zero-shot sim-to-real transfer capability of our open-source dataset, demonstrating that synthetic data can server as an effective substitute for real-world data under controlled conditions for scalable policy training. For code and dataset details, please refer to: this https URL.
