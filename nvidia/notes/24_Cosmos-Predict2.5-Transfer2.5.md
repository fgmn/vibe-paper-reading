---
id: "24"
org: 英伟达
short: "Cosmos-Predict2.5 · Transfer2.5"
title: "World Simulation with Video Foundation Models for Physical AI"
aliases: ["Cosmos-Predict2.5 · Transfer2.5", "Cosmos-Predict2.5", "Cosmos-Transfer2.5"]
date: 2025-10-28
category: "Cosmos · Predict"
source: "英伟达主导"
partners: []
authors: ["NVIDIA: Arslan Ali", "Junjie Bai", "Maciej Bala", "Yogesh Balaji", "Aaron Blakeman", "Tiffany Cai", "Jiaxin Cao", "Tianshi Cao", "Elizabeth Cha", "Yu-Wei Chao", "Prithvijit Chattopadhyay", "Mike Chen", "Yongxin Chen", "Yu Chen", "Shuai Cheng", "Yin Cui", "Jenna Diamond", "Yifan Ding", "Jiaojiao Fan", "Linxi Fan", "Liang Feng", "Francesco Ferroni", "Sanja Fidler", "Xiao Fu", "Ruiyuan Gao", "Yunhao Ge", "Jinwei Gu", "Aryaman Gupta", "Siddharth Gururani", "Imad El Hanafi", "Ali Hassani", "Zekun Hao", "Jacob Huffman", "Joel Jang", "Pooya Jannaty", "Jan Kautz", "Grace Lam", "Xuan Li", "Zhaoshuo Li", "Maosheng Liao", "Chen-Hsuan Lin", "Tsung-Yi Lin", "Yen-Chen Lin", "Huan Ling", "Ming-Yu Liu", "Xian Liu", "Yifan Lu", "Alice Luo", "Qianli Ma", "Hanzi Mao", "Kaichun Mo", "Seungjun Nah", "Yashraj Narang", "Abhijeet Panaskar", "Lindsey Pavao", "Trung Pham", "Morteza Ramezanali", "Fitsum Reda", "Scott Reed", "Xuanchi Ren", "Haonan Shao", "Yue Shen", "Stella Shi", "Shuran Song", "Bartosz Stefaniak", "Shangkun Sun", "Shitao Tang", "Sameena Tasmeen", "Lyne Tchapmi", "Wei-Cheng Tseng", "Jibin Varghese", "Andrew Z. Wang", "Hao Wang", "Haoxiang Wang", "Heng Wang", "Ting-Chun Wang", "Fangyin Wei", "Jiashu Xu", "Dinghao Yang", "Xiaodong Yang", "Haotian Ye", "Seonghyeon Ye", "Xiaohui Zeng", "Jing Zhang", "Qinsheng Zhang", "Kaiwen Zheng", "Andrew Zhu", "Yuke Zhu"]
arxiv: "2511.00062"
pdf: "[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf]]"
code: "https://github.com/nvidia-cosmos/cosmos-predict2.5"
project: "https://research.nvidia.com/labs/dir/cosmos-predict2.5"
huggingface: ["https://huggingface.co/collections/nvidia/cosmos-predict25-68bb63255f2fc206c5e5b346", "https://huggingface.co/nvidia/Cosmos-Predict2.5-2B", "https://huggingface.co/nvidia/Cosmos-Predict2.5-14B", "https://huggingface.co/nvidia/Cosmos-Transfer2.5-2B"]
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "nvidia", "cosmos", "world-model", "video-generation", "flow-matching", "controlnet", "synthetic-data"]
---

# World Simulation with Video Foundation Models for Physical AI

