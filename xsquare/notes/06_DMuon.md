---
id: "06"
org: 自变量
short: "DMuon"
title: "DMuon: Efficient Distributed Muon Training with Near-Adam Overhead"
aliases: ["DMuon"]
date: 2026-06-25
category: 训练基础设施
source: 自变量主导
partners: []
authors: ["Vincent Chen", "Starrick Liu", "Regis Cheng", "Dance Yang", "Shalfun Li", "Ryan Yu", "Lucy Liang", "Hang Su", "Roy Gan", "Hao Wang", "Qian Wang"]
arxiv: "2606.27153"
pdf: "[[xsquare/papers/06_2606.27153_DMuon.pdf]]"
code: "https://github.com/X-Square-Robot/dmuon"
project: "https://x-square-robot.github.io/dmuon/"
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "optimizer", "distributed-training"]
---

# DMuon: Efficient Distributed Muon Training with Near-Adam Overhead

> [!info] 论文信息
> arXiv [2606.27153](https://arxiv.org/abs/2606.27153) · v1 2026-06-25
> PDF：[[xsquare/papers/06_2606.27153_DMuon.pdf|本地 PDF]]
> [代码](https://github.com/X-Square-Robot/dmuon) · [项目页](https://x-square-robot.github.io/dmuon/)

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 问题根源：NS 迭代需要完整矩阵：“Muon breaks this contract. Its core computation, the Newton–Schulz iteration, operates on the full weight matrix rather than individual shards.”（§1）
> - 即插即用、无需改框架：“we present DMuon, an open-source distributed Muon implementation that integrates into existing training pipelines as a drop-in module, with no framework-level modifications”（Abstract）
> - 每个矩阵一个 owner，只算一次更新：“DMuon instead assigns each matrix parameter to a single owner rank. The owner maintains the authoritative optimizer state for that matrix and computes its Muon update once”（§3.1）
> - 相对 Muon-AG 的端到端与优化器步加速：“Compared with the gather-then-compute Muon-AG baseline, DMuon achieves a 1.48 × – 3.01 × 1.48\times\!\text{--}\!3.01\times speedup in end-to-end step time and a 6.85 × – 163.00 × 6.85\times\!\text{--}\!163.00\times speedup in optimizer-step time.”（§5.1）
> - 平均步时在 AdamW 的 2% 以内：“Together these components reduce the end-to-end cost of running Muon to within 2% of AdamW’s step time on average”（§5.2）
> - 分解在 Wall-OSS-0.5 上逐项关闭测得：“Table 2 attributes DMuon’s optimizer-step speedup to its three main components, measured by disabling each in isolation on Wall-OSS-0.5”（§5.2）
> - 对称 Gram 内核贡献 48%：“The symmetric Gram kernel contributes the largest share (48%).”（§5.2）
> - owner 调度与负载均衡贡献 32%：“Owner scheduling with load balancing assignment accounts for a further 32%”（§5.2）
> - 自动调优与 NS 批处理贡献 16%：“The remaining 16% comes from auto-tuning and NS batching”（§5.2）
> - Wall-OSS 上 1–256 GPU 扩展：“Scaling results on Wall-OSS across 1–256 A800 GPUs. DMuon substantially reduces optimizer overhead and approaches AdamW-level throughput at larger scales.”（Figure 8 caption）

## 一句话总结

DMuon 让每个矩阵只由一个 owner 做 Muon 更新，再重叠通信、优化 NS 内核，使分布式 Muon 的单步开销接近 AdamW。

## 要解决什么问题

现有分布式训练栈默认优化器是逐元素的，每个 rank 只更新自己的参数分片；Muon 的 Newton–Schulz 迭代却要作用在完整矩阵上，于是每步都要重建矩阵，并在各 rank 上重复做同样的正交化，开销可与前向加反向相当甚至更高。VLA 训练的时间上下文较短，前向-反向在步时中占比小，这部分优化器开销更难摊薄。

## 方法

- 以 owner 为中心的执行（owner-style execution）：每个矩阵参数只分配给一个 owner rank，由它保存权威优化器状态并只计算一次 Muon 更新；非 owner 只在前向/反向需要时临时物化参数。一步训练分四个阶段：参数物化、梯度路由、owner 侧 Muon 更新、异步发布（§3.1、§3.5 Algorithm 1）。
- 以 owner 为中心的通信优化（Owner Centric Communication Optimization，§3.2）：细粒度权重布局用 XOR 规则把 owner 分散到不同节点和 GPU 列；广播和规约拆成节点间/节点内两级，在前向和反向中与计算流水重叠。
- 高效 Gram Newton–Schulz 迭代（§3.3）：沿用 Gram 空间的 NS 递推；小矩阵按形状批处理以提高占用率；利用 Gram 矩阵的对称性走 SYRK 式内核；用 TileLang 和 CUTE DSL 按矩阵形状自动调优，并把结果存入持久内核缓存。
- 计算感知负载均衡（Computation-Aware Load Balance，§3.4）：先实测每种形状、批大小的执行代价，再把 owner 分配写成最小化 makespan 的 MILP，初始化时求解一次；搜索空间过大时退回贪心分配。
- 作为即插即用模块接入 PyTorch FSDP2/HSDP，可与张量并行组合，保持精确的 Muon 更新语义；NS 迭代用 fp16 运行（§4）。

## 实验与关键数字

- 设置（§5）：A800 集群、bf16；四个生产负载 Wall-OSS-0.5、Pi0、Wall-WM、Qwen2.5-7B；对比 AdamW 和“先 all-gather 再计算”的朴素分布式 Muon（Muon-AG）。Wall-OSS 上的扩展实验覆盖 1–256 张 A800（图 8）。
- 相对 Muon-AG：端到端步时加速 1.48×–3.01×，优化器步时加速 6.85×–163.00×（§5.1、表 1）。注：表 1 中 Wall-WM 行的优化器加速比与该行原始时间之比对不上，摘要给出的 6.85× 和 163.00× 两个端点也与表中数值有出入，需核对原文。
- 相对 AdamW：几个组件合起来，平均端到端步时开销在 2% 以内（§5.1–5.2）。
- 加速来源分解（§5.2 表 2，在 Wall-OSS-0.5 上逐项关闭测得）：对称 Gram 内核占 48%，owner 调度与负载均衡占 32%，自动调优与 NS 批处理占 16%。
- 局限（§5.3）：单 GPU 训练时收益不明显，无法利用分布式执行带来的额外好处。

## 局限 / 存疑

## 与其他论文的关系

- 在 [[02_WALL-OSS-0.5]] 和 [[03_WALL-WM]] 的生产训练中使用并验证，两者也是 §5 的评测负载；图 1 的 loss 曲线来自 Wall-OSS-0.5 的真实训练

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 10 条

> we present DMuon, an open-source distributed Muon implementation that integrates into existing training pipelines as a drop-in module, with no framework-level modifications
> 批注：Claude：即插即用、无需改框架
> — [[xsquare/papers/06_2606.27153_DMuon.pdf#page=1|p.1]]

> Muon breaks this contract. Its core computation, the Newton–Schulz iteration, operates on the full weight matrix rather than individual shards.
> 批注：Claude：问题根源：NS 迭代需要完整矩阵
> — [[xsquare/papers/06_2606.27153_DMuon.pdf#page=1|p.1]]

> DMuon instead assigns each matrix parameter to a single owner rank. The owner maintains the authoritative optimizer state for that matrix and computes its Muon update once
> 批注：Claude：每个矩阵一个 owner，只算一次更新
> — [[xsquare/papers/06_2606.27153_DMuon.pdf#page=4|p.4]]

> Compared with the gather-then-compute Muon-AG baseline, DMuon achieves a 1.48→–3.01→speedup in end-to-end step time and a 6.85→–163.00→speedup in optimizer-step time
> 批注：Claude：相对 Muon-AG 的端到端与优化器步加速
> — [[xsquare/papers/06_2606.27153_DMuon.pdf#page=12|p.12]]

> Scaling results on Wall-OSS across 1–256 A800 GPUs. DMuon substantially reduces optimizer overhead and approaches AdamW-level throughput at larger scales.
> 批注：Claude：Wall-OSS 上 1–256 GPU 扩展
> — [[xsquare/papers/06_2606.27153_DMuon.pdf#page=13|p.13]]

> Table 2 attributes DMuon’s optimizer-step speedup to its three main components, measured by disabling each in isolation on Wall-OSS-0.5
> 批注：Claude：分解在 Wall-OSS-0.5 上逐项关闭测得
> — [[xsquare/papers/06_2606.27153_DMuon.pdf#page=14|p.14]]

> The symmetric Gram kernel contributes the largest share (48%).
> 批注：Claude：对称 Gram 内核贡献 48%
> — [[xsquare/papers/06_2606.27153_DMuon.pdf#page=14|p.14]]

> Owner scheduling with load balancing assignment accounts for a further 32%
> 批注：Claude：owner 调度与负载均衡贡献 32%
> — [[xsquare/papers/06_2606.27153_DMuon.pdf#page=14|p.14]]

> The remaining 16% comes from auto-tuning and NS batching
> 批注：Claude：自动调优与 NS 批处理贡献 16%
> — [[xsquare/papers/06_2606.27153_DMuon.pdf#page=14|p.14]]

> Together these components reduce the end-to-end cost of running Muon to within 2% of AdamW’s step time on average
> 批注：Claude：平均步时在 AdamW 的 2% 以内
> — [[xsquare/papers/06_2606.27153_DMuon.pdf#page=14|p.14]]
<!-- highlights:end -->

## 摘要（中文）

以 Muon 为代表的、基于矩阵正交化的优化器，已在各类现代深度学习负载上表现出很强的收敛性。随着模型架构的规模和异构性不断增长，这种矩阵感知的更新为传统的逐元素优化提供了有力的替代。然而，现有分布式训练基础设施是围绕逐元素优化器的假设构建的，与 Muon 这类矩阵级优化器很不匹配：Muon 的更新耦合整个权重矩阵，并且需要代价高昂的 Newton-Schulz 迭代。原生 Muon 实现的开销超过前向与反向传播的 2 倍。

为弥合这一差距，我们提出 DMuon：一个开源的分布式 Muon 实现，以即插即用模块的形式接入现有训练流水线，无需修改框架。在具身基础模型和大语言模型（LLM）训练负载上，DMuon 的端到端步时加速 1.48×–3.01×，优化器步时加速 6.85×–163.00×，使单步延迟接近 AdamW 水平，让我们的模型训练能够高效扩展。

## 摘要（原文）

> Matrix-orthogonalization-based optimizers, exemplified by Muon, have demonstrated strong convergence behavior across a wide range of modern deep learning workloads. The matrix-aware updates offer a compelling alternative to conventional element-wise optimization, particularly as model architectures continue to grow in scale and heterogeneity. Yet contemporary distributed training infrastructure built around the assumption of element-wise optimizers is poorly matched to matrix-level optimizers such as Muon, whose updates couple entire weight matrices and require costly Newton-Schulz iterations. Vanilla Muon implementations incur more than 2x the cost of forward and backward passes. To close this gap, we present DMuon, an open-source distributed Muon implementation that integrates into existing training pipelines as a drop-in module, with no framework-level modifications. Across both embodied foundation model and large language model (LLM) training workloads, DMuon achieves a 1.48x-3.01x speedup in end-to-end step time and a 6.85x-163.00x speedup in optimizer-step time, bringing per-step latency to near-AdamW levels and enabling efficient scaling in our model training.
