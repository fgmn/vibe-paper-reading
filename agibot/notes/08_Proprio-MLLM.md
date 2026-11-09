---
id: "08"
org: 智元
short: "Proprio-MLLM"
title: "Towards Proprioception-Aware Embodied Planning for Dual-Arm Humanoid Robots"
aliases: ["Proprio-MLLM"]
date: 2025-10-09
category: "其他"
source: "智元合作"
product: "灵犀 X1"
partners: []
authors: ["Boyu Li", "Siyuan He", "Hang Xu", "Haoqi Yuan", "Xinrun Xu", "Yu Zang", "Liwei Hu", "Junpeng Yue", "Zhenxiong Jiang", "Pengbo Hu", "Börje F. Karlsson", "Yehui Tang", "Zongqing Lu"]
arxiv: "2510.07882"
pdf: "[[agibot/papers/08_2510.07882_Proprio-MLLM.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot", "lingxi"]
---

# Towards Proprioception-Aware Embodied Planning for Dual-Arm Humanoid Robots

> [!info] 论文信息
> arXiv [2510.07882](https://arxiv.org/abs/2510.07882) · v1 2025-10-09 · 最新 v2（2025-10-15）
> PDF：[[agibot/papers/08_2510.07882_Proprio-MLLM.pdf|本地 PDF]]
> 角色：智元合作 · 机型：灵犀 X1
> 清单里的一句话（Claude 根据摘要写，请核对）：面向双臂人形的本体感知具身规划：仿真平台与具身感知 MLLM 规划器。
> 灵犀依据：To support a broad range of interaction scenarios, DualTHOR integrates two distinct humanoid robots: the powerful and stable Unitree H1, and the dexterous and precise Agibot X1.（https://arxiv.org/html/2510.07882 (Sec. III DualTHOR; affiliations include AgiBot)）
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

> In recent years, Multimodal Large Language Models (MLLMs) have demonstrated the ability to serve as high-level planners, enabling robots to follow complex human instructions. However, their effectiveness, especially in long-horizon tasks involving dual-arm humanoid robots, remains limited. This limitation arises from two main challenges: (i) the absence of simulation platforms that systematically support task evaluation and data collection for humanoid robots, and (ii) the insufficient embodiment awareness of current MLLMs, which hinders reasoning about dual-arm selection logic and body positions during planning. To address these issues, we present DualTHOR, a new dual-arm humanoid simulator, with continuous transition and a contingency mechanism. Building on this platform, we propose Proprio-MLLM, a model that enhances embodiment awareness by incorporating proprioceptive information with motion-based position embedding and a cross-spatial encoder. Experiments show that, while existing MLLMs struggle in this environment, Proprio-MLLM achieves an average improvement of 19.75% in planning performance. Our work provides both an essential simulation platform and an effective model to advance embodied intelligence in humanoid robotics. The code is available at this https URL.
