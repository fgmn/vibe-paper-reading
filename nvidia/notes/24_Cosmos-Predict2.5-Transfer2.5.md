---
id: "24"
org: 英伟达
short: "Cosmos-Predict2.5 · Transfer2.5"
title: "World Simulation with Video Foundation Models for Physical AI"
aliases: ["Cosmos-Predict2.5 · Transfer2.5"]
date: 2025-10-28
category: "Cosmos · Predict"
source: "英伟达主导"
partners: []
authors: ["NVIDIA: Arslan Ali", "Junjie Bai", "Maciej Bala", "Yogesh Balaji", "Aaron Blakeman", "Tiffany Cai", "Jiaxin Cao", "Tianshi Cao", "Elizabeth Cha", "Yu-Wei Chao", "Prithvijit Chattopadhyay", "Mike Chen", "Yongxin Chen", "Yu Chen", "Shuai Cheng", "Yin Cui", "Jenna Diamond", "Yifan Ding", "Jiaojiao Fan", "Linxi Fan", "Liang Feng", "Francesco Ferroni", "Sanja Fidler", "Xiao Fu", "Ruiyuan Gao", "Yunhao Ge", "Jinwei Gu", "Aryaman Gupta", "Siddharth Gururani", "Imad El Hanafi", "Ali Hassani", "Zekun Hao", "Jacob Huffman", "Joel Jang", "Pooya Jannaty", "Jan Kautz", "Grace Lam", "Xuan Li", "Zhaoshuo Li", "Maosheng Liao", "Chen-Hsuan Lin", "Tsung-Yi Lin", "Yen-Chen Lin", "Huan Ling", "Ming-Yu Liu", "Xian Liu", "Yifan Lu", "Alice Luo", "Qianli Ma", "Hanzi Mao", "Kaichun Mo", "Seungjun Nah", "Yashraj Narang", "Abhijeet Panaskar", "Lindsey Pavao", "Trung Pham", "Morteza Ramezanali", "Fitsum Reda", "Scott Reed", "Xuanchi Ren", "Haonan Shao", "Yue Shen", "Stella Shi", "Shuran Song", "Bartosz Stefaniak", "Shangkun Sun", "Shitao Tang", "Sameena Tasmeen", "Lyne Tchapmi", "Wei-Cheng Tseng", "Jibin Varghese", "Andrew Z. Wang", "Hao Wang", "Haoxiang Wang", "Heng Wang", "Ting-Chun Wang", "Fangyin Wei", "Jiashu Xu", "Dinghao Yang", "Xiaodong Yang", "Haotian Ye", "Seonghyeon Ye", "Xiaohui Zeng", "Jing Zhang", "Qinsheng Zhang", "Kaiwen Zheng", "Andrew Zhu", "Yuke Zhu"]
arxiv: "2511.00062"
pdf: "[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf]]"
code: "https://github.com/nvidia-cosmos/cosmos-predict2.5"
project: "https://research.nvidia.com/labs/dir/cosmos-predict2.5"
huggingface: ["https://huggingface.co/collections/nvidia/cosmos-predict25-68bb63255f2fc206c5e5b346", "https://huggingface.co/nvidia/Cosmos-Predict2.5-2B", "https://huggingface.co/nvidia/Cosmos-Predict2.5-14B", "https://huggingface.co/nvidia/Cosmos-Transfer2.5-2B"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia", "cosmos"]
---

# World Simulation with Video Foundation Models for Physical AI

> [!info] 论文信息
> arXiv [2511.00062](https://arxiv.org/abs/2511.00062) · v1 2025-10-28 · 最新 v2（2026-02-24）
> PDF：[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf|本地 PDF]]
> [代码](https://github.com/nvidia-cosmos/cosmos-predict2.5) · [项目页](https://research.nvidia.com/labs/dir/cosmos-predict2.5)
> 系列：Cosmos · Predict · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：Cosmos-Predict2.5 与 Transfer2.5 技术报告：基于 flow 的统一 Text/Image/Video2World 模型，借 Reason1 做文本 grounding，并推出更小更强的控制网。
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

> We introduce [Cosmos-Predict2.5], the latest generation of the Cosmos World Foundation Models for Physical AI. Built on a flow-based architecture, [Cosmos-Predict2.5] unifies Text2World, Image2World, and Video2World generation in a single model and leverages [Cosmos-Reason1], a Physical AI vision-language model, to provide richer text grounding and finer control of world simulation. Trained on 200M curated video clips and refined with reinforcement learning-based post-training, [Cosmos-Predict2.5] achieves substantial improvements over [Cosmos-Predict1] in video quality and instruction alignment, with models released at 2B and 14B scales. These capabilities enable more reliable synthetic data generation, policy evaluation, and closed-loop simulation for robotics and autonomous systems. We further extend the family with [Cosmos-Transfer2.5], a control-net style framework for Sim2Real and Real2Real world translation. Despite being 3.5$\times$ smaller than [Cosmos-Transfer1], it delivers higher fidelity and robust long-horizon video generation. Together, these advances establish [Cosmos-Predict2.5] and [Cosmos-Transfer2.5] as versatile tools for scaling embodied intelligence. To accelerate research and deployment in Physical AI, we release source code, pretrained checkpoints, and curated benchmarks under the NVIDIA Open Model License at this https URL and this https URL. We hope these open resources lower the barrier to adoption and foster innovation in building the next generation of embodied intelligence.
