---
id: "23"
org: 英伟达
short: "Cosmos-Surg-dVRK"
title: "Cosmos-Surg-dVRK: World Foundation Model-based Automated Online Evaluation of Surgical Robot Policy Learning"
aliases: ["Cosmos-Surg-dVRK"]
date: 2025-10-17
category: "Cosmos · 其他"
source: "英伟达主导"
partners: []
authors: ["Lukas Zbinden", "Nigel Nelson", "Juo-Tung Chen", "Xinhao Chen", "Ji Woong Kim", "Mahdi Azizian", "Axel Krieger", "Sean Huver"]
arxiv: "2510.16240"
pdf: "[[nvidia/papers/23_2510.16240_Cosmos-Surg-dVRK.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia", "cosmos"]
---

# Cosmos-Surg-dVRK: World Foundation Model-based Automated Online Evaluation of Surgical Robot Policy Learning

> [!info] 论文信息
> arXiv [2510.16240](https://arxiv.org/abs/2510.16240) · v1 2025-10-17 · 最新 v2（2025-11-03）
> PDF：[[nvidia/papers/23_2510.16240_Cosmos-Surg-dVRK.pdf|本地 PDF]]
> 系列：Cosmos · 其他 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：对 Cosmos WFM 做手术场景微调并配合视频分类器，在 dVRK 上实现手术机器人策略的全自动在线评测。
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

> The rise of surgical robots and vision-language-action models has accelerated the development of autonomous surgical policies and efficient assessment strategies. However, evaluating these policies directly on physical robotic platforms such as the da Vinci Research Kit (dVRK) remains hindered by high costs, time demands, reproducibility challenges, and variability in execution. World foundation models (WFM) for physical AI offer a transformative approach to simulate complex real-world surgical tasks, such as soft tissue deformation, with high fidelity. This work introduces Cosmos-Surg-dVRK, a surgical finetune of the Cosmos WFM, which, together with a trained video classifier, enables fully automated online evaluation and benchmarking of surgical policies. We evaluate Cosmos-Surg-dVRK using two distinct surgical datasets. On tabletop suture pad tasks, the automated pipeline achieves strong correlation between online rollouts in Cosmos-Surg-dVRK and policy outcomes on the real dVRK Si platform, as well as good agreement between human labelers and the V-JEPA 2-derived video classifier. Additionally, preliminary experiments with ex-vivo porcine cholecystectomy tasks in Cosmos-Surg-dVRK demonstrate promising alignment with real-world evaluations, highlighting the platform's potential for more complex surgical procedures.
