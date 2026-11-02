---
id: "05"
org: 自变量
short: "X-Tokenizer"
title: "X-Tokenizer: A Multimodal Action Tokenizer for Vision-Language-Action Pretraining"
aliases: ["X-Tokenizer"]
date: 2026-06-07
category: 动作表征
source: 自变量主导
partners: ["香港城市大学", "清华大学"]
authors: ["Miracle Kang", "Lights Shi", "Lucy Liang", "Roy Gan", "Dongxiu Liu", "Pushi Zhang", "Sylas Chen", "Shawn Qin", "Yinan Zheng", "Jinliang Zheng", "Hao Wang", "Xianyuan Zhan", "Hang Su"]
arxiv: "2606.14752"
pdf: "[[xsquare/papers/05_2606.14752_X-Tokenizer.pdf]]"
code: "https://github.com/X-Square-Robot/X-Tokenizer"
project: "https://x-square-robot.github.io/X-Tokenizer_projectPage/"
huggingface: ["https://huggingface.co/x-square-robot/X-Tokenizer"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "action-tokenizer", "vla", "pretraining"]
---

# X-Tokenizer: A Multimodal Action Tokenizer for Vision-Language-Action Pretraining

> [!info] 论文信息
> arXiv [2606.14752](https://arxiv.org/abs/2606.14752) · v1 2026-06-07 · 最新 v2（2026-06-28）
> PDF：[[xsquare/papers/05_2606.14752_X-Tokenizer.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/X-Tokenizer) · [项目页](https://x-square-robot.github.io/X-Tokenizer_projectPage/) · [X-Tokenizer](https://huggingface.co/x-square-robot/X-Tokenizer)
> 合作单位：香港城市大学、清华大学

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

> Modern Vision-Language-Action (VLA) models must bridge pretrained vision-language reasoning and precise continuous robot control. Existing action tokenizers discretize actions primarily for reconstruction, producing codes that preserve motion geometry but provide only weak semantic supervision to the backbone. We therefore formulate action tokenization not as mere compression, but as semantic interface learning between multimodal reasoning and executable control. To this end, we introduce X-Tokenizer, a lightweight encoder-Semantic Residual Quantization (SRQ)-decoder architecture that provides a shared action interface across diverse robotic arm embodiments. Its key component, SRQ, imposes an asymmetric structure on residual vector quantization: the first level is trained with Masked Action Modeling (MAM) to form a discrete action language that captures coarse motion intent, while deeper levels remain reconstruction-oriented residuals that preserve fine-grained details. To further align action tokens with multimodal semantics, X-Tokenizer is pretrained with contrastive alignment to the representation space of a pretrained foundation model and with next-frame vision-language feature prediction. Pretrained on 2.4M trajectories (2.0B action frames), a single frozen X-Tokenizer plugs into a mixed discrete-continuous VLA as a representation-shaping supervision signal. X-Tokenizer achieves top real-world aggregate and strong RoboTwin 2.0 simulation results. Outperforming FAST in multimodal grounding (+13.5%) and long-horizon tasks (+8.25), it shows that action tokenizers serve as semantic interfaces for VLA pretraining beyond mere action compression.
