---
id: "5-05"
org: 专题·代码世界模型与神经渲染
short: "VideoCoCo"
title: "VideoCoCo: Code-as-CoT for Physically-Consistent Video Generation via an Agentic Dual-Engine System"
aliases: ["VideoCoCo", "Video-CoCo", "VideoCoCo-3K", "Code-as-CoT"]
date: 2026-07-29
category: "Code2Video：编码智能体写程序来生成视频"
venue: —
affiliation: "香港中文大学 · 中国科学技术大学 · 华南理工大学 · 香港大学 · 南洋理工大学 · 北京大学 · 上海交通大学 · CMU · 清华大学 · 华中科技大学 · MBZUAI"
authors: ["Haodong Li", "Tianfei Ren", "Xiaoxiao Ma", "Chunmei Qing", "Zhen Fang", "Sipeng He", "Ziyu Guo", "Haoyu Wu", "Juanxi Tian", "Yihang Zou", "Ruichuan An", "Dongzhi Jiang", "Boxue Yang", "Ji Xie", "Xu Huang", "Wenhao Yan", "Jialv Zou", "Zhengrong Yue", "Yaxin Luo", "Xiaotong Li", "Yuzhu Wang", "Junyan Ye", "Jinjing Zhao", "Zehui Chen", "Lin Chen", "Renye Yan", "Feng Zhao", "Pheng-Ann Heng"]
arxiv: "2607.27380"
pdf: "[[topics/papers/代码世界模型与神经渲染/5-05_2607.27380_VideoCoCo.pdf]]"
code: "https://github.com/micky-li-hd/VideoCoCo"
project: "https://github.com/micky-li-hd/VideoCoCo"
license: CC BY 4.0（arXiv 摘要页）
status: 未读
rating:
read_date:
tags: ["paper", "code2video", "code-as-cot", "blender", "text-to-video", "physics", "video-editing", "draft-conditioned", "lora", "phygenbench", "vbench-2"]
---

# VideoCoCo: Code-as-CoT for Physically-Consistent Video Generation via an Agentic Dual-Engine System

