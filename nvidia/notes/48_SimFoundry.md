---
id: "48"
org: 英伟达
short: "SimFoundry"
title: "SimFoundry: Modular and Automated Scene Generation for Policy Learning and Evaluation"
aliases: ["SimFoundry"]
date: 2026-06-26
category: "仿真平台"
source: "英伟达主导"
partners: []
authors: ["Nadun Ranawaka", "Josiah Wong", "Wei-Lin Pai", "Wei-Teng Chu", "Tianyuan Dai", "Masoud Moghani", "Hang Yin", "Yunfan Jiang", "Wesley Durbano", "Brandon Huynh", "Yu Fang", "Danfei Xu", "Ruohan Zhang", "Li Fei-Fei", "Linxi Fan", "Bowen Wen", "Ajay Mandlekar", "Yuke Zhu"]
arxiv: "2606.28276"
pdf: "[[nvidia/papers/48_2606.28276_SimFoundry.pdf]]"
code: ""
project: "https://research.nvidia.com/labs/gear/simfoundry/"
huggingface: []
license: CC BY-SA 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# SimFoundry: Modular and Automated Scene Generation for Policy Learning and Evaluation

> [!info] 论文信息
> arXiv [2606.28276](https://arxiv.org/abs/2606.28276) · v1 2026-06-26 · 最新 v4（2026-08-05）
> PDF：[[nvidia/papers/48_2606.28276_SimFoundry.pdf|本地 PDF]]
> [项目页](https://research.nvidia.com/labs/gear/simfoundry/)
> 系列：物理AI · 仿真平台 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：SimFoundry：从单段真实视频自动重建可交互数字孪生并生成“数字表亲”，用于策略训练与评估。
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

> Training and evaluating robot policies in the real world is costly and difficult to scale. We introduce SimFoundry, a modular and automated system for zero-shot real-to-sim scene construction from a video. SimFoundry generates sim-ready digital twins and supports object, scene, and task editing, enabling the automated generation of diverse digital cousins: affordance-preserving variations of reconstructed real-world scenes. Policies trained on SimFoundry data transfer zero-shot to challenging real tasks involving multi-step manipulation, articulated object interaction, and bimanual interaction, and its digital cousins (variations of the original scene, objects, and tasks) facilitate generalization to new real-world conditions. Across 7 manipulation tasks and 5 policy architectures, SimFoundry simulation evaluations strongly predict real-world performance, with mean Pearson correlation 0.911 and mean maximum ranking violation 0.018. When evaluating sim-trained policies zero-shot in the real world, policies trained with object, scene, and task cousins in simulation show average task success rate improvements of 17%, 21%, and 40%, respectively. Additional details at this https URL .
