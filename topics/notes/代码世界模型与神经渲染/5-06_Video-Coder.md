---
id: "5-06"
org: 专题·代码世界模型与神经渲染
short: "Video-Coder"
title: "Video-Coder: Reinforcing Agentic Coding for Video Generation"
aliases: ["Video-Coder", "Video-Coder-9B", "Video-Coder Harness"]
date: 2026-11-06
category: "Code2Video：编码智能体写程序来生成视频"
venue: —
affiliation: "中佛罗里达大学（UCF）· 维尔茨堡大学 · 微软研究院 · 清华大学 · 北卡罗来纳大学教堂山分校 · 威斯康星大学麦迪逊分校"
authors: ["Chaoyang Wang", "Sicheng Gao", "Junan Hu", "Kunyang Li", "Dongyang Chen", "Yiyang Zhou", "Huaxiu Yao", "Yong Jae Lee", "Radu Timofte", "Yuzhang Shang"]
arxiv: "2611.09894"
pdf: "[[topics/papers/代码世界模型与神经渲染/5-06_2611.09894_Video-Coder.pdf]]"
code: "https://github.com/CYWang735/Video-Coder"
project: "https://huggingface.co/Video-Coder"
license: CC BY 4.0（arXiv 摘要页）
status: 未读
rating:
read_date:
tags: ["paper", "code2video", "coding-agent", "agentic-rl", "grpo", "blender", "harness", "text-to-video", "physics", "minimax-h3", "phygenbench", "vbench-2"]
---

# Video-Coder: Reinforcing Agentic Coding for Video Generation

