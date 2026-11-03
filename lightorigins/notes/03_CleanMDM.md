---
id: "03"
org: 亮源
short: "CleanMDM"
title: "CleanMDM: Clean Motion Diffusion Model for Multimodal Motion Cleanup"
aliases: ["CleanMDM"]
date: 2026-10-04
category: 动作生成
source: 合作
partners: ["北京大学", "阿里巴巴"]
authors: ["Zhe Li", "Shicheng Wang", "Bowen Cai", "Huan Fu"]
arxiv: "2610.05411"
pdf: "[[lightorigins/papers/03_2610.05411_CleanMDM.pdf]]"
code: ""
project: ""
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "motion-diffusion", "motion-cleanup", "human-motion"]
---

# CleanMDM: Clean Motion Diffusion Model for Multimodal Motion Cleanup

> [!info] 论文信息
> arXiv [2610.05411](https://arxiv.org/abs/2610.05411) · v1 2026-10-04
> PDF：[[lightorigins/papers/03_2610.05411_CleanMDM.pdf|本地 PDF]]
> 合作单位：北京大学、阿里巴巴

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 掩码条件生成，支持任意模态组合：“formulates cleanup as masked conditional generation with plug-and-play conditions. This single model supports arbitrary combinations of noisy 3D motion, sparse 2D keyframes, sparse 3D keyframes, and text.”（Abstract）
> - 逐帧置信度决定保留还是重新生成：“high-confidence frames are preserved, low-confidence frames are regenerated, and the boundary between the two is determined by the per-frame weights rather than a hard binary mask.”（§1）
> - LMQD 减少滑步、抖动和穿透：“LMQD enforces a sequence-level distribution constraint and reduces skating, jitter, and penetration.”（§4.3）
> - MACP 每只脚底采样 54 个顶点：“Since standard SMPL foot keypoints may lie inside the mesh, we sample 54 vertices on each foot sole to better approximate the contact surface.”（§4.5）
> - 自动清理优于 StableMotion：“CleanMDM substantially improves reconstruction fidelity and distributional realism over StableMotion, while simultaneously reducing contact-related artifacts (skating and penetration) and temporal noise (acceleration error and jitter).”（§5.3）
> - 多模态清理 MPJPE 21.95 vs GenMo 646.4：“In the most challenging multimodal cleanup setting, CleanMDM substantially outperforms GenMo (21.95 vs. 646.4 MPJPE), consistent with our expectation that a model designed for generation rather than cleanup does not explicitly preserve the input draft”（§5.3）
> - MACP 减少伪影但全局 MPJPE 上升：“While global MPJPE can increase (due to sequence-level adjustments of root/ground alignment), C6 consistently reduces artifacts, including skating, penetration frequency/distance, and jitter, approaching the statistics of the ground truth.”（§5.3）
> - KungFu：MPJPE 69.4 vs 127.8，抖动 9.2 vs 12.0：“On KungFu, CleanMDM cuts MPJPE roughly in half compared with StableMotion (69.4 vs. 127.8), while StableMotion attains a marginally lower jitter (9.2 vs. 12.0) by over-smoothing the motion in a way that alters its action identity”（§5.3）
> - 加入 3D 关键帧增益最大：“Notably, the strongest gains appear when CleanMDM additionally leverages sparse 3D keyframes, which anchor the reconstruction inside corrupted intervals and reduce ambiguity.”（§5.4）
> - 用户研究：自动清理三项评分：“Auto cleanup StableMotion 3.45 3.61 2.33 CleanMDM 4.13 4.41 4.63”（Appendix A.11, Table 13）

## 一句话总结

把动捕数据清理建模为潜空间中的掩码条件生成，单个模型可任意组合噪声动作、2D/3D 关键帧和文本来修复动作。

## 要解决什么问题

动作捕捉数据（尤其是视频动捕）常有缺失片段、抖动、漂移和接触伪影（滑步、悬空、穿地），动画师仍要手动挑关键帧、修正再插值。现有生成式清理方法大多是黑盒去噪器，对所有帧一视同仁，难以保留可靠片段或执行用户意图；插帧和条件生成方法则把损坏区间当作完全未观测，丢掉了其中部分可靠的信息，而且两类方法通常是分开的、单一模态的模型。作者指出真实的损坏几乎总是局部的，理想的清理应保留可信部分、只重新生成损坏区域。

## 方法

- 掩码条件生成框架：在动作自编码器的潜空间（时间维下采样）中训练条件流匹配（flow matching）Transformer，动作用绝对关节位置表示（沿用 ACMDM），见 §3、§4.1。
- 置信度对齐的多模态融合（confidence-aligned multimodal fusion）：噪声 3D 草稿（带逐帧置信度）、稀疏 3D 关键帧、稀疏 2D 关键帧先编码到共享潜空间，再按逐帧权重加权求和，经 AdaLN + 门控残差注入；文本用冻结的 CLIP 编码后走交叉注意力；某个模态的权重置零即关闭该模态，见 §4.2、Eq. 2。
- 潜在动作质量判别器（Latent Motion Quality Discriminator, LMQD）：在自编码器潜空间对整段序列做对抗正则，与生成器交替训练，用来减少滑步、抖动和穿透，见 §4.3。
- 自动清理与插帧合一（auto cleanup and inbetweening in one model）：训练时一半 batch 去掉区间标注做盲清理，另一半保留区间标注做掩码引导清理；推理时可以不给标注、给出损坏区间，或再加关键帧和文本，见 §4.4。
- 网格感知接触投影（Mesh-Aware Contact Projection, MACP）：测试时对整段序列做优化，在每只脚底采样 54 个 SMPL 顶点，约束它们与地面高度场的接触，见 §4.5、附录 A.3。

## 实验与关键数字

- 设置（§5.1、Table 1）：用 AMASS 和 MotionLLaMA 训练，按 StableMotion 的协议向干净片段的随机区间注入抖动、滑步、水平漂移和垂直悬空等伪影；在自动清理、插帧、多模态清理设置下与 StableMotion、ACMDM、CondMDI、GenMo 比较。
- 主结果（§5.3）：自动清理中相对 StableMotion 重建精度和分布真实性都更好，滑步、穿透和抖动更少；插帧中在 MPJPE 和关键帧误差上优于 ACMDM 和 CondMDI；多模态清理中 MPJPE 为 21.95，GenMo 为 646.4。
- 接触投影（§5.3）：加 MACP 后滑步、穿透频率/深度和抖动下降，接近真值统计，但全局 MPJPE 会上升。
- 真实视频动捕数据（§5.3、附录 A.10）：KungFu 上 MPJPE 69.4，StableMotion 为 127.8；StableMotion 抖动略低（9.2 vs 12.0），但这是靠过度平滑、改变了动作本身。
- 消融（§5.4、Table 2）：逐步加入文本、2D 关键帧、LMQD、3D 关键帧，其中 3D 关键帧带来的增益最大；LMQD 改善接触和时间质量指标（MPJPE 不一定下降）；把潜空间 3D 关键帧编码换成关节空间 MLP 投影，时间质量明显变差（附录 A.8）。
- 用户研究（附录 A.11、Table 13）：专业动画师打分，自动清理任务中 CleanMDM 的伪影/自然度/忠实度为 4.13/4.41/4.63，StableMotion 为 3.45/3.61/2.33。

## 局限 / 存疑


## 与其他论文的关系

- [[01_Light-Loco-Parkour]]：两篇都要处理 GVHMR 从视频恢复的人体动作中的接触伪影；本文用网格感知接触投影修正 GVHMR 输出的滑步和悬空，Light-Loco-Parkour 则在物理仿真中跟踪修正 GVHMR + GMR 得到的种子动作与障碍的穿透

## 我的想法


## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 10 条

> formulates cleanup as masked conditional generation with plug-and-play conditions. This single model sup- ports arbitrary combinations of noisy 3D motion, sparse 2D keyframes, sparse 3D keyframes, and text.
> 批注：Claude：掩码条件生成，支持任意模态组合
> — [[lightorigins/papers/03_2610.05411_CleanMDM.pdf#page=1|p.1]]

> high-confidence frames are preserved, low-confidence frames are regenerated, and the boundary between the two is determined by the per-frame weights rather than a hard binary mask.
> 批注：Claude：逐帧置信度决定保留还是重新生成
> — [[lightorigins/papers/03_2610.05411_CleanMDM.pdf#page=2|p.2]]

> LMQD enforces a sequence-level distribution constraint and reduces skating, jitter, and penetration.
> 批注：Claude：LMQD 减少滑步、抖动和穿透
> — [[lightorigins/papers/03_2610.05411_CleanMDM.pdf#page=6|p.6]]

> Since standard SMPL foot keypoints may lie inside the mesh, we sample 54 vertices on each foot sole to better approximate the contact surface.
> 批注：Claude：MACP 每只脚底采样 54 个顶点
> — [[lightorigins/papers/03_2610.05411_CleanMDM.pdf#page=7|p.7]]

> CleanMDM substantially improves reconstruction fidelity and distributional realism over StableMotion, while simultaneously reducing contact-related artifacts (skating and penetra- tion) and temporal noise (acceleration error and jitter).
> 批注：Claude：自动清理优于 StableMotion
> — [[lightorigins/papers/03_2610.05411_CleanMDM.pdf#page=8|p.8]]

> In the most challenging multimodal cleanup setting, CleanMDM substantially outperforms GenMo (21.95 vs. 646.4 MPJPE), consistent with our expectation that a model designed for generation rather than cleanup does not explicitly preserve the input draft
> 批注：Claude：多模态清理 MPJPE 21.95 vs GenMo 646.4
> — [[lightorigins/papers/03_2610.05411_CleanMDM.pdf#page=8|p.8]]

> On KungFu, CleanMDM cuts MPJPE roughly in half compared with StableMotion (69.4 vs. 127.8), while StableMotion attains a marginally lower jitter (9.2 vs. 12.0) by over-smoothing the motion in a way that alters its action identity
> 批注：Claude：KungFu：MPJPE 69.4 vs 127.8，抖动 9.2 vs 12.0
> — [[lightorigins/papers/03_2610.05411_CleanMDM.pdf#page=8|p.8]]

> While global MPJPE can increase (due to sequence-level adjustments of root/ground alignment), C6 consistently reduces artifacts, including skating, penetration frequency/distance, and jitter, approaching the statistics of the ground truth.
> 批注：Claude：MACP 减少伪影但全局 MPJPE 上升
> — [[lightorigins/papers/03_2610.05411_CleanMDM.pdf#page=8|p.8]]

> Notably, the strongest gains appear when CleanMDM additionally leverages sparse 3D keyframes, which anchor the reconstruction inside corrupted intervals and reduce ambiguity.
> 批注：Claude：加入 3D 关键帧增益最大
> — [[lightorigins/papers/03_2610.05411_CleanMDM.pdf#page=9|p.9]]

> Auto cleanup StableMotion 3.45 3.61 2.33 CleanMDM 4.13 4.41 4.63
> 批注：Claude：用户研究：自动清理三项评分
> — [[lightorigins/papers/03_2610.05411_CleanMDM.pdf#page=22|p.22]]
<!-- highlights:end -->

## 摘要（中文）

动作捕捉数据很少能直接使用，因为它们通常存在缺失片段、抖动、漂移和接触伪影。传统上，损坏的动作由动画师清理：先从噪声动作中手动挑出关键帧，再修正这些关键帧，最后在修正后的关键帧之间插值，重建连贯的动作。生成式动作模型的兴起让自动清理成为可能，但大多数方法是可控性有限的黑盒去噪器，难以保留可靠的片段或执行用户的具体意图。

受动画工作流程启发，本文提出 CleanMDM，一个统一的多模态动作清理框架，把清理表述为带即插即用条件的掩码条件生成。这一个模型支持噪声 3D 动作、稀疏 2D 关键帧、稀疏 3D 关键帧和文本的任意组合。这一设计既能在无需额外用户标注的情况下自动清理，也能在多模态引导下进行可控清理。为进一步提升动作的真实感，我们引入潜在动作质量判别器（LMQD），以更好地匹配运动学分布，减少滑步、抖动和穿透伪影；并把网格感知接触投影（Mesh-Aware Contact Projection）作为测试时优化步骤，增强接触和物理一致性。

在多个数据集上的实验表明，CleanMDM 始终优于以往的清理和生成基线，而且低成本条件（文本和 2D 关键帧）在多模态清理场景中能带来可靠的可控性提升。

## 摘要（原文）

> Motion capture data is rarely directly usable, as they typically exhibit missing segments, jitter, drift and contact artifacts. Traditionally, corrupted motions are cleaned by animators through the manual identification of keyframes from noisy motion, subsequent keyframe correction, and interpolation between corrected keyframes to reconstruct coherent motion. While the rise of generative motion models has made automatic cleanup feasible, most approaches operate as black box denoisers with limited controllability, making it difficult to preserve reliable segments or enforce specific user intents. Inspired by animation workflows, we present CleanMDM, a unified multimodal motion cleanup framework that formulates cleanup as masked conditional generation with plug-and-play conditions. This single model supports arbitrary combinations of noisy 3D motion, sparse 2D keyframes, sparse 3D keyframes, and text. This design enables both automatic cleanup without additional user annotation and controllable cleanup under multimodal guidance. To further improve motion realism, we incorporate the Latent Motion Quality Discriminator (LMQD) to better match kinematic distributions and reduce skating, jitter, and interpenetration artifacts, and we apply Mesh-Aware Contact Projection as a test-time optimization step to enhance contact and physical consistency. Experiments across multiple datasets demonstrate that CleanMDM consistently outperforms prior cleanup and generation baselines, and that low cost conditions (text and 2D keyframes) provide reliable controllability gains in multimodal cleanup scenarios.
