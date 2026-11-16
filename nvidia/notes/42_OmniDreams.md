---
id: "42"
org: 英伟达
short: "OmniDreams"
title: "NVIDIA OmniDreams: Real-Time Generative World Model for Closed-Loop Autonomous Vehicle Simulation"
aliases: ["OmniDreams"]
date: 2026-06-02
category: "Cosmos · Drive"
source: "英伟达主导"
partners: []
authors: ["Aarti Basant", "Amlan Kar", "Despoina Paschalidou", "Fangyin Wei", "Francesco Ferroni", "Guillermo Garcia Cobo", "Haithem Turki", "Huan Ling", "Jaewoo Seo", "James Lucas", "Jay Zhangjie Wu", "Jialiang Wang", "Jonathan Lorraine", "Jun Gao", "Kai He", "Katarina Tothova", "Kevin Xie", "Michal Tyszkiewicz", "Qi Wu", "Riccardo de Lutio", "Ruilong Li", "Sanja Fidler", "Seung Wook Kim", "Tianchang Shen", "Tianshi Cao", "Tobias Pfaff", "William Lew", "Xindi Wu", "Xuanchi Ren", "Yifan Lu", "Yuxuan Zhang", "Zan Gojcic", "Zian Wang"]
arxiv: "2606.03159"
pdf: "[[nvidia/papers/42_2606.03159_OmniDreams.pdf]]"
code: "https://github.com/nv-tlabs/omni-dreams"
project: "https://research.nvidia.com/labs/sil/projects/omnidreams-blog/"
huggingface: ["https://huggingface.co/nvidia/omni-dreams-models"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia", "cosmos"]
---

# NVIDIA OmniDreams: Real-Time Generative World Model for Closed-Loop Autonomous Vehicle Simulation

> [!info] 论文信息
> arXiv [2606.03159](https://arxiv.org/abs/2606.03159) · v1 2026-06-02 · 最新 v4（2026-11-12）
> PDF：[[nvidia/papers/42_2606.03159_OmniDreams.pdf|本地 PDF]]
> [代码](https://github.com/nv-tlabs/omni-dreams) · [项目页](https://research.nvidia.com/labs/sil/projects/omnidreams-blog/)
> 系列：Cosmos · Drive · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：由 Cosmos 扩散模型中/后训练得到的实时自回归动作条件驾驶世界模型，与 Alpamayo 策略组成闭环自动驾驶仿真。
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

> As autonomous vehicle capabilities advance, the safe evaluation of driving policies in long-tail scenarios remains a critical bottleneck. In closed-loop simulation, the driving policy model actively interacts with the environment, where its actions dynamically update the simulator state and directly influence the next set of generated sensor observations. While recent reconstruction-based neural simulators offer photorealism, they are fundamentally constrained by their initial captured data and struggle to generalize to highly dynamic or novel scenes. To overcome these limitations, we introduce OmniDreams, a foundation generative world model mid- and post-trained from the Cosmos diffusion model to autoregressively generate action-conditioned videos in real time. By leveraging the rich visual priors of Cosmos and mid- and post-training on 21k hours of driving scenarios, OmniDreams synthesizes complex, unobserved phenomena that are hard for traditional simulators to capture, such as extreme weather and unpredictable dynamic agent behaviors. Crucially, it autoregressively conditions its photorealistic sensor generation on past frames, the current simulator state, and immediate driving actions. Deployed in a closed-loop system with the Alpamayo 1 policy model and AlpaSim orchestrator, OmniDreams acts as a highly responsive, reactive environment, providing a scalable and comprehensive solution for training and evaluating next-generation autonomous driving policies. We additionally show preliminary results indicating that a world-action model (WAM) post-trained from OmniDreams achieves strong performance on the Physical AI Autonomous Vehicles NuRec dataset, surpassing the VLA-based Alpamayo 1.5 research policy model while using only 1/5 the total parameters. These results highlight the potential for a real-time world model like OmniDreams to also serve as a backbone for policy architectures.