> [!info] 论文信息
> arXiv [2611.09894](https://arxiv.org/abs/2611.09894) · v1（2026-11-06），本地 PDF 即 v1
> 单位：中佛罗里达大学（Yuzhang Shang 组，主）、维尔茨堡大学（Radu Timofte）、微软研究院、清华、UNC 教堂山（Huaxiu Yao）、UW–Madison（Yong Jae Lee）· 一作：Chaoyang Wang · 通讯作者：Yuzhang Shang
> PDF：[[topics/papers/代码世界模型与神经渲染/5-06_2611.09894_Video-Coder.pdf|本地 PDF]]（16 页：正文第 1–9 页 + 参考文献第 9–11 页 + 附录 A 系统提示词（第 12–14 页）、附录 B 视频奖励提示词（第 15–16 页））
> 代码：[CYWang735/Video-Coder](https://github.com/CYWang735/Video-Coder) · Hugging Face：[Video-Coder](https://huggingface.co/Video-Coder)（作者称数据、模型、代码全部开源；仓库内容未核对）
> 专题：[[topics/代码世界模型与神经渲染#五、Code2Video：编码智能体写程序来生成视频|代码世界模型与神经渲染 · 五、Code2Video：编码智能体写程序来生成视频]]

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-18）。本机 Read 打不开 PDF，全文是用 PDFKit 脚本抽成文本后通读的（含两个附录）；图 2（第 4 页）、式 (3)（第 6 页）、表 1–2（第 7 页）、表 3 和图 4（第 9 页）另外渲染成 PNG 逐格对照过。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。

## 一句话总结

把"文生视频"变成一个**智能体编程任务**，并且第一次专门**训练**这个编码智能体：Qwen3.5-9B 在一个叫 **Video-Coder Harness** 的沙箱里写 Blender Python 脚本、用 `check_script` / `run_blender` 两个工具执行，拿回报错、场景摘要（物体数、运动物体在采样帧的世界坐标、出画检查）和几张渲染帧，反复修改，最后交出一段**灰色黏土白模视频**；白模只带结构和运动，交给**冻结的 MiniMax-H3** 按提示词补外观。训练分两步：先在 Gemini 3.8 Flash 跑出的多轮轨迹上 SFT，再用 GRPO 做 harness 原生的智能体 RL，奖励 = 0.5 × 视频奖励（Qwen3.8-omni-flash 拿生成视频和"老师草稿生成的参考视频"比布局、运动、镜头）+ 随训练指数衰减的可执行奖励。结果：MiniMax-H3 在 PhyGenBench 上 0.61 → 0.67、VBench-2.0 物理维度 54.58% → 78.19%；只在 H3 上训练的智能体换到 OmniWeaving 上也有 0.48 → 0.51。

## 要解决什么问题

- **像素空间的视频模型不建模 3D 世界**：提示词涉及精确空间关系、多物体交互、受物理支配的运动时，常见物体数量和位置错、遮挡不一致、轨迹不合理、物体变形或消失；而且端到端生成的视频难以编辑和复现，用户只能反复改提示词（§1）。
- **代码天然适合描述这些东西**：几何、运动、相机轨迹都能用一小段程序精确写出来（作者举例"三个球同时从不同高度落下"）。
- **已有的代码驱动视觉生成没有训练**（§2.2）：3D-GPT、SceneCraft、BlenderAlchemy 用代码搭 3D 场景；[GPT4Motion](https://arxiv.org/abs/2311.12631) 和 [[topics/notes/代码世界模型与神经渲染/5-05_VideoCoCo|VideoCoCo]] 用 Blender 代码引导视频生成。但它们大多是**单轮**、**固定提示流程**、调用**冻结的（常是闭源的）**大模型，既不根据执行反馈改代码，也不针对最终视频质量优化模型。
- **深度、轨迹、相机位姿、3D 追踪视频这些控制信号**（[[topics/papers/代码世界模型与神经渲染/5-06_2611.09894_Video-Coder.pdf#page=3|§2.1]]，引 Gen-1、MotionCtrl、CameraCtrl、Diffusion as Shader、PhysGen）通常要用户提供或手工流水线生成——Video-Coder 想让智能体自动造出这些信号。

## 方法

总览见 [[topics/papers/代码世界模型与神经渲染/5-06_2611.09894_Video-Coder.pdf#page=2|图 1（第 2 页）]]；数据流水线见 [[topics/papers/代码世界模型与神经渲染/5-06_2611.09894_Video-Coder.pdf#page=4|图 2（第 4 页）]]。

### 世界状态怎么用代码表示：Video-Coder Harness（§3.2、附录 A）

- **任务形式**：给提示词 c，策略 π 写 Blender 程序 f；执行得到 (v, ℓ) = E(f)，v 是白模视频（失败为空），ℓ 是执行反馈。第 t 轮的程序以提示词和之前所有轮的代码、反馈、渲染为条件（写–跑–改循环）。
- **脚本契约**（附录 A，[[topics/papers/代码世界模型与神经渲染/5-06_2611.09894_Video-Coder.pdf#page=12|图 5，第 12 页]]）：单个自包含脚本，`blender --background --factory-startup` 无头执行；只能用 Blender API 和 Python 标准库，**不许外部资产**；几何只用基本体、修改器、bmesh、`from_pydata`，总面数约 50 万以内；动画用关键帧、驱动、约束或物理（物理要先烘焙）；必须建相机并保证动作始终在画面内；随机数要设种子保证确定性；禁止 subprocess、socket、eval 等。
- **统一的白模渲染**：所有场景同一种外观——Workbench 引擎、STUDIO 光照、单色 0.8 灰、开阴影和 cavity，固定分辨率和帧率，H.264 MP4 输出。所以白模**只携带结构和运动**，不带材质。具体分辨率、帧率、帧数在提示词模板里是变量，论文没给数值。
- **两个工具和三类反馈**：

| 工具 | 作用 |
|---|---|
| `check_script` | 快速静态检查：语法、是否 import bpy、有无相机和渲染调用、禁用调用 |
| `run_blender` | 照 harness 的方式执行并渲染（CPU，提示词里写约 20–120 秒） |

| 反馈 | 内容 |
|---|---|
| 执行反馈 | 语法错误、缺相机或渲染调用、运行时 traceback；失败时只有这一项 |
| 内容检查 | 视频格式、帧数；空帧、静止视频、物体出画；**场景摘要**：物体数、运动物体、运动网格在采样帧的世界坐标、原点在视野外的网格 |
| 视觉反馈 | 均匀采样几帧渲染图（带帧号和时间）作为图像回传，让智能体自己看 |

- **验收**：智能体输出提交指令后，harness 在干净目录里**从头重跑**最终脚本，所有检查都通过才算数；重跑得到的视频就是最终白模。提示词模板里还有一个可选的"评审"（judge_enabled），会对比帧和描述，正文没说训练或测试时是否开启。
- 系统提示词还要求先"思考与规划"（物体尺寸、位置（米）、帧时序、相机），并要求逐帧列出问题（数量错、穿模、运动顺序或时间错、出画…）再改。同一份系统提示词用于老师造数据、RL 训练和推理。

### 渲染器：冻结的视频生成器

| 项 | 内容 |
|---|---|
| 主渲染器 | **MiniMax-H3**（参考文献 [20] 只写了"Hailuo AI, 2024"的网址），训练和测试都冻结 |
| 迁移测试 | OmniWeaving（智能体没见过） |
| 条件信号 | 白模视频（结构 + 运动）+ 文字提示词（外观） |
| 条件注入方式 | 论文没写白模怎么喂给 H3（推测走 H3 的参考视频通路，即其他笔记里的 Ref2VA，需核对）；OmniWeaving 怎么接也没写 |
| 实时 / 流式 | 不涉及；离线生成单段视频 |

作者明确说训练时视频生成器不动，**只优化 Qwen3.5-9B 写程序**。这和 VideoCoCo 正好相反。

### 数据：四段流水线（§3.1，图 2）

| 阶段 | 做法 |
|---|---|
| ① 提示词构造 | 取 InternVid、OpenVid-1M、MiraData 的字幕；用大模型（正文说"an LLM"，图 2 标的是 Gemini 3.8）改写成**以场景为中心**的描述（物体及数量、空间布局、运动过程、相机行为），丢掉主要靠细粒度外观、人脸表情等无法用 3D 场景编程表达的提示词 |
| ② 智能体轨迹生成 | **Gemini 3.8 Flash** 接入 Harness，写–跑–改直到草稿符合提示词或达到轮数上限 T_max；记录推理、代码、工具调用、反馈、渲染观察 |
| ③ 真值视频合成 | 提示词 + 老师草稿 → **MiniMax-H3** → 结构和运动跟白模、外观跟提示词的"参考视频" |
| ④ 清洗过滤 | 执行有效性（从未成功渲染、超轮数 / token、非法工具调用）；白模质量（几乎静止、空、主体出画、退化视角）；提示词–视频一致性（**Seed2.0** 判白模是否正确反映物体、数量、空间关系、运动，低于阈值丢弃） |
| 产出 | **Video-Coder-SFT-6k**（提示词 + 完整轨迹 + 参考视频）、**Video-Coder-RL-2k**（提示词 + 参考视频），互不重叠 |

数据集规模前后不一，见"局限 / 存疑"。

### 训练（§3.3、§4.1）

| 项 | SFT | 智能体 RL |
|---|---|---|
| 初始化 | Qwen3.5-9B | SFT 后的模型 |
| 数据 | Video-Coder-SFT（6k 或 10k，见存疑） | Video-Coder-RL（2k 或 4k） |
| 学到什么 | 规划场景、写 Blender 代码、调用工具、读反馈、改代码 | 更有效的场景编程和修改策略 |
| 算法 | 模仿老师轨迹 | **GRPO**，组大小 8，按 DAPO 的做法屏蔽未完成的 rollout |
| 学习率 / 批 | 1e-5 / 8 | 1e-6 / 8 |
| 交互上限 | — | 最多 100 轮，上下文 120K |
| 算力 | 8 张 H100 训练智能体 | 另外 16 张 H100 部署 MiniMax-H3 生成 rollout 视频 |
| 总时长 | 全流程约 3 天 | |

**奖励**（第 6 页式 (3)）：

R = α · R_video + exp(−steps / T) · R_exe，α = 0.5

- **R_exe**（0/1）：工具调用格式全对、最终程序执行成功并通过所有环境检查才给 1。
- **R_video**（归一化到 [0, 1]）：每个 rollout 的白模都要过一遍 MiniMax-H3 生成最终视频，再由 **Qwen3.8-omni-flash** 拿它和"老师草稿生成的参考视频"及提示词比较。附录 B 的评分提示词分四维，每维只能打 0 / 0.25 / 0.5 / 0.75 / 1：**忠实度**（对照描述，抽 3–6 条硬约束）、**布局**、**运动**、**镜头**（后三项对照参考视频）；明确要求忽略纹理、颜色、光照等外观，"拿不准就打低分"。四维怎么合成一个分数没写。
- **退火**：可执行奖励的权重从 1 按 exp(−steps/T) 衰减到训练结束时约 0.37（不会降到 0）。动机是早期程序常执行失败、拿不到视频奖励，可执行奖励帮助稳定；后期让视频奖励主导，避免"能跑但保守"的程序。

### 一致性与记忆

不涉及长时记忆或跨段一致性。"一致性"体现在两处：harness 强制确定性（种子、从头重跑），以及视频奖励检查生成视频的布局、运动、镜头是否与参考一致。

## 实验与关键数字

评测（§4.1）：**PhyGenBench**（力学 / 光学 / 热学 / 材料，官方协议，GPT-4o 当评委，0–1）和 **VBench-2.0** 物理维度（力学 / 热学 / 材料，百分比）。

### PhyGenBench（[[topics/papers/代码世界模型与神经渲染/5-06_2611.09894_Video-Coder.pdf#page=7|表 1，第 7 页]]）

| 方法 | 力学 | 光学 | 热学 | 材料 | 平均 |
|---|---|---|---|---|---|
| Pika | 0.35 | 0.56 | 0.43 | 0.39 | 0.44 |
| Gen-3 | 0.45 | 0.57 | 0.49 | 0.51 | 0.51 |
| Kling | 0.45 | 0.58 | 0.50 | 0.40 | 0.49 |
| CogVideoX | 0.39 | 0.55 | 0.40 | 0.42 | 0.45 |
| Open-Sora V1.2 | 0.43 | 0.50 | 0.44 | 0.37 | 0.44 |
| LaVie | 0.30 | 0.44 | 0.38 | 0.32 | 0.36 |
| Vchitect-2.0 | 0.41 | 0.56 | 0.44 | 0.37 | 0.45 |
| MiniMax-H3 | 0.61 | 0.73 | 0.52 | 0.55 | 0.61 |
| HunyuanVideo | 0.33 | 0.39 | 0.26 | 0.30 | 0.33 |
| OmniWeaving | 0.48 | 0.56 | 0.43 | 0.39 | 0.48 |
| Wan2.2-TI2V-5B | 0.55 | 0.58 | 0.53 | 0.50 | 0.54 |
| Cosmos-Predict2.5 | 0.30 | 0.33 | 0.41 | 0.39 | 0.35 |
| LTX-Video-2B | 0.51 | 0.58 | 0.48 | 0.45 | 0.51 |
| Video-CoCo（表中所记） | 0.51 | 0.58 | 0.48 | 0.45 | 0.51 |
| Video-Coder-9B + OmniWeaving | 0.52 | 0.58 | 0.52 | 0.44 | 0.51 |
| **Video-Coder-9B + MiniMax-H3** | **0.68** | **0.79** | **0.60** | **0.61** | **0.67** |

- H3 + Video-Coder 四类都第一，平均 0.61 → 0.67。
- 迁移到 OmniWeaving（RL 时没用过）：0.48 → 0.51，热学 +0.09、材料 +0.05。
- "Video-CoCo"一行和 LTX-Video-2B 完全相同，与 VideoCoCo 原文对不上，见存疑。

### VBench-2.0 物理维度（[[topics/papers/代码世界模型与神经渲染/5-06_2611.09894_Video-Coder.pdf#page=7|表 2，第 7 页]]）

| 方法 | 力学 | 热学 | 材料 | 平均 |
|---|---|---|---|---|
| Sora | 62.22% | 43.36% | 64.94% | 56.84% |
| Kling 1.6 | 65.55% | 59.46% | 68.00% | 64.34% |
| HunyuanVideo | 76.09% | 56.52% | 64.37% | 65.66% |
| MiniMax-H3 | 67.59% | 47.22% | 48.94% | 54.58% |
| CogVideoX-1.5 | 80.80% | 67.13% | **83.19%** | 77.04% |
| **Video-Coder-9B + MiniMax-H3** | **88.67%** | **70.88%** | 75.02% | **78.19%** |

- 平均比 H3 高 23.61 个点（摘要说"约 24"）；力学比 H3 高 21.08、比 CogVideoX-1.5 高 7.87；材料仍落后 CogVideoX-1.5，作者解释为材料现象依赖细粒度外观和材质响应，而白模只编码结构和运动。三列平均和表里的平均对得上。
- 这张表**没有 OmniWeaving 和 VideoCoCo 的行**（VideoCoCo 自报 77.88%）。

### 消融（[[topics/papers/代码世界模型与神经渲染/5-06_2611.09894_Video-Coder.pdf#page=9|表 3、图 4，第 9 页]]，PhyGenBench 平均，渲染器都是 MiniMax-H3）

| 变体 | PhyGenBench |
|---|---|
| MiniMax-H3（直接文生视频） | 0.61 |
| + Video-Coder-SFT（只做 SFT） | 0.63 |
| + RL，固定权重 R = α·R_video + R_exe（无退火） | 0.65 |
| + RL，只用可执行奖励 | 0.64 |
| + RL，只用视频奖励 | 0.63 |
| **+ Video-Coder（SFT + 完整 RL）** | **0.67** |

- SFT 带来 +0.02，RL 再 +0.04；去掉任一奖励或去掉退火都掉分。作者对"无退火更差"的解释：可执行奖励被过度利用，掩盖了视频奖励的细微差别，智能体倾向写"能跑但保守"的程序。
- α 敏感性（图 4，柱状图读数）：α = 0.4 和 0.7 约 0.65，α = 0.5 和 0.6 约 0.67；作者说在合理范围内不敏感。

### 定性（[[topics/papers/代码世界模型与神经渲染/5-06_2611.09894_Video-Coder.pdf#page=8|图 3，第 8 页]]）

三辆白车在日落时的城市道路上行驶、戴眼镜穿格子夹克的男人在演播室递文件夹、三艘快艇划过海面、戴眼镜的女人用勺子吃碗里的东西：白模定下物体数量（三辆车、三艘船）、布局、运动方向、取景，生成视频保持这些并补上外观。

## 局限 / 存疑

- **数据集规模前后矛盾（需核对）**：摘要、§1、§3.1、图 2 都是 **SFT-6k / RL-2k**；§4.1 训练细节和 §5 结论是 **SFT-10k / RL-4k**。专题清单写的是 6k + 2k。
- **VideoCoCo 一行数字有误（需核对）**：表 1 把 Video-CoCo 记为 0.51 / 0.58 / 0.48 / 0.45 / 0.51，和上一行 LTX-Video-2B 一模一样；而 [[topics/notes/代码世界模型与神经渲染/5-05_VideoCoCo|VideoCoCo]] 原文（v1、v2 摘要和 v2 表 1）报的是 OmniWeaving + VideoCoCo 平均 0.558（0.56 / 0.61 / 0.51 / 0.53）。按 VideoCoCo 自报的数字，**同样以 OmniWeaving 为渲染器，VideoCoCo（0.56）高于 Video-Coder + OmniWeaving（0.51）**。表 2 也没列 VideoCoCo 的 77.88%，而 Video-Coder 的 78.19% 只比它高 0.31 个点，且用的是更强的 H3。
- **"16.28 个点"算不出来（需核对）**：§4.2 说 OmniWeaving 从 0.48 到 0.51 是"提升 16.28 个点"，绝对值是 0.03，相对值约 6%，都不是 16.28。
- **"约 7 个点"还是 6 个点**：摘要和引言说 PhyGenBench 上 H3 提升约 7 个点，§4.3 说 6 个点，表里是 0.61 → 0.67。
- **缺少最关键的两条基线**：没有报告**老师 Gemini 3.8 Flash 直接在 harness 里写代码**的结果（SFT 数据就是它产生的，9B 学生是否超过老师不知道），也没有**未训练的 Qwen3.5-9B + harness** 的结果；"训练"本身的价值只能从 SFT 0.63 → 完整 0.67 看出来。
- **RL 信号绕回了老师**：视频奖励把生成视频和"老师草稿 → H3"的参考视频比布局、运动、镜头，所以 RL 在一定程度上是在逼近 Gemini 的草稿；忠实度一维对照的是描述，能部分缓解。四个维度怎么合成 R_video（平均？motion_na 时怎么处理？）没写。
- **评测时的提示词处理没交代**：训练提示词都被改写成"以场景为中心"的描述，PhyGenBench / VBench-2.0 的原始提示词是否也先改写、传给 H3 的是原始提示词还是改写后的，论文没说；训练提示词与评测基准有没有去重也没说（VideoCoCo 明确做了去重）。
- **白模能否表达这些物理现象**：PhyGenBench 有光学、热学、材料类（升华、熔化、颜色混合），Workbench 灰模只给几何和运动；训练数据又刻意滤掉了靠外观表达的提示词。作者自己也用这一点解释 VBench 材料维度落后，但 PhyGenBench 上光学和材料也涨了不少，增益来自哪里没有分析。
- **条件注入方式没写**：白模视频以什么方式进入 MiniMax-H3 和 OmniWeaving（参考视频？首帧？通道拼接？）、H3 用多少步、多长、什么分辨率，都没写。参考文献 [20] 对 MiniMax-H3 只给了一个 2024 年的 Hailuo 网址。
- **推理成本没报**：每次 `run_blender` 约 20–120 秒（CPU），最多 100 轮，RL 时每个 rollout 还要过一次 H3；一条提示词端到端要多久、平均几轮没有统计。
- **"第一个训练的代码驱动视频生成智能体"** 是作者的说法；就本专题收到的工作看，VideoCoCo、GPT4Motion 确实都用冻结的智能体，这个说法暂时成立，但只针对"训练智能体"这一侧（VideoCoCo 训练了渲染端）。
- **轮数上限 T_max**（造数据时）、可选评审 judge_enabled、visual_feedback 开关在各阶段是否开启，都没给数值或说明。
- 小问题：正文有 "Mimax-H3"、"Eis denotes" 等笔误；视频奖励"拿不准就打低分"的规则会压低奖励方差，对 GRPO 组内归一化的影响没讨论。

## 与其他论文的关系

- **同节直接对照：[[topics/notes/代码世界模型与神经渲染/5-05_VideoCoCo|VideoCoCo]]（5-05，2026-07）**。两篇骨架几乎一样——编码智能体写 Blender Python → 沙箱渲出灰 / 白模草稿 → 视频模型按草稿生成逼真视频，评测也都是 PhyGenBench + VBench-2.0 物理维度（两篇的基线行数字完全相同，Video-Coder 显然沿用了 VideoCoCo 的表）。区别在**训练哪一边**：

| | VideoCoCo | Video-Coder |
|---|---|---|
| 编码智能体 | 现成模型（论文没写是哪个），不训练 | Qwen3.5-9B，SFT（Gemini 3.8 Flash 轨迹）+ GRPO |
| 智能体看得到什么 | 渲染报错（作为诊断信号） | 报错 + 场景摘要（坐标、出画）+ 渲染帧 |
| 渲染器 | OmniWeaving + LoRA（训练） | MiniMax-H3（冻结）；可换 OmniWeaving |
| 渲染器前的中间步 | 指令智能体写"只管外观"的编辑指令 | 直接用提示词 |
| 训练数据 | 3K 草稿–指令–目标（老师 Seedance 2.0） | 6k SFT 轨迹 + 2k RL 提示词（老师 Gemini 3.8 Flash + MiniMax-H3） |
| 同用 OmniWeaving 时 PhyGenBench | 0.558（自报） | 0.51 |
| 最好成绩 | 0.558 / 77.88%（OmniWeaving） | 0.67 / 78.19%（MiniMax-H3） |

  两者互补：一个说明"现成智能体 + 学会读白模的编辑器"有效，一个说明"冻结渲染器 + 训练过的智能体"有效；两边都训练的组合还没人做。Video-Coder 把 VideoCoCo 归为"提示冻结、常是闭源模型的固定流程"，但它自己的数据和奖励同样依赖闭源 / 专有模型（Gemini 3.8 Flash、Seed2.0、MiniMax-H3、Qwen3.8-omni-flash）。
- **code2video 一支的前后**：[GPT4Motion](https://arxiv.org/abs/2311.12631)（5-01）是最早的"GPT 写 Blender 物理脚本 → 引导扩散"；[Code2Video](https://arxiv.org/abs/2510.01174)（5-03）写 Manim 代码直接成片，也有 Planner / Coder / Critic 的多轮修正，但不训练；[PhysOPSD](https://arxiv.org/abs/2611.12411)（5-07）只在训练时用代码草稿当特权信息，推理不需要智能体——和 Video-Coder 的"推理时每条提示都要跑几十轮 Blender"在成本上是两个极端。
- **和第一节"代码世界 + 视频渲染器"的关系**：渲染器选 **MiniMax-H3** 和 [[topics/notes/代码世界模型与神经渲染/1-01_CodeWorldModel|CWM]]、[[topics/notes/代码世界模型与神经渲染/1-12_StreamRender-H3|StreamRender-H3]]、[[topics/notes/代码世界模型与神经渲染/1-14_CoCode-World|CoCode-World]]、[[topics/notes/代码世界模型与神经渲染/2-09_SolarRenderer|SolarRenderer]] 一致（那几篇都用 H3 的 Ref2VA 参考视频通路，本文没说用的是不是这条）。但第一节维护的是**可交互、持续推进的世界**，智能体在运行中改规则（[[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]]、[[topics/notes/代码世界模型与神经渲染/1-10_Mallea|Mallea]]），渲染器要流式甚至实时；Video-Coder 的程序只服务一段离线视频。另一方面，第一节几乎都用现成的大模型（GPT、Claude、Gemini）当编码智能体，**没有人训练过"世界大脑"**；Video-Coder 的 harness + 可执行奖励 + 渲染结果奖励这一套，原则上可以直接搬去训练 CWM 式的世界编码智能体。
- **条件信号的谱系**：Workbench 灰模 RGB 和 [[topics/notes/代码世界模型与神经渲染/1-03_Magpie|Magpie]] 的 UE 白盒、Matrix-Game 4.0 的低模代理同属"粗渲染画面"，没有深度 / 法线 / 语义（对比 [[mirros/notes/01_AgentGarten|AgentGarten]] 的深度 / 法线、[[topics/notes/代码世界模型与神经渲染/2-06_AlayaRenderer-Flash|AlayaRenderer-Flash]] 的 G-buffer）。[[topics/notes/代码世界模型与神经渲染/3-04_WorldDraft|WorldDraft]]（3-04）系统评测了"草稿视频 + 文字 → 视频"，其中 MiniMax-H3 总分 63.63，是被测模型里较强的一个——和本文选 H3 当渲染器、H3 底模在 PhyGenBench 上就有 0.61 是一致的。
- **和智能体 RL / 自我改进的联系**：方法上直接继承 Search-R1、ReTool、SWE-RL、ARPO 一类"工具交互 + 可验证奖励"的智能体 RL，以及一作参与的 AdaTooler-V（自适应视觉工具调用）和被点名的 [Gen-Searcher](https://arxiv.org/abs/2603.28767)（把智能体 RL 用到图像生成）。"在沙箱里执行 → 看渲染结果 → 改代码"的闭环，加上可执行奖励退火到视频奖励，是一个很具体的"用环境反馈训练编码智能体"的例子，可以和 [[topics/递归自我改进RSI]] 里的环境 / 课程生成类工作对照；AgentGarten 的 playbook 积累是不训练权重的另一种做法。
- **和机器人 / 仿真的联系**：
  - Harness 的场景摘要（运动物体在采样帧的世界坐标、出画检查）本质上是**仿真器给的特权状态**，智能体同时看渲染帧和真值坐标来自检——这和机器人里"仿真器状态 + 渲染观测"的 sim 环境设计是一回事。
  - "Blender 白模 → 冻结视频模型补外观"在形式上就是**sim-to-real 的视觉迁移**（同 Cosmos-Transfer、专题里的 RoboRender 2-16 一条线），而且物体轨迹、相机轨迹可以从程序里直接读出来当标签。如果把提示词换成机器人操作或第一视角导航场景（相机沿路径运动、"走到第三扇门前"之类），这套管线可以批量造**带精确运动标签的逼真视频**，供 VLN / 具身模型训练或评测——论文没做，只是潜在用途；VLN 里数据从仿真到真实的问题见 [[topics/视觉语言导航VLN]]。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文是 CC BY 4.0 许可，可以转录，但这里仍只记位置和要点，原句请点页码看）
> 1. 第 2 页 §1 第 3–4 段：用 Gemini 3.8 Flash + Harness 生成轨迹、MiniMax-H3 合成参考视频，得到 SFT-6k / RL-2k；SFT + harness 原生 RL、两种奖励加退火 → 方法概述与数据规模（6k / 2k 的出处）
> 2. 第 3 页 §2.2 末：GPT4Motion、VideoCoCo 依赖提示冻结、常为闭源的模型和固定流程，本文训练多轮编码智能体 → 与 VideoCoCo 的区别
> 3. 第 4 页 §3.1：字幕来自多个公开视频数据集，改写成场景中心描述，丢弃依赖外观和人脸表情的提示词；三级过滤用 Seed2.0 判一致性 → 数据流水线
> 4. 第 5 页 §3.2：统一灰黏土渲染；check_script / run_blender 两个工具；执行反馈、内容检查、视觉反馈三类反馈；提交后从头重跑验收 → Harness
> 5. 第 5 页 §3.3：从 Qwen3.5-9B 初始化；训练时视频生成器冻结，只优化智能体 → 训练哪一边
> 6. 第 6 页式 (3)：R = α·R_video + exp(−steps/T)·R_exe，α = 0.5；R_exe 为 0/1，R_video 用 Qwen3.8-omni-flash → 奖励设计
> 7. 第 6 页 §4.1：8 张 H100 训练、16 张 H100 部署 H3，组大小 8、最多 100 轮、120K 上下文、约 3 天；此处写 SFT-10k / RL-4k → 训练细节与规模矛盾
> 8. 第 7 页 §4.2：0.67 四类第一；OmniWeaving 0.48 → 0.51 "16.28 个点" → 主结果与算不出的数字
> 9. 第 8–9 页 §4.3：SFT 0.63、完整 0.67、去掉任一奖励 0.64 / 0.63、无退火 0.65，解释为可执行奖励被过度利用 → 消融
> 10. 第 15–16 页附录 B：视频奖励的四个维度、五档打分、忽略外观、拿不准取低分 → 视频奖励的具体含义

## 摘要（中文）

近年来视频生成在画面质量和时间一致性上进步显著，但生成空间结构精确、运动动态连贯、场景构成可控的视频仍然困难。本文提出 Video-Coder，首次尝试训练一个代码驱动的视频生成智能体：它自主编写并执行代码，构建一个动态 3D 场景（草稿视频），为下游视频生成器提供结构和运动信号。为支持这一范式，我们设计了专门的数据流水线，整理出两个高质量数据集 Video-Coder-SFT-6k 和 Video-Coder-RL-2k，包含多样的提示词和真值参考视频。我们还开发了 Video-Coder Harness，一个集成代码执行、3D 场景渲染和执行反馈的统一交互环境，用于智能体的训练和推理。随后我们先做 SFT，再做 harness 原生的智能体强化学习来训练 Video-Coder，采用结合执行奖励和视频奖励的双重奖励反馈。此外，我们设计了退火训练策略，随时间逐渐降低执行奖励，让模型在训练后期更多依赖视频奖励。实验表明 Video-Coder 带来显著提升，使 MiniMax-H3 在 PhyGenBench 上提高约 7 个点、在 VBench-2.0 上提高 24 个点。我们希望这项工作能成为视频生成中编码智能体的开放基础，并完全开源数据、模型和代码。

## 摘要（原文）

以下转录自 [arXiv 摘要页](https://arxiv.org/abs/2611.09894)（Chaoyang Wang 等，CC BY 4.0；摘要页上的断字 "Video- Coder"、"fol- lowed" 已合并）：

Recent years have witnessed remarkable progress in video generation in terms of visual quality and temporal consistency. However, generating videos with precise spatial structure, coherent motion dynamics, and controllable scene composition remains challenging. In this paper, we introduce Video-Coder, the first attempt to train a code-driven video generation agent, which autonomously writes and executes code to construct a dynamic 3D scene (Draft Video) that provides structure and motion signals to downstream video generators. To support this paradigm, we design a dedicated data pipeline and curate two high-quality datasets, Video-Coder-SFT-6k and Video-Coder-RL-2k, which contain diverse prompts and ground-truth reference videos. We further develop the Video-Coder Harness, a unified interactive environment integrating code execution, 3D scene rendering, and execution feedback for agent training and inference. We then train Video-Coder with SFT followed by harness-native agentic reinforcement learning with dual reward feedback, which combines execution-based and video-based rewards. Additionally, we design an annealing training strategy that gradually reduces the execution reward over time, allowing the model to rely more on the video reward in the later training stages. Experiments show that Video-Coder achieves significant gains, improving Minimax-H3 by approximately 7 points on PhyGenBench and 24 points on VBench-2.0. We hope this work can serve as an open foundation for coding agents in video generation, and we fully open-source our data, models, and code
