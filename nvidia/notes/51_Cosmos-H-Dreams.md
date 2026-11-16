---
id: "51"
org: 英伟达
short: "Cosmos-H-Dreams"
title: "NVIDIA Cosmos-H-Dreams: Real-Time Generative Physics Simulation for Surgical Robotics"
aliases: ["Cosmos-H-Dreams"]
date: 2026-08-25
category: "Cosmos · 其他"
source: "英伟达主导"
partners: []
authors: ["Javier Gamazo Tejero", "Lukas Zbinden", "Keyur Sheth", "Raghavendra K M", "Nadim Daher", "Diego Granero Maraña", "Filip Binkiewicz", "Patrick Thornycroft", "Mahdi Azizian", "Sean D. Huver"]
arxiv: "2608.24199"
pdf: "[[nvidia/papers/51_2608.24199_Cosmos-H-Dreams.pdf]]"
code: "https://github.com/isaac-for-healthcare/Cosmos-H-Dreams"
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia", "cosmos"]
---

# NVIDIA Cosmos-H-Dreams: Real-Time Generative Physics Simulation for Surgical Robotics

> [!info] 论文信息
> arXiv [2608.24199](https://arxiv.org/abs/2608.24199) · v1 2026-08-25 · 最新 v2（2026-08-27）
> PDF：[[nvidia/papers/51_2608.24199_Cosmos-H-Dreams.pdf|本地 PDF]]
> [代码](https://github.com/isaac-for-healthcare/Cosmos-H-Dreams)
> 系列：Cosmos · 其他 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：从 Cosmos-H-Surgical-Simulator 后训练并用 Self Forcing 蒸馏为因果少步模型，实现约 160 FPS 的可交互手术世界模拟器。
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

> Generative simulation for surgical robotics still lacks real-time interaction. Physical-robot experiments, often involving animal or cadaver labs, are time-consuming, costly, and difficult to reproduce, while classical simulators struggle to capture photorealistic appearance and deformable-tissue dynamics. We address this gap with Cosmos-H-Dreams, an integrated real-time surgical world-model system combining an action-conditioned generative model, a teacher-to-student distillation recipe, and a deployment stack built on the NVIDIA FlashDreams streaming-inference library. Starting from Cosmos-H-Surgical-Simulator, a multi-embodiment action-conditioned surgical video world model fine-tuned on the large-scale Open-H-Embodiment corpus, we post-train this checkpoint on embodiment- and procedure-specific data. By distilling the resulting bidirectional teacher into a causal, few-step student with Self Forcing, we turn a passive video generator into a controllable surgical simulator that streams at $\sim$160 inference FPS on a single NVIDIA RTX PRO 6000 Blackwell workstation GPU. Crucially, Cosmos-H-Dreams is controller-agnostic: any interface that emits a stream of robot kinematics can drive it. We demonstrate live control through a browser keyboard over WebRTC, a Meta Quest headset over WebXR, a commercial surgical robot console such as CMR Surgical's Versius, and learned policies operating in closed loop. To our knowledge, this is the first interactive surgical world model supporting live human and policy control. Human operators and policies alike can act inside the synthesized world and observe the consequences in real time. We release Cosmos-H-Dreams as an open surgical simulation system, providing a common foundation for surgical education, scalable synthetic data generation, and future intraoperative decision support.