> [!info] 论文信息
> arXiv [2511.00062](https://arxiv.org/abs/2511.00062) · v1 2025-10-28 · 最新 v2（2026-02-24）
> PDF：[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf|本地 PDF]]
> [代码](https://github.com/nvidia-cosmos/cosmos-predict2.5) · [Transfer2.5 代码](https://github.com/nvidia-cosmos/cosmos-transfer2.5) · [项目页](https://research.nvidia.com/labs/dir/cosmos-predict2.5)
> 系列：Cosmos · Predict · 角色：英伟达主导
> 清单里的一句话（Claude 根据摘要写，请核对）：Cosmos-Predict2.5 与 Transfer2.5 技术报告：基于 flow 的统一 Text/Image/Video2World 模型，借 Reason1 做文本 grounding，并推出更小更强的控制网。
> 汇总：[[nvidia/英伟达-论文与报告汇总|英伟达论文与报告汇总]]

> [!note] 下面各节是 Claude 根据论文全文（arXiv v2，44 页：正文 36 页 + 贡献者名单 + 参考文献）写的初稿（2026-11-23）。读的时候请核对并改成你自己的理解。写着"需核对"的地方是论文本身前后对不上的，没有替你选择。

## 一句话总结

Cosmos 第二代视频世界模型的技术报告，主体是"更好的数据 + 更简单的模型 + 更完整的后训练"：从 3500 万小时原始视频切出 60 亿片段、只留约 4%（2 亿）做预训练；DiT 去掉绝对位置编码、换 **WAN2.1 VAE** 和 **Cosmos-Reason1 文本编码器**，用 **flow matching** 把 Text2World / Image2World / Video2World 合进一个模型；后训练走**分领域 SFT → 模型合并（model soup）→ 基于 VideoAlign 的 GRPO 式 RL → rCM 4 步蒸馏**。2B / 14B 两档在 PAI-Bench 上和 Wan2.2-27B-A14B 打平（T2W 0.768 vs 0.769，I2W 0.810 vs 0.806）。在此之上做了一串应用：控制网 **Transfer2.5-2B**（比 Transfer1-7B 小 3.5 倍但更好、长视频误差累积更少）、真机数据增强（视觉扰动下 24/30 vs 5/30）、7 路环视驾驶生成、相机可控多视角、DreamGen 合成 VLA 数据、动作条件世界模型（Bridge）。

## 要解决什么问题

- **物理 AI 需要"安全的世界代理"**：真机训练慢、贵、危险，尤其在早期；能根据智能体动作生成高质量、多样画面的世界模拟器，可以让策略先在"硅里"学感知和控制。
- **上一代 [[nvidia/notes/08_Cosmos|Cosmos-Predict1]] 的不足**（作者列出的三处改进方向）：
  1. 数据：过滤不够严，缺少专门为物理 AI 挑的后训练数据；
  2. 模型：T2W、I2W、V2W 是分开的模型，结构偏复杂（EDM 扩散、绝对位置编码）；
  3. 训练配方：T5 文本编码器对物理场景的语义不够细，没有 RL 和模型合并。
- **开源视频模型（Wan、Hunyuan、LTX）多为内容创作优化**，在物体动力学、交互、物理一致性上不够；闭源模型（Sora、Veo、Kling）不能拿来微调做机器人和自动驾驶。
- 下游要的能力：合成 VLA 训练数据、策略评估（动作条件生成）、自动驾驶多视角闭环仿真、Sim2Real / Real2Real 画面转换。

## 方法

### 数据（§2，[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=4|图 1，第 4–5 页]]）

| 项目 | Predict1 | Predict2.5 |
|---|---|---|
| 原始视频 | 2000 万小时 | **3500 万小时**（第 4 页另写"超过 2 亿条原始视频"） |
| 切出的片段 | — | 60 亿+（5–60 秒，<5 秒丢弃） |
| 过滤后存活率 | 30% | **约 4%** |
| 预训练片段 | — | **约 2 亿** |

- **七步管线**：按镜头切分 → GPU 转码 → 裁黑边 → 过滤 → 打标题 → 语义去重 → 分片。
- **过滤链**（便宜的在前、贵的在后）：美学评分 → 运动量 → OCR（字幕/叠字）→ 感知质量（类似 DOVER）→ "语义伪影"（类似 VTSS，画中画、坏转场）→ 最后用 VLM 精筛；再用内容类型分类器归类，**剔除游戏、动画、卡通、合成图案**等不符合物理世界的内容。
- **标题**：每 5 秒一个窗口，用 Qwen2.5-VL-7B 生成短 / 中 / 长三种长度，强调主体、运动和关键语义。
- **去重**：嵌入聚类后簇内两两比较，保留最高分辨率；在线去重，新片段和已留片段比，平局偏向更老、更高分辨率的。
- **分片**：26 类内容分类 × 分辨率 × 宽高比 × 时长，方便课程式采样和领域配比。基础设施上接 Delta Lake 和 Milvus 做 SQL 分析和向量检索。
- **五个领域专项数据**（§2.2）：不用 VLM 过滤、改用领域专用过滤器子集，标题换更大的 VLM + 领域定制 prompt。
  - 机器人（[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=6|表 2]]）：AgiBot-Beta、Bridge、DROID、GR00T、1X、OpenX、RoboMIND；剔除低分辨率和近静止视频，**把太慢的机器人视频加速播放**统一节奏；prompt 要求先列初始场景、再按时间写动作（运动类型、哪个部件、相机运动），并注入数据集元数据（GR00T 的任务描述和成功评分、Bridge 的分步指令、AgiBot 的初始场景）减少幻觉。
  - 自动驾驶：约 310 万段 20 秒 7 路环视（自家平台），按地区、车流、速度、加速度、机动、路型、隧道收费站、能见度、天气、光照等属性配比采样；标题聚焦需要注意的交通参与者、环境、纵横向元动作、速度、交互。
  - 智慧空间（仓库、工厂、工地）：关键词检索 + VLM 确认相关性，约 4 万段。
  - 人体动态：YOLOX + RTMPose，要求 >40% 帧有人、每帧 ≤8 人、至少一人占画面 ≥3%。
  - 物理：先定义可观察物理现象的分类（经典力学、流体……），再按分类收视频（碎玻璃、球碰撞、流水）。

