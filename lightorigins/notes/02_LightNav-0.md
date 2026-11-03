---
id: "02"
org: 亮源
short: "LightNav-0"
title: "LightNav-0: Eliciting VLM Spatial Intelligence for Generalist Embodied Navigation"
aliases: ["LightNav-0"]
date: 2026-08-31
category: 导航
source: 亮源主导
partners: []
authors: ["Shaoan Wang", "Aocheng Luo", "Fei Huang", "Jingyi Xu", "Xiaoyang Wang", "Yueyu Wang", "Qianli Ma", "Fan Yang", "Ran Mei", "Jia Wei", "Jiangpeng Hu", "Xuhao Liu", "Hongming Chen", "Yuanbin Shao", "Yiyang Lin", "Ziliang Li", "Liang Pan", "Xinhang Liu", "Yuntao Ma", "Tingxiang Fan"]
arxiv: "2608.30935"
pdf: "[[lightorigins/papers/02_2608.30935_LightNav-0.pdf]]"
code: "https://github.com/lightorigins/LightNav-0"
project: "https://www.lightorigins.com/blog/lightnav-0"
huggingface: ["https://huggingface.co/LightOriginsHQ/LightNav-0", "https://huggingface.co/datasets/LightOriginsHQ/Light-INSIGHT-Bench"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "navigation", "vlm", "real2sim2real", "benchmark"]
---

# LightNav-0: Eliciting VLM Spatial Intelligence for Generalist Embodied Navigation

