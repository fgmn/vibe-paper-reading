---
id: "29"
org: 智元
short: "τ0-VLA"
title: "$τ_0$-VLA: a Hierarchical Robot Foundation Model with World-Model-Guided Test-Time Computation"
aliases: ["τ0-VLA"]
date: 2026-08-17
category: "VLA/基础模型"
source: "智元主导"
product: ""
partners: []
authors: ["Xiaowei Cai", "Yunuo Cai", "Bingao Chen", "Jingxiao Chen", "Zhi Chen", "Siyuan Feng", "Tengyu Hou", "Jingshun Huang", "Han Jiang", "Runkun Ju", "Dong Li", "Mingxiang Li", "Shaowei Li", "Xinchen Li", "Yifan Li", "Yi Liu", "Zhongyuan Liu", "Jianlan Luo", "Junwen Miao", "Ruiqi Ni", "Buqing Nie", "Mingjie Pan", "Xinlin Ren", "Jianheng Song", "Jiaxu Wang", "Peiqi Wang", "Sen Wang", "Xiaoyan Wang", "Dafeng Wei", "Dongming Wu", "Pengwei Xie", "Pu Yang", "Hangjian Ye", "Xiangyu Yue", "Jinyu Zhang", "Qinglin Zhang", "Xueyong Zhao", "Pengfei Zhou", "Yue Zhou"]
arxiv: "2608.16885"
pdf: "[[agibot/papers/29_2608.16885_tau0-VLA.pdf]]"
code: ""
project: "https://tau0-vla.github.io/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# $τ_0$-VLA: a Hierarchical Robot Foundation Model with World-Model-Guided Test-Time Computation

> [!info] 论文信息
> arXiv [2608.16885](https://arxiv.org/abs/2608.16885) · v1 2026-08-17
> PDF：[[agibot/papers/29_2608.16885_tau0-VLA.pdf|本地 PDF]]
> [项目页](https://tau0-vla.github.io/)
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：τ0-VLA：以世界模型引导测试时计算的分层机器人基础模型，用于长时程操作。
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

> Long-horizon robot manipulation requires a robot to both execute individual skills reliably and sequence them coherently over extended tasks. Most hierarchical vision-language-action (VLA) models make each such decision with a single forward pass, leaving no mechanism to allocate additional computation to difficult or consequential choices. We introduce $\tau_0$-VLA, a hierarchical robot foundation model that formulates high-level subtask generation as a compute-scalable inference problem through world-model-guided test-time computation. At each inference step, the high-level policy uses execution memory to generate a subtask and, when needed, searches over alternatives before committing to its output. A low-level policy then executes the generated subtask across multiple robot embodiments. The policy is trained on 40,115 hours of heterogeneous real-world data with multimodal co-training. Across in-domain and distribution-shifted settings, allocating additional test-time computation substantially improves next-subtask prediction accuracy, and these gains translate into higher closed-loop success on long-horizon robot manipulation tasks.
