---
id: "3-04"
org: 专题·代码世界模型与神经渲染
short: "WorldDraft"
title: "WorldDraft: If Code Builds the World, Can Video Models Just Render It?"
aliases: ["WorldDraft", "WorldDraft-Primer"]
date: 2026-11-12
category: "基准、立场与相邻工作"
venue: —
affiliation: "南方科技大学 · ZODA · 香港科技大学 · 香港中文大学 · 香港科技大学（广州） · 复旦大学 · 浙江大学 · 中佛罗里达大学（UCF）"
authors: ["Zhiyu Hou", "Wen-Jie Shu", "Harold Haodong Chen", "Weilin Ruan", "Chenfei Liao", "Liuzhou Zhang", "Disen Lan", "Xiaogang Xu", "Qi Chen", "Ser-Nam Lim"]
arxiv: "2611.16217"
pdf: "[[topics/papers/代码世界模型与神经渲染/3-04_2611.16217_WorldDraft.pdf]]"
code: "https://github.com/KevinHuge/WorldDraft"
project: "https://haroldchen19.github.io/WorldDraft-site/"
license: CC BY 4.0（arXiv 摘要页）
status: 未读
rating:
read_date:
tags: ["paper", "benchmark", "generative-rendering", "code-world", "video-to-video", "video-diffusion", "visual-prompting", "evaluation"]
---

# WorldDraft: If Code Builds the World, Can Video Models Just Render It?

