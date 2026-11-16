---
id: "43"
org: 英伟达
short: "GRAIL"
title: "GRAIL: Generating Humanoid Loco-Manipulation from World Models"
aliases: ["GRAIL"]
date: 2026-06-03
category: "合成数据与世界模型"
source: "英伟达主导"
partners: []
authors: ["Tianyi Xie", "Haotian Zhang", "Jinhyung Park", "Zi Wang", "Bowen Wen", "Jiefeng Li", "Xueting Li", "Qingwei Ben", "Haoyang Weng", "Yufei Ye", "David Minor", "Tingwu Wang", "Chenfanfu Jiang", "Sanja Fidler", "Jan Kautz", "Linxi Fan", "Yuke Zhu", "Zhengyi Luo", "Umar Iqbal", "Ye Yuan"]
arxiv: "2606.05160"
pdf: "[[nvidia/papers/43_2606.05160_GRAIL.pdf]]"
code: ""
project: "https://research.nvidia.com/labs/dair/grail/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "nvidia"]
---

# GRAIL: Generating Humanoid Loco-Manipulation from World Models

> [!info] 论文信息
> arXiv [2606.05160](https://arxiv.org/abs/2606.05160) · v1 2026-06-03 · 最新 v2（2026-10-19）
> PDF：[[nvidia/papers/43_2606.05160_GRAIL.pdf|本地 PDF]]
> [项目页](https://research.nvidia.com/labs/dair/grail/)
> 系列：物理AI · 合成数据与世界模型 · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：GRAIL：将视频世界模型锚定到 3D 资产与仿真场景，全虚拟合成人形移动操作数据，免去真实场景搭建与遥操作。
> 汇总：[[nvidia/英伟达-论文与报告汇总|英伟达论文与报告汇总]]

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

> Scaling humanoid loco-manipulation requires robot-compatible demonstrations across diverse objects, whole-body motions, and scene geometries, but teleoperation and motion capture are difficult to scale because each collection depends on physical setups, instrumented actors, and robot operation. We present GRAIL, a digital generation pipeline that remains fully virtual until deployment: it grounds video world models in 3D assets and simulator-ready scenes to synthesize interactions without rebuilding physical environments or teleoperating the robot. Rather than reconstructing unconstrained in-the-wild videos, GRAIL starts from fully specified 3D configurations in which object geometry, camera parameters, metric scale, environment depth, and a robot-proportioned character are known before video generation and reused during reconstruction. This privileged setup better conditions 4D recovery, allowing model-based object tracking, human motion estimation, and interaction-aware optimization to reconstruct metric 4D human-object interaction (HOI) trajectories with reduced depth ambiguity and morphology mismatch. We retarget the recovered motions to a humanoid robot and train complementary task-general trackers: an object-aware latent adaptor for manipulation and a scene-aware tracker for terrain traversal. GRAIL produces over 20,000 sequences spanning pick-up, whole-body manipulation, sitting, and terrain traversal. Using only GRAIL-generated data, we train egocentric visual policies through a sim-to-real pipeline and deploy them on a Unitree G1 humanoid, achieving 84% real-world success on diverse object pick-up and 90% success on stair-climbing.
