---
id: "01"
org: KU Leuven
short: "SGT"
title: "Semantic Consistency of Vision Tokens: A Vision-Centric Perspective on Multimodal Large Language Models"
aliases: ["SGT", "Semantically-Guided Training", "SCT", "SIT", "semantic inconsistency"]
date: 2026-11-11
category: "多模态大模型"
source: "KU Leuven（Tinne Tuytelaars 组）"
partners: []
authors: ["Nikola Đukić", "Tim Lebailly", "Tinne Tuytelaars"]
arxiv: "2611.15448"
pdf: "[[kuleuven/papers/01_2611.15448_SGT.pdf]]"
code: "https://github.com/djukicn/sgt"
project: ""
huggingface: []
license: "CC BY 4.0"
status: 未读
rating:
read_date:
tags: ["paper", "kuleuven", "mllm", "vision-encoder", "clip", "dinov2", "representation-learning"]
---

# Semantic Consistency of Vision Tokens: A Vision-Centric Perspective on Multimodal Large Language Models

> [!info] 论文信息
> arXiv [2611.15448](https://arxiv.org/abs/2611.15448) · v1（2026-11-11，cs.CV）· [HTML 版](https://arxiv.org/html/2611.15448v1)
> KU Leuven：Nikola Đukić、Tim Lebailly、Tinne Tuytelaars
> PDF：[[kuleuven/papers/01_2611.15448_SGT.pdf|本地 PDF]]（21 页：正文 10 页 + 参考文献 + NeurIPS checklist，看格式是 NeurIPS 投稿，论文没写是否已录用）
> [代码](https://github.com/djukicn/sgt) · 许可 CC BY 4.0

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-28）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。

## 一句话总结

CLIP/SigLIP 这类语言对齐编码器里，有一部分 patch token 的"相似度模式"和 DINOv2 差得很远（作者叫它**语义不一致 token，SIT**），它们装的是全局信息而不是本位置的物体信息。作者先用"删 token"实验证明 MLLM 在视觉为主的任务上主要靠**语义一致 token（SCT）**；再提出 **SGT（Semantically-Guided Training）**：在 LLaVA 1.5 指令微调阶段解冻视觉编码器，在语言建模损失之外加一项"让 CLIP 的 token 相似度矩阵贴近 DINOv2"的损失。7B 上视觉类平均从 63.34 升到 66.48、文本类基本不掉（69.10 → 68.95），总平均 67.58，超过 DINOv2、CLIP+DINOv2 拼接、TIPSv2、Locality Alignment。但消融（表 4）显示：**只解冻编码器、不加语义引导（α=0）就已经拿到总平均 67.39**，SGT 这一项本身只多 0.19。

## 要解决什么问题

- MLLM 几乎都用 CLIP / SigLIP 当视觉编码器，因为它们和语言对齐；但它们是用"整图 ↔ 整句"对齐训练的，patch 级表示质量差，做分割、检测这类密集任务不如 DINOv2 这类自监督（SSL）模型。
- 现在 MLLM 的很多任务其实是密集视觉任务：数数（TallyQA）、指代定位（RefCOCO）、空间关系（VSR）、深度顺序和相对距离（CV-Bench）。
- 直觉上把 DINOv2 的 patch 特征接进来应该有用，但已有工作反复失败：
  - 直接换成 DINOv2：文本类任务大幅下降（Prismatic VLMs / Karamcheti 2024；Cambrian / Tong 2024a）；
  - CLIP 和 DINOv2 拼接、相加、交错：没有提升（Eyes Wide Shut / Tong 2024b）；多层融合贡献也有限；
  - 多种编码器融合里，加 DINOv2 通常不涨（Shi 2024）。
- 作者的两个问题：(1) MLLM 到底需不需要 DINOv2 那种"语义一致"的 patch 表示？(2) 需要的话，怎么在保留语言对齐的前提下得到它？

## 方法

### 1. 语义不一致度 SIC（§3.2，式 1）

- 同一张图分别过 CLIP（得到 token x^v）和 DINOv2（得到 x^s），同一位置一一对应。
- 对第 i 个 token：先算它和所有 token 的余弦相似度（CLIP 一行、DINOv2 一行），再对两行逐项求差的平方、取平均：
  - SIC(x_i^v) = (1/n) Σ_j ( s(x_i^v, x_j^v) − s(x_i^s, x_j^s) )²
- 本质上是**两个 Gram（相似度）矩阵逐行的 MSE**，只比较"谁和谁像"，不要求特征本身对齐，所以 CLIP 可以保留自己的特征空间。
- SIC 高 = **SIT**：在 PCA 图上是散落在各个物体上的"异色" patch，和同物体的邻居不像，反而和其他 SIT 像，装的是全局信息。作者解释成：整图-字幕对齐目标不惩罚把全局信息存进某些 patch。
- SIC 低 = **SCT**：相似度模式以物体为中心，和 DINOv2 一致。

### 2. 删 token 探针（§3.3，图 2）

- 按 SIC 排序，从 MLLM 输入里删掉前 k 个（升序删 = 删 SCT，降序删 = 删 SIT），k 每步约占总 token 的 1%。
- 模型：LLaVA 1.5 7B / 13B（CLIP，336×336，576 个 token 全部送进 LLM，Vicuna）和 Gemma 3 4B / 12B / 27B（SigLIP，896×896 后 4×4 max pool 成 256 个 token）。
- 基准：CV-Bench（数数、空间关系、深度顺序、相对距离）。
- 结论：两个家族、所有尺寸都一样，**删 SCT 掉分明显更多，删 SIT 影响小** → MLLM 做视觉判断主要靠 SCT，SIT 基本是浪费的。
- 论文正文没给图 2 的具体数值，只给了趋势。

### 3. 和 register / sink token 的关系（§3.3，图 3）

- Darcet 等（2024）发现 ViT 里有少量（通常 ≤ 5 个）高范数 token 存全局信息（register）；Luo 等（2026）发现它们在 MLLM 里变成吸走大量注意力的 sink token。
- 作者在 5000 张图上统计：大多数 sink token 的确 SIC 高，但同一张图里 sink token 的 SIC 排名分得很开，**并不总是最不一致的那几个**；而 SIT 的数量远多于几个。所以"只去掉 sink token"不够，要处理的是整批 SIT。

### 4. SGT 训练目标（§4.1，式 2）

- 损失 = 语言建模（下一词预测，作用于 LLM、连接器、视觉编码器全部参数） + α × Σ_j SIC(x_j^v)（只作用于视觉编码器）。
- 分工：语言建模项保证视觉 token 仍然是 LLM 看得懂、对答题有用的；语义引导项把 SIT 拉成 SCT。
- 和相关做法的区别（§2）：
  - Gong 等（2025）也是让 CLIP 的特征核去匹配 DINOv2，但额外加正则把特征拉回原始 CLIP（为了保住和 CLIP 文本编码器的对齐），限制了 patch 质量，接进 MLLM 后不如 Locality Alignment；
  - SGT 不加这种约束，而是用 LLM 的损失来保住"语言对齐"——作者认为这是关键：编码器应当**在 MLLM 里面**和 LLM 一起训，而不是单独预训练好再接上。
  - 形式上和 DINOv3 的 gram anchoring 很像（那是 teacher-student 之间的 Gram 矩阵约束）。
- 需核对：式 2 写的是对似然的连乘 ∏ f(x_i^t | …) 取最小，按字面是在最小化似然；应当是负对数似然，应该是笔误。

### 5. 实现细节（§4.2）

- 框架：LLaVA 1.5，两阶段：
  - 预训练阶段只训 2 层 MLP 投影器，LLM 和编码器都冻结，不加语义引导；
  - 指令微调阶段用 SGT 目标，编码器从 LLaVA 原本的 CLIP ViT-L/14-336 开始，**α = 5**；SigLIP 版本用 SO400M/14-384，**α = 1**。
- 语义引导的参照模型：DINOv2 ViT-L/14 with registers（冻结）。
- 算力：单节点 4 张 AMD MI250x、512 GB 内存（LUMI 超算）；7B 一次约 25 小时，13B 约 42 小时；复现全部实验共 2536 GPU 小时。
- 表 4 的三个设置各训了 3 次估标准误，其余模型只训一次。

### 6. 评测（§4.2）

| 类别 | 基准 | 指标 |
|---|---|---|
| 文本类（TC） | TextVQA（OCR）、SciQA、GQA、POPE（幻觉） | 准确率；POPE 用三个子集平均 F1 |
| 视觉类（VC） | TallyQA（数数）、RefCOCO / OCID-Ref（指代定位）、VSR（空间关系）、CV-Bench | 准确率；RefCOCO 用 IoU 0.5 的精度（RefCOCO / + / g 三个验证集平均），OCID-Ref 用 IoU 0.25 |

## 实验与关键数字

### 主结果（表 1，LLaVA 1.5 7B，不同视觉编码器）

| 视觉编码器 | TextVQA | SciQA | GQA | POPE | TallyQA | RefCOCO | OCID-Ref | VSR | CV-Bench | TC | VC | Total |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLIP（原版 LLaVA） | 58.48 | 69.41 | 62.64 | 85.89 | 61.72 | 77.54 | 52.04 | 70.21 | 55.21 | 69.10 | 63.34 | 65.90 |
| DINOv2 | 46.54 | 64.95 | 63.44 | 85.95 | 59.46 | 80.45 | 55.65 | 65.54 | 55.42 | 65.22 | 63.30 | 64.16 |
| CLIP + DINOv2（拼接） | 57.93 | 67.67 | 63.24 | **86.92** | 61.43 | 79.43 | 56.84 | 68.66 | 54.60 | 68.94 | 64.19 | 66.30 |
| TIPSv2 | 52.99 | 65.89 | 63.05 | 86.00 | 60.80 | 81.63 | 55.19 | 68.08 | **57.91** | 66.98 | 64.72 | 65.73 |
| Locality Alignment | **59.02** | 69.31 | 63.00 | 86.45 | 61.25 | 78.25 | 53.03 | 68.08 | 55.56 | **69.45** | 63.23 | 65.99 |
| **SGT** | 57.75 | 68.06 | **63.43** | 86.57 | **62.81** | **83.17** | **57.34** | **71.23** | 57.85 | 68.95 | **66.48** | **67.58** |

（加粗按表中数字标的；GQA 最高其实是 DINOv2 的 63.44，SGT 63.43 差 0.01，论文原文说 SGT 在 GQA 上最好，需核对。SciQA 最高是 CLIP 69.41。）

- 相对原版 LLaVA：VC **+3.14**，TC −0.15，Total **+1.68**。涨得最多的是 RefCOCO（+5.63）和 OCID-Ref（+5.30），也就是指代定位。
- CV-Bench 上 TIPSv2（57.91）略高于 SGT（57.85）。
- DINOv2 视觉类和 CLIP 持平（63.30 vs 63.34），但 TextVQA 掉 12 个点 —— 缺语言对齐的代价主要在 OCR。
- 简单拼接 CLIP+DINOv2 是第二强的总分（66.30），作者自己也说"出乎意料"。

### 推广到其他设置（表 2，每对都是基线 LLaVA vs SGT）

| 设置 | 基线 TC / VC / Total | SGT TC / VC / Total | VC 提升 | Total 提升 |
|---|---|---|---|---|
| 13B LLM（Vicuna-13B） | 70.52 / 64.12 / 66.96 | 70.18 / 67.17 / 68.51 | +3.05 | +1.55 |
| SigLIP 起点（SO400M） | 70.28 / 64.09 / 66.84 | 70.03 / 68.06 / 68.94 | +3.97 | +2.10 |
| Qwen2.5-3B LLM | 68.98 / 59.83 / 63.90 | 68.54 / 63.26 / 65.60 | +3.43 | +1.70 |

- 三种设置都是视觉类涨 3–4 个点、文本类小幅下降（0.25–0.44）。
- 单项里涨得最猛的：Qwen2.5-3B 的 RefCOCO 60.97 → 69.99（+9.0）；SigLIP 的 RefCOCO +6.4、OCID-Ref +6.2。
- 13B SGT（68.51）也超过 7B SGT（67.58）。

### α 的选择（表 3）

| 编码器 | α=1 Total | α=5 Total | α=10 Total |
|---|---|---|---|
| CLIP | 67.41 | **67.58** | 67.00 |
| SigLIP | **68.94** | 67.53 | 67.04 |

- CLIP 上 1 和 5 差别不大，10 开始文本类和视觉类一起掉；SigLIP 更敏感，所以取 1。
- 注意：α 是在同一批测试基准上选的，没有单独的验证集。

### 最关键的消融：解冻编码器但不加语义引导（表 4，3 次训练的均值 ± 标准误）

| 设置 | TC | VC | Total | 平均 SIC（5000 张图） |
|---|---|---|---|---|
| LLaVA（编码器冻结） | 69.10 ± 0.01 | 63.34 ± 0.10 | 65.90 ± 0.05 | 0.075 |
| α = 0（解冻，不加语义引导） | **69.55** ± 0.12 | 65.66 ± 0.04 | 67.39 ± 0.08 | 0.052 |
| SGT（α = 5） | 68.95 ± 0.09 | **66.48** ± 0.08 | **67.58** ± 0.04 | **0.015** |

- 只是解冻编码器，文本类和视觉类**都涨**，而且 SIC 自己就从 0.075 降到 0.052 —— 语义一致性在联合训练里会自然出现。
- 再加语义引导：SIC 降到 0.015，VC 再 +0.82，但 TC −0.60，Total 只多 **0.19**。
- 换算一下：相对原版 LLaVA 的总分提升 1.68 里，约 1.49（≈ 89%）来自"解冻编码器"，语义引导只占 0.19；视觉类提升 3.14 里，解冻贡献 2.32，语义引导 0.82。RefCOCO 上 α=0 已经是 83.07，SGT 83.17。
- 作者的解读：两项目标之间有取舍，且"语义一致性不是中间模型变好的唯一原因"。

### 语义引导到底改了什么（§4.3.2–4.3.3，图 4、图 5）

- SGT 后 5000 张图上的 SIC 分布整体左移，原来的高 SIC 长尾消失。
- 单张图逐 token 看：几乎每个 token 的 SIC 都下降，**原本 SIC 越高的降得越多**；少数本来就比较低的几乎不变 —— 作者猜这些 token 同时存了全局和局部信息，LLM 仍然需要。
- PCA 可视化：SGT 特征比 CLIP 平滑得多，接近 DINOv2；放在同一空间比较时，SCT 基本保持原来的 CLIP 表示，被大改的是 SIT。

## 局限 / 存疑

- **对比不完全公平**：表 1 的 SGT 解冻了编码器，而原版 LLaVA 的 CLIP 是冻结的；DINOv2、拼接、TIPSv2、Locality Alignment 这些对手的编码器在指令微调时是否解冻，论文没写（需核对）。表 4 的 α=0（67.39）在表 1 里不出现，但它已经高于表 1 所有对手（最高 66.30）。所以"联合训练优于单独训练编码器"这条结论更多是"解冻"带来的，语义引导项的独立贡献只有 0.19 个总分点（VC +0.82）。
- **α 在测试集上选**：没有独立验证集，和其他方法的差距里可能有一点选择偏差。
- **除表 4 外都是单次训练**：作者说表 4 的标准误（0.01–0.5）可以代表其他模型；但 VSR 的标准误到 0.49，单项上 1 个点以内的差别不一定稳定。
- **局限只提了算力**：§5 自己说每一步编码器更新都要过一遍 LLM 的前后向，微调可以接受，但没法用在大规模预训练新编码器上。
- **需要额外一个冻结的 DINOv2 前向**，训练时多一个 ViT-L；推理时不需要。
- **probing 的细节缺失**：Gemma 3 的 token 是 4×4 max pool 后的 256 个，SIC 是在池化前还是池化后、DINOv2 用什么分辨率算对应 token，正文没说（需核对，可能在代码里）。
- **规模偏小**：只在 LLaVA 1.5 框架（336/384 分辨率、单图、无动态切图）、3B–13B 上验证；没有试在 Qwen2.5-VL 那种自带视觉编码器、高分辨率动态切图的现代 MLLM 上加 SGT。
- **"drastically outperforms"说法偏强**：VC 比第二名 TIPSv2 高 1.76，Total 比第二名拼接高 1.28；CV-Bench 上反而 TIPSv2 略高。
- **文本类会小幅下降**：四个设置里 TC 都低于基线 0.15–0.44，作者表述为"保持强劲"。TextVQA 每次都掉（58.48 → 57.75 等）。
- 小问题：式 2 用 ∏ 似然取最小（应为负对数似然）；正文说 SGT 在 GQA 最好，但表 1 里 DINOv2 的 63.44 比 SGT 的 63.43 高 0.01。

## 与其他论文的关系

- **直接对手**：
  - Locality Alignment（Covert 等 2025）：单独微调 CLIP 减少全局上下文干扰，再接进 MLLM；
  - TIPSv2（Cao 等 CVPR 2026，Google）：从头联合训练 iBOT/DINOv2 损失和 CLIP 损失；作者说这是第一次把它当 MLLM 编码器用；
  - Gong 等（2025）：让 CLIP 的特征核匹配 DINOv2 + 回拉正则。
- **问题来源**：Prismatic VLMs（Karamcheti 2024）、Cambrian-1 / CV-Bench（Tong 2024a）、Eyes Wide Shut（Tong 2024b）都发现 DINOv2 直接用或简单融合不涨。
- **token 现象**：ViT register（Darcet 2024）、MLLM 里的 sink token（Luo 2026 "To sink or not to sink"）；同期 Fan 等（2026）发现约 30% 视觉 token 对应到 LLM 词表里的碎片子词、可以直接删掉 —— 本文认为根源是语义不一致，主张"修好"而不是"删掉"。
- **形式上的近亲**：DINOv3 的 gram anchoring（同样是 Gram 矩阵约束）；CLIP-DINOiser（免训练，用 DINO 相似度重排 CLIP 特征）；SimZSS（同组，冻结 DINOv2 只训文本编码器做开放词汇分割）。
- **和本库的联系**：
  - VLA 里常见"SigLIP + DINOv2 拼接"的视觉骨干（OpenVLA 沿用 Prismatic 的设计）。本文表 1 显示拼接在 MLLM 里已经是很强的基线（第二名），而 SGT 用单个编码器就超过它，少一半视觉 token 开销 —— 对机器人里需要定位、空间关系的 VLA 可能有参考价值，但本文没做这类实验。
  - [[topics/语义3DGS与具身导航|语义3DGS与具身导航]] 专题里大量工作把 CLIP / DINOv2 的 patch 特征蒸到 3D 高斯里；本文的 SIC 可以当一个指标，衡量所用 2D 特征的 patch 质量。

## 我的想法

<!-- 留给你写。几个可以想的问题（Claude 提的）：
- 表 4 里 α=0 已经拿走了约 89% 的总分提升：如果你要复现，先只解冻编码器看看，再决定是否值得多跑一个 DINOv2。
- SIC 只约束"谁和谁像"、不约束特征值本身，所以不破坏语言对齐 —— 这个思路能不能用在 VLA 的视觉编码器微调上（比如用 DINOv2 或深度模型的 Gram 矩阵当正则，防止动作微调把空间信息洗掉）？
- 删 SIT 掉分少：能不能直接按 SIC 做视觉 token 剪枝，给 VLA / VLN 推理加速？
- 在高分辨率动态切图的现代 MLLM（Qwen2.5-VL 系列）上还成立吗？
-->

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置，页码按本地 PDF）
> 1. 第 1 页摘要：定义 SCT / SIT，删 token 实验，SGT 结合语言建模和语义引导 → 一句话总结
> 2. 第 2 页 §1 第 2 段：直接换 DINOv2 或简单融合都没有带来更好的 MLLM → 要解决的问题
> 3. 第 4 页 §3.2 式 1：SIC = 两组余弦相似度逐项差的平方的平均，以 DINOv2 为参照 → SIC 定义
> 4. 第 5 页 §3.3 与图 2：LLaVA 1.5 7B/13B、Gemma 3 4B/12B/27B 在 CV-Bench 上删 SCT 掉分更多 → 探针结论
> 5. 第 5–6 页 §3.3 末段与图 3：sink token 多数 SIC 高，但不总是最不一致的，SIT 数量远多于几个 → 与 register 的关系
> 6. 第 6–7 页 §4.1 式 2：语言建模作用于全部参数，语义引导只作用于编码器 → SGT 目标（含 ∏ 笔误）
> 7. 第 7 页 §4.2：两阶段训练、α=5（CLIP）/ α=1（SigLIP）、DINOv2 ViT-L/14 reg、4×MI250x、2536 GPU 小时 → 实现细节
> 8. 第 8 页表 1：六种编码器九个基准和 TC / VC / Total → 主结果
> 9. 第 8–9 页表 2、表 3：13B / SigLIP / Qwen2.5-3B 推广；α 扫描 → 推广与超参
> 10. 第 9 页表 4 与 §4.3.1 末段：α=0 时 TC、VC 都涨且 SIC 降到 0.052，加语义引导后 VC 再涨、TC 下降 → 关键消融；第 10 页 §5：算力局限

## 摘要（中文）

在计算机视觉领域，视觉-语言编码器和自监督编码器是两种不同的范式，分别以全局语言对齐和高质量的纯视觉 patch 表示为特点。多模态大语言模型（MLLM）通常因为语言对齐而选用前者，尽管近来出现了越来越多类似传统密集视觉任务的视觉为主任务，它们很可能受益于后者的高质量 patch 表示。这就引出一个问题：自监督模型能否帮助 MLLM 完成视觉为主的任务？为此，我们为语言对齐编码器产生的 patch token 定义了语义（不）一致性的概念，并区分出两类 token：语义一致 token（SCT）和语义不一致 token（SIT）。通过在现代 MLLM 的输入中系统地删除 SCT 或 SIT 进行探测，我们发现模型更依赖 SCT——删除 SCT 带来更大的性能下降，说明 MLLM 受益于视觉 token 的语义一致性。据此，我们对 MLLM 训练目标做了一个简单有效的扩展：把传统的语言建模与"最小化视觉 token 语义不一致性"的语义引导结合起来。这一策略称为语义引导训练（SGT），两项损失共同推动视觉编码器产生语义一致的 token，同时保留语言对齐。大量评测表明，SGT 在视觉为主的基准上大幅超过所有基线和使用专门视觉编码器的 MLLM，同时在文本为主的基准上保持较高分数，在全部任务的平均上达到当前最佳。我们的结果说明，应当在 MLLM 的框架内、而非脱离 MLLM 去兼顾语言对齐和语义一致性，这为设计更好的 MLLM 视觉编码器铺平了道路。

## 摘要（原文）

> 原文 © Nikola Đukić, Tim Lebailly, Tinne Tuytelaars，CC BY 4.0（arXiv:2611.15448）。

> In the computer vision world, vision-language and self-supervised encoders represent two unique paradigms characterized by global language alignment and high-quality vision-only patch representations, respectively. Multimodal large language models (MLLMs) often use the former because of language alignment, despite the recent rise in vision-centric tasks resembling traditional dense vision tasks that would likely benefit from the high-quality patch representations of the latter. This raises the question whether self-supervised models could aid MLLMs in vision-centric tasks. To investigate this, we define the concept of semantic (in)consistency of patch tokens produced by language-aligned encoders and identify two sets of tokens, semantically consistent (SCTs) and semantically inconsistent (SITs). Through systematic probing via the removal of SCTs or SITs from the input of modern MLLMs, we show higher reliance on SCTs than SITs, as removal of the former induces larger performance drops. This demonstrates that MLLMs benefit from semantic consistency of vision tokens. With this in mind, we devise a simple yet effective extension of the MLLM training objective that combines traditional language modeling with semantic guidance via minimization of semantic inconsistency of vision tokens. This strategy, named Semantically-Guided Training (SGT), combines the signals of both loss terms to push the vision encoder towards providing semantically consistent tokens, while preserving language alignment. Through extensive evaluation, we show that SGT drastically outperforms all baselines and MLLMs with specialized vision encoders on vision-centric benchmarks while keeping strong scores on text-centric benchmarks, thus setting state of the art when averaged across all tasks. Our results highlight the importance of combining language alignment and semantic consistency through the lens of MLLMs rather than independently from them and pave the way towards the design of better MLLM vision encoders.
