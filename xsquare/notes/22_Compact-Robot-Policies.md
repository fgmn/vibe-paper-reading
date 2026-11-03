---
id: "22"
org: 自变量
short: "Compact-Robot-Policies"
title: "Compact Robot Policies Need Fine-Grained Visual Representations"
aliases: ["Compact-Robot-Policies"]
date: 2026-10-06
category: 策略学习
source: 合作
partners: ["KTH"]
authors: ["Nanhe Chen", "Runqiu Yang", "Jiawei Tang", "Sichao Liu", "Yuquan Wang"]
arxiv: "2610.08183"
pdf: "[[xsquare/papers/22_2610.08183_Compact-Robot-Policies-Fine-Grained-Visual-Representations.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "visual-representation", "policy-learning"]
---

# Compact Robot Policies Need Fine-Grained Visual Representations

> [!info] 论文信息
> arXiv [2610.08183](https://arxiv.org/abs/2610.08183) · v1 2026-10-06
> PDF：[[xsquare/papers/22_2610.08183_Compact-Robot-Policies-Fine-Grained-Visual-Representations.pdf|本地 PDF]]
> 合作单位：KTH

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - CoRP 仅 48.9M 参数：“CoRP has only 48.9M parameters and four standard components: a DINOv2-initialized ViT-S/14 visual encoder”（§1）
> - LIBERO 97.0%，RoboTwin 2.0 75.78%/73.36%：“It reaches 97.0% on LIBERO and 75.78%/73.36% on RoboTwin 2.0 Clean/Randomized”（Abstract）
> - 与 OpenVLA-OFT 相当，高 ProgVLA 5.9 点：“OpenVLA-OFT (97.1%, 7.0B), and 5.9 points above ProgVLA (91.1%), the strongest prior-free compact policy.”（§4.2）
> - 低于有视频预训练的 Motus 和 GigaWorld-Policy：“but stays below pretrained Motus (88.7%/87.0%) and GigaWorld-Policy (86.4%/85.0%).”（§4.2）
> - 随机 ViT 78.1%、ImageNet ResNet 74.5%：“a random ViT-S/14 drops to 78.1% and an ImageNet ResNet-34 to 74.5% on LIBERO.”（Abstract）
> - 冻结编码器 97.0% 降到 77.2%：“The answer is NO: freezing the pretrained encoder lowers average LIBERO success from 97.0% to 77.2%.”（§4.4）
> - 硬 token 预算 83.2% 提到 97.0%：“a hard, instruction-aware token budget raises average LIBERO success from 83.2% to 97.0%, whereas a variational bottleneck lowers success with or without it.”（§4.6）
> - VIB 使 Goal 从 95.8% 降到 33.0%：“it reduces the instruction-induced change from 49.7% to 13.6% and Goal success from 95.8% to 33.0%”（§4.6）
> - 去掉语言 LIBERO-Goal 降到 9.2%：“Removing language is catastrophic only on LIBERO-Goal, where success drops from 95.8% to 9.2%, while the other suites lose at most 11.2 points”（§4.5）
> - RoboTwin 2.0 去掉语言提升约 2.7 点：“Conversely, on RoboTwin 2.0, where each scene identifies its task, removing language raises success by about 2.7 points in both settings”（§4.5）

## 一句话总结

48.9M 参数的紧凑策略 CoRP 能媲美大得多的系统，说明关键在于经过预训练、任务适配并压缩的视觉表征。

## 要解决什么问题

多任务操作策略（VLA、世界动作模型）在架构、规模、预训练先验、数据和训练配方上同时不同，已发表的对比无法把性能归因到任何单一组件。作者想回答：策略的性能有多少取决于视觉表征、表征的哪些性质真正重要，而参数规模和生成式先验是否只是附带因素。

## 方法

- 把策略分解为表征提取器（representation extractor）和条件动作生成器（conditional action generation）：固定动作生成器，每次只改变提取器的一个性质，包括视觉编码器的初始化、是否微调、进入动作生成器的视觉 token 数、是否提供指令（§1、§3）。
- 压缩表征策略（Compressed Representation Policy, CoRP）：DINOv2 初始化的 ViT-S/14 视觉编码器、T5-Efficient-Tiny 语言编码器加轻量适配器、学习查询的交叉注意力重采样器（resampler，每个视角压缩成 48 个 token，查询由指令经 FiLM 调制）、单块 DiT 动作生成器（§3.1，附录 A.1）。
- 训练目标：流匹配损失（flow matching）加辅助的任务分类损失（task-classification loss），后者直接促使视觉前缀保留任务相关信息，只在训练时使用；所有模块端到端联合训练（§3.2）。
- 诊断手段：用任务头准确率衡量策略“知不知道该做哪个任务”，冻结表征后用轻量探针预测动作块（NMAE、R²）衡量表征中的动作相关信息（§4.1）。
- 真机：架构不变，先在自有的大规模真机数据上预训练，再在少量任务上微调（§4.7，附录 A.5）。

## 实验与关键数字

- 总体：CoRP 在 LIBERO 上平均 97.0%，在 RoboTwin 2.0 Clean/Randomized 上为 75.78%/73.36%；LIBERO 上与 OpenVLA-OFT（97.1%，7.0B）相当，比最强的无先验紧凑策略 ProgVLA（91.1%）高 5.9 点（§4.2、表 1）。
- RoboTwin 2.0 上超过 X-VLA 和 π0.5，但仍低于有视频预训练的 Motus（88.7%/87.0%）和 GigaWorld-Policy（86.4%/85.0%）（§4.2、表 2）。
- 预训练初始化与微调：随机初始化的 ViT-S/14 降到 78.1%，ImageNet 预训练的 ResNet-34 降到 74.5%；冻结编码器使 LIBERO 平均成功率从 97.0% 降到 77.2%（§4.3–4.4）。
- 压缩：按指令分配的硬 token 预算把 LIBERO 平均成功率从 83.2%（传全部 token）提到 97.0%；加变分信息瓶颈（VIB）反而有害，使 LIBERO-Goal 从 95.8% 降到 33.0%（§4.6、表 7）。
- 语言条件：只在观测无法确定目标时关键，去掉语言后 LIBERO-Goal 从 95.8% 降到 9.2%，其他套件最多损失 11.2 点；RoboTwin 2.0 上去掉语言反而提升约 2.7 点（§4.5）。
- 真机：在三项双臂任务（抓杯、放勺、插头拔插）上做了定性验证，没有真机基线；文中关于试验次数和推理耗时的表述前后不一致，需核对（§4.7、附录 A.5）。

## 局限 / 存疑

## 与其他论文的关系

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 9 条

> It reaches 97.0% on LIBERO and 75.78%/73.36% on RoboTwin 2.0 Clean/Randomized
> 批注：Claude：LIBERO 97.0%，RoboTwin 2.0 75.78%/73.36%
> — [[xsquare/papers/22_2610.08183_Compact-Robot-Policies-Fine-Grained-Visual-Representations.pdf#page=1|p.1]]

> a random ViT-S/14 drops to 78.1% and an ImageNet ResNet-34 to 74.5% on LIBERO.
> 批注：Claude：随机 ViT 78.1%、ImageNet ResNet 74.5%
> — [[xsquare/papers/22_2610.08183_Compact-Robot-Policies-Fine-Grained-Visual-Representations.pdf#page=1|p.1]]

> CoRP has only 48.9M parameters and four standard components: a DINOv2-initialized ViT-S/14 visual encoder
> 批注：Claude：CoRP 仅 48.9M 参数
> — [[xsquare/papers/22_2610.08183_Compact-Robot-Policies-Fine-Grained-Visual-Representations.pdf#page=2|p.2]]

> OpenVLA-OFT (97.1%, 7.0B), and 5.9 points above ProgVLA (91.1%), the strongest prior-free compact policy.
> 批注：Claude：与 OpenVLA-OFT 相当，高 ProgVLA 5.9 点
> — [[xsquare/papers/22_2610.08183_Compact-Robot-Policies-Fine-Grained-Visual-Representations.pdf#page=6|p.6]]

> but stays below pretrained Motus (88.7%/87.0%) and GigaWorld-Policy (86.4%/85.0%).
> 批注：Claude：低于有视频预训练的 Motus 和 GigaWorld-Policy
> — [[xsquare/papers/22_2610.08183_Compact-Robot-Policies-Fine-Grained-Visual-Representations.pdf#page=6|p.6]]

> The answer is NO: freezing the pretrained encoder lowers average LIBERO success from 97.0% to 77.2%.
> 批注：Claude：冻结编码器 97.0% 降到 77.2%
> — [[xsquare/papers/22_2610.08183_Compact-Robot-Policies-Fine-Grained-Visual-Representations.pdf#page=7|p.7]]

> Conversely, on RoboTwin 2.0, where each scene identifies its task, removing language raises success by about 2.7 points in both settings
> 批注：Claude：RoboTwin 2.0 去掉语言提升约 2.7 点
> — [[xsquare/papers/22_2610.08183_Compact-Robot-Policies-Fine-Grained-Visual-Representations.pdf#page=7|p.7]]

> a hard, instruction-aware token budget raises average LIBERO success from 83.2% to 97.0%, whereas a variational bottleneck lowers success with or without it.
> 批注：Claude：硬 token 预算 83.2% 提到 97.0%
> — [[xsquare/papers/22_2610.08183_Compact-Robot-Policies-Fine-Grained-Visual-Representations.pdf#page=8|p.8]]

> it reduces the instruction-induced change from 49.7% to 13.6% and Goal success from 95.8% to 33.0%
> 批注：Claude：VIB 使 Goal 从 95.8% 降到 33.0%
> — [[xsquare/papers/22_2610.08183_Compact-Robot-Policies-Fine-Grained-Visual-Representations.pdf#page=8|p.8]]
<!-- highlights:end -->

## 摘要（中文）

多任务操作策略在架构、规模和预训练先验上同时存在差异，因此已发表的比较无法把性能归因到任何单一组件。我们认为，性能主要来自视觉表征，而参数规模和生成式先验在很大程度上是次要的。为验证这一点，我们构建了 CoRP（Compressed Representation Policy，压缩表征策略）：一个刻意做得很紧凑的策略（48.9M 参数，没有视觉-语言模型，也没有视频生成先验），由表征提取器和流匹配动作生成器两部分组成。它在 LIBERO 上达到 97.0%，在 RoboTwin 2.0 Clean/Randomized 上达到 75.78%/73.36%，与比它大 40.9–163.6 倍的系统相当。

在固定动作生成器的前提下，我们每次只改变提取器的一个性质。预训练初始化是决定性的：随机初始化的 ViT-S/14 在 LIBERO 上降到 78.1%，ImageNet 预训练的 ResNet-34 降到 74.5%。只有预训练还不够，冻结编码器会损失 19.8 个点。压缩同样重要：把每个视角重采样为 48 个 token 优于传入全部 patch token（97.0% vs 83.2%）；而在这些 token 上施加变分信息瓶颈不如硬性的 token 预算，它会抑制策略所依赖的、随指令变化的 token 选择，使 LIBERO-Goal 从 95.8% 降到 33.0%。

语言条件只在观测无法确定目标时才起作用（LIBERO-Goal：从 9.2% 到 95.8%）；而在观测没有歧义的 RoboTwin 2.0 上，去掉语言反而略微提高了成功率。因此我们认为，紧凑策略要奏效，其表征需要经过预训练、针对任务适配并经过压缩。

## 摘要（原文）

> Multi-task manipulation policies differ in architecture, scale, and pretrained priors all at once, so published comparisons cannot attribute performance to any single component. We argue that most of it comes from the visual representation, and that parameter scale and generative priors are largely incidental. To test this, we build CoRP (Compressed Representation Policy), a deliberately compact policy (48.9M parameters, no vision-language model and no video-generative prior) that factorizes into a representation extractor and a flow-matching action generator. It reaches 97.0% on LIBERO and 75.78%/73.36% on RoboTwin 2.0 Clean/Randomized, matching systems 40.9-163.6x larger. Holding the action generator fixed, we then vary one extractor property at a time. Pretrained initialization is decisive: a random ViT-S/14 drops to 78.1% and an ImageNet ResNet-34 to 74.5% on LIBERO. Pretraining alone is not enough, as freezing the encoder costs 19.8 points. Compression matters as much: resampling each view to 48 tokens beats passing all patch tokens (97.0% vs 83.2%), and a variational information bottleneck over those tokens is worse than a hard token budget, cutting LIBERO-Goal from 95.8% to 33.0% by suppressing the instruction-dependent token selection the policy relies on. Language conditioning contributes only where the observation leaves the goal ambiguous (LIBERO-Goal: 9.2% to 95.8%), while on RoboTwin 2.0, where observations are unambiguous, removing it slightly improves success. Therefore, we argue that a compact policy works when its representation is pretrained, task-adapted, and compressed. Project page: this https URL
