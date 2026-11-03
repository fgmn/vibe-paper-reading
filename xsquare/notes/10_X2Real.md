---
id: "10"
org: 自变量
short: "X2Real"
title: "X2Real: an eXtensive simulation benchmark for real-world generalist policies"
aliases: ["X2Real"]
date: 2026-09-23
category: 评测基准
source: 自变量主导
partners: []
authors: ["Lian Ruan", "Jade Yang", "Sherphylan Gao", "Felix Gao", "Kyson Liang", "Galen Liu", "Ligo Wu", "Lane Jin", "Guu Gu", "Bevan Xie", "Cloud Yan", "Zongzi Yuan", "Kino Luo", "Emma Chen", "Shuwen Chen", "Yang Ping", "Miles Guo", "Rain Sun", "Kayden Zhang", "Alex Du", "Ruihai Wu", "Liang Hao", "Zhaoshuo Li", "Roy Gan", "Hao Wang", "Qian Wang"]
arxiv: "2609.27449"
pdf: "[[xsquare/papers/10_2609.27449_X2Real.pdf]]"
code: "https://github.com/X-Square-Robot/x2real"
project: "https://x2robot.com/en/pages/x2real"
huggingface: ["https://huggingface.co/datasets/x-square-robot/X2Real-Dataset"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "benchmark", "simulation", "sim2real"]
---

# X2Real: an eXtensive simulation benchmark for real-world generalist policies

