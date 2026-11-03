---
id: "13"
org: 自变量
short: "X2-NativeCursor"
title: "X2-NativeCursor: Native-Token Text Progress Tracking for Incremental-Text Streaming Codec TTS"
aliases: ["X2-NativeCursor"]
date: 2026-09-09
category: 语音交互
source: 自变量主导
partners: []
authors: ["Zehan Liu", "Carl Chen", "Rime Wen", "Kaiqi Fu", "Altman Lin", "Shawn Qin", "Lights Shi", "Roy Gan", "Hao Wang", "Qian Wang"]
arxiv: "2609.09677"
pdf: "[[xsquare/papers/13_2609.09677_X2-NativeCursor.pdf]]"
code: "https://github.com/X-Square-Robot/X2Streaming-TTS"
project: ""
huggingface: ["https://huggingface.co/x-square-robot/X2-NativeCursor-Qwen3TTS-12Hz"]
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "speech", "tts", "streaming"]
---

# X2-NativeCursor: Native-Token Text Progress Tracking for Incremental-Text Streaming Codec TTS

> [!info] 论文信息
> arXiv [2609.09677](https://arxiv.org/abs/2609.09677) · v1 2026-09-09
> PDF：[[xsquare/papers/13_2609.09677_X2-NativeCursor.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/X2Streaming-TTS) · [X2-NativeCursor-Qwen3TTS-12Hz](https://huggingface.co/x-square-robot/X2-NativeCursor-Qwen3TTS-12Hz)

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 核心思路：波形解码前从原生语音 token 跟踪进度，不改生成器：“We propose X2-NativeCursor, a lightweight observer that tracks progress from native speech tokens before waveform decoding without changing the TTS generator.”（Abstract）
> - 输出规则：游标永不后退：“A separate output rule converts revisable position estimates into a cursor that never moves backward.”（Abstract）
> - TNPlan 读音未定时等待释放：“If later input may change the reading of a number, unit, or symbol, TNPlan waits before releasing its labels.”（§2.2）
> - 主结果：MAE 0.151（80 ms）vs. 1.253（320 ms）：“Mean absolute error against an automatic reference is 0.151 Chinese characters with 80-ms lookahead, versus 1.253 characters with 320-ms lookahead for an online waveform baseline.”（Abstract）
> - 中英文 MAE 分别降低约 88% 和 44%：“Compared with the online waveform baseline, Chinese and English MAE are lower by about 88% and 44%, respectively.”（§3.2）
> - 第二参考 MMS-FA 下 MAE 0.206：“X2-NativeCursor remains ahead of the online waveform baseline and the two learned native-token baselines, with a Chinese-character MAE of 0.206.”（§3.2）
> - 参数量与对齐 RTF：“Our observer has 2.166M parameters and an alignment real-time factor of 0.0180, versus 0.3598 for this baseline.”（§1）
> - 消融：去掉文本编码器 MAE 大幅上升：“Removing the text encoder raises MAE from 0.343 to 1.465 and worsens all four groups.”（§3.3）
> - 局限：对未见音色敏感：“With three voices not used in training, average MAE rises to 0.788, with large differences between voices (0.320–1.213).”（§3.3）
> - 迁移到 CosyVoice2：MAE 0.284：“The run selected by development MAE achieves a Chinese-character MAE of 0.284 (95% CI: 0.237–0.343).”（§3.5）

## 一句话总结

不改动 TTS 生成器，在波形解码前直接从原生语音 token 在线估计“已经说到原文哪个字”，游标永不后退。

## 要解决什么问题

增量文本流式 TTS 中文本先于语音到达，仅凭文本到达无法知道已经说到哪里，而同步高亮、打断处理、对话历史更新都需要这个进度。基于波形的对齐要么需要完整音频，要么得等波形解码后再用声学编码器重新处理，增加等待和计算；把对齐内置到生成器里则要改架构、重新训练。

## 方法

- 独立观察器（observer）：只读取 TTS 每一步产生的原生语音 token（native speech tokens），TTS 生成器、语音分词器和波形解码器都保持不变；每个骨干单独训练一个观察器（见 §2.1、§2.5）
- 规范化计划 TNPlan（normalization plan）：把输入文本转成口语标签（spoken labels）并记录各自对应的原文跨度；数字、单位、符号的读音可能被后续输入改变时，先等待再释放标签（例如中文“99%”的读法是百分号在前、数字在后，所有标签共享“99%”的原文跨度）（见 §2.2）
- 编码与局部匹配：文本编码器（标签嵌入加因果卷积）与原生 token 编码器（四个膨胀卷积块、固定前瞻帧数，Qwen3-TTS 主设定为一帧即 80 ms）提供特征；局部匹配器（local matcher）只在上一位置附近的 7 个偏移上打分，用偏移分布的期望更新位置（见 §2.3、§2.4）
- 单调输出：内部位置估计可以后退或跳过标签，对外发布的游标取已到达的最远位置并映射回原文跨度，因此永不后退（见 §2.4）
- 训练：以 Qwen3-ForcedAligner 给出的标签起点时间为参考，损失为偏移交叉熵加内容损失和速率损失（见 §2.5）

## 实验与关键数字

- 主结果（Qwen3-TTS，Qwen3-ForcedAligner 作自动参考，Table 1）：中文 MAE 为 0.151 个字（80 ms 前瞻），在线波形基线为 1.253（320 ms 前瞻）；中文、英文 MAE 分别降低约 88% 和 44%
- 换用训练中未用到的 MMS-FA 作参考：中文 MAE 0.206，仍领先在线波形基线和两个学习式原生 token 基线（见 §3.2）
- 开销：观察器 2.166M 参数，对齐 RTF 0.0180，基线为 0.3598（见 §1、§3.4）
- 消融与局限（Table 2）：去掉文本编码器后 MAE 从 0.343 升到 1.465；换用三个训练未见的音色时平均 MAE 升到 0.788，说明对合成音色变化敏感
- 迁移（§3.5）：在 CosyVoice2 上重训观察器，中文 MAE 0.284（95% CI: 0.237–0.343）

## 局限 / 存疑

## 与其他论文的关系

- [[12_X2Streaming-TTS]]：代码发布在同一个 X2Streaming-TTS 仓库，同样基于 Qwen3-TTS 做增量文本流式 TTS；TNPlan“读音确定后再释放”与该文的因果承诺思路相近

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 9 条

> We propose X2-NativeCursor, a lightweight observer that tracks progress from native speech tokens before waveform decoding without changing the TTS generator.
> 批注：Claude：核心思路：波形解码前从原生语音 token 跟踪进度，不改生成器
> — [[xsquare/papers/13_2609.09677_X2-NativeCursor.pdf#page=1|p.1]]

> A separate output rule converts revisable position estimates into a cursor that never moves backward.
> 批注：Claude：输出规则：游标永不后退
> — [[xsquare/papers/13_2609.09677_X2-NativeCursor.pdf#page=1|p.1]]

> Mean absolute error against an automatic reference is 0.151 Chinese characters with 80-ms lookahead, versus 1.253 characters with 320-ms lookahead for an online waveform baseline.
> 批注：Claude：主结果：MAE 0.151（80 ms）vs. 1.253（320 ms）
> — [[xsquare/papers/13_2609.09677_X2-NativeCursor.pdf#page=1|p.1]]

> Our observer has 2.166M parameters and an alignment real-time factor of 0.0180, versus 0.3598 for this baseline.
> 批注：Claude：参数量与对齐 RTF
> — [[xsquare/papers/13_2609.09677_X2-NativeCursor.pdf#page=2|p.2]]

> If later input may change the reading of a number, unit, or symbol, TNPlan waits before releasing its labels.
> 批注：Claude：TNPlan 读音未定时等待释放
> — [[xsquare/papers/13_2609.09677_X2-NativeCursor.pdf#page=3|p.3]]

> Compared with the online waveform baseline, Chinese and English MAE are lower by about 88% and 44%, respectively.
> 批注：Claude：中英文 MAE 分别降低约 88% 和 44%
> — [[xsquare/papers/13_2609.09677_X2-NativeCursor.pdf#page=5|p.5]]

> X2-NativeCursor remains ahead of the online waveform baseline and the two learned native-token baselines, with a Chinese-character MAE of 0.206.
> 批注：Claude：第二参考 MMS-FA 下 MAE 0.206
> — [[xsquare/papers/13_2609.09677_X2-NativeCursor.pdf#page=5|p.5]]

> Removing the text encoder raises MAE from 0.343 to 1.465 and worsens all four groups.
> 批注：Claude：消融：去掉文本编码器 MAE 大幅上升
> — [[xsquare/papers/13_2609.09677_X2-NativeCursor.pdf#page=5|p.5]]

> The run selected by development MAE achieves a Chinese-character MAE of 0.284 (95% CI: 0.237–0.343).
> 批注：Claude：迁移到 CosyVoice2：MAE 0.284
> — [[xsquare/papers/13_2609.09677_X2-NativeCursor.pdf#page=6|p.6]]
<!-- highlights:end -->

## 摘要（中文）

增量文本流式文本转语音（TTS）需要在线跟踪文本进度，用于同步高亮、打断处理和对话历史更新。输入文本在被说出之前就已到达，因此仅凭文本到达无法判断语音进度。现有基于波形的对齐方法要么需要完整音频，要么在流式过程中额外增加声学处理。

本文提出 X2-NativeCursor：一个轻量级观察器，在波形解码之前直接从原生语音 token 跟踪进度，且不改变 TTS 生成器。它的规范化计划把口语标签与其对应的原文片段关联起来。文本编码器和原生 token 编码器为一个局部匹配器提供特征，由匹配器估计当前的标签位置。另一条独立的输出规则把可修正的位置估计转换为永不后退的游标。

以自动参考为基准，在 80 ms 前瞻下平均绝对误差为 0.151 个汉字，而在线波形基线在 320 ms 前瞻下为 1.253 个汉字。相对该基线，对齐实时率也从 0.3598 降到 0.0180。换用第二种自动对齐参考时，跟踪误差依然更低。我们在 Qwen3-TTS 上评测 X2-NativeCursor，并通过为每个骨干单独训练观察器，验证了它向 CosyVoice2 的迁移。代码已公开：https://github.com/X-Square-Robot/X2Streaming-TTS 。

## 摘要（原文）

> Incremental-text streaming text-to-speech (TTS) needs online text progress tracking for synchronized highlighting, interruption handling, and dialogue-history updates. Input text arrives before it is spoken, so text arrival alone cannot indicate speech progress. Existing waveform-based alignment requires complete audio or adds acoustic processing during streaming. We propose X2-NativeCursor, a lightweight observer that tracks progress from native speech tokens before waveform decoding without changing the TTS generator. Its normalization plan links spoken labels to their original-text spans. Text and native-token encoders feed a local matcher that estimates the current label position. A separate output rule converts revisable position estimates into a cursor that never moves backward. Mean absolute error against an automatic reference is 0.151 Chinese characters with 80-ms lookahead, versus 1.253 characters with 320-ms lookahead for an online waveform baseline. Alignment real-time factor also decreases from 0.3598 to 0.0180 relative to this baseline. Lower tracking error is retained under a second automatic alignment reference. We evaluate X2-NativeCursor on Qwen3-TTS and validate its adaptation to CosyVoice2 by training a separate observer for each backbone. Code is publicly available at this https URL.
