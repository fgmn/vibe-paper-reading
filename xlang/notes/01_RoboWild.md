---
id: "01"
org: XLANG
short: "RoboWild"
title: "RoboWild: Can Frontier Models Generalize to Robot Use in the Wild?"
aliases: ["RoboWild", "robot-use agent", "RUA"]
date: 2026-11-21
category: "基准"
source: "XLANG Lab（港大）主导"
partners: []
authors: ["Yimo Cai", "Delin Chen", "Junhao Chen", "Kaiqian Cui", "Zicheng Gong", "Zhewei Kang", "Yitao Liu", "Jiamin Song", "Haoyuan Wu", "Weiming Wu", "Yingming Zheng", "Zilong Zhou", "Tao Yu"]
arxiv: ""
pdf: "[[xlang/papers/01_RoboWild.pdf]]"
code: "https://github.com/xlang-ai/RoboWild"
project: "https://robowild.xlang.ai/"
huggingface: ["https://huggingface.co/datasets/xlangai/RoboWild"]
license:
status: 未读
rating:
read_date:
tags: ["paper", "xlang", "benchmark", "robot-use-agent", "vlm-agent", "simulation", "coding-agent"]
---

# RoboWild: Can Frontier Models Generalize to Robot Use in the Wild?

> [!info] 论文信息
> XLANG Lab（香港大学）· 论文日期 2026-11-21 · 暂无 arXiv 版，PDF 放在 HuggingFace 数据集仓库里
> 作者：署名 "XLANG Lab"，附录 A 列出 12 位共同一作（按姓氏字母序，贡献相同）+ 通讯作者 Tao Yu；另有 5 位 contributor（Yitong Li、Haikong Lu、Taiye Lu、Zhao Pu、Yuxiang Wan）。`authors` 只填了核心作者
> PDF：[[xlang/papers/01_RoboWild.pdf|本地 PDF]]（51 页：正文 15 页 + 参考文献 + 附录 A–G）
> [项目页](https://robowild.xlang.ai/) · [论文 PDF](https://huggingface.co/datasets/xlangai/RoboWild/blob/main/RoboWild.pdf) · [代码](https://github.com/xlang-ai/RoboWild) · [数据集](https://huggingface.co/datasets/xlangai/RoboWild) · [Slides](https://docs.google.com/presentation/d/1VMG5HpbCefa9syTL6qDlzPQjGyknmAiw9wQr1JHTIfQ/edit?usp=sharing) · [发布推文](https://x.com/XLangNLP/status/2123881231465222655) · [场景浏览器](https://robowild.xlang.ai/scenes/?scene=scene01)

> [!note] 下面各节是 Claude 根据论文全文和项目页写的初稿（2026-11-24）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。

## 一句话总结

XLANG（OSWorld 的同一团队）把"computer use"的评测思路搬到机器人上：不训练任何策略，直接让前沿 VLM 当 **robot-use agent（RUA）**，通过 `move_robot` 这类工具在 Isaac Sim/Lab 里操纵机器人完成自然语言请求。基准有 **38 个家具齐全的场景、4,480 个物体、60+ 种交互行为、341 个任务、4 种机器人**。最强的 Claude Fable 5.2（max 思考）只有 **13.28%** 成功率，每个任务平均消耗 2.26M 输出 token、约 6 小时、125 美元；而同一类模型在 RoboDojo 上能到 50–65%。失败主要是**抓取**和**运动执行**，不是"没理解任务"；另外 87% 的轨迹会碰乱无关物体。

## 要解决什么问题

- 前沿 VLM 在 coding、tool use、computer use 上已经能端到端完成任务，下一步是物理世界：让同一个通用模型通过感知 + 控制工具来操作机器人（RUA）。
- 现有机器人基准对这种评测**不够难**：
  - **桌面操作基准**（LIBERO、CALVIN、RLBench）：相关物体都摆在工作区里，不考察找东西、认东西；LIBERO-PRO 还显示 LIBERO 上 90%+ 的策略在简单扰动下就失效。
  - **家居场景基准**（BEHAVIOR-1K、RoboCasa365）：场景大，但物体交互被简化（如 BEHAVIOR-1K 用虚拟按钮开电器，RoboDojo 把剪刀、钳子做成单个刚体）。
  - 多数基准评的是**在自己任务分布上训练的策略**；评"冻结的基础模型 + harness"的只有 RoboARCade、Embodied First Exam、Gym-Anything for Robotics 等少数几个。
- 作者的立场：VLM 带着通用的预训练知识，用工具指挥机器人，所以 RUA 评测的 sim-to-real 差距"预计不大"，可以放心在仿真里做大规模、可复现的评测（这一点是论点，见"局限"）。

## 方法

### 1. 场景与物体（§2.1、附录 B）

- **38 个场景，23 种场景类型**：玄关、客厅、各种厨房、浴室、洗衣房、书房、儿童房、台球室、宠物护理、工作间、修车台、办公室、会议室、实验室、车库、便利店、面包房、酒吧、诊所，还有多房间的办公室 / 带庭院的住宅 / 旋转楼梯间等。
- 搭建流程：参考真实照片和生成的参考图 → 在 Isaac Sim 里先放大家具和电器，再按任务需要把小物体放到台面或容器里 → 跑仿真让物体落稳 → 载入 **Isaac Lab** 做三类检查（视觉/布局、物理稳定性如穿模和抖动、手动交互如开关门抽屉）。
- 物体来源：GenieSim、ArtVIP 等仿真数据集，BlenderKit、Sketchfab 等 3D 仓库；配置关节、物理属性和碰撞几何。包含刚体、关节体、可变形物体、粒子（液体、颗粒）。
- **物体密度 3.60 个/m²**，是第二名（Gym-Anything 1.82）的约两倍。
- **脚本化行为（scripted behaviors）**：纯物理表达不了的功能用脚本补，读取关节角、接触力、相对位姿、时间，驱动状态机去改关节限位、建立/解除连接、出料、改外观。表 4 列出 12 种受管理的行为类型：
  - `articulation_interlock`（门锁、把手）、`breakable_fixed_joint`（可拆的盖、粘贴）、`plug_retention`（插头、push-fit 盖）、`threaded_cap`（瓶盖、灯泡、螺丝螺母）、`magnetic_surface`（冰箱贴、白板磁贴）、`sticky_fur`（粘毛、撒调料）
  - `particle_faucet`（水龙头）、`rotary_dispenser`（宠物粮/调料分配器）、`gas_lift`（升降凳）、`toaster_cycle`（烤面包机）、`automatic_ladder`（电动折叠梯）、`scripted_visual`（灯、显示屏、烹饪、点火、白板）
  - 绑定关系和参数写在 YAML 里；烹饪、点火只更新过程状态和外观，不模拟传热和燃烧。
  - 例子：转动式分配器转够角度、出口没堵时才掉一粒粮；模拟时钟要直接拧时针分针。
- 项目页展示的复杂物体：立式搅拌机（抬头、独立控制行星和打蛋头转速）、空气炸锅、台虎钳、电钻、显微镜（换物镜转盘）、游标卡尺、阁楼梯等。

### 2. 任务（§2.2、附录 C.2–C.3）

- 每个任务 = 自然语言指令 + 初始配置 + 完成条件（含顺序、次数、持续时间等过程约束）。可行性通过人类遥操作或"智能体 + 运动规划"跑通一遍来验证。
- **341 个任务 = 239 个唯一 setup**（127 Short + 112 Long，按子目标数和操作难度分）：
  - 239 个 setup 全部在 **Dexmate Vega-1** 上实例化；
  - 其中 **34 个**对四种机器人都可行，另外在 Mobile ALOHA、Franka Mobile、Unitree G1 上实例化；
  - 205 + 34 × 4 = 341。
- 能力需求（可多选，占任务比例）：

| 类别 | 能力 | 占比 |
|---|---|---|
| 感知 | 视觉消歧（从相似物体中认出目标） | 58.6% |
| 感知 | 视觉推理 | 14.6% |
| 感知 | 读字（OCR） | 13.4% |
| 感知 | 记忆 | 5.0% |
| 物理 | 关节/材料交互 | 53.6% |
| 物理 | 精细操作 | 48.5% |
| 物理 | 导航 | 28.5% |
| 物理 | 双臂操作 | 21.3% |
| 物理 | 使用工具 | 12.6% |

- 任务长度：85.4% 的 setup 有多个里程碑；65.7% 有先后依赖（依赖链 1 层 34%、2 层 33%、3 层 20%、4 层及以上 13%）；平均里程碑数从 2 层链的 3.8 升到 4+ 层链的 6.9。56.9% 的 setup 同时需要感知和物理能力。
- 例子：配对内六角扳手开锁再开盖；读电子钟、把模拟钟拨到同一时间；给宠物粮分配器加粮再出 5 粒到大碗；把 7 块积木搬到庭院重搭同样的三跨桥；用锅铲炒虾、用烤肉夹翻牛排、扫包裹条码、对准投影仪画面。

### 3. 评测器（§2.3、附录 C.1）

- 每个任务一个可执行的 `evaluator.py`：`observe()` 每步记录过程事件（如"先拧下盖子""碗放到出口下"），`evaluate()` 在结束时同时检查事件记录和终态。这样"直接从盒子里倒 5 粒粮进碗"会被判失败。
- 读取的量：物体位姿、关节位置、接触、几何区域、粒子占据、脚本行为的状态；可复用谓词（`On`、`IsCompletelyInside`、`InContact` 等）。
- **构建与验证流程**（有点像 OSWorld 评测脚本的升级版）：
  1. **生成器**（编码智能体）只看公开的任务说明和接口文档，写评测器；
  2. **验证器**用生成器看不到的人工标注样本（成功 / 失败 / 临界）回放测试；
  3. 人类审核只给"泛化的修改意见"，不泄露私有样本；改完后全量回归；
  4. 依赖过程历史的条件，快照回放验证不了，要在实时运行中再检查；
  5. 最后由没看过原标注的独立审核者测试更多情况、检查 RUA 轨迹里的合法替代解法。
- 论文**没有给出评测器整体的验证通过率**（附录 C.1.3 明说）。

### 4. Agent harness（§2.4、附录 E）

两种 RUA 形式，共用同一套机器人工具后端：

**A. ReAct 循环（主实验）**
- 输入：任务指令、robot-use guidance（坐标系 robot_base、单位米、四元数 WXYZ 等约定）、RGB 图（头部 + 左右腕三路）、机器人状态、JSON 工具 schema。
- 工具只有两个：`move_robot`（≈ plan_motion + step 合一，用 **cuRobo** 规划并执行手臂/躯干/底盘目标，只检查关节限位和自碰撞，**场景避障要模型自己选中间点**）和 `done`。
- 每轮最多一个工具调用；只保留最近两次观测的图像；工具结果文本超过 40 万字符时，把最旧的截到 300 字符前缀，直到降到预算一半（让前缀稳定、可缓存）。连续两次提醒仍不调用工具则结束。
- 仿真在模型思考和规划时冻结，只在动作执行时推进；控制步长 0.2 s。

**B. 编码智能体（消融，§4.2）**
- 用 **Claude Code** 在沙箱工作区里跑：`TASK.md`、`AGENTS.md`、`API.md`、装好机器人 SDK 的 Python 环境、`observations/` 和 `scratch/` 目录；无网络、无 GPU、碰不到仿真器和评测器。
- 工具拆开：`get_scene_state`、`get_robot_state`、`solve_ik`、`plan_motion`（只返回轨迹不执行）、`step`（逐行执行关节目标）、`done`；深度版再加 `get_camera_point_3d`（最多 32 个像素转 3D 点）和 `sensors_to_collision_world`（用头部深度建体素障碍图）。
- 调用经命名管道 → 沙箱外的可信网关 → session broker 串行执行并计预算。

**预算**：Short 任务 100 次机器人调用，Long 任务 200 次；失败的请求也计费；`done` 和自动返回的图像不计。脚本里 `plan_motion` + `step` 算 2 次。

**机器人**（表 5）：

| 机器人 | 底盘 | 操作 | 备注 |
|---|---|---|---|
| Dexmate Vega-1 | 全向轮式 | 两条 7 自由度臂 + 3 自由度躯干 + 3 自由度头 | 主力本体，全部 239 个 setup |
| Mobile ALOHA（AgileX Cobot-Magic） | 全向轮式 | 两条 6 自由度臂、二值平行夹爪 | 无躯干 |
| Franka Mobile | 全向轮式 | 一条 7 自由度 Panda 臂 + 0.34 m 升降 | 单臂 |
| Unitree G1 | 双足 | 两条 7 自由度臂 + Dex3 三指手 + 3 自由度腰 | 由学习得到的全身跟踪策略 **ScaleBFM** 驱动，VLM 给关键帧 |

### 5. 评分方式（§3.1、附录 E.5）

- 每个 setup 权重相同：Dexmate-only setup 取 0/1；共享 setup 取四个本体结果的平均（四个里成功一个 = 0.25）。总成功率 = 239 个 setup 分数的平均。
- 每个模型 × 每个思考档位，每个任务**只跑一次**（成本原因）。

## 实验与关键数字

### 主结果（表 2，RGB-only ReAct，各模型最高思考档位）

| 模型 | 总成功率 | Short | Long | 平均工具调用 | 平均输出 token | 平均成本 |
|---|---|---|---|---|---|---|
| GPT-6.1 Sol（max） | 4.60% | 6.69% | 2.23% | 133.9 | 183K | $6.3 |
| Claude Opus 5.5（max） | 6.49% | 8.27% | 4.46% | 129.8 | 1.37M | $42.9 |
| Gemini 4 Carbon（high） | 10.56% | 12.99% | 7.81% | 127.1 | 634K | $35.3 |
| GPT-6 Astra（max） | 11.61% | 15.16% | 7.59% | 124.1 | **111K** | $29.3 |
| **Claude Fable 5.2（max）** | **13.28%** | 14.37% | **12.05%** | 127.3 | 2.26M | $125.34 |

- **token 效率差别极大**：Astra 每次工具调用约 900 输出 token；Fable 5.2 调用次数相近但 token 约是 Astra 的 20 倍，Gemini 约 6 倍。论文的结论是 GPT 系在每个思考档位都更省 token、同 token 下表现更好。
- **预算没饱和**：成功率在一定调用数后近似线性上升（Astra 从第 16 次、Gemini 18、Fable 33、Opus 37、Sol 52 开始），100 次以后变慢只是因为 Short 任务封顶在 100。
- **思考越多一般越好**，例外是 Astra xhigh、Sol xhigh、Opus max。Fable 5.2：low 2.7% → high 8.9% → max 13.3%（表 20）。

各思考档位的输出 token 与成本（表 19）：

| 档位 | Opus 5.5 | GPT-6.1 Sol | GPT-6 Astra | Gemini 4 Carbon | Fable 5.2 |
|---|---|---|---|---|---|
| low | 23K / $2.44 | 7K / $1.06 | 6K / $6.89 | 203K / $26.56 | 131K / $14.63 |
| medium | 101K / $8.64 | 25K / $2.98 | 24K / $19.53 | 440K / $30.21 | — |
| high | 153K / $10.67 | 45K / $3.58 | 40K / $21.82 | 634K / $35.29 | 470K / $30.38 |
| xhigh | 442K / $18.47 | 72K / $4.12 | 53K / $22.74 | — | — |
| max | 1.37M / $42.89 | 183K / $6.26 | 111K / $29.30 | — | 2.26M / $125.34 |

### 时间（§4.4、表 21）

- 每个 episode 的非 API 时间（规划 0.08 h + 执行 0.09 h + 其他 0.10 h）≈ 0.27 h，API 时间 = 输出 token ÷ Artificial Analysis 的输出速度。
- Opus 5.5：low 0.33 h → medium 0.53 → high 0.67 → xhigh 1.42 → **max 3.64 h**（API 占 92.6%）；low→max 输出 token 增加近 60 倍。
- 最高档位：Astra 1.04 h（最快，虽然 API 最慢 40 tok/s）、Sol 1.40 h、Opus 3.64 h、Gemini 3.72 h、**Fable 6.03 h**（API 占 95.5%）。
- 注意这是**估算**（用公开 API 速度算），不是实测。

### 跨本体（§4.1、图 6，34 个共享 setup）

- 三种轮式机器人（Dexmate、Mobile ALOHA、Franka Mobile）上都有成功；同一套工具接口下，RUA 能在单臂/双臂移动机器人之间泛化。
- 较强模型（Fable、Astra、Gemini）在 Dexmate 上更好（双臂 + 可调躯干更灵活）；较弱模型（Opus、Sol）在单臂 Franka 上和强模型差不多，但在双臂机器人上落后。
- **Unitree G1 上所有模型都是 0**：VLM 的高层工具命令和 ScaleBFM 底层运动之间"沟通不畅"。
- 图 6 每格数值在 0–11.8% 之间；从文字提取看不清各数值对应哪个模型，需对照原图。

### harness 消融（表 3，Opus 5.5 max，239 个 Dexmate 任务）

| 设置 | 成功率 | 工具调用 | 输入 token | 缓存命中 | 输出 token | 成本 |
|---|---|---|---|---|---|---|
| ReAct（RGB，默认） | 6.28% | 131.3 | 15.2M | 78% | 1.37M | $43.0 |
| ReAct + 深度 | 6.69% | 136.0 | 14.5M | 86% | 740K | $25.4 |
| Claude Code（RGB） | 12.13% | 97.9 | 154M | 98% | 730K | $57.1 |
| **Claude Code + 深度** | **14.64%** | 110.6 | 141M | 98% | 610K | $50.3 |

- **深度**：成功率只略升，但输出 token 和成本大幅下降。没有深度时模型会用多相机图像算射线交点来估距离，很费 token。
- **编码智能体**：成功率约翻倍（6.28% → 12.13%），调用次数更少。原因：感知、规划、执行分开调用；会基于 URDF 写可复用的运动学脚本、写更细的关节级控制。输入 token 多 10 倍，但缓存命中 98%。
- 加了深度的 Claude Code + Opus 5.5（14.64%）超过了默认 harness 下的最强模型 Fable 5.2（13.28%）——**harness 设计的影响和换更强模型同量级**。
- 深度噪声做得很认真（附录 E.5）：按 ZED X Mini 建模，噪声随距离四次方增长（1 m 处约 3.2 mm，2 m 处约 12.3 mm），边缘像素 3.5% 丢失，相机外参每回合加固定偏移。

### 和 RoboDojo 对比（§4.3、图 7）

- Opus 5.5 max、ReAct、100 次调用预算，跑 RoboDojo 42 个仿真任务的 210 个布局（去掉了每任务步数上限和"回到初始位姿"的要求）。
- 50 次调用：RoboDojo 42.38%（89 个布局）vs RoboWild 1.05%；100 次调用：**RoboDojo 50.00%（105 个）vs RoboWild 4.81%**。RoboDojo 上很快进入平台期。
- Anthropic 报告 Fable 5.2 在 RoboDojo 上 64.9%，在 RoboWild 只有 13.28%（作者承认设置和预算不同，不完全可比）。

### 按能力和任务结构（附录 F.1）

- 能力标签和成功率的相关性都很小（|r| ≤ 0.15），各模型强项不同：Opus 精细操作相关性更负（−0.11 vs 双臂 −0.01），Astra 反过来（精细 −0.08、双臂 −0.13）；只有 Fable 5.2 的导航和成功正相关（r = 0.15）。
- 里程碑 ≥ 6 或依赖深度 ≥ 4 的任务，没有模型超过 7.0%。
- 正文 §1 总结为"OCR、双臂操作、工具使用普遍较弱"。

### 失败分析（§5.1，4 个模型 × 50 个任务 = 200 条轨迹，12 条成功、188 条失败）

| 失败类型 | Opus 5.5 | GPT-6.1 Sol | GPT-6 Astra | Gemini 4 Carbon | 合计 |
|---|---|---|---|---|---|
| 抓取失败 | 15（31.9%） | 28（57.1%） | 18（40.0%） | 19（40.4%） | **80（42.6%）** |
| 运动/执行失败 | 14（29.8%） | 11（22.4%） | 16（35.6%） | 13（27.7%） | 54（28.7%） |
| 功能物体操作错误 | 9（19.1%） | 6（12.2%） | 6（13.3%） | 9（19.1%） | 30（16.0%） |
| 目标/对象选错 | 5（10.6%） | 2（4.1%） | 3（6.7%） | 3（6.4%） | 13（6.9%） |
| 其他（提前停止等） | 4（8.5%） | 2（4.1%） | 2（4.4%） | 3（6.4%） | 11（5.9%） |

- 50 个任务里 34 个 Dexmate、4 个 ALOHA、4 个 Franka、8 个 G1；分类由"分析智能体"对照工具调用记录、物体位姿和关键帧完成。
- 解读：**选错目标很少**（6.9%），说明模型理解任务和视觉认物基本过关；瓶颈在物理执行。32/50 个任务上至少 3 个模型失败类型相同，其中 8 个任务四个模型都是抓取失败。
- 典型案例：纸杯滑出夹爪；拖把挂环停在挂钩左边；拧瓶盖时瓶子滚动导致盖子歪斜；拿错游戏盒（Uncharted 4 而不是 Red Dead Redemption 2）。

### 失败恢复（§5.2）

- 200 条轨迹共 4,710 个恢复片段，平均每条 23.6 个；"局部修复率"= 解决眼前错误的比例。

| 类型 | 含义 | 每条轨迹次数 | 局部修复率 |
|---|---|---|---|
| Interface | 参数非法、碰撞急停、规划器拒绝（有明确报错） | 12.1 | **78.7%** |
| Re-anchor | 调整相机或底盘、找被遮挡物、捡回掉落物 | 3.7 | 45.5% |
| Contact | 重抓、微调位姿、换手、换抓法 | 7.7 | **25.7%** |

- 关键发现：**有报错信息时能修，只靠视觉判断接触问题时修不好**，常常重复同样的抓取直到预算耗尽；能修好的往往是改变了物理约束（比如用另一只手扶住打滑的瓶子再拧盖）。

### 安全与副作用（§5.3）

- **碰撞**：78% 的轨迹触发了 harness 安全急停，共 1,527 次；"破坏性强行操作"（拽着门把手往下扯到门脱离铰链轴）出现在 4 次运行中。
- **扰动无关物体**：87% 的轨迹碰乱了非目标物体，共 679 次；48% 的运行把东西碰倒（倾斜 ≥ 60°），37% 把东西碰下桌面/架子（≥ 15 cm）。
- 评测器只检查目标状态，所以有的运行把邻近游戏盒碰到地上**仍然判成功**。
- **任务表现好 ≠ 动作安全**：Opus 5.5 成功率不高，但最安全（碰撞 247 次 vs Astra 441 次，零破坏性操作，掉落物 18 个约为其他模型一半）；Astra 碰倒最多（49）。

## 局限 / 存疑

- **全部在仿真里**。作者认为 RUA 是通过工具指挥机器人、不需要迁移学到的控制策略，所以 sim-to-real 不是核心问题；但抓取、接触这些恰恰是主要失败点，而它们最依赖仿真的接触模型，这个论证本身值得怀疑。作者也承认需要真机配对实验。
- **脚本化行为是交互层面的近似**（烹饪、点火、粘附都不是物理模拟），"60+ 种交互行为"的计数口径不清楚：表 4 只有 12 种受管理的行为类型，另有资产自带脚本"未完全列出"。需核对 60+ 怎么数的。
- **每个设置只跑一次**，没有方差或置信区间。在 4–13% 这种低成功率区间，239 个 setup 上 1–2 个百分点的差距（如 Gemini 10.56% vs Astra 11.61%、ReAct 6.28% vs +深度 6.69%）很可能不显著。
- **评测器没有报告整体验证准确率**；依赖历史的条件在快照回放里被标"未验证"、不计入一致率。
- **评测不惩罚副作用**：碰倒无关物体仍可判成功，安全性只是单独分析。
- 时间是用公开 API 速度**估算**的，不是实测；成本按 2026-11-19 的标价算，Gemini 价格还含限时折扣。
- 主实验只有 ReAct 一种 harness 下的模型横比；编码智能体消融只测了 Opus 5.5 一个模型。Claude Code 和 Anthropic 模型的组合可能有"自家主场"优势，没有对比 Codex 等其他编码智能体（尽管图 4 写了 Codex）。
- G1 全 0 的原因归结为 ScaleBFM 接口问题，没进一步分析是 VLM 能力问题还是工具设计问题。
- 数字小问题：
  - 项目页写"61.9% 的任务需要至少两种能力"，论文正文写"56.9% 的 setup 同时需要感知和物理能力"，口径不同（任务 vs setup、任意两种 vs 跨类），不是矛盾，但别混用。
  - 正文 Opus 5.5 成功率 6.49%（加权、含四个本体），表 3 的 6.28% 只算 Dexmate；图 7 的 4.81% 是 100 次调用截断后的值（Long 任务本有 200 次）。三者都对，口径不同。
  - 图 6 和图 12 的各模型数值从 PDF 文字里提取时顺序错乱，上面只引用了正文里明确写出的数字。

## 与其他论文的关系

- **同团队的 computer-use 基准**：OSWorld（NeurIPS 2024）、OSWorld 2.0（arXiv 2606.29537）。RoboWild 明显是同一套方法论：真实环境 + 可执行评测脚本 + 冻结前沿模型 + 统一工具接口。
- **代码即策略 / 编码智能体控制机器人**：[[nvidia/notes/36_CaP-X|CaP-X]]（编码智能体在去掉人工抽象后性能下降）；RoboWild 的编码 harness 结果（翻倍）和它一致地说明"给编码智能体合适的工具层"很关键。更早的 Code as Policies、VoxPoser、SayCan。
- **对比基准**：RoboDojo（arXiv 2607.04434，仿真 + 真机双臂基准；[[xsquare/projects/WALL-OSS-1.0-Lite-RoboDojo|WALL-OSS-1.0-Lite-RoboDojo]] 就是在它上面评的 VLA）；RoboCasa365、BEHAVIOR-1K、LIBERO；同类"基础模型 + harness"基准 RoboARCade、Embodied First Exam、Gym-Anything for Robotics（表 1 里最接近 RoboWild 的一个）。
- **"冻结前沿模型直接当策略"**：GPT-6 Astra 在 RoboDojo 上的早期评测（arXiv 2609.24170）。
- [[topics/递归自我改进RSI|递归自我改进RSI]] 专题里的 Embodied Turing Machines（编码智能体闭环开发显式状态代码库，RoboDojo 70.24%）和 InSight：如果把 RoboWild 当成 RSI 的环境，其可执行评测器正好能当奖励信号。
- 人形底层控制：ScaleBFM（Scaling behavior foundation model，arXiv 2607.15163）。
- 与 VLA / 世界动作模型（RT-2、OpenVLA、π0/π0.5、GR00T N1、World Action Models）是两条路线：VLA 动作流畅但离不开训练分布，RUA 泛化好但执行粗糙、慢且贵。

## 我的想法

<!-- 留给你写。几个可以想的问题（Claude 提的）：
- 抓取失败占 42.6%、选错目标只有 6.9%：是不是应该给 RUA 一个"抓取原语"（如 VLA 或抓取检测模型）当工具，让 VLM 只负责高层？这样评的还是"robot use"吗？
- 编码 harness 翻倍、深度省一半 token：RUA 的瓶颈有多少是 harness 的，有多少是模型的？
- 6 小时/任务、125 美元/任务，离实际部署有多远？低思考档位的 Astra（6K token）能做到什么程度？
- 评测器生成流程（生成器 / 私有样本验证器 / 不泄露样本的人工反馈）能不能用在我们自己的任务构建上？
-->

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文没有写明许可，这里只记位置和要点，原句请点页码看）
> 1. 第 1 页摘要：341 任务、38 场景、4,480 物体、60+ 行为、4 本体；Fable 5.2 13.28% → 基准规模与主结论
> 2. 第 2 页 §1 第 2 段：桌面基准不考察找物，家居场景基准简化交互 → 要解决的问题
> 3. 第 4 页 §2.2 末尾与图 3：239 个 setup（127 Short / 112 Long），34 个跨本体；能力占比与依赖链 → 任务统计
> 4. 第 5 页 §2.3：observe() 记录过程、evaluate() 查终态；生成器 / 私有样本验证器 / 独立审核 → 评测器
> 5. 第 5–6 页 §2.4、第 38 页附录 E.1–E.2、表 17–18：ReAct 只有 move_robot 和 done；编码智能体工具拆分 → harness
> 6. 第 7 页表 2、§3.2：五模型成功率、调用数、token、成本；token 效率差 20 倍 → 主结果
> 7. 第 8 页 §4.1：G1 由 ScaleBFM 驱动，所有模型 0 成功 → 跨本体结论
> 8. 第 9 页表 3：深度和 Claude Code 消融四行数字 → harness 消融
> 9. 第 11–13 页 §5.1–5.3、图 9、图 11：188 个失败分类；恢复片段修复率；78% 碰撞、87% 扰动 → 行为分析
> 10. 第 14–15 页 §7：只在仿真里评测，sim-to-real 论证与真机验证的缺失 → 局限

## 摘要（中文）

前沿视觉语言模型（VLM）的能力已迅速扩展到数字世界中的编程、工具使用和计算机使用。物理交互是下一个前沿：能力扩展到物理世界中的机器人使用智能体（RUA）。然而现有机器人基准因工作空间受限、物体交互简单、任务分布狭窄而要求不够高。我们提出 RoboWild，一个包含 341 个多样化机器人使用任务的基准。它的 38 个配齐家具的场景从住宅到工作间和实验室，密集布置了 4,480 个物理和功能上逼真的物体，涵盖关节机构、可变形材料、粒子集合以及 60 多种交互行为。任务围绕这些复杂场景和物体交互设计，覆盖广泛的活动，需要精确操作和导航，并用 4 种机器人本体评测跨本体泛化。表现最好的模型 Claude Fable 5.2 总体成功率只有 13.28%。VLM 作为 RUA 每个任务需要大量时间和 token，Fable 5.2、Opus 5.5 和 Carbon 消耗的输出 token 是 6.1 Sol 和 6 Astra 的数倍。VLM 在人形本体上也表现吃力，而单独的 harness 消融显示加入深度信息或允许执行代码可以提升成功率。同时，失败分析指出抓取、双臂操作和工具使用方面的持续困难。即使在仿真中的日常任务上，智能体也会把机器人开进障碍物、碰乱与请求无关的物体，表明 VLM 作为 RUA 常常忽视自身动作的物理风险。

## 摘要（原文）

> Frontier vision-language models (VLMs) have rapidly expanded their capabilities to coding, tool use, and computer use in the digital world. Physical interaction is the next frontier where capabilities expand to robot-use agents (RUAs) in the physical world, yet existing robotics benchmarks are not demanding enough due to constrained workspace, simple object interactions, and narrow task distribution. We present RoboWild, a benchmark composed of 341 diverse robot-use tasks. Its 38 furnished scenes, from homes to workshops and laboratories, are densely arranged with 4,480 physically and functionally realistic objects spanning articulated mechanisms, deformable materials, particle sets, and over 60 interactive behaviors. Tasks cover broad activities designed around such complex scenes and object interactions, requiring precise manipulation and navigation, with 4 robot embodiments to evaluate cross-embodiment generalization. The best-performing model, Claude Fable 5.2, achieves only 13.28% overall success. VLMs as RUAs require substantial time and tokens per task, with Fable 5.2, Opus 5.5 and Carbon consuming several times as many output tokens as 6.1 Sol and 6 Astra. VLMs also struggle on the humanoid embodiment, while separate harness ablations show that adding depth information or enabling code execution can improve task success. Meanwhile, failure analysis points to persistent difficulties in grasping, bimanual manipulation, and tool use. Even on routine tasks in simulation, agents drive robots into obstacles and disturb objects unrelated to the request, revealing that VLMs as RUAs often overlook the physical risks of their actions.
