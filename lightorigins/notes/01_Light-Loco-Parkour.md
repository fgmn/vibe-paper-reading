---
id: "01"
org: 亮源
short: "Light-Loco-Parkour"
title: "Light-Loco-Parkour: Versatile Perceptive Whole-Body Locomotion via Multi-Skill Distillation"
aliases: ["Light-Loco-Parkour"]
date: 2026-08-01
category: 运动控制
source: 亮源主导
partners: []
authors: ["Hongming Chen", "Zhuoran Li", "Hongxi Wang", "Jiangpeng Hu", "Ziliang Li", "Peize Liu", "QingRui Zhao", "Xuhao Liu", "Liang Pan", "Ximin Lyu", "Yuntao Ma", "Tingxiang Fan"]
arxiv: "2608.02653"
pdf: "[[lightorigins/papers/01_2608.02653_Light-Loco-Parkour.pdf]]"
code: ""
project: "https://light-loco-parkour.github.io/"
huggingface: []
license: arXiv 默认许可（不可再分发）
status: 未读
rating:
read_date:
tags: ["paper", "humanoid", "parkour", "whole-body-control", "real2sim2real", "distillation"]
---

# Light-Loco-Parkour: Versatile Perceptive Whole-Body Locomotion via Multi-Skill Distillation

