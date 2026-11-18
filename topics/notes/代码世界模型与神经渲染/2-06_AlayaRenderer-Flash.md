---
id: "2-06"
org: 专题·代码世界模型与神经渲染
short: "AlayaRenderer-Flash"
title: "Generative World Renderer at the Speed of Play"
aliases: ["AlayaRenderer-Flash", "Generative World Renderer at the Speed of Play"]
date: 2026-07-21
category: "结构条件的生成式渲染器"
venue: —
affiliation: "Alaya Lab（通讯邮箱为 shanda.com）· 加州大学默塞德分校"
authors: ["Guixu Lin", "Zheng-Hui Huang", "Siqi Yang", "Ming-Hsuan Yang", "Kaipeng Zhang", "Zhixiang Wang"]
arxiv: "2607.18703"
pdf: "[[topics/papers/代码世界模型与神经渲染/2-06_2607.18703_AlayaRenderer-Flash.pdf]]"
code: "—（论文没给代码链接；前作 Generative World Renderer 的仓库是 ShandaAI/AlayaRenderer）"
project: "https://alaya-renderer-flash.alayalab.ai"
license: arXiv 非独占分发许可（arXiv 摘要页）
status: 未读
rating:
read_date:
tags: ["paper", "neural-rendering", "g-buffer", "generative-renderer", "video-diffusion", "autoregressive", "streaming", "few-step-distillation", "real-time", "game"]
---

# Generative World Renderer at the Speed of Play

