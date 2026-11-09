---
id: "02"
org: 智元
short: "AgiBot World Colosseo"
title: "AgiBot World Colosseo: A Large-scale Manipulation Platform for Scalable and Intelligent Embodied Systems"
aliases: ["AgiBot World Colosseo"]
date: 2025-03-09
category: "数据集"
source: "智元主导"
product: "精灵 G1"
partners: []
authors: ["AgiBot World Contributors", "Qingwen Bu", "Jisong Cai", "Li Chen", "Xiuqi Cui", "Yan Ding", "Siyuan Feng", "Shenyuan Gao", "Xindong He", "Xuan Hu", "Xu Huang", "Shu Jiang", "Yuxin Jiang", "Cheng Jing", "Hongyang Li", "Jialu Li", "Chiming Liu", "Yi Liu", "Yuxiang Lu", "Jianlan Luo", "Ping Luo", "Yao Mu", "Yuehan Niu", "Yixuan Pan", "Jiangmiao Pang", "Yu Qiao", "Guanghui Ren", "Cheng Ruan", "Jiaqi Shan", "Yongjian Shen", "Chengshi Shi", "Mingkang Shi", "Modi Shi", "Chonghao Sima", "Jianheng Song", "Huijie Wang", "Wenhao Wang", "Dafeng Wei", "Chengen Xie", "Guo Xu", "Junchi Yan", "Cunbiao Yang", "Lei Yang", "Shukai Yang", "Maoqing Yao", "Jia Zeng", "Chi Zhang", "Qinglin Zhang", "Bin Zhao", "Chengyue Zhao", "Jiaqi Zhao", "Jianchao Zhu"]
arxiv: "2503.06669"
pdf: "[[agibot/papers/02_2503.06669_AgiBot-World-Colosseo.pdf]]"
code: "https://github.com/OpenDriveLab/AgiBot-World"
project: "https://agibot-world.com/"
huggingface: ["https://huggingface.co/datasets/agibot-world/AgiBotWorld-Alpha", "https://huggingface.co/datasets/agibot-world/AgiBotWorld-Beta", "https://huggingface.co/agibot-world/GO-1", "https://huggingface.co/agibot-world/GO-1-Air"]
license: CC BY-NC-SA 4.0
status: 未读
rating:
read_date:
tags: ["paper", "agibot"]
---

# AgiBot World Colosseo: A Large-scale Manipulation Platform for Scalable and Intelligent Embodied Systems

> [!info] 论文信息
> arXiv [2503.06669](https://arxiv.org/abs/2503.06669) · v1 2025-03-09 · 最新 v5（2026-10-20） · 发表：IROS 2025 Best Paper Award Finalist; IEEE TRO 2026（据 GitHub README）
> PDF：[[agibot/papers/02_2503.06669_AgiBot-World-Colosseo.pdf|本地 PDF]]
> [代码](https://github.com/OpenDriveLab/AgiBot-World) · [项目页](https://agibot-world.com/)
> 角色：智元主导 · 机型：精灵 G1
> 清单里的一句话（Claude 根据摘要写，请核对）：AgiBot World：百台精灵 G1 采集的百万级轨迹操作数据平台，并提出 GO-1（Genie Operator-1）通用策略。
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

> We explore how scalable robot data can address real-world challenges for generalized robotic manipulation. Introducing AgiBot World, a large-scale platform comprising over 1 million trajectories across 217 tasks in five deployment scenarios, we achieve an order-of-magnitude increase in data scale compared to existing datasets. Accelerated by a standardized collection pipeline with human-in-the-loop verification, AgiBot World guarantees high-quality and diverse data distribution. It is extensible from grippers to dexterous hands and visuo-tactile sensors for fine-grained skill acquisition. Building on top of data, we introduce Genie Operator-1 (GO-1), a novel generalist policy that leverages latent action representations to maximize data utilization, demonstrating predictable performance scaling with increased data volume. Policies pre-trained on our dataset achieve an average performance improvement of 30% over those trained on Open X-Embodiment, both in in-domain and out-of-distribution scenarios. GO-1 exhibits exceptional capability in real-world dexterous and long-horizon tasks, achieving over 60% success rate on complex tasks and outperforming prior RDT approach by 32%. By open-sourcing the dataset, tools, and models, we aim to democratize access to large-scale, high-quality robot data, advancing the pursuit of scalable and general-purpose intelligence.
