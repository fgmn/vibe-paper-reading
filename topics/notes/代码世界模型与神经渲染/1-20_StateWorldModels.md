---
id: "1-20"
org: 专题·代码世界模型与神经渲染
short: "State World Models"
title: "State World Models: Execute the Rules, Generate the Pixels"
aliases: ["State World Models", "Stateful Harness", "WorldState-Bench", "状态世界模型"]
date: 2026-10-19
category: "代码世界 + 视频渲染器（完整系统）"
venue: —
affiliation: "清华大学自动化系 · GigaAI（极佳科技）"
authors: ["Chan Yan Ki", "Yanran Zhang", "Wenzhao Zheng", "Xiaofeng Wang", "Zheng Zhu", "Lei Chen", "Jie Zhou", "Jiwen Lu"]
arxiv: "2610.26811"
pdf: "[[topics/papers/代码世界模型与神经渲染/1-20_2610.26811_StateWorldModels.pdf]]"
code: "https://github.com/Zhangyr2022/StateWorldModel"
project: "https://ivg-yanranzhang.github.io/StateWorldModel/"
license: CC BY 4.0（arXiv 摘要页）
status: 未读
rating:
read_date:
tags: ["paper", "world-model", "code-world", "explicit-state", "hidden-state", "frozen-renderer", "minimax-h3", "coding-agent", "counterfactual", "benchmark"]
---

# State World Models: Execute the Rules, Generate the Pixels

