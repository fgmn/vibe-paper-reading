---
id: "46"
org: 英伟达
short: "ENPIRE"
title: "ENPIRE: Agentic Robot Policy Self-Improvement in the Real World"
aliases: ["ENPIRE"]
date: 2026-06-18
category: "操作与其他"
source: "英伟达主导"
partners: []
authors: ["Wenli Xiao", "Jia Xie", "Tonghe Zhang", "Haotian Lin", "Letian \"Max\" Fu", "Haoru Xue", "Jalen Lu", "Yi Yang", "Cunxi Dai", "Zi Wang", "Jimmy Wu", "Guanzhi Wang", "S. Shankar Sastry", "Ken Goldberg", "Linxi \"Jim\" Fan", "Yuke Zhu", "Guanya Shi"]
arxiv: "2606.19980"
pdf: "[[topics/papers/递归自我改进RSI/2-17_2606.19980_ENPIRE.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# ENPIRE: Agentic Robot Policy Self-Improvement in the Real World

> [!info] 论文信息
> arXiv [2606.19980](https://arxiv.org/abs/2606.19980) · v1 2026-06-18 · 最新 v2（2026-09-20） · 发表：CoRL 2026
> PDF：[[topics/papers/递归自我改进RSI/2-17_2606.19980_ENPIRE.pdf|本地 PDF]]
> 系列：物理AI · 操作与其他 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：ENPIRE：智能体驱动的真实世界机器人策略自我改进，减少人工监督与算法工程。
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

> Achieving dexterous robotic manipulation in the real world heavily relies on human supervision and algorithm engineering, which becomes a central bottleneck in the pursuit of general physical intelligence. Although emerging coding agents can generate code to automate algorithm search, their successes remain largely confined in digital environments. We conjecture that the missing abstraction to automate robotics research is a repeatable feedback loop for real-world policy improvement: reset the scene, execute a policy, verify the outcome, and refine the next iteration. To bridge this gap, we introduce ENPIRE, a harness framework for coding agents that instantiates this physical feedback routine with four core modules: an Environment module (EN) for automatic reset and verification, a Policy Improvement module (PI) that launches policy refinement, a Rollout module (R) to evaluate policies with one or multiple physical robots operating in parallel, and an Evolution module (E) in which coding agents analyze logs, consult literature, improve training infrastructure and algorithm code to address failure modes. This closed-loop system transforms real-world manipulation learning into a controllable optimization procedure, minimizing human effort while allowing fair ablations across training recipe and agent variants. Powered by ENPIRE, frontier coding agents can autonomously train a policy to achieve a 99% success rate on challenging, dexterous manipulation tasks, such as organizing a pin box, fastening a zip tie, and tool use, a process that further accelerates when we dispatch an agent team on a robot fleet. Our results suggest a practical and scalable path toward deploying coding agents to autonomously advancing robotics in the physical world.
