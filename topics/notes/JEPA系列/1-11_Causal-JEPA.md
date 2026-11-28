---
id: "1-11"
org: 专题·JEPA系列
short: "Causal-JEPA（C-JEPA）"
title: "Causal-JEPA: Learning World Models through Object-Level Latent Masking"
aliases: ["C-JEPA", "Causal-JEPA", "Object-Level Latent Masking"]
date: 2026-02-11
category: "JEPA 世界模型与规划"
venue: "ICML 2026"
source: "arXiv"
affiliation: "Brown University；GalilAI；New York University；Mila & Université de Montréal"
partners: ["GalilAI"]
authors: ["Heejeong Nam", "Quentin Le Lidec", "Lucas Maes", "Yann LeCun", "Randall Balestriero"]
arxiv: "2602.11389"
pdf: "[[topics/papers/JEPA系列/1-11_2602.11389_Causal-JEPA.pdf]]"
code: "https://github.com/galilai-group/cjepa"
project: ""
huggingface: []
license:
status: 未读
rating:
read_date:
tags: ["paper", "jepa", "world-model", "object-centric", "slot-attention", "masking", "counterfactual-reasoning"]
---

# Causal-JEPA: Learning World Models through Object-Level Latent Masking

> [!info] 论文信息
> arXiv [2602.11389](https://arxiv.org/abs/2602.11389) · v2 2026-05-28（v1 2026-02-11）· ICML 2026（PMLR 306）· 25 页（正文 9 页 + 附录 A–M）
> [代码](https://github.com/galilai-group/cjepa)
> PDF：[[topics/papers/JEPA系列/1-11_2602.11389_Causal-JEPA.pdf|本地 PDF]]（v2）
> 作者：Heejeong Nam（Brown、GalilAI）、Quentin Le Lidec\*（NYU）、Lucas Maes\*（Mila & Université de Montréal）、Yann LeCun（NYU）、Randall Balestriero（Brown、GalilAI）。\* 同等贡献
> 专题：[[topics/JEPA系列#一、JEPA 世界模型与规划|JEPA系列 · 一]]

> [!note] 下面各节是 Claude 根据 PDF 全文（v2，含附录 A–M）写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 动机：只有物体中心表征不够："However, learning on top of object-centric representations alone is not sufficient."（§1，p.1）
> - 开放问题："how interaction structure can be made functionally necessary through the learning objective itself."（§1，p.2）
> - 遮挡防止捷径："Our masking strategy prevents shortcut solutions such as trivial temporal interpolation"（§1，p.2）
> - 身份锚点："preserving only the earliest time step t0 as an identity anchor."（§4.2，p.4）
> - "causal"的含义被限定："the term "causal" refers to temporally directed predictive dependencies from past object states to future states that remain stable under object-level masking, rather than claims of causal identifiability."（Remark 1，p.4）
> - 推理时不遮挡："At inference time, C-JEPA performs forward latent prediction following Eq. 4, with a fully observable history and masking applied only to future tokens."（§4.2，p.5）
> - 遮挡过多有害："excessive masking can remove informative dependencies, indicating an optimal masking regime that depends on the robustness of the underlying object representations"（§5.1，p.6）
> - 只有物体中心表征时规划掉得多："object-centric representations alone do not suffice for accurate long-horizon prediction."（§5.2，p.6）
> - 定理的定位："It should be interpreted as a statement about predictive sufficiency under masking, rather than as a claim of recovering true causal interactions."（§6.2，p.8）
> - 作者承认的局限："Performance depends on the quality of the object-centric encoder, which can limit the performance ceiling."（§7，p.9）

## 一句话总结

在冻结的物体中心编码器（VideoSAUR，基于冻结 DINOv2）输出的 slot 上训练一个 JEPA 式的双向 transformer 预测器，训练时除了遮住未来，还**随机遮住若干个物体在整个历史窗口里的 slot**（只保留最早一帧当身份锚点），逼预测器从其他物体和动作/本体这类辅助变量推断被遮物体的轨迹——相当于对"预测器能看到什么"做物体级干预，让交互推理成为降损失的必要条件。结果：CLEVRER 视频问答里反事实题（按题）比不遮历史的同架构 OC-JEPA 高约 20 个百分点（VideoSAUR 47.68 → 68.81）；Push-T 规划中只用 DINO-WM 1.02% 的潜输入（6×128 vs 196×384）就达到 88.67%（DINO-WM 91.33%），MPC 快 8 倍以上。

## 要解决什么问题

- 世界模型需要关系理解：实体及其交互，而不是像素级的伪相关。物体中心表征（Slot Attention 系）提供了实体抽象，但**光有物体中心表征不够**：没有显式机制时，模型会退化为只学每个物体自己的运动，或利用偶然相关。
- 已有显式学交互的办法：架构上拆分自身动力学与交互（OCVP、SlotFormer 变体）、稀疏注意力（SPARTAN）、固定关系图（C-SWM）、下游专用设计。都没有让"交互"**通过学习目标本身**变成必需。
- patch 级遮挡预测（MAE、VideoMAE、motion-guided masking）优化的是局部 patch 相关，不强制物体级交互推理。
- patch 级世界模型（DINO-WM）token 多（196 个 patch），注意力二次方开销大；物体级 token 少得多。

## 方法

### 设置（§4.1）

- 冻结物体中心编码器 g：S_t = g(X_t) = {s¹_t, …, s^N_t}，s^i ∈ R^d，对 slot 顺序置换等变。
- 历史窗口长度 T_h，预测时域 T_p。辅助变量 U_t = {a_t, p_t}（动作、本体），作为**独立的实体 token** 输入，而不是拼进物体 latent。
- 每步的实体 token 集 Z_t = {S_t, U_t}。

### 物体级遮挡（§4.2，式 3）

- 未来 token 总是遮住；另外按遮挡索引集 M（每次随机遮 0 ~ |M| 个物体）把选中物体**整个历史窗口**的 slot 换成 mask token，只保留最早一帧 t₀ 当身份锚点。
- mask token：z̃^i_τ = φ(z^i_{t₀}) + e_τ，φ 是线性投影，e_τ 是可学嵌入加时间位置编码。因为 slot 置换等变、实体维度不加位置编码，被遮物体必须靠锚点告诉预测器"这是谁"。
- 作者把它解释成对**预测器可观测性**的潜变量层面干预（附录 B.1），产生"反事实式"的预测查询。

### 目标与预测器（式 4–6）

- 预测器：ViT 式双向 masked transformer（6 层、16 头、头维 64、MLP 2048），对历史 + 未来的所有被遮 token 联合推断：Ẑ_T = f(Z̄_T)。
- L_mask = 所有被遮 token 的 L2 误差，可拆成 **L_history**（被遮物体在历史里的补全，压制对自身动力学的依赖）+ **L_future**（未来预测，对齐前向世界建模）。
- 编码器冻结、目标也来自冻结编码器（跟 DINO-WM 一样），所以没有坍塌问题，不需要 SIGReg / stop-gradient 之类。
- **推理**：历史完全可见，只遮未来 → 就是标准的前向潜变量 rollout。
- 为什么用双向 masked 预测器而不是自回归（附录 E.1）：自回归会偏向局部自身动力学。

### 理论视角（§6，附录 L–M）

- 假设：时间有向的预测依赖（同一时间步内无瞬时因果）、共享转移机制（平稳）、slot 对齐物体、有限历史足够。**不假设**因果充分性（允许未观测混杂）、一阶马尔可夫、全局稀疏。
- **定义 1（影响邻域）**：被遮物体状态 z^i_t 的最小充分上下文子集 N_t(i)，使 p(z^i_t | Z^{(−i)}_T) = p(z^i_t | N_t(i))；与马尔可夫毯相关。
- **定理 1**：遮挡历史补全损失的最优预测器是 E[z^i_t | N_t(i)]，任何不用 N_t(i) 信息的预测器达不到最小期望误差。（证明本质是条件期望的 L2 最优性。）
- **推论 1**：反复多样的物体级遮挡会让注意力模式对齐影响邻域，可看成软的局部关系结构；作者联系 ICP / IRM。
- 作者反复强调：这是"遮挡下的预测充分性"，不是恢复真实因果父节点。

### 实现（附录 C–G）

| | CLEVRER（视觉推理） | Push-T（控制） |
|---|---|---|
| 编码器 | VideoSAUR（冻结 DINOv2 ViT-S/14，slot 128 维）；另测 SAVi | VideoSAUR（在物体随机运动的 Push-T 变体上训练） |
| slot 数 | 7（最多 6 个可见物体 + 背景） | 4（3 个物体 + 背景） |
| 历史 / 预测 | 6 帧（frameskip 2）/ 10 帧 | 3 帧（frameskip 5）/ 1 帧 |
| 训练遮挡 | 随机遮 0–4 个物体 | 随机遮 0–2 个物体 |
| 训练 | 30 epoch，Adam，批 256，lr 5e-4，单 GPU，预先抽取的 slot 嵌入 | 同左 |
| 下游 | ALOE（按 SlotFormer 协议）：128 帧输入 rollout 到 160 帧，在模型生成的轨迹上训练问答 | CEM（300 样本 / 30 精英 / 30 轮），H=5，动作块 5，执行完 25 步再重规划，预算 50 步，目标 25 步外；slot 与目标 slot 用匈牙利匹配后算 L2 |

成功判定：位置误差 < 20（工作空间 0–450）且朝向误差 < π/9。CLEVRER 因评估服务器不可用，报的是**验证集**结果（只用训练集训练，不用验证集选模型）。

## 实验与关键数字

### 1. CLEVRER：遮挡物体数的影响（表 1 / 表 A2，%）

| 模型 | |M| | 平均（按题） | 反事实（按选项） | 反事实（按题） |
|---|---|---|---|---|
| OC-JEPA (V) | 0 | 82.79 | 79.53 | 47.68 |
| C-JEPA (V) | 1 | 83.95 | 80.34 | 49.67 |
| C-JEPA (V) | 2 | 84.56 | 80.61 | 50.25 |
| C-JEPA (V) | 3 | 87.61 | 86.49 | 63.60 |
| C-JEPA (V) | 4 | **89.40** | **88.67** | **68.81** |
| OC-JEPA (S) | 0 | 77.28 | 76.69 | 41.10 |
| C-JEPA (S) | 1 | 78.39 | 77.26 | 43.13 |
| C-JEPA (S) | 2 | **83.88** | **85.16** | **60.19** |
| C-JEPA (S) | 3 | 79.02 | 77.78 | 43.77 |
| C-JEPA (S) | 4 | 73.28 | 73.55 | 34.06 |

- V = VideoSAUR，S = SAVi。OC-JEPA 是只遮未来、不遮历史的同架构对照 → 增益来自目标而不是物体中心表征本身。
- 反事实题增益最大（V：+21.13；S：+19.09），摘要里的"约 20%"就是这个。
- SAVi 编码器下遮太多反而变差（|M|=4 低于基线），作者解释为最佳遮挡量取决于编码器 slot 的质量。

### 2. CLEVRER：与其他物体中心世界模型比较（表 2 / 表 A3，SAVi 编码器，%）

| 模型 | 平均（按题） | 反事实（按选项） | 反事实（按题） |
|---|---|---|---|
| SlotFormer | 79.44 | 79.28 | 47.29 |
| SlotFormer 去掉重建损失 | 44.94 | 55.62 | 11.10 |
| OCVP-Seq | 83.11 | 83.21 | 56.06 |
| OCVP-Seq 去掉重建损失 | 80.09 | 77.46 | 43.00 |
| OC-JEPA | 77.28 | 76.69 | 41.10 |
| **C-JEPA**（|M|=2） | **83.88** | **85.16** | **60.19** |

SlotFormer 去掉重建后崩得很厉害（依赖像素监督），OCVP 掉得少一些（架构分解部分弥补）；C-JEPA 无重建也最好。注意平均分 C-JEPA 83.88 只比带重建的 OCVP-Seq 83.11 高 0.77。

### 3. Push-T 规划（表 3，成功率 %，C-JEPA 用 |M|=1）

| token 数 × 维度 | 模型 | 成功率 |
|---|---|---|
| 196 × 384 | DINO-WM | 91.33 |
| 196 × 384 | DINO-WM-Reg.（带 register 的 DINOv2） | 88.00 |
| 6 × 128 | OC-DINO-WM（物体中心编码器 + DINO-WM 的自回归预测器） | 60.67 |
| 6 × 128 | OC-JEPA（+JEPA 式联合预测） | 76.00 |
| 6 × 128 | **C-JEPA**（+物体级遮挡） | **88.67** |

- 6 个 token = 4 个 slot + 动作 + 本体；6×128 / (196×384) = 1.02%。
- 换成物体中心表征但保留 DINO-WM 预测器掉 30 个点；JEPA 式联合预测找回 15.33；物体级遮挡再加 12.67，接近 DINO-WM。
- 速度：单张 L40s，评估 50 条轨迹（三个种子平均）C-JEPA 673 s vs DINO-WM 5,763 s，**快 8 倍以上**。
- 辅助变量作为独立实体 vs 拼进物体 latent（图 3）：独立实体一致更好（只有图）。

### 4. 遮挡粒度的消融（附录 K，表 A4、A5）

CLEVRER（按题平均 / 反事实按题，%）：

| 遮挡方式 | 预算 | 平均 | 反事实 |
|---|---|---|---|
| 物体级 | 4/7 | 89.40 | 68.81 |
| token 级 | 28% | 87.83 | 65.82 |
| token 级 | 42% | 84.43 | 51.08 |
| token 级 | 56% | 89.32 | 68.88 |
| tube 级 | 56% | **89.46** | **69.81** |

Push-T（成功率 %）：

| 预算 | 物体级 | token 级 | tube 级 |
|---|---|---|---|
| 1/4（25%） | **88.67** | 84.67 | 55.33 |
| 2/4（50%） | 82.67 | **84.00** | 5.33 |

作者承认 CLEVRER 上三种方式差别有限（潜空间只有 T×N 个 token），但说 token / tube 级对预算更敏感、提升不稳定；Push-T 上 tube 级严重退化。

### 5. PHYRE 定性分析（§5.3，附录 J）

C-JEPA 的想象 rollout 比 OC-JEPA 更符合物理（早期碰撞会影响后续运动）；预测器的跨 slot 注意力更集中在物理相关的 slot 上。PHYRE 没有真实时间因果图，作者明确说注意力图不能当恢复出的因果图。

## 局限 / 存疑

> 前两条来自论文 §7，其余是 Claude 的推断，请核对。

- **性能受物体中心编码器质量限制**；编码器冻结，作者建议以后在强预训练骨干上联合微调（需要解决坍塌）。
- **影响邻域没有在有显式时间因果图的数据集上直接验证**；PHYRE 只是定性。名字里的"Causal"被作者自己限定为"遮挡下稳定的时间有向预测依赖"，定理 1 本质是条件期望的 L2 最优性，并不能说明学到了因果结构。
- **"物体级遮挡更好"的证据不一致，需核对**：CLEVRER 上 tube 级 56%（89.46 / 69.81）和 token 级 56%（89.32 / 68.88）与物体级 4/7（89.40 / 68.81）持平甚至略高；Push-T 上 50% 预算时 token 级（84.00）高于物体级（82.67），而附录 K 正文却说物体级"在更高遮挡比下保持稳健"。另外表 A5 的标题写的是"CLEVRER performance"，内容却是 Push-T，应是标题复制错误。
- **遮挡量要调，且对编码器敏感**：SAVi 下 |M|=2 最好、|M|=4 低于不遮；VideoSAUR 下随 |M| 单调上升到 4。Push-T 主结果用 |M|=1，2 时就下降。
- **统计**：表 1–3 没有标准差；DINO-WM 基线用单一随机种子 42；Push-T 只评估 50 条轨迹（验证集只有 21 条轨迹）；CLEVRER 报的是验证集而非测试集。
- **Push-T 的物体中心编码器在"物体随机运动"的 Push-T 变体上训练**，数据与 DINO-WM 的 DINOv2 不完全对等；规划时还要用匈牙利匹配对齐 slot，附录 G 还提到成本里加了"prospective embeddings"的同类项，没有解释清楚。
- 只有一个控制任务（Push-T）且 C-JEPA 仍略低于 DINO-WM（88.67 vs 91.33）；效率优势主要来自 token 数少，和遮挡目标本身无关。
- 编码器、目标都冻结，所以这其实是"在固定 slot 表征上学动力学"，和 LeWM / PLDM 那类端到端学表征的 JEPA 世界模型不是同一设定。

## 与其他论文的关系

- **JEPA 谱系**：遮挡预测思想来自 [[topics/notes/JEPA系列/2-01_I-JEPA|I-JEPA]]（图像 patch）、[[topics/notes/JEPA系列/2-02_V-JEPA|V-JEPA]]（时空 tube）、[[topics/notes/JEPA系列/2-03_V-JEPA2|V-JEPA 2]]；本文把遮挡单位从 patch / tube 换成**物体**，作者称是第一个把 JEPA 和物体中心世界建模结合的工作。
- **世界模型基线**：[[topics/notes/JEPA系列/1-02_DINO-WM|DINO-WM]]——同样冻结 DINOv2、同样 Push-T + CEM 规划流程，本文把 patch token 换成 slot token 并加物体级遮挡。代码基于 stable-worldmodel（与 [[topics/notes/JEPA系列/1-05_LeWM|LeWM]] 同一作者组：Maes、Le Lidec、Balestriero、LeCun）。
- **物体中心世界模型**：SlotFormer、OCVP、C-SWM、SPARTAN（跨 slot 注意力作为交互结构的代理）；编码器 VideoSAUR / SAVi。
- **因果 / 不变性**：影响邻域对应马尔可夫毯；推论 1 联系 ICP、IRM；遮挡作为反事实变化与 Xiao et al. 2023 相近。
- 本系列 [[topics/notes/JEPA系列/3-04_IActTherefore|I Act, Therefore]] 也讨论 JEPA 世界模型里的动作 / 因果，可以对照"因果"这个词在两篇里的不同用法。
- 库里其他 JEPA 笔记：[[xsquare/notes/23_EgoJEPA|EgoJEPA]]。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

## 摘要（原文）

> World models require robust relational understanding to support prediction, reasoning, and control. While object-centric representations provide a useful abstraction, they are not sufficient to capture interaction-dependent dynamics. We therefore propose C-JEPA, a simple and flexible object-centric world model that extends masked joint embedding prediction from image patches to object-centric representations. By masking object-level latents and requiring each masked object state to be inferred from the surrounding context, C-JEPA imposes structured partial observability during training, creating counterfactual-like prediction queries that discourage shortcut solutions and make interaction-dependent prediction necessary under the learning objective. Empirically, C-JEPA leads to consistent gains in visual question answering, with an absolute improvement of about 20% in counterfactual reasoning over the same architecture without object-level masking. On agent control tasks, C-JEPA enables substantially more efficient planning by using only 1% of the total latent input features required by patch-based world models, while achieving comparable performance. Finally, we provide a formal analysis demonstrating that object-level masking induces useful inductive bias by controlling observability. Our code is available at https://github.com/galilai-group/cjepa.