> [!info] 论文信息
> arXiv [2611.16217](https://arxiv.org/abs/2611.16217) · v1（2026-11-12），目前只有这一版
> 单位：南方科技大学、ZODA、香港科技大学（项目负责人所在）、港中文、港科大（广州）、复旦、浙大、UCF · 共同一作：Zhiyu Hou、Wen-Jie Shu、Harold H. Chen（项目负责人）
> PDF：[[topics/papers/代码世界模型与神经渲染/3-04_2611.16217_WorldDraft.pdf|本地 PDF]]（27 页：正文 1–10 页 + 参考文献 11–13 页 + 附录 A–D 14–27 页）
> 代码：[KevinHuge/WorldDraft](https://github.com/KevinHuge/WorldDraft) · 项目页：[WorldDraft-site](https://haroldchen19.github.io/WorldDraft-site/)（完整 3×3 网格的生成视频放在这里，PDF 里只有选例）
> 专题：[[topics/代码世界模型与神经渲染#三、基准、立场与相邻工作|代码世界模型与神经渲染 · 三、基准、立场与相邻工作]]

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-18）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。
> 本机没有 PDF 渲染工具，这次是用 macOS PDFKit 抽出全部 27 页文字来读的，**图（图 1 雷达图、图 11 人机一致性、图 12 消融）只看到了正文里引用的数字，没看到图本身**。表 1 的文字抽取有几行错位，下面的表是按列数和正文、表 2 交叉对照后还原的，建议对照第 8 页原表再看一眼。

## 一句话总结

把"代码搭世界、视频模型只渲染"这条路线里的**渲染那一半**单独拿出来考：用编码智能体（GPT-6-Astra）照着真实视频写出 48 个 MuJoCo / Blender 可执行 4D 世界，每个世界在**同一套运动学和相机**下导出 3（草稿精细度 P0 抽象 / P1 仿真 / P2 预演）× 3（外观对齐：中性灰模 / 与目标一致 / 与目标冲突）= 9 种草稿视频，共 432 个严格配对用例；输入只给"草稿视频 + 目标文字"，从**世界保持**（实体数、框 IoU、轨迹、交互事件、相机）和**视觉实现**（属性 QA、正确且持续的绑定）两方面打分。测了 12 个模型，结论是三条：两者此消彼长（SolarRenderer 世界保持最高 63.28 但属性实现 69.97；Wan 3.0 属性实现最高 80.40 但世界保持最低 44.37）；草稿越精细结构越好、外观反而越差（12 个模型里 11 个的外观增益为负）；冲突草稿会让源颜色"漏"到结果里，最高 64.17%（Wan2.1-VACE）。另提出免训练的 **WorldDraft-Primer**：只改第一帧，画角标框和目标颜色的提示，MiniMax-H3 的总分从 63.63 升到 65.56，超过总分第一的 LynnReal-Omni（64.89）。

## 要解决什么问题

- **范式背景**：编码智能体操控 Blender / MuJoCo 等引擎，用代码把布局、轨迹、物理交互写成"可执行的仿真草稿"，视频模型只负责把低保真草稿变成逼真视频。作者的问题就是标题：代码已经把世界建好了，视频模型能不能"只渲染"？
- **两个缺一不可的标准**（§1、§3.1）：
  1. **世界保持**：不改写草稿规定的几何、物体运动、事件时序、相机运动；
  2. **视觉实现**：把文字指定的属性（颜色、材质、光照）生成出来，并在运动、遮挡、视角变化中持续绑在对应实体上。
  作者强调两者互不蕴含：模型常常保住了粗动态却没把外观绑上，或者满足了外观却改了 4D 世界。
- **现有评测的缺口**：
  - V2V 编辑基准（FIVE-Bench、V2V-Bench 等）编辑的是**本来就有丰富纹理的真实视频**，不是低保真草稿；
  - 面向可编程世界的评测（文中叫 PROWBench，引用的是 [ROWBench, 2610.02205](https://arxiv.org/abs/2610.02205)）主要看生成视频是否符合程序记录的状态和事件，外观只用 CLIP 一类整体分数，不查细粒度属性和持续绑定。（这是 WorldDraft 作者的说法，只对 PROWBench 的主赛道成立：PROWBench 的多视角设置有按 5 个属性判的外观合规和跨视角一致指标，见 [[topics/notes/代码世界模型与神经渲染/3-06_PROWBench|PROWBench 笔记]]。）
- 所以需要一个同时评两件事、并且能控制"草稿给多少信息""草稿外观会不会误导"的基准。

## 方法

### 任务形式化（§3.1，[[topics/papers/代码世界模型与神经渲染/3-04_2611.16217_WorldDraft.pdf#page=4|第 4 页]]）

- 上游仿真器执行 4D 世界 W，得到草稿视频 D（T×H×W×3）；渲染器 G 只能看到 (D, p)，输出目标视频 V̂ = G(D, p)。
- W 只用于产生草稿和做评测真值，**渲染器拿不到**任何引擎内部信号（没有深度、语义图、G-buffer、相机参数），条件就是一段 RGB 草稿视频 + 一句目标描述。这一点和专题里多数系统（StreamRender-H3 用语义图、AgentGarten 用深度/法线、AlayaRenderer 用 G-buffer）不同，见"局限 / 存疑"。

### 可执行世界族（§3.2、附录 A）

| 项目 | 内容 |
|---|---|
| 数量 | 48 个世界族 |
| 谁写代码 | 多模态编码智能体 GPT-6-Astra，把真实视频里的物理交互和相机路径翻译成 MuJoCo 或 Blender 脚本 |
| 真实视频的角色 | 只当"世界蓝本"，不要求像素级复现 |
| 记录的真值 | W_i = (S_i 3D 几何, T_i 稠密轨迹, E_i 事件时间戳, C_i 相机位姿) |
| 准入审核 | ① 数值稳定不发散；② 忠于参考交互；③ 有明确的 4D 绑定压力点（可评） |
| 六类挑战 | I 多实体编排 · II 多阶段动态 · III 遮挡与重现 · IV 相机运动 · V 非刚体形变 · VI 混合交互（碰撞、动量传递） |

六类是按"主要压力"分的，不是互斥划分；每个世界族归到它最主要的那类，同时带次要动态（第 5 页）。各类的例子见附录图 5–10（[[topics/papers/代码世界模型与神经渲染/3-04_2611.16217_WorldDraft.pdf#page=15|第 15–20 页]]）。正文没给每类有几个世界族；只在附录 B.1 提到相机分数只在"8 个相机运动世界族"上算。

### 受控草稿设计：3×3 因子网格（§3.3，[[topics/papers/代码世界模型与神经渲染/3-04_2611.16217_WorldDraft.pdf#page=5|第 5–6 页]]）

每个世界固定运动学和目标 prompt，只沿两个轴改草稿外观：

| 轴 | 档位 | 含义 |
|---|---|---|
| 草稿精细度 P | P0 抽象 | 基本几何体 + 平涂着色，只保留基本语义和运动 |
| | P1 仿真 | 标准物理网格 + 基础光照；**标准工作点** |
| | P2 预演（previs） | 稠密网格、完整场景、真实阴影；仍有合成到真实的差距 |
| 外观对齐 A | A_N 中性 | 灰模一类无信息着色，外观全靠文字 |
| | A_A 对齐 | 草稿外观与目标 prompt 一致（在该精细度允许的精度内） |
| | A_C 冲突 | 故意相反（如草稿是蓝色金属、目标是红色塑料），测"源泄漏" |

- 两个轴都只动表面外观，不动几何 S、运动 T、相机 C。48 × 9 = **432 个严格配对用例**。
- **Prompt 约束**：每个世界一个 prompt，含 2–4 个可验证属性；用空间/语义角色指代实体（"领头的方块"），不用外观词，免得随对齐档位变；**不写轨迹和相机路径**，防止文字补偿草稿的稀疏。

### 评测套件（§3.4、附录 B，[[topics/papers/代码世界模型与神经渲染/3-04_2611.16217_WorldDraft.pdf#page=16|第 16–22 页]]）

统一协议：只评生成视频的**前 5 秒**，按绝对时间戳对齐；几何类 8 Hz 共 40 个时间点，属性/事件 QA 取 8 个关键时间点；**不做任何事后对齐、变形或尺度归一**，空间漂移、比例变形、事件错位都直接扣分。

| 维度 | 组成（权重） | 工具 |
|---|---|---|
| 世界保持 WP | 0.40 实体与布局 E + 0.40 运动与事件 M + 0.20 相机 K | |
| · E | 0.25 全局计数 GC（t = 0 / 2.125 / 5 s 三点全对）+ 0.25 局部计数 LC + 0.50 框 IoU（对比仿真器投影的 amodal 3D 包围盒） | SAM3 检测 + 全局匈牙利匹配（IoU ≥ 0.05） |
| · M | 0.25 轨迹覆盖 TC + 0.50 交互成功率 ISR（动作和结果都对，12 帧）+ 0.25 事件时序覆盖 EC | |
| · K | 旋转误差 / 180° 与尺度归一的平移误差 / 2 的平均，转成 0–100；只在 8 个相机运动世界族上算 | ViPE 估 6-DoF 轨迹 |
| 渲染保真 RF | 属性级二值 QA（颜色、材质、纹理、环境、光照），正反问题平衡；**评委只看目标文字和生成视频，看不到草稿** | Qwen3.6-27B（沿用 ROWBench 做法） |
| 视觉质量 VQ | MUSIQ-SPAQ 与 LAION 美学分的平均，**不参与门控**，单独列 | |
| 外观持续 AP | 锚点帧属性正确 c_q 且后续时间点同一实体仍保持 s_q，两者都为 1 才得分（"一直错"不算一致） | |
| 冲突惩罚 CP | RF(P1, A_A) − RF(P1, A_C) | |
| 源泄漏 SL | 冲突的源颜色在目标实体上仍出现的比例；作者注明 SL 低不代表目标实现了 | |

**总分**（附录 B.4，第 21–22 页）= 0.50 R + 0.25 G + 0.25 C_rob：

- R：每个条件下 WP^0.40 · RF^0.20 · AP^0.30 · VQ^0.10 的加权几何平均，再对 9 个条件取平均；几何平均是为了惩罚"只保结构不管 prompt"或反过来的退化捷径。
- G（精细度响应）= 50 + (g_s + g_a + g_b)/6，三个 P0→P2 增益线性映射到 0–100，50 = 无变化。
- C_rob = [RF_C + AP_C + (100 − max(CP, 0)) + (100 − SL)] / 4。

**人机一致性**（附录 B.5）：五名人工盲评取多数票，六个指标的一致率 87.5%–94.2%，平均 91.0%（RF 94.2、SL 92.5、AP 91.5、ISR 90.8、GC 89.2、LC 87.5）。抽了多少个用例没说。

### WorldDraft-Primer：只改第一帧的视觉提示（§4、附录 C，[[topics/papers/代码世界模型与神经渲染/3-04_2611.16217_WorldDraft.pdf#page=7|第 7 页]]）

- **思路**：文字提示没有空间定位，容易让多个实体串色；改所有帧又会破坏确定的运动并引入闪烁。视频扩散模型会经时空注意力把第一帧的外观往后传，所以**只改第一帧**，后面 T−1 帧原样保留。
- **物体强调（对应世界保持）**：VLM（正文说 Qwen3.5，附录 C.4 说 Qwen3.5-27B）按 prompt 挑出 K 个关键实体，开放词汇定位模型给 2D 框，在框外画中性单色的 **L 形角标**；角标只占边缘，不盖住实体内部和接触面。
- **属性提示（对应视觉实现）**：实体提示——把角标换成目标颜色、在实体轮廓内画稀疏的目标色斜线、简化纹理或粗高光；环境提示——在支撑面上加软接触阴影、粗地面纹理或光照渐变。
- 所有提示由程序用 **SVG** 画，不用扩散修补，避免噪声和模糊。附录 C.4 给了完整的智能体系统提示：最多 8 轮、每轮一次工具调用、最多两次裁剪放大，按几何、初始位置和跨帧运动认实体（不按目标颜色），最多 16 个单体框或 6 个群组框。从系统提示里写的坐标看，草稿分辨率是 **832×480**。
- **免训练、即插即用**，不需要仿真器内部信号，只用草稿和 prompt。

## 实验与关键数字

### 被测模型（§5.1）

12 个：10 个开源 + 2 个商用。

| 类别 | 模型 |
|---|---|
| 生成式渲染器 | SolarRenderer-33B、C2R-14B |
| 全能模型（omni） | MiniMax-H3-33B、LynnReal-Omni-32B、OmniWeaving-8.3B、VINO-13B、UniVideo-13B |
| 可控生成器 | Bernini-R-14B、Wan2.2-VACE-Fun-A14B、Wan2.1-VACE-14B |
| 商用 | Wan 3.0、Seedance 2.5 |

### 主结果（[[topics/papers/代码世界模型与神经渲染/3-04_2611.16217_WorldDraft.pdf#page=8|表 1，第 8 页]]）

渲染表现 = 3×3 全网格平均；精细度增益 = A_N 下 P0→P2 的变化；冲突鲁棒 = P1、A_C 下。粗体为该列最好。

| 模型 | 规模 | WP↑ | RF↑ | VQ↑ | AP↑ | 结构增益 | 外观增益 | 绑定增益 | 冲突 RF↑ | 冲突 AP↑ | CP↓ | SL↓ | 总分↑ |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| OmniWeaving | 8.3B | 61.61 | 66.37 | 62.02 | 58.01 | +12.75 | −14.47 | −15.95 | 58.13 | 47.68 | 10.63 | 50.97 | 57.62 |
| UniVideo | 13B | 53.34 | 67.31 | 63.01 | 59.10 | +15.61 | −4.24 | −7.43 | 63.39 | 51.78 | 6.02 | 52.24 | 57.82 |
| VINO | 13B | 52.83 | 67.95 | 63.43 | 60.38 | +15.99 | −2.70 | −5.21 | 67.34 | 56.75 | 3.57 | 38.26 | 59.78 |
| Wan2.1-VACE | 14B | 60.97 | 60.86 | 60.78 | 51.68 | **+18.82** | −2.89 | −2.68 | 60.93 | 50.37 | 8.05 | 64.17 | 56.89 |
| Wan2.2-VACE | 14B | 60.52 | 70.25 | 64.11 | 62.09 | +11.48 | −2.37 | −4.74 | 68.80 | 59.18 | 3.14 | 33.60 | 62.43 |
| C2R | 14B | 53.05 | 71.14 | 65.14 | 64.96 | +15.98 | −2.75 | −5.65 | 69.95 | 63.11 | 4.45 | 43.03 | 61.10 |
| Bernini-R | 14B | 61.81 | 72.41 | 63.88 | 64.80 | +8.45 | −3.33 | −3.51 | 71.17 | 62.53 | 2.93 | 43.16 | 62.97 |
| LynnReal-Omni | 32B | 60.52 | 75.51 | 65.48 | 68.41 | +7.26 | −3.62 | −5.28 | 75.32 | 68.05 | 2.26 | 30.54 | **64.89** |
| MiniMax-H3 | 33B | 50.70 | 76.38 | 64.06 | 70.32 | +8.01 | −0.89 | −1.93 | 76.41 | 70.80 | 0.74 | 28.64 | 63.63 |
| SolarRenderer | 33B | **63.28** | 69.97 | 62.48 | 61.68 | +12.25 | −1.49 | −2.02 | 69.43 | 60.17 | 4.27 | 40.37 | 62.59 |
| Wan 3.0（商用） | – | 44.37 | **80.40** | **66.92** | **75.41** | −0.35 | −0.58 | −0.16 | **79.82** | **74.18** | **0.53** | **27.39** | 63.36 |
| Seedance 2.5（商用） | – | 58.66 | 75.55 | 63.10 | 69.20 | +10.88 | **+2.51** | **+3.21** | 76.60 | 69.53 | 1.97 | 41.57 | 64.73 |

（表 1 的抽取文字里 LynnReal-Omni、MiniMax-H3、SolarRenderer、Wan 3.0、Seedance 2.5 几行错位；LynnReal-Omni、MiniMax-H3、Seedance 2.5 三行与表 2 完全一致，SolarRenderer 的 WP 63.28 和 Wan 3.0 的 WP 44.37 / RF 80.40 与正文一致。原表的"最好 / 次好"标色看不到，粗体是我按数字标的。）

三条结论（§5.2）：

1. **世界保持与视觉实现此消彼长**：SolarRenderer WP 最高（63.28）但 RF 只有 69.97；Wan 3.0 RF 最高（80.40）但 WP 最低（44.37）。在通用视频榜上领先的 Seedance 2.5 总分 64.73，被 32B 的 LynnReal-Omni（64.89）略微超过，拖后腿的是 WP 58.66。作者结论："通用视觉规模化不解决双重正确性"。
2. **草稿越精细，结构越稳、外观越差**：开源模型的结构增益全为正（最高 Wan2.1-VACE +18.82）；外观和绑定增益几乎全为负（OmniWeaving −14.47 / −15.95），Seedance 2.5 是唯一例外（+2.51 / +3.21）。作者的解释是稠密草稿带来的合成着色偏置压过了文字条件的交叉注意力。
3. **冲突源外观会泄漏**：开源模型冲突惩罚最高 10.63（OmniWeaving），源颜色泄漏最高 64.17%（Wan2.1-VACE）、UniVideo 52.24%；连 Wan 3.0、MiniMax-H3 也有约 28%–30%（27.39 / 28.64）。作者的说法是渲染器把草稿像素当成刚性约束，而不是可覆盖的脚手架。

### 失败模式（§5.3，[[topics/papers/代码世界模型与神经渲染/3-04_2611.16217_WorldDraft.pdf#page=9|图 4，第 9 页]]）

用 LynnReal-Omni 和 Seedance 2.5 举例：

- **文字驱动的结构覆盖**：C05（遮挡与重现，仓库叉车）里两者的"空间保持"分数都 ≤ 18.8，最低 6.2，生成了完全不同的视角和叉车轨迹，退化成文生视频。
- **空间推理和属性绑定弱**：A04（12 艘帆船排成 3×4 的颜色布局）在 A_N 下颜色被打乱。
- **预演纹理"锁死"和冲突泄漏**：A04 从 P1 到 P2，LynnReal-Omni 的 RF 在 A_A 下从 73.1 掉到 46.2，A_C 下掉到 17.3；在 (P1, A_C) 还多生成了一簇绿色帆船。
- 附录 D（第 25 页）的补充例子：MiniMax-H3 在 A01 把俯视相机转走、在 C05 (P1, A_C) 照抄草稿的红车身；Wan 3.0 在 F03 把整齐的多米诺阵变成稀疏的乱块；Seedance 2.5 在 E03 (P2, A_C) 保住了伞面几何却保留了冲突的红白条纹。

### WorldDraft-Primer（[[topics/papers/代码世界模型与神经渲染/3-04_2611.16217_WorldDraft.pdf#page=10|表 2，第 10 页]]）

| 模型 | WP | RF | VQ | AP | 结构 | 外观 | 绑定 | 冲突 RF | 冲突 AP | CP↓ | SL↓ | 总分 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| OmniWeaving | 61.61 | 66.37 | 62.02 | 58.01 | +12.75 | −14.47 | −15.95 | 58.13 | 47.68 | 10.63 | 50.97 | 57.62 |
| + Text PE | 62.63 | 67.98 | 63.46 | 59.36 | +12.98 | −14.81 | −16.32 | 60.06 | 48.79 | 10.30 | 49.79 | 58.52 |
| + Primer | 64.60 | 70.93 | 66.19 | 61.90 | +13.51 | −15.45 | −17.02 | 62.97 | 50.88 | 10.41 | 47.55 | 60.13 |
| MiniMax-H3 | 50.70 | 76.38 | 64.06 | 70.32 | +8.01 | −0.89 | −1.93 | 76.41 | 70.80 | 0.74 | 28.64 | 63.63 |
| + Text PE | 51.45 | 77.91 | 65.34 | 71.72 | +8.07 | −0.91 | −1.97 | 77.94 | 72.22 | 0.75 | 28.07 | 64.89 |
| + Primer | 52.55 | 80.21 | 67.26 | 73.84 | +8.24 | −0.93 | −2.02 | 80.23 | 74.34 | 0.78 | 27.21 | **65.56** |

- OmniWeaving：WP +2.99、RF +4.56、SL −3.42 个百分点、总分 +2.51（按表核对一致）。
- MiniMax-H3：RF 到 80.21（+3.83），总分 65.56（+1.93），超过 LynnReal-Omni 和 Seedance 2.5。
- Text PE（改写 VPO，每个世界族只优化一次 prompt，九个条件共用）只带来 +0.90 / +1.26 的总分提升。
- 注意：Primer 让两个模型的**外观 / 绑定增益更负**（OmniWeaving −14.47 → −15.45），MiniMax-H3 的 CP 也略升（0.74 → 0.78）；"两个目标都稳定提升"只在 WP、RF、AP 这几列成立。

**组件消融**（附录 C.2，第 23 页，MiniMax-H3，图 12 没看到，以下是正文数字）：

| 去掉的组件 | 变化 |
|---|---|
| 物体强调（角标） | GC 30.02 → 28.70，LC 45.42 → 43.43，框 IoU 16.70 → 15.97 |
| 属性提示 | RF 80.21 → 76.61，AP 73.84 → 70.53，SL "升到" 26.75% |

注意 MiniMax-H3 即使加了 Primer，GC 也只有 30.02、框 IoU 16.70，实体计数和定位的绝对水平都很低。

## 局限 / 存疑

- **"负外观增益"的模型个数对不上（需核对）**：正文说外观和绑定增益"10 个模型里 9 个为负，Seedance 2.5 是唯一例外"。但表 1 有 12 个模型，10 个开源模型的外观和绑定增益**全部**为负，Wan 3.0 也为负，只有 Seedance 2.5 为正，即 12 个里 11 个为负。"10 个"和"9 个"都不知道指哪个集合。
- **消融里源泄漏的方向矛盾（需核对）**：附录 C.2 说去掉属性提示后 SL "升到 26.75%"，还说完整 Primer "六个指标同时最好"；但表 2 里完整 Primer 的 SL 是 27.21%，比 26.75% 还高。要么图 12 的基准数字和表 2 不是同一次运行，要么文字写错。
- **"消融崩塌"的措辞偏重**：去掉角标后 GC 只降 1.32、框 IoU 降 0.73，正文却说"所有空间指标急剧崩塌"。
- **渲染器只给 RGB 草稿**：任务定义里渲染器只能看到草稿视频和文字，没有深度、语义、G-buffer、相机参数等引擎信号，也没有参考图。而专题里真正部署的系统几乎都用结构通道（StreamRender-H3 语义图 + 参考图、AgentGarten 深度/法线、AlayaRenderer G-buffer、Matrix-Game 4.0 低模代理 + 空间记忆帧）。所以 WorldDraft 测的是"通用 V2V 模型把 RGB 草稿当条件"这一种接口，结论不一定能推到这些系统；作者也没有评测任何一个完整的代码世界系统（CWM、AgentGarten、StreamRender-H3、Matrix-Game 4.0 的渲染器都不在被测列表里）。
- **SolarRenderer 和 C2R 是怎么接入的没说**：SolarRenderer 本来是结构视频走 H3 参考通路 + 控制 LoRA，C2R 是粗 3D 渲染条件；"所有模型都输入 (D, p)"时它们的条件通道怎么填、有没有参考图，没有交代。同为"生成式渲染器"，C2R 的 WP（53.05）比 OmniWeaving（61.61）还低，"专用渲染器保持更好"这一说法只对 SolarRenderer 成立。
- **总分的设计**：精细度分数 G 奖励 P0→P2 的结构增益，P0 上做得差的模型反而能拿更多分；Wan 3.0 结构增益为负，部分原因可能是它在 P0 就已经很"自由"。作者自己也承认增益和惩罚依赖各模型的基线水平（第 22 页）。
- **评测依赖 VLM 和检测器**：RF、AP、SL、ISR 都由 Qwen3.6-27B 判，框和计数靠 SAM3 + 匈牙利匹配。人机一致率平均 91.0%，但抽样量没给；相机分数靠 ViPE 从生成视频反估。
- **只评前 5 秒**，长时一致性（专题里流式渲染器最关心的）不在范围内；草稿本身多长也没写。
- **规模**：48 个世界族、每类约 8 个（按 48/6 推测，论文没给分布），每个组合只有 48 个样本，模型间零点几分的差距（如 64.89 对 64.73）未报告方差或置信区间。
- **小的引用和命名问题**：正文写 "PROWBench"，参考文献题目是 "Rowbench"；GPT-6-Astra 引的是 GPT-5 系统卡；Qwen3.5 / Qwen3.6 都引 Qwen3 技术报告；MiniMax-H3 标为 2025 年（专题清单记的是 2026-08-03 发布）。
- **Primer 的定位**：作者在附录 C.1 自己说它是"分析性的概念验证"——弱模型（OmniWeaving）有时会把角标"回显"到后续帧，P2 稠密草稿下仍偏塑料感着色。另外它要额外跑一个 27B VLM 智能体（最多 8 轮），对实时渲染并不现实。

## 与其他论文的关系

- **它在专题里的位置**：专题第一节的系统（[[topics/notes/代码世界模型与神经渲染/1-01_CodeWorldModel|CWM]]、[[mirros/notes/01_AgentGarten|AgentGarten]]、[[topics/notes/代码世界模型与神经渲染/1-12_StreamRender-H3|StreamRender-H3]]、[[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]]、[[topics/notes/代码世界模型与神经渲染/1-15_GameWM|GameWM]]）都是"做一个系统并展示它能跑"；WorldDraft 第一次把"渲染器是否忠实"拆成可量化的世界保持 / 视觉实现，并且用因子设计控制草稿信息量和外观冲突。但它测的是离线 V2V，不涉及实时、流式、交互。
- **和各系统条件信号的对照**：
  - 专题脉络里"条件信号在变粗"（G-buffer → 深度/法线 → 语义图 → 低模代理）。WorldDraft 的 P0→P2 正好是"草稿精细度"这一维的受控实验，结论是**更精细的草稿稳住结构但拖累外观**，这给"条件越粗、渲染器补得越多"提供了一个侧面证据，也提示 Matrix-Game 4.0 一类低模代理条件的外观上限可能受代理着色影响。
  - **"源泄漏"**与 [[topics/notes/代码世界模型与神经渲染/1-12_StreamRender-H3|StreamRender-H3]] 的设计选择相呼应：StreamRender-H3 只给语义图（每类一个平色、无光照纹理），外观全部来自参考图 + prompt，正是在接口上避开了"草稿外观被抄进结果"的问题；但它也因此需要每次会话先生成参考图。
  - [[topics/notes/代码世界模型与神经渲染/1-15_GameWM|GameWM]] 主张交互细节也交给视频模型生成，这与 WorldDraft 严格扣"不许改写草稿"的世界保持标准是两种取向；按 WorldDraft 的口径，GameWM 式的自由发挥会被记作结构偏离。
- **被测的结构条件渲染器**：[[topics/notes/代码世界模型与神经渲染/2-09_SolarRenderer|SolarRenderer]]（WP 第一）、[C2R / Coarse-to-Real](https://arxiv.org/abs/2601.22301)。专题第二节的 [[topics/notes/代码世界模型与神经渲染/2-06_AlayaRenderer-Flash|AlayaRenderer-Flash]]、DiffusionRenderer、Cosmos-Transfer 都没测。
- **底座**：MiniMax-H3（CWM、[[topics/notes/代码世界模型与神经渲染/1-05_CoDeR|CoDeR]]、StreamRender-H3、SolarRenderer、GameWM 的渲染底座）在这里作为通用 omni 模型直接被测：RF 和冲突鲁棒性很好，但 WP 只有 50.70，12 个模型里倒数第二（仅高于 Wan 3.0）。可以看作那些系统要给 H3 加 LoRA / 结构通道微调的一个旁证（推测，论文没做这个对比）。
- **LynnReal-Omni**（[2609.15863](https://arxiv.org/abs/2609.15863)）总分第一；StreamRender-H3 的流式窗口（sink + 近期历史）和引导拟合正是沿用 LynnReal-Omni 的做法。
- **相关评测**：[ROWBench](https://arxiv.org/abs/2610.02205)（与 [[topics/notes/代码世界模型与神经渲染/1-04_ProgrammableWorldModel|Programmable World Model]] 同一批作者，Zheng-Hui Huang 等）查生成视频是否符合程序记录的状态和事件，WorldDraft 的 QA 协议照它来，但补上了细粒度属性和持续绑定；[Video2World](https://arxiv.org/abs/2610.04432) 评的是上游"看视频搭仿真环境"，WorldDraft 评下游渲染，两者正好首尾相接（WorldDraft 自己的世界也是编码智能体照真实视频写出来的）。
- **代码建世界的上游工作**（相关工作里引用）：[Code as Worlds](https://arxiv.org/abs/2608.27549)、[GS-Agent](https://arxiv.org/abs/2607.21522)、[VideoCoCo](https://arxiv.org/abs/2607.27380)、Code Video Model（微软，冻结 H3、只在早期去噪步注入 Three.js 代理视频）。
- **视觉提示**：Primer 依据"视频扩散模型会通过时空注意力传播首帧外观"，引用 [In-Video Instructions](https://arxiv.org/abs/2511.19401) 和 MME-CoF-Pro。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文是 CC BY 4.0，必要处可引原句，这里仍以位置和要点为主）
> 1. 第 2 页 §1 第 2 段：生成式渲染器要同时满足世界保持和视觉实现，原句 "if code builds the world, can video models just render it?" → 问题与两条标准
> 2. 第 4 页 §3.1 式 (1)：推理时 G 只能访问 (D, p)，W 只用于生成草稿和评测 → 渲染器拿不到引擎内部信号
> 3. 第 5 页 §3.2 "Construction and Validation"：GPT-6-Astra 把真实视频翻译成 MuJoCo / Blender 脚本，记录 (S, T, E, C)，三级准入审核 → 世界怎么建
> 4. 第 5–6 页 §3.3：P0/P1/P2 与 A_N/A_A/A_C 的定义，只改表面外观，48×3×3 = 432 → 因子设计
> 5. 第 6 页 §3.4 式 (3)：AP 需"锚点正确且持续"才得分；CP、SL 的定义 → 评测口径
> 6. 第 8 页表 1 与 §5.2 Takeaway ❶–❸：WP/RF 张力、外观增益"9 out of 10"为负、泄漏最高 64.17% → 主结论，以及"9/10"与表对不上
> 7. 第 9–10 页 §5.3：C05 空间保持 ≤ 18.8、A04 RF 73.1 → 46.2 → 17.3 → 失败模式
> 8. 第 10 页表 2 与 §5.4：Primer 使 MiniMax-H3 总分 63.63 → 65.56、OmniWeaving +2.51，Text PE +0.90 / +1.26 → Primer 效果
> 9. 第 16–22 页附录 B：只评前 5 秒、不做事后对齐；WP = 0.40E + 0.40M + 0.20K；总分 = 0.50R + 0.25G + 0.25C_rob → 指标细节
> 10. 第 23 页附录 C.2：去掉属性提示后 SL "升到" 26.75%，而表 2 完整 Primer 为 27.21% → 消融与表 2 的矛盾

## 摘要（中文）

多模态编码智能体把 4D 世界构建与视觉生成解耦，使视频模型从"世界生成器"转向"生成式渲染器"。这种分工引出一个根本问题：如果代码搭建了世界，视频模型能否只负责渲染？可靠的生成式渲染器取决于两个互补的标准：(i) 世界保持，即保留规定的 4D 运动学和相机路径；(ii) 视觉实现，即把文字指定的目标属性持续地绑定在对象上。为评估这种能力，我们提出 WorldDraft，一个包含 432 个严格配对测试用例的基准，覆盖 48 个可执行 4D 世界族、六类动态挑战。在 3×3 因子设计下，WorldDraft 在相同动态的前提下正交地交叉草稿精细度（从抽象代理到预演）和外观对齐（从中性到冲突）。对 12 个代表性模型的大量评测表明：(I) 世界保持与视觉实现之间存在明显的张力；(II) 更丰富的草稿脚手架能稳定结构，却反而损害外观保真；(III) 冲突的源外观线索会引发严重的源泄漏（最高 64%），暴露出跨模态解耦的脆弱。为缓解这些瓶颈，我们提出 WorldDraft-Primer，一种即插即用的视觉提示策略，在多个冻结的视频渲染器上稳定地同时提升两个目标。WorldDraft 和 WorldDraft-Primer 为连接程序化 4D 仿真与视频生成打下基础，推动有物理依据的生成式渲染。

## 摘要（原文）

论文采用 CC BY 4.0 许可，以下转录 arXiv 摘要原文：

> Multimodal coding agents decouple 4D world construction from visual generation, repurposing video models from world generators toward generative renderers. This division of labor raises a fundamental question: if code builds the world, can video models just render it? A reliable generative renderer hinges on two complementary criteria: (i) world preservation, retaining prescribed 4D kinematics and camera paths; and (ii) visual realization, persistently binding text-specified target attributes over time. To evaluate this capability, we introduce WorldDraft, a benchmark of 432 strictly paired test cases across 48 executable 4D world families spanning six dynamic challenge categories. Under a 3×3 factorial design, WorldDraft orthogonally crosses draft granularity (abstract proxy to previs) and appearance alignment (neutral to conflicting) under identical dynamics. Extensive evaluations across 12 representative models reveal that: (I) world preservation and visual realization remain in stark operational tension; (II) richer draft scaffolding anchors structure but paradoxically impairs appearance fidelity; and (III) conflicting source cues trigger severe source leakage (up to 64%), exposing fragile cross-modal disentanglement. To mitigate these bottlenecks, we propose WorldDraft-Primer, a plug-and-play visual prompting strategy that consistently improves both objectives across frozen video renderers. Together, WorldDraft and WorldDraft-Primer lay a foundation for bridging programmatic 4D simulation with video generation, advancing physically grounded generative rendering.
