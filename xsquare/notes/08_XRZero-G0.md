---
id: "08"
org: 自变量
short: "XRZero-G0"
title: "XRZero-G0: Pushing the Frontier of Dexterous Robotic Manipulation with Interfaces, Quality and Ratios"
aliases: ["XRZero-G0"]
date: 2026-04-14
category: 数据采集
source: 自变量主导
partners: []
authors: ["James Wang", "Primo Pu", "Zephyr Fung", "Alex Wang", "Sam Wang", "Bender Deng", "Kevin Wang", "Zivid Liu", "Chris Pan", "Panda Yang", "Andy Zhai", "Lucy Liang", "Shalfun Li", "Johnny Sun", "Jacky Xu", "Will Tian", "Kai Yan", "Kohler Ye", "Scott Li", "Qian Wang", "Roy Gan", "Hao Wang"]
arxiv: "2604.13001"
pdf: "[[xsquare/papers/08_2604.13001_XRZero-G0.pdf]]"
code: "https://github.com/X-Square-Robot/XRZero-G0"
project: "https://x2robot.com/x2go"
huggingface: ["https://huggingface.co/datasets/x-square-robot/XRZero-G0-3K"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "data-collection", "dexterous", "dataset"]
---

# XRZero-G0: Pushing the Frontier of Dexterous Robotic Manipulation with Interfaces, Quality and Ratios

