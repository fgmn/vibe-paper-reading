---
id: "32"
org: 英伟达
short: "Cosmos Policy"
title: "Cosmos Policy: Fine-Tuning Video Models for Visuomotor Control and Planning"
aliases: ["Cosmos Policy"]
date: 2026-01-22
category: "Cosmos · Policy"
source: "英伟达主导"
partners: []
authors: ["Moo Jin Kim", "Yihuai Gao", "Tsung-Yi Lin", "Yen-Chen Lin", "Yunhao Ge", "Grace Lam", "Percy Liang", "Shuran Song", "Ming-Yu Liu", "Chelsea Finn", "Jinwei Gu"]
arxiv: "2601.16163"
pdf: "[[nvidia/papers/32_2601.16163_Cosmos-Policy.pdf]]"
code: "https://github.com/NVlabs/cosmos-policy"
project: "https://research.nvidia.com/labs/dir/cosmos-policy/"
huggingface: ["https://huggingface.co/collections/nvidia/cosmos-policy"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia", "cosmos"]
---

# Cosmos Policy: Fine-Tuning Video Models for Visuomotor Control and Planning

> [!info] 论文信息
> arXiv [2601.16163](https://arxiv.org/abs/2601.16163) · v1 2026-01-22 · 发表：ICLR 2026 (per NVIDIA Cosmos Lab publications list)
> PDF：[[nvidia/papers/32_2601.16163_Cosmos-Policy.pdf|本地 PDF]]
> [代码](https://github.com/NVlabs/cosmos-policy) · [项目页](https://research.nvidia.com/labs/dir/cosmos-policy/)
> 系列：Cosmos · Policy · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：将 Cosmos-Predict2 单阶段后训练为机器人策略，把动作、未来状态与价值编码为潜在帧，实现视觉运动控制与测试时规划。
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

> Recent video generation models demonstrate remarkable ability to capture complex physical interactions and scene evolution over time. To leverage their spatiotemporal priors, robotics works have adapted video models for policy learning but introduce complexity by requiring multiple stages of post-training and new architectural components for action generation. In this work, we introduce Cosmos Policy, a simple approach for adapting a large pretrained video model (Cosmos-Predict2) into an effective robot policy through a single stage of post-training on the robot demonstration data collected on the target platform, with no architectural modifications. Cosmos Policy learns to directly generate robot actions encoded as latent frames within the video model's latent diffusion process, harnessing the model's pretrained priors and core learning algorithm to capture complex action distributions. Additionally, Cosmos Policy generates future state images and values (expected cumulative rewards), which are similarly encoded as latent frames, enabling test-time planning of action trajectories with higher likelihood of success. In our evaluations, Cosmos Policy achieves state-of-the-art performance on the LIBERO and RoboCasa simulation benchmarks (98.5% and 67.1% average success rates, respectively) and the highest average score in challenging real-world bimanual manipulation tasks, outperforming strong diffusion policies trained from scratch, video model-based policies, and state-of-the-art vision-language-action models fine-tuned on the same robot demonstrations. Furthermore, given policy rollout data, Cosmos Policy can learn from experience to refine its world model and value function and leverage model-based planning to achieve even higher success rates in challenging tasks. We release code, models, and training data at this https URL
