---
id: "02"
org: 蚂蚁灵波
short: "LingBot-VLA"
title: "A Pragmatic VLA Foundation Model"
aliases: ["LingBot-VLA"]
date: 2026-01-26
category: "VLA"
source: "蚂蚁灵波主导"
partners: []
authors: ["Wei Wu", "Fan Lu", "Yunnan Wang", "Shuai Yang", "Shi Liu", "Fangjing Wang", "Qian Zhu", "He Sun", "Yong Wang", "Shuailei Ma", "Yiyu Ren", "Kejia Zhang", "Hui Yu", "Jingmei Zhao", "Shuai Zhou", "Zhenqi Qiu", "Houlong Xiong", "Ziyu Wang", "Zechen Wang", "Ran Cheng", "Yong-Lu Li", "Yongtao Huang", "Xing Zhu", "Yujun Shen", "Kecheng Zheng"]
arxiv: "2601.18692"
pdf: "[[lingbot/papers/02_2601.18692_LingBot-VLA.pdf]]"
code: "https://github.com/Robbyant/lingbot-vla/"
project: "https://technology.robbyant.com/lingbot-vla/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "lingbot"]
---

# A Pragmatic VLA Foundation Model

> [!info] 论文信息
> arXiv [2601.18692](https://arxiv.org/abs/2601.18692) · v1 2026-01-26 · 最新 v4（2026-06-15）
> PDF：[[lingbot/papers/02_2601.18692_LingBot-VLA.pdf|本地 PDF]]
> [github.com](https://github.com/Robbyant/lingbot-vla/) · [huggingface.co](https://huggingface.co/datasets/robbyant/lingbot-GM-100) · [technology.robbyant.com](https://technology.robbyant.com/lingbot-vla/) · [github.com](https://github.com/robbyant/lingbot-vla)
> 方向：VLA · 角色：蚂蚁灵波主导
> 汇总：[[lingbot/蚂蚁灵波-论文汇总|蚂蚁灵波论文汇总]]

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

> Offering great potential in robotic manipulation, a capable Vision-Language-Action (VLA) foundation model is expected to faithfully generalize across tasks and platforms while ensuring cost efficiency (e.g., data and GPU hours required for adaptation). To this end, we develop LingBot-VLA with around 20,000 hours of real-world data from 9 popular dual-arm robot configurations. Through a systematic assessment on 4 robotic platforms, each completing 100 tasks with 130 post-training episodes per task, our model achieves clear superiority over competitors, showcasing its strong performance and broad generalizability. We have also built an efficient codebase, which delivers a throughput of 261 samples per second with an 8-GPU training setup, representing a 1.5~2.8$\times$ (depending on the relied VLM base model) speedup over existing VLA-oriented codebases. The above features ensure that our model is well-suited for real-world deployment. To advance the field of robot learning, we provide open access to the code, base model, and benchmark data, with a focus on enabling more challenging tasks and promoting sound evaluation standards.
