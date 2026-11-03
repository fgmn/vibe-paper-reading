---
id: "23"
org: 自变量
short: "EgoJEPA"
title: "EgoJEPA: Beyond Retargeting for Dexterous Manipulation from Egocentric Videos"
aliases: ["EgoJEPA"]
date: 2026-10-14
category: 技能学习
source: 合作
partners: ["MBZUAI", "上海交通大学", "Xense Robotics"]
authors: ["Meng Cao", "Can Zhao", "Jinjie Wei", "Haonan Zhao", "Yulong Zhang", "Duo Han", "Xiaofan Li", "Ziwu Song", "Rongtao Xu", "Ruyi Gan", "Hao Wang", "Qian Wang", "Daolin Ma", "Ian Reid", "Xiaodan Liang"]
arxiv: "2610.20904"
pdf: "[[xsquare/papers/23_2610.20904_EgoJEPA.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY-NC-ND 4.0
status: 未读
rating:
read_date:
tags: ["paper", "egocentric-video", "dexterous", "jepa"]
---

# EgoJEPA: Beyond Retargeting for Dexterous Manipulation from Egocentric Videos

> [!info] 论文信息
> arXiv [2610.20904](https://arxiv.org/abs/2610.20904) · v1 2026-10-14
> PDF：[[xsquare/papers/23_2610.20904_EgoJEPA.pdf|本地 PDF]]
> 合作单位：MBZUAI、上海交通大学、Xense Robotics

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 阶段 1：以手部运动差为条件的 JEPA 式预测：“Human-action pre-training learns effect-aware latent actions through JEPA-style visual prediction conditioned on hand-motion differences”（Abstract）
> - 阶段 2：联合预测视觉动态与潜在动作：“Latent-action-based world modeling jointly predicts future visual dynamics and latent actions, which decouples human prior pre-training from robot-specific control parameterizations”（Abstract）
> - 评测规模：五个任务、三种本体：“Experiments on five real-world manipulation tasks across three robot embodiments demonstrate the effectiveness and efficiency of EgoJEPA.”（Abstract）
> - 域外 74% vs 65%，成本降低 47.2%：“It achieves a 74% average success rate under the out-of-domain evaluation, compared with 65% for the retargeting baseline, while reducing cumulative cross-embodiment wall-clock cost by 47.2%, from 743.2 to 392.7 hours.”（Abstract）
> - 人类预训练数据规模：“The dataset contains 1,111,943 episodes from 62,518 recording sessions, amounting to approximately 20,106.6 hours and 2.17 billion video frames.”（§4.1）
> - 域内/域外平均成功率及相对重定向的提升：“EgoJEPA attains the highest success rate on all five tasks, with average success rates of 94% and 74% under in- and out-of-domain settings, respectively, surpassing the retargeting pipeline by 14% and 9% absolute margins.”（§4.2）
> - 人类预训练的作用：40% 到 74%：“human pre-training increases the average out-of-domain success rate from 40% to 74%, with improvements across all five tasks”（§4.3）
> - JEPA 优于 VQ-VAE：63% 到 74%：“EgoJEPA increases the average out-of-domain success rate from 63% to 74%, with gains across all five tasks”（§4.3）
> - 数据效率：10% 示范即达 35%：“with only 10% of the demonstrations, EgoJEPA achieves a 35% success rate, surpassing the 30% attained by the robot-only model trained on the full dataset (100%).”（§4.3）
> - 抗位置噪声：70% 到 60% vs 60% 到 30%：“EgoJEPA experiences a modest 10% success-rate drop (70% to 60%), whereas retargeting suffers a drastic 30% decline (60% to 30%).”（§4.3）

## 一句话总结

EgoJEPA 绕开人手到机器人的规则重定向，从第一视角人类视频学习与本体无关的潜在动作，再用轻量适配器迁移到不同机器人。

## 要解决什么问题

第一视角人类视频是昂贵机器人示范的可扩展替代，但其中的操作先验很难迁移到机器人控制。常用的重定向方法用手工几何映射把手腕和手指位姿转成特定本体的动作：每换一种本体都要重新标定和预训练，手部跟踪误差也会直接传进机器人控制。另一类不用动作标注、从帧间变化学潜在动作的方法，学到的可能是与动作无关的视觉变化。

## 方法

- 第一视角版本的联合嵌入预测架构（Joint Embedding Predictive Architecture, JEPA），分三阶段（§3，图 2）：
  1. 人类动作预训练（Human-action pre-training，§3.1）：把相邻帧手部标注（关键点、MANO 参数等）之差定义为“人类动作”，以它为条件，由视觉上下文预测未来帧的目标表征（EMA 目标编码器 + stop-gradient），学到效果感知的潜在动作（effect-aware latent actions）；
  2. 基于潜在动作的世界建模（Latent-action-based world modeling，§3.2）：用联合流匹配（joint flow matching）同时预测未来视觉动态和由阶段 1 冻结动作编码器给出的潜在动作，不依赖重定向得到的机器人坐标动作；
  3. 本体特定微调（Embodiment-specific tuning，§3.3）：在世界-动作模型的动作分支插入轻量的输入/输出适配器，把机器人 delta 动作映射进共享潜在动作空间。
- 阶段 1–2 与本体无关，可在不同机器人间复用；换机器人只需重做阶段 3（§1、§4.3）。
- 实现（§4.1，附录 A.2、表 A3）：阶段 1 的视觉编码器由 Wan2.2 VAE 编码器初始化，阶段 2 的视频 Transformer 由 Wan2.2-TI2V-5B 初始化，适配器是两层 MLP。

## 实验与关键数字

- 设置（§4.1）：人类预训练数据为商业采购的第一视角数据集，含 1,111,943 个 episode、约 20,106.6 小时；在三种机器人本体（Sharpa 灵巧手、Wuji 灵巧手、Xense Tac UMI 夹爪）上评测五个真实任务，分域内和域外（物体变化、空间位置变化）两种设置；对比 LAPA、DexWild、重定向流水线和两个自身变体。
- 主结果（§4.2 图 3）：五个任务成功率都最高，域内/域外平均 94% / 74%，比重定向流水线分别高 14% / 9%（绝对值）；摘要中域外对比为 74% vs 65%。
- 消融（§4.3）：去掉阶段 1–2 的人类预训练（Robot-only），域外平均从 74% 降到 40%；阶段 1 改用 VQ-VAE 重建，从 74% 降到 63%。拧瓶盖任务只用 10% 机器人示范即达 35%，高于用全量数据训练的 Robot-only（30%）。
- 抗标注噪声（§4.3 图 6）：在最大位置噪声下，EgoJEPA 成功率从 70% 降到 60%，重定向从 60% 降到 30%。
- 跨本体成本（§4.3 图 7）：累计墙钟时间从 743.2 小时降到 392.7 小时，减少 47.2%。

## 局限 / 存疑

## 与其他论文的关系

- §1 讨论机器人示范依赖遥操作或专用采集系统时引用了 [[15_ManipArena]] 和 [[04_WALL-SS]]（背景引用）
- 同样从人类数据学习机器人操作（本文未引用）：[[09_HOST]]（单段人类视频、推理期习得技能）、[[08_XRZero-G0]]（免机器人穿戴式采集）

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 10 条

> Human- action pre-training learns effect-aware latent actions through JEPA-style visual prediction conditioned on hand-motion differences
> 批注：Claude：阶段 1：以手部运动差为条件的 JEPA 式预测
> — [[xsquare/papers/23_2610.20904_EgoJEPA.pdf#page=1|p.1]]

> Latent-action-based world modeling jointly predicts future visual dynamics and latent actions, which decou- ples human prior pre-training from robot-specific control parameterizations
> 批注：Claude：阶段 2：联合预测视觉动态与潜在动作
> — [[xsquare/papers/23_2610.20904_EgoJEPA.pdf#page=1|p.1]]

> Experiments on five real-world manipulation tasks across three robot embodiments demonstrate the effectiveness and efficiency of EgoJEPA.
> 批注：Claude：评测规模：五个任务、三种本体
> — [[xsquare/papers/23_2610.20904_EgoJEPA.pdf#page=1|p.1]]

> It achieves a 74% average success rate under the out-of-domain evalu- ation, compared with 65% for the retargeting baseline, while reducing cumulative cross-embodiment wall-clock cost by 47.2%, from 743.2 to 392.7 hours.
> 批注：Claude：域外 74% vs 65%，成本降低 47.2%
> — [[xsquare/papers/23_2610.20904_EgoJEPA.pdf#page=1|p.1]]

> The dataset contains 1,111,943 episodes from 62,518 recording sessions, amounting to ap- proximately 20,106.6 hours and 2.17 billion video frames.
> 批注：Claude：人类预训练数据规模
> — [[xsquare/papers/23_2610.20904_EgoJEPA.pdf#page=5|p.5]]

> EgoJEPA attains the highest success rate on all five tasks, with average success rates of 94% and 74% under in- and out-of-domain settings, respectively, sur- passing the retargeting pipeline by 14% and 9% absolute margins.
> 批注：Claude：域内/域外平均成功率及相对重定向的提升
> — [[xsquare/papers/23_2610.20904_EgoJEPA.pdf#page=6|p.6]]

> human pre-training increases the average out- of-domain success rate from 40% to 74%, with improvements across all five tasks
> 批注：Claude：人类预训练的作用：40% 到 74%
> — [[xsquare/papers/23_2610.20904_EgoJEPA.pdf#page=7|p.7]]

> EgoJEPA increases the average out-of-domain success rate from 63% to 74%, with gains across all five tasks
> 批注：Claude：JEPA 优于 VQ-VAE：63% 到 74%
> — [[xsquare/papers/23_2610.20904_EgoJEPA.pdf#page=8|p.8]]

> with only 10% of the demonstrations, EgoJEPA achieves a 35% success rate, surpassing the 30% attained by the robot-only model trained on the full dataset (100%).
> 批注：Claude：数据效率：10% 示范即达 35%
> — [[xsquare/papers/23_2610.20904_EgoJEPA.pdf#page=8|p.8]]

> EgoJEPA experiences a modest 10% success-rate drop (70% to 60%), whereas re- targeting suffers a drastic 30% decline (60% to 30%).
> 批注：Claude：抗位置噪声：70% 到 60% vs 60% 到 30%
> — [[xsquare/papers/23_2610.20904_EgoJEPA.pdf#page=9|p.9]]
<!-- highlights:end -->

## 摘要（中文）

第一视角人类视频为昂贵的机器人示范提供了可扩展的替代来源，但把其中的操作先验迁移到机器人控制上仍然困难。常用的基于重定向的方法，通过手工设计的几何映射把人的手腕和手指位姿转换为特定本体的动作指令。然而，这类映射在不同本体之间需要细致的重新标定，并且可能把手部跟踪误差传播到下游的机器人控制流程中。

为此，我们提出 EgoJEPA，一个无需基于规则的人到机器人重定向、即可从第一视角人类视频中学习与本体无关表示的三阶段框架：1）人类动作预训练：以手部运动差为条件，通过 JEPA 式视觉预测学习效果感知的潜在动作；2）基于潜在动作的世界建模：联合预测未来视觉动态与潜在动作，把人类先验的预训练与特定机器人的控制参数化解耦；3）本体特定微调：通过轻量的动作适配器，把预训练模型适配到不同机器人上。

在三种机器人本体、五个真实世界操作任务上的实验验证了 EgoJEPA 的有效性和效率。在域外评测中，它取得 74% 的平均成功率，重定向基线为 65%；同时把跨本体的累计墙钟成本降低 47.2%，从 743.2 小时降到 392.7 小时。

## 摘要（原文）

> Egocentric human videos offer a scalable alternative to costly robot demonstra- tions, yet transferring their manipulation priors to robot control remains chal- lenging. The commonly adopted retargeting-based approaches convert human wrist and finger poses into embodiment-specific action commands through hand- crafted geometric mappings. However, such mappings require meticulous recal- ibration across different embodiments and risk propagating hand-tracking errors into downstream robot control pipelines. To this end, we propose EgoJEPA, a three-stage framework that learns embodiment-agnostic representations from ego- centric human videos without rule-based human-to-robot retargeting: 1) Human- action pre-training learns effect-aware latent actions through JEPA-style visual prediction conditioned on hand-motion differences; 2) Latent-action-based world modeling jointly predicts future visual dynamics and latent actions, which decou- ples human prior pre-training from robot-specific control parameterizations; 3) Embodiment-specific tuning adapts the pretrained model to diverse robots through lightweight action adapters. Experiments on five real-world manipulation tasks across three robot embodiments demonstrate the effectiveness and efficiency of EgoJEPA. It achieves a 74% average success rate under the out-of-domain evalu- ation, compared with 65% for the retargeting baseline, while reducing cumulative cross-embodiment wall-clock cost by 47.2%, from 743.2 to 392.7 hours.
