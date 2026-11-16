---
id: "13"
org: 英伟达
short: "Cosmos-Reason1"
title: "Cosmos-Reason1: From Physical Common Sense To Embodied Reasoning"
aliases: ["Cosmos-Reason1"]
date: 2025-03-18
category: "Cosmos · Reason"
source: "英伟达主导"
partners: []
authors: ["NVIDIA: Alisson Azzolini", "Junjie Bai", "Hannah Brandon", "Jiaxin Cao", "Prithvijit Chattopadhyay", "Huayu Chen", "Jinju Chu", "Yin Cui", "Jenna Diamond", "Yifan Ding", "Liang Feng", "Francesco Ferroni", "Rama Govindaraju", "Jinwei Gu", "Siddharth Gururani", "Imad El Hanafi", "Zekun Hao", "Jacob Huffman", "Jingyi Jin", "Brendan Johnson", "Rizwan Khan", "George Kurian", "Elena Lantz", "Nayeon Lee", "Zhaoshuo Li", "Xuan Li", "Maosheng Liao", "Tsung-Yi Lin", "Yen-Chen Lin", "Ming-Yu Liu", "Xiangyu Lu", "Alice Luo", "Andrew Mathau", "Yun Ni", "Lindsey Pavao", "Wei Ping", "David W. Romero", "Misha Smelyanskiy", "Shuran Song", "Lyne Tchapmi", "Andrew Z. Wang", "Boxin Wang", "Haoxiang Wang", "Fangyin Wei", "Jiashu Xu", "Yao Xu", "Dinghao Yang", "Xiaodong Yang", "Zhuolin Yang", "Jingxu Zhang", "Xiaohui Zeng", "Zhe Zhang"]
arxiv: "2503.15558"
pdf: "[[nvidia/papers/13_2503.15558_Cosmos-Reason1.pdf]]"
code: "https://github.com/nvidia-cosmos/cosmos-reason1"
project: "https://research.nvidia.com/labs/dir/cosmos-reason1/"
huggingface: ["https://huggingface.co/collections/nvidia/cosmos-reason1-67c9e926206426008f1da1b7", "https://huggingface.co/nvidia/Cosmos-Reason1-7B"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia", "cosmos"]
---

# Cosmos-Reason1: From Physical Common Sense To Embodied Reasoning

> [!info] 论文信息
> arXiv [2503.15558](https://arxiv.org/abs/2503.15558) · v1 2025-03-18 · 最新 v3（2025-05-19）
> PDF：[[nvidia/papers/13_2503.15558_Cosmos-Reason1.pdf|本地 PDF]]
> [代码](https://github.com/nvidia-cosmos/cosmos-reason1) · [项目页](https://research.nvidia.com/labs/dir/cosmos-reason1/)
> 系列：Cosmos · Reason · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：面向物理 AI 的多模态推理大模型，基于物理常识与具身推理本体做 SFT+RL，以长思维链输出具身决策，并构建配套基准。
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

> Physical AI systems need to perceive, understand, and perform complex actions in the physical world. In this paper, we present the Cosmos-Reason1 models that can understand the physical world and generate appropriate embodied decisions (e.g., next step action) in natural language through long chain-of-thought reasoning processes. We begin by defining key capabilities for Physical AI reasoning, with a focus on physical common sense and embodied reasoning. To represent physical common sense, we use a hierarchical ontology that captures fundamental knowledge about space, time, and physics. For embodied reasoning, we rely on a two-dimensional ontology that generalizes across different physical embodiments. Building on these capabilities, we develop two multimodal large language models, Cosmos-Reason1-7B and Cosmos-Reason1-56B. We curate data and train our models in two stages: Physical AI supervised fine-tuning (SFT) and Physical AI reinforcement learning (RL). To evaluate our models, we build comprehensive benchmarks for physical common sense and embodied reasoning according to our ontologies. Evaluation results show that Physical AI SFT and RL bring significant improvements. To facilitate the development of Physical AI, we make our code and pre-trained models available under the NVIDIA Open Model License at this https URL.
