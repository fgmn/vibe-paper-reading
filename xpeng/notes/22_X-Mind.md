---
id: "22"
org: 小鹏
short: "X-Mind"
title: "X-Mind: Efficient Visual Chain-of-Thought via Predictive World Model for End-to-End Driving"
aliases: ["X-Mind"]
date: 2026-06-27
category: "世界模型"
source: "小鹏主导"
product: ""
partners: []
authors: ["Bohao Zhao", "Chengrui Wei", "Guangfeng Jiang", "Ruixin Liu", "Xuejie Lv", "Liu Liang", "Sutao Deng", "Xiuyang Fan", "Pengkun Zheng", "Jinyun Zhou", "Rui Guo", "Hanpeng Liu", "Yutong Zheng", "Yi Guo", "Xinlong Zheng", "Qingyu Luo", "Zhuangzhuang Ding", "Yu Zhang", "Hang Zhang", "Xianming Liu"]
arxiv: "2606.28758"
pdf: "[[xpeng/papers/22_2606.28758_X-Mind.pdf]]"
code: ""
project: "https://x-mind.github.io"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng"]
---

# X-Mind: Efficient Visual Chain-of-Thought via Predictive World Model for End-to-End Driving

> [!info] 论文信息
> arXiv [2606.28758](https://arxiv.org/abs/2606.28758) · v1 2026-06-27
> PDF：[[xpeng/papers/22_2606.28758_X-Mind.pdf|本地 PDF]]
> [项目页](https://x-mind.github.io)
> 方向：世界模型 · 角色：小鹏主导
> 清单里的一句话（Claude 根据摘要写，请核对）：X-Mind：以预测世界模型实现高效视觉思维链，用于端到端驾驶。
> 汇总：[[xpeng/小鹏-论文与报告汇总|小鹏论文与报告汇总]]

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

> Predicting future states is essential for autonomous agents, yet current Vision-Language-Action (VLA) models fundamentally lack this capability, relying instead on reactive perception-action mapping. While integrating Predictive World Models (PWMs) addresses this gap, existing approaches either incur prohibitive cascaded latency or act as shallow terminal tasks that fail to deeply embed forward-looking reasoning. To endow VLA models with this reasoning capability, we propose X-Mind. Rather than treating PWMs as an external auxiliary module, this framework internalizes them as the Visual Chain-of-Thought (Visual CoT). By enforcing a world rollout prior to action, the model is constrained to imagine future evolution first, yielding a driving policy that is robustly grounded in environmental dynamics and aware of the future consequences its actions will unfold. The challenge here is efficiency, and we tackle it on two fronts. First, we introduce a compact representation of visual thinking: an abstract sketch that fuses a Bird's-Eye-View (BEV) layout with abstract driving priors (e.g., navigation intents and traffic rules). Rather than rolling out dense future frames, the model reasons over this sketch as a mental canvas; aided by a Deep Compression Autoencoder (DC-AE), a 12-frame future rollout is reduced to merely 96 tokens, alleviating the long-context computational bottleneck. Second, to accelerate generation further, we propose a recurrent block diffusion scheme that unrolls the denoising steps across the layers of the large drive model, folding iterative refinement into the backbone's one forward pass. Trained and validated on large-scale real-world data, X-Mind achieves competitive end-to-end driving performance, which makes it a highly practical, low-latency solution that successfully deploys large-scale cognitive reasoning directly onto resource-constrained vehicle platforms.
