---
id: "16"
org: 自变量
short: "IK-Hierarchical-Decision"
title: "Integrated Hierarchical Decision-Making in Inverse Kinematic Planning and Control"
aliases: ["IK-Hierarchical-Decision"]
date: 2024-12-02
category: 运动控制
source: 合作
partners: ["西交利物浦大学", "CNRS"]
authors: ["Kai Pfeiffer", "Quan Zhang", "Yuqing Chen", "Gordon Boateng", "Yuquan Wang", "Vincent Bonnet", "Abderrahmane Kheddar"]
arxiv: "2412.01324"
pdf: "[[xsquare/papers/16_RSS2026-p185_Integrated-Hierarchical-Decision-Making-IK.pdf]]"
code: ""
project: ""
huggingface: []
license: RSS 论文集版本
status: 未读
rating:
read_date:
tags: ["paper", "inverse-kinematics", "whole-body-control"]
---

# Integrated Hierarchical Decision-Making in Inverse Kinematic Planning and Control

> [!info] 论文信息
> arXiv [2412.01324](https://arxiv.org/abs/2412.01324) · v1 2024-12-02 · 最新 v5（2026-06-06）
> PDF：[[xsquare/papers/16_RSS2026-p185_Integrated-Hierarchical-Decision-Making-IK.pdf|本地 PDF]]
> [RSS 2026](https://doi.org/10.15607/rss.2026.xxii.185)
> 合作单位：西交利物浦大学、CNRS

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 分层决策与全身 IK 规划/控制一体化的框架：“This work presents a novel and efficient nonlinear programming framework that tightly integrates hierarchical decision-making with whole-body inverse kinematic planning and control.”（p.1）
> - 能处理的两类代表性问题：“such as inverse kinematic planning with simultaneous prioritized selection of end-effector locations from a large set of candidates, or inverse kinematic control with simultaneous selection of bi-manual grasp locations on a randomly rotated box.”（p.1）
> - 控制周期 1.5 ms vs PIQP 2.2 ms、MOSEK 8.3 ms：“For example, SHIK-C with selection among 100 possible locations on Unitree’s G1 robot is run at a control loop time of 1.5 ms, compared to 2.2 ms and 8.3 ms for PIQP and MOSEK, respectively”（p.2）
> - S-SHQP 37–67 次迭代；NLOPT 误差 3 mm–1.2 cm：“On the contrary, S-SHQP requires between 37 and 67 iterations for all samples. NLOPT finishes within 5 to 15 iterations, but manages to converge to a decision-making error of only 3 mm to 1.2 cm”（p.7）
> - G1 每个末端 200 个候选位置：“Each end-effector (LF, RF, LH, RH) is assigned 200 potential locations (Tab. 3), for example identified by exteroceptive sensors.”（p.7）
> - NQP 0.23 s 解完，H-PIQP 0.33 s：“The problem is solved in 0.23 s (89 S-SHQP iterations) by NQP. For comparison, H-PIQP converges in 90 iterations / 0.33 s”（p.8）
> - 100 次不同初始构型的鲁棒性测试：“Lastly, we conduct 100 simulations on G1 foot location planning with different initial configurations in order to test the robustness of our solver S-SHQP.”（p.8）
> - 其中 95 次成功：“The robot succeeds in 95 simulations with a DM error smaller than”（p.8）
> - ℓ0 形式接触 92/100 个物体，线性/最小二乘形式失败：“successfully interacts with 92 out of 100 objects before they pass beyond reach. If the fourth level is formulated as a linear or least-squares program”（p.9）
> - 计算量随稀疏约束数线性增长：“By exploiting the structure of the quadratic sub-problem SHQP, the proposed numerical scheme achieves linear computational scaling with respect to the number of sparse constraints.”（p.9）

## 一句话总结

用基于 ℓ0 范数的稀疏分层非线性规划，把离散选点决策直接融入全身逆运动学的规划与实时控制。

## 要解决什么问题

机器人逆运动学（IK）常伴随离散决策：用尽量少的关节完成运动，或在多个候选位置中选一个放置末端。现有做法要么用混合整数非线性规划（MINLP），计算代价高；要么把决策与 IK 分开、靠可达性近似，可能选到不可达的位置或过于保守；要么用 ℓ1 范数的线性稀疏规划，效率高但不够通用、精度有限，也没有处理底层的非线性问题。

## 方法

- 稀疏分层非线性规划（sparse hierarchical nonlinear programming, SH-NLP）：按优先级逐层最小化约束松弛量的 ℓ0 范数；同类“选择约束”组成一组，ℓ0 最小化只让组内一个约束得到满足，从而完成选择；ℓ0 用对数代理函数做连续近似（§III–IV）。
- 序列稀疏分层二次规划求解器（sequential sparse hierarchical quadratic programming, S-SHQP）：每次迭代解一个 SHQP 子问题，配合信赖域和分层步长滤波器（hierarchical step filter, HSF）；规划模式（SHIK-P）由滤波器决定是否接受步长，控制模式（SHIK-C）每步直接接受（§V，图 2）。
- 并行与分层决策：多个末端从同一候选集中选择时，用掩码改写权重来避免重复分配（double allocation）；组内有可行约束时优先把它加入活动集，避免不必要地切换到牛顿法而损害低优先级任务（§VI）。
- 专用内点求解器 NQP：借助定理 1 消去辅助变量，使每层退化为最小二乘问题，计算量随稀疏约束数线性增长（§VII）。
- 选择与全身 IK 同时求解，所选位置直接带有运动学可达性保证，不需要可达性近似；在 UFactory xarm6 和 Unitree G1 上验证（§I 贡献、§VIII）。

## 实验与关键数字

- 机械臂抓放规划（xarm6 从多个物体中选一个抓取）：S-SHQP 在所有样本上用 37 到 67 次迭代收敛；NLOPT 只需 5 到 15 次迭代，但决策误差有 3 mm 到 1.2 cm（§VIII-A、图 3）。
- 人形机器人规划（G1）：每个末端各有 200 个候选位置，NQP 用 0.23 s（89 次 S-SHQP 迭代）解完，H-PIQP 需 90 次迭代、0.33 s（§VIII-C）；表 3 标题给出的时间和迭代数与正文不一致，需核对。
- 鲁棒性：做了 100 次不同初始构型的 G1 足部位置规划仿真，成功 95 次，失败归因于求解器的局部性（§VIII-C、图 6）。
- 人形机器人实时控制（SHIK-C）：右手从 100 个下落物体中持续选目标，用 ℓ0 形式时成功接触 92 个，改成线性或最小二乘（ℓ1/ℓ2）形式则一个也接触不到（§VIII-E）。
- 速度：在 100 个候选位置中选择时，G1 的控制周期为 1.5 ms，PIQP 和 MOSEK 分别为 2.2 ms 和 8.3 ms（§I；§VIII-E 正文给出的计时与引言略有出入）；计算时间随稀疏约束数线性增长（§VIII-C 图 4、§IX）。

## 局限 / 存疑

## 与其他论文的关系

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 10 条

> This work presents a novel and efficient nonlinear programming framework that tightly integrates hierarchical decision-making with whole-body inverse kinematic planning and control.
> 批注：Claude：分层决策与全身 IK 规划/控制一体化的框架
> — [[xsquare/papers/16_RSS2026-p185_Integrated-Hierarchical-Decision-Making-IK.pdf#page=1|p.1]]

> such as inverse kinematic planning with simultaneous prioritized selection of end-effector locations from a large set of candidates, or inverse kinematic control with simultaneous selection of bi-manual grasp locations on a randomly rotated box.
> 批注：Claude：能处理的两类代表性问题
> — [[xsquare/papers/16_RSS2026-p185_Integrated-Hierarchical-Decision-Making-IK.pdf#page=1|p.1]]

> For example, SHIK-C with selection among 100 possible locations on Unitree’s G1 robot is run at a control loop time of 1.5 ms, compared to 2.2 ms and 8.3ms for PIQP and MOSEK, respectively
> 批注：Claude：控制周期 1.5 ms vs PIQP 2.2 ms、MOSEK 8.3 ms
> — [[xsquare/papers/16_RSS2026-p185_Integrated-Hierarchical-Decision-Making-IK.pdf#page=2|p.2]]

> On the contrary, S-SHQP requires between 37 and 67 iterations for all samples. NLOPT finishes within 5 to 15 iterations, but manages to converge to a decision-making error of only 3mm to 1.2cm
> 批注：Claude：S-SHQP 37–67 次迭代；NLOPT 误差 3 mm–1.2 cm
> — [[xsquare/papers/16_RSS2026-p185_Integrated-Hierarchical-Decision-Making-IK.pdf#page=7|p.7]]

> Each end-effector (LF, RF, LH, RH) is assigned 200 potential locations (Tab. 3), for example identified by exteroceptive sensors.
> 批注：Claude：G1 每个末端 200 个候选位置
> — [[xsquare/papers/16_RSS2026-p185_Integrated-Hierarchical-Decision-Making-IK.pdf#page=7|p.7]]

> Lastly, we conduct 100 simulations on G1 foot location planning with different initial configurations in order to test the robustness of our solver S-SHQP.
> 批注：Claude：100 次不同初始构型的鲁棒性测试
> — [[xsquare/papers/16_RSS2026-p185_Integrated-Hierarchical-Decision-Making-IK.pdf#page=8|p.8]]

> The robot succeeds in 95 simulations with a DM error smaller than
> 批注：Claude：其中 95 次成功
> — [[xsquare/papers/16_RSS2026-p185_Integrated-Hierarchical-Decision-Making-IK.pdf#page=8|p.8]]

> The problem is solved in 0.23 s (89 S-SHQP iterations) by NQP. For comparison, H-PIQP converges in 90 iterations / 0.33 s
> 批注：Claude：NQP 0.23 s 解完，H-PIQP 0.33 s
> — [[xsquare/papers/16_RSS2026-p185_Integrated-Hierarchical-Decision-Making-IK.pdf#page=8|p.8]]

> By exploiting the structure of the quadratic sub-problem SHQP, the proposed numerical scheme achieves linear computational scaling with respect to the number of sparse constraints.
> 批注：Claude：计算量随稀疏约束数线性增长
> — [[xsquare/papers/16_RSS2026-p185_Integrated-Hierarchical-Decision-Making-IK.pdf#page=9|p.9]]

> successfully interacts with 92 out of 100 objects before they pass beyond reach. If the fourth level is formulated as a linear or least-squares program
> 批注：Claude：ℓ0 形式接触 92/100 个物体，线性/最小二乘形式失败
> — [[xsquare/papers/16_RSS2026-p185_Integrated-Hierarchical-Decision-Making-IK.pdf#page=9|p.9]]
<!-- highlights:end -->

## 摘要（中文）

本文提出一种新颖、高效的非线性规划框架，把分层决策与全身逆运动学的规划和控制紧密结合起来。决策在机器人学的许多方面都扮演核心角色：从用尽量少的关节实现的稀疏逆运动学控制，到在逆运动学规划的同时从多个候选中选出一个离散的末端执行器位置。现有方法往往依赖计算量很大的混合整数非线性规划，或者把决策与逆运动学分开处理（有时用可达性方法来近似），或者采用高效但通用性较差的 ℓ1 范数线性稀疏规划，而没有处理底层的非线性问题。

相比之下，本文提出的稀疏分层非线性规划求解器利用稀疏的分层结构，并借助在机器人学中很少使用的 ℓ0 范数，做到高效、通用且精确。该求解器能高效处理以往文献未曾解决的复杂非线性分层决策问题，例如：在逆运动学规划中同时从大量候选中按优先级选择末端执行器位置，或者在逆运动学控制中同时为一个随机旋转的箱子选择双臂抓取位置。

## 摘要（原文）

> This work presents a novel and efficient nonlinear programming framework that tightly integrates hierarchical decision-making with whole-body inverse kinematic planning and control. Decision-making plays a central role in many aspects of robotics, from sparse inverse kinematic control with a minimal number of joints, to inverse kinematic planning while simultaneously selecting a discrete end-effector location from multiple candidates. Current approaches often rely on heavy computations using mixed-integer nonlinear programming, separate decision-making from inverse kinematics (some times approximated by reachability methods), or employ efficient but less versatile $\ell_1$-norm formulations of linear sparse programming, without addressing the underlying nonlinear problem formulations. In contrast, the proposed sparse hierarchical nonlinear programming solver is efficient, versatile, and accurate by exploiting sparse hierarchical structure and leveraging the $\ell_0$-norm which is rarely used in robotics. The solver efficiently tackles complex nonlinear hierarchical decision-making problems previously unaddressed in the literature, such as inverse kinematic planning with simultaneous prioritized selection of end-effector locations from a large set of candidates, or inverse kinematic control with simultaneous selection of bi-manual grasp locations on a randomly rotated box.
