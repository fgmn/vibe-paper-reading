---
id: "29"
org: 小鹏
short: "TuringLLM"
title: "TuringLLM: Efficiently Scaling Foundation Models Toward Physical AI"
aliases: ["TuringLLM"]
date: 2026-08-31
category: "机器人"
source: "小鹏主导"
product: "通用（车+IRON）"
partners: []
authors: ["Yuheng Zhang", "Yizhao Wang", "Da Zhu", "Hua Zhou", "Yue He", "Jiahui Hu", "Shaman Tang", "Hanlin Chen", "Yuhua Wei", "Anhua Liu", "Shuang Su", "Rui Xin", "MingYuan Wang", "MingHao Li", "HaoJie Yang", "Siqi Liu", "Jianlei Zheng", "WeiChao Huang", "Qiman Wu", "Hang Zhang", "HongGou Yang", "Xianming Liu"]
arxiv: "2608.30567"
pdf: "[[xpeng/papers/29_2608.30567_TuringLLM.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# TuringLLM: Efficiently Scaling Foundation Models Toward Physical AI

> [!info] 论文信息
> arXiv [2608.30567](https://arxiv.org/abs/2608.30567) · v1 2026-08-31
> PDF：[[xpeng/papers/29_2608.30567_TuringLLM.pdf|本地 PDF]]
> 方向：机器人 · 角色：小鹏主导 · 产品：通用（车+IRON）
> 清单里的一句话（Claude 根据摘要写，请核对）：TuringLLM：20B总参/2B激活的MoE语言基座，面向物理AI长上下文低时延应用。
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

> We present Turing-20B-A2B, a 20B-parameter Mixture-of-Experts language model that activates approximately 2B parameters per token, designed for long-context and latency-sensitive physical AI applications. The model adopts Quantile Routing in a dynamic top-k configuration, enabling token-adaptive expert allocation while maintaining balanced expert utilization and a controlled average compute budget. During deployment, we further apply capacity-constrained routing to prompt prefill for more regular and efficient expert execution, while retaining dropless routing during pretraining. Turing-20B-A2B also employs a hybrid attention architecture that combines Lightning Attention with a small number of full-attention layers for efficient long-context modeling. The model is pretrained with a progressive three-stage curriculum and extended to a native context length of 128K through continued pretraining, with further inference-time extension to 512K using YaRN. Despite its compact active-parameter budget, Turing-20B-A2B achieves, at the base-model stage, overall general capability exceeding Qwen3-8B Base and approaching Qwen3.5-9B Base, while maintaining strong long-context performance and favorable prefill-latency scaling. These results demonstrate an effective balance among model capability, long-context scalability, and practical inference efficiency.
