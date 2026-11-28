---
id: "09"
org: 蚂蚁灵波
short: "LingBot-VA 2.0"
title: "Native Video-Action Pretraining for Generalizable Robot Control"
aliases: ["LingBot-VA 2.0"]
date: 2026-07-09
category: "世界-动作模型"
source: "蚂蚁灵波主导"
partners: []
authors: ["Qihang Zhang", "Lin Li", "Luyao Zhang", "Shuai Yang", "Yiming Luo", "Shuaiting Li", "Ruilin Wang", "Junke Wang", "Jiahao Shao", "Gangwei Xu", "Jiaming Zhou", "Yishu Shen", "Yudong Jin", "Fangyi Xu", "Shuailei Ma", "Jiaqi Liao", "Guanxing Lu", "Zifan Shi", "Yongkun Wen", "Yujie Zhao", "Weixuan Tang", "Xinyang Wang", "Chaojian Li", "Jiapeng Zhu", "Ka Leong Cheng", "Nan Xue", "Xing Zhu", "Yujun Shen", "Yinghao Xu"]
arxiv: "2607.08639"
pdf: "[[lingbot/papers/09_2607.08639_LingBot-VA-2.0.pdf]]"
code: ""
project: "https://technology.robbyant.com/lingbot-va-v2"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "lingbot"]
---

# Native Video-Action Pretraining for Generalizable Robot Control

> [!info] 论文信息
> arXiv [2607.08639](https://arxiv.org/abs/2607.08639) · v1 2026-07-09 · 最新 v2（2026-07-16）
> PDF：[[lingbot/papers/09_2607.08639_LingBot-VA-2.0.pdf|本地 PDF]]
> [technology.robbyant.com](https://technology.robbyant.com/lingbot-va-v2)
> 方向：世界-动作模型 · 角色：蚂蚁灵波主导
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

> The advent of video-action models offers a promising path for robot control. Nevertheless, we argue that repurposing video generative models designed for digital content creation is inherently inadequate for physical environments. To bridge this gap, we present LingBot-VA 2.0, a video-action foundation model built from the ground up for embodiment. Four core design principles showcase its evolution from LingBot-VA. (1) Departing from traditional reconstruction-focused VAEs, we introduce a semantic visual-action tokenizer, which aligns visual representations with both semantics and actions, improving instruction following and action precision in subsequent policy learning. (2) Given the strictly causal nature of temporal dynamics, we adopt a causal pretraining paradigm, training from scratch to circumvent the catastrophic forgetting that frequently occurs when adapting bidirectional architectures. (3) To meet the demands of high-frequency inference, our model employs a sparse MoE backbone, expanding model capacity without compromising efficiency. (4) Real-time closed-loop control is realized through an enhanced asynchronous inference scheme, which predicts future latents in parallel with action execution while re-grounding each rollout on the latest observation via learned forward dynamics. Real-world deployment validates LingBot-VA 2.0 as a robust foundation model, as evidenced by its few-shot generalization across complex manipulation tasks.
