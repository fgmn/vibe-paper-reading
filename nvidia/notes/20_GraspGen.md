---
id: "20"
org: 英伟达
short: "GraspGen"
title: "GraspGen: A Diffusion-based Framework for 6-DOF Grasping with On-Generator Training"
aliases: ["GraspGen"]
date: 2025-07-17
category: "操作与其他"
source: "英伟达主导"
partners: []
authors: ["Adithyavairavan Murali", "Balakumar Sundaralingam", "Yu-Wei Chao", "Wentao Yuan", "Jun Yamada", "Mark Carlson", "Fabio Ramos", "Stan Birchfield", "Dieter Fox", "Clemens Eppner"]
arxiv: "2507.13097"
pdf: "[[nvidia/papers/20_2507.13097_GraspGen.pdf]]"
code: "https://github.com/NVlabs/GraspGen"
project: "https://graspgen.github.io"
huggingface: []
license: CC BY-SA 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# GraspGen: A Diffusion-based Framework for 6-DOF Grasping with On-Generator Training

> [!info] 论文信息
> arXiv [2507.13097](https://arxiv.org/abs/2507.13097) · v1 2025-07-17
> PDF：[[nvidia/papers/20_2507.13097_GraspGen.pdf|本地 PDF]]
> [代码](https://github.com/NVlabs/GraspGen) · [项目页](https://graspgen.github.io)
> 系列：物理AI · 操作与其他 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：GraspGen：基于扩散的 6-DoF 抓取生成框架，配合在生成器上训练的判别器，跨夹爪与场景泛化。
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

> Grasping is a fundamental robot skill, yet despite significant research advancements, learning-based 6-DOF grasping approaches are still not turnkey and struggle to generalize across different embodiments and in-the-wild settings. We build upon the recent success on modeling the object-centric grasp generation process as an iterative diffusion process. Our proposed framework, GraspGen, consists of a DiffusionTransformer architecture that enhances grasp generation, paired with an efficient discriminator to score and filter sampled grasps. We introduce a novel and performant on-generator training recipe for the discriminator. To scale GraspGen to both objects and grippers, we release a new simulated dataset consisting of over 53 million grasps. We demonstrate that GraspGen outperforms prior methods in simulations with singulated objects across different grippers, achieves state-of-the-art performance on the FetchBench grasping benchmark, and performs well on a real robot with noisy visual observations.
