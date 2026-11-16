---
id: "53"
org: 英伟达
short: "Cosmos Simulation"
title: "Interactive World Simulation with Cosmos for Physical AI"
aliases: ["Cosmos Simulation"]
date: 2026-11-04
category: "Cosmos · 其他"
source: "英伟达主导"
partners: []
authors: ["NVIDIA: Anis Ahmad", "Jon Allen", "Malik Aqeel Anwar", "Jesse Archer", "Maciej Bala", "Piotr Barejko", "Aarti Basant", "Dan Blick", "Taras Bolzhelarskyi", "Henry Che", "Jin Chen", "Yukang Chen", "Tae Eun Choe", "Yuzhu Dong", "Nat Duca", "Liang Feng", "Francesco Ferroni", "Xiao Fu", "Mohit Gambhir", "Vivek Goel", "Rony Goldenthal", "Aryaman Gupta", "Ali Hassani", "Nathan Hayes-Roth", "Yong He", "Michael Honke", "Shengyu Huang", "Wei Huang", "DeLesley Hutchins", "Suneel Indupuru", "Pooya Jannaty", "Jingyi Jin", "Janmesh Kalra", "Ashna Khetan", "Xin Kong", "Aleksandr Korovko", "Hui Kuang", "Zhengfei Kuang", "George Kurian", "Jean-Francois Lafleche", "Jayjun Lee", "Justin Leung", "William Lew", "Xiang Li", "Zhaoshuo Li", "Chen-Hsuan Lin", "Ming-Yu Liu", "Xiangyu Lu", "Yuhang Lu", "Martin Ding Ma", "Qianli Ma", "Aditya Mahajan", "Miguel Martin", "Janarbek Matai", "Jonathan McCaffrey", "Qing Miao", "Ashkan Mirzaei", "Mustafa Munir", "Sangmin Oh", "David Pankratz", "Trung Pham", "Marilyn Reeb", "Gavriel State", "Jiaxiang Tang", "Shitao Tang", "Yue Tang", "Tolou Tavakkoli", "Alexander Temirov", "Hweimi Tsou", "Sergei Vasilev", "Thomas Volk", "Andrew Z. Wang", "Hao Wang", "Shijie Wang", "Zhonghao Wang", "David Wehr", "Shumian Xin", "Mengyao Xu", "Yao Xu", "Shuai Yang", "Sophia Zalewski", "Pengcuo Zeren", "Cindy Zha", "Jing Zhang", "Yuliya Zhautouskaya", "Kaiwen Zheng", "Andrew Zhu", "Rick Zhuang"]
arxiv: "2611.06627"
pdf: "[[nvidia/papers/53_2611.06627_Cosmos-Simulation.pdf]]"
code: "https://github.com/NVIDIA/cosmos"
project: "https://research.nvidia.com/labs/cosmos-lab/cosmos-simulation/"
huggingface: ["https://huggingface.co/collections/nvidia/cosmos3-examples", "https://huggingface.co/nvidia/Cosmos3-Nano-Sim-Auto", "https://huggingface.co/nvidia/Cosmos3-Nano-Sim-Bimanual", "https://huggingface.co/nvidia/Cosmos3-Nano-Sim-Transfer"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia", "cosmos"]
---

# Interactive World Simulation with Cosmos for Physical AI

> [!info] 论文信息
> arXiv [2611.06627](https://arxiv.org/abs/2611.06627) · v1 2026-11-04
> PDF：[[nvidia/papers/53_2611.06627_Cosmos-Simulation.pdf|本地 PDF]]
> [代码](https://github.com/NVIDIA/cosmos) · [项目页](https://research.nvidia.com/labs/cosmos-lab/cosmos-simulation/)
> 系列：Cosmos · 其他 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：Cosmos Simulation：把 Cosmos WFM 后训练为实时流式交互模拟器，覆盖相机导航、机器人操作、可控 Transfer 与多视角驾驶仿真。
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

> We present a shared framework that adapts Cosmos world foundation models for real-time interactive world simulation in Physical AI. By streaming visual observations in response to actions and scene controls, the framework enables users and embodied agents to interact with evolving virtual environments. It supports both predicting the visual consequences of actions and generating observations from physical state maintained by an external simulator. We demonstrate this approach across camera navigation and robot manipulation, controllable video transfer, and multi-view autonomous vehicle (AV) simulation. These examples provide a shared foundation for developing interactive virtual environments for Physical AI training and evaluation. Our code and model checkpoints are available at this https URL and this https URL. The project website is available at this https URL.