> [!info] 论文信息
> arXiv [2609.27449](https://arxiv.org/abs/2609.27449) · v1 2026-09-23 · 最新 v2（2026-10-13）
> PDF：[[xsquare/papers/10_2609.27449_X2Real.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/x2real) · [项目页](https://x2robot.com/en/pages/x2real) · [X2Real-Dataset](https://huggingface.co/datasets/x-square-robot/X2Real-Dataset)

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 10 个能力维度、44 个长程任务：“It features a comprehensive taxonomy with 10 capability dimensions and 44 hierarchical long-horizon tasks, covering basic manipulation skills and advanced capacities such as visual grounding, language understanding, and bimanual control.”（Abstract）
> - 仿真与真机评测线性相关 0.84：“X2Real calibrates simulation visual and physical properties to align with real hardware, achieving a 0.84 linear correlation between simulated and real-robot evaluation results.”（Abstract）
> - Mana 生态与近 300 小时数据集：“Powered by a custom physical domain-specific language, the Mana simulation ecosystem supports modular task design and iterative performance analysis, alongside a nearly 300-hour annotated simulation trajectory dataset.”（Abstract）
> - 三条正交随机化轴：“Our randomization scheme falls into three orthogonal axes to guarantee diverse, robust, and unbiased evaluation”（§2.2）
> - 任务表示为可执行 DAG：“we represent each manipulation task as an executable Directed Acyclic Graph (DAG) composed of atomic tasks.”（§3.3）
> - 最强策略 ID 53.9% 降到 OOD 34.3%：“even the strongest evaluated policy decreases from an overall ID success rate of 53.9% to an OOD success rate of 34.3%”（§1）
> - 复刻 ManipArena 的 8 个任务：“we choose 8 tasks from ManipArena that mainly contain rigid object interactions.”（§4.1.2）
> - 以真机微调的 wall-oss-0.5 做 sim2real 验证：“We select the wall-oss-0.5 model as our base model for its best performance on ManipArena. After finetuning it with real demonstration data, we directly evaluate it in our simulation environment”（§4.1.2）
> - 编码智能体与 wall-oss-preview 互有胜负：“Thus, neither method dominates both capability dimensions or both evaluation metrics.”（§4.2.2）
> - 自动合成 3.75 层 vs 遥操作 1.90 层：“Under the full-task instruction setting, the automatically synthesized data yield an average of 3.75 completed layers and a maximum of 6, whereas the teleoperated data yield an average of 1.90 layers and a maximum of 4.”（§4.3）

## 一句话总结

基于 Isaac Lab-Arena 的可演化仿真基准，含 44 个长程任务，仿真与真机评测线性相关 0.84。

## 要解决什么问题

现有仿真基准难以忠实反映通用操作策略的真实能力：sim2real 差距使仿真分数无法预测真机表现；任务分布窄，多是固定资产上的抓放任务，很快饱和；训练与评测流程界限不清，策略可以靠固定随机种子、记忆场景来“刷榜”。已有工作通常只解决其中一项，而且静态基准迟早会饱和，需要一套能持续演化的评测基础设施。

## 方法

- 三条设计原则：忠实（faithfulness）、多样（diversity）、公平（fairness）。
- 多维任务体系（Multi-dimensional Task Suite）：分为推理（Reasoning：泛化、视觉理解、语言理解、记忆）和操作（Manipulation：精细操作、双臂协作、工具使用、动态操作、移动操作）两大类，另设叠积木、长序列按按钮、汉诺塔三个挑战任务来测能力上限；见 §2.1、附录 A.1。
- 多轴域随机化（multi-axis domain randomization）：外观、任务设置、本体三条正交轴，按任务类别分层启用；训练数据在改编自 ManipArena 的绿幕棚数字孪生中采集，与评测配置严格分离（§2.2–2.3）。
- 硬件对齐标定：视觉与物理参数对齐真机，并用 CMA-ES 搜索 StablePD 控制器增益，使仿真与真机轨迹回放达到毫米级一致（§2.2、§4.1.1）。
- Mana 仿真生态：以基于 YAML 的物理领域特定语言（Physical DSL）统一描述场景、本体、子任务依赖图和随机化规则，由 LLM 智能体驱动任务设计循环（Task Design Loop）和 rollout 分析循环（Rollout Analysis Loop）；另含 AIG3D 资产合成、物理与渲染异步调度等（§3.1–3.4）。
- 可执行任务 DAG（executable Directed Acyclic Graph）：每个任务拆成可验证的原子子任务，同一张图同时用于自动数据合成、逐帧子任务标注和进度/失败分析（§3.3）；统一运行时接口 Policy Space 让不同策略在同一协议下评测（§2.4）。

## 实验与关键数字

- Sim2real 验证：在仿真中复刻 ManipArena 的 8 个刚体任务，用只在真机数据上微调的 wall-oss-0.5 评测，仿真与真机结果线性相关 0.84（§4.1.2 指出这是进度分的相关，精密任务在仿真中成功率明显偏低）。
- 桌面任务：四个通用策略（Wall-OSS-0.5、DreamZero、π0.5、内部模型 wall-oss-preview）用同一批数据后训练；最强的策略总体成功率从 ID 的 53.9% 降到 OOD 的 34.3%，进度分能体现成功率看不到的部分完成情况（§4.2.1、表 1）。
- 编码智能体作为策略：GPT-6-Astra 在 OOD 环境上与 wall-oss-preview 总体相当，推理类任务更强、操作类任务更弱，两者都没有全面占优；但其推理延迟很长，期间仿真暂停（§4.2.2）。
- 移动操作：wall-oss-preview 与 π0.5 在三个移动任务上的 OOD 成功率都很低，DAG 阶段分析能定位卡在哪一步（§4.2.3、表 2）。
- 自动合成 vs 遥操作（stack_blocks 挑战）：全任务指令下，自动合成数据平均完成 3.75 层、最多 6 层，遥操作数据平均 1.90 层、最多 4 层；按 DAG 分阶段给指令还能进一步提升（§4.3、表 3）。

## 局限 / 存疑

## 与其他论文的关系

- [[15_ManipArena]]：训练数据的绿幕场景改编自 ManipArena，sim2real 验证复刻了其中 8 个任务
- [[02_WALL-OSS-0.5]]：sim2real 验证的基座模型，也是桌面评测的四个策略之一
- [[03_WALL-WM]]：引言中作为通用操作策略的代表被引用

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 10 条

> X2Real calibrates simulation visual and physical properties to align with real hardware, achieving a 0.84 linear correlation between simulated and real-robot evaluation results.
> 批注：Claude：仿真与真机评测线性相关 0.84
> — [[xsquare/papers/10_2609.27449_X2Real.pdf#page=1|p.1]]

> It features a comprehensivetaxonomywith10capabilitydimensionsand44hierarchicallong-horizontasks, covering basic manipulation skills and advanced capacities such as visual grounding, language understanding, and bimanual control
> 批注：Claude：10 个能力维度、44 个长程任务
> — [[xsquare/papers/10_2609.27449_X2Real.pdf#page=1|p.1]]

> Powered by a custom physical domain-specific language, the Mana simulation ecosystem supports modular task design and iterative performance analysis, alongside a nearly 300-hour annotated simulation trajectory dataset.
> 批注：Claude：Mana 生态与近 300 小时数据集
> — [[xsquare/papers/10_2609.27449_X2Real.pdf#page=1|p.1]]

> even the strongest evaluated policy decreases from an overall ID success rate of 53.9% to an OOD success rate of 34.3%
> 批注：Claude：最强策略 ID 53.9% 降到 OOD 34.3%
> — [[xsquare/papers/10_2609.27449_X2Real.pdf#page=4|p.4]]

> Our randomization scheme falls into three orthogonal axes to guarantee diverse, robust, and unbiased evaluation
> 批注：Claude：三条正交随机化轴
> — [[xsquare/papers/10_2609.27449_X2Real.pdf#page=5|p.5]]

> we represent each manipulation task as an executable Directed Acyclic Graph (DAG) composedofatomictasks
> 批注：Claude：任务表示为可执行 DAG
> — [[xsquare/papers/10_2609.27449_X2Real.pdf#page=18|p.18]]

> we choose 8 tasks from ManipArena that mainly contain rigid object interactions.
> 批注：Claude：复刻 ManipArena 的 8 个任务
> — [[xsquare/papers/10_2609.27449_X2Real.pdf#page=26|p.26]]

> We select the wall-oss-0.5 model as our base model for its best performance on ManipArena. After finetuning it with real demonstration data, we directly evaluate it in our simulation environment
> 批注：Claude：以真机微调的 wall-oss-0.5 做 sim2real 验证
> — [[xsquare/papers/10_2609.27449_X2Real.pdf#page=27|p.27]]

> Thus, neither method dominates both capability dimensions or both evaluation metrics.
> 批注：Claude：编码智能体与 wall-oss-preview 互有胜负
> — [[xsquare/papers/10_2609.27449_X2Real.pdf#page=31|p.31]]

> Under the full-task instruction setting, the automatically synthesized data yield an average of 3.75 completed layers and a maximum of 6, whereas the teleoperated data yield an average of 1.90 layers and a maximum of 4.
> 批注：Claude：自动合成 3.75 层 vs 遥操作 1.90 层
> — [[xsquare/papers/10_2609.27449_X2Real.pdf#page=33|p.33]]
<!-- highlights:end -->

## 摘要（中文）

通用机器人操作策略发展迅速，但由于现有仿真基准存在根本缺陷，对它们进行可靠评测仍然困难：sim-to-real 差距明显、任务覆盖面窄，以及训练-测试流程界定不清导致的不公平评测。已有工作只部分解决了这些问题，无法同时做到忠实、多样与公平，而静态的基准设计也难以支撑策略的长期发展。

我们提出 X2Real，一个基于 Nvidia Isaac Lab-Arena、可持续演化的仿真基准，用于忠实评估机器人操作策略在真实世界中的表现。遵循忠实、多样、公平三条核心原则，X2Real 标定仿真的视觉与物理属性以对齐真实硬件，使仿真与真机评测结果之间的线性相关达到 0.84。它有一套全面的分类体系，包含 10 个能力维度和 44 个分层的长程任务，既覆盖基本操作技能，也覆盖视觉定位、语言理解和双臂控制等高级能力。我们还采用多轴域随机化和严格不相交的训练-评测流程，以减少对基准的投机利用，确保评测可信。

依托自定义的物理领域特定语言，Mana 仿真生态支持模块化的任务设计和迭代式的性能分析，并配有近 300 小时带标注的仿真轨迹数据集。X2Real 提供了一套忠实、多样、公平且不断演化的评测基础设施，有效弥合 sim-to-real 的评测差距，支持通用机器人操作策略的进一步发展。

## 摘要（原文）

> Generalist robot manipulation policies have developed rapidly, yet their reliable evaluation remains challenging due to fundamental flaws in existing simulation benchmarks: prominent sim-to-real gaps, narrow task coverage, and unfair evaluation caused by ambiguous training-test pipelines. Prior works only partially resolve these issues and lack simultaneous faithfulness, diversity, and fairness, while static benchmark designs fail to sustain long-term policy development. We present X2Real, an evolvable simulation benchmark for faithfully evaluating the real-world performance of robotic manipulation policies based on Nvidia Isaac Lab-Arena. Following three core principles (faithfulness, diversity, and fairness), X2Real calibrates simulation visual and physical properties to align with real hardware, achieving a 0.84 linear correlation between simulated and real-robot evaluation results. It features a comprehensive taxonomy with 10 capability dimensions and 44 hierarchical long-horizon tasks, covering basic manipulation skills and advanced capacities such as visual grounding, language understanding, and bimanual control. We further adopt multi-axis domain randomization and strictly disjoint training-evaluation pipelines to mitigate benchmark exploitation and ensure credible evaluation. Powered by a custom physical domain-specific language, the Mana simulation ecosystem supports modular task design and iterative performance analysis, alongside a nearly 300-hour annotated simulation trajectory dataset. X2Real offers a faithful, diverse, and fair evolving evaluation infrastructure, effectively bridging the sim-to-real evaluation gap and supporting the advancement of generalist robotic manipulation policies.
