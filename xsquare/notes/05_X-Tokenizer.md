---
id: "05"
org: 自变量
short: "X-Tokenizer"
title: "X-Tokenizer: A Multimodal Action Tokenizer for Vision-Language-Action Pretraining"
aliases: ["X-Tokenizer"]
date: 2026-06-07
category: 动作表征
source: 自变量主导
partners: ["香港城市大学", "清华大学"]
authors: ["Miracle Kang", "Lights Shi", "Lucy Liang", "Roy Gan", "Dongxiu Liu", "Pushi Zhang", "Sylas Chen", "Shawn Qin", "Yinan Zheng", "Jinliang Zheng", "Hao Wang", "Xianyuan Zhan", "Hang Su"]
arxiv: "2606.14752"
pdf: "[[xsquare/papers/05_2606.14752_X-Tokenizer.pdf]]"
code: "https://github.com/X-Square-Robot/X-Tokenizer"
project: "https://x-square-robot.github.io/X-Tokenizer_projectPage/"
huggingface: ["https://huggingface.co/x-square-robot/X-Tokenizer"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "action-tokenizer", "vla", "pretraining"]
---

# X-Tokenizer: A Multimodal Action Tokenizer for Vision-Language-Action Pretraining

> [!info] 论文信息
> arXiv [2606.14752](https://arxiv.org/abs/2606.14752) · v1 2026-06-07 · 最新 v2（2026-06-28）
> PDF：[[xsquare/papers/05_2606.14752_X-Tokenizer.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/X-Tokenizer) · [项目页](https://x-square-robot.github.io/X-Tokenizer_projectPage/) · [X-Tokenizer](https://huggingface.co/x-square-robot/X-Tokenizer)
> 合作单位：香港城市大学、清华大学

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 核心观点：动作分词是语义接口学习：“We therefore formulate action tokenization not as mere compression, but as semantic interface learning between multimodal reasoning and executable control.”（Abstract）
> - SRQ 非对称结构：首层 MAM，深层重建残差：“the first level is trained with Masked Action Modeling (MAM) to form a discrete action language that captures coarse motion intent, while deeper levels remain reconstruction-oriented residuals that preserve fine-grained details”（Abstract）
> - 对比对齐与下一帧 VL 特征预测：“X-Tokenizer is pretrained with contrastive alignment to the representation space of a pretrained foundation model and with next-frame vision-language feature prediction”（Abstract）
> - 预训练规模 2.4M 轨迹 / 2.0B 帧：“We pretrain X-Tokenizer on about 2.4M trajectories and about 2.0B action frames spanning”（§4）
> - 推理时关闭自回归头与分词器：“At inference, both the autoregressive head and X-Tokenizer are disabled, so the policy runs as a single-forward continuous flow regressor with no discrete-token overhead.”（§3.4）
> - 真实机器人总体结果（VQA 与 PR）：“X-Tokenizer achieves the best aggregate performance: 85.9 % 85.9\% VQA, 80.6 % 80.6\% PR over five short-horizon manipulation tasks, 69.3 % 69.3\% PR over two long-horizon tasks, and 77.4 % 77.4\% average PR over all seven tasks.”（§4.4）
> - 仅多级结构不足以提升动作质量：“suggesting that multi-level discrete structure alone helps the backbone representation but is not sufficient for action quality”（§4.4）
> - RoboTwin 2.0 总体最好：“Wall-OSS+X-Tokenizer achieves the best aggregate performance, improving over the strongest published baseline”（§4.3）
> - 跨本体：五个单臂本体联合训练：“we train on five single-arm embodiments and compare separate single-embodiment models with one joint model trained on the union”（§4.3）
> - 噪声鲁棒性：WER 最低：“X-Tokenizer obtains the lowest WER across noise levels, while FAST degrades sharply once perturbations trigger BPE re-segmentation.”（§4.2.3）

## 一句话总结

把动作分词器做成 VLM 与连续控制之间的语义接口：首层码表达粗粒度运动意图，深层码保留执行细节，作为 VLA 预训练的监督信号。

## 要解决什么问题

现有动作分词器（如 FAST）主要为重建而设计，码只是在划分几何动作空间，没有与任务语义、视觉上下文或语言意图对齐。在混合离散-连续 VLA 中，离散动作 token 的预测损失会塑造连续专家所依赖的共享隐状态；如果 token 只是任意的重建索引，就会把 VLM 隐状态拉向几何码模式，而不是与动作相关的多模态语义。

## 方法

- 把动作分词表述为语义接口学习（semantic interface learning）：动作 token 不只是压缩结果，而是塑造 VLM 表征的监督目标（§1、§3.1）。
- 核心结构为编码器–语义残差量化（Semantic Residual Quantization, SRQ）–解码器（§3.2）：
  1. 编码器对 delta 动作（相对动作块之前的本体状态锚点）做 Perceiver 式交叉注意力下采样，得到少量隐槽，并带可丢弃的本体 token；
  2. SRQ 使用多级 RVQ，但监督是非对称的：只有第一级接受语义监督，更深层级只负责重建残差；
  3. 轻量的 Perceiver IO 式解码器还原动作块。
- 三个预训练辅助头（§3.3）：掩码动作建模（Masked Action Modeling, MAM）对首层码做 BERT 式掩码预测，形成“动作语言”；视觉-语言对比对齐（Vision-Language Contrastive Alignment）在全局和逐槽两个粒度上把编码器隐变量与冻结 Qwen2.5-VL-7B 的融合特征做 InfoNCE；下一帧视觉-语言特征预测（Next-Frame VL Feature Prediction）让码编码动作的即时物理后果。
- 辅助头只在分词器预训练时使用，之后移除，部署时只剩轻量的编码器–SRQ–解码器核心（§3.1、§4.2.3）。
- 下游协同训练（§3.4）：冻结的 X-Tokenizer 离线把专家轨迹编码成多级 token，作为混合 VLA 自回归分支的监督；Flow Matching 连续专家基于共享隐状态回归动作。推理时自回归头和分词器都关闭。实现细节见附录 A，预训练数据与本体见附录 B。

## 实验与关键数字

- 预训练语料约 2.4M 条轨迹、约 2.0B 动作帧（§4、附录 B）；主要对比对象是 FAST。
- 真实机器人（§4.4）：七个桌面任务（五个短时程 + 两个长时程），以 Wall-OSS 为测试平台，只替换动作接口（原始 flow head、FAST、无辅助头的 RVQ、X-Tokenizer）。X-Tokenizer 总体最好：VQA 85.9%，短时程 PR 80.6%，长时程 PR 69.3%，七任务平均 PR 77.4%。分词器对齐的是 Qwen2.5-VL-7B 特征，而策略主干是 Qwen2.5-VL-3B。
- 消融：只用多级 RVQ、不加三个语义头时，VQA 提升但动作质量不够；加上 MAM、Align、Pred 后两方面都提升（§4.4、§4.2.2 表 1）。
- RoboTwin 2.0（§4.3）：Wall-OSS+X-Tokenizer 总体表现最好，在 Easy 和 Hard 设置下都超过最强已发表基线 π0.5，Hard 下增益更大（作者说明这是跨方法的基准比较，不是受控消融）。在五个单臂本体上，联合训练优于分别训练。
- 鲁棒性（§4.2.3 表 2）：注入动作噪声后，X-Tokenizer 在各噪声水平下 WER 都最低，FAST 一旦 BPE 重新切分就急剧退化。

## 局限 / 存疑

## 与其他论文的关系

- 以 [[01_WALL-OSS]] 的混合离散-连续架构作为 RoboTwin 和真实机器人实验的测试平台（§4.3、§4.4）
- 引言把 [[02_WALL-OSS-0.5]] 列为混合离散-连续 VLA 系统之一

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 10 条

> We therefore formulate action tokenization not as mere compression, but as semantic interface learning between multimodal reasoning and executable control.
> 批注：Claude：核心观点：动作分词是语义接口学习
> — [[xsquare/papers/05_2606.14752_X-Tokenizer.pdf#page=1|p.1]]

> the first level is trained with Masked Action Modeling (MAM) to form a discrete action language that captures coarse motion intent, while deeper levels remain reconstruction-oriented residuals that preserve fine-grained details
> 批注：Claude：SRQ 非对称结构：首层 MAM，深层重建残差
> — [[xsquare/papers/05_2606.14752_X-Tokenizer.pdf#page=1|p.1]]

> X-Tokenizer is pretrained with contrastive alignment to the representation space of a pretrained foundation model and with next-frame vision-language feature prediction
> 批注：Claude：对比对齐与下一帧 VL 特征预测
> — [[xsquare/papers/05_2606.14752_X-Tokenizer.pdf#page=1|p.1]]

> At inference, both the autoregressive head and X-Tokenizer are disabled, so the policy runs as a e single-forward continuous flow regressor with no discrete-token overhead.ign
> 批注：Claude：推理时关闭自回归头与分词器
> — [[xsquare/papers/05_2606.14752_X-Tokenizer.pdf#page=6|p.6]]

> We pretrain X-Tokenizer on about 2.4M trajectories and about 2.0B action frames spanning
> 批注：Claude：预训练规模 2.4M 轨迹 / 2.0B 帧
> — [[xsquare/papers/05_2606.14752_X-Tokenizer.pdf#page=6|p.6]]

> X-Tokenizer obtains the lowest WER across noise levels, while FAST degrades sharply once perturbations trigger BPE re-segmentation.
> 批注：Claude：噪声鲁棒性：WER 最低
> — [[xsquare/papers/05_2606.14752_X-Tokenizer.pdf#page=9|p.9]]

> Wall-OSS+X-Tokenizer achieves the best aggregate performance, improving over the strongest published baseline
> 批注：Claude：RoboTwin 2.0 总体最好
> — [[xsquare/papers/05_2606.14752_X-Tokenizer.pdf#page=12|p.12]]

> we train on five single-arm embodiments and compare separate single-embodiment models with one joint model trained on the union
> 批注：Claude：跨本体：五个单臂本体联合训练
> — [[xsquare/papers/05_2606.14752_X-Tokenizer.pdf#page=12|p.12]]

> X-Tokenizer achieves the best aggregate performance: 85.9% VQA, 80.6% PR over five short-horizon manipulation tasks, 69.3% PR over two long-horizon tasks, and 77.4% average PR over all seven tasks
> 批注：Claude：真实机器人总体结果（VQA 与 PR）
> — [[xsquare/papers/05_2606.14752_X-Tokenizer.pdf#page=12|p.12]]

> suggesting that multi-level discrete structure alone helps the backbone representation but is not su!cient for action quality
> 批注：Claude：仅多级结构不足以提升动作质量
> — [[xsquare/papers/05_2606.14752_X-Tokenizer.pdf#page=12|p.12]]
<!-- highlights:end -->

## 摘要（中文）

现代视觉-语言-动作（VLA）模型必须在预训练的视觉-语言推理与精确的连续机器人控制之间架起桥梁。现有动作分词器主要为重建而对动作做离散化，得到的码能保留运动几何，却只给主干网络提供很弱的语义监督。因此，我们不把动作分词仅仅视为压缩，而是把它表述为多模态推理与可执行控制之间的语义接口学习。

为此，我们提出 X-Tokenizer：一种轻量的编码器–语义残差量化（SRQ）–解码器架构，为多种机械臂本体提供共享的动作接口。其关键组件 SRQ 给残差向量量化施加了非对称结构：第一级用掩码动作建模（MAM）训练，形成刻画粗粒度运动意图的离散动作语言；更深的层级仍是面向重建的残差，用于保留细粒度细节。为了让动作 token 进一步与多模态语义对齐，X-Tokenizer 在预训练中还使用了与预训练基础模型表征空间的对比对齐，以及下一帧视觉-语言特征预测。

X-Tokenizer 在 2.4M 条轨迹（2.0B 动作帧）上预训练，单个冻结的 X-Tokenizer 即可作为塑造表征的监督信号接入混合离散-连续 VLA。X-Tokenizer 取得了最好的真实世界总体结果和强劲的 RoboTwin 2.0 仿真结果。它在多模态 grounding（+13.5%）和长时程任务（+8.25）上超过 FAST，表明动作分词器在 VLA 预训练中可以充当语义接口，而不只是动作压缩。

## 摘要（原文）

> Modern Vision-Language-Action (VLA) models must bridge pretrained vision-language reasoning and precise continuous robot control. Existing action tokenizers discretize actions primarily for reconstruction, producing codes that preserve motion geometry but provide only weak semantic supervision to the backbone. We therefore formulate action tokenization not as mere compression, but as semantic interface learning between multimodal reasoning and executable control. To this end, we introduce X-Tokenizer, a lightweight encoder-Semantic Residual Quantization (SRQ)-decoder architecture that provides a shared action interface across diverse robotic arm embodiments. Its key component, SRQ, imposes an asymmetric structure on residual vector quantization: the first level is trained with Masked Action Modeling (MAM) to form a discrete action language that captures coarse motion intent, while deeper levels remain reconstruction-oriented residuals that preserve fine-grained details. To further align action tokens with multimodal semantics, X-Tokenizer is pretrained with contrastive alignment to the representation space of a pretrained foundation model and with next-frame vision-language feature prediction. Pretrained on 2.4M trajectories (2.0B action frames), a single frozen X-Tokenizer plugs into a mixed discrete-continuous VLA as a representation-shaping supervision signal. X-Tokenizer achieves top real-world aggregate and strong RoboTwin 2.0 simulation results. Outperforming FAST in multimodal grounding (+13.5%) and long-horizon tasks (+8.25), it shows that action tokenizers serve as semantic interfaces for VLA pretraining beyond mere action compression.
