---
id: "03"
org: 英伟达
short: "MimicGen"
title: "MimicGen: A Data Generation System for Scalable Robot Learning using Human Demonstrations"
aliases: ["MimicGen"]
date: 2023-10-26
category: "合成数据与世界模型"
source: "英伟达主导"
partners: []
authors: ["Ajay Mandlekar", "Soroush Nasiriany", "Bowen Wen", "Iretiayo Akinola", "Yashraj Narang", "Linxi Fan", "Yuke Zhu", "Dieter Fox"]
arxiv: "2310.17596"
pdf: "[[nvidia/papers/03_2310.17596_MimicGen.pdf]]"
code: ""
project: "https://mimicgen.github.io/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# MimicGen: A Data Generation System for Scalable Robot Learning using Human Demonstrations

> [!info] 论文信息
> arXiv [2310.17596](https://arxiv.org/abs/2310.17596) · v1 2023-10-26 · 发表：CoRL 2023
> PDF：[[nvidia/papers/03_2310.17596_MimicGen.pdf|本地 PDF]]
> [项目页](https://mimicgen.github.io/)
> 系列：物理AI · 合成数据与世界模型 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：MimicGen：将少量人类演示适配到新场景，自动合成大规模机器人模仿学习数据。
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

> Imitation learning from a large set of human demonstrations has proved to be an effective paradigm for building capable robot agents. However, the demonstrations can be extremely costly and time-consuming to collect. We introduce MimicGen, a system for automatically synthesizing large-scale, rich datasets from only a small number of human demonstrations by adapting them to new contexts. We use MimicGen to generate over 50K demonstrations across 18 tasks with diverse scene configurations, object instances, and robot arms from just ~200 human demonstrations. We show that robot agents can be effectively trained on this generated dataset by imitation learning to achieve strong performance in long-horizon and high-precision tasks, such as multi-part assembly and coffee preparation, across broad initial state distributions. We further demonstrate that the effectiveness and utility of MimicGen data compare favorably to collecting additional human demonstrations, making it a powerful and economical approach towards scaling up robot learning. Datasets, simulation environments, videos, and more at this https URL .
