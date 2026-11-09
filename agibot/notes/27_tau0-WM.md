---
id: "27"
org: 智元
short: "τ0-WM"
title: "$τ_0$-WM: A Unified Video-Action World Model for Robotic Manipulation"
aliases: ["τ0-WM"]
date: 2026-05-31
category: "世界模型"
source: "智元主导"
product: ""
partners: []
authors: ["Pengfei Zhou", "Shengcong Chen", "Di Chen", "Jiaxu Wang", "Rongjun Jin", "Bingwen Zhu", "Yike Pan", "Songen Gu", "Kuanning Wang", "Shufeng Nan", "Xingyu Qiu", "Chenhao Qiu", "Pu Yang", "Yunuo Cai", "Jianxiong Gao", "Yifan Li", "Yanwei Fu", "Xiangyu Yue", "Zhi Chen", "Jianlan Luo"]
arxiv: "2606.01027"
pdf: "[[agibot/papers/27_2606.01027_tau0-WM.pdf]]"
code: ""
project: "https://tau0-wm.github.io"
huggingface: []
license: CC BY-NC-SA 4.0
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# $τ_0$-WM: A Unified Video-Action World Model for Robotic Manipulation

> [!info] 论文信息
> arXiv [2606.01027](https://arxiv.org/abs/2606.01027) · v1 2026-05-31 · 最新 v2（2026-08-23）
> PDF：[[agibot/papers/27_2606.01027_tau0-WM.pdf|本地 PDF]]
> [项目页](https://tau0-wm.github.io)
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：τ0-WM：统一策略学习、视频预测与动作评估的视频-动作世界模型。
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

> Robotic manipulation requires models that generate executable actions while anticipating and evaluating their future consequences before physical execution. We present $\tau_0$-World Model ($\tau_0$-WM), a unified video-action world model that integrates policy learning, video prediction, and action evaluation within a single future-predictive framework. Built on a shared video diffusion backbone, $\tau_0$-WM provides two complementary interfaces. First, a video action model jointly predicts future visual latents and continuous action chunks from multi-view observations, language instructions, and robot state. Second, an action-conditioned video simulator rolls out candidate action chunks into multi-view futures and predicts dense task-progress scores. The model is trained on approximately $27{,}300$ hours of real-robot teleoperation, UMI-style interaction, egocentric human videos, and rollout or failure trajectories using modality-specific supervision masks. At inference time, $\tau_0$-WM uses test-time computation to sample action candidates, rank them with re-denoising consistency, and invoke simulator-based rectification for low-quality candidates. On challenging long-horizon and fine-grained robotic manipulation tasks, $\tau_0$-WM shows superior performance over other relevant baselines.
