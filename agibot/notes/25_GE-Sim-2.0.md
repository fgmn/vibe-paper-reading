---
id: "25"
org: 智元
short: "GE-Sim 2.0"
title: "GE-Sim 2.0: A Roadmap Towards Comprehensive Closed-loop Video World Simulators for Robotic Manipulation"
aliases: ["GE-Sim 2.0"]
date: 2026-05-26
category: "世界模型"
source: "智元主导"
product: ""
partners: []
authors: ["Boxiang Qiu", "Liliang Chen", "Yue Liao", "Nan Wang", "Lintao Wang", "Jiayi Luo", "Wenzhi Zhao", "Shengcong Chen", "Di Chen", "Ye Li", "Chen Gao", "Shuicheng Yan", "Si Liu", "Maoqing Yao", "Guanghui Ren"]
arxiv: "2605.27491"
pdf: "[[agibot/papers/25_2605.27491_GE-Sim-2.0.pdf]]"
code: "https://github.com/AgibotTech/GE-Sim-V2"
project: "https://ge-sim-v2.github.io/"
huggingface: ["https://huggingface.co/agibot-world/Genie-Envisioner-Sim-v2.0"]
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# GE-Sim 2.0: A Roadmap Towards Comprehensive Closed-loop Video World Simulators for Robotic Manipulation

> [!info] 论文信息
> arXiv [2605.27491](https://arxiv.org/abs/2605.27491) · v1 2026-05-26
> PDF：[[agibot/papers/25_2605.27491_GE-Sim-2.0.pdf|本地 PDF]]
> [代码](https://github.com/AgibotTech/GE-Sim-V2) · [项目页](https://ge-sim-v2.github.io/)
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：GE-Sim 2.0：基于 Genie Envisioner 的闭环视频世界模拟器，支持策略评测与学习。
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

> We introduce GE-Sim 2.0 (Genie Envisioner World Simulator 2.0), a closed-loop video world simulator for robotic manipulation. Building on the action-conditioned video generation framework of Genie Envisioner, GE-Sim 2.0 is re-trained on thousands of hours of real-world robot data spanning teleoperation, contact-rich interaction, and on-robot policy deployment, substantially improving action-following fidelity and trajectory coverage. On top of this foundation, three new modules close the loop from video simulation to policy learning: a state expert that decodes proprioceptive state from video latents to support next-chunk prediction by downstream VLA policies; a world judge that scores generated rollouts against task instructions, yielding machine-verifiable success signals and rewards in place of manual inspection; and an acceleration framework that delivers a 25-frame rollout in 2.3 seconds on a single H100, with up to 4* frame skipping at inference for long-horizon evaluation. GE-Sim 2.0 tops the public WorldArena leaderboard at only 2B parameters, outperforming both dedicated robotic world models and closed-source general video generators, and policies trained against its rollouts and rewards translate into measurable real-world gains, establishing GE-Sim 2.0 as a practical platform for scalable evaluation and closed-loop learning of manipulation policies.
