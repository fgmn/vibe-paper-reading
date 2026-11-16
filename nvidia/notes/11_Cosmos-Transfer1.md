---
id: "11"
org: 英伟达
short: "Cosmos-Transfer1"
title: "Cosmos-Transfer1: Conditional World Generation with Adaptive Multimodal Control"
aliases: ["Cosmos-Transfer1"]
date: 2025-03-18
category: "Cosmos · Transfer"
source: "英伟达主导"
partners: []
authors: ["NVIDIA: Hassan Abu Alhaija", "Jose Alvarez", "Maciej Bala", "Tiffany Cai", "Tianshi Cao", "Liz Cha", "Joshua Chen", "Mike Chen", "Francesco Ferroni", "Sanja Fidler", "Dieter Fox", "Yunhao Ge", "Jinwei Gu", "Ali Hassani", "Michael Isaev", "Pooya Jannaty", "Shiyi Lan", "Tobias Lasser", "Huan Ling", "Ming-Yu Liu", "Xian Liu", "Yifan Lu", "Alice Luo", "Qianli Ma", "Hanzi Mao", "Fabio Ramos", "Xuanchi Ren", "Tianchang Shen", "Xinglong Sun", "Shitao Tang", "Ting-Chun Wang", "Jay Wu", "Jiashu Xu", "Stella Xu", "Kevin Xie", "Yuchong Ye", "Xiaodong Yang", "Xiaohui Zeng", "Yu Zeng"]
arxiv: "2503.14492"
pdf: "[[nvidia/papers/11_2503.14492_Cosmos-Transfer1.pdf]]"
code: "https://github.com/nvidia-cosmos/cosmos-transfer1"
project: "https://research.nvidia.com/labs/dir/cosmos-transfer1/"
huggingface: ["https://huggingface.co/collections/nvidia/cosmos-transfer1-67c9d328196453be6e568d3e", "https://huggingface.co/nvidia/Cosmos-Transfer1-7B"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia", "cosmos"]
---

# Cosmos-Transfer1: Conditional World Generation with Adaptive Multimodal Control

> [!info] 论文信息
> arXiv [2503.14492](https://arxiv.org/abs/2503.14492) · v1 2025-03-18 · 最新 v2（2025-04-01）
> PDF：[[nvidia/papers/11_2503.14492_Cosmos-Transfer1.pdf|本地 PDF]]
> [代码](https://github.com/nvidia-cosmos/cosmos-transfer1) · [项目页](https://research.nvidia.com/labs/dir/cosmos-transfer1/)
> 系列：Cosmos · Transfer · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：以分割、深度、边缘等多模态空间控制为条件、可按空间位置自适应加权的世界生成模型，用于 Sim2Real 与自动驾驶数据增强。
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

> We introduce Cosmos-Transfer, a conditional world generation model that can generate world simulations based on multiple spatial control inputs of various modalities such as segmentation, depth, and edge. In the design, the spatial conditional scheme is adaptive and customizable. It allows weighting different conditional inputs differently at different spatial locations. This enables highly controllable world generation and finds use in various world-to-world transfer use cases, including Sim2Real. We conduct extensive evaluations to analyze the proposed model and demonstrate its applications for Physical AI, including robotics Sim2Real and autonomous vehicle data enrichment. We further demonstrate an inference scaling strategy to achieve real-time world generation with an NVIDIA GB200 NVL72 rack. To help accelerate research development in the field, we open-source our models and code at this https URL.
