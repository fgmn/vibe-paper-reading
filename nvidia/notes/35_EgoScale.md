---
id: "35"
org: 英伟达
short: "EgoScale"
title: "EgoScale: Scaling Dexterous Manipulation with Diverse Egocentric Human Data"
aliases: ["EgoScale"]
date: 2026-02-18
category: "合成数据与世界模型"
source: "英伟达主导"
partners: []
authors: ["Ruijie Zheng", "Dantong Niu", "Yuqi Xie", "Jing Wang", "Mengda Xu", "Yunfan Jiang", "Fernando Castañeda", "Fengyuan Hu", "You Liang Tan", "Letian Fu", "Trevor Darrell", "Furong Huang", "Yuke Zhu", "Danfei Xu", "Linxi Fan"]
arxiv: "2602.16710"
pdf: "[[nvidia/papers/35_2602.16710_EgoScale.pdf]]"
code: ""
project: "https://research.nvidia.com/labs/gear/egoscale/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# EgoScale: Scaling Dexterous Manipulation with Diverse Egocentric Human Data

> [!info] 论文信息
> arXiv [2602.16710](https://arxiv.org/abs/2602.16710) · v1 2026-02-18
> PDF：[[nvidia/papers/35_2602.16710_EgoScale.pdf|本地 PDF]]
> [项目页](https://research.nvidia.com/labs/gear/egoscale/)
> 系列：物理AI · 合成数据与世界模型 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：EgoScale：利用两万小时级第一视角人类视频预训练，将操作先验迁移到灵巧手机器人，并揭示人类数据规模律。
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

> Human behavior is among the most scalable sources of data for learning physical intelligence, yet how to effectively leverage it for dexterous manipulation remains unclear. While prior work demonstrates human to robot transfer in constrained settings, it is unclear whether large scale human data can support fine grained, high degree of freedom dexterous manipulation. We present EgoScale, a human to dexterous manipulation transfer framework built on large scale egocentric human data. We train a Vision Language Action (VLA) model on over 20,854 hours of action labeled egocentric human video, more than 20 times larger than prior efforts, and uncover a log linear scaling law between human data scale and validation loss. This validation loss strongly correlates with downstream real robot performance, establishing large scale human data as a predictable supervision source. Beyond scale, we introduce a simple two stage transfer recipe: large scale human pretraining followed by lightweight aligned human robot mid training. This enables strong long horizon dexterous manipulation and one shot task adaptation with minimal robot supervision. Our final policy improves average success rate by 54% over a no pretraining baseline using a 22 DoF dexterous robotic hand, and transfers effectively to robots with lower DoF hands, indicating that large scale human motion provides a reusable, embodiment agnostic motor prior.
