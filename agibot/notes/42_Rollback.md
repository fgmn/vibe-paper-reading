---
id: "42"
org: 智元
short: "Rollback"
title: "Rollback: Experience Backtracking in World Models for Policy Improvement"
aliases: ["Rollback"]
date: 2026-10-26
category: "世界模型"
source: "智元主导"
product: ""
partners: []
authors: ["Jiayi Luo", "Yang Zhang", "Liliang Chen", "Nan Wang", "Chen Gao", "Boxiang Qiu", "Zhuoxuan Li", "Baorui Peng", "Chuankang Li", "Yuxiang Yan", "Si Liu", "Qingyun Sun", "Shuicheng Yan", "Maoqing Yao", "Jianxin Li", "Guanghui Ren"]
arxiv: "2610.36068"
pdf: "[[agibot/papers/42_2610.36068_Rollback.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# Rollback: Experience Backtracking in World Models for Policy Improvement

> [!info] 论文信息
> arXiv [2610.36068](https://arxiv.org/abs/2610.36068) · v1 2026-10-26
> PDF：[[agibot/papers/42_2610.36068_Rollback.pdf|本地 PDF]]
> 角色：智元主导
> 清单里的一句话（Claude 根据摘要写，请核对）：Rollback：在动作条件世界模型中回退到过去决策点探索反事实未来，以改进策略。
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

> Action-conditioned world models offer a scalable alternative to costly real-world interaction for improving robot policies. However, existing world-model-based methods largely treat world models as forward-only surrogates of the physical environment, leaving untapped a capability no physical environment affords: rewinding to past decision points to explore counterfactual futures. We introduce Rollback, a policy improvement paradigm that turns world models from passive simulators into counterfactual engines: it rolls back to critical decision points, branches into alternative actions, and contrasts their outcomes to attribute success to individual decisions. This concentrates imagination where it matters most and distills counterfactual outcomes into fine-grained, action-level supervision without a separately learned value model. We build a scalable training system that unifies distributed world-model search with asynchronous real-robot execution, forming a self-reinforcing cycle: real-world experience continually sharpens the world model, and a sharper world model in turn drives further policy improvement. We term the world-model side of this cycle test-time physics grounding, a capability that hand-built physics simulators lack: while the world model serves as the training environment, real transitions from the policy it trains correct its dynamics through a lightweight LoRA pipeline. Experiments on three challenging real-world tasks show that Rollback improves success rates over the strongest baseline by an absolute 10.67%, 11.11%, and 11.85% on block extraction, ball tossing, and tabletop curling, respectively, while achieving more stable improvement throughout training. Although initialized from teleoperated demonstrations far below human level, Rollback surpasses the average success rate of human players on both ball tossing and tabletop curling within 8 hours of training.
