---
title: 递归自我改进（RSI）与 VLN / VLA
tags: [topic]
paper_count: 107
updated: 2026-11-04
---

# 递归自我改进（RSI）与 VLN / VLA

> [!info] 这份清单怎么来的
> RSI（recursive self-improvement，递归自我改进）指系统在循环里改进自己：自己产生数据、任务、奖励、纠错样本，或改写自己的代码、技能、世界模型，再用来更新自己，一轮接一轮。这里收集 107 篇相关工作，重点是用在导航（VLN）和 VLA 上的，分五节；第五节是可以接进 RSI 循环的环境与课程生成方法。
> - 这个方向在 2026 年秋天集中爆发：截至 2026-11-04，arXiv 上标题含 "recursive self-improvement" 的论文共 117 篇，其中 83 篇是 2026 年 9–10 月提交的。这里只挑了与导航和机器人相关的，以及它们依赖的基础工作，不是穷尽列表。
> - 检索时间 2026-11-04，来源是 Hugging Face 论文搜索、arXiv API 和网页搜索。每篇都对照 arXiv 页面核对过标题和首版日期；"怎么自我改进"依据的摘要原句都在摘要里找到了，"摘要里的关键数字"一栏的每个数字也都出现在摘要中。
> - "任务 / 闭环方式"一栏里的 ✦ 表示摘要里自己用了 self-improving、self-evolving 或 recursive self-improvement 这类说法；没有 ✦ 的是做法属于自我改进闭环、但没这样自称的工作。
> - 其中 4 篇也在 [[topics/视觉语言导航VLN|VLN 专题]] 里，链接栏直接指向那边已下载的 PDF。
> - 其余 103 篇的 PDF 在 `topics/papers/递归自我改进RSI/`，文件名开头的"节号-序号"和表格顺序一致；下载的是 2026-11-04 时 arXiv 上的最新版本，只存在本地，不进 git。
> - 发表信息只在 arXiv 备注、项目主页或官方代码仓库写明时才填，"—"表示只有预印本或没找到。每节按首版日期排序。"怎么自我改进"是 Claude 根据摘要写的一句话，读原文时请核对。

## 建议的阅读顺序

先看大模型上的几种自我改进做法，再看它们怎么搬到机器人和导航上：