> [!info] 论文信息
> arXiv [2607.27380](https://arxiv.org/abs/2607.27380) · 本地 PDF 是 v2（2026-08-08）；v1 是 2026-07-29（两版摘要里的数字相同，正文差异未核对）
> 单位：香港中文大学（Pheng-Ann Heng 组）为主，中国科学技术大学（Feng Zhao）、华南理工（Chunmei Qing）等 11 家 · 共同一作：Haodong Li、Tianfei Ren、Xiaoxiao Ma · 项目负责人：Haodong Li、Zhen Fang · 通讯作者：Chunmei Qing、Feng Zhao、Pheng-Ann Heng
> PDF：[[topics/papers/代码世界模型与神经渲染/5-05_2607.27380_VideoCoCo.pdf|本地 PDF]]（16 页：正文约 11 页（第 1–12 页）+ 参考文献（第 12–16 页），没有附录；arXiv 备注写"15 页、3 图、3 表"）
> 代码 / 项目页：[micky-li-hd/VideoCoCo](https://github.com/micky-li-hd/VideoCoCo)（论文里的 Project Page 就是这个 GitHub 仓库；仓库里放了什么没有核对）
> 专题：[[topics/代码世界模型与神经渲染#五、Code2Video：编码智能体写程序来生成视频|代码世界模型与神经渲染 · 五、Code2Video：编码智能体写程序来生成视频]]

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-18）。本机 Read 打不开 PDF，全文是用 PDFKit 脚本抽成文本后通读的；表 1、表 2（第 9 页）和图 2、图 3（第 5、6 页）另外渲染成 PNG 逐格对照过。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。

## 一句话总结

把文生视频拆成两个"引擎"：**可执行仿真引擎**里，编码智能体把提示词写成一个自包含的 **Blender Python 程序**（场景、物体、物理属性、随时间的演化），在沙箱里跑出一段**确定性的白模草稿视频**——作者把这段代码叫作"过程级思维链"（Code-as-CoT）；**生成式视频引擎**里，指令智能体看提示词和草稿写一段只管外观的编辑指令，**以草稿为条件的视频编辑器**（OmniWeaving 加 LoRA）把白模改成逼真视频。为了让编辑器读懂白模草稿，作者用 Seedance 2.0 当老师造了 3000 条"草稿–指令–目标"三元组（VideoCoCo-3K）。结果：OmniWeaving 在 PhyGenBench 上从 0.475 升到 0.558、VBench-2.0 物理维度从 52.18% 升到 77.88%，两个榜的平均分都是表里第一；不训练编辑器、只喂草稿也能到 0.506，作者据此说主要增益来自草稿本身。

## 要解决什么问题

- **因果不透明（Causal Opacity）**：提示词只在很压缩的语义层面描述事件（"黄油在热锅里融化"），没说清支配它演化的物理过程；文生视频模型要同时"脑补"完整的时空过程和外观。外观可以从数据里记住，**某个提示词特有的过程**却很难（第 2、5 页）。
- **现有视频思维链的中间表示不够**（[[topics/papers/代码世界模型与神经渲染/5-05_2607.27380_VideoCoCo.pdf#page=2|图 1，第 2 页]]）：
  - 规划式（VChain、VideoDirectorGPT）：文字计划、布局、关键帧，**不可执行**；
  - 视觉状态式（VideoRLVR、ChEaP）：在生成序列里推中间视觉状态；
  - 测试时搜索式（Video-T1、时间回溯）：采多个候选再挑或改。
  这些中间产物要么只是"描述"或"挑选"，要么**时间上稀疏**（孤立关键帧），都不能把整个过程实例化、检查、修改。
- **物理感知视频生成的两条路都有短板**（§2.2）：显式方法（仿真器、轨迹引导，如 PhyT2V、WISA、PhysCtrl）多依赖固定规则或模板，开放提示词泛化差；隐式方法（DPO、RL、特征对齐，如 VideoDPO、PhyGDPO、PISA）把物理知识藏在奖励或表示里，对"这一个提示词的过程"控制力有限。
- 作者的出发点：同组前作 [DraCo](https://arxiv.org/abs/2512.05112)（草稿当图像生成的 CoT）和 [CoCo](https://arxiv.org/abs/2603.08652)（把草稿换成可执行代码，文生图）——VideoCoCo 把"代码即思维链"从图像预览扩展到**完整的时间过程**。

## 方法

总览见 [[topics/papers/代码世界模型与神经渲染/5-05_2607.27380_VideoCoCo.pdf#page=5|图 2（第 5 页）]]。整条管线只要一个文字提示词，中间产物全是代码或渲染视频。

### 整体流程

| 步骤 | 记号 | 谁来做 | 输入 → 输出 |
|---|---|---|---|
| ① 写程序 | c = A_code(p) | 编码智能体（**哪个模型没写**） | 提示词 → 自包含的 Blender Python 程序 |
| ② 沙箱执行 | d = B(c) | 隔离的 Blender 环境 | 程序 → 白模草稿视频（报错作为诊断信号回传改代码） |
| ③ 写编辑指令 | e = A_edit(p, d) | 指令智能体（**哪个模型没写**） | 提示词 + 草稿 → 只描述外观的编辑指令 |
| ④ 草稿条件编辑 | v̂ = G_θ(d, e) | OmniWeaving + LoRA | 草稿 + 指令 → 逼真视频 |

### 世界状态怎么用代码表示（§3.1）

- **表示**：一个自包含的 Blender Python 程序，声明场景、物体及其物理属性、目标事件的时间演化。选 Blender 代码而不选文字计划或关键帧，理由三条：**显式**（每个物体、运动、交互都得写出来，没有文字计划的欠描述）、**可执行**（智能体必须承诺一个真能跑的过程）、**可检查**（能读、能改、能重跑）。
- **沙箱**：提供一套标准化的原语并强制确定性——同一个程序永远得到同一段草稿；渲染错误作为诊断信号返回给智能体修改代码，而不是静默失败。修改循环最多几轮、怎么判定"草稿合格"都没写。
- **草稿长什么样**：故意做成低保真的**白色黏土仿真**，没有逼真材质和复杂光照，但**时间上稠密**——每一帧都对应程序化过程里一个实例化的物理状态。作者的说法是草稿"定下发生什么、何时发生，长什么样留给下一个引擎"。
- 注意：这里**没有交互式世界状态**，也没有引擎持续推进；程序一次性写完、渲完，就是一段离线视频。图 3 的例子（塑料瓶抽真空瘪掉、干冰升华、鸡蛋砸石头碎掉、木玩具浮在水面）说明草稿里会用到刚体、碎裂、流体或至少形变一类的效果，但论文没说具体用了 Blender 的哪些物理模块，还是靠关键帧动画"摆"出来。

### 渲染器：草稿条件视频编辑（§3.2、§3.4）

| 项 | 内容 |
|---|---|
| 骨干 | **OmniWeaving**（[2603.24458](https://arxiv.org/abs/2603.24458)，统一视频生成 / 编辑模型；参数量论文没写，[[topics/notes/代码世界模型与神经渲染/3-04_WorldDraft\|WorldDraft]] 记为 8.3B） |
| 条件信号 | 白模草稿视频 d（结构与运动）+ 编辑指令 e（主体、材质、光照、镜头风格） |
| 条件注入方式 | 走 OmniWeaving 自带的"视频编辑"输入；具体是通道拼接、参考帧还是 token 拼接，论文没写 |
| 指令的约束 | 只写外观，**明确不鼓励重新描述运动**——"d 管发生什么，e 管长什么样" |
| 训练目标 | 标准条件去噪损失 ‖ε − ε_θ(z_t, t, d, e)‖² |
| 适配方式 | 免训练 / 全量微调 / LoRA 三种，LoRA 最好 |
| 训练超参 | LoRA 秩、步数、学习率、显卡、帧数、分辨率**全都没写** |
| 推理 | 多少步去噪、生成一段要多久没写；不是实时，也不是流式 |

- 为什么要训练：白黏土草稿的风格不在现成编辑器的训练分布里，现成编辑器要么**忽略草稿的运动**，要么**幻觉出与草稿冲突的外观**（第 7 页）。
- 图 2 里指令的例子末尾带着 `--resolution 720p --duration 5 --ratio 16:9`，看起来像商用视频 API 的参数格式（猜测是给老师 Seedance 2.0 用的），说明最终视频大致是 720p、5 秒、16:9；论文正文没有交代输出规格。

### VideoCoCo-3K：草稿–指令–目标三元组（§3.3）

| 项 | 内容 |
|---|---|
| 构造方式 | 把上面的管线大规模跑一遍：每个提示词 p_i → 草稿 d_i + 指令 e_i，再调用一次老师编辑器 G_T 得到逼真目标 y_i = G_T(d_i, e_i) |
| 老师 | **Seedance 2.0**（字节，闭源）：选它是因为既能出逼真画面、又能忠实保留草稿运动 |
| 规模 | 3000 条三元组 |
| 提示词来源 | "我们的源分布"，具体是哪些数据集没写 |
| 去污染 | 排除了评测基准的全部提示词及其近似重复 |
| 附带元数据 | 原始提示词和 Blender 程序，便于检查、扩充、重新生成 |
| 质量筛选 | 没写（没提到对老师输出做过滤） |

本质上是**把闭源老师的"草稿 → 逼真"能力蒸馏进开源 OmniWeaving 的一个 LoRA**。

### 一致性与记忆

论文只做 5 秒左右的单段视频，不涉及长时记忆、外观锚点或跨段一致性；"一致性"指的是视频里的物理过程和提示词一致，靠草稿把过程钉死。

## 实验与关键数字

评测（§4.1）：**PhyGenBench**（力学 / 光学 / 热学 / 材料四类，官方协议用 GPT-4o 当 MLLM 评委，分数 0–1）和 **VBench-2.0** 的物理维度（力学 / 热学 / 材料，百分比；用的是"预先登记的子集"，子集多大没写）。基线分闭源 API 和开源权重两组；VideoCoCo 加在 OmniWeaving 上，OmniWeaving 单独也报。

### PhyGenBench（[[topics/papers/代码世界模型与神经渲染/5-05_2607.27380_VideoCoCo.pdf#page=9|表 1，第 9 页]]）

| 方法 | 力学 | 光学 | 热学 | 材料 | 平均 |
|---|---|---|---|---|---|
| Pika（闭源） | 0.35 | 0.56 | 0.43 | 0.39 | 0.44 |
| Gen-3（闭源） | 0.45 | 0.57 | 0.49 | 0.51 | 0.51 |
| Kling（闭源） | 0.45 | 0.58 | 0.50 | 0.40 | 0.49 |
| CogVideoX | 0.39 | 0.55 | 0.40 | 0.42 | 0.45 |
| Open-Sora V1.2 | 0.43 | 0.50 | 0.44 | 0.37 | 0.44 |
| LaVie | 0.30 | 0.44 | 0.38 | 0.32 | 0.36 |
| Vchitect-2.0 | 0.41 | 0.56 | 0.44 | 0.37 | 0.45 |
| HunyuanVideo | 0.33 | 0.39 | 0.26 | 0.30 | 0.33 |
| Wan2.2-TI2V-5B | 0.55 | 0.58 | **0.53** | 0.50 | 0.54 |
| Cosmos-Predict2.5 | 0.30 | 0.33 | 0.41 | 0.39 | 0.35 |
| LTX-Video-2B | 0.51 | 0.58 | 0.48 | 0.45 | 0.51 |
| OmniWeaving | 0.48 | 0.56 | 0.43 | 0.39 | 0.48 |
| **+ VideoCoCo** | **0.56** | **0.61** | 0.51 | **0.53** | **0.56** |

- 正文给三位小数：平均 0.475 → **0.558**，力学 0.558、光学 0.613、热学 0.511（第二，Wan2.2-TI2V-5B 0.533）、材料 0.525；最强开源基线 Wan2.2-TI2V-5B 平均 0.544。
- 相对 OmniWeaving 增益最大的是**材料 +0.133**（0.392 → 0.525）和**热学 +0.078**（0.433 → 0.511）——作者的解释是"外观先验最弱的地方，代码贡献的是动力学而不是表面真实感"。

### VBench-2.0 物理维度（[[topics/papers/代码世界模型与神经渲染/5-05_2607.27380_VideoCoCo.pdf#page=9|表 2，第 9 页]]）

| 方法 | 力学 | 热学 | 材料 | 平均 |
|---|---|---|---|---|
| Sora（闭源） | 62.22% | 43.36% | 64.94% | 56.84% |
| Kling 1.6（闭源） | 65.55% | 59.46% | 68.00% | 64.34% |
| HunyuanVideo | 76.09% | 56.52% | 64.37% | 65.66% |
| CogVideoX-1.5 | 80.80% | 67.13% | **83.19%** | 77.04% |
| OmniWeaving | 62.79% | 52.08% | 41.67% | 52.18% |
| **+ VideoCoCo** | **92.31%** | **72.92%** | 68.42% | **77.88%** |

- 平均 +25.70 个点；力学 +29.52、热学 +20.84；材料第二，落后 CogVideoX-1.5。三列平均和表里的平均对得上。

### 消融：编辑器怎么适配（[[topics/papers/代码世界模型与神经渲染/5-05_2607.27380_VideoCoCo.pdf#page=10|表 3，第 10 页]]，PhyGenBench）

| 变体 | 力学 | 光学 | 热学 | 材料 | 平均 |
|---|---|---|---|---|---|
| OmniWeaving | 0.48 | 0.56 | 0.43 | 0.39 | 0.48 |
| + VideoCoCo（免训练） | 0.50 | 0.53 | 0.48 | 0.51 | 0.51 |
| + VideoCoCo（全量微调） | 0.51 | 0.61 | 0.51 | 0.49 | 0.54 |
| + VideoCoCo（LoRA） | **0.56** | **0.61** | **0.51** | **0.53** | **0.56** |

- 免训练（原版 OmniWeaving 直接读草稿）平均 0.475 → **0.506**，热学 0.433 → 0.478、材料 0.392 → 0.508。没有更新任何参数，作者据此说"增益完全来自可执行草稿"。
- LoRA（0.558）好过全量微调（0.535）：作者的解释是这项适配很窄（只学"白黏土 → 逼真"的改风格），低秩子空间保住了底模的视觉先验，全量微调在 3K 数据上容易过拟合。

### 定性（[[topics/papers/代码世界模型与神经渲染/5-05_2607.27380_VideoCoCo.pdf#page=6|图 3，第 6 页]]）

四个例子：塑料瓶抽真空瘪掉、干冰升华、鸡蛋砸石头碎裂、木玩具浮在水面。基线画面合理但过程不对（例如干冰没有升华），VideoCoCo 跟着草稿走对了过程。

## 局限 / 存疑

- **两个智能体是什么模型没写（需核对）**：编码智能体 A_code 和指令智能体 A_edit 是哪个大模型、用什么提示词、改代码最多几轮、怎么判定草稿合格，正文都没交代，也没有附录。这直接影响结果能否复现，也影响"代码贡献了多少"的解读——智能体本身的物理常识可能才是关键。
- **图 3 的基线列名和图注对不上（需核对）**：图里中间一列标的是 "Wan 2.1"，图注却说是 OmniWeaving。表里也没有 Wan 2.1 这一行。
- **三位小数和两位小数**：正文和摘要用 0.475 / 0.558，表 1 只给 0.48 / 0.56。表 1 的四类平均（0.56、0.61、0.51、0.53）简单平均是 0.5525，和 0.558 不完全一致，推测 PhyGenBench 的平均是按题数加权的，论文没说明。
- **"每一类都提升"不完全对**：§4.3 说 LoRA 版本"每一类都超过底模"成立；但免训练版的**光学从 0.56 降到 0.53**，全量微调版的材料（0.49）也低于免训练版（0.51）。"增益完全来自草稿"的说法只在平均分上成立。
- **老师是闭源的 Seedance 2.0**：VideoCoCo-3K 的目标视频全来自它，最终编辑器其实是在模仿 Seedance 2.0 的草稿条件编辑。论文没有报告**直接用 Seedance 2.0 当编辑器**的结果，也没有说老师输出有没有经过质量筛选；"开源模型 + 3K 条蒸馏数据就能追上"的结论缺少这个上限参照。
- **基线范围**：比较的都是纯文生视频模型；相关工作里点名的物理感知方法（PhyT2V、WISA、PhysCtrl、PhyGDPO 等）和同类"代码 / 仿真草稿"方法（GPT4Motion）**都没有进表**。用到了草稿和多个大模型智能体的系统去比单个文生视频模型，算力和信息量不对等。
- **评测细节少**：VBench-2.0 用的"预先登记的子集"多大、怎么选的没写；所有数字都来自一次运行，没有方差；也没有人评。
- **实现细节几乎为零**：LoRA 秩、训练步数、显卡、分辨率、帧数、去噪步数、端到端耗时都没写。作者在结论里承认会增加推理延迟，但没给数字。
- **能力上限是 Blender**：作者自己说湍流这类复杂现象零样本很难合成，未来想接 Taichi 等专门物理引擎，或把这种"可执行先验"蒸馏回端到端视频模型、去掉推理时仿真（这正是后来 [PhysOPSD](https://arxiv.org/abs/2611.12411)（5-07）的方向）。
- **"物理一致"的评委是 GPT-4o**：PhyGenBench 的分数来自 MLLM 评委，白模草稿把"发生了什么"钉得很死，评委容易判对；但画面里的物理细节（例如流体是否真实）未必被这个指标捕捉。

## 与其他论文的关系

- **同节直接对照：[[topics/notes/代码世界模型与神经渲染/5-06_Video-Coder|Video-Coder]]（5-06，2026-11）**。两篇骨架几乎一样：编码智能体写 Blender Python → 沙箱渲出灰 / 白模草稿 → 视频模型按草稿生成逼真视频，评测也都用 PhyGenBench + VBench-2.0 物理维度。差别在**训练哪一边**：
  - VideoCoCo 训练的是**渲染端**：智能体用现成的（没说是哪个），编辑器 OmniWeaving 在 Seedance 2.0 蒸馏出的 3K 三元组上加 LoRA；
  - Video-Coder 训练的是**编码端**：渲染器 MiniMax-H3 冻结不动，Qwen3.5-9B 智能体先在 Gemini 3.8 Flash 的多轮轨迹上 SFT，再用"可执行奖励 + 视频奖励（退火）"做 GRPO；它的 Harness 还会把渲染帧和场景摘要回传给智能体做多轮自检，VideoCoCo 只提到把报错回传。
  - 数字上：同样以 OmniWeaving 为渲染器，VideoCoCo 自报 PhyGenBench 平均 0.558，Video-Coder（智能体训练时配的是 H3，测试换成 OmniWeaving）只有 0.51；Video-Coder 的最好结果 0.67 / 78.19% 用的是更强的 MiniMax-H3（底模就有 0.61）。**Video-Coder 的表 1 把 VideoCoCo 记成 0.51 / 0.58 / 0.48 / 0.45 / 0.51，和 LTX-Video-2B 那一行一模一样，也和本文 v1、v2 摘要里的 0.558 不符**，看起来是抄错行，见 Video-Coder 笔记的"局限 / 存疑"。两篇的基线行（Pika 到 LTX-Video-2B、VBench 的 Sora 到 CogVideoX-1.5）数字完全相同，Video-Coder 应该是直接沿用了本文的表。
  - 两者互补：一个证明"现成智能体 + 适配过的编辑器"够用，一个证明"冻结渲染器 + 训练过的智能体"也够用；把两边都训练的组合目前没人做。
- **code2video 一支的前后**：[GPT4Motion](https://arxiv.org/abs/2311.12631)（5-01）早就是"GPT 写 Blender 物理脚本 → 渲染结果引导扩散"，VideoCoCo 的区别主要是换成了现代视频编辑模型并专门训练它读白模草稿；[Code2Video](https://arxiv.org/abs/2510.01174)（5-03）写 Manim 代码直接渲成片，不需要神经渲染；[PhysOPSD](https://arxiv.org/abs/2611.12411)（5-07，与 WorldDraft 有共同作者）把"代码渲出的物理草稿"只放在训练时当特权信息，推理时只要文字——正好对应本文结论里"把可执行先验蒸馏回端到端模型"的设想。
- **和第一节"代码世界 + 视频渲染器"的区别**：[[topics/notes/代码世界模型与神经渲染/1-01_CodeWorldModel|CWM]]、[[mirros/notes/01_AgentGarten|AgentGarten]]、[[topics/notes/代码世界模型与神经渲染/1-12_StreamRender-H3|StreamRender-H3]]、[[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]]、[[topics/notes/代码世界模型与神经渲染/1-15_GameWM|GameWM]] 都维护一个**可交互、持续推进**的代码世界，渲染器要流式甚至实时；VideoCoCo 的程序只为一段 5 秒视频服务，一次写完、一次渲完，没有动作输入、没有记忆、没有实时要求。但"代码 / 引擎定结构和运动，视频模型只管外观"的分工完全一样，CWM 把这叫"代理视频"，本文叫"时空草稿"。
- **条件信号的谱系**：本文的白黏土 RGB 草稿和 [[topics/notes/代码世界模型与神经渲染/1-03_Magpie|Magpie]] 的 UE 白盒、Matrix-Game 4.0 的低模代理同属"粗渲染画面"一档，不提供深度、法线、语义（对比 AgentGarten 的深度 / 法线、StreamRender-H3 的语义图、[[topics/notes/代码世界模型与神经渲染/2-06_AlayaRenderer-Flash|AlayaRenderer-Flash]] 的 G-buffer）。[[topics/notes/代码世界模型与神经渲染/2-09_SolarRenderer|SolarRenderer]] 用一个控制 LoRA 读各种结构视频，思路和本文"一个 LoRA 学会读白黏土"相近，但 SolarRenderer 冻结的是 MiniMax-H3，且数据来自真实配对而不是商用模型蒸馏。
- **草稿条件渲染的系统评测**：[[topics/notes/代码世界模型与神经渲染/3-04_WorldDraft|WorldDraft]]（3-04）专门考"草稿视频 + 目标文字 → 视频"，也用编码智能体写 Blender / MuJoCo 世界，把 OmniWeaving 列进了被测模型（总分 57.62）；它发现草稿越精细结构越好、外观越差，以及冲突草稿的颜色会"漏"进结果——本文用中性白黏土草稿 + "指令只写外观"的分工，正好避开了外观冲突那一类问题，但"过程对了、外观对不对"本文没有单独评。
- **和机器人 / 具身的联系**：
  - "白模仿真视频 → 逼真视频"的编辑器，和机器人里用 Cosmos-Transfer 一类模型做**仿真到真实的视觉迁移**（sim-to-real 数据增广）是同一件事；专题里的 RoboRender（2-16）就是这条线。本文的 VideoCoCo-3K（仿真草稿–逼真目标配对）在形式上就是一份小规模的 sim-to-real 视觉配对数据，只是内容是日常物理现象而不是机械臂操作。
  - 反过来看，Blender 草稿里物体的运动是程序给定的，逼真视频继承了它——如果要用这类视频当机器人或导航的训练数据，**运动标签（物体轨迹、相机位姿）可以直接从程序里读出来**，这是纯文生视频给不了的。论文没往这个方向走。
- **思维链谱系**：同组前作 [DraCo](https://arxiv.org/abs/2512.05112)（草稿当文生图 CoT）→ [CoCo](https://arxiv.org/abs/2603.08652)（代码当文生图 CoT）→ 本文（代码当文生视频 CoT）。视频侧对照的是 VChain、VideoDirectorGPT（规划式）和 Video-T1（测试时搜索）。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文是 CC BY 4.0 许可，可以转录，但这里仍只记位置和要点，原句请点页码看）
> 1. 第 2 页 §1 第 2 段：提示词只在压缩的语义层描述事件，模型要同时恢复过程和外观，作者称之为 Causal Opacity → 问题动机
> 2. 第 2 页图 1 图注：规划式、测试时搜索式、视觉状态式三类视频 CoT 与本文对比 → 现有中间表示稀疏或不可执行
> 3. 第 6 页 §3.1 "Code-as-CoT Program Synthesis"：选 Blender Python 的三条理由（显式、可执行、可检查）→ 世界状态的代码表示
> 4. 第 6–7 页 §3.1 "Sandboxed Execution"：沙箱提供标准化原语、强制确定性、报错作为诊断信号；草稿是低保真白黏土但时间上稠密 → 草稿的性质
> 5. 第 7 页 §3.2 "Editing Instruction Construction"：指令智能体只写外观、不鼓励重定义运动 → d 管过程、e 管外观的分工
> 6. 第 7 页 §3.2 末段：白黏土草稿不在现成编辑器分布内，会忽略运动或幻觉外观 → 为什么要训练编辑器
> 7. 第 8 页 §3.3：用 Seedance 2.0 当老师、每条调用一次，共 3000 条三元组，排除评测提示词及近似重复 → VideoCoCo-3K 的构造
> 8. 第 8 页 §3.4：从 OmniWeaving 初始化，比较全量微调和 LoRA；推理只需提示词 → 编辑器与端到端推理
> 9. 第 10–11 页 §4.2–4.3：0.475 → 0.558、各类三位小数分数；免训练 0.506；LoRA 0.558 优于全量 0.535 → 关键数字与消融
> 10. 第 12 页 §5：承认增加推理延迟、受限于 Blender 表达力（湍流难），未来接 Taichi 或蒸馏回端到端模型 → 局限

## 摘要（中文）

文生视频模型的画面质量已经很出色，但仍难以生成物理上一致的动态，因为场景的时间演化必须从高度压缩的文字提示里隐式推断。现有的思维链方法引入中间计划或视觉状态，但这些表示通常不可执行或时间上稀疏，限制了它们实例化和控制完整时空过程的能力。为此，我们提出 VideoCoCo，一个智能体式的双引擎框架，其中可执行的 Blender 代码充当过程级的思维链。给定文字提示，编码智能体合成一个 Blender 程序，显式规定场景及其时间演化。可执行仿真引擎运行该程序，生成确定性的时空草稿，随后由生成式视频引擎通过草稿条件编辑把它转换成逼真视频。这种分解把过程级推理和高保真视觉实现分开。为了让视频编辑器适应仿真草稿，我们构建了 VideoCoCo-3K，一个精选的"草稿–指令–目标"三元组数据集。VideoCoCo 把 OmniWeaving 基线在 PhyGenBench 上从 0.475 提升到 0.558，在 VBench-2.0 上从 52.18 提升到 77.88，在两个基准上都取得最好的平均分。这些结果表明，可执行代码是物理一致视频生成的一种有效、可控、可检查的中间表示。

## 摘要（原文）

以下转录自 [arXiv 摘要页](https://arxiv.org/abs/2607.27380)（Haodong Li 等，CC BY 4.0）：

Text-to-video models have achieved remarkable visual quality, yet they still struggle to generate physically consistent dynamics because the temporal evolution of a scene must be inferred implicitly from a highly compressed text prompt. Existing chain-of-thought approaches introduce intermediate plans or visual states, but these representations are typically non-executable or temporally sparse, limiting their ability to instantiate and control the complete spatiotemporal process. To address this limitation, we introduce VideoCoCo, an agentic dual-engine framework in which executable Blender code serves as a process-level chain of thought. Given a text prompt, a coding agent synthesizes a Blender program that explicitly specifies the scene and its temporal evolution. The executable simulation engine runs the program to produce a deterministic spatiotemporal draft, which is subsequently transformed into a photorealistic video by a generative video engine through draft-conditioned editing. This decomposition separates process-level reasoning from high-fidelity visual realization. To adapt the video editor to simulated drafts, we construct VideoCoCo-3K, a curated dataset of draft-instruction-target triplets. VideoCoCo improves the OmniWeaving baseline from 0.475 to 0.558 on PhyGenBench and from 52.18 to 77.88 on VBench-2.0, achieving the best average score on both benchmarks. These results demonstrate that executable code provides an effective, controllable, and inspectable intermediate representation for physically consistent video generation.
