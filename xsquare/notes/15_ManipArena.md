---
id: "15"
org: 自变量
short: "ManipArena"
title: "ManipArena: Comprehensive Real-world Evaluation of Reasoning-Oriented Generalist Robot Manipulation"
aliases: ["ManipArena"]
date: 2026-03-30
category: 评测基准
source: 合作
partners: ["中山大学", "MBZUAI", "清华大学"]
authors: ["Yu Sun", "Meng Cao", "Yang Ping", "Kaidong Zhang", "Qingxuan Chen", "Rongtao Xu", "Liangwang Ruan", "Xuecheng Chen", "Dongxiu Liu", "Yunxiao Yan", "Zunnan Xu", "Runze Xu", "Charles Yang", "Peilun Zhang", "Xiaofan Li", "Ruyi Gan", "Liang Ma", "Yuehao Yin", "Jincheng Yu", "Lufang Chen", "Yuxin Liang", "Peng Zhai", "Hao Wang", "Ivan Laptev", "Ian Reid", "Qian Wang", "Xiaodan Liang"]
arxiv: "2603.28545"
pdf: "[[xsquare/papers/15_2603.28545_ManipArena.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY-NC-SA 4.0
status: 未读
rating:
read_date:
tags: ["paper", "benchmark", "real-robot"]
---

# ManipArena: Comprehensive Real-world Evaluation of Reasoning-Oriented Generalist Robot Manipulation

