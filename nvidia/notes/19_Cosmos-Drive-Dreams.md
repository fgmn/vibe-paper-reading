---
id: "19"
org: 英伟达
short: "Cosmos-Drive-Dreams"
title: "Cosmos-Drive-Dreams: Scalable Synthetic Driving Data Generation with World Foundation Models"
aliases: ["Cosmos-Drive-Dreams"]
date: 2025-06-10
category: "Cosmos · Drive"
source: "英伟达主导"
partners: []
authors: ["Xuanchi Ren", "Yifan Lu", "Tianshi Cao", "Ruiyuan Gao", "Shengyu Huang", "Amirmojtaba Sabour", "Tianchang Shen", "Tobias Pfaff", "Jay Zhangjie Wu", "Runjian Chen", "Seung Wook Kim", "Jun Gao", "Laura Leal-Taixe", "Mike Chen", "Sanja Fidler", "Huan Ling"]
arxiv: "2506.09042"
pdf: "[[nvidia/papers/19_2506.09042_Cosmos-Drive-Dreams.pdf]]"
code: "https://github.com/nv-tlabs/Cosmos-Drive-Dreams"
project: "https://research.nvidia.com/labs/toronto-ai/cosmos_drive_dreams"
huggingface: ["https://huggingface.co/collections/nvidia/cosmos-drive-dreams", "https://huggingface.co/datasets/nvidia/PhysicalAI-Autonomous-Vehicle-Cosmos-Drive-Dreams"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia", "cosmos"]
---

# Cosmos-Drive-Dreams: Scalable Synthetic Driving Data Generation with World Foundation Models

> [!info] 论文信息
> arXiv [2506.09042](https://arxiv.org/abs/2506.09042) · v1 2025-06-10 · 最新 v3（2025-06-18）
> PDF：[[nvidia/papers/19_2506.09042_Cosmos-Drive-Dreams.pdf|本地 PDF]]
> [代码](https://github.com/nv-tlabs/Cosmos-Drive-Dreams) · [项目页](https://research.nvidia.com/labs/toronto-ai/cosmos_drive_dreams)
> 系列：Cosmos · Drive · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：基于 Cosmos 特化的驾驶模型 Cosmos-Drive 构建合成数据管线，生成多视角可控的长尾驾驶场景以提升感知与规划。
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

> Collecting and annotating real-world data for safety-critical physical AI systems, such as Autonomous Vehicle (AV), is time-consuming and costly. It is especially challenging to capture rare edge cases, which play a critical role in training and testing of an AV system. To address this challenge, we introduce the Cosmos-Drive-Dreams - a synthetic data generation (SDG) pipeline that aims to generate challenging scenarios to facilitate downstream tasks such as perception and driving policy training. Powering this pipeline is Cosmos-Drive, a suite of models specialized from NVIDIA Cosmos world foundation model for the driving domain and are capable of controllable, high-fidelity, multi-view, and spatiotemporally consistent driving video generation. We showcase the utility of these models by applying Cosmos-Drive-Dreams to scale the quantity and diversity of driving datasets with high-fidelity and challenging scenarios. Experimentally, we demonstrate that our generated data helps in mitigating long-tail distribution problems and enhances generalization in downstream tasks such as 3D lane detection, 3D object detection and driving policy learning. We open source our pipeline toolkit, dataset and model weights through the NVIDIA's Cosmos platform. Project page: this https URL