### Flow matching（§3.1，[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=8|第 8 页]]）

- 从 Predict1 的 EDM 换成 **flow matching**：$x_t=(1-t)x+t\epsilon$，网络预测速度 $v_t=\epsilon-x$，MSE 损失。作者的说法是两者前向/反向过程数学等价、只是网络参数化不同，速度目标更直接、优化更平滑。
- **偏向高噪声采样**：logit-normal 采 $t$ 后做 shift $t_s=\beta t/(1+(\beta-1)t)$；$\beta$ 随分辨率从 256p 的 1 增到 720p 的 5（高分辨率像素相关性强，噪声小了"打不散"）。
- 仍出现帧间突兀跳变 → 认为高噪声区样本太少，**让 5% 的样本专门从最高 2% 的噪声区间采**，明显减少跳变。

### 网络结构（§3.2，[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=9|表 3、图 2，第 9–10 页]]）

| 配置 | 2B | 14B |
|---|---|---|
| 层数 | 32 | 36 |
| 模型维度 | 2048 | 5120 |
| FFN 隐层 | 8192 | 20480 |
| 注意力头 × 头维 | 16 × 128 | 40 × 128 |
| AdaLN-LoRA 维度 | 256 | 256 |

- 基本沿用 Predict1 的 DiT（自注意力 + 交叉注意力 + FFN，AdaLN 按时间步调制）；**唯一的主要结构改动是去掉绝对位置编码、只留 3D RoPE**，为了后训练时能外推到更高分辨率、更长视频（借鉴长上下文 LLM 的 YaRN / NTK）。
- **视觉 tokenizer 换成 WAN2.1 VAE**（因果 VAE，时空压缩 4×8×8），再 1×2×2 patchify。一次生成 **93 帧 = 24 个潜帧，16 fps，约 5.8 秒**。
- **文本编码器换成 Cosmos-Reason1**（替代 T5）：不取单层输出，而是**把多个 block 的激活按 token 拼起来再投影到 1024 维**，通过交叉注意力注入。Reason1 的视觉编码器可以接图像做风格控制，留作以后。
- **一个模型三种模式**：T2W（只有文本）、I2W（文本 + 一帧）、V2W（文本 + 一段视频）。I2W / V2W 用**帧替换**：生成序列开头的帧直接换成条件帧；每个 token 拼一个二值 mask 标记是否条件帧，损失只算在要生成的帧上。

### 预训练（§4.1，[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=11|表 4，第 11 页]]）

渐进式，难度沿"分辨率"和"任务"两个轴上升，每阶段收敛、画质不再提升就进下一阶段：

| 阶段 | 任务 | 分辨率 |
|---|---|---|
| 1 | Text2Image | 256p（320×192） |
| 2 | T2I + Video2World（1 或 5 帧条件 → 生成其余 92 / 88 帧） | 256p |
| 3 | 同上 | 480p（832×480） |
| 4 | 同上 | 720p（1280×704） |
| 5 | 再加 Text2World（0 / 1 / 2 帧条件，概率 0.5 / 0.25 / 0.25） | 720p |

AdamW（β=0.9/0.999），学习率 2B 3e-5、14B 1.3e-5，weight decay 0.001，2000 步 warmup 后线性衰减。

### 后训练（§4.2，[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=11|第 11–14 页]]）

1. **分领域 SFT**：用 InternVideo2 嵌入上的多头分类器把数据分成五类——物体恒存（1040 万）、高运动（100 万）、复杂场景（160 万）、驾驶（310 万）、机器人操作（73 万），**每个领域单独微调一个模型**（各 30K 步、batch 256），省去配比问题；人评里每个 SFT 模型在本领域都明显胜过预训练模型（[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=12|图 3]]）。
2. **4K 冷却**：用 38.8 万段 4K 视频把学习率线性降到 0，提升细节和运动平滑度。
3. **模型合并**：把各领域 SFT 模型和冷却模型合起来；试了 model soup、TIES、DARE-Linear、DARE-TIES，每种扫超参出 20+ 个候选，先在少量难例上挑、再大规模人评验证。除 DARE-Linear 外表现相近，**选最简单的 model soup**（[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=12|图 4]]）。作者的观察：**直接网格搜超参比按各 SFT 模型胜率做启发式选择更好**。
4. **强化学习**（[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=13|第 13 页]]，细节在 Ye et al. 2025）：奖励模型 **VideoAlign**（VLM 打文本对齐、运动质量、画质三项）；每个条件 20 步采样生成 8 个视频，**组内归一化奖励作为优势（GRPO 式）**；显存不够，把轨迹概率拆成各步条件概率之和，每两步算一次梯度、在整条轨迹上累积后更新；256 步、batch 32；**加微调数据上的扩散损失做正则抑制 reward hacking**；最终发布合并模型 RL 后的 EMA 权重。
5. **步数蒸馏**：**rCM**（连续时间一致性蒸馏 + 分布匹配蒸馏的前向-反向混合），为此做了支持 JVP 的融合 flash attention、FSDP2 和上下文并行适配；**4 步**生成，指标和教师相当（T2W 0.764 vs 0.768，I2W 0.816 vs 0.810，蒸馏版反而略高）。