> [!info] 论文信息
> arXiv [2604.13001](https://arxiv.org/abs/2604.13001) · v1 2026-04-14 · 最新 v2（2026-04-16）
> PDF：[[xsquare/papers/08_2604.13001_XRZero-G0.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/XRZero-G0) · [项目页](https://x2robot.com/x2go) · [XRZero-G0-3K](https://huggingface.co/datasets/x-square-robot/XRZero-G0-3K)

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 闭环采集-检查-训练-评估流水线：“we propose a closed-loop collection, inspection, training, and evaluation pipeline for non-proprioceptive data”（Abstract）
> - 数据有效率最高 85%：“Through this rigorous verification pipeline, the framework achieves a data validity rate of up to 85%, establishing a robust foundation for downstream policy learning.”（§3.2）
> - G0-Dataset 规模：2,000 小时、3,000 任务：“human operators collected over 2,000 hours of high-fidelity, multi-modal demonstration data. The dataset spans 3,000 distinct manipulation tasks”（§4.1）
> - 相比主从遥操作的完成时间：“the proposed system reduces the average completion time from 35s to 15s for simple tasks, from 75s to 40s for medium tasks, and from 120s to 70s for hard tasks”（§5.2）
> - 纯免机器人数据：2,000 episode 下 70%：“At 2,000 pure robot-free episodes, Wall-OSS achieves a 70% success rate at”（§5.3）
> - 未见高度下仍 60%：“and maintains a 60% success rate at the unseen”（§5.3）
> - 1:1 增广：插花入瓶 50% 到 75%：“In the precision-demanding Inserting Flower into Vase task, the Wall-OSS success rate increases from 50% (pure teleoperation) to 75% (1:1 mixed regime).”（§5.4）
> - 10:1 的数据构成：“Cost-Substitution (10:1) (500 robot-free + 50 real-robot) maintains a comparable total dataset volume while matching baseline performance.”（Figure 7 caption）
> - 10:1 叠毛巾 87.5%，与 500 条真机相同：“in the Folding Towel task, Wall-OSS achieves an 87.5% success rate under the 10:1 regime, identical to the performance yielded by 500 pure real-robot episodes”（§5.4）
> - 10:1 可比纯真机且成本降到二十分之一：“combining a minimal volume of real-robot data with large-scale robot-free data (e.g., a 10:1 ratio) achieves performance comparable to exclusively real-robot datasets, while reducing acquisition costs by a factor of twenty”（Abstract）

## 一句话总结

XRZero-G0 是软硬件协同的免机器人数据采集系统：VR 穿戴式采集加闭环质检，再用少量真机数据锚定大量免机器人数据来训练策略。

## 要解决什么问题

灵巧操作基础模型缺少高质量、动作对齐的示范数据。UMI 一类的免机器人采集虽然可扩展，但有三方面瓶颈：接口上依赖手持视觉 SLAM，在弱纹理或动态环境中容易漂移；数据处理是开环的，缺少自动质检；也缺少如何混合廉价免机器人数据与昂贵真机数据的系统经验。

## 方法

- 接口（Interfaces，§3.1）：背包式穿戴装置。PICO 4 VR 头显提供 inside-out 的 6-DoF 跟踪和第一视角相机，再加双腕相机；两种自制夹爪（按压式 H 形用于快速抓取，手指驱动的 G 形用于精细操作）刚性固定在 VR 手柄上，两夹爪间距校准到与真机双臂一致。
- 质量（Quality，§3.2）：“采集-检查-训练-评估”（Collection-Inspection-Training-Evaluation）闭环流水线：
  1. 过滤模糊帧、下采样静止帧；
  2. 按目标本体的 URDF 做运动学重定向，并用 IK 剔除越关节限位、奇异或自碰撞的片段；
  3. 每类任务抽样轨迹在目标双臂机器人上开环回放验证；
  4. 切分子任务并做语义标注。
- 配比（Ratios，§3.3）：大量免机器人数据用于预训练，构建通用表征；少量真机数据作为运动学锚点做微调，作者称之为少样本物理锚定（Few-Shot Physical Anchoring）。
- 输出与模型无关的数据格式，可用于 VLA 和世界动作模型（WAM）两类策略（§3.4）；实验的基座策略是 Wall-OSS、π0、π0.5（§5.1）。

## 实验与关键数字

- 数据集（§4.1）：G0-Dataset 超过 2,000 小时、覆盖 3,000 个操作任务；闭环质检后数据有效率最高 85%（§3.2）。
- 采集效率（§5.2）：相比主从遥操作，简单/中等/困难任务的平均完成时间分别从 35s 降到 15s、75s 降到 40s、120s 降到 70s。
- 纯免机器人数据（§5.3）：长时程双臂插花任务用 2,000 个免机器人 episode 训练，Wall-OSS 成功率达 70%，在未见过的另一工作高度下仍有 60%。
- 数据配比（§5.4）：以 500 条遥操作数据为基线。1:1 增广（再加 500 条免机器人数据）让 Wall-OSS 在插花入瓶任务的成功率从 50% 升到 75%；10:1 替代（500 条免机器人 + 50 条真机）在叠毛巾任务上达到 87.5%，与 500 条纯真机数据相同。免机器人数据的采集成本约为遥操作的二十分之一。

## 局限 / 存疑

## 与其他论文的关系

- 以 [[01_WALL-OSS]] 为三个基座策略之一（§5.1），纯免机器人数据和配比实验的主要数字都来自 Wall-OSS
- 同样用人类侧数据替代昂贵的机器人示范：[[23_EgoJEPA]]（第一视角人类视频、免重定向；两文未互相引用）

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 10 条

> we propose a closed-loop collection, inspection, training, and evaluation pipeline for non-proprioceptive data
> 批注：Claude：闭环采集-检查-训练-评估流水线
> — [[xsquare/papers/08_2604.13001_XRZero-G0.pdf#page=1|p.1]]

> combining a minimal volume of real-robot data with large-scale robot-free data (e.g., a 10:1 ratio) achieves performance comparable to exclusively real-robot datasets, while reducing acquisition costs by a factor of twenty
> 批注：Claude：10:1 可比纯真机且成本降到二十分之一
> — [[xsquare/papers/08_2604.13001_XRZero-G0.pdf#page=1|p.1]]

> Through this rigorous verification pipeline, the framework achieves a data validity rate of up to 85%, establishing a robust foundation for downstream policy learning.
> 批注：Claude：数据有效率最高 85%
> — [[xsquare/papers/08_2604.13001_XRZero-G0.pdf#page=6|p.6]]

> human operators collected over 2,000 hours of high-fidelity, multi-modal demonstration data. The dataset spans 3,000 distinct manipulation tasks
> 批注：Claude：G0-Dataset 规模：2,000 小时、3,000 任务
> — [[xsquare/papers/08_2604.13001_XRZero-G0.pdf#page=7|p.7]]

> the proposed system reduces the average completion time from 35s to 15s for simple tasks, from 75s to 40s for medium tasks, and from 120s to 70s for hard tasks
> 批注：Claude：相比主从遥操作的完成时间
> — [[xsquare/papers/08_2604.13001_XRZero-G0.pdf#page=9|p.9]]

> At 2,000 pure robot-free episodes, Wall-OSS achieves a 70% success rate at
> 批注：Claude：纯免机器人数据：2,000 episode 下 70%
> — [[xsquare/papers/08_2604.13001_XRZero-G0.pdf#page=10|p.10]]

> and maintains a 60% success rate at the unseen
> 批注：Claude：未见高度下仍 60%
> — [[xsquare/papers/08_2604.13001_XRZero-G0.pdf#page=10|p.10]]

> In the precision-demanding Inserting Flower into Vase task, the Wall-OSS success rate increases from 50% (pure teleoperation) to 75% (1:1 mixed regime).
> 批注：Claude：1:1 增广：插花入瓶 50% 到 75%
> — [[xsquare/papers/08_2604.13001_XRZero-G0.pdf#page=10|p.10]]

> Cost-Substitution (10:1) (500 robot-free + 50 real-robot) maintains a comparable total dataset volume while matching baseline performance.
> 批注：Claude：10:1 的数据构成
> — [[xsquare/papers/08_2604.13001_XRZero-G0.pdf#page=11|p.11]]

> in the Folding Towel task, Wall-OSS achieves an 87.5% success rate under the 10:1 regime, identical to the performance yielded by 500 pure real-robot episodes
> 批注：Claude：10:1 叠毛巾 87.5%，与 500 条真机相同
> — [[xsquare/papers/08_2604.13001_XRZero-G0.pdf#page=12|p.12]]
<!-- highlights:end -->

## 摘要（中文）

获取高质量、动作对齐的示范数据，仍是扩展灵巧机器人操作基础模型的根本瓶颈。免机器人的人类示范（例如 UMI 范式）为传统遥操作提供了可扩展的替代方案，但现有系统受限于欠佳的硬件人体工学、开环的工作流程，以及缺乏系统性的数据混合策略。

为解决这些局限，我们提出 XRZero-G0，一个面向具身数据采集和策略学习的软硬件协同系统。该系统采用符合人体工学的虚拟现实（VR）接口，配备俯视相机和两种专用夹爪，直接提升采集效率。为保证数据集的可靠性，我们为非本体感知数据提出了“采集—检查—训练—评估”的闭环流水线。这一流程达到 85% 的数据有效率，并建立了透明的质量控制机制。

此外，我们研究了免机器人数据的经验扩展规律和最优混合比例。大量实验表明，把少量真机数据与大规模免机器人数据结合（例如 10:1 的比例），可以达到与纯真机数据集相当的性能，同时把采集成本降到二十分之一。我们利用 XRZero-G0 构建了一个 2,000 小时的免机器人数据集，可零样本跨本体迁移到目标实体机器人，展示了一种面向通用真实世界操作、高度可扩展的方法。

## 摘要（原文）

> The acquisition of high-quality, action-aligned demonstration data remains a fundamental bottleneck in scaling foundation models for dexterous robot manipulation. Although robot-free human demonstrations (e.g., the UMI paradigm) offer a scalable alternative to traditional teleoperation, current systems are constrained by sub-optimal hardware ergonomics, open-loop workflows, and a lack of systematic data-mixing strategies. To address these limitations, we present XRZero-G0, a hardware-software co-designed system for embodied data collection and policy learning. The system features an ergonomic, virtual reality interface equipped with a top-view camera and dual specialized grippers to directly improve collection efficiency. To ensure dataset reliability, we propose a closed-loop collection, inspection, training, and evaluation pipeline for non-proprioceptive data. This workflow achieves an 85% data validity rate and establishes a transparent mechanism for quality control. Furthermore, we investigate the empirical scaling behaviors and optimal mixing ratios of robot-free data. Extensive experiments indicate that combining a minimal volume of real-robot data with large-scale robot-free data (e.g., a 10:1 ratio) achieves performance comparable to exclusively real-robot datasets, while reducing acquisition costs by a factor of twenty. Utilizing XRZero-G0, we construct a 2,000-hour robot-free dataset that enables zero-shot cross-embodiment transfer to a target physical robot, demonstrating a highly scalable methodology for generalized real-world this http URL project repository: this https URL
