---
id: "21"
org: 自变量
short: "LatentQuant"
title: "LatentQuant: Preserving the Policy-Facing Latent Contract under NVFP4 VAE Quantization"
aliases: ["LatentQuant"]
date: 2026-10-02
category: 世界模型
source: 合作
partners: ["UCSD", "中山大学", "中国科学院大学", "香港科技大学（广州）"]
authors: ["Ziye Deng", "Lufang Chen", "Shuyu Feng", "Zhenwei Duan", "Zicong Ye", "Yu Sun", "Xiaofan Li", "Ruyi Gan", "Hao Wang", "Hao Zhang"]
arxiv: "2610.03959"
pdf: "[[xsquare/papers/21_2610.03959_LatentQuant.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "quantization", "world-action-model"]
---

# LatentQuant: Preserving the Policy-Facing Latent Contract under NVFP4 VAE Quantization

> [!info] 论文信息
> arXiv [2610.03959](https://arxiv.org/abs/2610.03959) · v1 2026-10-02
> PDF：[[xsquare/papers/21_2610.03959_LatentQuant.pdf|本地 PDF]]
> 合作单位：UCSD、中山大学、中国科学院大学、香港科技大学（广州）

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - WAM 的编码器潜变量直接作为策略条件：“Recent world action models (WAMs) reuse pretrained video VAEs whose encoder latents directly condition downstream action policies.”（Abstract）
> - 解码器 QDQ 偏转梯度、引发持久漂移：“Controlled decoder-only experiments show that activation quantize–dequantize operations alter the reconstruction signal and decoder Jacobian, redirecting the gradient returned to the encoder and inducing persistent latent drift.”（Abstract）
> - 两阶段 QAT：先对齐编码器再冻结、只调解码器：“a two-stage NVFP4 QAT framework that first aligns the quantized encoder with its high-precision counterpart, then freezes it while adapting the decoder”（Abstract）
> - 联合 QAT 重建几乎持平 FP32：“On Wan2.1, joint QAT nearly matches FP32 VBench-7 (0.7403 versus 0.7409), yet LIBERO success collapses from”（Abstract）
> - Wan2.1 / LIBERO 各方法结果：“Wan2.1 FP32 0.7409 0.7747 0.000 0.000 95.50 Direct NVFP4 0.7266 0.7513 0.288 0.033 94.38 Joint QAT 0.7403 0.7565 4.796 0.270 10.50 Joint+KL 0.7341 0.7571 1.190 0.118 86.75 LatentQuant 0.7340 0.7513 0.202 0.018 95.75”（Table 1）
> - Wan2.2 / RoboTwin 各方法结果：“Wan2.2 BF16 0.7436 0.7750 0.000 0.000 69.80 Direct NVFP4 0.7325 0.7626 0.092 0.202 68.00 Joint QAT 0.7402 0.7613 4.638 0.344 0 Joint+KL 0.7407 0.7638 0.995 0.340 8.40 LatentQuant 0.7414 0.7656 0.062 0.003 68.80”（Table 1）
> - 实验对象是两个 WALL-WM 变体：“We evaluate two WALL-WM ( Li et al., 2026b ) variants that consume pretrained video-VAE latents for control.”（§6.1）
> - 800 次 LIBERO、500 次 RoboTwin 试验：“Success is measured over 800 LIBERO and 500 RoboTwin trials.”（§6.1）
> - B300 上 1.17×–1.26× 端到端加速：“On NVIDIA B300 GPUs, NVFP4 execution achieves 1.17×–1.26× end-to-end VAE speedups over BF16 cuDNN”（Abstract）
> - 15 个真机任务：7 低、2 平、6 高：“LatentQuant–FP32 differences in three-run mean milestone scores over 15 real-robot tasks: 7 lower, 2 tied, and 6 higher, with median 0.”（Figure 3 caption）

## 一句话总结

LatentQuant 先对齐量化编码器、再冻结它只调解码器，让 NVFP4 视频 VAE 保住下游策略依赖的潜变量。

## 要解决什么问题

近期世界动作模型（WAM）复用预训练视频 VAE，其编码器潜变量直接作为冻结动作策略的输入，因此量化 VAE 时不仅要保住重建质量，还要保住策略所期望的潜变量表示，即“面向策略的潜变量契约”。直接 NVFP4 量化无法补偿 W4A4 误差；联合量化感知训练（QAT）能恢复重建，却会移动潜变量，使策略性能崩溃，而重建指标把这种不兼容掩盖了。

## 方法

- 面向策略的潜变量契约（policy-facing latent contract）：重建只约束编码器与解码器的复合，任意可逆变换都能保持重建却改变策略的输入，所以量化要同时满足重建和潜变量保持（见 §1、§3.1）。
- 机理分析：解码器激活的量化-反量化（QDQ）同时改变重建信号和解码器 Jacobian，使回传给编码器的潜变量梯度方向发生偏转，并经反复优化更新固化为编码器参数中的持久潜变量漂移；去掉所有 QDQ 后漂移仍在（见 §4、附录 E）。
- 两阶段 NVFP4 QAT（见 §5、附录 B）：
  1. 阶段 I 逐样本编码器对齐（sample-wise encoder alignment）：用按通道标准差归一化的误差，把量化编码器的输出逐样本对齐到冻结的高精度参考编码器，不需要动作标签或策略梯度；
  2. 阶段 II 固定契约下的解码器适配：冻结对齐后的编码器，只用 MSE + Sobel + LPIPS 重建损失训练量化解码器，使重建梯度无法再改写潜变量。
- 数值设定：W4A4 NVFP4（E2M1 数值、每 16 元素块一个 E4M3 缩放、外加 FP32 张量级缩放），归一化、非线性、残差和 VAE 输入/潜变量边界保持高精度；另实现 B300 上的原生 packed-NVFP4 卷积后端（见 §3.2、附录 A、附录 F）。

## 实验与关键数字

- 设置：评测两个以预训练视频 VAE 潜变量做控制的 WALL-WM 变体——Wan2.1 VAE 配 LIBERO（FP32 参考）、Wan2.2 VAE 配 RoboTwin（BF16 参考），下游策略全程冻结；成功率分别基于 800 次 LIBERO 和 500 次 RoboTwin 试验（见 §6.1）。
- 重建好不等于策略兼容（表 1）：Wan2.1 上联合 QAT 的 Robot VBench-7 为 0.7403，几乎等于 FP32 的 0.7409，LIBERO 成功率却从 95.50% 跌到 10.50%；Wan2.2 上联合 QAT 使 RoboTwin 成功率从 69.80% 降到 0；加 KL 正则（Joint+KL）也只恢复到 86.75% / 8.40%；直接 NVFP4 反而保住了 94.38% / 68.00%。
- LatentQuant：LIBERO 95.75%（参考 95.50%）、RoboTwin 68.80%（参考 69.80%），潜变量偏差和动作偏差都低于直接 NVFP4，Robot VBench-7 也高于直接 NVFP4（0.7340 对 0.7266；0.7414 对 0.7325）（见表 1）。
- 物理观测迁移：15 个真机任务上与 FP32 相比，7 个更低、2 个持平、6 个更高，中位数差为 0（见 §6.4、图 3）。
- 部署效率：NVIDIA B300 上原生 NVFP4 执行相对 BF16 cuDNN 获得 1.17×–1.26× 的端到端 VAE 加速（见 §6.4、附录 F）。

## 局限 / 存疑

## 与其他论文的关系

- [[03_WALL-WM]]：实验对象就是两个 WALL-WM 变体（分别使用 Wan2.1、Wan2.2 视频 VAE），量化时其下游动作策略保持冻结

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 9 条

> Recent world action models (WAMs) reuse pretrained video VAEs whose encoder latents directly condition downstream action policies.
> 批注：Claude：WAM 的编码器潜变量直接作为策略条件
> — [[xsquare/papers/21_2610.03959_LatentQuant.pdf#page=1|p.1]]

> On Wan2.1, joint QAT nearly matches FP32 VBench-7 (0.7403 versus 0.7409), yet LIBERO success collapses from
> 批注：Claude：联合 QAT 重建几乎持平 FP32
> — [[xsquare/papers/21_2610.03959_LatentQuant.pdf#page=1|p.1]]

> Controlled decoder-only experiments show that activation quantize–dequantize operations alter the reconstruction signal and decoder Jaco- bian, redirecting the gradient returned to the encoder and inducing persistent latent drift.
> 批注：Claude：解码器 QDQ 偏转梯度、引发持久漂移
> — [[xsquare/papers/21_2610.03959_LatentQuant.pdf#page=1|p.1]]

> a two-stage NVFP4 QAT framework that first aligns the quantized encoder with its high-precision counterpart, then freezes it while adapting the decoder
> 批注：Claude：两阶段 QAT：先对齐编码器再冻结、只调解码器
> — [[xsquare/papers/21_2610.03959_LatentQuant.pdf#page=1|p.1]]

> On NVIDIA B300 GPUs, NVFP4 execution achieves 1.17!–1.26! end-to-end VAE speedups over BF16 cuDNN
> 批注：Claude：B300 上 1.17×–1.26× 端到端加速
> — [[xsquare/papers/21_2610.03959_LatentQuant.pdf#page=1|p.1]]

> We evaluate two WALL-WM (Li et al., 2026b) variants that consume pretrained video-VAE latents for control
> 批注：Claude：实验对象是两个 WALL-WM 变体
> — [[xsquare/papers/21_2610.03959_LatentQuant.pdf#page=7|p.7]]

> Success is measured over 800 LIBERO and 500 RoboTwin trials.
> 批注：Claude：800 次 LIBERO、500 次 RoboTwin 试验
> — [[xsquare/papers/21_2610.03959_LatentQuant.pdf#page=7|p.7]]

> Wan2.1 FP32 0.7409 0.7747 0.000 0.000 95.50 Direct NVFP4 0.7266 0.7513 0.288 0.033 94.38 Joint QAT 0.7403 0.7565 4.796 0.270 10.50 Joint+KL 0.7341 0.7571 1.190 0.118 86.75 LatentQuant 0.7340 0.7513 0.202 0.018 95.75
> 批注：Claude：Wan2.1 / LIBERO 各方法结果
> — [[xsquare/papers/21_2610.03959_LatentQuant.pdf#page=8|p.8]]

> Wan2.2 BF16 0.7436 0.7750 0.000 0.000 69.80 Direct NVFP4 0.7325 0.7626 0.092 0.202 68.00 Joint QAT 0.7402 0.7613 4.638 0.344 0 Joint+KL 0.7407 0.7638 0.995 0.340 8.40 LatentQuant 0.7414 0.7656 0.062 0.003 68.80
> 批注：Claude：Wan2.2 / RoboTwin 各方法结果
> — [[xsquare/papers/21_2610.03959_LatentQuant.pdf#page=8|p.8]]
<!-- highlights:end -->

## 摘要（中文）

近期的世界动作模型（WAM）复用预训练视频 VAE，其编码器潜变量直接作为下游动作策略的条件。因此，量化不仅要保持重建保真度，还必须保持冻结策略所期望的“面向策略的潜变量契约”（policy-facing latent contract）。直接 NVFP4 量化让 W4A4 量化误差得不到补偿，而联合量化感知训练（QAT）则可能通过移动这一表示来恢复重建。在 Wan2.1 上，联合 QAT 的 VBench-7 几乎与 FP32 持平（0.7403 对 0.7409），但 LIBERO 成功率却从 95.5% 崩溃到 10.5%。

受控的仅解码器实验表明，激活的量化-反量化操作会改变重建信号和解码器 Jacobian，从而改变回传给编码器的梯度方向，并引发持久的潜变量漂移。基于这一机理，我们提出 LatentQuant，一个两阶段 NVFP4 QAT 框架：先将量化编码器与其高精度对应版本对齐，然后冻结编码器、只适配解码器。

在 Wan2.1 和 Wan2.2 上，LatentQuant 保持了接近基线的控制性能和较高的重建质量，在 LIBERO 上取得 95.75% 的成功率，在 RoboTwin 上取得 68.8%。在 NVIDIA B300 GPU 上，NVFP4 执行相对 BF16 cuDNN 实现了 1.17×–1.26× 的端到端 VAE 加速。

## 摘要（原文）

> Recent world action models (WAMs) reuse pretrained video VAEs whose encoder latents directly condition downstream action policies. Quantization must therefore preserve not only reconstruction fidelity but also the policy-facing latent contract expected by the frozen policy. Direct NVFP4 leaves W4A4 quantization error uncompensated, whereas joint quantization-aware training (QAT) can recover reconstruction by moving this representation. On Wan2.1, joint QAT nearly matches FP32 VBench-7 (0.7403 versus 0.7409), yet LIBERO success collapses from 95.5% to 10.5%. Controlled decoder-only experiments show that activation quantize-dequantize operations alter the reconstruction signal and decoder Jacobian, redirecting the gradient returned to the encoder and inducing persistent latent drift. Based on this mechanism, we introduce LatentQuant, a two-stage NVFP4 QAT framework that first aligns the quantized encoder with its high-precision counterpart, then freezes it while adapting the decoder. Across Wan2.1 and Wan2.2, LatentQuant preserves near-baseline control and high reconstruction quality, achieving 95.75% success on LIBERO and 68.8% on RoboTwin. On NVIDIA B300 GPUs, NVFP4 execution achieves 1.17x-1.26x end-to-end VAE speedups over BF16 cuDNN.