### 训练基础设施（§4.3）

- FSDP2 混合分片（逐参数分片，借鉴 TorchTitan 的异步 checkpoint、meta-device 初始化）。
- **Ulysses 式上下文并行**替代 Predict1 的 ring attention：更省通信，也更好支持 NATTEN 稀疏注意力和带 JVP 的 flash attention；图像 batch 时关闭、视频 batch 时打开。
- 选择性激活重计算（先重算逐元素和归一化，必要时扩展到部分线性层）。
- 弹性奖励服务：解码 / 打分流水线，CUDA IPC 零拷贝，异步任务 + Redis 取结果。
- 4096 张 H100、720p 93 帧时 MFU：2B **36.5%**（CP=2），14B **33.1%**（CP=8，通信更多）。

## 实验与关键数字

### 基础模型（§5，[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=16|表 10、11，第 16 页]]）

PAI-Bench Predict：Domain 分（7 个领域的 VQA 评测：av、common、human、industry、misc、physics、robotics）+ Quality 分（改自 VBench 的 8 项指标），Overall 取平均。

| 模型 | T2W Overall | I2W Overall |
|---|---|---|
| Predict2.5-2B 预训练 | 0.751 | 0.799 |
| **Predict2.5-2B 后训练** | **0.768** | **0.810** |
| Predict2.5-14B 预训练 | 0.757 | 0.806 |
| **Predict2.5-14B 后训练** | **0.768** | **0.810** |
| Wan2.1-14B | 0.761 | 0.797 |
| Wan2.2-5B | 0.764 | 0.804 |
| Wan2.2-27B-A14B | **0.769** | 0.806 |

**人评**（[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=17|图 6、7，第 17 页]]，胜 / 负 / 平）：

| 对比 | Cosmos 胜 | 对手胜 | 平 |
|---|---|---|---|
| 2B vs Wan2.2-5B | 30.0% | 26.2% | 43.8% |
| 2B vs Wan2.1-14B | 33.0% | 34.8% | 32.2% |
| 14B vs Wan2.1-14B | **48.6%** | 31.8% | 19.6% |
| 14B vs Wan2.2-27B-A14B | 38.1% | 35.9% | 26.0% |

- 14B 相对 2B 的优势**在自动指标里几乎看不出来**（后训练后两者 Overall 完全相同），在人评里才明显（对同一个 Wan2.1-14B，胜率 33.0% → 48.6%）。

**RL 效果**（[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=14|表 6]]、[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=13|图 5]]，Predict2.5-2B）：VideoAlign 奖励总和——T2W 预训练 1.08 → 1.69、合并模型 1.23 → 1.74；I2W 0.23 → 0.42、0.24 → 0.45。主要涨在运动质量和画质，I2W 的文本对齐几乎没变。人评 RL 后胜 / RL 前胜 / 平：预训练 + RL 37.0 / 16.3 / 46.7，合并 + RL 41.1 / 18.9 / 40.0。

### Cosmos-Transfer2.5（§6.1，[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=18|第 18–21 页]]）

- **结构**：沿用 [[nvidia/notes/11_Cosmos-Transfer1|Transfer1]] 的控制网，唯一改动是 4 个控制块的位置——Transfer1 把 4 块**串在主干开头**，Transfer2.5 改成**每 7 个主干块后插一个**，让条件信息逐层注入。
- **控制数据**：深度（Video Depth Anything）1000 万段、分割（SAMv2）300 万段、边缘 + 模糊 1400 万段；每个模态的控制分支**独立训练** 10 万步、batch 64。
- **PAI-Bench-Transfer**（600 段，[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=19|表 12]]）：

| 模型 | Blur SSIM↑ | Edge F1↑ | Depth si-RMSE↓ | Seg mIoU↑ | 质量分↑ |
|---|---|---|---|---|---|
| Transfer1-7B 四模态均匀权重 | 0.82 | 0.26 | 0.70 | 0.74 | 9.24 |
| **Transfer2.5-2B 四模态均匀权重** | **0.87** | **0.41** | **0.67** | **0.76** | 9.31 |
| Transfer2.5-2B 只用 Blur | 0.90 | 0.26 | 0.59 | 0.75 | **9.75** |

  单模态对比也是 2.5 全面胜过 1（如 Edge 单模态的 Edge F1 0.49 vs 0.38）。作者把提升归因于更强的底座和更聚焦物理 AI 的训练数据。
