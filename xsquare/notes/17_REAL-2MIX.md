---
id: "17"
org: 自变量
short: "REAL-2MIX"
title: "Identity-Faithful Audio-Visual Target Speaker Extraction with REAL-2MIX and VOXBLINK2-AVSE"
aliases: ["REAL-2MIX"]
date: 2026-08-04
category: 语音交互
source: 合作
partners: ["香港中文大学（深圳）"]
authors: ["Peijun Yang", "Zhan Jin", "Xiaoyi Qin", "Ruiyi Gan", "Hao Wang", "Juan Liu", "Ming Li"]
arxiv: "2608.03964"
pdf: "[[xsquare/papers/17_2608.03964_REAL-2MIX_AV-Target-Speaker-Extraction.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "speech", "audio-visual", "speaker-extraction"]
---

# Identity-Faithful Audio-Visual Target Speaker Extraction with REAL-2MIX and VOXBLINK2-AVSE

> [!info] 论文信息
> arXiv [2608.03964](https://arxiv.org/abs/2608.03964) · v1 2026-08-04 · 最新 v2（2026-08-06）
> PDF：[[xsquare/papers/17_2608.03964_REAL-2MIX_AV-Target-Speaker-Extraction.pdf|本地 PDF]]
> 合作单位：香港中文大学（深圳）

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - Real-2mix：真实双人混合 + 同步多视角视频：“We introduce Real-2mix , a Mandarin AV-TSE benchmark of jointly recorded real two-speaker mixtures with synchronized multi-view video.”（Abstract）
> - 基准规模：77 场景、7,598 片段、11.84 小时：“It contains 77 scenes and 7,598 clips (11.84 hours), including 6,042 dual-annotated mixtures.”（Abstract）
> - VoxBlink2-AVSE 规模：“We additionally curate VoxBlink2-AVSE from VoxBlink2, comprising 250,828 synchronized audio–lip-ROI pairs from 28,421 identities and 766.17 hours of speech.”（Abstract）
> - 提取器：冻结 AV-HuBERT 特征 + 逐层调制：“Our extractor uses frozen, 1,280-dimensional projected AV-HuBERT features, target-conditioned training, and layer-wise feature modulation.”（Abstract）
> - 保留身份比例与语句比例：“The retained data cover 25.54% of the original identities but only 2.53% of its utterances and 4.60% of its duration.”（§4.3）
> - 最佳 checkpoint 的 CER 与严格正确率：“On the complete manifest, the best archived checkpoint obtains 0.2261 CER, 82.22% strict output correctness, and 69.53% both-output strict success.”（Abstract）
> - VoxBlink2 训练的结果：“With the same six-block AVSR/FiLM architecture, VoxBlink2 reaches 0.2793 CER, 6.28% wrong-speaker rate, and 74.33% strict correctness.”（§6.5）
> - LRS3 上 FiLM 提升有限：“In the controlled LRS3 pair, FiLM reduces CER from 0.7965 to 0.7456 but raises strict correctness only from 58.36% to 59.01%.”（§6.5）
> - 仅输入端条件化的残留重叠：“Finally, input-only conditioning retains 63.85% residual overlap versus 12.45% with FiLM.”（§6.5）
> - 作者对最佳 checkpoint 的保留意见：“its launch CLI was not fully preserved; the causal effect of the loss requires matched retraining, and all rows are single checkpoints.”（§6.5）

## 一句话总结

发布普通话真实双人重叠音视频基准 Real-2mix 与训练语料 VoxBlink2-AVSE，检验提取器是否按唇形取对人。

## 要解决什么问题

音视频目标说话人提取（AV-TSE）的分离器可能忽略视觉线索，不管提示哪个人都输出声学上占主导的声音。用独立录音人工混合的测试集无法还原目标语音、干扰、混响和噪声同时被录下的真实场景，真实混合又缺少干净的分离源，难以做侵入式评测；逐个评估视觉提示还发现不了“两个输出其实是同一个人”的失败。

## 方法

- Real-2mix 基准（见 §3）：每个场景两名参与者，先录只有 A、只有 B 的独白阶段作为场景内参考，再录同时朗读的重叠段；设 0.5/1.5/3 m 三种距离和三台同步相机；每个 A+B 混合分别用 A、B 的唇部视频各查询一次，要求提示 A 得到 A、提示 B 得到 B
- 人脸跟踪与身份对齐：RetinaFace 与 FAN 提取嘴部 ROI，聚类加 Viterbi 解码修正帧间身份交换，再用 TalkNet 在独白片段上把视觉身份对应到转写标签（见 §3.4、附录 A）
- VoxBlink2-AVSE 训练语料：对 VoxBlink2 先做音视频有效性检查，再用 DNSMOS OVRL 阈值去掉低质量尾部；训练集与开发集说话人不相交（见 §4）
- 提取器：冻结的 AV-HuBERT 视觉分支特征（投影到 1,280 维），在 TF-GridNet 输入端做时频融合，并在每个 GridNet block 之后用逐层 FiLM 重新注入目标信息；可选基于 ECAPA-TDNN 的说话人间隔损失（speaker-margin loss）（见 §5）
- 评测：Qwen3-ASR-1.7B 计算 CER；WeSpeaker ResNet34 计算输出与独白参考的说话人相似度和间隔；先用重叠语音检测（OSD）判定是否残留重叠，再判身份是否正确（OSD-first strict）（见 §6.1–6.4）

## 实验与关键数字

- 基准规模：77 个场景、7,598 个片段（11.84 小时），其中 6,042 个双人标注混合（见 Abstract、Table 1）
- 训练语料：VoxBlink2-AVSE 含 250,828 对数据、28,421 个身份、766.17 小时；保留了原库 25.54% 的身份，但只有 2.53% 的语句（见 §4.3、Table 2）
- 最佳存档 checkpoint（不加说话人损失）：CER 0.2261，严格输出正确率 82.22%，双输出严格成功率 69.53%（见 Table 4、Table 5）
- 训练数据比 FiLM 影响更大：同为六个 GridNet block 的 AVSR/FiLM 架构，用 VoxBlink2 训练得到 CER 0.2793、错误说话人率 6.28%、严格正确率 74.33%；而在 LRS3 上 FiLM 只把严格正确率从 58.36% 提到 59.01%（见 §6.5）
- 仅输入端条件化时残留重叠为 63.85%，加 FiLM 后为 12.45%；作者提醒最佳 checkpoint 的启动配置未完整保留，说话人损失的因果作用需要匹配重训才能确认，且每行都是单个 checkpoint（见 §6.5）

## 局限 / 存疑

## 与其他论文的关系

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 9 条

> We introduce REAL-2MIX, a Mandarin AV- TSE benchmark of jointly recorded real two- speaker mixtures with synchronized multi-view video
> 批注：Claude：Real-2mix：真实双人混合 + 同步多视角视频
> — [[xsquare/papers/17_2608.03964_REAL-2MIX_AV-Target-Speaker-Extraction.pdf#page=1|p.1]]

> It contains 77 scenes and 7,598 clips (11.84 hours), including 6,042 dual- annotated mixtures
> 批注：Claude：基准规模：77 场景、7,598 片段、11.84 小时
> — [[xsquare/papers/17_2608.03964_REAL-2MIX_AV-Target-Speaker-Extraction.pdf#page=1|p.1]]

> We additionally curate VOXBLINK2-AVSE from VoxBlink2, com- prising 250,828 synchronized audio–lip-ROI pairs from 28,421 identities and 766.17 hours of speech
> 批注：Claude：VoxBlink2-AVSE 规模
> — [[xsquare/papers/17_2608.03964_REAL-2MIX_AV-Target-Speaker-Extraction.pdf#page=1|p.1]]

> Our extractor uses frozen, 1,280- dimensional projected AV-HuBERT features, target-conditioned training, and layer-wise fea- ture modulation
> 批注：Claude：提取器：冻结 AV-HuBERT 特征 + 逐层调制
> — [[xsquare/papers/17_2608.03964_REAL-2MIX_AV-Target-Speaker-Extraction.pdf#page=1|p.1]]

> On the complete manifest, the best archived checkpoint obtains 0.2261 CER, 82.22% strict output correctness, and 69.53% both-output strict success.
> 批注：Claude：最佳 checkpoint 的 CER 与严格正确率
> — [[xsquare/papers/17_2608.03964_REAL-2MIX_AV-Target-Speaker-Extraction.pdf#page=1|p.1]]

> The retained data cover 25.54% of the orig- inal identities but only 2.53% of its utterances and 4.60% of its duration.
> 批注：Claude：保留身份比例与语句比例
> — [[xsquare/papers/17_2608.03964_REAL-2MIX_AV-Target-Speaker-Extraction.pdf#page=4|p.4]]

> In the controlled LRS3 pair, FiLM reduces CER from 0.7965 to 0.7456 but raises strict correctness only from 58.36% to 59.01%.
> 批注：Claude：LRS3 上 FiLM 提升有限
> — [[xsquare/papers/17_2608.03964_REAL-2MIX_AV-Target-Speaker-Extraction.pdf#page=7|p.7]]

> its launch CLI was not fully preserved; the causal effect of the loss requires matched retraining, and all rows are single checkpoints.
> 批注：Claude：作者对最佳 checkpoint 的保留意见
> — [[xsquare/papers/17_2608.03964_REAL-2MIX_AV-Target-Speaker-Extraction.pdf#page=8|p.8]]

> Finally, input-only conditioning retains 63.85% residual overlap ver- sus 12.45% with FiLM.
> 批注：Claude：仅输入端条件化的残留重叠
> — [[xsquare/papers/17_2608.03964_REAL-2MIX_AV-Target-Speaker-Extraction.pdf#page=8|p.8]]
<!-- highlights:end -->

## 摘要（中文）

音视频目标说话人提取（AV-TSE）应当输出视频所指示的那位说话人，但分离器可能忽略视觉线索，反复输出声学上占主导的那个声音。

本文提出 Real-2mix：一个普通话 AV-TSE 基准，由真实联合录制的双人混合语音和同步多视角视频组成。每个场景在重叠段之前还录有只有 A 说话、只有 B 说话的阶段，提供场景内的说话人参考。基准包含 77 个场景、7,598 个片段（11.84 小时），其中 6,042 个为双人标注的混合片段；处理后剩下 6,038 个可评测混合和 12,076 条目标说话人评测行。我们还从 VoxBlink2 中整理出 VoxBlink2-AVSE，包含来自 28,421 个身份、共 766.17 小时语音的 250,828 对同步音频–唇部 ROI 数据。

我们的提取器使用冻结的、投影到 1,280 维的 AV-HuBERT 特征，以目标为条件的训练，以及逐层特征调制。我们用 Qwen3-ASR-1.7B 的 CER 评估内容，用 WeSpeaker ResNet34 加重叠语音检测（OSD）评估目标身份。在完整测试清单上，存档的最佳检查点取得 0.2261 的 CER、82.22% 的严格输出正确率和 69.53% 的双输出严格成功率。

## 摘要（原文）

> Audio-visual target speaker extraction should return the speaker indicated by the video, yet a separator can ignore the visual cue and repeatedly output the acoustically dominant voice. We introduce REAL-2MIX, a Mandarin AV-TSE benchmark of jointly recorded real two-speaker mixtures with synchronized multi-view video. Each scene also contains preceding A-only and B-only stages that provide in-scene speaker references. It contains 77 scenes and 7,598 clips (11.84 hours), including 6,042 dual-annotated mixtures. After processing there leave 6,038 evaluable mixtures and 12,076 target-speaker rows. We additionally curate VOXBLINK2-AVSE from VoxBlink2, comprising 250,828 synchronized audio--lip-ROI pairs from 28,421 identities and 766.17 hours of speech. Our extractor uses frozen, 1,280-dimensional projected AV-HuBERT features, target-conditioned training, and layer-wise feature modulation. We jointly evaluate content with Qwen3-ASR-1.7B CER and target identity with WeSpeaker ResNet34 plus Overlapped Speech Detection (OSD). On the complete manifest, the best archived checkpoint obtains 0.2261 CER, 82.22% strict output correctness, and 69.53% both-output strict success.