1. [STaR](https://arxiv.org/abs/2203.14465)：让模型给大量问题生成推理链，只留答对的再微调，反复迭代，是自生成数据循环的原型。
2. [Self-Rewarding Language Models](https://arxiv.org/abs/2401.10020)：模型自己当评委给回答打分，构造偏好数据迭代训练，生成和评判能力一起提升。
3. [The Curse of Recursion](https://arxiv.org/abs/2305.17493)：反面教材，只拿模型生成的数据反复训练会导致模型崩溃，原始分布的尾部会消失。
4. [Voyager](https://arxiv.org/abs/2305.16291)：Minecraft 里靠自动课程探索，把自验证成功的行为存成可执行的技能库，持续积累能力。
5. [Darwin Godel Machine](https://arxiv.org/abs/2505.22954)：编码智能体反复改写自己的代码并实测，SWE-bench 从 20.0% 提到 50.0%。
6. [RoboCat](https://arxiv.org/abs/2306.11706)：机器人上的早期例子，新任务模型自己采数据，回灌下一轮训练。
7. [SOAR](https://arxiv.org/abs/2407.20635)：VLM 自动提出任务并判定成功，机器人在新环境里自主采数据重训，策略提升 2 倍。
8. [Self-Improving Embodied Foundation Models](https://arxiv.org/abs/2509.15155)：训练时顺带学"还剩几步"，再用它推出奖励和成功检测器，让机器人自主练习、在线强化学习。
9. [π*0.6](https://arxiv.org/abs/2511.14759)：VLA 在真实部署中把示范、自主数据和人工干预统一进强化学习，从经验里持续提升。
10. [SRDF](https://arxiv.org/abs/2412.08467)：VLN 的数据飞轮，导航器和指令生成器轮流互相改进，R2R 测试集 SPL 从 70% 到 78%，超过人类的 76%。
11. [CorrectNav](https://arxiv.org/abs/2508.10416)：找出自己偏航的轨迹，自动生成纠错数据继续训练，多轮"自我纠错飞轮"。
12. [RSI-Nav](https://arxiv.org/abs/2610.15782)：同一个模型给轨迹写指令、自己执行验证、保留合格样本再更新自己，R2R-CE 成功率 68.6%。
13. [ASENA](https://arxiv.org/abs/2609.39207)：不改模型权重，编码智能体写程序、修失败、沉淀技能，R2R 成功率从 72% 到 98%。
14. [Toward Recursive Self-Improvement in Physical AI](https://arxiv.org/abs/2610.29677)：综述，把 RSI 放进机器人学习的框架里，并给出评估原则。
15. [What Stops Recursive Self-Improvement in Robotics? Lessons from 123 Rounds of Agentic Skill Discovery](https://arxiv.org/abs/2609.31760)：让智能体对机器人自我改进跑 123 轮，总结 RSI 在机器人上停滞的原因。

| 节 | 篇数 |
|---|---|
| [[#一、导航与 VLN 中的自我改进]] | 30 |
| [[#二、VLA 与机器人策略中的自我改进]] | 31 |
| [[#三、物理 AI 的 RSI：综述与分析]] | 4 |
| [[#四、基础：大模型与智能体的自我改进]] | 29 |
| [[#五、环境与课程生成]] | 13 |

## 一、导航与 VLN 中的自我改进

导航智能体自己产生数据、纠错样本、奖励或经验，再用它们更新自己。包括 VLN、目标导航、社交导航、户外和空中导航。

| 日期 | 论文 | 发表 | 任务 / 闭环方式 | 怎么自我改进 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2024-03 | [**SELFI**](https://arxiv.org/abs/2403.00991)<br>Autonomous Self-Improvement with Reinforcement Learning for Social Navigation | CoRL 2024 | 社交导航<br>真机自主改进<br>✦ | 在离线模型式预训练策略之上，用真实机器人在线采集的经验做无模型强化学习快速微调，自主改进避障与社交合规行为。 | — | [[topics/papers/递归自我改进RSI/1-01_2403.00991_SELFI.pdf\|PDF]] · [主页](https://sites.google.com/view/selfi-rl/) |
| 2024-12 | [**SRDF**](https://arxiv.org/abs/2412.08467)<br>Bootstrapping Language-Guided Navigation Learning with Self-Refining Data Flywheel | — | VLN<br>数据飞轮 | 导航器筛选数据以训练更好的指令生成器，生成器再产出更优数据训练下一轮导航器，两者轮流互促，无需人工标注。 | after several flywheel rounds, the navigator elevates the performance boundary from 70% to 78% SPL on the classic R2R test set, surpassing human performance (76%) for the first time | [[topics/papers/视觉语言导航VLN/4-18_2412.08467_SRDF.pdf\|PDF]]（VLN 专题 4-18） · [代码](https://github.com/wz0919/VLN-SRDF) |
| 2025-06 | [**EvolveNav**](https://arxiv.org/abs/2506.01551)<br>Empowering LLM-Based Vision-Language Navigation via Self-Improving Embodied Reasoning | — | VLN<br>数据飞轮<br>✦ | 先用形式化 CoT 标签监督微调激活导航推理，再迭代地以模型自身的推理输出作为自增强 CoT 标签做自反思后训练。 | — | [[topics/papers/视觉语言导航VLN/3-11_2506.01551_EvolveNav.pdf\|PDF]]（VLN 专题 3-11） · [代码](https://github.com/expectorlin/EvolveNav) |
| 2025-06 | [**ATENA**](https://arxiv.org/abs/2506.06630)<br>Active Test-time Vision-Language Navigation | — | VLN<br>自生成奖励/评估 | 测试时依据情节成败反馈调整动作置信度，并让智能体对高置信情节自行评估成败作为反馈，持续在线自适应新环境。 | — | [[topics/papers/递归自我改进RSI/1-04_2506.06630_ATENA.pdf\|PDF]] |
| 2025-06 | [**NavMorph**](https://arxiv.org/abs/2506.23468)<br>A Self-Evolving World Model for Vision-and-Language Navigation in Continuous Environments | ICCV 2025 | VLN<br>世界模型自进化<br>✦ | 以紧凑潜表征建模环境动态的世界模型提供前瞻规划，配合上下文进化记忆在训练和在线测试中持续更新、自适应新环境。 | — | [[topics/papers/视觉语言导航VLN/3-14_2506.23468_NavMorph.pdf\|PDF]]（VLN 专题 3-14） · [代码](https://github.com/Feliciaxyao/NavMorph) |
| 2025-07 | [**SE-VLN**](https://arxiv.org/abs/2507.13152)<br>A Self-Evolving Vision-Language Navigation Framework Based on Multimodal Large Language Models | — | VLN<br>经验/记忆积累<br>✦ | 测试时把成功与失败案例转为分层记忆中的可复用知识，检索经验辅助多模态大模型推理，并以反思模块实现持续进化。 | SE-VLN achieved navigation success rates of 57% and 35.2% in unseen environments, representing absolute performance improvements of 23.9% and 15.0% over current state-of-the-art methods on R2R and REVERSE datasets, respectively | [[topics/papers/递归自我改进RSI/1-06_2507.13152_SE-VLN.pdf\|PDF]] |
| 2025-08 | [**CorrectNav**](https://arxiv.org/abs/2508.10416)<br>Self-Correction Flywheel Empowers Vision-Language-Action Navigation Model | — | VLN<br>自我纠错 | 在训练集上重评模型找出偏航轨迹，自动生成感知与动作的纠错数据继续训练，再重评获得新错误，多轮“自纠错飞轮”迭代提升。 | CorrectNav achieves new state-of-the-art success rates of 65.1% and 69.3%, surpassing prior best VLA navigation models by 8.2% and 16.4% | [[topics/papers/视觉语言导航VLN/3-17_2508.10416_CorrectNav.pdf\|PDF]]（VLN 专题 3-17） · [代码](https://github.com/owlet914/CorrectNav) · [主页](https://correctnav.github.io) |
| 2025-09 | [**SID**](https://arxiv.org/abs/2509.24910)<br>Learning Goal-Oriented Vision-and-Language Navigation with Self-Improving Demonstrations at Scale | ECCV 2026 | VLN<br>数据飞轮<br>✦ | 先用最短路径数据训练初始智能体，再让它生成带探索行为的新轨迹作为示范训练更强智能体，逐轮迭代提升探索与泛化能力。 | It notably achieves a 50.9% success rate on the unseen validation splits of SOON, surpassing prior leading approaches by a margin of 13.9%. | [[topics/papers/递归自我改进RSI/1-08_2509.24910_SID.pdf\|PDF]] · [代码](https://github.com/OpenGVLab/SID-VLN) |
| 2026-03 | [**CMMR-VLN**](https://arxiv.org/abs/2603.07997)<br>Vision-and-Language Navigation via Continual Multimodal Memory Retrieval | — | VLN<br>经验/记忆积累 | 构建以全景图和显著地标索引的多模态经验记忆供检索增强决策，并用反思式更新只保存完整成功路径与失败中的关键初始错误。 | average success rate improvements of 52.9%, 20.9% and 20.9%, and 200%, 50% and 50% over the NavGPT, the MapGPT, and the DiscussNav in simulation and real tests, respectively | [[topics/papers/递归自我改进RSI/1-09_2603.07997_CMMR-VLN.pdf\|PDF]] |
| 2026-04 | [**IRRL**](https://arxiv.org/abs/2604.07945)<br>Incremental Residual Reinforcement Learning Toward Real-World Learning for Social Navigation | RO-MAN 2026 | 社交导航<br>真机自主改进 | 结合无回放缓冲的增量学习与只学习基策略残差的残差强化学习，让机器人在真实环境运行中边走边学、适应未见场景。 | — | [[topics/papers/递归自我改进RSI/1-10_2604.07945_IRRL.pdf\|PDF]] |
| 2026-04 | [**SDB**](https://arxiv.org/abs/2604.19064)<br>The Essence of Balance for Self-Improving Agents in Vision-and-Language Navigation | — | VLN<br>其他<br>✦ | 针对从策略自生经验中自我改进的不稳定，把每步扩展成多个潜在行为假设并按可靠性软聚合，加正则平衡行为多样性与学习稳定性。 | on REVERIE val-unseen, SDB improves SPL from 33.73 to 35.93 and OSR from 51.07 to 54.25 | [[topics/papers/递归自我改进RSI/1-11_2604.19064_SDB.pdf\|PDF]] |
| 2026-05 | [**SimWorld Studio**](https://arxiv.org/abs/2605.09423)<br>Automatic Environment Generation with Evolving Coding Agent for Embodied Agent Learning | — | 户外导航<br>其他<br>✦ | 自进化编码智能体按验证反馈生成 UE5 环境；导航智能体的表现再引导生成贴近其能力边界的课程，环境与智能体协同进化。 | co-evolution yields an 18-point success-rate gain over fixed-environment learning and a 40-point gain over an untrained agent | [[topics/papers/递归自我改进RSI/1-12_2605.09423_SimWorld-Studio.pdf\|PDF]] |
| 2026-05 | [**Robo-Cortex**](https://arxiv.org/abs/2605.18729)<br>A Self-Evolving Embodied Agent via Dual-Grain Cognitive Memory and Autonomous Knowledge Induction | — | 多种导航<br>经验/记忆积累<br>✦ | 把成功模式与失败教训归纳为自然语言导航启发式库，配合短期反思记忆和长期原则记忆，在反思-适应循环中持续进化策略。 | with gains of up to +4.16% SPL over the strongest prior method and up to +15.30% SPL under heuristic transfer to unseen environments | [[topics/papers/递归自我改进RSI/1-13_2605.18729_Robo-Cortex.pdf\|PDF]] |
| 2026-05 | [**IDEA**](https://arxiv.org/abs/2605.23257)<br>Turning Adaptation into Assets: Cross-Domain Bridging for Online Vision-Language Navigation | ICML 2026 | VLN<br>经验/记忆积累 | 把每次测试时适应得到的软提示连同域坐标存入不断增长的资产库，再将新域投影到历史知识凸包构建跨域桥接，加速后续适应。 | — | [[topics/papers/递归自我改进RSI/1-14_2605.23257_IDEA.pdf\|PDF]] |
| 2026-06 | [**EvoMemNav**](https://arxiv.org/abs/2606.03509)<br>Efficient Self-Evolving Fine-Grained Memory for Zero-Shot Embodied Navigation | — | 目标导航<br>经验/记忆积累<br>✦ | 构建保留原始视图的视觉-语义记忆图，每个子任务后反思并回写图上先验，无需重训即可用累积的环境知识改进后续决策。 | — | [[topics/papers/递归自我改进RSI/1-15_2606.03509_EvoMemNav.pdf\|PDF]] · [代码](https://github.com/caicaiya123/EvoMemNav) |
| 2026-06 | [**AgenticRL**](https://arxiv.org/abs/2606.03963)<br>Agentic Reinforcement Learning with Self-Refinement for Complex UAV Navigation | — | 空中导航<br>自生成奖励/评估 | 多角色智能体生成可执行奖励、训练 PPO 策略后诊断其行为失败，据此给出修改指令并重写奖励，闭环迭代提升无人机导航。 | Reward refinement increases mean simulation success from 37.2% to 96.4%, while the resulting policies achieve a collective real-world success rate of 90.0% and a sim-to-real accuracy of 93.4%. | [[topics/papers/递归自我改进RSI/1-16_2606.03963_AgenticRL.pdf\|PDF]] |
| 2026-06 | [**AllDayNav**](https://arxiv.org/abs/2606.10927)<br>Lifelong Navigation via Real-World Reinforcement Learning | — | 多种导航<br>真机自主改进<br>✦ | 自进化多模态记忆维护关键帧与语义，并自主生成开放词汇指令、图像目标和结构化奖励，驱动真实世界强化学习的终身自学习。 | AllDayNav achieves success rates approaching $100\%$ | [[topics/papers/递归自我改进RSI/1-17_2606.10927_AllDayNav.pdf\|PDF]] · [主页](https://bagh2178.github.io/AllDayNav/) |
| 2026-06 | [**EvolveNav**](https://arxiv.org/abs/2606.18235)<br>Proactive Preflection and Self-Evolving Memory for Zero-Shot Object Goal Navigation | — | 目标导航<br>经验/记忆积累<br>✦ | 从历史轨迹提取可执行规则存入规则记忆，按 UCB 兼顾相关性与历史成功率检索，并在行动前预演，实现测试时持续改进。 | achieving a 10.1\% improvement in success rate with fewer unnecessary steps | [[topics/papers/递归自我改进RSI/1-18_2606.18235_EvolveNav.pdf\|PDF]] |
| 2026-07 | [**VTM-Nav**](https://arxiv.org/abs/2607.14514)<br>Harnessing Cross-Episode Experience for Object-Goal Navigation with Hierarchical Visual-Topological Memory | — | 目标导航<br>经验/记忆积累 | 跨情节保留自获取的分层视觉-拓扑场景记忆，新请求时重定位并检索目标相关记录引导决策，模型参数固定、无需重训即可复用经验。 | VTM-Nav exceeds the memory-reset WMNav control by 4.6, 2.0, and 0.8 SR points on HM3D v0.1, HM3D v0.2, and MP3D, respectively | [[topics/papers/递归自我改进RSI/1-19_2607.14514_VTM-Nav.pdf\|PDF]] |
| 2026-08 | [**SC²-WM**](https://arxiv.org/abs/2608.07548)<br>SC$^{2}$-WM: A Self-Correcting World Model with Closed-Loop Feedback for Vision-and-Language Navigation in Continuous Environments | ICML 2026 | VLN<br>世界模型自进化 | 用世界模型前瞻生成内部反馈，执行前做状态级计划修正；反馈显示模型能力不足时在测试时选择性更新世界模型本身。 | — | [[topics/papers/递归自我改进RSI/1-20_2608.07548_SC2-WM.pdf\|PDF]] · [代码](https://github.com/sunrise-ikun/SC2_WM) |
| 2026-08 | [**AeroDPO**](https://arxiv.org/abs/2608.07557)<br>Unleashing Lightweight UAV Navigation with High-Fidelity Perception and Automated Preference Optimization | — | 空中导航<br>自我纠错 | 无人机碰撞时回滚仿真状态，以出错动作为负样本、特权干预合成的避碰动作为正样本，自动构建偏好数据做 DPO。 | AeroDPO boosts success rates to 49.16% on unmapped scenarios while drastically suppressing collision rates | [[topics/papers/递归自我改进RSI/1-21_2608.07557_AeroDPO.pdf\|PDF]] · [代码](https://github.com/XuPeng23/AeroDPO) |
| 2026-09 | [**RegenHarness**](https://arxiv.org/abs/2609.27612)<br>A Robot Agent Harness with Evidence-Gated Recursive Self-Improvement | — | 多种导航<br>技能/代码自修改<br>✦ | 依据跨任务执行记录提出上下文规则、任务模板、路由和恢复策略的修改，经回归检查与发布授权后版本化上线，不更新模型权重。 | — | [[topics/papers/递归自我改进RSI/1-22_2609.27612_RegenHarness.pdf\|PDF]] |
| 2026-09 | [**NavHarness**](https://arxiv.org/abs/2609.34276)<br>Towards Lifelong Embodied Navigation | — | 多种导航<br>经验/记忆积累 | 免训练 harness 把地图、任务记录与房屋知识的核查和修正纳入导航循环，跨会话保存、验证并整合经验，支撑终身导航。 | On GOAT-Bench, NavHarness improves s-SR over context-only independent sessions by 18.6 points with Astra and 22.6 with Opus 5. | [[topics/papers/递归自我改进RSI/1-23_2609.34276_NavHarness.pdf\|PDF]] |
| 2026-09 | [**ASENA**](https://arxiv.org/abs/2609.39207)<br>Self-evolving Agents for Embodied Navigation | — | VLN<br>技能/代码自修改 | 编码智能体经机器人 harness 写程序、查看结果、修复失败并沉淀笔记与技能，权重不变，靠工作区持续进化提升导航成功率。 | Success increases from 72% to 98% on R2R and from 65% to 89% on RxR. | [[topics/papers/递归自我改进RSI/1-24_2609.39207_ASENA.pdf\|PDF]] · [主页](https://research.nvidia.com/labs/gear/asena) |
| 2026-10 | [**EMHO**](https://arxiv.org/abs/2610.08432)<br>EMbodied Agent Harness Optimization via Experience Traces | — | 目标导航<br>技能/代码自修改<br>✦ | 冻结具身模型，分析执行轨迹与历史 harness 版本，迭代改写进度监控、工具使用和失败应对等 harness 逻辑。 | — | [[topics/papers/递归自我改进RSI/1-25_2610.08432_EMHO.pdf\|PDF]] |
| 2026-10 | [**RIWANav**](https://arxiv.org/abs/2610.08640)<br>Recursive World-Action Models with Self-Improvement for Urban Navigation | — | 户外导航<br>世界模型自进化<br>✦ | 世界模型用想象结果给策略提供 GRPO 比较反馈，改进后的策略再挑选样本构建自课程更新世界模型，二者交替递归自我改进。 | — | [[topics/papers/递归自我改进RSI/1-26_2610.08640_RIWANav.pdf\|PDF]] |
| 2026-10 | [**VeriFine**](https://arxiv.org/abs/2610.08761)<br>Scaling Verification for Self-Improvement in Embodied Reasoning | — | 多种导航<br>自生成奖励/评估<br>✦ | 评分裁判诊断反复出现的失败并构建自适应课程优化策略；进展停滞时少量引入人类校准改进裁判，策略、课程与裁判协同进化。 | — | [[topics/papers/递归自我改进RSI/1-27_2610.08761_VeriFine.pdf\|PDF]] · [主页](https://veri-fine.github.io/) |
| 2026-10 | [**RSI-Nav**](https://arxiv.org/abs/2610.15782)<br>Data-Centric Recursive Self-Improvement for Navigation via Policy-Synchronized Language-Action Dual Bootstrapping | — | VLN<br>数据飞轮<br>✦ | 同一模型分片为无标注轨迹生成指令、自行执行验证并保留合格样本，随即自我更新，使生成的监督始终与进化中的策略同步。 | RSI-Nav reaches 68.6% SR on R2R-CE and 72.4% SR on RxR-CE | [[topics/papers/递归自我改进RSI/1-28_2610.15782_RSI-Nav.pdf\|PDF]] · [代码](https://github.com/OpenGVLab/RSI-Nav) |
| 2026-10 | [**WEDGE**](https://arxiv.org/abs/2610.19420)<br>From Failures to Learnable Worlds: Policy-Conditioned Environment Generation for Navigation Agents | — | 目标导航<br>其他 | 用 LLM 对比成功与失败轨迹提炼并验证策略弱点，据此生成针对性训练环境做适应，策略变强后再重新诊断，迭代循环。 | — | [[topics/papers/递归自我改进RSI/1-29_2610.19420_WEDGE.pdf\|PDF]] · [主页](https://zhangyuejoslin.github.io/WEDGE/) |
| 2026-10 | [**RetroNav**](https://arxiv.org/abs/2610.35172)<br>Scene-Grounded Retrospection and Retry for Self-Evolving Lifelong Navigation | — | 多种导航<br>经验/记忆积累<br>✦ | 统一记忆把场景知识与历史导航经验关联，每次尝试后由评估器判定是否重试，回顾智能体据证据生成重试简报，免训练自进化。 | — | [[topics/papers/递归自我改进RSI/1-30_2610.35172_RetroNav.pdf\|PDF]] · [代码](https://github.com/3dv-casia/RetroNav)（2026-11-04 打不开） |

## 二、VLA 与机器人策略中的自我改进

操作、移动操作和通用机器人策略的自我改进：自主采数据再训练、用 VLM 或世界模型当评判、在真机部署中持续学习、改写自己的技能代码。

| 日期 | 论文 | 发表 | 任务 / 闭环方式 | 怎么自我改进 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2023-06 | [**RoboCat**](https://arxiv.org/abs/2306.11706)<br>A Self-Improving Generalist Agent for Robotic Manipulation | TMLR 2023 | 通用机器人策略<br>数据飞轮 | 多本体目标条件决策 Transformer：微调出的新任务模型自行采集数据并回灌下一轮训练，构成自主改进循环的基础单元。 | adaptation using only 100-1000 examples for the target task | [[topics/papers/递归自我改进RSI/2-01_2306.11706_RoboCat.pdf\|PDF]] |
| 2024-07 | [**SOAR**](https://arxiv.org/abs/2407.20635)<br>Autonomous Improvement of Instruction Following Skills via Foundation Models | CoRL 2024 | 通用机器人策略<br>真机自主改进 | VLM 自动提出任务并判定成功，机器人在新环境自主采数据，再按目标图像生成+目标到达分解无标注地重训策略。 | in a suite of unseen environments, the robot policy can be improved 2x with autonomously collected data | [[topics/papers/递归自我改进RSI/2-02_2407.20635_SOAR.pdf\|PDF]] · [代码](https://github.com/rail-berkeley/soar) · [主页](https://auto-improvement.github.io) |
| 2025-06 | [**SILVR**](https://arxiv.org/abs/2506.06658)<br>Self-Improving Loops for Visual Robotic Planning | ICLR 2026 | VLA/操作<br>世界模型自进化<br>✦ | 视频生成式规划器在自身产生的轨迹上反复更新，无需真值奖励或专家示范，在新任务上随迭代持续提升。 | — | [[topics/papers/递归自我改进RSI/2-03_2506.06658_SILVR.pdf\|PDF]] · [代码](https://github.com/brown-palm/silvr) · [主页](https://diffusion-supervision.github.io/silvr/) |
| 2025-09 | [**Self-Improving Embodied Foundation Models**](https://arxiv.org/abs/2509.15155) | NeurIPS 2025 | 通用机器人策略<br>自生成奖励/评估<br>✦ | SFT 阶段同时学 steps-to-go，自改进阶段用它导出奖励与成功检测器，让机器人队列自主练习下游任务并在线 RL。 | — | [[topics/papers/递归自我改进RSI/2-04_2509.15155_Self-Improving-Embodied-Foundation.pdf\|PDF]] · [主页](https://self-improving-efms.github.io) |
| 2025-09 | [**DexFlyWheel**](https://arxiv.org/abs/2509.23829)<br>A Scalable and Self-improving Data Generation Framework for Dexterous Manipulation | NeurIPS 2025 (Spotlight) | 仿真数据<br>数据飞轮<br>✦ | 模仿学习+残差 RL 训练策略，在仿真中生成并增广轨迹后回灌下一轮，形成灵巧操作数据自增强飞轮。 | Policies trained on our dataset achieve an average success rate of 81.9% on the challenge test sets and successfully transfer to the real world through digital twin, achieving a 78.3% success rate on dual-arm lift tasks. | [[topics/papers/递归自我改进RSI/2-05_2509.23829_DexFlyWheel.pdf\|PDF]] · [主页](https://DexFlyWheel.github.io) |
| 2025-10 | [**Reflection-Based Task Adaptation for Self-Improving VLA**](https://arxiv.org/abs/2510.12710) | — | VLA/操作<br>自生成奖励/评估<br>✦ | VLM 对失败做因果反思自动合成稠密奖励驱动 RL，同时挑选高质量成功轨迹做 SFT，防止奖励投机。 | — | [[topics/papers/递归自我改进RSI/2-06_2510.12710_Reflection-Based-Task-Adaptation-for.pdf\|PDF]] |
| 2025-10 | [**PLD**](https://arxiv.org/abs/2511.00091)<br>Self-Improving Vision-Language-Action Models with Data Generation via Residual RL | ICLR 2026 | VLA/操作<br>数据飞轮<br>✦ | 残差 RL 探测 VLA 失败区域，按部署分布混合采集含恢复行为的轨迹，再 SFT 蒸馏回通用 VLA，实现自我改进。 | PLD achieves near-saturated 99% task success on LIBERO, over 50% gains in SimplerEnv, and 100% success on real-world Franka and YAM arm manipulation tasks. | [[topics/papers/递归自我改进RSI/2-07_2511.00091_PLD.pdf\|PDF]] · [主页](https://wenlixiao.com/self-improve-VLA-PLD) |
| 2025-11 | [**π*0.6**](https://arxiv.org/abs/2511.14759)<br>$π^{*}_{0.6}$: a VLA That Learns From Experience | — | 通用机器人策略<br>真机自主改进<br>✦ | RECAP 用优势条件化把示范、自主 on-policy 数据与人工干预统一进 RL，让 VLA 在真实部署中从经验持续提升。 | On some of the hardest tasks, RECAP more than doubles task throughput and roughly halves the task failure rate. | [[topics/papers/递归自我改进RSI/2-08_2511.14759_pi-0.6.pdf\|PDF]] · [主页](https://pi.website/blog/pistar06) |
| 2025-11 | [**SRPO**](https://arxiv.org/abs/2511.15605)<br>Self-Referential Policy Optimization for Vision-Language-Action Models | — | VLA/操作<br>自生成奖励/评估 | 以同批次中模型自己的成功轨迹为参照，在世界模型潜空间度量进度，给失败轨迹分配进度奖励来做 VLA-RL。 | Starting from a supervised baseline with 48.9% success, SRPO achieves a new state-of-the-art success rate of 99.2% in just 200 RL steps | [[topics/papers/递归自我改进RSI/2-09_2511.15605_SRPO.pdf\|PDF]] · [代码](https://github.com/sii-research/siiRL) |
| 2025-12 | [**EVOLVE-VLA**](https://arxiv.org/abs/2512.14666)<br>Test-Time Training from Environment Feedback for Vision-Language-Action Models | — | VLA/操作<br>自生成奖励/评估<br>✦ | 测试时训练：用学习到的进度估计器替代真值奖励提供稠密反馈，VLA 通过与环境交互持续自适应。 | +8.6% on long-horizon tasks, +22.0% in 1-shot learning | [[topics/papers/递归自我改进RSI/2-10_2512.14666_EVOLVE-VLA.pdf\|PDF]] · [代码](https://github.com/showlab/EVOLVE-VLA) · [主页](https://showlab.github.io/EVOLVE-VLA) |
| 2026-02 | [**World-VLA-Loop**](https://arxiv.org/abs/2602.06508)<br>Closed-Loop Learning of Video World Model and VLA Policy | — | VLA/操作<br>世界模型自进化 | 视频世界模型同时预测未来帧与奖励，用于 VLA 的 RL 后训练，新策略的 rollout 再回灌微调世界模型，形成共进化闭环。 | — | [[topics/papers/递归自我改进RSI/2-11_2602.06508_World-VLA-Loop.pdf\|PDF]] · [代码](https://github.com/showlab/World-VLA-Loop) · [主页](https://showlab.github.io/World-VLA-Loop/) |
| 2026-02 | [**RISE**](https://arxiv.org/abs/2602.11075)<br>Self-Improving Robot Policy with Compositional World Model | RSS 2026 | VLA/操作<br>世界模型自进化<br>✦ | 组合式世界模型预测多视角未来并用进度价值模型估优势，在想象空间中闭环生成 rollout 并更新 VLA 策略。 | more than +35% absolute performance increase in dynamic brick sorting, +45% for backpack packing, and +35% for box closing | [[topics/papers/递归自我改进RSI/2-12_2602.11075_RISE.pdf\|PDF]] · [代码](https://github.com/OpenDriveLab/RISE) · [主页](https://opendrivelab.com/RISE/) |
| 2026-02 | [**VLAW**](https://arxiv.org/abs/2602.12063)<br>Iterative Co-Improvement of Vision-Language-Action Policy and World Model | — | VLA/操作<br>世界模型自进化 | 用真机 rollout 提升动作条件视频世界模型的保真度，再用世界模型生成合成 rollout 改进 VLA，两者迭代共进。 | We achieve a 39.2% absolute success rate improvement over the base policy and 11.6% improvement from training with the generated synthetic rollouts. | [[topics/papers/递归自我改进RSI/2-13_2602.12063_VLAW.pdf\|PDF]] · [代码](https://github.com/Robert-gyj/Ctrl-World) · [主页](https://sites.google.com/view/vlaw-arxiv) |
| 2026-03 | [**Seed2Scale**](https://arxiv.org/abs/2603.08260)<br>A Self-Evolving Data Engine with Parallel Worlds Expansion for Scalable Robot Learning | — | 仿真数据<br>数据飞轮<br>✦ | 小 VLA 负责探索采集、大 VLM 打分过滤、目标模型学习，从 4 条种子示范自我演化并投射到多环境扩充数据。 | Seed2Scale achieves a remarkable 75.38% success rate in zero-shot real-world evaluations, where baseline methods fail completely (0%). | [[topics/papers/递归自我改进RSI/2-14_2603.08260_Seed2Scale.pdf\|PDF]] · [主页](https://terminators2025.github.io/Seed2Scale.github.io) |
| 2026-05 | [**Learning While Deploying**](https://arxiv.org/abs/2605.00416)<br>Fleet-Scale Reinforcement Learning for Generalist Robot Policies | — | 通用机器人策略<br>真机自主改进 | 16 台双臂机器人队列的离线到在线 RL：部署中收集自主 rollout 与人工干预，持续后训练并重新部署通用 VLA。 | A single generalist policy improves as fleet experience accumulates, reaching an average success rate of 95%, with the largest gains on long-horizon tasks. | [[topics/papers/递归自我改进RSI/2-15_2605.00416_Learning-While-Deploying.pdf\|PDF]] · [主页](https://learning-while-deploying.github.io/) |
| 2026-06 | [**Visual Verification Enables Inference-time Steering and Autonomous Policy Improvement**](https://arxiv.org/abs/2606.18247) | RSS 2026 | 通用机器人策略<br>自生成奖励/评估<br>✦ | 生成器-验证器框架：视觉验证器在推理时筛选动作，经验证的自生成轨迹再用于离线微调通用策略。 | — | [[topics/papers/递归自我改进RSI/2-16_2606.18247_Visual-Verification-Enables.pdf\|PDF]] · [代码](https://github.com/princeton-prism/veritas) · [主页](https://veritas-improvement.github.io) |
| 2026-06 | [**ENPIRE**](https://arxiv.org/abs/2606.19980)<br>Agentic Robot Policy Self-Improvement in the Real World | CoRL 2026 | VLA/操作<br>真机自主改进 | 为编码智能体提供自动复位、验证、并行 rollout 的真机闭环，智能体分析日志并改训练代码与算法来自主训练策略。 | frontier coding agents can autonomously train a policy to achieve a 99% success rate on challenging, dexterous manipulation tasks | [[topics/papers/递归自我改进RSI/2-17_2606.19980_ENPIRE.pdf\|PDF]] · [代码](https://github.com/NVlabs/ENPIRE) · [主页](https://research.nvidia.com/labs/gear/enpire) |
| 2026-06 | [**InSight**](https://arxiv.org/abs/2606.24884)<br>Self-Guided Skill Acquisition via Steerable VLAs | — | VLA/操作<br>数据飞轮 | VLM 找出 VLA 缺少的动作原语并用底层控制器尝试，成功片段加入训练集重训 VLA，无需目标技能人类示范。 | On hardware, acquired twisting and pouring skills achieve 92% and 96% success, versus 32% and 16% for a zero-shot CaP-X baseline. | [[topics/papers/递归自我改进RSI/2-18_2606.24884_InSight.pdf\|PDF]] · [代码](https://github.com/insight-vla/insight) · [主页](https://insight-vla.github.io) |
| 2026-07 | [**Policy-Level Recursive Self-Improvement for Embodied AI with a Criticality World Model**](https://arxiv.org/abs/2607.28251) | — | 通用机器人策略<br>世界模型自进化<br>✦ | 执行结果训练“危险度”世界模型，用其风险分数引导场景采集训练专家策略，再用风险门控在专家与原策略间切换。 | the composed systems reduce failure rates by 59--67% for locomotion and manipulation and 8--25% for VLA benchmarks relative to their respective baselines | [[topics/papers/递归自我改进RSI/2-19_2607.28251_Policy-Level-Recursive-Self-Improvement.pdf\|PDF]] |
| 2026-09 | [**SEES**](https://arxiv.org/abs/2609.32698)<br>A Self-Evolving Embodied System via Failure-Guided VLA Policy Adaptation | — | VLA/操作<br>自我纠错<br>✦ | 监控原子技能失败找出瓶颈，复现失败状态并由 LLM 生成成功判据构造仿真 RL 任务，在线更新共享 VLA 适配器。 | — | [[topics/papers/递归自我改进RSI/2-20_2609.32698_SEES.pdf\|PDF]] |
| 2026-09 | [**EVO-WAM**](https://arxiv.org/abs/2609.38057)<br>Evolving World Action Models through Video-Action Verification | — | VLA/操作<br>世界模型自进化 | 世界动作模型自生成视频-动作轨迹，经 VLM 判完成、逆动力学校验一致性后迭代自训练，无需外部执行即可适配新任务。 | On seven unseen RoboTwin 2.0 tasks, EVO-WAM increases average success rates from 26.9% to 68.0% for Cosmos3 and from 28.5% to 46.4% for DreamZero | [[topics/papers/递归自我改进RSI/2-21_2609.38057_EVO-WAM.pdf\|PDF]] · [代码](https://github.com/Clausy9/EVO-WAM) · [主页](https://evo-wam.github.io/) |
| 2026-09 | [**EmbodiRSI**](https://arxiv.org/abs/2609.38905)<br>Recursive Self-Improvement for Data-Efficient Robot Adaptation | — | VLA/操作<br>自我纠错<br>✦ | real-to-sim-to-real：按策略执行反馈生成纠错轨迹并定向采集弱点数据，在任务专属仿真中多轮迭代后迁回真机。 | EmbodiRSI increases scene-balanced autonomous simulation success from 50.4% to 83.5% over two RSI updates | [[topics/papers/递归自我改进RSI/2-22_2609.38905_EmbodiRSI.pdf\|PDF]] |
| 2026-10 | [**MobiAgent**](https://arxiv.org/abs/2610.03476)<br>Dual-Loop Recursive Policy Self-Improvement for Long-Horizon Mobile Manipulation | CoRL 2026 | 移动操作<br>数据飞轮<br>✦ | 内环用 VLM 规划与反思组合原子技能执行；外环自动切分、验证部署轨迹，聚类发现新技能并持续微调技能库。 | Through autonomous data recycling, success improves from 7.50% to 27.50% on RoboCasa and from 32.5% to 57.5% on Astribot S1. | [[topics/papers/递归自我改进RSI/2-23_2610.03476_MobiAgent.pdf\|PDF]] · [代码](https://github.com/kaiknower/MobiAgent) · [主页](https://kaiknower.github.io/mobiagent) |
| 2026-10 | [**EmbodiedSmith**](https://arxiv.org/abs/2610.07969)<br>Scaling Embodied Data through Recursive Self-Improvement Flywheel in Simulation | — | 仿真数据<br>数据飞轮<br>✦ | 智能体循环中场景生成与任务生成互相驱动、迭代修正，自动扩充多本体仿真数据用于机器人预训练与评测。 | — | [[topics/papers/递归自我改进RSI/2-24_2610.07969_EmbodiedSmith.pdf\|PDF]] |
| 2026-10 | [**PhysEvo**](https://arxiv.org/abs/2610.08995)<br>Astra Can Act, Let It | — | VLA/操作<br>技能/代码自修改<br>✦ | 冻结单一模型，元智能体依据轨迹诊断失败、修订工具与技能，并能改进自身诊断工具，实现元级自我改进。 | On eight manipulation tasks challenging direct Astra, PhysEvo achieves 55.00% success, compared with 1.25% for the direct-Astra reference. | [[topics/papers/递归自我改进RSI/2-25_2610.08995_PhysEvo.pdf\|PDF]] |
| 2026-10 | [**Co-Evolving Robot Orchestrators and Policies through Deployment**](https://arxiv.org/abs/2610.09228) | — | VLA/操作<br>数据飞轮<br>✦ | VLM 编排器与 VLA 在部署中共进化：从自身执行中整理技能示范微调策略，经验证提升后才采用新策略。 | Across ten simulated RoboLab tasks, Robo-COP raises mean held-out success from 64.8% to 73.8% over the same harness with a frozen policy | [[topics/papers/递归自我改进RSI/2-26_2610.09228_Co-Evolving-Robot-Orchestrators-and.pdf\|PDF]] · [主页](https://robo-cop.pages.dev/) |
| 2026-10 | [**Embodied Turing Machines**](https://arxiv.org/abs/2610.12369)<br>Stateful Code for Robot Recursive Self-Improvement | — | VLA/操作<br>技能/代码自修改<br>✦ | 把策略完全写成显式状态代码（COAP），由编码智能体闭环开发、扩展共享代码库，测试时不需要任何模型。 | On RoboDojo's 42 bimanual tasks, the resulting library reaches a success rate of 70.24% without a model at test time. | [[topics/papers/递归自我改进RSI/2-27_2610.12369_Embodied-Turing-Machines.pdf\|PDF]] |
| 2026-10 | [**RoboRSI**](https://arxiv.org/abs/2610.12424)<br>Stable, efficient, and reusable robot self-evolution in complex real-world environments | — | 移动操作<br>技能/代码自修改<br>✦ | 自顶向下技能细化：把执行结果归因到负责的技能分支并只修改该分支，多智能体诊断、验证后发布新技能并复用。 | exceeding the strongest baseline by 2.7 to 11.0 percentage points | [[topics/papers/递归自我改进RSI/2-28_2610.12424_RoboRSI.pdf\|PDF]] · [代码](https://github.com/nssmd/RoboRSI) · [主页](https://lab.noematrix.ai/blog/2-roborsi/)（2026-11-04 打不开） |
| 2026-10 | [**AdaRSI**](https://arxiv.org/abs/2610.20474)<br>On-Demand Recursive Self-Improvement for Embodied Agents | — | VLA/操作<br>技能/代码自修改<br>✦ | 编码智能体先改技能与 harness，再从保存状态重试归因持久失败，只对仍不可靠的子步骤用自采示范微调 VLA。 | raises its success on unseen composite tasks from 4.6% to 13.8% | [[topics/papers/递归自我改进RSI/2-29_2610.20474_AdaRSI.pdf\|PDF]] |
| 2026-10 | [**Learning from Fleet Experience**](https://arxiv.org/abs/2610.25736)<br>Collective Experience Learning Across 96 Robots | — | VLA/操作<br>真机自主改进 | 机器人队列汇集自身执行经验，用失败上下文检索成功片段做优先微调，更新共享策略后再下发，无需新示范。 | On multi-stage phone packaging, learning with 96 robots raises success from 79.2% to 98.3%. | [[topics/papers/递归自我改进RSI/2-30_2610.25736_Learning-from-Fleet-Experience.pdf\|PDF]] · [代码](https://github.com/RLinf/RLinf) · [主页](https://cel-robot-learning.github.io) |
| 2026-10 | [**TinyAstral**](https://arxiv.org/abs/2610.41216)<br>Transferring Self-Evolving Harnesses to Tiny Generalist Manipulation Agents | — | VLA/操作<br>技能/代码自修改<br>✦ | 冻结教师模型，由 LLM 智能体读轨迹提出 harness 修改并经配对统计检验接受，再把演化后的能力蒸馏进 4B 小模型。 | On RoboTwin, harness evolution raises the teacher's success from 33.4% to 63.6%; the final 4B student reaches 62.8%. | [[topics/papers/递归自我改进RSI/2-31_2610.41216_TinyAstral.pdf\|PDF]] · [代码](https://github.com/Garfield-kh/TinyAstral) · [主页](https://garfield-kh.github.io/TinyAstral/) |

## 三、物理 AI 的 RSI：综述与分析

讨论机器人上的递归自我改进能走多远、卡在哪里的综述、实证分析和规模规律。

| 日期 | 论文 | 发表 | 任务 / 闭环方式 | 怎么自我改进 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|---|
| 2026-09 | [**What Stops Recursive Self-Improvement in Robotics? Lessons from 123 Rounds of Agentic Skill Discovery**](https://arxiv.org/abs/2609.31760) | — | 分析/综述<br>技能/代码自修改 | 智能体观察机器人失败、诊断缺失能力、自写技能或安装外部模型并在仿真中测试，跑 123 轮后总结 RSI 停滞的瓶颈。 | We ran it for 123 improvement rounds on household manipulation tasks. | [[topics/papers/递归自我改进RSI/3-01_2609.31760_What-Stops-Recursive-Self-Improvement-in.pdf\|PDF]] |
| 2026-10 | [**Who Improves the Robot? Toward Physical Recursive Self-Improvement**](https://arxiv.org/abs/2610.18842) | — | 分析/综述<br>其他<br>✦ | 提出 L0–L5 分级框架区分能力级与元级、任务内与跨任务的改进，指出现有工作尚未实现严格意义的物理 RSI。 | — | [[topics/papers/递归自我改进RSI/3-02_2610.18842_Who-Improves-the-Robot-Toward-Physical.pdf\|PDF]] · [代码](https://github.com/SAIL-Research-Lab/Physical-RSI) |
| 2026-10 | [**Where is Physical RSI capability from? An Observational Scaling Law of LLM-as-policy**](https://arxiv.org/abs/2610.26848) | — | 分析/综述<br>其他<br>✦ | 提出 PhysRSI-eval 五轴指标，在 18 个操作任务上评测 VLM 智能体从物理失败中自我改进的速度与上限，并做观测式缩放分析。 | — | [[topics/papers/递归自我改进RSI/3-03_2610.26848_Where-is-Physical-RSI-capability-from-An.pdf\|PDF]] |
| 2026-10 | [**Toward Recursive Self-Improvement in Physical AI**](https://arxiv.org/abs/2610.29677) | — | 分析/综述<br>其他<br>✦ | 综述把 RSI 放进机器人学习框架，梳理从提升机器人能力到改进“产生能力的过程”本身的路径，并给出评估原则。 | — | [[topics/papers/递归自我改进RSI/3-04_2610.29677_Toward-Recursive-Self-Improvement-in.pdf\|PDF]] · [代码](https://github.com/Physical2RSI/Awesome-Physical2RSI) · [主页](https://physical2rsi.github.io/) |

## 四、基础：大模型与智能体的自我改进

具身 RSI 借用的思路大多来自这里：自生成训练数据、自我博弈、模型给自己打分、改写自身代码的智能体，以及对"自己训练自己"的风险分析。

### 自生成数据

| 日期 | 论文 | 发表 | 怎么自我改进 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2022-03 | [**STaR**](https://arxiv.org/abs/2203.14465)<br>Bootstrapping Reasoning With Reasoning | — | 用少量示例让模型为大量问题生成推理链，只保留答对的（答错则给出答案再合理化），微调后重复迭代。 | performs comparably to fine-tuning a 30$\times$ larger state-of-the-art language model on CommensenseQA | [[topics/papers/递归自我改进RSI/4-01_2203.14465_STaR.pdf\|PDF]] |
| 2022-12 | [**Self-Instruct**](https://arxiv.org/abs/2212.10560)<br>Aligning Language Models with Self-Generated Instructions | ACL 2023 | 模型自己生成指令、输入与输出样本，过滤无效和重复项后用来微调自身，几乎不需要人工标注。 | a 33% absolute improvement over the original model on Super-NaturalInstructions | [[topics/papers/递归自我改进RSI/4-02_2212.10560_Self-Instruct.pdf\|PDF]] · [代码](https://github.com/yizhongw/self-instruct) |
| 2023-12 | [**ReST-EM**](https://arxiv.org/abs/2312.06585)<br>Beyond Human Data: Scaling Self-Training for Problem-Solving with Language Models | TMLR | 采样模型解答，用二元正确性反馈过滤，在筛出样本上微调并重复数轮，以EM式自训练超越只用人类数据。 | — | [[topics/papers/递归自我改进RSI/4-03_2312.06585_ReST-EM.pdf\|PDF]] |
| 2025-06 | [**SEAL**](https://arxiv.org/abs/2506.10943)<br>Self-Adapting Language Models | — | 模型为新输入生成自编辑（微调数据与更新指令）并SFT持久更新权重，以更新后的下游表现作RL奖励来学会写自编辑。 | — | [[topics/papers/递归自我改进RSI/4-04_2506.10943_SEAL.pdf\|PDF]] · [代码](https://github.com/Continual-Intelligence/SEAL) · [主页](https://jyopari.github.io/posts/seal) |

### 自我博弈

| 日期 | 论文 | 发表 | 怎么自我改进 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2024-01 | [**SPIN**](https://arxiv.org/abs/2401.01335)<br>Self-Play Fine-Tuning Converts Weak Language Models to Strong Language Models | ICML 2024 | 自我博弈微调：当前模型学习区分上一轮自己生成的回答与人类标注回答，逐轮迭代直到策略贴合目标分布。 | — | [[topics/papers/递归自我改进RSI/4-05_2401.01335_SPIN.pdf\|PDF]] · [代码](https://github.com/uclaml/SPIN) |
| 2025-05 | [**Absolute Zero**](https://arxiv.org/abs/2505.03335)<br>Reinforced Self-play Reasoning with Zero Data | — | 单一模型既出题又解题，用代码执行器验证题目与答案作为可验证奖励，不用任何外部数据自我演化课程。 | — | [[topics/papers/递归自我改进RSI/4-06_2505.03335_Absolute-Zero.pdf\|PDF]] · [代码](https://github.com/LeapLabTHU/Absolute-Zero-Reasoner) · [主页](https://andrewzh112.github.io/absolute-zero-reasoner/) |
| 2025-08 | [**R-Zero**](https://arxiv.org/abs/2508.05004)<br>Self-Evolving Reasoning LLM from Zero Data | ICLR 2026 | 同一基座分出Challenger与Solver：前者出恰在能力边缘的题，后者解题，二者协同进化形成零数据自生成课程。 | boosting the Qwen3-4B-Base by +6.49 on math-reasoning benchmarks and +7.54 on general-domain reasoning benchmarks | [[topics/papers/递归自我改进RSI/4-07_2508.05004_R-Zero.pdf\|PDF]] · [代码](https://github.com/Chengsong-Huang/R-Zero) |
| 2026-01 | [**SOAR (LLM)**](https://arxiv.org/abs/2601.18778)<br>Teaching Models to Teach Themselves: Reasoning at the Edge of Learnability | ICML 2026 | 教师模型为学生出合成题，以学生在真实难题上的进步为奖励（双层元强化学习），帮模型突破稀疏奖励下的推理平台期。 | — | [[topics/papers/递归自我改进RSI/4-08_2601.18778_SOAR-LLM.pdf\|PDF]] · [主页](https://ssundaram21.github.io/soar/) |

### 自生成奖励/评估

| 日期 | 论文 | 发表 | 怎么自我改进 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2024-01 | [**Self-Rewarding Language Models**](https://arxiv.org/abs/2401.10020) | ICML 2024 | 模型用LLM-as-a-Judge给自己的回答打分构造偏好对并迭代DPO，指令遵循和自我评判能力同时提升。 | Fine-tuning Llama 2 70B on three iterations of our approach yields a model that outperforms many existing systems on the AlpacaEval 2.0 leaderboard, including Claude 2, Gemini Pro, and GPT-4 0613. | [[topics/papers/递归自我改进RSI/4-09_2401.10020_Self-Rewarding-Language-Models.pdf\|PDF]] |
| 2024-07 | [**Meta-Rewarding Language Models**](https://arxiv.org/abs/2407.19594)<br>Self-Improving Alignment with LLM-as-a-Meta-Judge | — | 在自奖励循环中加入元评判：模型评判自己的评判并据此改进打分能力，缓解自奖励训练的快速饱和。 | a win rate improvement of Llama-3-8B-Instruct from 22.9% to 39.4% on AlpacaEval 2, and 20.6% to 29.1% on Arena-Hard | [[topics/papers/递归自我改进RSI/4-10_2407.19594_Meta-Rewarding-Language-Models.pdf\|PDF]] |

### 代码/提示自修改

| 日期 | 论文 | 发表 | 怎么自我改进 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2023-10 | [**Self-Taught Optimizer (STOP)**](https://arxiv.org/abs/2310.02304)<br>Recursively Self-Improving Code Generation | COLM 2024 | 由LM驱动的改进器程序去优化任意程序，再把改进器用于改进自身代码，得到更强的改进器（模型权重不变）。 | — | [[topics/papers/递归自我改进RSI/4-11_2310.02304_Self-Taught-Optimizer-STOP.pdf\|PDF]] · [代码](https://github.com/microsoft/stop) |
| 2024-08 | [**ADAS**](https://arxiv.org/abs/2408.08435)<br>Automated Design of Agentic Systems | ICLR 2025 | 元智能体用代码不断编写新的智能体系统，依托持续增长的发现档案迭代，自动发明优于人工设计的智能体。 | — | [[topics/papers/递归自我改进RSI/4-12_2408.08435_ADAS.pdf\|PDF]] · [代码](https://github.com/ShengranHu/ADAS) · [主页](https://shengranhu.com/ADAS) |
| 2024-10 | [**Gödel Agent**](https://arxiv.org/abs/2410.04444)<br>A Self-Referential Agent Framework for Recursive Self-Improvement | ACL 2025 | 受哥德尔机启发，智能体借助LLM在运行时读取并改写自身逻辑与代码，仅由高层目标引导递归自我改进。 | — | [[topics/papers/递归自我改进RSI/4-13_2410.04444_G-del-Agent.pdf\|PDF]] · [代码](https://github.com/Arvid-pku/Godel_Agent) |
| 2025-05 | [**Darwin Godel Machine**](https://arxiv.org/abs/2505.22954)<br>Open-Ended Evolution of Self-Improving Agents | — | 编码智能体反复改写自身代码库并在编码基准上实测验证，用开放式进化档案保留多样变体，越改越会改自己。 | increasing performance on SWE-bench from 20.0% to 50.0%, and on Polyglot from 14.2% to 30.7% | [[topics/papers/递归自我改进RSI/4-14_2505.22954_Darwin-Godel-Machine.pdf\|PDF]] · [代码](https://github.com/jennyzzt/dgm) |
| 2025-06 | [**AlphaEvolve**](https://arxiv.org/abs/2506.13131)<br>A coding agent for scientific and algorithmic discovery | — | 多个LLM在进化框架中直接修改算法代码，由自动评估器反馈迭代优化；其成果还加速了支撑它自身的LLM训练。 | found a procedure to multiply two $4 \times 4$ complex-valued matrices using $48$ scalar multiplications; offering the first improvement, after 56 years, over Strassen's algorithm in this setting | [[topics/papers/递归自我改进RSI/4-15_2506.13131_AlphaEvolve.pdf\|PDF]] |
| 2026-03 | [**Hyperagents**](https://arxiv.org/abs/2603.19461) | — | 把任务智能体和元智能体合成一个可编辑程序，且元级修改流程本身也可被改写，实现“改进如何改进”的元认知自修改。 | — | [[topics/papers/递归自我改进RSI/4-16_2603.19461_Hyperagents.pdf\|PDF]] · [代码](https://github.com/facebookresearch/Hyperagents) |
| 2026-09 | [**AIDE²**](https://arxiv.org/abs/2609.26457)<br>Recursive self-improvement of AI research agents | — | AI研究智能体提出对自身代码的修改，在AI研发任务上评测自身变体并保留隐藏评测最优者，8天内连续自我升级7次。 | the rate falls from 55% to 32% during the run, 7 percentage points below the human-engineered agent | [[topics/papers/递归自我改进RSI/4-17_2609.26457_AIDE2.pdf\|PDF]] |
| 2026-10 | [**Skill^∞**](https://arxiv.org/abs/2610.35434)<br>Skill$^{\infty}$: Recursive Self-Improvement for Agent Skill Optimization | — | 元智能体按元技能优化任务技能，并用同一流程优化元技能本身，使技能优化过程本身递归地自我改进。 | On 83 SkillsBench tasks, Skill$^{\infty}$ reaches a pass rate of 60.7%, compared with 56.4% for human-curated skills and 54.5% for SkillEvolver. | [[topics/papers/递归自我改进RSI/4-18_2610.35434_Skill-inf.pdf\|PDF]] · [代码](https://github.com/taowangcheng/Skill-Infinity) |
| 2026-10 | [**The Trinity**](https://arxiv.org/abs/2610.36077)<br>Capability-Driven Recursive Self-Improvement for Multimodal Agents | — | 自动生成简化可验证的模拟世界供能力学习，并沿能力树进化可复用Harness模块，二者循环推进多模态智能体RSI。 | Our evolved Harnesses improve mean performance by 34 points across 28 training benchmarks and 26 points across 18 unseen benchmarks, including two real-world embodied tasks. | [[topics/papers/递归自我改进RSI/4-19_2610.36077_The-Trinity.pdf\|PDF]] · [代码](https://github.com/InfRec-Cardinal/The-Trinity) · [主页](https://trinity-rsi.github.io/) |

### 技能/反思积累

| 日期 | 论文 | 发表 | 怎么自我改进 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2023-03 | [**Reflexion**](https://arxiv.org/abs/2303.11366)<br>Language Agents with Verbal Reinforcement Learning | NeurIPS 2023 | 不更新权重：智能体对任务反馈做语言反思并存入情景记忆，在后续尝试中依据这些反思改进决策。 | Reflexion achieves a 91% pass@1 accuracy on the HumanEval coding benchmark, surpassing the previous state-of-the-art GPT-4 that achieves 80% | [[topics/papers/递归自我改进RSI/4-20_2303.11366_Reflexion.pdf\|PDF]] · [代码](https://github.com/noahshinn/reflexion) |
| 2023-05 | [**Voyager**](https://arxiv.org/abs/2305.16291)<br>An Open-Ended Embodied Agent with Large Language Models | — | Minecraft中的LLM智能体靠自动课程探索，把自验证成功的行为存成可执行代码技能库，借环境反馈迭代改进并持续积累能力。 | It obtains 3.3x more unique items, travels 2.3x longer distances, and unlocks key tech tree milestones up to 15.3x faster than prior SOTA. | [[topics/papers/递归自我改进RSI/4-21_2305.16291_Voyager.pdf\|PDF]] · [代码](https://github.com/MineDojo/Voyager) · [主页](https://voyager.minedojo.org/) |
| 2023-08 | [**ExpeL**](https://arxiv.org/abs/2308.10144)<br>LLM Agents Are Experiential Learners | AAAI 2024 | 智能体在训练任务中自主收集成败经验并提炼成自然语言洞见，推理时检索经验与洞见，随经验积累持续变强。 | — | [[topics/papers/递归自我改进RSI/4-22_2308.10144_ExpeL.pdf\|PDF]] · [代码](https://github.com/LeapLabTHU/ExpeL) · [主页](https://andrewzh112.github.io/expel) |
| 2026-08 | [**PAST-Bench**](https://arxiv.org/abs/2608.04003)<br>Benchmarking the Foundations of Recursive Self-Improvement in Personal Agents | — | 基准：让个人智能体在开/关“保留经验”的对照条件下顺序完成任务，检验记忆、技能复用等是否真带来后续提升及其作用路径。 | It spans 26 scenarios and 204 episodes across memory, procedural reuse, information gathering, and update. | [[topics/papers/递归自我改进RSI/4-23_2608.04003_PAST-Bench.pdf\|PDF]] · [代码](https://github.com/Gen-Verse/PAST-Bench) |

### 理论与风险

| 日期 | 论文 | 发表 | 怎么自我改进 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2023-05 | [**The Curse of Recursion**](https://arxiv.org/abs/2305.17493)<br>Training on Generated Data Makes Models Forget | — | 揭示用模型生成数据反复训练会导致模型崩溃：原始分布尾部消失且缺陷不可逆，在VAE、GMM和LLM中都会发生。 | — | [[topics/papers/递归自我改进RSI/4-24_2305.17493_The-Curse-of-Recursion.pdf\|PDF]] |
| 2024-04 | [**Is Model Collapse Inevitable? Breaking the Curse of Recursion by Accumulating Real and Synthetic Data**](https://arxiv.org/abs/2404.01413) | — | 实验与理论表明：用合成数据替换真实数据会崩溃，但让各代合成数据与原始真实数据累积共存，误差有上界，可避免崩溃。 | — | [[topics/papers/递归自我改进RSI/4-25_2404.01413_Is-Model-Collapse-Inevitable-Breaking.pdf\|PDF]] |
| 2026-09 | [**The Last AI Built by Humans**](https://arxiv.org/abs/2609.11873)<br>Toward Genuine Recursive Self-Improvement | — | 综述与路线图：用HCI指标揭示现有LLM的不足，把RSI分为从执行自主、策略自主、经验与环境自主到递归元改进的层级。 | — | [[topics/papers/递归自我改进RSI/4-26_2609.11873_The-Last-AI-Built-by-Humans.pdf\|PDF]] · [代码](https://github.com/theseus-labs-rsi/awesome-rsi) · [主页](https://theseus-labs-rsi.github.io/) |
| 2026-09 | [**Generalized Agent Iteration**](https://arxiv.org/abs/2609.13406)<br>One Formal Framework for Iterative Policy Improvement and Recursive Self-Improvement | — | 形式框架：把广义策略迭代与RSI统一为“评估—改进”循环，用改进机制是否属于智能体、评估标准是否外部锚定两维定位各系统。 | — | [[topics/papers/递归自我改进RSI/4-27_2609.13406_Generalized-Agent-Iteration.pdf\|PDF]] |
| 2026-10 | [**The Winner's Curse in LLM Self-Improvement Loops: Selection Noise, Lock-in, and Acceptance Rules**](https://arxiv.org/abs/2610.09239) | — | 把“变好就保留”的自改进步骤视为含噪选择：复用小评估集会系统性高估收益，后续多数提案其实有害，应报告留出集增益。 | the final selection-set score of greedy loops exceeded held-out accuracy by 13 to 20 points with 16 selection items and by 1 to 5 points with 256 | [[topics/papers/递归自我改进RSI/4-28_2610.09239_The-Winner-s-Curse-in-LLM.pdf\|PDF]] |
| 2026-10 | [**Trustworthy Recursive Self-Improvement in the Era of Large Models: Foundation, Risks, Evaluation and Open Challenges**](https://arxiv.org/abs/2610.35193) | — | 综述：给出RSI操作定义与诊断—提案—评估—实施（S1–S4）流程框架，从改进有效性、约束保持、有效监督三方面梳理风险与评测。 | — | [[topics/papers/递归自我改进RSI/4-29_2610.35193_Trustworthy-Recursive-Self-Improvement.pdf\|PDF]] · [代码](https://github.com/pujiayue/Trustworthy-RSI) |

## 五、环境与课程生成

本身不是 RSI，但有了参数化的场景和任务生成器后，可以接进 RSI 循环，让"练什么"也跟着学生一起进化：按学习进度挑参数、用后悔值驱动环境设计、自动放宽随机化范围、让大模型写新任务和新环境，以及程序化生成室内场景。

### 按学习进度采样

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2019-10 | [**ALP-GMM**](https://arxiv.org/abs/1910.07224)<br>Teacher algorithms for curriculum learning of Deep RL in continuously parameterized environments | CoRL 2019 | 教师在连续参数空间里采样程序化环境的参数，用高斯混合模型建模学生的绝对学习进度，据此出题，并能识别易、难和学不会的区域。 | — | [[topics/papers/递归自我改进RSI/5-01_1910.07224_ALP-GMM.pdf\|PDF]] · [代码](https://github.com/flowersteam/teachDeepRL) |
| 2020-10 | [**Prioritized Level Replay**](https://arxiv.org/abs/2010.03934) | — | 按再次训练时的学习潜力（用 TD 误差估计）优先重放程序化生成的关卡，自然形成由易到难的课程。 | over 76% improvement in test return relative to standard RL baselines | [[topics/papers/递归自我改进RSI/5-02_2010.03934_Prioritized-Level-Replay.pdf\|PDF]] |

### 对抗与共进化的环境设计

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2019-01 | [**POET**](https://arxiv.org/abs/1901.01753)<br>Paired Open-Ended Trailblazer (POET): Endlessly Generating Increasingly Complex and Diverse Learning Environments and Their Solutions | — | 边生成环境挑战边优化求解它们的智能体，多条路径并行探索，并允许解法在环境之间迁移，形成开放式、不断变难的课程。 | — | [[topics/papers/递归自我改进RSI/5-03_1901.01753_POET.pdf\|PDF]] |
| 2020-12 | [**PAIRED**](https://arxiv.org/abs/2012.02096)<br>Emergent Complexity and Zero-shot Transfer via Unsupervised Environment Design | — | 引入与环境生成器结盟的对手智能体，生成器最大化后悔值（对手回报减主角回报），自动产生可解、逐步变复杂的环境课程。 | — | [[topics/papers/递归自我改进RSI/5-04_2012.02096_PAIRED.pdf\|PDF]] |
| 2022-03 | [**ACCEL**](https://arxiv.org/abs/2203.01302)<br>Evolving Curricula with Regret-Based Environment Design | — | 在后悔值目标下对关卡做小幅编辑，保留处在智能体能力前沿的关卡，课程从简单开始逐步变复杂。 | — | [[topics/papers/递归自我改进RSI/5-05_2203.01302_ACCEL.pdf\|PDF]] · [主页](http://accelagent.github.io) |

### 自动域随机化

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2019-04 | [**Active Domain Randomization**](https://arxiv.org/abs/1904.04762) | — | 不再均匀采样随机化参数，而是学习采样策略：比较随机化环境和参考环境里的 rollout 差异，找出最有信息量的变化。 | — | [[topics/papers/递归自我改进RSI/5-06_1904.04762_Active-Domain-Randomization.pdf\|PDF]] · [代码](https://github.com/montrealrobotics/active-domainrand) |
| 2019-10 | [**ADR**](https://arxiv.org/abs/1910.07113)<br>Solving Rubik's Cube with a Robot Hand | — | 自动域随机化（ADR）随着策略变强不断放宽随机化范围，纯仿真训练的控制策略和视觉估计迁移到真机灵巧手解魔方。 | — | [[topics/papers/递归自我改进RSI/5-07_1910.07113_ADR.pdf\|PDF]] · [主页](https://openai.com/blog/solving-rubiks-cube/) |

### 大模型生成任务与环境

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2023-06 | [**OMNI**](https://arxiv.org/abs/2306.01711)<br>Open-endedness via Models of human Notions of Interestingness | — | 用基础模型当有趣度模型，在学得会的任务里再挑出有价值、够新颖的，避免在大量无趣的细微变体上浪费训练。 | — | [[topics/papers/递归自我改进RSI/5-08_2306.01711_OMNI.pdf\|PDF]] · [主页](https://www.jennyzhangzt.com/omni/) |
| 2023-11 | [**RoboGen**](https://arxiv.org/abs/2311.01455)<br>Towards Unleashing Infinite Data for Automated Robot Learning via Generative Simulation | ICML 2024 | 机器人智能体自己提出要学的任务，生成对应的仿真场景，分解子任务并选择学习方法、自动产生监督，形成提出—生成—学习的循环。 | — | [[topics/papers/递归自我改进RSI/5-09_2311.01455_RoboGen.pdf\|PDF]] |
| 2024-05 | [**OMNI-EPIC**](https://arxiv.org/abs/2405.15568)<br>Open-endedness via Models of human Notions of Interestingness with Environments Programmed in Code | — | 让基础模型直接写代码生成下一个可学且有趣的任务，环境和奖励函数一起生成，原则上能创造任何可仿真的学习任务。 | — | [[topics/papers/递归自我改进RSI/5-10_2405.15568_OMNI-EPIC.pdf\|PDF]] · [主页](https://dub.sh/omniepic) |
| 2024-11 | [**Eurekaverse**](https://arxiv.org/abs/2411.01775)<br>Environment Curriculum Generation via Large Language Models | CoRL 2024 | 把环境写成代码，让大模型逐步生成更难、更多样又学得会的地形，作为四足机器人跑酷的训练课程，并迁移到真机。 | — | [[topics/papers/递归自我改进RSI/5-11_2411.01775_Eurekaverse.pdf\|PDF]] · [主页](https://eureka-research.github.io/eurekaverse) |

### 程序化与语言生成场景

| 日期 | 论文 | 发表 | 做了什么 | 摘要里的关键数字 | 链接 |
|---|---|---|---|---|---|
| 2022-06 | [**ProcTHOR**](https://arxiv.org/abs/2206.06994)<br>Large-Scale Embodied AI Using Procedural Generation | — | 程序化生成可交互的室内房屋，可以采样任意规模的场景来训练和评测导航、重排和操作智能体。 | a sample of 10,000 generated houses; state-of-the-art results across 6 embodied AI benchmarks | [[topics/papers/递归自我改进RSI/5-12_2206.06994_ProcTHOR.pdf\|PDF]] · [主页](https://procthor.allenai.org) |
| 2023-12 | [**Holodeck**](https://arxiv.org/abs/2312.09067)<br>Language Guided Generation of 3D Embodied AI Environments | CVPR 2024 | 用 GPT-4 按文字提示生成 3D 室内环境，用物体间的空间关系约束优化布局，并用来在新类型场景里训练导航智能体。 | — | [[topics/papers/递归自我改进RSI/5-13_2312.09067_Holodeck.pdf\|PDF]] |

## 附：检索中看到、没有放进正文的

标题已对照 arXiv 核对。导航一组大多是测试时适应、人工反馈或纯强化学习，闭环不是靠自己产生的数据；其余两组和正文同类，2026 年 9–10 月的新论文尤其多，想扩充时可以从这里挑：

**导航**

- [Fast-Slow Test-Time Adaptation for Online Vision-and-Language Navigation](https://arxiv.org/abs/2311.13209)（2023-11）
- [OLiVia-Nav: An Online Lifelong Vision Language Approach for Mobile Robot Social Navigation](https://arxiv.org/abs/2409.13675)（2024-09）
- [General Scene Adaptation for Vision-and-Language Navigation](https://arxiv.org/abs/2501.17403)（2025-01）
- [User-Feedback-Driven Adaptation for Vision-and-Language Navigation](https://arxiv.org/abs/2512.10322)（2025-12）
- [Nipping the Drift in the Bud: Retrospective Rectification for Robust Vision-Language Navigation](https://arxiv.org/abs/2602.06356)（2026-02）
- [Self-Evolutionary Replanning for Failure-Aware Motion Planning](https://arxiv.org/abs/2603.02772)（2026-03）
- [All-day Multi-scenes Lifelong Vision-and-Language Navigation with Tucker Adaptation](https://arxiv.org/abs/2603.14276)（2026-03）
- [AVERT-VLN: Abstention-aware Visual Error Recovery and Training for Vision-and-Language Navigation](https://arxiv.org/abs/2609.39579)（2026-09）
- [Asking Less, Adapting Better: Feedback-Efficient Test-Time Adaptation for Vision-and-Language Navigation](https://arxiv.org/abs/2610.30643)（2026-10）

**机器人与VLA**

- [Self-Improving Robots: End-to-End Autonomous Visuomotor Reinforcement Learning](https://arxiv.org/abs/2303.01488)（2023-03）
- [Robot Fine-Tuning Made Easy: Pre-Training Rewards and Policies for Autonomous Real-World Reinforcement Learning](https://arxiv.org/abs/2310.15145)（2023-10）
- [SOE: Sample-Efficient Robot Policy Self-Improvement via On-Manifold Exploration](https://arxiv.org/abs/2509.19292)（2025-09）
- [Toward Physical Recursive Self-Improvement: A Call for Body-Control Co-Design for Humanoid Robot](https://arxiv.org/abs/2510.03081)（2025-10）
- [Ctrl-World: A Controllable Generative World Model for Robot Manipulation](https://arxiv.org/abs/2510.10125)（2025-10）
- [LACY: A Vision-Language Model-based Language-Action Cycle for Self-Improving Robotic Manipulation](https://arxiv.org/abs/2511.02239)（2025-11）
- [WMPO: World Model-based Policy Optimization for Vision-Language-Action Models](https://arxiv.org/abs/2511.09515)（2025-11）
- [EvoVLA: Self-Evolving Vision-Language-Action Model](https://arxiv.org/abs/2511.16166)（2025-11）
- [Robot-Powered Data Flywheels: Deploying Robots in the Wild for Continual Data Collection and Foundation Model Adaptation](https://arxiv.org/abs/2511.19647)（2025-11）
- [Iterative Compositional Data Generation for Robot Control](https://arxiv.org/abs/2512.10891)（2025-12）
- [SOP: A Scalable Online Post-Training System for Vision-Language-Action Models](https://arxiv.org/abs/2601.03044)（2026-01）
- [SARM2: Multi-Task Stage Aware Reward Modeling for Self Improving Robotic Manipulation](https://arxiv.org/abs/2606.10305)（2026-06）
- [Playful Agentic Robot Learning](https://arxiv.org/abs/2606.19419)（2026-06）
- [Robot Self-Improvement via Human-Video Dynamics Models](https://arxiv.org/abs/2606.21406)（2026-06）
- [ASPIRE: Agentic /Skills Discovery for Robotics](https://arxiv.org/abs/2607.00272)（2026-06）
- [Practice Makes Policies: Bootstrapping and Consolidating Robotic Capabilities from Zero Human Demonstrations](https://arxiv.org/abs/2607.26809)（2026-07）
- [Self-Evolving Embodied Agents via Skill-Harness Evolution](https://arxiv.org/abs/2608.11350)（2026-08）
- [Beyond Imitation: Self-Improving Robot Policies via Off-Policy Q-Planning](https://arxiv.org/abs/2608.21204)（2026-08）
- [Motus2: A Self-Evolving General World Model for Dexterous Manipulation](https://arxiv.org/abs/2608.30237)（2026-08）
- [RE-0: Verified Recursive Improvement of Embodied Code-as-Policy Agents through Local On-Policy Distillation](https://arxiv.org/abs/2609.32416)（2026-09）
- [RoboFoundry: System-as-Policy Evolution for Self-Learning Embodied Agents](https://arxiv.org/abs/2609.32862)（2026-09）
- [RoboHarn-Evo: Evolving Hierarchical Physical Knowledge for Self-Improving Robotic Manipulation](https://arxiv.org/abs/2609.37583)（2026-09）
- [Learning from Runtime Feedback through Failure-Bank Self-Evolution for Vision-Language-Action Models](https://arxiv.org/abs/2609.39820)（2026-09）
- [RoboCoach: World Models as Active Coaches for Compositional Robot Skills](https://arxiv.org/abs/2609.39685)（2026-09）
- [Reconstruct, Practice, Go Real: Guided Self-Improvement for Embodied Agents](https://arxiv.org/abs/2610.02204)（2026-10）
- [EmbodiedRSI: Active Continual Robot Learning Through Hypothesis-Guided Co-Evolution](https://arxiv.org/abs/2610.10498)（2026-10）
- [EndoRSI: Physical-Evidence-Driven Recursive Improvement of Endoscopic Robot Policies](https://arxiv.org/abs/2610.13376)（2026-10）
- [Evo-RL: Iterative Robot Reinforcement Learning from Selective Experience](https://arxiv.org/abs/2610.13345)（2026-10）
- [ReTrace: Cross-Stage Failure Attribution for Self-Improving Robotic Manipulation](https://arxiv.org/abs/2610.15814)（2026-10）
- [D-World: An Explicit World-Language-Action Model with Recursive Self-Improvement under Dual Control](https://arxiv.org/abs/2610.17114)（2026-10）
- [SEAR: Self-Evolving Agentic Robotics](https://arxiv.org/abs/2610.18792)（2026-10）
- [EmbodiedEvo: Self-Evolving Coding Agent For Physical Intelligence](https://arxiv.org/abs/2610.18867)（2026-10）
- [Scaling Online Exploration for Robot Agents](https://arxiv.org/abs/2610.22496)（2026-10）
- [InstAgent: A Recursively Self-Improving Agent Operating System for Heterogeneous Robot Collaboration](https://arxiv.org/abs/2610.23098)（2026-10）
- [Learning to Compose: Recursive Self-Improvement of Shared Executable Stacks for Zero-Shot Long-Horizon Robot Manipulation](https://arxiv.org/abs/2610.24464)（2026-10）
- [Compile Once, Run Cheap: Frozen, Portable Skills for Embodied Agents, and What Recursive Self-Improvement Adds](https://arxiv.org/abs/2610.25114)（2026-10）
- [From VLM Planners to Robotic Agents: Self-Evolving Harnesses for History-Dependent Manipulation](https://arxiv.org/abs/2610.29560)（2026-10）
- [Rollback: Experience Backtracking in World Models for Policy Improvement](https://arxiv.org/abs/2610.36068)（2026-10）
- [Recursive Self-Improvement in Physical AI: Mechanisms, Evidence, and Evaluation](https://arxiv.org/abs/2610.38266)（2026-10）

**基础**

- [Large Language Models Can Self-Improve](https://arxiv.org/abs/2210.11610)（2022-10）
- [A Self-Improving Coding Agent](https://arxiv.org/abs/2504.15228)（2025-04）
- [Huxley-Gödel Machine: Human-Level Coding Agent Development by an Approximation of the Optimal Self-Improving Machine](https://arxiv.org/abs/2510.21614)（2025-10）
- [Group-Evolving Agents: Open-Ended Self-Improvement via Experience Sharing](https://arxiv.org/abs/2602.04837)（2026-02）
- [Self-Improvement of Large Language Models: A Technical Overview and Future Outlook](https://arxiv.org/abs/2603.25681)（2026-03）
- [The Red Queen Gödel Machine: Co-Evolving Agents and Their Evaluators](https://arxiv.org/abs/2606.26294)（2026-06）
- [Algorithmic Unverifiability of Safety for Fixed and Recursively Self-Improving Systems](https://arxiv.org/abs/2606.28639)（2026-06）
- [Recursive Self-Improvement in AI: From Bounded Self-Refinement to Autonomous Research Loops](https://arxiv.org/abs/2607.07663)（2026-07）
- [Self-Improvements in Modern Agentic Systems: A Survey](https://arxiv.org/abs/2607.13104)（2026-07）
- [SkillJack: Persistent Skill Backdoors in Self-Evolving Agents](https://arxiv.org/abs/2608.03509)（2026-08）
- [Co-Evolution in Agentic Systems: Toward Self-Directed Evolution Beyond Human Design](https://arxiv.org/abs/2608.10299)（2026-08）
- [Phantom Gains: Auditing Self-Improvement Against a Measured Null](https://arxiv.org/abs/2608.20290)（2026-08）
- [Recursive Criticality of AI Self-Improvement](https://arxiv.org/abs/2609.00137)（2026-08）
- [Dream-RSI: Recursive Self-Improvement through Evolving Worlds](https://arxiv.org/abs/2609.14858)（2026-09）
- [The Economics of Recursive Self-Improvement](https://arxiv.org/abs/2609.15802)（2026-09）
- [RRSI: Regularized Recursive Self-Improvement of Agent Harnesses](https://arxiv.org/abs/2609.24972)（2026-09）
- [Evolutionary Safety of Recursive Self-Improving AI: Taxonomy, Risk Discovery, and Evaluation](https://arxiv.org/abs/2609.31186)（2026-09）
- [Agent Plasticity: Measuring Self-Improvement Through Experience](https://arxiv.org/abs/2610.08902)（2026-10）
- [Auditing the Product, Not the Recursion: The Evaluation Evidence Behind Recursive Self-Improvement Claims](https://arxiv.org/abs/2610.27610)（2026-10）
- [RSI Arena: Towards Recursive Self-Improvement with Human Feedback](https://arxiv.org/abs/2610.33624)（2026-10）
- [RSI-Env: An Open-Ended Environment for Recursive Self-Improvement of Agents](https://arxiv.org/abs/2611.01736)（2026-11）
- [Recursa: Toward Recursively Self-Improving Foundation Model Systems](https://arxiv.org/abs/2611.04035)（2026-11）