- **长视频误差累积**（§6.1.2，[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=21|图 10]]）：提出 **RNDS**——第 $i$ 块生成视频的 DOVER 分 / 对应真实视频的 DOVER 分，再除以第 1 块的这个比值，使曲线从 1 起步。17 段 30–120 秒视频、每块 93 帧自回归生成，四种控制模态下 Transfer2.5 的 RNDS 下降都远小于 Transfer1。

### 真机数据增强（§6.2，[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=21|第 21–24 页]]）

- 平台：半人形，两条 7 自由度 Kinova Gen3 + Robotiq 2F-140，头部一个 RealSense D455；Quest 2 遥操作 + cuRobo MPC。
- 任务：双臂端碗装苹果（一手拿苹果、一手拿碗，苹果放进碗里再把碗放下）；**只变物体位置**，物体、桌面、背景固定；采 100 条示教。
- 策略：UNet Diffusion Policy，单张图（小 ViT）+ 夹爪状态，预测 8 步动作块，10 FPS。
- 增强：全图 **edge 控制** + 只在机器人像素上加 **blur 控制**（Grounding DINO + SAMv2 抠机器人），CFG 3；先让 VLM 给示例视频写标题、再迭代修到 Transfer2.5 能复现原视频，然后把桌子、苹果颜色、碗颜色、光照、背景标成可变槽位让 LLM 填。每条示教生成 5 个变体，只换图像、动作和关节状态不变。
- 结果（[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=23|表 13]]，每种场景 3 次，物体位置固定）：

| 策略 | 原场景 | 9 个新场景 | 合计 |
|---|---|---|---|
| 只用 100 条示教 | 1/3 | 0/27 | 1/30 |
| 常规图像增强（亮度、对比度、色相、噪声、模糊……） | 3/3 | 2/27（只有换橙色碗成功 2 次） | 5/30 |
| **Transfer2.5 增强** | 3/3 | **21/27** | **24/30** |

  9 个新场景：山竹换苹果、橙色碗、米色 / 黑色桌布、左侧聚光灯（前 5 个大致在增强 prompt 覆盖范围内）、桌上干扰物、背景柜子变黑、打开抽屉和烤箱门（这 3 个是明确的分布外），以及前三项组合。

### 自动驾驶多视角（§6.3，[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=25|第 25–28 页]]）

- **结构**：把 7 个视角沿潜在时间维拼起来当连续帧；为放进显存，每个视角潜帧减到 8（29 帧/视角，共 203 帧，30 fps）；每个视角独立编解码，通道维拼一个 7 维可学习视角嵌入；RoPE 按视角分别构造；每个视角可有自己的条件帧和控制信号。
- **Transfer2.5-2B/auto/multiview** 的控制信号叫"**世界场景图**"：HD 地图（车道线类型和颜色、路沿、杆、红绿灯带状态）+ 按类别着色、按朝向明暗区分的 3D 框，比原来的控制视频多了**线型细节**和**遮挡 / 朝向感知**。用 RDS-HQ 14 万段训练。
- 评测：RDS-HQ 中 1000 段不相交的片段（[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=25|表 14、15]]）。

| 模型 | FVD-StyleGAN↓ | FVD-I3D↓ | FID↓ | TSE↓ | CSE↓ |
|---|---|---|---|---|---|
| Predict2.5-2B/auto/mv | **23.1** | **25.3** | **12.1** | 0.948 | 1.903 |
| Predict1-7B-Sample-AV | 63.7 | 69.6 | 25.3 | 0.930 | 2.631 |
| Transfer2.5-2B/auto/mv | 24.2 | 25.7 | 20.0 | 1.246 | 2.310 |
| Transfer1-7B-Sample-AV | 56.6 | 60.7 | 22.6 | 1.017 | 1.835 |
| 真实视频 | — | — | — | 1.193 | 1.832 |

  控制遵循（在生成视频上跑 BEVFormer 3D 检测、LATR 车道检测）：LET-AP 0.394 vs Transfer1 0.243（真实视频 0.476）；车道 F1 0.637 vs 0.604（真实 0.637）。

### 相机可控多视角（§6.4，[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=28|第 28–33 页]]）

