---
id: "19"
org: 自变量
short: "DualTrack"
title: "DualTrack: Synchronized speech-gesture generation via symmetric coupling of pretrained priors"
aliases: ["DualTrack"]
date: 2026-09-29
category: 语音交互
source: 合作
partners: ["香港中文大学（深圳）"]
authors: ["Yuanzhuo Hu", "Zehan Liu", "Xiaoyi Qin", "Ming Li"]
arxiv: "2609.36624"
pdf: "[[xsquare/papers/19_2609.36624_DualTrack.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "speech", "gesture-generation", "tts"]
---

# DualTrack: Synchronized speech-gesture generation via symmetric coupling of pretrained priors

> [!info] 论文信息
> arXiv [2609.36624](https://arxiv.org/abs/2609.36624) · v1 2026-09-29
> PDF：[[xsquare/papers/19_2609.36624_DualTrack.pdf|本地 PDF]]
> 合作单位：香港中文大学（深圳）

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 核心思路：在共享 12.5 Hz 时间轴上耦合预训练先验：“which couples pretrained speech and motion priors on a shared 12.5 Hz timeline.”（Abstract）
> - 因果适配器与当前状态融合：“Causal adapters exchange previous-packet information, while current-state fusion coordinates the streams before they separately complete sixteen-codebook packets.”（Abstract）
> - 两流可并行预测：“Neither stream conditions on the other stream’s current output codes, allowing parallel packet prediction across modalities.”（§3.4）
> - 评测：43 段 BEAT2 录音、四种语言：“We evaluate 43 BEAT2 recordings in four languages, with speakers held out from joint training and validation.”（Abstract）
> - 英语 WER 与 NMOS 对比 GELINA：“lowers English WER from GELINA’s 18.09% to 3.45% and raises NMOS from 2.709 to 3.830.”（§4.2）
> - 英语 Full FGD 与多样性：“Full FGD falls from 7.513 to 6.889; full diversity moves from 2.651 to 11.499 toward GT 16.085.”（§4.2）
> - 西班牙语结果：“On six Spanish recordings, WER falls from 215.09% to 0.00%, and Full/Body FGD decreases from 9.850/3.451 to 8.560/3.247.”（§4.2）
> - 中文/日语 CER：“Chinese/Japanese CER is 2.10%/4.56% without a speaker embedding and 1.66%/4.73% with one,”（§4.2）
> - 消融：完整模型更好：“The full model achieves lower full-body FGD, higher beat consistency, and higher predicted speech naturalness.”（§4.2）
> - 主观评测优于 GELINA：“For each task, we retained five participants who completed all 28 shared samples (22 English + 6 Spanish). DualTrack outperforms GELINA in all three tasks.”（§4.2）

## 一句话总结

把预训练的 Qwen3-TTS 与运动先验在 12.5 Hz 共享时钟上双向耦合，联合生成同步的语音和含手指的全身手势。

## 要解决什么问题

语音–手势联合合成的配对数据少。级联方法只能让语音单向驱动动作；已有联合方法缺少双向跨模态交互与逐步并行预测，支持的语言有限（如 GELINA），或简化了身体和手指表示；借合成配对迁移单模态知识（如 MAGI）又未必能体现自然的语音–手势关系。

## 方法

- 运动表示与分词：所有动作统一到 77 关节的 SOMA 骨架和 499 维 UMR 特征；改造 SeMoCo 分词器（SeMoCo tokenizer），用 1 个语义码本加 15 层残差运动学码本，在 12.5 Hz 上输出 16 码的运动 packet（见 §3.1、§3.2）
- 运动先验 MotionPrior：语义 transformer 和全历史 transformer 编码历史 packet，因子化语义预测器决定保留还是切换语义码，Depth GPT 依次生成 15 个运动学码；先在 release910k、BONES-SEED、BEAT2 纯动作数据上预训练，再适配 BEAT2 分布（见 §3.3）
- 双轨耦合（见 §3.4）：语音流由 Qwen3-TTS（12Hz-0.6B-Base）初始化，运动流由 MotionPrior 初始化；残差适配器（residual adapters）把对方上一个 packet 双向注入，Tick Fusion 融合当前语音状态与运动语义状态；两条流都不以对方当前输出码为条件，因此可以并行预测 packet
- 训练：适配器和融合模块的输出投影零初始化；预训练语音模型、运动 packet 预测器和 codec 保持冻结，只训练耦合模块和部分运动层；预热后一半配对样本改用模型生成的运动历史（见 §3.4）

## 实验与关键数字

- 评测设置：BEAT2 中 43 段测试录音，覆盖四种语言，说话人不参与联合训练和验证；与 GELINA 的直接比较限于其支持的英语/西班牙语输入（见 §4.1）
- 英语（Table 1）：DualTrack†（加说话人嵌入）把 WER 从 GELINA 的 18.09% 降到 3.45%，NMOS 从 2.709 升到 3.830；Full FGD 从 7.513 降到 6.889，全身多样性从 2.651 升到 11.499（GT 为 16.085）
- 西班牙语与中日文：6 段西班牙语录音上 WER 从 215.09% 降到 0.00%，Full/Body FGD 从 9.850/3.451 降到 8.560/3.247；中文/日语 CER 为 2.10%/4.56%（无说话人嵌入），GELINA 不支持这两种语言（见 §4.2）
- 消融（Table 2）：同时去掉残差适配器和 Tick Fusion 后，全身 FGD、节拍一致性和预测语音自然度都变差
- 主观评测：保留完成全部 28 个共享样本的参与者，DualTrack 在语音自然度、动作自然度和音画同步三项上都优于 GELINA（见 Figure 2）

## 局限 / 存疑

## 与其他论文的关系

- [[12_X2Streaming-TTS]]：同样以 Qwen3-TTS（12Hz）为语音骨干，本文把它与动作先验耦合，该文用它做 token 级流式 TTS

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 10 条

> which couples pretrained speech and motion priors on a shared 12.5 Hz timeline.
> 批注：Claude：核心思路：在共享 12.5 Hz 时间轴上耦合预训练先验
> — [[xsquare/papers/19_2609.36624_DualTrack.pdf#page=1|p.1]]

> Causal adapters exchange previous- packet information, while current-state fusion coordinates the streams before they separately complete sixteen-codebook packets
> 批注：Claude：因果适配器与当前状态融合
> — [[xsquare/papers/19_2609.36624_DualTrack.pdf#page=1|p.1]]

> We evaluate 43 BEAT2 recordings in four languages, with speakers held out from joint training and validation.
> 批注：Claude：评测：43 段 BEAT2 录音、四种语言
> — [[xsquare/papers/19_2609.36624_DualTrack.pdf#page=1|p.1]]

> lowers English WER from GELINA’s 18.09% to 3.45% and raises NMOS from 2.709 to 3.830.
> 批注：Claude：英语 WER 与 NMOS 对比 GELINA
> — [[xsquare/papers/19_2609.36624_DualTrack.pdf#page=3|p.3]]

> Full FGD falls from 7.513 to 6.889; full diversity moves from 2.651 to 11.499 toward GT 16.085.
> 批注：Claude：英语 Full FGD 与多样性
> — [[xsquare/papers/19_2609.36624_DualTrack.pdf#page=3|p.3]]

> Neither stream conditions on the other stream’s current output codes, allow- ing parallel packet prediction across modalities.
> 批注：Claude：两流可并行预测
> — [[xsquare/papers/19_2609.36624_DualTrack.pdf#page=3|p.3]]

> On six Spanish recordings, WER falls from 215.09% to 0.00%, and Full/Body FGD decreases from 9.850/3.451 to 8.560/3.247.
> 批注：Claude：西班牙语结果
> — [[xsquare/papers/19_2609.36624_DualTrack.pdf#page=3|p.3]]

> Chinese/Japanese CER is 2.10%/4.56% without a speaker embedding and 1.66%/4.73% with one,
> 批注：Claude：中文/日语 CER
> — [[xsquare/papers/19_2609.36624_DualTrack.pdf#page=3|p.3]]

> The full model achieves lower full-body FGD, higher beat consistency, and higher predicted speech naturalness.
> 批注：Claude：消融：完整模型更好
> — [[xsquare/papers/19_2609.36624_DualTrack.pdf#page=4|p.4]]

> For each task, we retained five participants who completed all 28 shared samples (22 English + 6 Spanish). DualTrack outperforms GELINA in all three tasks.
> 批注：Claude：主观评测优于 GELINA
> — [[xsquare/papers/19_2609.36624_DualTrack.pdf#page=4|p.4]]
<!-- highlights:end -->

## 摘要（中文）

语音–手势联合合成必须在配对数据有限的情况下协调两种模态。现有方法往往缺少双向交互、支持的语言有限，或者简化了身体和手指的表示。

本文提出 DualTrack，把预训练的语音先验和运动先验耦合在共享的 12.5 Hz 时间轴上。因果适配器交换上一个 packet 的信息，当前状态融合模块先协调两条流，之后两条流再各自补全由十六个码本组成的 packet。

我们在 BEAT2 的 43 段录音上评测，覆盖四种语言，其中的说话人不参与联合训练和验证。在英语/西班牙语共有输入上，不提供语音或动作前缀时，DualTrack 相比所评测的 GELINA 基线取得了更低的词错误率和全身运动 Fréchet Gesture Distance，以及更高的节拍一致性和语音自然度。

## 摘要（原文）

> Joint speech-gesture synthesis must coordinate two modalities despite limited paired data. Existing approaches often lack bidirectional interaction, have limited language coverage, or simplify body and finger representations. We present DualTrack, which couples pretrained speech and motion priors on a shared 12.5 Hz timeline. Causal adapters exchange previous-packet information, while current-state fusion coordinates the streams before they separately complete sixteen-codebook packets. We evaluate 43 BEAT2 recordings in four languages, with speakers held out from joint training and validation. On the shared English/Spanish inputs, without speech or motion prefixes, DualTrack achieves lower word error rate and full-motion Fréchet Gesture Distance, higher beat consistency and speech naturalness than the evaluated GELINA baseline.
