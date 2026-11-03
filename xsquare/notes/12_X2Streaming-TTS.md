---
id: "12"
org: 自变量
short: "X2Streaming-TTS"
title: "X2Streaming-TTS: Causal Token-Level Text-to-Speech from Streaming Text with Speech-State Inheritance"
aliases: ["X2Streaming-TTS"]
date: 2026-08-19
category: 语音交互
source: 自变量主导
partners: []
authors: ["Rime Wen", "Zehan Liu", "Shawn Qin", "Lights Shi", "Roy Gan", "Hao Wang", "Qian Wang"]
arxiv: "2608.18661"
pdf: "[[xsquare/papers/12_2608.18661_X2Streaming-TTS.pdf]]"
code: "https://github.com/X-Square-Robot/X2Streaming-TTS"
project: "https://x-square-robot.github.io/X2Streaming-TTS/"
huggingface: ["https://huggingface.co/x-square-robot/X2Streaming-TTS-1.7B"]
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "speech", "tts", "streaming"]
---

# X2Streaming-TTS: Causal Token-Level Text-to-Speech from Streaming Text with Speech-State Inheritance

> [!info] 论文信息
> arXiv [2608.18661](https://arxiv.org/abs/2608.18661) · v1 2026-08-19
> PDF：[[xsquare/papers/12_2608.18661_X2Streaming-TTS.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/X2Streaming-TTS) · [项目页](https://x-square-robot.github.io/X2Streaming-TTS/) · [X2Streaming-TTS-1.7B](https://huggingface.co/x-square-robot/X2Streaming-TTS-1.7B)

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 因果承诺：不确定性感知缓冲与容量自适应分段：“To handle uncertain prefixes, we introduce causal commitment, which keeps ambiguous expressions provisional through uncertainty-aware buffering and performs capacity-adaptive, punctuation-aware segmentation.”（Abstract）
> - 因果语音状态继承：跨段传递 Code2Wav 与 Talker 状态：“To preserve acoustic continuity, we further introduce causal speech-state inheritance, which carries the complete Code2Wav state and selected historical Talker states across segment boundaries.”（Abstract）
> - 与离线 Qwen3-TTS 对比：8 个条件中 3 个更好，最大退化 0.62：“Our method achieves lower recognition error than the offline reference in 3 of the 8 conditions, while its largest degradation among the remaining 5 conditions is 0.62 percentage points.”（§4.2）
> - 流式系统中 8 个条件里 6 个最低：“Among the evaluated streaming systems, our method achieves the lowest error in 6 of the 8 conditions.”（§4.2）
> - 预算利用率与 hard-cap 比例：“Compared with punctuation-only segmentation, our controller increases utilization from 11.77% to 76.93%. Compared with the fixed-window policy, it reduces the hard-cap rate from 87.13% to 0.54%.”（§4.3）
> - 边界 F1 0.952，略高于 SaT-3L：“Our joint text–acoustic estimator achieves an F1 score of 0.952, with a miss rate of 0.057 and a false-split rate of 0.036, slightly outperforming SaT-3L at an F1 score of 0.940.”（§4.3）
> - 边界连续性：五列最好，PBD 0.1092：“Our method achieves the best value in all five columns of Table 3 . It obtains a PBD of 0.1092, with a bootstrap interval disjoint from that of the nearest comparator, FireRedTTS-2 at 0.1915.”（§4.4）
> - 符号与前缀歧义：CER 2.00%、正确读法 73.3%：“our method achieves a CER of 2.00% and a fully correct reading rate of 73.3%, compared with 6.65% and 40.0%, respectively, for the strongest comparator.”（§4.5）
> - 延迟测量硬件：单张 RTX 5090：“Serving latency is measured separately on one RTX 5090 using the deployed BF16 engine.”（§4.1）
> - TTFT 随并发变化：15.8 ms 到 260.8 ms：“Median TTFT increases from 15.8 ms for a single request to 38.5, 50.2, 76.3, 118.6, and 260.8 ms at concurrency levels 8, 16, 32, 64, and 128, respectively.”（§4.6）

## 一句话总结

基于 Qwen3-TTS 的严格因果 token 级流式 TTS，用因果承诺管读音与分段，用语音状态继承管跨段连续。

## 要解决什么问题

许多流式 TTS 要等整句文本才开始合成，其实只是伪流式；真正的 token 级合成必须在文本前缀不确定时做出无法撤回的发声决定。具体难点有三：数字、单位、符号的读音可能被后到的字符改变；纯标点分段太碎、固定窗口又会在非语言边界处切断；每段从静默重新起步会在段边界留下可感知的音高、音色断裂。

## 方法

- 零前瞻的依据：文本信息密集而语音在时间上冗余，每个文本 token 对应多步声学解码（声学/文本扩展比 ρ），发声本身就为后续 token 的到达争取了时间；骨干选用 Qwen3-TTS，因为其 Talker 输出可计数的离散声学 token、Code2Wav 的解码状态可迁移、KV cache 剩余容量可观测（见 §3）
- 因果承诺（causal commitment）（见 §3.1）：
  1. 不确定性感知的语义就绪（uncertainty-aware semantic readiness）：用确定性闭合规则把读音仍可能被后续 token 改变的数字、单位、符号等留在待定后缀中，读音确定后整体规范化并原子释放，释放后不再修改；
  2. 容量自适应、标点感知分段（capacity-adaptive punctuation-aware segmentation, CAPS）：用在线 EMA 估计扩展比，预测当前段可容纳的文本 token 数，遇到满足阈值的句末/从句/弱标点或达到容量硬上限时关闭当前段，并给出分段数上界（Theorem 1）。
- 因果语音状态继承（causal speech-state inheritance）：跨段通过两条独立路径传递完整的 Code2Wav 状态（KV cache、卷积状态等）和末尾 H 个 Talker 状态；固定的因果注意力先验让未来位置权重为零，再以有界增益做残差注入；前一段未通过健康检查时清空继承状态（见 §3.2）
- 推理流程：流式前端只释放已就绪的文本，Talker 生成声学 token，Code2Wav 流式输出波形供即时播放（见 Figure 1）

## 实验与关键数字

- 可懂度（SEED-TTS-Eval、MiniMax 与长文本外推，Table 1）：与同一权重的离线 Qwen3-TTS 相比，8 个条件中有 3 个误差更低，其余条件最大退化 0.62 个百分点；在所评测的流式系统中，8 个条件里有 6 个误差最低
- 因果承诺（Table 2）：相比纯标点分段，预算利用率从 11.77% 提升到 76.93%；相比固定窗口，hard-cap 比例从 87.13% 降到 0.54%；边界 F1 为 0.952，略高于可看未来子词的 SaT-3L（0.940）
- 语音状态继承（Table 3）：五列指标全部最好，边界不连续度 PBD 为 0.1092，其 bootstrap 区间与最接近的 FireRedTTS-2（0.1915）不重叠
- 符号与前缀歧义（Table 4）：CER 2.00%、完全正确读法 73.3%，最强对比系统分别为 6.65% 和 40.0%
- 延迟（单张 RTX 5090）：单请求 TTFT 中位数 15.8 ms，128 路并发时为 260.8 ms（见 §4.6）

## 局限 / 存疑

## 与其他论文的关系

- [[13_X2-NativeCursor]]：同样面向基于 Qwen3-TTS 的增量文本流式 TTS，代码发布在本文的 X2Streaming-TTS 仓库中；该文解决在线文本进度跟踪
- [[19_DualTrack]]：同样以 Qwen3-TTS 为语音骨干，用于语音–手势联合生成

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 10 条

> To handle uncertain prefixes, we introduce causal commitment, which keeps ambiguous expressions provisional through uncertainty-aware buffering and performs capacity-adaptive, punctuation-aware segmentation.
> 批注：Claude：因果承诺：不确定性感知缓冲与容量自适应分段
> — [[xsquare/papers/12_2608.18661_X2Streaming-TTS.pdf#page=1|p.1]]

> To preserve acoustic continuity, we further introduce causal speech-state inheritance, which carries the complete Code2Wav state and selected historical Talker states across segment boundaries.
> 批注：Claude：因果语音状态继承：跨段传递 Code2Wav 与 Talker 状态
> — [[xsquare/papers/12_2608.18661_X2Streaming-TTS.pdf#page=1|p.1]]

> Serving latency is measured separately on one RTX 5090 using the deployed BF16 engine.
> 批注：Claude：延迟测量硬件：单张 RTX 5090
> — [[xsquare/papers/12_2608.18661_X2Streaming-TTS.pdf#page=7|p.7]]

> Our method achieves lower recognition error than the offline reference in 3 of the 8 conditions, while its largest degradation among the remaining 5 conditions is 0.62 percentage points.
> 批注：Claude：与离线 Qwen3-TTS 对比：8 个条件中 3 个更好，最大退化 0.62
> — [[xsquare/papers/12_2608.18661_X2Streaming-TTS.pdf#page=7|p.7]]

> Among the evaluated streaming systems, our method achieves the lowest error in 6 of the 8 conditions.
> 批注：Claude：流式系统中 8 个条件里 6 个最低
> — [[xsquare/papers/12_2608.18661_X2Streaming-TTS.pdf#page=8|p.8]]

> Compared with punctuation-only segmentation, our controller increases utilization from 11.77% to 76.93%. Compared with the fixed-window policy, it reduces the hard-cap rate from 87.13% to 0.54%.
> 批注：Claude：预算利用率与 hard-cap 比例
> — [[xsquare/papers/12_2608.18661_X2Streaming-TTS.pdf#page=8|p.8]]

> Our joint text– acoustic estimator achieves an F1 score of 0.952, with a miss rate of 0.057 and a false-split rate of 0.036, slightly outperforming SaT-3L at an F1 score of 0.940
> 批注：Claude：边界 F1 0.952，略高于 SaT-3L
> — [[xsquare/papers/12_2608.18661_X2Streaming-TTS.pdf#page=8|p.8]]

> Our method achieves the best value in all five columns of Table 3. It obtains a PBD of 0.1092, with a bootstrap interval disjoint from that of the nearest comparator, FireRedTTS-2 at 0.1915
> 批注：Claude：边界连续性：五列最好，PBD 0.1092
> — [[xsquare/papers/12_2608.18661_X2Streaming-TTS.pdf#page=8|p.8]]

> our method achieves a CER of 2.00% and a fully correct reading rate of 73.3%, compared with 6.65% and 40.0%, respectively, for the strongest comparator.
> 批注：Claude：符号与前缀歧义：CER 2.00%、正确读法 73.3%
> — [[xsquare/papers/12_2608.18661_X2Streaming-TTS.pdf#page=9|p.9]]

> Median TTFT increases from 15.8 ms for a single request to 38.5, 50.2, 76.3, 118.6, and 260.8 ms at concurrency levels 8, 16, 32, 64, and 128, respectively.
> 批注：Claude：TTFT 随并发变化：15.8 ms 到 260.8 ms
> — [[xsquare/papers/12_2608.18661_X2Streaming-TTS.pdf#page=9|p.9]]
<!-- highlights:end -->

## 摘要（中文）

流式文本转语音（TTS）对低延迟口语对话系统至关重要，但许多系统要等到整句文本才开始合成，因此只是“伪流式”。真正的 token 级合成必须从不确定的文本前缀生成语音，同时在上下文有限的条件下，让无限延伸的语音流在听感上保持连续。

本文提出 X2Streaming-TTS，一个因果 TTS 框架：它接收异步到达的文本 token 并输出语音，不访问任何未来输入。为处理不确定前缀，我们提出因果承诺（causal commitment）：通过不确定性感知的缓冲让有歧义的表达保持暂定，并执行容量自适应、标点感知的分段。为保持声学连续性，我们进一步提出因果语音状态继承（causal speech-state inheritance）：跨分段边界传递完整的 Code2Wav 状态和选定的历史 Talker 状态。配合注意力先验约束，它屏蔽了对未来位置的访问，同时保留有界的声学上下文。

实验表明，X2Streaming-TTS 在大多数主观和客观指标上优于现有伪流式模型。进一步分析显示，因果承诺使在线分段更稳定，减少了因上下文不足导致的失败；语音状态继承改善了边界连续性，且不损害自然度和说话人身份。由此，X2Streaming-TTS 实现了严格的 token 级合成，质量与所评测的离线基线相当；单请求时首个音频 token 时间（TTFT）中位数为 15.8 ms，128 路并发时 TTFT 中位数为 260.8 ms。代码已公开：https://github.com/X-Square-Robot/X2Streaming-TTS 。

## 摘要（原文）

> Streaming text-to-speech is essential for low-latency spoken dialogue systems, yet many systems wait for sentence-level text and are therefore only pseudo-streaming. True token-level synthesis must generate speech from uncertain prefixes while maintaining perceptual continuity over an unbounded stream with bounded context. We present X2Streaming-TTS, a causal TTS framework that consumes asynchronously arriving text tokens and emits speech without accessing future input. To handle uncertain prefixes, we introduce causal commitment, which keeps ambiguous expressions provisional through uncertainty-aware buffering and performs capacity-adaptive, punctuation-aware segmentation. To preserve acoustic continuity, we further introduce causal speech-state inheritance, which carries the complete Code2Wav state and selected historical Talker states across segment boundaries. Together with an attention prior constraint, it blocks access to future positions while retaining bounded acoustic context. Experiments show that X2Streaming-TTS outperforms existing pseudo-streaming models on most subjective and objective metrics. Further analysis shows that causal commitment stabilizes online segmentation and reduces failures caused by insufficient context, while speech-state inheritance improves boundary continuity without degrading naturalness or speaker identity. X2Streaming-TTS thus achieves strict token-level synthesis with quality comparable to the evaluated offline baselines, a median time to first audio token (TTFT) of 15.8 ms for a single request, and a median TTFT of 260.8 ms at 128 concurrent requests. Our implementation is publicly available at this https URL .
