---
id: "05"
org: 小鹏
short: "High-Performance N-Queens Solver on GPU: Iterative DFS with Zero Bank Conflicts"
title: "High-Performance N-Queens Solver on GPU: Iterative DFS with Zero Bank Conflicts"
aliases: ["High-Performance N-Queens Solver on GPU: Iterative DFS with Zero Bank Conflicts"]
date: 2025-11-15
category: "其他"
source: "小鹏主导"
product: ""
partners: []
authors: ["Guangchao Yao", "Yali Li"]
arxiv: "2511.12009"
pdf: "[[xpeng/papers/05_2511.12009_High-Performance-N-Queens-Solver-on-GPU.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "xpeng"]
---

# High-Performance N-Queens Solver on GPU: Iterative DFS with Zero Bank Conflicts

> [!info] 论文信息
> arXiv [2511.12009](https://arxiv.org/abs/2511.12009) · v1 2025-11-15
> PDF：[[xpeng/papers/05_2511.12009_High-Performance-N-Queens-Solver-on-GPU.pdf|本地 PDF]]
> 方向：其他 · 角色：小鹏主导
> 清单里的一句话（Claude 根据摘要写，请核对）：GPU上零bank冲突迭代DFS的高性能N皇后求解器。
> 汇总：[[xpeng/小鹏-论文与报告汇总|小鹏论文与报告汇总]]

## 一句话总结

## 要解决什么问题

## 方法

## 实验与关键数字

## 局限 / 存疑

## 与其他论文的关系

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> The counting of solutions to the N-Queens problem is a classic NP-complete problem with extremely high computational complexity. As of now, the academic community has rigorously verified the number of solutions only up to N <= 26. In 2016, the research team led by PreuBer solved the 27-Queens problem using FPGA hardware, which took approximately one year, though the result remains unverified independently. Recent studies on GPU parallel computing suggest that verifying the 27-Queens solution would still require about 17 months, indicating excessively high time and computational resource costs. To address this challenge, we propose an innovative parallel computing method on NVIDIA GPU platform, with the following core contributions: (1) An iterative depth-first search (DFS) algorithm for solving the N-Queens problem; (2) Complete mapping of the required stack structure to GPU shared memory; (3) Effective avoidance of bank conflicts through meticulously designed memory access patterns; (4) Various optimization techniques are employed to achieve optimal performance. Under the proposed optimization framework, we successfully verified the 27-Queens problem in just 28.4 days using eight RTX 5090 GPUs, thereby confirming the correctness of PreuBer's computational results. Moreover, we have reduced the projected solving time for the next open case-the 28-Queens problem-to approximately 11 months, making its resolution computationally feasible. Compared to the state-of-the-art GPU methods, our method achieves over 10x speedup on identical hardware configurations (8 A100), while delivering over 26x acceleration when utilizing 8 RTX 5090 GPUs, and brings fresh perspectives to this long-stagnant problem.