> [!info] 论文信息
> arXiv [2608.30935](https://arxiv.org/abs/2608.30935) · v1 2026-08-31 · 最新 v2（2026-09-09）
> PDF：[[lightorigins/papers/02_2608.30935_LightNav-0.pdf|本地 PDF]]
> [代码](https://github.com/lightorigins/LightNav-0) · [项目页](https://www.lightorigins.com/blog/lightnav-0) · [LightNav-0](https://huggingface.co/LightOriginsHQ/LightNav-0) · [Light-INSIGHT-Bench](https://huggingface.co/datasets/LightOriginsHQ/Light-INSIGHT-Bench) · [INSIGHT-Bench](https://github.com/lightorigins/Light-INSIGHT-Bench) · [官网 PDF](https://static.lightorigins.com/website/reports/lightnav-0-technical-report_02cfc2f.pdf)

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 统一 token 接口：双通道指点 + RVQ 动作 tokenizer：“LightNav-0 represents diverse navigation tasks through a unified token interface: dual-channel pointing expresses task-, scene-, and embodiment-agnostic spatial intent, while a residual vector-quantized action tokenizer maps this intent to precise, embodiment-specific trajectories.”（Abstract）
> - RVQ 任意非空前缀都能解码为可执行粗轨迹：“Any non-empty token prefix decodes into an executable coarse trajectory, while successive residual levels progressively refine geometric precision.”（Fig. 4 caption）
> - LightNav-ER 平均 67.4，超过 Qwen3-VL-4B 和 8B Molmo2-ER：“attaining the highest complete-set average of 67.4. This exceeds the strongest baseline average, achieved by Qwen3-VL-4B, by +4.3 (6.8%) and the 8B Molmo2-ER average by +4.6 (7.3%), despite using only 50% of the parameters.”（§VI-B）
> - R2R 单目 SR/SPL/NE 提升：“Relative to the best prior monocular entries, SR increases from 66.9 to 68.5 (+1.6; 2.4%) and SPL from 62.3 to 62.8 (+0.5; 0.8%), while NE decreases from 4.05 to 3.91”（§VI-C1）
> - RxR nDTW 低于 DualVLN：“Its nDTW of 67.4 remains below DualVLN’s 70.0, revealing that the higher success and terminal accuracy do not translate uniformly to trajectory fidelity.”（§VI-C1）
> - MP3D ObjectNav SR 46.6 到 53.3：“On MP3D, it raises SR over CogNav from 46.6 to 53.3 (+6.7; 14.4%) and SPL over VLFM from 17.5 to 21.2 (+3.7; 21.1%).”（§VI-C2）
> - INSIGHT-Bench 上 SR、SPL 超过 JanusVLN：“It improves SR over JanusVLN from 27.4 to 43.7 (+16.3; 59.5%) and SPL from 24.0 to 41.5 (+17.5; 72.9%), and reduces NE from NaVid’s 4.25 m to 3.88 m”（§VI-C3）
> - EVT-Bench 单目标与干扰跟踪 SR：“For single-target tracking, it raises SR from ReferTrack’s 89.4 to 91.7 (+2.3; 2.6%). Under distracted tracking, where the agent must preserve target identity among distractors, the margin increases from 73.3 to 82.6 (+9.3; 12.7%).”（§VI-C4）
> - 双通道指点消融：平均 SR/SPL：“Dual-channel pointing raises mean SR from 54.7 to 63.0 (+8.3; 15.2%) and mean SPL from 34.3 to 39.9 (+5.6; 16.3%).”（§VI-E）
> - 真机跟随未见过的动态目标类别：“Although tracking supervision contains only human targets, LightNav-0 follows previously unseen classes of dynamic targets, including humanoid robots, wheeled robots, and carts, without additional training.”（§VI-D2）

## 一句话总结

用双通道指点和 RVQ 动作 token，让 4B 的 VLM 只凭单目 RGB 统一完成指令导航、找物和视觉跟踪。

## 要解决什么问题

具身导航要把异构目标（语言指令、物体类别、移动目标）和视觉观测转成跨任务、跨环境、跨本体的动作。现代 VLM 已具备视觉定位、空间推理和指点等空间先验，但很少被直接用于机器人控制；现有导航系统多依赖面向单一任务或本体的组件（路点预测器、拓扑地图、专用动作头），把感知、推理和动作割裂开，泛化有限。连续动作头还把动作生成放到语言模型之外，使 RL 后训练拿不到精确的逐动作概率，而纯离散的动作 token 又往往精度不足。

## 方法

- 统一 token 接口：以 Qwen3-VL-4B-Instruct 为骨干，保留原架构，只扩展词表，不加任务专用预测头或任务 ID token；每个决策步输出 2 个指点 token 加 3 个 RVQ 动作 token，全部由原语言模型头自回归解码，用同一个交叉熵目标训练，见 §III-A、§III-E。
- 双通道指点（dual-channel pointing）：affordance point 指出可行方向或自由空间路点，object point 定位目标物体或目标位置，各自用通道专属的图像网格 token 表示，作为动作解码前的显式空间推理步骤，见 §III-C。
- 残差向量量化动作 tokenizer（residual vector-quantized action tokenizer）：把 10 个未来 SE(2) 路点组成的轨迹用 3 级码本（每级 256 个码字）量化，第一级给出粗轨迹、后两级补残差；任意非空前缀都能解码成可执行轨迹，算力紧张时可提前停止，见 §III-D、Fig. 4。
- 时间感知视觉历史压缩（temporally aware visual history compression）：参照艾宾浩斯遗忘曲线，越旧的帧采样越稀、空间池化越粗，把历史限制在固定的视觉 token 预算内，见 §III-B。
- 三阶段训练：具身推理中训练（embodied-reasoning mid-training，得到 LightNav-ER）→ 混入 ER/VQA 数据、含 DAgger 样本的监督微调（“先专精再保留”）→ 在线多任务 GRPO 强化学习，每个任务一个终端奖励，并按 SFT 策略的成败筛选训练回合，见 §V。另构建了 INSIGHT-Bench（mesh 与 3D Gaussian splatting 场景，按场景类型和指令类型做诊断分类），见 §IV-D。

## 实验与关键数字

- 具身推理（Table II）：LightNav-ER 取得最高的完整集平均分 67.4，比最强基线 Qwen3-VL-4B 高 4.3，比 8B 的 Molmo2-ER 高 4.6，参数量只有后者的 50%。
- 连续 VLN（Table III）：R2R 上单目方法中各项指标最佳，SR 从 66.9 提到 68.5、SPL 从 62.3 提到 62.8、NE 从 4.05 降到 3.91；RxR 上 nDTW 67.4 仍低于 DualVLN 的 70.0，全景方法在 R2R 和 RxR 上仍略有优势。
- 物体导航与 INSIGHT-Bench（Table IV、VI）：闭集 ObjectNav 各设置上单目 SR、SPL 均最佳，且不用深度和里程计，如 MP3D 上 SR 从 CogNav 的 46.6 提到 53.3；INSIGHT-Bench 上 SR 从 JanusVLN 的 27.4 提到 43.7、SPL 从 24.0 提到 41.5。
- 视觉跟踪（Table VIII，EVT-Bench）：单目标跟踪 SR 从 ReferTrack 的 89.4 提到 91.7，干扰跟踪 SR 从 73.3 提到 82.6；但 ReferTrack 的跟踪率（TR）仍最高。
- 消融（Table IX、X）：去掉双通道指点后，平均 SR 从 63.0 降到 54.7、平均 SPL 从 39.9 降到 34.3；用 LightNav-ER 初始化比直接用 Qwen3-VL 初始化，在所有设置上 SR 都更高。
- 真实世界（§VI-D2，仅定性展示）：同一 checkpoint 零样本部署到人形、四足、空中和轮式平台；跟踪训练数据只有人类目标，却能跟随人形机器人、轮式机器人、推车等没见过的目标类别。

## 局限 / 存疑


## 与其他论文的关系

- [[05_X-Tokenizer]]：同样用残差向量量化（RVQ）把连续动作离散成 VLM 可直接预测的 token，第一级表示粗粒度动作、后续级别补残差细节；本文用于导航轨迹，X-Tokenizer 用于机械臂动作
- [[02_WALL-OSS-0.5]]：同样用 RVQ 动作 tokenizer 作为 VLM 骨干的离散动作接口

## 我的想法


## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 10 条

> LightNav-0 represents diverse navigation tasks through a unified token interface: dual-channel pointing expresses task-, scene-, and embodiment-agnostic spatial intent, while a residual vector-quantized action tokenizer maps this intent to precise, embodiment-specific trajectories.
> 批注：Claude：统一 token 接口：双通道指点 + RVQ 动作 tokenizer
> — [[lightorigins/papers/02_2608.30935_LightNav-0.pdf#page=1|p.1]]

> Any non-empty token prefix decodes into an executable coarse trajectory, while successive residual levels progressively refine geometric precision.
> 批注：Claude：RVQ 任意非空前缀都能解码为可执行粗轨迹
> — [[lightorigins/papers/02_2608.30935_LightNav-0.pdf#page=5|p.5]]

> Its nDTW of 67.4 remains below DualVLN’s 70.0, revealing that the higher success and terminal accuracy do not translate uniformly to trajectory fidelity.
> 批注：Claude：RxR nDTW 低于 DualVLN
> — [[lightorigins/papers/02_2608.30935_LightNav-0.pdf#page=15|p.15]]

> attaining the highest complete-set average of 67.4. This exceeds the strongest baseline average, achieved by Qwen3-VL-4B, by +4.3 (6.8%) and the 8B Molmo2-ER average by +4.6 (7.3%), despite using only 50% of the parameters.
> 批注：Claude：LightNav-ER 平均 67.4，超过 Qwen3-VL-4B 和 8B Molmo2-ER
> — [[lightorigins/papers/02_2608.30935_LightNav-0.pdf#page=15|p.15]]

> On MP3D, it raises SR over CogNav from 46.6 to 53.3 (+6.7; 14.4%) and SPL over VLFM from 17.5 to 21.2 (+3.7; 21.1%).
> 批注：Claude：MP3D ObjectNav SR 46.6 到 53.3
> — [[lightorigins/papers/02_2608.30935_LightNav-0.pdf#page=15|p.15]]

> Relative to the best prior monocular entries, SR increases from 66.9 to 68.5 (+1.6; 2.4%) and SPL from 62.3 to 62.8 (+0.5; 0.8%), while NE decreases from 4.05 to 3.91
> 批注：Claude：R2R 单目 SR/SPL/NE 提升
> — [[lightorigins/papers/02_2608.30935_LightNav-0.pdf#page=15|p.15]]

> It improves SR over JanusVLN from 27.4 to 43.7 (+16.3; 59.5%) and SPL from 24.0 to 41.5 (+17.5; 72.9%), and reduces NE from NaVid’s 4.25 m to 3.88 m
> 批注：Claude：INSIGHT-Bench 上 SR、SPL 超过 JanusVLN
> — [[lightorigins/papers/02_2608.30935_LightNav-0.pdf#page=15|p.15]]

> For single-target tracking, it raises SR from ReferTrack’s 89.4 to 91.7 (+2.3; 2.6%). Under distracted tracking, where the agent must preserve target identity among distractors, the mar- gin increases from 73.3 to 82.6 (+9.3; 12.7%).
> 批注：Claude：EVT-Bench 单目标与干扰跟踪 SR
> — [[lightorigins/papers/02_2608.30935_LightNav-0.pdf#page=16|p.16]]

> Although tracking supervision contains only human targets, LightNav-0 follows previously unseen classes of dynamic targets, in- cluding humanoid robots, wheeled robots, and carts, without additional training.
> 批注：Claude：真机跟随未见过的动态目标类别
> — [[lightorigins/papers/02_2608.30935_LightNav-0.pdf#page=18|p.18]]

> Dual-channel pointing raises mean SR from 54.7 to 63.0 (+8.3; 15.2%) and mean SPL from 34.3 to 39.9 (+5.6; 16.3%).
> 批注：Claude：双通道指点消融：平均 SR/SPL
> — [[lightorigins/papers/02_2608.30935_LightNav-0.pdf#page=19|p.19]]
<!-- highlights:end -->

## 摘要（中文）

具身导航要求智能体在不同任务、环境和机器人本体之间，把异构的目标和视觉观测转化为动作。现代视觉-语言模型（VLM）已经蕴含了用于视觉定位、空间推理和指点的空间先验，但这些能力很少被直接激发出来用于机器人控制。现有导航系统转而依赖针对特定任务或特定本体的组件，使感知、推理和动作相互割裂，泛化能力有限。

本文提出 LightNav-0，一个紧凑的通用具身导航模型：它激发预训练 VLM 的空间智能并将其与导航对齐，不需要任务专用的预测头。LightNav-0 通过统一的 token 接口表示各种导航任务：双通道指点表达与任务、场景和本体无关的空间意图，而残差向量量化动作 tokenizer 把这一意图映射为精确的、针对具体本体的轨迹。结合时间感知的视觉历史压缩、ER 中训练、监督微调和强化学习，这一形式让单个模型同时支持指令跟随、开放词汇物体导航和视觉跟踪。导航训练语料覆盖 2K+ 个场景和 4K+ 小时的具身导航数据。

用于初始化 LightNav-0 的具身推理检查点 LightNav-ER，在 8 个具身推理基准上取得最高的完整集平均分；LightNav-0 则在全部 10 个公开导航仿真设置上取得单目方法中最先进的成功率。真实世界评测进一步表明，它能零样本泛化到不同的机器人本体、多样的场景以及静态和动态目标。这些结果确立了紧凑 VLM 作为通用具身导航的统一且可迁移的骨干。

## 摘要（原文）

> Embodied navigation requires agents to translate heterogeneous goals and visual observations into actions across tasks, environments, and robot embodiments. Modern vision-language models (VLMs) already encode spatial priors for visual grounding, spatial reasoning, and pointing, but these capabilities are rarely elicited directly for robot control. Existing navigation systems instead rely on task- or embodiment-specific components, fragmenting perception, reasoning, and action while offering limited generalization. Here we present LightNav-0, a compact generalist embodied navigation model that elicits the spatial intelligence of a pretrained VLM and aligns it with navigation, without task-specific prediction heads. LightNav-0 represents diverse navigation tasks through a unified token interface: dual-channel pointing expresses task-, scene-, and embodiment-agnostic spatial intent, while a residual vector-quantized action tokenizer maps this intent to precise, embodiment-specific trajectories. Together with temporally aware visual history compression, ER mid-training, supervised fine-tuning, and reinforcement learning, this formulation supports instruction following, open-vocabulary object navigation, and visual tracking within a single model. The navigation training corpus spans 2K+ scenes and 4K+ hours of embodied navigation data. LightNav-ER, the embodied-reasoning checkpoint used to initialize LightNav-0, attains the highest complete-set average across 8 embodied-reasoning benchmarks, while LightNav-0 achieves state-of-the-art monocular success rates across all 10 public navigation simulation settings. Real-world evaluations further demonstrate zero-shot generalization across robot embodiments, diverse scenes, and static and dynamic targets. These results establish compact VLMs as a unified and transferable backbone for generalist embodied navigation.