- 输入一段参考视角视频 + N 条目标相机轨迹（内外参），输出 N 段目标视角视频；源和目标 token 沿时间拼接，相机每 4 帧采一次以对齐潜帧；目标相机用 **Plücker 射线图**、经投影层后**加到视频 token 上**（自注意力之前）；**只训自注意力层和相机投影层**。
- 两个变体：**multiview-agibot**（AgiBot 14.6 万条，头部视角 → 左右夹爪视角）；**robot/multiview**（MultiCamVideo 13.6 万 + SynCamVideo 3.4 万，第三人称视频 → 两段任意相机变换后的视频）。
- [[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=31|表 17]]（80 段视频 × 16 条轨迹）：多视角版 vs 单视角版，Sampson 误差 **19.73 vs 26.61 px**，平移误差 0.08 持平，旋转误差 0.20 vs 0.19。
- 另有 Predict2.5-2B/robot/multiview-agibot：输入三张单帧（头 + 两夹爪）+ 相机轨迹，生成三路操作视频。

### DreamGen 合成 VLA 数据（§6.5，[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=34|表 18]]）

把 14B 在 GR1 人形数据上后训练（Predict2.5-14B/robot/gr00tdream-gr1），在 [[nvidia/notes/16_DreamGen|DreamGen]] Bench 上看指令遵循（GPT-4o / Qwen2.5-VL 打分）：物体 91.8 / 69.4、行为 70.2 / 59.6、环境 69.0 / 69.0。物体和环境泛化最好；**行为维度不是最好**（GPT 打分 WAN2.1 72.3 更高，Qwen 打分 Predict2-14B 61.7 更高）。

### 动作条件世界模型（§6.6，[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=34|表 19、20，第 34–35 页]]）

- 输入一帧 + 动作序列，逐块自回归生成；动作经 MLP 嵌入后**加到时间步嵌入上**。
- Bridge（约 2 万条，320×256，5 FPS，7 维末端增量动作），测试集随机 100 条：

| 方法 | PSNR↑ | SSIM↑ | Latent L2↓ | FVD↓ |
|---|---|---|---|---|
| Predict1-7B ActionCond | 21.14 | 0.82 | 0.32 | 190 |
| **Predict2.5-2B 加到时间嵌入** | **24.95** | **0.85** | **0.28** | **146** |
| Predict2.5-2B 交叉注意力 | 24.41 | 0.84 | 0.28 | 159 |
| Predict2.5-2B 通道拼接 | 23.11 | 0.78 | 0.35 | 267 |

## 局限 / 存疑

作者自己说的很少，只提到：

- Cosmos-Reason1 的视觉编码器可以接视觉条件做风格控制，**没做**，留作以后。
- DiT 上下文有限，长视频只能分块自回归，误差会累积（RNDS 就是为量化这个提出的）。

读的时候值得核对的：

- **数据规模的两个"2 亿"（需核对）**：第 4 页说"处理了超过 2 亿条原始视频"，同一页又说过滤后得到"约 2 亿条可训练片段"，第 6 页的口径是"3500 万小时原始视频 → 60 亿片段 → 2 亿片段"。按 60 亿 × 4% 算是 2.4 亿，"约 2 亿"大致对得上；"2 亿条原始视频"和其余口径怎么换算没有说明。
- **驾驶相机命名对不上（需核对）**：§2.2.2 的 7 路是 front-wide、front-tele、left、right、rear、rear-left、rear-right；§6.3.2 是 front-wide、front-tele、front-left、front-right、rear-left、rear-right、rear-tele。两处数据集规模也不同（310 万段 vs 150 万段），可能是两套数据，但没说明。
- **驾驶多视角的提升说法（需核对）**："FVD/FID 最多提升 2.3 倍"——按表 14，Predict2.5 vs Predict1 的 FVD 是 63.7/23.1 ≈ **2.8 倍**，Transfer2.5 vs Transfer1 约 2.3 倍；"检测指标最多提升 60%"按表 15 实际是 62–65%。更值得注意的是，作者说多视角一致性"保持有竞争力"，但 **Transfer2.5 的 TSE（1.246）和 CSE（2.310）都比 Transfer1（1.017、1.835）差**，CSE 离真实视频（1.832）也更远。
- **RL 步数（需核对）**：生成时说"每个条件用 20 步扩散采样"，梯度累积处又说"整条轨迹（共十步）"；可能是"每两步算一次、共 10 组"，正文没讲清。
- **14B 的价值主要靠人评支撑**：PAI-Bench 上后训练 2B 和 14B 的 Overall 完全相同（T2W 0.768、I2W 0.810），预训练时 14B 也只高 0.006–0.007；所有自动指标的差距都在千分位，没有方差或置信区间。人评没给标注人数和样本量。
- **"14B 只有 Wan2.2-27B-A14B 一半参数"**：Wan2.2-27B-A14B 是 MoE（两个专家各 14B，每步激活 14B），按激活参数其实相当。
- **真机实验样本很小**：每个场景 3 次、物体位置固定，24/30 vs 5/30 差距大是可信的，但单场景之间比较（如米色桌布 1/3、组合场景 3/3——组合里本来就包含米色桌布）说明噪声不小。只有一个任务、一种策略（Diffusion Policy）。
- **Transfer 质量分的反常**：四模态融合的质量分 9.31 反而低于只用 Blur 的 9.75；表注说"多模态用空间均匀权重"，没探索更好的加权。
- **多视角相机控制的命名混乱**：表 16 和正文写的是"Cosmos-Predict2.5 支持 3 视角相机控制"，但模型名是 Transfer2.5-2B/robot/multiview；表 1 里 Predict2.5-2B/robot/multiview-agibot 和 Transfer2.5-2B/robot/multiview-agibot 输入不同（单帧 vs 头部视频）。读的时候注意区分是"从单帧预测"还是"从视频重渲"。
- **很多应用对照的是自家上一代**：动作条件、驾驶、Transfer 都只和 Predict1 / Transfer1 比，没有和 Wan-Fun-Control 等外部控制模型比；外部第三方对比可以看 [[topics/notes/代码世界模型与神经渲染/3-06_PROWBench|PROWBench]]、[[topics/notes/代码世界模型与神经渲染/2-09_SolarRenderer|SolarRenderer]]、[[topics/notes/代码世界模型与神经渲染/2-16_RoboRender|RoboRender]] 里把 Transfer2.5 当基线的结果。
- **动作条件模型只在 Bridge 上、只看画面指标**（PSNR/SSIM/FVD），没有做"用它评估策略、和真机成功率相关性"这类实验，而引言把它定位为"策略验证"工具。
- **RL 奖励模型和评测有重叠**：RL 优化的 VideoAlign 奖励（表 6）本身就是汇报的指标之一；独立证据是人评（图 5）。
- 许可证：摘要写 NVIDIA Open Model License（模型和代码），arXiv 论文本身是 CC BY 4.0。

