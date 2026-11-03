---
id: "14"
org: 自变量
short: "X2Streaming-ASR"
title: "X2Streaming-ASR: wait when uncertain, emit when ready for streaming ASR"
aliases: ["X2Streaming-ASR"]
date: 2026-09-08
category: 语音交互
source: 自变量主导
partners: []
authors: ["Zhiwei Lin", "Kaiqi Fu", "Rime Wen", "Zehan Liu", "Shawn Qin", "Roy Gan", "Hao Wang"]
arxiv: "2609.08672"
pdf: "[[xsquare/papers/14_2609.08672_X2Streaming-ASR.pdf]]"
code: "https://github.com/X-Square-Robot/X2Streaming-ASR"
project: ""
huggingface: ["https://huggingface.co/x-square-robot/X2Streaming-ASR-4B-1009"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "speech", "asr", "streaming"]
---

# X2Streaming-ASR: wait when uncertain, emit when ready for streaming ASR

> [!info] 论文信息
> arXiv [2609.08672](https://arxiv.org/abs/2609.08672) · v1 2026-09-08 · 最新 v4（2026-10-12）
> PDF：[[xsquare/papers/14_2609.08672_X2Streaming-ASR.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/X2Streaming-ASR) · [X2Streaming-ASR-4B-1009](https://huggingface.co/x-square-robot/X2Streaming-ASR-4B-1009)

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 核心思路：分解为何时提交与提交什么：“We propose X2Streaming-ASR, which decomposes streaming recognition into when to commit and what to commit.”（Abstract）
> - 三阶段训练流程：“Its three-stage training procedure first establishes streaming recognition ability, then warm-starts the commit policy with automatically probed trajectories, and finally refines the policy using character-level, segment-assigned group-relative rewards for recognition accuracy and latency.”（Abstract）
> - 基于 Voxtral Realtime 的架构：“X2Streaming-ASR is built on Voxtral Realtime, which consists of a causal audio encoder, an adapter, and a decoder-only language model.”（§2.1）
> - 奖励兼顾错误与延迟，错误优先：“The reward combines errors and latency, with errors taking priority, so the model waits at ambiguities and commits once the evidence is sufficient.”（§1）
> - 十个测试集上平均提交延迟最低：“Across ten Chinese and English test sets, X2Streaming-ASR attains the lowest mean commit latency relative to forced-aligned endpoints,”（Abstract）
> - 中文 AISHELL-1/3 上优于开源模型与 Uni-ASR：“On Chinese, it outperforms the open-source models and Uni-ASR on AISHELL-1 and AISHELL-3.”（§3.2）
> - 英文各测试集排第一或第二：“On English, X2Streaming-ASR ranks first or second relative to the open-source models on every set.”（§3.2）
> - AISHELL-1：最终模型 CER 1.53 / 32 ms / P95 320 ms，Stage 2 为 6.27：“Proposed Streaming 1.53 32 320 Stage 2 Streaming 6.27 4 80”（Table 3）
> - 句级奖励学到全局等待：“Sentence-level rewards therefore learn a global wait, sacrificing latency for better recognition.”（§3.4）
> - 延迟从数百毫秒降到数十毫秒：“Experiments show that mean latency drops from hundreds of milliseconds to tens of milliseconds, while recognition accuracy stays in the first tier.”（§4）

## 一句话总结

把流式 ASR 拆成“何时提交”和“提交什么”，用 GRPO 学会不确定时等待、有把握就输出，平均延迟降到几十毫秒。

## 要解决什么问题

实时语音助手和全双工对话需要既准确又低提交延迟的部分转写。现有方法用固定分块、前瞻或全局延迟，或把输出时间往声学边界拉，都是与位置无关的旋钮：调晚则每个位置都变慢，调早则每个位置都承担同样的出错风险；基于修正的方法又不满足单遍硬提交。而一个字在声学边界之后还需要多少未来上下文，其实因位置而异。

## 方法

- 架构：基于 Voxtral Realtime（因果音频编码器、adapter、decoder-only 语言模型），去掉其全局延迟 τ；语言模型在“听”状态下每读入一个 80 ms 音频 token 就做等待/输出（wait/emit）二元决策，选择 emit 后自回归生成文本直到 Eos，再回到听状态（见 §2.1）
- 三阶段训练（见 §2.2）：
  1. Stage 1：训练只输出“声学上已结束”的字符的流式识别器；
  2. Stage 2：用 Stage 1 模型从左到右探测（probe）每个字的可提交时间，作为提交策略的监督热启动，探测时间不当作真值；
  3. Stage 3：用 GRPO 精调提交策略，奖励同时计入识别错误和延迟，错误优先。
- 提交段级的信用分配（commit-segment credit assignment）：在同一参考字符上比较组内各轨迹，把优势累加到产生或漏掉该字的提交段上，避免句级奖励把有用和多余的等待一并强化（见 §2.2）
- 其他细节：Stage 1/2 混入离线整句识别，同一 checkpoint 可流式也可离线识别；Stage 3 冻结编码器和 adapter，只用 LoRA 微调语言模型（见 §2.2、§3.1）

## 实验与关键数字

- 评测：中文 AISHELL-1/2/3、WenetSpeech meeting/net，英文 LibriSpeech test-clean/other、GigaSpeech clean、VoxPopuli、TED-LIUM，共十个测试集；对比 Zipformer、Paraformer、X-ASR、Confucius4-R2T2 和 Uni-ASR（Uni-ASR 只引用论文 CER）（见 §3.1、Table 1）
- 延迟：十个测试集上相对强制对齐端点的平均提交延迟都是最低；结论称平均延迟从数百毫秒降到数十毫秒，识别准确率仍在第一梯队（见 Table 1、§4）
- 准确率：中文在 AISHELL-1、AISHELL-3 上优于开源模型和 Uni-ASR；英文在每个测试集上都排开源模型第一或第二，在 GigaSpeech clean、VoxPopuli、TED-LIUM 上达到最优（见 §3.2）
- AISHELL-1 消融（Table 3）：最终模型 CER 1.53、平均延迟 32 ms、P95 320 ms；只做 Stage 2 监督热启动时 CER 为 6.27；改用句级奖励的 GRPO 变体学到的是全局等待，以延迟换准确率（见 §3.4）

## 局限 / 存疑

## 与其他论文的关系

- [[11_X2-Turn]]：本文引用 X2-Turn 作为把流式 ASR 引入话轮判断的工作；两者都基于 Voxtral Realtime，X2-Turn 沿用全局延迟 τ，本文改为模型逐位置决定等待或提交

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 9 条

> We propose X2Streaming-ASR, which decomposes streaming recognition into when to commit and what to com- mit.
> 批注：Claude：核心思路：分解为何时提交与提交什么
> — [[xsquare/papers/14_2609.08672_X2Streaming-ASR.pdf#page=1|p.1]]

> Its three-stage training procedure first establishes streaming recognition ability, then warm-starts the commit policy with auto- matically probed trajectories, and finally refines the policy using character-level, segment-assigned group-relative rewards for recog- nition accuracy and latency.
> 批注：Claude：三阶段训练流程
> — [[xsquare/papers/14_2609.08672_X2Streaming-ASR.pdf#page=1|p.1]]

> Across ten Chinese and English test sets, X2Streaming-ASR attains the lowest mean commit latency rel- ative to forced-aligned endpoints,
> 批注：Claude：十个测试集上平均提交延迟最低
> — [[xsquare/papers/14_2609.08672_X2Streaming-ASR.pdf#page=1|p.1]]

> X2Streaming-ASR is built on Voxtral Realtime, which consists of a causal audio encoder, an adapter, and a decoder- only language model
> 批注：Claude：基于 Voxtral Realtime 的架构
> — [[xsquare/papers/14_2609.08672_X2Streaming-ASR.pdf#page=2|p.2]]

> On Chinese, it outperforms the open-source models and Uni-ASR on AISHELL-1 and AISHELL- 3
> 批注：Claude：中文 AISHELL-1/3 上优于开源模型与 Uni-ASR
> — [[xsquare/papers/14_2609.08672_X2Streaming-ASR.pdf#page=3|p.3]]

> On English, X2Streaming-ASR ranks first or second relative to the open-source models on every set.
> 批注：Claude：英文各测试集排第一或第二
> — [[xsquare/papers/14_2609.08672_X2Streaming-ASR.pdf#page=3|p.3]]

> Proposed Streaming 1.53 32 320 Stage 2 Streaming 6.27 4 80
> 批注：Claude：AISHELL-1：最终模型 CER 1.53 / 32 ms / P95 320 ms，Stage 2 为 6.27
> — [[xsquare/papers/14_2609.08672_X2Streaming-ASR.pdf#page=4|p.4]]

> Sentence-level rewards therefore learn a global wait, sacrificing latency for better recognition.
> 批注：Claude：句级奖励学到全局等待
> — [[xsquare/papers/14_2609.08672_X2Streaming-ASR.pdf#page=4|p.4]]

> Experiments show that mean latency drops from hundreds of milliseconds to tens of milliseconds, while recog- nition accuracy stays in the first tier.
> 批注：Claude：延迟从数百毫秒降到数十毫秒
> — [[xsquare/papers/14_2609.08672_X2Streaming-ASR.pdf#page=4|p.4]]
<!-- highlights:end -->

## 摘要（中文）

面向实时语音助手和全双工对话的流式自动语音识别（ASR），必须以较低的提交延迟给出准确的部分转写。现有系统通常使用固定的分块大小、前瞻或目标延迟，或者鼓励在估计的声学边界附近输出。这些方法都没有在“单遍、硬提交”的约束下，直接优化每个输出位置应当额外使用多少上下文。

本文提出 X2Streaming-ASR，把流式识别分解为“何时提交”和“提交什么”两个问题。其三阶段训练流程先建立流式识别能力，再用自动探测得到的轨迹为提交策略做热启动，最后用字符级、按分段分配的组相对奖励（兼顾识别准确率与延迟）进一步优化策略。

在十个中英文测试集上，X2Streaming-ASR 相对强制对齐端点的平均提交延迟最低：中文字符为 32–109 ms，英文单词为 12–85 ms，同时识别准确率与现有系统相当。代码已公开：https://github.com/X-Square-Robot/X2Streaming-ASR 。

## 摘要（原文）

> Streaming automatic speech recognition (ASR) for real-time voice agents and full-duplex dialogue must provide accurate partial transcripts with low commit latency. Existing systems commonly use a fixed chunk size, look-ahead, or target delay, or encourage emissions near estimated acoustic boundaries. These approaches do not directly optimize how much additional context to use at each output position under a single-pass, hard-commit constraint. We propose X2Streaming-ASR, which decomposes streaming recognition into when to commit and what to commit. Its three-stage training procedure first establishes streaming recognition ability, then warm-starts the commit policy with automatically probed trajectories, and finally refines the policy using character-level, segment-assigned group-relative rewards for recognition accuracy and latency. Across ten Chinese and English test sets, X2Streaming-ASR attains the lowest mean commit latency relative to forced-aligned endpoints, 32--109ms on Chinese characters and 12--85ms on English words, while recognition accuracy remains comparable to existing this http URL is available at this https URL.