> [!info] 论文信息
> arXiv [2607.18703](https://arxiv.org/abs/2607.18703) · v1（2026-07-21，PDF 内标注日期 2026-07-22），技术报告
> 单位：Alaya Lab（主，通讯作者 Zhixiang Wang 的邮箱是 shanda.com）、加州大学默塞德分校（Ming-Hsuan Yang）· 一作 Guixu Lin
> PDF：[[topics/papers/代码世界模型与神经渲染/2-06_2607.18703_AlayaRenderer-Flash.pdf|本地 PDF]]（11 页：正文 9 页 + 参考文献 2 页，没有附录）
> 演示页：[alaya-renderer-flash.alayalab.ai](https://alaya-renderer-flash.alayalab.ai) · 论文没给代码链接
> 专题：[[topics/代码世界模型与神经渲染#二、结构条件的生成式渲染器|代码世界模型与神经渲染 · 二、结构条件的生成式渲染器]]

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-18）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。

## 一句话总结

把前作 [Generative World Renderer](https://arxiv.org/abs/2604.02329) 里的离线正向渲染器 **AlayaRenderer**（Wan 2.1 微调，吃引擎导出的 5 通道 G-buffer + 文字风格提示，50 步双向、固定 21 个潜帧窗口）改成能跟着游戏实时跑的流式版本，做了三件事：**块自回归**（每块 4 个潜帧，历史按距离分三档压缩，首个潜帧当全局外观锚点，再给每层自注意力加一个"文字 sink"保住提示词控制）、**四步蒸馏**（CFG 蒸馏 → 32/16/8/4 步渐进蒸馏 → 在自 rollout 上做 Mean Flow 蒸馏 + 小权重 GAN 头）、**蒸馏出的轻量编解码器**（5 次 Wan VAE 编码换成一个共享小编码器，解码换成在游戏域上再蒸馏的 TAEHV）。单张 H200、832×448 下吞吐从 0.56 → 1.53（自回归）→ 6.30（四步）→ **31.54 FPS**，峰值显存 30.1 → 16.2 GB；接进开源赛车游戏 SuperTuxKart，含引擎读回和传输的完整系统稳定 30 FPS，玩的时候可以随时换风格提示。

## 要解决什么问题

- **思路**：与其让视频模型从文字或控制提示里"想象"整个世界（结构、材质、玩法逻辑会随时间漂），不如让物理引擎继续负责仿真，生成模型只替换延迟渲染里最后的**着色**一步。G-buffer（反照率、深度、法线、粗糙度、金属度）正好是现成接口：编码了结构化世界状态，又不规定最终外观。
- **前作的瓶颈**（第 2 页 §1）：AlayaRenderer 在 3A 游戏数据上训练，画质和文字风格控制都好，但是**离线**的：
  1. 50 步去噪占大头；
  2. G-buffer 要过 5 次 Wan VAE 编码、输出要过 Wan VAE 解码，两头也慢；
  3. 双向、固定窗口，没法对游戏引擎吐出的**无限长** G-buffer 流做自回归续写。
- 目标：保留 G-buffer + 文字提示两个接口，速度做到"能边玩边渲"。

## 方法

总览见 [[topics/papers/代码世界模型与神经渲染/2-06_2607.18703_AlayaRenderer-Flash.pdf#page=3|图 2，第 3 页]]：玩家用普通游戏输入控制玩法、用文字提示控制外观；引擎持续更新世界状态、导出同步的 G-buffer；渲染器实时生成风格化画面回显给玩家。

### 世界状态与条件信号（§2.1）

| 项目 | 内容 |
|---|---|
| 世界状态由谁维护 | 游戏引擎（物理、玩法、相机都在引擎里，渲染器不改变世界动力学）；**不涉及代码生成或编码智能体** |
| 条件信号 | 5 个同步 G-buffer：albedo、depth、metallic、normal、roughness（几何和材质，不含光照 / 最终外观） |
| 外观控制 | 文字风格提示（光照、天气、艺术风格等），可在流式过程中随时切换 |
| 骨干 | AlayaRenderer，基于 **Wan 2.1** 潜空间视频扩散模型（文字走交叉注意力） |
| 条件注入 | 每个 G-buffer 通道当一路视频，用同一个 Wan 因果 3D VAE 编码成与帧对齐的潜变量，沿**通道维**拼成 `g_k`，再和加噪 RGB 潜变量拼接后进第一个 3D patch embedding：`h_k = PatchEmbed([x_k, g_k])`。只加宽输入投影，DiT 其余部分不改 |

### 块自回归流式（§2.2）

- 前作：21 个潜帧一个窗口、双向生成。Flash：按块自回归，**每块 4 个潜帧**，已生成的块留作历史。
- **三档历史压缩**：按离当前块的时间距离分档，近的保留全分辨率，远的压得越来越粗（思路来自 FramePack 一类多尺度历史压缩和 Helios）。每档的长度、压缩比论文都没给（见"局限 / 存疑"）。
- **全局外观锚点**：把第一个生成的潜帧插到最高保真那一档的最前面，每一块都能看到流的初始外观。
- 历史以干净潜变量 token 的形式和当前块一起进自注意力；G-buffer 潜变量仍是每块自己的条件。
- **文字 sink**：每层自注意力额外挂一组由风格提示嵌入投影出来的常驻 KV，任意长 rollout 里每块都通过自注意力（外加原来的交叉注意力）持续看到提示词。
- 编解码也做成因果的：VAE 编码器跨块带着时间特征缓存，G-buffer 流被当作一条连续序列编码；解码器的时间状态跨块保留，逐块流式解码与整段一次性解码数值一致。

### 四步蒸馏（§2.3）

直接把 50 步压成 4 步画质掉很多，而最后一阶段对学生的初始化很敏感（直接对 ODE 回归初始化的四步学生做 MFD 会训崩），所以分三阶段：

| 阶段 | 做什么 | 步数 | 说明 |
|---|---|---|---|
| 1 引导蒸馏 | 把老师在目标 CFG 强度下的合成速度场蒸进学生（Meng et al. 2023） | 仍是 50 步 | 之后每步只需一次前向，不再算两遍 CFG |
| 2 渐进减步 | 照 Progressive Distillation 依次训 32 → 16 → 8 → 4 步 | 4 步 | 直接训 4 步不稳定，这一步给最后阶段一个稳的初始化 |
| 3 自 rollout 上的 Mean Flow 蒸馏（MFD）+ GAN | 照 Self Forcing，学生只以自己生成的块为历史；分布精修用 MFD；在中间层特征和最终潜变量预测上挂轻量 GAN 头，权重很小 | 4 步 | 试过 DMD 式对抗分布匹配，优化不稳、有明显颜色伪影，所以换 MFD；GAN 头用来补回激进减步丢掉的高频纹理 |

### 轻量编解码器（§2.4）

- 去噪只剩 4 步后，瓶颈变成两头的 VAE：编码要跑 **5 次** Wan VAE（每个 G-buffer 通道一次），解码是流式 Wan VAE 解码器。
- **小解码器**：TAEHV 架构，用它公开的 Wan 2.1 权重初始化；但这些权重重建游戏画面不够好，于是再从冻结的 Wan VAE 解码器蒸馏（两者吃同一份 DiT 输出的潜变量，像素重建损失 + 小权重 LPIPS）。
- **共享小 G-buffer 编码器**：一次前向直接预测 `g_k`，先蒸馏到对齐冻结 Wan VAE 编码器的潜变量，再和整个渲染器联合微调。

### 部署（§2.5、§3.5）

- 推理链路：小编码器编码 G-buffer 流 → 四步扩散 → 带状态的小解码器出 RGB；所有组件跨块保留时间状态，无限长输入流不用重启。
- SuperTuxKart 适配：先采一份目标域数据（同步 RGB + 同样 5 种 G-buffer）微调，再接进实时引擎。玩家用普通输入开车和转镜头，用预设风格或任意文字换外观，提示词可在线更新、不打断游戏。

## 实验与关键数字

**设置**（第 5 页 §3）：数据是引擎采集的《黑神话：悟空》，1280×720、30 FPS，**1,352 段训练 / 131 段测试**，每帧 RGB + 5 个 G-buffer，采集流程同 Generative World Renderer。测试段每段 150 帧（5 秒），模型输入 **832×448**。所有训练阶段都在 8 张 H200 上；FPS 和峰值显存在单张 H200 上测。

**指标**：S_CLIP-I（OpenCLIP ViT-L/14 图像相似度，衡量内容保持，对光照 / 风格变化不敏感）；tLPIPS_warp（光流对齐相邻帧后的 LPIPS，衡量闪烁）；Boundary MSE / SSIM（相邻评测窗口交界处的一致性，协议照 HorizonRelight）；M_CLIP（对比式 CLIP 边际 = 与本提示相似度 − 与另一段测试提示相似度，衡量提示可控性）；FPS 与峰值显存。

### 逐步拆解（[[topics/papers/代码世界模型与神经渲染/2-06_2607.18703_AlayaRenderer-Flash.pdf#page=6|表 1，第 6 页]]）

| 配置 | 步数 | S_CLIP-I↑ | Boundary MSE↓ | Boundary SSIM↑ | tLPIPS_warp↓ | M_CLIP↑ | FPS↑ | 显存 GB↓ |
|---|---|---|---|---|---|---|---|---|
| AlayaRenderer（原版，双向） | 50 | 0.836 | 0.0500 | 0.308 | **0.124** | 0.039 | 0.56 | 30.1 |
| + 块自回归（AR） | 50 | 0.846 | 0.0433 | 0.358 | 0.197 | 0.030 | 1.53 | 22.6 |
| + 四步蒸馏（AR-distilled） | 4 | 0.843 | 0.0418 | 0.371 | 0.158 | **0.045** | 6.30 | 22.6 |
| + 轻量编解码器（Flash） | 4 | **0.847** | **0.0406** | **0.430** | 0.155 | 0.043 | **31.54** | **16.2** |

- 自回归化：内容相似度和窗口交界一致性变好，但**闪烁明显变差**（tLPIPS 0.124 → 0.197），吞吐只到 1.53 FPS。
- 四步蒸馏：吞吐 ×4.1，显存不变，闪烁回落到 0.158，提示可控性略升。
- 轻量编解码器：吞吐 6.30 → 31.54（×5，说明四步之后两头的 VAE 占了约 80% 的时间），显存 22.6 → 16.2 GB；作者把画质略升归因于小编解码器在游戏域上蒸馏 / 微调过。
- 总加速 0.56 → 31.54 约 **56 倍**。

### 与外部 G-buffer 渲染器比较（[[topics/papers/代码世界模型与神经渲染/2-06_2607.18703_AlayaRenderer-Flash.pdf#page=7|表 2、表 3，第 7 页]]）

外部基线都在作者的训练集上重训（只要实现公开、能复现）。

| 方法 | 窗口 | S_CLIP-I↑ | FVD↓ | tLPIPS_warp↓ | M_CLIP↑ | FPS↑ | 显存 GB↓ |
|---|---|---|---|---|---|---|---|
| RGB↔X（逐帧） | 5s | 0.820 | 1031.3 | 0.305 | 0.027 | 1.30 | 3.3 |
| [FrameDiffuser](https://arxiv.org/abs/2512.16670)（逐帧自回归） | 5s | 0.844 | 650.6 | 0.440 | n/a | 0.31 | 3.5 |
| AlayaRenderer-Flash | 5s | **0.847** | **384.1** | **0.155** | **0.043** | **31.54** | 16.2 |
| DiffusionRenderer（只在正文，第 7 页） | 25 帧独立窗口 ×6 | 0.870 | 335.5 | 0.156 | — | 1.10 | — |

- 能力表（表 2）：只有 Flash 同时满足 G-buffer、自回归、提示切换、少步、无限长度；FrameDiffuser 不支持提示控制，RGB↔X 逐帧没有时序建模。
- **DiffusionRenderer 在离线协议下内容相似度和 FVD 都比 Flash 好**（0.870 vs 0.847，335.5 vs 384.1），闪烁持平（0.156 vs 0.155），但只有 1.10 FPS。作者的说法是双向方法在有利协议下能拿到更好的离线画质，Flash 赢在"质量—效率"权衡。
- 定性（[[topics/papers/代码世界模型与神经渲染/2-06_2607.18703_AlayaRenderer-Flash.pdf#page=8|图 3，第 8 页]]）：雪景整段 5 秒 + 竹林每 5 帧采样；RGB↔X 光照不一致、闪烁，FrameDiffuser 长 rollout 里光照、色调、几何漂移。

### 长 rollout 上切换提示（§3.4，[[topics/papers/代码世界模型与神经渲染/2-06_2607.18703_AlayaRenderer-Flash.pdf#page=9|图 4，第 9 页]]）

- 637 帧一次流式渲完，每 5 块换一次提示，在 8 个提示间循环（赛博朋克、火山、沙暴、极地、蒸汽波、神圣金、深海、红外等）。
- **只有定性图**：作者说每次切换都跟上了，几何、角色动作、相机轨迹保持，没有重影和边界伪影。没有切换时的定量指标（M_CLIP 的"切换评测"定义在第 6 页出现过，但没报数字）。

### 端到端可玩（§3.5，第 8–9 页）

- SuperTuxKart，单张 H200：渲染器本身（G-buffer 编码 + 四步扩散 + RGB 解码）31.54 FPS；算上引擎侧 G-buffer 读回、数据传输和显示同步，整个系统稳定在目标 **30 FPS**。
- 没有报 SuperTuxKart 微调数据量、画质指标，也没有报按键到画面的延迟。

## 局限 / 存疑

- **吞吐不等于延迟**：31.54 FPS 是吞吐。每块 4 个潜帧，按 Wan VAE 时间 4 倍压缩大约对应 13–16 帧画面，生成一块要等这块的 G-buffer 都到齐，所以"按键到看见"至少是一块的量级（粗算约 0.4–0.5 s，这是我按吞吐估的，论文没报，需核对）。和 [[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]] 报的"按键到画面 112 ms"不是同一口径。
- **时间稳定性其实不如原版**：表 1 里原版双向 AlayaRenderer 的 tLPIPS_warp 是 0.124，Flash 是 0.155；摘要说"保留了老师的核心渲染能力"，但闪烁这一项是退步的。窗口交界一致性（Boundary 指标）变好是因为原版本来就是分窗独立生成。
- **Boundary 指标对自回归模型怎么算没说清**：定义是"相邻、独立处理的流式窗口之间"的过渡，Flash 是连续流式生成，评测窗口怎么切、窗口长度多少，论文没写（需核对）。
- **三档历史压缩的细节全缺**：每档保留多少块、压缩比、用什么方式压（下采样 patch？池化？），以及文字 sink 有多少个 KV 槽，都没给。
- **训练 / 测试只在一个游戏上**：1,352 段《黑神话：悟空》训练、131 段同一游戏测试；前作数据还有《赛博朋克 2077》，Flash 没在别的游戏上量化评测。SuperTuxKart 是另外采数据微调的，没有定量结果。
- **评测分辨率**：数据 1280×720，模型跑 832×448；31.54 FPS 是在这个分辨率、单张 H200（不是消费级卡）上测的。
- **表 1 和表 3 的指标不一样**：表 1 没有 FVD，表 3 没有 Boundary 指标；DiffusionRenderer 的结果只在正文里出现，没进表 3，显存也没报。
- **提示可控性的度量较弱**：M_CLIP 只有 0.03–0.045 的量级，各配置之间差别很小；Flash（0.043）还略低于去掉轻量编解码器之前的 AR-distilled（0.045）。
- **骨干说法与专题清单的出入**：这篇明确说 AlayaRenderer"built upon Wan 2.1"；专题清单把前作 Generative World Renderer 的骨干写成"DiffusionRenderer 微调"。两者可能都对（例如沿用 DiffusionRenderer 的做法但换成 Wan 2.1 底座），读 2-05 时需核对。
- **代码和权重**：论文只给演示页，没说是否开源 Flash 的代码或权重（需核对演示页 / ShandaAI 仓库）。

## 与其他论文的关系

- **前作**：[Generative World Renderer](https://arxiv.org/abs/2604.02329)（2-05，同组 Zheng-Hui Huang、Zhixiang Wang、Kaipeng Zhang）——从《赛博朋克 2077》《黑神话：悟空》抓配对 RGB + G-buffer 数据、训出离线的 AlayaRenderer。Flash 是它的实时部署版。
- **同组的"代码世界"系统**：[[topics/notes/代码世界模型与神经渲染/1-04_ProgrammableWorldModel|Programmable World Model]]（1-04，同为 Alaya Lab 的 Zheng-Hui Huang、Guixu Lin）用状态增强的 3D 有向包围盒当中间表示、由智能体写程序维护世界状态。Flash 这一篇本身没有编码智能体，只是"引擎 + 生成式渲染器"中渲染器的那一半。
- **G-buffer 渲染器谱系**（专题第二节）：RGB↔X（逐帧）→ DiffusionRenderer（视频扩散、双向）→ [FrameDiffuser](https://arxiv.org/abs/2512.16670)（2-03，逐帧自回归，约 0.31 FPS，本文表 3 复现出的也是 0.31）→ Flash（块自回归 + 少步）。之后的 [RGBX-Next](https://arxiv.org/abs/2608.13929)（2-07）也走 G-buffer 路线。
- **条件信号越来越粗的一端**：专题脉络里 G-buffer 是最"细"的条件（含材质）。[[topics/notes/代码世界模型与神经渲染/2-09_SolarRenderer|SolarRenderer]] 把本文归为"绑定在某个引擎表示上的渲染器"，并引用本文说明"从头蒸馏一个这种规模的结构条件模型代价大、不稳定"，它的做法是冻结骨干、复用现成四步 LoRA 再做结构引导的分布匹配。
- **实时渲染器的蒸馏路线对照**：
  - [[mirros/notes/01_AgentGarten|AgentGarten]]：同样在自 rollout 上蒸馏 + 加 GAN 补纹理（DMD + 真实视频 GAN + 精确 R1/R2），同样用 TAEHV 小解码器；本文则报告 DMD 在自己设置下不稳、有颜色伪影，改用 Mean Flow 蒸馏。
  - [[topics/notes/代码世界模型与神经渲染/1-12_StreamRender-H3|StreamRender-H3]]：语义图条件、H3 骨干、流式 DMD 两步；[[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]]：低模代理、Causal Forcing++ 1–2 步、单张 RTX 5090 60 FPS。Flash 是这批里最早（2026-07）做到 30 FPS 可玩的，但硬件是 H200。
  - [[topics/notes/代码世界模型与神经渲染/1-01_CodeWorldModel|CWM]] 的流式版每块 5.1 s，[[topics/notes/代码世界模型与神经渲染/1-03_Magpie|Magpie]] 用白盒画面、32 FPS，可以和本文的 31.54 FPS 对照看（分辨率、硬件都不同）。
- **历史压缩与长视频**：三档历史压缩来自 FramePack（Zhang et al. 2026a）和 [Helios](https://arxiv.org/abs/2603.04379) 的多尺度思路；蒸馏用到 [Self Forcing](https://arxiv.org/abs/2506.08009)、Progressive Distillation、[Mean Flow Distillation](https://arxiv.org/abs/2606.11155)。
- **评测**：[[topics/notes/代码世界模型与神经渲染/3-04_WorldDraft|WorldDraft]] 专门评"代码建世界、视频模型只渲染"；本文只在自家游戏数据上评，没有接入这类基准。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文用的是 arXiv 非独占分发许可，这里只记位置和要点，原句请点页码看）
> 1. 第 2 页 §1 第 1 段：延迟渲染的 G-buffer 编码结构化世界状态而不规定外观，引擎管几何物理玩法、生成模型只替换着色 → 思路
> 2. 第 2 页 §1 第 2 段：原版 50 步、两头 VAE 慢、双向固定窗口没法续写无限流 → 三个瓶颈
> 3. 第 2–3 页 §2.1：5 个 G-buffer 各自过 Wan VAE、通道维拼接后进第一个 patch embedding，只加宽输入投影 → 条件注入方式
> 4. 第 3 页 §2.2 第 1–2 段：每块 4 个潜帧、三档历史压缩、首帧当外观锚点、每层自注意力加文字 sink → 流式设计
> 5. 第 4 页 §2.3：引导蒸馏 → 32/16/8/4 步渐进 → 自 rollout 上 MFD + GAN；DMD 不稳且有颜色伪影 → 蒸馏配方
> 6. 第 4–5 页 §2.4：5 次 Wan VAE 编码换共享小编码器，TAEHV 解码器再蒸馏到游戏域 → 轻量编解码器
> 7. 第 5 页 §3 第 1 段：黑神话 1,352 / 131 段、832×448、8×H200 训练 → 实验设置
> 8. 第 6 页表 1 及 §3.1：0.56 → 1.53 → 6.30 → 31.54 FPS，tLPIPS 0.124 → 0.197 → 0.158 → 0.155 → 逐步拆解
> 9. 第 7 页表 3 及正文：DiffusionRenderer 在 25 帧独立窗口协议下 S_CLIP-I 0.870、FVD 335.5、1.10 FPS → 外部比较与 Flash 的短板
> 10. 第 9 页 §3.5 末段：单张 H200 渲染器 31.54 FPS，含读回传输显示的完整系统 30 FPS → 端到端可玩

## 摘要（中文）

生成式世界渲染器 AlayaRenderer 接收物理引擎导出的结构化世界状态并合成 RGB 帧。与从文字或控制提示生成画面的模型不同，AlayaRenderer 保持场景结构，不改变底层的世界动力学，展示了通往交互式世界建模和用户可控游玩的另一条路径。然而原版 AlayaRenderer 计算代价太高，无法实时部署。本技术报告提出 AlayaRenderer-Flash，一个面向实时的生成式正向世界渲染器，把 AlayaRenderer 从 0.56 FPS 提升到 31.54 FPS，达到"可玩的速度"。AlayaRenderer-Flash 把原渲染器改写为少步自回归流式模型，并引入轻量的蒸馏编解码器，用于高效的潜变量编码和帧重建。它保留了教师模型的 G-buffer 和文字提示接口，同时能在任意长度的输入流上连续渲染。我们在 G-buffer 流上从内容保持、时间一致性、跨窗口稳定性、提示可控性和运行效率几方面评测 AlayaRenderer-Flash。结果表明它大幅降低了推理代价，同时保留了教师模型的核心渲染能力。把 AlayaRenderer-Flash 与物理引擎集成，我们构建了一个以 30 FPS 运行、完全可玩的生成式世界。

## 摘要（原文）

见 [arXiv 摘要页](https://arxiv.org/abs/2607.18703)。论文用的是 arXiv 非独占分发许可，这里不转录原文。