> [!info] 论文信息
> arXiv [2603.28545](https://arxiv.org/abs/2603.28545) · v1 2026-03-30 · 最新 v2（2026-07-01）
> PDF：[[xsquare/papers/15_2603.28545_ManipArena.pdf|本地 PDF]]
> 合作单位：中山大学、MBZUAI、清华大学

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 20 个任务、10,812 条轨迹、约 188 小时：“Specifically, ManipArena comprises 20 real-robot tasks, 10,812 trajectories, and approximately 188 hours of demonstrations.”（§1）
> - 15 个桌面任务、5 个移动任务：“The benchmark includes 15 tabletop tasks and 5 mobile-manipulation tasks.”（§1）
> - 10 次试验的分层评测协议：“Trials 1–4 sample in-domain configurations, trials 5–8 introduce controlled visual or configuration shifts, and trials 9–10 use the strongest held-out condition available for the task”（§3.3）
> - 每次试验 10 分的分步计分：“Each trial is worth 10 points, distributed over stages such as grasping, transport, alignment, insertion, pouring, semantic selection, and final retraction”（§3.4）
> - 七种配置；结论受模型来源、数据等影响：“Using ManipArena, we evaluate seven tabletop configurations spanning VLA and world-action-model policies. The results show that real-robot conclusions depend not only on architecture, but also on model provenance, fine-tuning regime, data sampling, and annotation granularity.”（Abstract）
> - 最佳总分 951/1500（63.4%）：“The best aggregate tabletop score (WALL-OSS-0.5-Specialist) reaches 951/1500 (63.4%), and no policy consistently dominates across tasks.”（§1）
> - 200/task 优于全量数据：“The 200/task recipe obtains the best five-task score (312/500, 42% SR), exceeding the full-data 60k recipe (277/500, 34% SR) and the full-data 120k control (248/500, 26% SR).”（§4.1）
> - L2/L3 标注的效果：“L2 raises total score from 703 to 867 and SR from 20% to 32.7%, while L3 obtains the highest SR (35.3%) and strongest semantic score (370/500).”（§4.2）
> - 统一训练使 WALL-OSS-0.5 下降 86.0 分：“but reduces WALL-OSS-0.5 by 86.0 points. Per-task results in Appendix E show that these shifts are competence redistributions rather than uniform gains or losses.”（§4.3）
> - 仿真只作为筛查工具：“We therefore treat simulation as a screening instrument, not a substitute benchmark: simulated gains require physical validation before being interpreted as real-robot capability gains.”（§4.5）

## 一句话总结

标准化真机评测框架：20 个任务、10,812 条轨迹，用分层试次和分步计分诊断 VLA 与世界动作模型的泛化。

## 要解决什么问题

VLA 和世界动作模型（WAM）的进展受限于缺少既贴近物理现实、又能受控诊断的评测协议。仿真基准规模大、可复现，但刻画不了感知噪声、接触动力学、延迟、标定误差等现实差距；真机评测则在平台、场景、物体和计分规则上各自为政，难以公平比较，也难以把表现归因到架构、数据还是任务设计。

## 方法

- 受控物理环境：固定底座的双臂桌面平台和带升降柱、全向底盘的移动平台，都在固定光照、相机位置和工作区几何的绿幕棚内运行，并公开电机电流、关节速度等底层信号（§3.1，附录 J）。
- 任务模式（task schema）驱动的设计：每个任务声明阶段、物体与布局变量、干扰物条件，以及留给评测的留出条件；训练和评测从同一任务空间的不同声明区域采样，使重叠与留出变化都是显式的（§3.2，附录 K）。
- 分层真机评测（stratified real-robot evaluation）：每个桌面任务固定 10 次试验，依次为域内、视觉/配置偏移和最强的留出条件（§3.3，OOD 设置的逐任务审计见附录 N）。
- 分步计分（partial-credit scoring）：每次试验 10 分，按抓取、搬运、对齐、放置、收回等子目标分配，不少于 9 分才算成功，从而定位失败发生在哪一阶段（§3.4，附录 L）。
- 三级语言标注：L1 为任务级指令，L2 加入本回合的物体和空间信息，L3 再加上生成的场景描述，把语言粒度当作可控的训练变量；另有少数桌面任务配有由物理场景重建的配对仿真环境（§3.5，附录 H）。

## 实验与关键数字

- 规模：20 个真机任务（15 个桌面、5 个移动）、10,812 条轨迹、约 188 小时示范（§1、§3.1）。
- 模型对比：评测七种桌面配置（π0.5 与 WALL-OSS-0.5 的单任务/统一多任务版本，以及 X-VLA、DreamZero、Fast-WAM；表 5 中另列有 Wall-WM）；最佳为 WALL-OSS-0.5 单任务专家，951/1500（63.4%），且没有策略在所有任务上占优，基准远未饱和（§1、§4.4）。
- 数据规模非单调：π0.5 统一策略在五个代表任务上，每任务 200 条数据得 312/500（42% SR），高于全量数据 60k 步（277/500，34% SR）和 120k 步（248/500，26% SR）（§4.1）。
- 语言粒度（测试时统一用 L1 指令）：L2 训练把总分从 703 提到 867、SR 从 20% 提到 32.7%；L3 的 SR 最高（35.3%），语义类得分也最高（370/500）（§4.2、表 4）。
- 训练方式与模型来源：统一多任务训练提升了 π0.5，却让 WALL-OSS-0.5 下降 86.0 分，且属于能力在任务间的重新分配；作者将其归因于 WALL-OSS-0.5 在相近本体的数据上预训练（§4.3、表 3）。
- 配对仿真：真机、仿真和混合数据训练的效果因任务而异，仿真只作为筛查工具，不能替代真机评测（§4.5、附录 H）。

## 局限 / 存疑

## 与其他论文的关系

- [[02_WALL-OSS-0.5]]：被评测的参考模型，单任务专家版取得最高总分
- [[03_WALL-WM]]：出现在模型对比表（表 5）中
- [[10_X2Real]]：后续的仿真基准，复刻了 ManipArena 的绿幕场景和部分任务来验证仿真与真机的相关性

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 10 条

> Using ManipArena, we evaluate seven tabletop configurations spanning VLA and world-action-model policies. The results show that real-robot conclusions depend not only on architecture, but also on model provenance, fine-tuning regime, data sampling, and annotation granularity.
> 批注：Claude：七种配置；结论受模型来源、数据等影响
> — [[xsquare/papers/15_2603.28545_ManipArena.pdf#page=1|p.1]]

> Specifically, ManipArena comprises 20 real-robot tasks, 10,812 trajectories, and approximately 188 hours of demonstrations.
> 批注：Claude：20 个任务、10,812 条轨迹、约 188 小时
> — [[xsquare/papers/15_2603.28545_ManipArena.pdf#page=3|p.3]]

> The benchmark includes 15 tabletop tasks and 5 mobile-manipulation tasks.
> 批注：Claude：15 个桌面任务、5 个移动任务
> — [[xsquare/papers/15_2603.28545_ManipArena.pdf#page=3|p.3]]

> The best aggregate tabletop score (WALL-OSS-0.5-Specialist) reaches 951/1500 (63.4%), and no policy consistently dominates across tasks.
> 批注：Claude：最佳总分 951/1500（63.4%）
> — [[xsquare/papers/15_2603.28545_ManipArena.pdf#page=3|p.3]]

> Trials 1–4 sample in-domain configurations, trials 5–8 introduce controlled visual or configuration shifts, and trials 9–10 use the strongest held-out condition available for the task
> 批注：Claude：10 次试验的分层评测协议
> — [[xsquare/papers/15_2603.28545_ManipArena.pdf#page=6|p.6]]

> Each trial is worth 10 points, distributed over stages such as grasping, transport, alignment, insertion, pouring, semantic selection, and final retraction
> 批注：Claude：每次试验 10 分的分步计分
> — [[xsquare/papers/15_2603.28545_ManipArena.pdf#page=6|p.6]]

> The 200/task recipe obtains the best five-task score (312/500, 42% SR), exceeding the full-data 60k recipe (277/500, 34% SR) and the full-data 120k control (248/500, 26% SR).
> 批注：Claude：200/task 优于全量数据
> — [[xsquare/papers/15_2603.28545_ManipArena.pdf#page=7|p.7]]

> L2 raises total score from 703 to 867 and SR from 20% to 32.7%, while L3 obtains the highest SR (35.3%) and strongest semantic score (370/500).
> 批注：Claude：L2/L3 标注的效果
> — [[xsquare/papers/15_2603.28545_ManipArena.pdf#page=7|p.7]]

> but reduces WALL-OSS-0.5 by 86.0 points. Per-task results in Appendix E show that these shifts are competence redistributions rather than uniform gains or losses.
> 批注：Claude：统一训练使 WALL-OSS-0.5 下降 86.0 分
> — [[xsquare/papers/15_2603.28545_ManipArena.pdf#page=8|p.8]]

> We therefore treat simulation as a screening instrument, not a substitute benchmark: simulated gains require physical validation before being interpreted as real-robot capability gains.
> 批注：Claude：仿真只作为筛查工具
> — [[xsquare/papers/15_2603.28545_ManipArena.pdf#page=9|p.9]]
<!-- highlights:end -->

## 摘要（中文）

视觉-语言-动作（VLA）模型和世界动作模型已成为通用机器人智能的核心范式，但它们的实证进展仍受制于缺少既贴近物理现实、又能做受控诊断的评测协议。以仿真器为中心的基准提供了规模和可复现性，却无法完整刻画感知噪声、接触动力学、延迟、标定误差和硬件约束带来的现实差距。反过来，真机评测往往在平台、场景、物体和计分规则上各不相同，使公平比较和失败归因都很困难。

我们提出 ManipArena，一个标准化的真机评测框架，用于在匹配的物理条件下研究操作泛化。ManipArena 包含 20 个任务、10,812 条专家轨迹、13.5M 帧，以及约 188 机器人小时的数据，覆盖桌面操作和移动操作。该框架结合了由模式定义的任务变化、分层的域内／视觉偏移／语义 OOD 试次、子任务级的分步计分、三级语言标注、底层电机信号，以及从物理场景重建的配对 real-to-sim 环境。

我们用 ManipArena 评测了涵盖 VLA 与世界动作模型策略的七种桌面配置。结果表明，真机上的结论不仅取决于架构，还取决于模型来源、微调方式、数据采样和标注粒度。因此，ManipArena 为诊断具身泛化中的能力边界和失败模式提供了可复现、可解释的基础。

## 摘要（原文）

> Vision-Language-Action (VLA) models and world-action models have emerged as central paradigms for general-purpose robotic intelligence, yet their empirical progress remains constrained by the absence of evaluation protocols that are both physically realistic and diagnostically controlled. Simulator-centric benchmarks provide scale and reproducibility, but cannot fully capture the reality gap induced by perception noise, contact dynamics, latency, calibration error, and hardware constraints. Conversely, real-robot evaluations are often fragmented across platforms, scenes, objects, and scoring rules, making fair comparison and failure attribution difficult. We introduce ManipArena, a standardized real-robot evaluation framework for studying manipulation generalization under matched physical conditions. ManipArena comprises 20 tasks, 10,812 expert trajectories, 13.5M frames, and approximately 188 robot hours across tabletop and mobile manipulation. The framework combines schema-defined task variation, stratified in-domain, visualshift, and semantic-OOD trials, subtask-level partial-credit scoring, three-level language annotations, low-level motor signals, and paired real-to-sim environments reconstructed from physical scenes. Using ManipArena, we evaluate seven tabletop configurations spanning VLA and world-action-model policies. The results show that real-robot conclusions depend not only on architecture, but also on model provenance, fine-tuning regime, data sampling, and annotation granularity. ManipArena thus provides a reproducible and interpretable foundation for diagnosing capability boundaries and failure modes in embodied generalization.
