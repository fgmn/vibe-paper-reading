---
id: "11"
org: 自变量
short: "X2-Turn"
title: "X2-Turn: Frame-Synchronous Dual-Head Modeling for Joint Streaming ASR and Turn State Prediction"
aliases: ["X2-Turn"]
date: 2026-08-11
category: 语音交互
source: 自变量主导
partners: []
authors: ["Kaiqi Fu", "Rime Wen", "Altman Lin", "Shawn Qin", "Roy Gan", "Hao Wang", "Qian Wang"]
arxiv: "2608.10878"
pdf: "[[xsquare/papers/11_2608.10878_X2-Turn.pdf]]"
code: "https://github.com/X-Square-Robot/X2-Turn"
project: ""
huggingface: ["https://huggingface.co/x-square-robot/X2-Turn-4B-0812", "https://huggingface.co/spaces/x-square-robot/x2-turn-4b-demo"]
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "speech", "asr", "turn-taking"]
---

# X2-Turn: Frame-Synchronous Dual-Head Modeling for Joint Streaming ASR and Turn State Prediction

> [!info] 论文信息
> arXiv [2608.10878](https://arxiv.org/abs/2608.10878) · v1 2026-08-11 · 最新 v3（2026-09-08）
> PDF：[[xsquare/papers/11_2608.10878_X2-Turn.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/X2-Turn) · [X2-Turn-4B-0812](https://huggingface.co/x-square-robot/X2-Turn-4B-0812) · [x2-turn-4b-demo](https://huggingface.co/spaces/x-square-robot/x2-turn-4b-demo)

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 核心方法：与 ASR 头并行的帧同步话轮状态头：“we introduce a frame-synchronous turn state head that operates in parallel with the ASR head on shared streaming representations, jointly predicting ASR tokens and fine-grained turn states at the frame level.”（Abstract）
> - ASR 锚定监督：词级标注投影到 ASR token 帧位置：“To temporally align the two tasks, we propose ASR-anchored supervision, which projects word-level turn annotations onto the frame-level positions of the corresponding ASR tokens.”（§1）
> - 五种话轮状态 token：“We define five turn state tokens to represent the evolving state of a user turn:”（§2.2）
> - Stage 1 ASR 数据约 26k 小时（中 14k、英 12k）：“totaling approximately 26k hours (14k hours in Chinese and 12k hours in English). This portion of data is used in Stage 1 to strengthen the model’s ASR capability in both languages.”（§3.1）
> - Pause TOR 中英文均最低：“Pause TOR is the lowest among all systems in both languages, indicating that X2-Turn takes the floor least often during intra-turn pauses.”（§4.1.1）
> - 指标完整的系统中整体 ACC 最高：“Among systems with fully reported metrics, X2-Turn therefore achieves the strongest overall ACC, with latency close to that of SoulX-Duplug.”（§4.1.1）
> - 英文 EasyTurn 与 SoulX-Duplug 对比：“In English, X2-Turn achieves substantially higher complete accuracy (92.10 vs. 77.67) but lower incomplete accuracy (84.60 vs. 88.96), at a latency cost of 20ms.”（§4.1.2）
> - 中文 backchannel 准确率优于 EasyTurn：“X2-Turn remains fully streaming and improves Chinese backchannel accuracy over EasyTurn (96.00 vs. 91.00).”（§4.1.2）
> - 延迟收紧时准确率损失小：“This indicates that our model is robust under tight latency constraints, allowing a suitable operating point to be chosen for different latency requirements with little loss in turn-taking accuracy.”（§4.3）
> - 帧级流式 ASR 可与固定分块方法竞争：“This indicates that frame-wise prediction with a short lookahead is competitive with, and often superior to fixed-chunk streaming even before accounting for its lower latency.”（§4.4）

## 一句话总结

在 Voxtral Realtime 流式 ASR 上并联一个帧同步的话轮状态头，一次前向同时输出转写和细粒度话轮状态。

## 要解决什么问题

口语对话系统需要实时区分用户打断、应忽略的附和语（backchannel）和一句话说完。已有模块化方法多在整句或固定分块层面预测话轮状态，与连续的话轮估计不匹配；而且往往依赖额外的 ASR 模型（如 VAD–ASR–话轮检测级联），带来顺序延迟和误差传播，响应慢、系统复杂。

## 方法

- 双头建模（dual-head modeling）：以基于延迟流建模（delayed-stream modeling, DSM）的 Voxtral Realtime 为骨干（每 80 ms 输出一个 token），在共享的解码器隐状态上并联话轮状态头与 ASR 头，联合损失为 ASR 损失加 λ 倍话轮损失；推理时只由 ASR 头驱动自回归解码，话轮预测不回灌，因此不影响 ASR（见 §2.1）
- 五种话轮状态 token：idle、noidle、incomplete、complete、backchannel；其中 noidle 专指语义尚不充分的早期语音，而不是噪声或静音（见 §2.2）
- ASR 锚定的话轮监督（ASR-anchored supervision）：用 LLM 给每个词标注话轮状态，再投影到该词的词边界 token [W] 及其子词 token 所在的 80 ms 帧位置；其余位置一律标为 idle，下游可在 complete 之后数连续 idle 帧做端点检测（见 §2.3）
- 词边界 [W] 锚定在词的起点（onset），而不是 Voxtral 原来的词终点（offset），让 ASR 和话轮决策更早出现（见 §2.3、§4.2）
- 两阶段训练：Stage 1 在中英 ASR 数据上适配延迟流协议；Stage 2 加入由 ASR 头复制初始化的话轮头联合微调；流式延迟 τ 按 batch 随机采样，一个模型覆盖多种延迟设置（见 §3.2）

## 实验与关键数字

- 训练数据：Stage 1 用约 26k 小时中英 ASR 数据（中文 14k、英文 12k 小时）；Stage 2 用 EasyTurn 中文子集和 Fisher 英文子集做联合训练（见 §3.1）
- 系统级（双语 Full-Duplex-Bench，X2-Turn 级联 Qwen2.5-7B-Instruct 与 Qwen3-TTS-Streaming）：Pause TOR 在中英文上都是所有系统中最低；在指标完整的系统中整体 ACC 最高，延迟接近 SoulX-Duplug；短板是英文 turn-taking TOR 和略高的整体延迟（见 Table 1）
- 模块级（EasyTurn）：英文 complete 准确率 92.10 vs. SoulX-Duplug 的 77.67，但 incomplete 准确率 84.60 vs. 88.96，延迟多 20ms；中文 backchannel 准确率 96.00 vs. EasyTurn 的 91.00；推理时不需要辅助 ASR 模型（见 Table 2）
- 消融：onset 放置在中英文上整体优于 offset；减小 τ 时延迟明显下降、话轮准确率只轻微下降（见 Table 3、Table 4）
- 流式 ASR：帧级预测加短前瞻可与固定分块的流式 ASR（Uni-ASR、Freeze-Omni）竞争甚至更好；联合话轮训练后 WER 有所退化，但仍持平或优于 Freeze-Omni（见 Table 5）

## 局限 / 存疑

## 与其他论文的关系

- [[14_X2Streaming-ASR]]：同样基于 Voxtral Realtime 做流式 ASR，并引用本文；本文沿用全局延迟 τ，该文改为模型逐位置决定等待或提交
- [[18_Full-Duplex-Floor]]：同样关注对话系统何时接话；本文在 Full-Duplex-Bench 上与 Moshi、PersonaPlex 等对比，该文专门检验这些全双工模型能否因内容主动开口

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 9 条

> we introduce a frame-synchronous turn state head that operates in parallel with the ASR head on shared streaming representations, jointly predicting ASR tokens and fine-grained turn states at the frame level.
> 批注：Claude：核心方法：与 ASR 头并行的帧同步话轮状态头
> — [[xsquare/papers/11_2608.10878_X2-Turn.pdf#page=1|p.1]]

> We define five turn state tokens to represent the evolving state of a user turn:
> 批注：Claude：五种话轮状态 token
> — [[xsquare/papers/11_2608.10878_X2-Turn.pdf#page=2|p.2]]

> totaling approximately 26k hours (14k hours in Chinese and 12k hours in English). This portion of data is used in Stage 1 to strengthen the model’s ASR capability in both languages.
> 批注：Claude：Stage 1 ASR 数据约 26k 小时（中 14k、英 12k）
> — [[xsquare/papers/11_2608.10878_X2-Turn.pdf#page=4|p.4]]

> Among systems with fully reported metrics, X2-Turn therefore achieves the strongest overall ACC, with latency close to that of SoulX-Duplug.
> 批注：Claude：指标完整的系统中整体 ACC 最高
> — [[xsquare/papers/11_2608.10878_X2-Turn.pdf#page=5|p.5]]

> In English, X2-Turn achieves substantially higher complete accuracy (92.10 vs. 77.67) but lower incomplete accuracy (84.60 vs. 88.96), at a latency cost of 20ms.
> 批注：Claude：英文 EasyTurn 与 SoulX-Duplug 对比
> — [[xsquare/papers/11_2608.10878_X2-Turn.pdf#page=5|p.5]]

> Pause TOR is the lowest among all systems in both languages, indicating that X2-Turn takes the floor least often during intra-turn pauses.
> 批注：Claude：Pause TOR 中英文均最低
> — [[xsquare/papers/11_2608.10878_X2-Turn.pdf#page=5|p.5]]

> X2-Turn remains fully streaming and improves Chinese backchannel accuracy over EasyTurn (96.00 vs. 91.00).
> 批注：Claude：中文 backchannel 准确率优于 EasyTurn
> — [[xsquare/papers/11_2608.10878_X2-Turn.pdf#page=5|p.5]]

> This indicates that frame-wise prediction with a short lookahead is competitive with, and often superior to fixed-chunk streaming even be- fore accounting for its lower latency.
> 批注：Claude：帧级流式 ASR 可与固定分块方法竞争
> — [[xsquare/papers/11_2608.10878_X2-Turn.pdf#page=6|p.6]]

> This indicates that our model is robust under tight latency constraints, allowing a suitable op- erating point to be chosen for different latency requirements with little loss in turn-taking accuracy.
> 批注：Claude：延迟收紧时准确率损失小
> — [[xsquare/papers/11_2608.10878_X2-Turn.pdf#page=6|p.6]]
<!-- highlights:end -->

## 摘要（中文）

准确且响应及时的话轮转换（turn-taking）对口语对话系统至关重要：系统必须实时区分用户打断、应当忽略的附和语（backchannel）以及一句话的结束。以往的模块化方法通常在整句或固定分块层面优化话轮状态预测，与连续的话轮状态估计不匹配；而且往往依赖一个辅助 ASR 模型，这限制了响应速度，也增加了系统整体复杂度。

为此，本文提出 X2-Turn，一种基于延迟流建模（delayed-stream modeling）的帧同步话轮状态预测方法。具体来说，我们在预训练的 Voxtral Realtime 模型基础上引入一个帧同步的话轮状态头，它与 ASR 头并行工作、共享流式表征，在帧级别联合预测 ASR token 和细粒度的话轮状态。

在双语 EasyTurn 和 Full-Duplex-Bench 上的实验表明，该方法在话轮状态准确率与决策延迟之间取得了有效的权衡。

## 摘要（原文）

> Accurate and responsive turn-taking is essential for spoken dialogue systems, which must distinguish in real time between user interruptions, backchannels that should be ignored, and the completion of an utterance. Prior modular approaches typically optimize turn state prediction at the utterance or fixed-chunk level, creating a mismatch with the continuous turn state estimate, and often depend on an auxiliary ASR model, which limits responsiveness and increases overall system complexity. Therefore, we present X2-Turn, a frame-synchronous turn state prediction method via delayed-stream modeling. Specifically, building on the pretrained Voxtral Realtime model, we introduce a frame-synchronous turn state head that operates in parallel with the ASR head on shared streaming representations, jointly predicting ASR tokens and fine-grained turn states at the frame level. Experiments on bilingual EasyTurn and Full-Duplex-Bench demonstrate that the proposed method achieves an effective trade-off between turn state accuracy and decision latency.
