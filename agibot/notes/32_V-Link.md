---
id: "32"
org: 智元
short: "V-Link"
title: "V-Link: Recovering Lost Visual Representations in Action DiT for Vision-Language-Action Models"
aliases: ["V-Link"]
date: 2026-08-26
category: "VLA/基础模型"
source: "智元主导"
product: ""
partners: []
authors: ["Yehao Lu", "Jiarui Yang", "Yuning Su", "Yufeng Xie", "Yu Zhong", "Yazhou Zhang", "Haiyu Lan", "Kaixiang Lu", "Peiwen Lin", "Chuang Wang", "Zequn Qin", "Enyu Li", "Xi Li"]
arxiv: "2608.25308"
pdf: "[[agibot/papers/32_2608.25308_V-Link.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# V-Link: Recovering Lost Visual Representations in Action DiT for Vision-Language-Action Models

> [!info] 论文信息
> arXiv [2608.25308](https://arxiv.org/abs/2608.25308) · v1 2026-08-26
> PDF：[[agibot/papers/32_2608.25308_V-Link.pdf|本地 PDF]]
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：V-Link：在 VLA 的动作 DiT 中恢复丢失的 3D 几何与 2D 语义视觉表征。
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

> Vision-language-action (VLA) models provide a scalable path toward generalist robotic manipulation by integrating visual perception, language understanding, and continuous action control. However, we reveal a critical limitation of VLA architectures: the action expert has limited access to the 3D geometric and 2D semantic information available in VLM features. This accessibility gap weakens perceptual grounding and limits performance on fine-grained robotic manipulation. To address this issue, we propose V-Link, which explicitly recovers visual representations during the vision-language (VL) to action (A) feature transfer. Specifically, V-Link learns complementary Spatial and Semantic Query representations within the VLM and injects them into Action DiT through asymmetric pathways. Semantic Queries complement the original VLM image tokens, whereas Spatial Queries provide dedicated geometric conditioning for spatially grounded action generation. Across LIBERO, LIBERO-Plus, and RoboTwin 2.0, our V-Link improves the average success rate over base model GR00T N1.6 by +1.9%, +31.2%, and +18.8%, respectively. On the AGIBOT A3 Ultra, V-Link further achieves gains of +20% and +24% on two real-world humanoid tasks.
