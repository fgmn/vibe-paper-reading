---
id: "09"
org: 自变量
short: "HOST"
title: "HOST:Robots Acquire Manipulation Skills in Seconds from a Single Human Video"
aliases: ["HOST"]
date: 2026-07-22
category: 技能学习
source: 自变量主导
partners: ["北京理工大学", "清华大学"]
authors: ["Guangyan Chen", "Meiling Wang", "Te Cui", "Zichen Zhou", "Qi Shao", "Shalfun Li", "Hang Su", "Roy Gan", "Hao Wang", "Mengyin Fu", "Yi Yang", "Yufeng Yue"]
arxiv: "2607.20033"
pdf: "[[xsquare/papers/09_2607.20033_HOST.pdf]]"
code: "https://github.com/CGuangyan-BIT/HOST"
project: "https://x2robot.com/pages/host"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "one-shot-imitation", "human-video", "skill-acquisition"]
---

# HOST:Robots Acquire Manipulation Skills in Seconds from a Single Human Video

> [!info] 论文信息
> arXiv [2607.20033](https://arxiv.org/abs/2607.20033) · v1 2026-07-22 · 最新 v4（2026-08-20）
> PDF：[[xsquare/papers/09_2607.20033_HOST.pdf|本地 PDF]]
> [代码](https://github.com/CGuangyan-BIT/HOST) · [项目页](https://x2robot.com/pages/host)
> 合作单位：北京理工大学、清华大学

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

## 一句话总结

机器人看一段人类视频，就能在推理阶段约 29 秒内学会新技能，不需要微调，也不会遗忘已掌握的技能。

## 要解决什么问题

习得新技能依赖"采集示范 → 微调"的训练期循环：慢、贵，还会侵蚀已掌握的技能。已有的单样本视觉模仿（OSVI）方法只把示范视频当作被动的条件输入，难以把视频里的操作流程转化为机器人动作。

## 方法

- 自我锚定预测（self-grounded prediction）的三级级联：
  1. 估计机器人在示范任务中的进度；
  2. 把接下来的进展转化为机器人自己未来的观测；
  3. 从预测出的观测推导出动作。
- 训练目标与示范视频绑定：把机器人轨迹和视频映射到共享的"任务进度流形"上，再让每个预测目标对齐视频的后续进展。
- 实现细节（对齐模块、自回归扩散模型）见附录 B。

## 实验与关键数字

- 50 个新操作任务
- 平均习得耗时 29 秒，平均成功率 62%
- 比零样本基线高 45%，同时保留已掌握技能
- 超过"每任务 50 条机器人示范微调"的基线：示范少 50 倍，习得快 507 倍

## 局限 / 存疑

## 与其他论文的关系

- 同样从人类数据学习：[[08_XRZero-G0]]（免机器人数据采集）、[[23_EgoJEPA]]（第一视角视频）
- "先预测未来观测、再推出动作"的思路，可对照 [[03_WALL-WM]] 的世界动作模型

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（中文）

对机器人来说，能够快速、轻松地习得新技能，同时保留已经掌握的技能，至关重要。然而，现有方法仍依赖繁琐的"训练期循环"：成本高、速度慢，还会侵蚀已掌握的技能。本文提出 HOST（Human-to-robot One-Shot Skill AcquisiTion，人到机器人的单样本技能习得）。这一框架让机器人只需一段人类视频，就能在数秒内习得新技能，同时保留原有技能。

HOST 通过一串层层递进的"自我锚定预测"来完成技能习得：先估计机器人在示范任务中进行到了哪一步；再把接下来的任务进展转化为机器人自身未来的观测画面；最后从这些预测出的观测中推导出动作。这条预测链的训练目标与视频示范是绑定的：先把机器人轨迹和视频示范映射到一个共享的"任务进度流形"上，再重新定义每个训练目标，使其对齐视频接下来的进展。这样，机器人就能主动跟随示范的操作流程，并把它适配到自己的本体上。

HOST 在推理阶段仅凭一段人类视频即可习得新技能，平均耗时 29 秒，平均成功率 62%。它比零样本基线高出 45%，同时保留了原有技能。它甚至超过了"每个任务用 50 条机器人示范微调"的基线，所需示范少 50 倍，每项技能的习得速度快 507 倍。

## 摘要（原文）

> The ability to acquire skills rapidly and effortlessly while retaining those already mastered is essential for robots. However, current methods still rely on a cumbersome training-time loop that is costly and slow, while eroding skills already mastered. In this paper, we introduce HOST (Human-to-robot One-Shot Skill AcquisiTion), a framework that enables a robot to acquire skills in seconds from a single human video while retaining previously mastered skills. HOST resolves skill acquisition through a cascade of self-grounded prediction. It first estimates the robot's progress within the demonstrated task, then translates the upcoming progression into the robot's own future observations, and finally derives actions from these predicted observations. This cascade is trained on targets coupled to the video demonstration, obtained by mapping the robot trajectory and the video demonstration onto a shared task progress manifold, then redefining each target to align with the future progression of the video. HOST thereby enables the robot to actively follow the demonstrated procedure and adapt it to the robot's embodiment. HOST acquires novel skills at inference time from a single human video in an average of 29 seconds and achieves a 62% average success rate. It exceeds the zero-shot baseline by 45% while retaining previously mastered skills. HOST even exceeds the baseline fine-tuned on 50 robot demonstrations per task while requiring 50 times fewer demonstrations and acquiring each skill 507 times faster. Additional information about HOST is available on the project website.
