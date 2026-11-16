---
id: "45"
org: 英伟达
short: "CAIP"
title: "Contrastive Action-Image Pre-training for Visuomotor Control"
aliases: ["CAIP"]
date: 2026-06-15
category: "操作与其他"
source: "英伟达合作"
partners: []
authors: ["Yuvan Sharma", "Dantong Niu", "Anirudh Pai", "Zekai Wang", "Zhuoyang Liu", "Baifeng Shi", "Stefano Saravalle", "Boning Shao", "Ruijie Zheng", "Jing Wang", "Konstantinos Kallidromitis", "Yusuke Kato", "Fabio Galasso", "Yuke Zhu", "Danfei Xu", "Linxi \"Jim\" Fan", "Jitendra Malik", "Trevor Darrell", "Roei Herzig"]
arxiv: "2606.17256"
pdf: "[[nvidia/papers/45_2606.17256_CAIP.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# Contrastive Action-Image Pre-training for Visuomotor Control

> [!info] 论文信息
> arXiv [2606.17256](https://arxiv.org/abs/2606.17256) · v1 2026-06-15
> PDF：[[nvidia/papers/45_2606.17256_CAIP.pdf|本地 PDF]]
> 系列：物理AI · 操作与其他 · 角色：英伟达合作
> 清单里的一句话（Claude 根据摘要写，请核对）：CAIP：以大规模第一视角视频中的人手姿态作为末端动作代理，做动作-图像对比预训练的视觉编码器。
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

> Existing vision encoders for robotics face a fundamental bottleneck: robotic datasets lack the scale necessary for large-scale pre-training. Prior work circumvents this data scarcity by turning to internet-scale image and language data or egocentric human video. While these models show promise, neither paradigm learns from paired vision and action data, which downstream visuomotor control policies require. However, robot trajectories, the most direct source of this paired signal, are not available at pre-training scale, motivating us to extract action signals from abundant human video instead. To this end, we introduce CAIP (Contrastive Action-Image Pre-training), a vision encoder that treats human hand poses from large-scale egocentric video as a proxy for end-effector actions. By extracting 3D hand keypoints, a representation that aligns naturally with downstream robot action spaces, CAIP learns a unified action-image representation through a contrastive objective. Leveraging 32,041 hours of egocentric human video and only 88 hours of robotic manipulation data, CAIP outperforms state-of-the-art vision encoders including DINOv2, SigLIP, MVP, and R3M. Evaluated on a challenging real-world dexterous manipulation setup using Dexmate Vega and Sharpa Wave hands, CAIP yields performance gains of more than 30% on tasks involving folding, pouring, and fine-grained manipulation. Our results show that our method of contrastive action-centric pre-training yields a scalable path to achieving robust visual representations better suited for physical interaction.
