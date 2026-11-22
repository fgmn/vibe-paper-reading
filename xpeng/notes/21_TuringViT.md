---
id: "21"
org: 小鹏
short: "TuringViT"
title: "TuringViT: Making SOTA Vision Transformers Accessible to All"
aliases: ["TuringViT"]
date: 2026-06-23
category: "机器人"
source: "小鹏主导"
product: "通用（车+IRON）"
partners: []
authors: ["Qiman Wu", "Hanlin Chen", "Lyujie Chen", "Rui Xin", "Jianlei Zheng", "Mingyuan Wang", "Jiahui Hu", "Da Zhu", "Yuecheng Ma", "Yuhua Wei", "Yizhao Wang", "Hua Zhou", "Yuheng Zhang", "Anhua Liu", "Shaman Tang", "Yue He", "Pengfei Diao", "Shuang Su", "Haotong Xin", "Weichao Huang", "Hang Zhang", "Xianming Liu"]
arxiv: "2606.24253"
pdf: "[[xpeng/papers/21_2606.24253_TuringViT.pdf]]"
code: ""
project: "https://turingvit.github.io"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "xpeng", "robotics"]
---

# TuringViT: Making SOTA Vision Transformers Accessible to All

> [!info] 论文信息
> arXiv [2606.24253](https://arxiv.org/abs/2606.24253) · v1 2026-06-23 · 最新 v2（2026-06-26）
> PDF：[[xpeng/papers/21_2606.24253_TuringViT.pdf|本地 PDF]]
> [项目页](https://turingvit.github.io)
> 方向：机器人 · 角色：小鹏主导 · 产品：通用（车+IRON）
> 清单里的一句话（Claude 根据摘要写，请核对）：TuringViT：让SOTA级ViT训练可复现可及，作为小鹏AI系统统一视觉底座。
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

> Modern VLMs and VLA systems commonly adopt off-the-shelf ViTs such as SigLIP2 as visual encoders, but diverse downstream requirements in latency, temporal modeling, and VLM integration often call for customized SOTA-level ViTs. Training such encoders remains beyond the reach of much of the community, as it requires massive image-text data, while standard softmax attention makes high-resolution or dynamic-resolution pretraining prohibitively costly and often forces low-resolution pretraining followed by post-hoc adaptation. TuringViT addresses these challenges with three key designs: Turing Linear Attention (TLA) for efficient sequence modeling, VISTA-Curation to construct supervision-rich image-video training data, and native dynamic-resolution pretraining that supports flexible inputs from the start and transfers seamlessly to downstream VLMs. As a result, TuringViT outperforms leading open-source ViT baselines with only 10% of the data, achieves stronger downstream VLM performance, and delivers substantially better latency scaling on high-resolution inputs. Our scaling-law analysis further shows that TuringViT continues to improve predictably with curated data scale, far from saturation. Its fast adaptation, hardware-friendly design, and efficient deployment have made it a unified visual foundation across XPeng's AI systems. More broadly, TuringViT provides a reproducible pipeline that dramatically lowers the cost for the community to train, customize, and deploy SOTA-level ViTs, moving toward making such Vision Transformers accessible to all.
