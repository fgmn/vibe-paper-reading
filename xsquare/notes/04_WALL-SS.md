---
id: "04"
org: 自变量
short: "WALL-SS"
title: "WALL-SS: Scaling Long-horizon World Models via Next-Scale Autoregression"
aliases: ["WALL-SS"]
date: 2026-08-26
category: 世界模型
source: 自变量主导
partners: []
authors: ["Maeve Zhang", "Rain Sun", "Xiang Wang", "Cyril Zhang", "Shalfun Li", "Meng Cao", "Howard Lu", "Ethan Chen", "Harry Jhou", "KZ Zheng", "Lights Shi", "Regis Cheng", "Lorenzin", "Robert Wang", "Victor Yao", "Gody Li", "Elise Mon", "Yohann Tang", "Ryan Yu", "PS Zhang", "Vincent Chen", "Hang Su", "Roy Gan", "Hao Wang", "Qian Wang"]
arxiv: "2608.26239"
pdf: "[[xsquare/papers/04_2608.26239_WALL-SS.pdf]]"
code: "https://github.com/X-Square-Robot/wall-ss"
project: "https://x2robot.com/pages/ss"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "world-model", "simulation", "policy-evaluation"]
---

# WALL-SS: Scaling Long-horizon World Models via Next-Scale Autoregression

> [!info] 论文信息
> arXiv [2608.26239](https://arxiv.org/abs/2608.26239) · v1 2026-08-26
> PDF：[[xsquare/papers/04_2608.26239_WALL-SS.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/wall-ss) · [项目页](https://x2robot.com/pages/ss) · [官网 PDF](https://x2robot-open.oss-cn-shenzhen.aliyuncs.com/ARWM%20OPEN/WALL-SS.pdf)

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

> Generative world models provide robots with predictive models of how the world evolves under interaction, with growing potential for simulation, planning, policy evaluation, and robot learning. Beyond clip-level future prediction, a unified generative formulation should relate actions to consequences, support flexible horizons and continuous interaction, and enable reward-driven optimization. We introduce WALL-SS, a world model that generates visual futures through Scale-wise autoregressive Scaling, enabling action-controllable and long-horizon robotic simulation. WALL-SS represents embodied trajectories as causal sequences of temporally interleaved observations and actions, making action-dependent state transitions explicit while naturally supporting variable-length generation, streaming extension through reusable causal states, and direct optimization through sequence probabilities. To make this formulation effective over long horizons, we generate each future observation in a coarse-to-fine manner and develop three complementary components within the same hierarchy. Action-conditioned next-scale prediction injects scale-aligned action representations to improve action-future coupling and model both successful and failed behaviors. Scale-compressed long-horizon memory retains recent interactions at fine resolution while compressing distant observations and actions, with scale-wise dream forcing enhancing robustness to self-generated context. Finally, on-policy alignment optimizes autoregressive visual dynamics with action-following and long-term consistency rewards while preserving the pretrained visual distribution. Experiments show that WALL-SS improves action following and trajectory accuracy, supports coherent minute-long streaming rollout under bounded memory, and consistently benefits from on-policy alignment in reducing action drift and long-horizon inconsistency.