> [!info] 论文信息
> arXiv [2608.02653](https://arxiv.org/abs/2608.02653) · v1 2026-08-01
> PDF：[[lightorigins/papers/01_2608.02653_Light-Loco-Parkour.pdf|本地 PDF]]
> [项目页](https://light-loco-parkour.github.io/) · [技术博客](https://www.lightorigins.com/blog/lightparkour) · [官网 PDF](https://static.lightorigins.com/website/reports/lightparkour-technical-report_687a744.pdf)

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 单个策略只凭深度和速度指令决定动作：“Conditioned only on onboard depth and a velocity command, the policy decides when to walk, balance, climb, step down, or vault, with no reference input, skill label, hand-coded gate, or runtime motion graph.”（Abstract）
> - 迭代自增强每轮把障碍和动作抬高 5–10 cm：“At each iteration, we lift both the obstacle and the motion by 5–10 cm so that the next round extracts a slightly harder version of the same skill.”（§V-A2）
> - 按相位切换的条件 AMP 驱动技能交接：“This phase switch is what actively drives the handoff: the robot is pushed to walk up to the obstacle and then, at the trigger, to adopt the skill that carries it across”（§V-C2）
> - Lightbot 0：90 cm、21 个驱动自由度：“Fig. 7: Lightbot 0 , the custom-built 90 90 cm humanoid used in all our experiments, with 21 21 actuated degrees of freedom, a chest-mounted depth camera, and a pelvis IMU.”（Fig. 7 caption）
> - 未见过的 50 cm 鞍马状障碍上 climb-and-step 仍成功：“We further replace the box with a 50 50 cm pommel-horse-like trapezoidal obstacle never seen in training, and the same skill still succeeds on the sloped, non-box profile”（§VII-B）
> - 只有本文参考满足四项要求：“As Table IV shows, only our references satisfy all four requirements at once: no penetration, no floating, object-paired, and dynamically feasible.”（§VII-C1）
> - 踏石成功率：学生 99.9、w/o FT 34.6、w/o GRU 0：“Perceptive locomotion: success rate (%) Stepping stones 99.9 99.9 34.6 34.6 0 0 99.9 99.9”（Table V）
> - 去掉专家蒸馏的教师无法收敛：“Following the HIL-style setting and removing expert distillation, the teacher fails to converge even though it still has privileged observations.”（§VII-C2）
> - 切换消融：33 / 51 / 98：“skills, w/o transition group 33 33 w/o AMP 51 51 Ours (with transition group) 98 98”（Table VII）
> - BeamDojo 在重叠设置上成功率低于本文：“BeamDojo is designed specifically for sparse footholds such as stepping stones and balance beams, yet its reported success remains lower than ours on the overlapping settings.”（§VII-C3）

## 一句话总结

单个端到端策略只凭板载深度图和速度指令，让人形机器人自主决定何时行走、何时用全身翻越或攀爬障碍。

## 要解决什么问题

现有人形全身控制要么跟踪富有表现力的全身参考动作却不能泛化到地形（mimic 类），要么用强化学习在线响应地形却几乎只用腿，手臂、躯干和膝盖基本闲置（locomotion 类）。把两者结合的全身运动还面临三个难题：与障碍接触精确配对的全身参考数据稀缺；从参考学到的技能往往只能在单一障碍上回放，难以跨障碍几何泛化；单个技能是短时程行为，长时程任务需要策略自己决定何时调用哪个技能、何时回到行走。最相关的已有工作中，PHP 依赖 one-hot 技能指令、难以准确跟踪速度，Zhang 等人的方法要在推理时额外运行动作生成器、需要专门的计算单元。

## 方法

- 感知运动主干（perceptive locomotion）：在 IsaacLab 中用 PPO 训练速度跟踪策略；教师读取无噪声高度扫描（height scan），采用非对称 actor-critic；设计速度松弛奖励（velocity-slack bonus）防止机器人在障碍前停步，以及基于足底向下射线的非法落脚惩罚（illegal-footstep penalty），见 §IV、Table I。
- 数据增强（data augmentation）：从网络视频用 GVHMR 提取 SMPL、用 GMR 重定向，再手动放置虚拟障碍，得到粗糙的“动作-地形”种子；在仿真中做物体交互模仿（object-interaction mimic，基于 BeyondMimic，跟踪全局根位置，并对接触部位加全局位置奖励），再迭代自增强（iterative self-augmentation）：每轮取得分最高的 rollout 作为下一轮参考，并把障碍和动作一起抬高 5–10 cm，得到动力学可行、与地形配对的参考序列，见 §V-A、Algorithm 1。
- 技能学习与泛化：每个技能选最难一档的专家，用 DAgger + PPO 蒸馏到与运动策略相同的观测（本体感觉、局部高度扫描、速度指令），不给技能标签；之后去掉专家，在随机摆放的障碍课程上加任务奖励继续训练，使技能跨障碍几何泛化，见 §V-B。
- 切换学习（transition learning）：先做多专家蒸馏（multi-expert distillation），把运动策略和各技能合并成一个学生策略；再加入“切换组”（transition group）做纯奖励的 RL 微调，用按相位切换的条件 AMP 先验（越过触发位置后从 locomotion AMP 切到 skill AMP）驱动交接，并在障碍后方也重置机器人以缓解稀疏奖励，见 §V-C。
- 从高度扫描到板载深度：把高度扫描策略蒸馏成 GRU 循环深度策略，加辅助的高度扫描重建损失，并用按 RealSense D435 标定的噪声-延迟模型做最后微调，见 §VI。

## 实验与关键数字

- 平台（§VII-A）：自研 90 cm 人形机器人 Lightbot 0，21 个驱动自由度，胸前一台 RealSense D435 深度相机；策略在板载 Jetson Orin Nano 上运行，不用 LiDAR、动捕或外部状态估计。
- 真机零样本部署（§VII-B）：室内外完成 reverse-vault、speed-vault、climb-and-step、窄桥、踏石、高台和户外台阶，并能自主串联行走与技能；把箱子换成训练中没见过的 50 cm 鞍马状梯形障碍，climb-and-step 仍能成功。
- 参考生成（Table IV）：与 GMR、OmniRetarget 相比，只有本文的参考同时满足无穿透、无悬空、与物体配对、动力学可行四项要求。
- 仿真消融与基准（Table V）：踏石上学生策略成功率 99.9%，去掉最终微调（w/o FT）降到 34.6%，去掉 GRU 记忆为 0；去掉专家蒸馏的教师（Teacher w/o ED）无法收敛；在重叠设置上，BeamDojo 报告的成功率低于本文。
- 切换消融（Table VII）：带切换组时切换+技能成功率 98%；去掉切换组（粗糙地形运动+技能）只有 33%，去掉 AMP 为 51%；站在障碍前下达后退指令时，策略能按指令后退。

## 局限 / 存疑


## 与其他论文的关系

- [[03_CleanMDM]]：两篇都要处理 GVHMR 从视频恢复的人体动作中的接触伪影；本文在物理仿真中用物体交互模仿修正种子动作与障碍的穿透，CleanMDM 用网格感知接触投影修正 GVHMR 输出的滑步和悬空

## 我的想法


## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 10 条

> Conditioned only on onboard depth and a velocity command, the policy decides when to walk, balance, climb, step down, or vault, with no reference input, skill label, hand-coded gate, or runtime motion graph.
> 批注：Claude：单个策略只凭深度和速度指令决定动作
> — [[lightorigins/papers/01_2608.02653_Light-Loco-Parkour.pdf#page=1|p.1]]

> At each iteration, we lift both the obstacle and the motion by 5–10 cm so that the next round extracts a slightly harder version of the same skill.
> 批注：Claude：迭代自增强每轮把障碍和动作抬高 5–10 cm
> — [[lightorigins/papers/01_2608.02653_Light-Loco-Parkour.pdf#page=8|p.8]]

> This phase switch is what actively drives the handoff: the robot is pushed to walk up to the obstacle and then, at the trigger, to adopt the skill that carries it across
> 批注：Claude：按相位切换的条件 AMP 驱动技能交接
> — [[lightorigins/papers/01_2608.02653_Light-Loco-Parkour.pdf#page=10|p.10]]

> We further replace the box with a 50 cm pommel-horse-like trapezoidal obstacle never seen in training, and the same skill still succeeds on the sloped, non-box profile
> 批注：Claude：未见过的 50 cm 鞍马状障碍上 climb-and-step 仍成功
> — [[lightorigins/papers/01_2608.02653_Light-Loco-Parkour.pdf#page=12|p.12]]

> Fig. 7. Lightbot 0, the custom-built 90 cm humanoid used in all our experiments, with 21 actuated degrees of freedom, a chest-mounted depth camera, and a pelvis IMU
> 批注：Claude：Lightbot 0：90 cm、21 个驱动自由度
> — [[lightorigins/papers/01_2608.02653_Light-Loco-Parkour.pdf#page=12|p.12]]

> As Table IV shows, only our refer- ences satisfy all four requirements at once: no penetration, no floating, object-paired, and dynamically feasible.
> 批注：Claude：只有本文参考满足四项要求
> — [[lightorigins/papers/01_2608.02653_Light-Loco-Parkour.pdf#page=13|p.13]]

> Perceptive locomotion: success rate (%) Stepping stones 99.9 34.6 0 99.9
> 批注：Claude：踏石成功率：学生 99.9、w/o FT 34.6、w/o GRU 0
> — [[lightorigins/papers/01_2608.02653_Light-Loco-Parkour.pdf#page=15|p.15]]

> Following the HIL-style setting and removing expert distillation, the teacher fails to converge even though it still has privileged observations.
> 批注：Claude：去掉专家蒸馏的教师无法收敛
> — [[lightorigins/papers/01_2608.02653_Light-Loco-Parkour.pdf#page=15|p.15]]

> skills, w/o transition group 33 w/o AMP 51 Ours (with transition group) 98
> 批注：Claude：切换消融：33 / 51 / 98
> — [[lightorigins/papers/01_2608.02653_Light-Loco-Parkour.pdf#page=16|p.16]]

> Beam- Dojo is designed specifically for sparse footholds such as stepping stones and balance beams, yet its reported success remains lower than ours on the overlapping settings.
> 批注：Claude：BeamDojo 在重叠设置上成功率低于本文
> — [[lightorigins/papers/01_2608.02653_Light-Loco-Parkour.pdf#page=16|p.16]]
<!-- highlights:end -->

## 摘要（中文）

现有的人形机器人全身控制系统，与人类穿越杂乱地形的方式仍有差距：它们要么跟踪富有表现力的全身参考动作，却无法泛化到不同地形；要么能在线对地形做出反应，却几乎不使用手臂、躯干和膝盖。本文提出 Light-Loco-Parkour（LightLP），一个端到端的感知式全身运动系统，用单个可部署策略弥合这一差距。该策略仅以板载深度图和速度指令为条件，自行决定何时行走、保持平衡、攀爬、下台阶或翻越，不需要参考输入、技能标签、手工设计的门控或运行时动作图。

与以往的人形系统相比，LightLP 有三点贡献。第一，它提出一条全身感知控制流程：在强化学习训练的速度跟踪运动策略基础上，扩展出从物体交互动作中学到的跑酷技能，使同一个策略在开阔地形跟踪速度、在障碍处执行全身穿越，并在之后恢复正常行走。第二，它从稀疏种子中习得地形条件化的技能：把单条动作扩展为一系列动力学可行、与障碍几何配对的参考动作，而不是依赖大规模动作库。第三，它从奖励中学习自主的技能切换，让策略仅凭深度图和指令决定何时调用哪种全身技能，不需要 one-hot 技能标签、手工状态机或运行时动作生成器。

仿真和真实世界实验表明，该系统在基准地形和未见过的障碍变体上都取得了高成功率，同一个策略可零样本迁移到室内和室外的硬件实验中。这些结果展示了人形机器人在户外环境中，仅依靠板载传感和单个可部署策略，实现自主的感知式全身运动。

## 摘要（原文）

> Existing humanoid whole-body control systems still fall short of the way humans move through cluttered terrain: they either track expressive whole-body references without terrain generalization, or react to terrain online while leaving the arms, torso, and knees largely unused. We present \texttt{Light-Loco-Parkour} (LLP), an end-to-end perceptive whole-body locomotion system that closes this gap with a single deployable policy. Conditioned only on onboard depth and a velocity command, the policy decides when to walk, balance, climb, step down, or vault, with no reference input, skill label, hand-coded gate, or runtime motion graph. Compared with prior humanoid systems, LLP makes three contributions. First, it introduces a whole-body perceptive-control pipeline that extends an RL-trained, velocity-tracking locomotion policy with parkour skills learned from object-interacting motions, so the same policy tracks velocity in open terrain, executes whole-body traversal at obstacles, and resumes locomotion afterward. Second, it acquires terrain-conditioned skills from sparse seeds by expanding a single motion into dynamically feasible, terrain-paired references across obstacle geometry, rather than relying on a large motion corpus. Third, it learns autonomous skill transitions from reward, letting the policy decide when and which whole-body skill to invoke from depth and command alone, with no one-hot skill label, hand-coded state machine, or runtime motion generator. Simulation and real-world experiments show high success across both benchmarked terrains and unseen obstacle variations, and the same policy transfers zero-shot to indoor and outdoor hardware experiments. These results demonstrate autonomous perceptive whole-body locomotion on a humanoid in outdoor settings, using only onboard sensing and a single deployable policy.
