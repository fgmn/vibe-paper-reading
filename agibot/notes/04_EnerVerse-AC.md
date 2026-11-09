---
id: "04"
org: 智元
short: "EnerVerse-AC"
title: "EnerVerse-AC: Envisioning Embodied Environments with Action Condition"
aliases: ["EnerVerse-AC"]
date: 2025-05-14
category: "世界模型"
source: "智元主导"
product: ""
partners: []
authors: ["Yuxin Jiang", "Shengcong Chen", "Siyuan Huang", "Liliang Chen", "Pengfei Zhou", "Yue Liao", "Xindong He", "Chiming Liu", "Hongsheng Li", "Maoqing Yao", "Guanghui Ren"]
arxiv: "2505.09723"
pdf: "[[agibot/papers/04_2505.09723_EnerVerse-AC.pdf]]"
code: "https://github.com/AgibotTech/EnerVerse-AC"
project: "https://annaj2178.github.io/EnerverseAC.github.io"
huggingface: ["https://huggingface.co/agibot-world/EnerVerse-AC"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# EnerVerse-AC: Envisioning Embodied Environments with Action Condition

> [!info] 论文信息
> arXiv [2505.09723](https://arxiv.org/abs/2505.09723) · v1 2025-05-14
> PDF：[[agibot/papers/04_2505.09723_EnerVerse-AC.pdf|本地 PDF]]
> [代码](https://github.com/AgibotTech/EnerVerse-AC) · [项目页](https://annaj2178.github.io/EnerverseAC.github.io)
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：EnerVerse-AC：动作条件世界模型，根据预测动作生成多视角未来观测，用于策略评测与数据扩增。
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

> Robotic imitation learning has advanced from solving static tasks to addressing dynamic interaction scenarios, but testing and evaluation remain costly and challenging due to the need for real-time interaction with dynamic environments. We propose EnerVerse-AC (EVAC), an action-conditional world model that generates future visual observations based on an agent's predicted actions, enabling realistic and controllable robotic inference. Building on prior architectures, EVAC introduces a multi-level action-conditioning mechanism and ray map encoding for dynamic multi-view image generation while expanding training data with diverse failure trajectories to improve generalization. As both a data engine and evaluator, EVAC augments human-collected trajectories into diverse datasets and generates realistic, action-conditioned video observations for policy testing, eliminating the need for physical robots or complex simulations. This approach significantly reduces costs while maintaining high fidelity in robotic manipulation evaluation. Extensive experiments validate the effectiveness of our method. Code, checkpoints, and datasets can be found at <this https URL.