> [!info] 论文信息
> arXiv [2610.26811](https://arxiv.org/abs/2610.26811) · 本地 PDF 是 v1（2026-10-19，目前也只有 v1）· 版式写 "Preprint"，没写投稿会议
> 单位：清华大学自动化系（7 位）、GigaAI（Zheng Zhu）· 共同一作：Chan Yan Ki、Yanran Zhang · 项目负责人：Wenzhao Zheng · 论文没标通讯作者
> PDF：[[topics/papers/代码世界模型与神经渲染/1-20_2610.26811_StateWorldModels.pdf|本地 PDF]]（36 页：正文 9 页 + AI 使用声明 + 参考文献到第 15 页 + 附录 A–I 第 16–36 页）
> 代码：[Zhangyr2022/StateWorldModel](https://github.com/Zhangyr2022/StateWorldModel) · 项目页：[ivg-yanranzhang.github.io/StateWorldModel](https://ivg-yanranzhang.github.io/StateWorldModel/) · 数据：[Hugging Face](https://huggingface.co/datasets/Louis0411/StateWorldModel) / [ModelScope](https://modelscope.cn/datasets/Louis0411/StateWorldModel/)（链接取自 PDF 首页；正文又说案例程序等"发表时发布"，仓库里实际放了什么未核对）
> 专题：[[topics/代码世界模型与神经渲染#一、代码世界 + 视频渲染器（完整系统）|代码世界模型与神经渲染 · 一、代码世界 + 视频渲染器（完整系统）]]（在该节末尾"补充"表里）

> [!note] 下面各节是 Claude 根据论文全文写的初稿（2026-11-18）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身没说清或前后对不上的，没有替你选择。
> 本地环境没有 poppler，PDF 是用 macOS PDFKit 抽成文字读完正文和附录的；表 1 另渲染成 PNG 对照过。**其余图（图 1–6、9–17）只看了图注和抽出来的图内文字，没看图像本身**。

## 一句话总结

不训练任何视频模型，只在**冻结的 MiniMax-H3** 外面套一层"有状态的外壳"（Stateful Harness）：编码智能体（GLM-5.3）先把世界描述写成一份**类型化的小语言游戏定义**（状态模式、动作、带 guard 的规则、事件、目标、视觉语义）；每一回合，运行时先按规则**结算**动作（例如"没有钥匙 → 宝箱打不开"），把结果填进固定槽位的 **VisualScript** 记录、确定性编译成文字指令，再配上一段**粘土模型**（无纹理的 3D 框场景）渲出的布局/相机预览视频和上一段的末帧锚点，交给 H3 生成约 5 秒的片段；最后由 VLM 看生成片段、提出与规则相容的状态更新写回账本。为了检验"画面看不出来的隐藏状态"能否决定结果，作者建了 **WorldState-Bench**：50 对"首帧和动作完全相同、只有隐藏值不同"的反事实双胞胎。只给规则时，11 个视频模型 / 世界模型里最好的 PairFollow 只有 32%；同一个冻结的 H3 明确写出结局后到 64%，完整外壳到 **92%**（PairStrict 90%，而 H3 自己 Rule+end 下只有 4%）。

## 要解决什么问题

- 交互式视频世界模型大多只解决"能走动、能看"：导航控制让场景可探索，但**动作的后果**由谁决定、是否符合规则、能否跨回合持续，都没有保证。
- 关键难点是**隐藏状态**：同一张画面、同一个动作"打开宝箱"，玩家有钥匙就该打开，没有就该打不开（[[topics/papers/代码世界模型与神经渲染/1-20_2610.26811_StateWorldModels.pdf#page=4|图 2，第 4 页]]）。只看像素的生成器会对两种情况给出同样的结局（作者叫 "twin collapse"）。
- 已有的显式状态系统（PWM、StatePlay、WorldMind 等）只评测选定的机制，没有回答"一个冻结的视频模型能不能按**新写的、涉及隐藏状态的规则**渲出规定的结局"。作者认为核心是让**状态转移有权威**，并让渲染忠实地表现它的后果。
- 现有基准（WBench、WorldMark、PlayWorld 等）测画质、提示遵循、导航、一致性，不直接测"只改隐藏值时结局是否随之改变"；基于游戏引擎的基准又需要现成的游戏。

## 方法

总览见 [[topics/papers/代码世界模型与神经渲染/1-20_2610.26811_StateWorldModels.pdf#page=5|图 3（第 5 页）]]。

### 世界状态怎么表示（§3）

状态 $s_t = (z_t, u_t)$，两部分：

| 部分 | 内容 | 形式 |
|---|---|---|
| 语义状态 $z_t$（账本，ledger） | 资源、实体属性、进度计数、态度、终止状态——可以是当前画面看不到的 | 可序列化的类型化字段记录 |
| 空间状态 $u_t$（粘土模型，clay model） | 可编辑的实体布局、尺度、相机路径 | 带地面的无纹理 3D 场景 + 带标签的长方体 |
| 规则 $\mathcal{R}$ | 每条规则 = guard（读状态和动作）+ effect（账本更新、空间编辑脚本、事件） | 一个回合内固定不变 |

闭环写成 $s_{t+1} = H_{\mathcal{R}}(s_t, a_t, o_{t+1})$：下一状态既包含动作按规则产生的后果，也包含从生成片段里观察到的、与规则相容的更新。

### 谁写代码（§3.1、附录 F.2）

- **编码智能体**根据世界描述写出可执行的游戏定义，用一种"小的类型化语言"；智能体验证后冻结定义，互动开始后规则不再改。附录 F.2 说所有报告的实验里，游戏定义都由**基于 GLM-5.3 的编码智能体**写。
- 新世界 = 新的游戏定义 + 同一个运行时 + 同一个冻结视频模型，"不需要引擎、不需要微调"。作者称这是"最小组合"。
- 交互时，**意图智能体**把用户自然语言映射成结构化动作；部署中意图/提议内核和 LLM 玩家是同一个常驻的 Qwen3.8-27B-VL 服务（附录 F.2）。
- 可选的**神经内核** $\rho$ 可以为已结算事件提议对白或旁白，但要经过模式校验、数值钳制、有限次重试、回退到规则默认值四道门，保证只能在规则允许的集合里取值（式 3）。

### 一回合怎么跑（§3.2、算法 1、表 10）

1. **规则结算**：在视频生成**之前**，规则对 $s_t, a_t$ 求值，得到暂定语义状态、事件 $e_t$、空间编辑脚本（增删移框、改相机路径）。
2. **空间引导**：把编辑脚本应用到粘土模型，程序化相机（推进、环绕、头部推进）渲出预览片段 $r_t$——只表达布局和相机，不是最终外观。
3. **指令编译**：VisualScript 记录有固定槽位（风格、首帧锚点描述、相机、主体+外观、动作、对象+反应、对白、特效、稳定性约束、**结束状态**、音景、分镜、时长等，表 11）。编译器是确定性函数，相同输入得到相同指令；指令里会说明预览只是布局参考，避免模型照抄粘土外观。
4. **冻结渲染**：H3 收到文字指令、预览视频（视频参考）和锚点帧（图像参考），生成片段；一回合一次请求，失败有限次重试，默认回退为沿用上一锚点。
5. **视觉观察与状态更新**：VLM 看片段，提出可观察字段的更新；运行时只接受格式正确且与规则相容的提议。与已结算结果矛盾的"画面事件"记为渲染不一致，**不能推翻规则结果**。
6. 片段末帧（`ffmpeg -sseof` 取）成为下一回合锚点；场景切换时可断开锚点链，外观改由文字槽位携带。

### 条件信号与渲染器

| 项目 | 内容 |
|---|---|
| 渲染骨干 | **冻结的 MiniMax-H3**，只用它的原生文字 / 图像参考 / 视频参考接口，权重一律不改 |
| 条件信号 | ① VisualScript 编译出的文字指令；② 粘土模型渲出的预览视频（布局 + 相机）；③ 锚点帧（初始图或上一片段末帧） |
| 生成规格 | 864×480、24 fps，片段约 5 s |
| 粘土模型构建 | 前馈几何模型（引的是 VGGT）一次前向得到深度、世界点、部件特征，聚类出带方向的实例框，用 1.7 m 人高先验和相机高度定尺度，在 Blender 里实例化。**部署的空间通道**是单主体配置：WildDet3D（基于 SAM 3 + LingBot-Depth，1.2B）定位主体、针孔模型放框、拟合地面，Blender 在原相机下渲一张与输入逐像素对齐的粘土预览（附录 F.2） |
| 训练 / 蒸馏 | 没有，完全免训练 |
| 实时性 | 不是实时系统：回合制，一回合生成一段视频；论文**没有报告每回合耗时**；空间管线离线运行（附录 I） |
| 外观一致与记忆 | 靠末帧锚点链 + VisualScript 的外观/稳定性槽位延续身份；长期"记忆"在账本和粘土模型里，而不在视频模型里 |

### WorldState-Bench（§4、附录 A–C）

- **50 个案例**，来自 49 个隐藏变量、21 个主题（魔法学院、地牢、约会、密室、钓鱼等）。每个案例是一对双胞胎 A/B：首帧、动作脚本、规则程序都相同，只有一个隐藏值不同，而规则要求的可见结局不同。
- 首帧由 FLUX.2 生成（1280×720），经 **8 轮 VLM 审核**、6 个维度（物体是否出现、颜色、文字、空间、数量、状态线索）检查是否泄露隐藏值，泄露就改提示重生成。
- 隐藏变量三类：机制选择 42 例、角色反应 6 例、形态选择 2 例。触发方式：咒语 20 段、手势 42 段、机关 26 段、区域 12 段（按片段计）。
- **Change-to-Comply 协议**：Change 看动作是否产生了相机运动以外的可辨事件，Comply 看事件是否符合该隐藏状态下的规则；无事件或无法判断记 UNCLEAR，不给分。
- 两种基线指令：**Rule-only**（场景、动作、含两个分支的规则、所选分支的后果、隐藏值）和 **Rule+end**（再追加一句明确的终态）。外壳不分这两种，用自己编译的 VisualScript（总是写明结局）。
- 指标：

| 级别 | 指标 | 含义 |
|---|---|---|
| 片段 | EndFollow | 结尾是规定结局 |
| 片段 | CntAbsent | 全片段都没出现"禁止结局"（即另一个双胞胎的结局） |
| 片段 | Strict | 两者同时满足 |
| 对 | PairFollow | 两个双胞胎都 EndFollow |
| 对 | PairStrict | 两个都 Strict（作者的主指标） |
| 对 | TwinContrast | 两段的判定结局不同 |

- 裁判：Qwen3.8-27B-VL，3 fps 采样帧 + 末帧，回答固定选项问题；裁判拿到该分支的期望结局，但看不到隐藏变量和规则文本。生成和评判用 8 张 A800 80GB。

## 实验与关键数字

### WorldState-Bench 主表（[[topics/papers/代码世界模型与神经渲染/1-20_2610.26811_StateWorldModels.pdf#page=7|表 1，第 7 页]]）

A 组是 Rule-only，B 组是 Rule+end；外壳一行是同一冻结 H3 + 编译指令 + 首帧参考。

| 后端 | EndFollow | PairFollow | TwinContrast | Strict (B) | CntAbsent (B) | PairStrict (B) |
|---|---|---|---|---|---|---|
| Wan2.2 A14B | 65 | 32 | 38 | 54 | 63 | 26 |
| LongCat-Video 13.6B | 47 | 8 | 24 | 46 | 62 | 8 |
| HunyuanVideo 1.5 | 57 | 20 | 26 | 29 | 30 | 4 |
| MiniMax-H3 | 66 | 32 | 32 | 29 | 30 | 4 |
| LingBot-World v2 | 48 | 16 | 38 | 44 | 76 | 14 |
| Echo-WM Flash | 57 | 26 | 42 | 43 | 60 | 8 |
| FantasyWorld | 34 | 8 | 30 | 35 | 81 | 8 |
| AlayaWorld | 37 | 12 | 28 | 33 | 85 | 6 |
| InSpatio-World | 19 | 2 | 14 | 17 | 92 | 4 |
| Astra | 11 | 0 | 14 | 16 | 96 | 0 |
| HY-WorldPlay | 9 | 0 | 4 | 7 | 94 | 0 |
| **Stateful Harness** | **96** | **92** | **96** | **95** | **98** | **90** |

- 单段对不等于成对对：H3 Rule-only EndFollow 66%，PairFollow 只有 32%。
- Astra、HY-WorldPlay、InSpatio-World 的 CntAbsent 很高（92–96%）但 EndFollow 不到 20%——它们基本"什么都没发生"，所以也没出现禁止结局。
- **同一冻结 H3 的成分链**（附录 D，[[topics/papers/代码世界模型与神经渲染/1-20_2610.26811_StateWorldModels.pdf#page=19|第 19–20 页]]）：Rule-only PairFollow 32% → Rule+end 64%（+32，McNemar p = 4.0×10⁻⁴，自助法 95% CI [16, 48]）→ 完整外壳 92%（+28，p = 2.6×10⁻³，CI [12, 44]）。
- H3 在 Rule+end 下 EndFollow 升到 82%，但 PairStrict 只有 4%：方向错误从 34% 降到 18%，可"泄漏"（对的结局里同时出现禁止内容）从 40% 升到 53%（表 5、表 6）。外壳把三类错误都压下去：泄漏 1%、方向错误 4%、copy-paste 2%，PairStrict 45/50。
- Rule+end 相对 Rule-only 的 ΔStrict：除 H3 外 10 个后端平均 +2.3 个点（6 升 4 降），HunyuanVideo 1.5、AlayaWorld、InSpatio-World、HY-WorldPlay 为负（图 11）。

**外壳在不同触发类型上**（附录 D，Strict / PairStrict）：咒语 100 / 100（20 段）、手势 95.2 / 90.5（42）、机关 92.3 / 84.6（26）、区域 91.7 / 83.3（12 段，即 11/12 段、5/6 对）。区域类在纯文字配置下 Strict 只有 66.7%，加首帧参考提升最大。

**空间参考配置**（表 6，H3，50 对）：

| 条件 | 空间参考 | Copy-paste | TwinContrast | 方向错误 | 仅泄漏 |
|---|---|---|---|---|---|
| Rule-only | 无 | 34 | 32 | 34 | 40 |
| Rule+end | 无 | 14 | 64 | 18 | 53 |
| 外壳 | 无 | 0 | 96 | 6 | 5 |
| 外壳 | 首帧 | 2 | 96 | 4 | 1 |

### 人工审核（附录 C）

- **裁判校验**：17 个案例（9 个 Rule-only、8 个 Rule+end）× 2 个隐藏状态 × 3 个系统（外壳、H3、Wan2.2）= 102 段，每段 3 名盲评。VLM 裁判与人类多数一致率 Q1 91.2%、Q2 86.3%（人与人之间 90.2%、80.7%），κ = 0.72 / 0.72；系统排名与人工的 Spearman ρ：Strict 0.94、CntAbsent 1.00。
- **成对偏好**（另取 25 对，2 倍速、四宫格同时播放、强制二选一）：外壳对 H3 96%、AlayaWorld 100%、Echo-WM Flash 100%、Wan2.2 96%，总体 98%，其余是评审意见分裂，没有一次判基线赢（[[topics/papers/代码世界模型与神经渲染/1-20_2610.26811_StateWorldModels.pdf#page=8|图 5，第 8 页]]；表 3）。

### 外部基准 WBench（表 2、表 7–9）

同一冻结 H3，官方文字协议 vs 完整外壳（含预览视频），全集：

| 配置 | 画质 | 设定遵循 | 交互 | 一致性 | 物理 | 总分 |
|---|---|---|---|---|---|---|
| H3（官方文字协议） | 77.9 | 71.1 | 68.9 | 83.8 | 69.3 | 74.2 |
| H3 原始文字 + 预览视频 | 79.3 | 75.3 | 55.7 | 67.1 | 58.2 | 67.1 |
| H3 + 外壳，仅首帧参考 | 77.6 | 89.6 | 69.0 | 75.3 | 69.0 | 76.1 |
| 完整外壳 | 78.0 | 87.2 | **77.7** | 77.8 | 68.8 | **77.9** |

- 交互 77.7 是 WBench 表里（文字驱动类）最高；文字驱动类平均：画质 77.4、物理 66.9。
- 一致性从 83.8 降到 75.3、再回到 77.8，**没有恢复到原始水平**；物理 69.3 → 68.8 也略降。
- 导航子集（表 9）总分 74.7 → 76.8 → 79.0；"原始文字 + 预览视频"只有 65.7——没告诉模型"这只是布局参考"时，它会照抄粘土外观，作者看了 30 段生成片段确认这一现象。

### 多回合演示（[[topics/papers/代码世界模型与神经渲染/1-20_2610.26811_StateWorldModels.pdf#page=9|图 6，第 9 页]]；附录图 15–17）

三段真实外壳录像，同一套冻结权重、三份不同游戏定义：小镇探索（15 幕，体力 28 → 0 后只能慢走，休息回到 60，任务 1/3 → 3/3）、约会（29 回合，好感 47 → 75 每回合 +1，第 14 回合"朋友 → 暧昧"、第 29 回合"恋人"，告白才被接受）、回合制 Boss 战（11 回合，Boss 血量 128 → 0）。**只有定性展示，没有多回合的定量评测**。

## 局限 / 存疑

作者自己承认的（附录 I）：粘土模型只是粗的框表示，实例恢复出错会传到预览；文字指令不总能阻止模型照抄粘土外观；关节姿态和细外观由视频模型决定；空间管线离线运行。后续想要更丰富的规则语言（时序、量词条件）、追踪更多实体和关系、迁移到更多后端。

读的时候值得核对的：

- **基准上的提升主要来自什么**：Rule-only 指令里已经给了**隐藏值和所选分支**，所以在单回合基准里"规则结算"本身几乎是平凡的（案例程序直接决定结局）。32 → 64 是"写明结局"带来的，64 → 92 是 VisualScript 编译 + 结算 + 锚点/参考通道一起带来的；作者把后一段称作"执行状态 + 编译参考"，但论文里没有把 VisualScript 措辞和"有状态"这两件事拆开消融。外壳真正有状态的部分（跨回合账本、VLM 回写）只在三段定性多回合演示里出现，正文也明说"本文的反事实评测测的是渲染的遵从度"。
- **基准上用的外壳配置不清楚（需核对）**：表 1 图注说外壳一行用"文字 + 首帧参考"，表 6 说"部署配置用首帧参考"；而 §3.2、图 3 和 WBench 的"完整外壳"都包含粘土预览视频。WorldState-Bench 的 92% 到底有没有用预览视频，论文没明说。
- **谁写案例程序（前后不一，需核对）**：§4 说"作者用类型化语言指定每个案例程序"；附录 F.2 又说"所有报告的实验里游戏定义都由 GLM-5.3 编码智能体写，每个 WorldState-Bench 案例程序就是这样一份定义"。
- **裁判与系统组件同源**：评判用 Qwen3.8-27B-VL，而部署里意图/提议内核和 LLM 玩家也是常驻的 Qwen3.8-27B-VL 服务（附录 F.2）；论文没说视觉观察器 $O_\psi$ 用哪个模型。有人工审核兜底（一致率 91.2% / 86.3%），但人工只覆盖 102 段。
- **跨轨道的数字混用**：§5.4 写"PairStrict 从 4 到 90"，4 是 H3 在 Rule+end 下的值；H3 在 Rule-only 下 PairStrict 是 0（表 4）。作者说的是"各自轨道的原始基线"，读的时候注意。
- **分辨率不一致**：外壳生成 864×480 / 24 fps，基线按各自原生分辨率（592×336 到 1280×720、15–24 fps）；H3 基线本身用什么分辨率没写。
- **引用对不上**：MiniMax-H3 引的是 "Chen et al., 2026a"，这条参考文献实际是 H3-World（2609.01560）；Qwen3.8-27B-VL 引的是 Qwen3 技术报告。附录 H "Compute Reporting" 一段像是残留的编辑文字（"The manuscript states that…"），没有给出每回合耗时、GPU 时长。
- **WBench 的交互分**：表 7 注明外壳的交互平均分 77.7 是官方榜单值，**不是**表中三个子分数（81.8、85.8、59.7，平均 75.8）的均值。
- **"免训练"的代价**：每个新世界都要编码智能体写一份游戏定义；没有给出智能体写定义的成功率、需要几轮修复、人工介入多少。
- **视觉回写可能引入漂移**：被接受的观察会改变后续状态，所以状态轨迹依赖生成视频（附录 F.1 自己承认）；但"相容性检查"具体怎么判定、拒绝率多少，没有数字。

## 与其他论文的关系

- **范式起点**：[[topics/notes/代码世界模型与神经渲染/1-01_CodeWorldModel|CWM]] 也是"编码智能体维护状态 + H3 渲染"，但把状态编译成代理视频（对数深度 + 语义 ID）并给 H3 加 LoRA 微调；本文的表 12 正是拿 CWM 对比：本文**不微调**，只用 H3 原生的文字 / 图像 / 视频参考接口，并且显式区分"规则结算"和"渲染"。CWM 没有定量结果，本文补上了"规则遵从"的定量评测。
- **同用 H3 的工作**：[[topics/notes/代码世界模型与神经渲染/1-07_Oneira|Oneira]]（状态表渲成条件视频 + H3 LoRA，自建 InteractionBench）、[[topics/notes/代码世界模型与神经渲染/1-05_CoDeR|CoDeR]]（白盒 + 深度 + ControlNet）、[[topics/notes/代码世界模型与神经渲染/2-09_SolarRenderer|SolarRenderer]] 和 [[topics/notes/代码世界模型与神经渲染/1-12_StreamRender-H3|StreamRender-H3]]（把结构视频喂进 H3 的参考通路，但仍训练 LoRA / 蒸馏）。本文是其中唯一完全不训练的，代价是不实时、回合制。
- **显式状态的另几种接口**：[[topics/notes/代码世界模型与神经渲染/1-04_ProgrammableWorldModel|PWM]] 用 OBB 投影成像素级嵌入图 + ControlNet，也含屏幕外实体，评测是 CombatStateBench 的存活人数 / 死亡状态；[[topics/notes/代码世界模型与神经渲染/1-11_Matrix-Game-4.0|Matrix-Game 4.0]] 用低模代理；[[mirros/notes/01_AgentGarten|AgentGarten]] 用深度 / 法线并训练实时渲染器。本文的特点是把**语义事件**放进文字（VisualScript），几何只当粗布局预览——作者认为文字能表达 OBB 流表达不了的语义事实。
- **几乎同时的同类基准**：[[topics/notes/代码世界模型与神经渲染/1-21_BoxWorld|BoxWorld]]（一周后发布）的 PairedStateBench 同样用"同一初始场景、不同分支"的成对设计和"触发 / 抑制"两类指标（对应本文的 EndFollow / CntAbsent）；两篇都发现端到端世界模型即使拿到"写明结局的文字"也做不对成对用例（BoxWorld 的 oracle 变体、本文的 Rule+end）。区别：BoxWorld 训练了一个实时渲染器，条件是 2D 框 + 属性 + 动态状态；本文不训练、回合制。
- **评测角度**：[[topics/notes/代码世界模型与神经渲染/3-04_WorldDraft|WorldDraft]] 发现草稿外观会泄漏进生成结果——本文"原始文字 + 预览视频"照抄粘土外观、要靠指令说明"这只是布局参考"，是同一现象。[PROWBench](https://arxiv.org/abs/2610.02205)（3-06）测"视频模型渲的是否符合程序规定的事件"，和 WorldState-Bench 的问题很近，可以对照。[Can video world models track unobserved world states?](https://arxiv.org/abs/2608.30692)（Shin et al.）是同期的"隐藏状态"测试，但测的是模型内部状态（猜杯子），本文把隐藏状态放在外部规则程序里。
- **同一节里的近邻**：[GameDirector](https://arxiv.org/abs/2609.25652)（1-16）、[Fight World Model](https://arxiv.org/abs/2610.40607)（1-22）、[Wizard](https://arxiv.org/abs/2610.40339)（1-23）、[StatePlay](https://arxiv.org/abs/2607.26754)、[WorldMind](https://arxiv.org/abs/2608.21439)（从帧里恢复 NPC 状态）、[Marionette](https://arxiv.org/abs/2608.14530)、[Incantation](https://arxiv.org/abs/2605.18601)（把选定状态变量当生成条件）。
- **被测的端到端世界模型**：LingBot-World v2、Echo-WM、AlayaWorld、InSpatio-World、Astra（同组 Wenzhao Zheng、Jiwen Lu）、HY-WorldPlay——在本基准上普遍"不动"或两个双胞胎给出同样结局。
- **和本库方向的联系**：
  - 具身导航里也常见"画面一样、隐藏状态不同"的情形（门锁没锁、物体是否已被拿走），但本文的世界都是游戏 / 叙事题材，没有机器人或导航实验；WorldState-Bench 的成对反事实设计可以借来测导航用世界模型能否尊重不可见状态。参见 [[topics/视觉语言导航VLN]]。
  - "编码智能体把描述写成可执行规则 + 冻结的生成模型负责外观"，属于 [[topics/递归自我改进RSI]] 第五节"大模型生成任务与环境"一路；VLM 看结果再回写状态，也类似具身智能体的"观察 → 记忆更新"，但这里写的是世界状态而不是智能体记忆。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文是 CC BY 4.0，必要处附短句原文）
> 1. 第 1 页摘要：只靠导航不能保证动作在"当前画面看不见的状态"下遵守持久规则；最好的基线 32%，H3 写明结局 64%，完整外壳 92% → 问题与核心数字
> 2. 第 2 页 §1 第 2 段："The central challenge is therefore to make state transitions authoritative and render their consequences faithfully." → 作者的问题定义
> 3. 第 3 页 §3 "Framework Overview" + 式 1：$s_t=(z_t,u_t)$，语义账本 + 可编辑空间状态，规则固定 → 状态表示
> 4. 第 4 页 §3.1 "Executable Rules"：编码智能体用小的类型化语言写游戏定义，每条规则有 guard 和 effect，互动前验证并冻结 → 谁写代码
> 5. 第 5 页 §3.2 "Instruction Compilation"：VisualScript 固定编译器，相同输入相同指令；文字承载 OBB 表达不了的语义，预览给布局和相机 → 条件信号
> 6. 第 6 页 §3.2 "Visual Observation and State Update"：与已结算结果矛盾的画面事件记为渲染不一致，不能推翻结果 → 规则的权威性
> 7. 第 6 页 §4 "Case Construction"：50 例、49 个隐藏变量、21 个主题，FLUX.2 首帧并审核 → 基准构造；§4 同时说案例程序由作者写，和附录 F.2 对照
> 8. 第 7 页表 1 与 §5.1：11 个后端、裁判 Qwen3.8-27B-VL、8 张 A800、外壳 864×480 → 主表与设置
> 9. 第 19–21 页附录 D 与表 4：成分链 32 → 64 → 92，McNemar p 值和自助法区间；H3 Rule+end 下 PairStrict 4% → 增益归因
> 10. 第 32 页附录 F.2 "Clay-Model Construction" / "Domain Adaptation"：部署的单主体空间通道（WildDet3D + Blender），所有游戏定义由 GLM-5.3 写 → 粘土模型与编码智能体细节

## 摘要（中文）

现有世界模型可以从单张图像生成动作条件的视频，其中许多关注相机运动，让用户探索生成的场景。然而，当动作的结果取决于当前画面中看不见的状态时，仅有导航并不能保证动作遵循持久的规则。我们提出 Stateful Harness，一个把世界演化与视频渲染分开、以支持有状态且受规则约束的交互的框架。它在给定规则下维护一个不断演化的世界状态，用一个冻结的视频模型渲染每个由此产生的事件，并用生成的片段为下一回合更新世界状态。每一回合，外壳结算用户选择的动作，把产生的事件编译成指令，同时由一个可编辑 3D 场景生成的预览片段提供空间和相机引导。为评估规则遵从，我们构建了 WorldState-Bench：50 对反事实双胞胎，共享首帧和动作，但隐藏状态和要求的结局不同。只给规则提示时，11 个被评测的视频后端中最好的一个，只在 32% 的双胞胎对上同时给出两个规定结局。对 MiniMax-H3，写明要求的结局把这一比例从 32% 提到 64%，而完整外壳用同一个冻结模型达到 92%。这些结果支持在含隐藏状态的世界交互中把规则执行与视频渲染分开。

## 摘要（原文）

论文以 CC BY 4.0 许可发布（[arXiv 摘要页](https://arxiv.org/abs/2610.26811)），以下转录自本地 PDF 第 1 页：

Existing world models can generate action-conditioned video from a single image. Many focus on camera movement, allowing users to explore the generated scene. However, navigation alone does not ensure that an action follows persistent rules when its outcome depends on state that is invisible in the current frame. We present STATEFUL HARNESS, a framework that separates world evolution from video rendering to support stateful and rule-governed interaction. It maintains an evolving world state under specified rules, renders each resulting event with a frozen video model, and uses the generated clip to update the world state for the next turn. At each turn, the harness resolves the action selected by the user and compiles the resulting event into an instruction, while a preview clip from an editable 3D scene provides spatial and camera guidance. To evaluate rule compliance, we build WorldState-Bench, a benchmark of 50 counterfactual twin pairs that share an initial frame and action but differ in hidden state and required outcome. Under rule-only prompting, the best of the 11 evaluated video backends produces the required endings for both cases in 32% of pairs. For MiniMax-H3, specifying the required endings raises this rate from 32% to 64%, while the full harness reaches 92% with the same frozen model. These results support separating rule execution from video rendering for world interactions with hidden state.