## 与其他论文的关系

- **Cosmos 系列主线**：[[nvidia/notes/08_Cosmos|Cosmos（Predict1）]] → 本文 Predict2.5（中间的 Predict2 没有单独论文，表 18 里出现过 Predict2-14B/gr00tdream-gr1，区别是没用 Reason1 文本嵌入）→ [[nvidia/notes/41_Cosmos-3|Cosmos 3]]（MoT 全模态）。控制网线：[[nvidia/notes/11_Cosmos-Transfer1|Cosmos-Transfer1]] → Transfer2.5。文本编码器来自 [[nvidia/notes/13_Cosmos-Reason1|Cosmos-Reason1]]。
- **以 Predict2.5 为底座的后续工作**：[[nvidia/notes/33_DreamDojo|DreamDojo]]（人类视频预训练的通用机器人世界模型）、[[nvidia/notes/52_GR00T-2|GR00T 2]]（基于 Predict2.5-2B 的世界动作模型）；同思路但基于 Predict2 的有 [[nvidia/notes/32_Cosmos-Policy|Cosmos Policy]]。驾驶方向可对照 [[nvidia/notes/19_Cosmos-Drive-Dreams|Cosmos-Drive-Dreams]]、[[nvidia/notes/42_OmniDreams|OmniDreams]]；手术方向 [[nvidia/notes/31_Cosmos-H-Surgical|Cosmos-H-Surgical]]、[[nvidia/notes/51_Cosmos-H-Dreams|Cosmos-H-Dreams]]、[[nvidia/notes/23_Cosmos-Surg-dVRK|Cosmos-Surg-dVRK]]。
- **应用对应的前作**：§6.5 合成 VLA 数据即 [[nvidia/notes/16_DreamGen|DreamGen]] 的流程（视频 → IDM / 潜动作伪标注）；数据里的 GR00T 来自 [[nvidia/notes/12_GR00T-N1|GR00T N1]]；驾驶的 RDS-HQ、世界场景图沿用 Cosmos-Drive-Dreams 一系（Ren et al. 2025）；相机控制沿用 GEN3C 一系（Ren et al. 2025）。
- **技术来源**：flow matching（Lipman）与 shifted logit-normal 时间步（SD3，Esser et al.）；WAN2.1 VAE；多层文本特征拼接（Wang et al. 2025）；模型合并（model soup、TIES、DARE）；视频 RL 用 VideoAlign 奖励 + GRPO（细节在 Ye et al. 2025）；蒸馏 rCM（Zheng et al. 2025）；Plücker 射线图相机表示；评测 PAI-Bench（Zhou et al. 2025）、VBench、DOVER。
- **同期开源视频底座对照**：Wan2.1 / Wan2.2、HunyuanVideo、CogVideoX、LTX。
- **作为第三方基线**：[[topics/代码世界模型与神经渲染|代码世界模型与神经渲染]] 专题里，Transfer2.5 常被当作"结构条件 → RGB"渲染器的基线（PROWBench、SolarRenderer、RoboRender 等），可以看外部视角下它的强弱。

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
<!-- highlights:end -->

