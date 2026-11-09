---
id: "28"
org: 智元
short: "VINE"
title: "VINE: Taming Generative Control Policies for Reinforcement Learning"
aliases: ["VINE"]
date: 2026-07-11
category: "其他"
source: "智元主导"
product: ""
partners: []
authors: ["Rushuai Yang", "Zhuo Han", "Houlin Li", "Hecheng Wang", "Zhichao Wu", "Rui Zhang", "Zhaowei Zhang", "Zihong Chen", "Xiaohan Yan", "Chiming Liu", "Yi Chen", "Wei Shan", "Maoqing Yao"]
arxiv: "2607.10369"
pdf: "[[agibot/papers/28_2607.10369_VINE.pdf]]"
code: "https://github.com/AgibotTech/vine-code"
project: "https://agibottech.github.io/vine"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# VINE: Taming Generative Control Policies for Reinforcement Learning

> [!info] 论文信息
> arXiv [2607.10369](https://arxiv.org/abs/2607.10369) · v1 2026-07-11
> PDF：[[agibot/papers/28_2607.10369_VINE.pdf|本地 PDF]]
> [代码](https://github.com/AgibotTech/vine-code) · [项目页](https://agibottech.github.io/vine)
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：VINE：改进流匹配策略采样，使价值梯度强化学习对生成式控制策略稳定可用。
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

> Flow-matching policies have emerged as an effective policy parameterization for robot learning. They iteratively generate actions from noise, enabling highly expressive modeling of complex and multimodal action distributions. However, prior works observed that scaling these policies with value-gradient reinforcement learning (RL) often leads to training instability. Existing methods attribute this instability to iterative generation and therefore avoid end-to-end value-gradient optimization by sacrificing iterative generation, high expressiveness, or value-gradient optimization. Contrary to prior belief, we show the instability does not stem from iterative generation itself, but from the vanilla sampling strategy originally designed for behavior cloning, which becomes brittle under value-gradient RL. Motivated by this insight, we propose VINE, an RL-oriented sampling method that enables stable end-to-end value-gradient optimization for flow-matching policies. Instead of following a single flow trajectory, VINE reconstructs a new interpolation state at every denoising step, creating a stable differentiable path for value-gradient propagation while remaining compatible with the original flow-matching denoising process. As a result, VINE preserves the expressiveness and iterative generation of flow-matching without sacrificing end-to-end value-gradient optimization. Despite performing end-to-end backpropagation through all ten denoising steps, VINE achieves stable policy improvement and consistently outperforms state-of-the-art RL methods on the OGBench offline RL benchmark and real-world robotic manipulation task. Videos are available on our website: this https URL.