> [!quote]- 初稿依据（10 处原文位置；论文 CC BY 4.0，这里只记位置和要点，原句请点页码看）
> 1. [[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=3|第 3 页]]引言：相对 Predict1 的三项改进（数据、统一模型、训练配方 + Reason1 替代 T5） → 要解决的问题
> 2. [[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=4|第 4 页]]、[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=6|第 6 页]] §2.1：200M 原始视频 / 35M 小时 / 60 亿片段 / 存活率 30%→4% / 约 2 亿片段 → 数据规模与"需核对"
> 3. [[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=8|第 8 页]] §3.1 式 (1)–(4)：flow matching 与 shifted logit-normal → 训练目标
> 4. [[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=9|第 9 页]] §3.2 与表 3：去掉绝对位置编码、WAN2.1 VAE 4×8×8、93 帧 / 24 潜帧、Reason1 多层特征拼接投影到 1024 维 → 结构
> 5. [[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=10|第 10 页]]–[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=11|第 11 页]] §4.1 与表 4：渐进式预训练、β 1→5、5% 样本取自最高 2% 噪声 → 预训练
> 6. [[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=11|第 11 页]]–[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=13|第 13 页]] §4.2：分领域 SFT、4K 冷却、model soup、VideoAlign + GRPO、20 步 vs "十步" → 后训练与"需核对"
> 7. [[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=16|第 16 页]] 表 10、11 与人评段：0.768 / 0.810，48.6% vs 31.8% → 基础模型结果
> 8. [[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=18|第 18 页]]–[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=19|第 19 页]] §6.1 与表 12：控制块每 7 块插一个、3.5× 更小、四模态分数 → Transfer2.5
> 9. [[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=23|第 23 页]] 表 13：1/30、5/30、24/30 → 真机数据增强
> 10. [[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=7|第 7 页]] §2.2.2 与 [[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=25|第 25 页]] 表 14、[[nvidia/papers/24_2511.00062_Cosmos-Predict2.5-Transfer2.5.pdf#page=28|第 28 页]] §6.3.3：两处 7 路相机名单不同、TSE/CSE 变差、"2.3 倍""60%" → 驾驶结果与存疑点

## 摘要（中文）

我们推出 Cosmos-Predict2.5，面向物理 AI 的最新一代 Cosmos 世界基础模型。它基于 flow 架构，在单个模型中统一了 Text2World、Image2World 和 Video2World 生成，并借助物理 AI 视觉语言模型 Cosmos-Reason1 提供更丰富的文本 grounding 和更精细的世界模拟控制。Cosmos-Predict2.5 在 2 亿段精选视频上训练，再经基于强化学习的后训练改进，在视频质量和指令对齐上相比 Cosmos-Predict1 有显著提升，发布 2B 和 14B 两种规模。这些能力让机器人和自动驾驶系统的合成数据生成、策略评估和闭环仿真更加可靠。我们还用 Cosmos-Transfer2.5 扩展了这一家族，它是一个用于 Sim2Real 和 Real2Real 世界转换的控制网式框架，虽然比 Cosmos-Transfer1 小 3.5 倍，却能提供更高保真度和稳健的长时程视频生成。这些进展让 Cosmos-Predict2.5 和 Cosmos-Transfer2.5 成为扩展具身智能的通用工具。为加速物理 AI 的研究和部署，我们以 NVIDIA Open Model License 发布源代码、预训练权重和精选基准，希望这些开放资源能降低使用门槛，促进下一代具身智能的创新。

## 摘要（原文）

> We introduce [Cosmos-Predict2.5], the latest generation of the Cosmos World Foundation Models for Physical AI. Built on a flow-based architecture, [Cosmos-Predict2.5] unifies Text2World, Image2World, and Video2World generation in a single model and leverages [Cosmos-Reason1], a Physical AI vision-language model, to provide richer text grounding and finer control of world simulation. Trained on 200M curated video clips and refined with reinforcement learning-based post-training, [Cosmos-Predict2.5] achieves substantial improvements over [Cosmos-Predict1] in video quality and instruction alignment, with models released at 2B and 14B scales. These capabilities enable more reliable synthetic data generation, policy evaluation, and closed-loop simulation for robotics and autonomous systems. We further extend the family with [Cosmos-Transfer2.5], a control-net style framework for Sim2Real and Real2Real world translation. Despite being 3.5$\times$ smaller than [Cosmos-Transfer1], it delivers higher fidelity and robust long-horizon video generation. Together, these advances establish [Cosmos-Predict2.5] and [Cosmos-Transfer2.5] as versatile tools for scaling embodied intelligence. To accelerate research and deployment in Physical AI, we release source code, pretrained checkpoints, and curated benchmarks under the NVIDIA Open Model License at this https URL and this https URL. We hope these open resources lower the barrier to adoption and foster innovation in building the next generation of embodied intelligence.
