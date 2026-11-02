# 自变量机器人（X Square Robot）公开论文与技术报告汇总

> 整理日期：2026-11-02
> 来源：自变量官网（x2robot.com 的 Blog / Open Source / News）、GitHub 组织 [X-Square-Robot](https://github.com/X-Square-Robot)、Hugging Face 组织 [x-square-robot](https://huggingface.co/x-square-robot)、arXiv、OpenAlex（按作者单位检索）。
> 日期一般取 arXiv v1 提交月份。
> 本地 PDF：全部 23 篇已下载到 [papers/](papers/) 文件夹（约 250 MB），文件名开头的编号对应下表中的 #。

## 一、自变量主导的论文 / 技术报告（官方发布）

### 具身基础模型（WALL 系列）

| # | 日期 | 标题 | 论文 | 代码 / 模型 / 项目页 |
|---|---|---|---|---|
| 1 | 2025-09 | **Igniting VLMs toward the Embodied Space**（WALL-OSS 技术报告） | [arXiv:2509.11766](https://arxiv.org/abs/2509.11766) | [wall-x](https://github.com/X-Square-Robot/wall-x) · [wall-oss-flow](https://huggingface.co/x-square-robot/wall-oss-flow) · [wall-oss-fast](https://huggingface.co/x-square-robot/wall-oss-fast) · [项目页](https://x2robot.com/en/research/68bc2cde8497d7f238dde690) |
| 2 | 2026-05 | **Wall-OSS-0.5 Technical Report** | [arXiv:2605.30877](https://arxiv.org/abs/2605.30877) · [官网 PDF](https://x2robot.com/api/files/file/WALL-OSS_0.5.pdf) | [wall-x](https://github.com/X-Square-Robot/wall-x) · [wall-oss-0.5](https://huggingface.co/x-square-robot/wall-oss-0.5) · [项目页](https://x2robot.com/oss) |
| 3 | 2026-06 | **WALL-WM: Carving World Action Modeling at the Event Joints**（世界动作模型） | [arXiv:2606.01955](https://arxiv.org/abs/2606.01955) · [官网 PDF](https://x2robot.com/api/files/file/WALL-WM.pdf) | [wall-wm](https://github.com/X-Square-Robot/wall-wm) · [项目页](https://x2robot.com/pages/wm) |
| 4 | 2026-08 | **WALL-SS: Scaling Long-horizon World Models via Next-Scale Autoregression**（生成式世界模型 / 仿真） | [arXiv:2608.26239](https://arxiv.org/abs/2608.26239) · [官网 PDF](https://x2robot-open.oss-cn-shenzhen.aliyuncs.com/ARWM%20OPEN/WALL-SS.pdf) | [wall-ss](https://github.com/X-Square-Robot/wall-ss) · [项目页](https://x2robot.com/pages/ss) |

### 动作表征、规划与训练基础设施

| # | 日期 | 标题 | 论文 | 代码 / 模型 / 项目页 |
|---|---|---|---|---|
| 5 | 2026-06 | **X-Tokenizer: A Multimodal Action Tokenizer for Vision-Language-Action Pretraining**（与港城大、清华合作） | [arXiv:2606.14752](https://arxiv.org/abs/2606.14752) | [X-Tokenizer](https://github.com/X-Square-Robot/X-Tokenizer) · [HF 模型](https://huggingface.co/x-square-robot/X-Tokenizer) · [项目页](https://x-square-robot.github.io/X-Tokenizer_projectPage/) |
| 6 | 2026-06 | **DMuon: Efficient Distributed Muon Training with Near-Adam Overhead**（分布式优化器） | [arXiv:2606.27153](https://arxiv.org/abs/2606.27153) | [dmuon](https://github.com/X-Square-Robot/dmuon) · [文档](https://x-square-robot.github.io/dmuon/) |
| 7 | 2026-09 | **X-Planner: Event-Structured Task Planning for Embodied Intelligence** | [arXiv:2609.25187](https://arxiv.org/abs/2609.25187) | [Xplanner](https://github.com/X-Square-Robot/Xplanner) · [X-Planner-9B](https://huggingface.co/x-square-robot/X-Planner-9B-0916) · [benchmark](https://huggingface.co/datasets/x-square-robot/xplanner-benchmark) · [项目页](https://x-square-robot.github.io/Xplanner/) |

### 数据采集、技能学习与评测

| # | 日期 | 标题 | 论文 | 代码 / 数据 / 项目页 |
|---|---|---|---|---|
| 8 | 2026-04 | **XRZero-G0: Pushing the Frontier of Dexterous Robotic Manipulation with Interfaces, Quality and Ratios**（免机器人数据采集 + 2000 小时数据集） | [arXiv:2604.13001](https://arxiv.org/abs/2604.13001) | [XRZero-G0](https://github.com/X-Square-Robot/XRZero-G0) · [数据集](https://huggingface.co/datasets/x-square-robot/XRZero-G0-3K) · [项目页](https://x2robot.com/x2go) |
| 9 | 2026-07 | **HOST: Robots Acquire Manipulation Skills in Seconds from a Single Human Video**（与北理工、清华合作） | [arXiv:2607.20033](https://arxiv.org/abs/2607.20033) | [HOST](https://github.com/CGuangyan-BIT/HOST) · [项目页](https://x2robot.com/pages/host) |
| 10 | 2026-09 | **X2Real: an eXtensive simulation benchmark for real-world generalist policies**（基于 Isaac Lab-Arena 的仿真评测基准） | [arXiv:2609.27449](https://arxiv.org/abs/2609.27449) | [x2real](https://github.com/X-Square-Robot/x2real) · [数据集](https://huggingface.co/datasets/x-square-robot/X2Real-Dataset) · [项目页](https://x2robot.com/en/pages/x2real) |

### 语音交互（X2 语音系列）

| # | 日期 | 标题 | 论文 | 代码 / 模型 |
|---|---|---|---|---|
| 11 | 2026-08 | **X2-Turn: Frame-Synchronous Dual-Head Modeling for Joint Streaming ASR and Turn State Prediction** | [arXiv:2608.10878](https://arxiv.org/abs/2608.10878) | [X2-Turn](https://github.com/X-Square-Robot/X2-Turn) · [X2-Turn-4B](https://huggingface.co/x-square-robot/X2-Turn-4B-0812) · [Demo](https://huggingface.co/spaces/x-square-robot/x2-turn-4b-demo) |
| 12 | 2026-08 | **X2Streaming-TTS: Causal Token-Level Text-to-Speech from Streaming Text with Speech-State Inheritance** | [arXiv:2608.18661](https://arxiv.org/abs/2608.18661) | [X2Streaming-TTS](https://github.com/X-Square-Robot/X2Streaming-TTS) · [HF 模型](https://huggingface.co/x-square-robot/X2Streaming-TTS-1.7B) |
| 13 | 2026-09 | **X2-NativeCursor: Native-Token Text Progress Tracking for Incremental-Text Streaming Codec TTS** | [arXiv:2609.09677](https://arxiv.org/abs/2609.09677) | [HF 模型](https://huggingface.co/x-square-robot/X2-NativeCursor-Qwen3TTS-12Hz)（代码在 X2Streaming-TTS 仓库） |
| 14 | 2026-09 | **X2Streaming-ASR: wait when uncertain, emit when ready for streaming ASR** | [arXiv:2609.08672](https://arxiv.org/abs/2609.08672) | [X2Streaming-ASR](https://github.com/X-Square-Robot/X2Streaming-ASR) · [HF 模型](https://huggingface.co/x-square-robot/X2Streaming-ASR-4B-1009) |

## 二、与高校合作、署名含自变量的论文

这些论文的作者单位中有 X Square Robot，但大多不在官网或官方 GitHub 列出。

| # | 日期 | 标题 | 发表 | 合作单位 |
|---|---|---|---|---|
| 15 | 2026-03 | **ManipArena: A Controlled Benchmark for Diagnosing Generalization in Real-Robot Manipulation** | [arXiv:2603.28545](https://arxiv.org/abs/2603.28545) | 中山大学、MBZUAI、清华；自变量作者占多数（含 Qian Wang、Hao Wang、Ruyi Gan） |
| 16 | 2026-07 | **Integrated Hierarchical Decision-Making in Inverse Kinematic Planning and Control** | RSS 2026 · [DOI](https://doi.org/10.15607/rss.2026.xxii.185) · 预印本 [arXiv:2412.01324](https://arxiv.org/abs/2412.01324) | 西交利物浦、CNRS（自变量作者：Yuquan Wang） |
| 17 | 2026-08 | **Identity-Faithful Audio-Visual Target Speaker Extraction with REAL-2MIX and VOXBLINK2-AVSE** | [arXiv:2608.03964](https://arxiv.org/abs/2608.03964) | 港中大（深圳）（自变量作者：Xiaoyi Qin、Ruyi Gan 等） |
| 18 | 2026-09 | **Full-Duplex Speech Models Take the Floor When Asked, Not When Needed** | [arXiv:2609.19596](https://arxiv.org/abs/2609.19596) | UConn、UT Austin、牛津（自变量作者：Kaiqi Fu） |
| 19 | 2026-09 | **DualTrack: Synchronized Speech–Gesture Generation via Symmetric Coupling of Pretrained Priors** | [arXiv:2609.36624](https://arxiv.org/abs/2609.36624) | 港中大（深圳） |
| 20 | 2026-09 | **WSM-Aware HRI: An IoT-Enhanced Framework for Early Detection and Norm-Guided Repair of Failures with LLM Guidance** | [arXiv:2609.32336](https://arxiv.org/abs/2609.32336) · ACM THRI 2026-10 · [DOI](https://doi.org/10.1145/3858343) | 港中大（深圳）、深圳市人工智能与机器人研究院（自变量作者：Yuquan Wang） |
| 21 | 2026-10 | **LatentQuant: Preserving the Policy-Facing Latent Contract under NVFP4 VAE Quantization** | [arXiv:2610.03959](https://arxiv.org/abs/2610.03959) | UCSD、中山大学、国科大、港科大（广州） |
| 22 | 2026-10 | **Compact Robot Policies Need Fine-Grained Visual Representations** | [arXiv:2610.08183](https://arxiv.org/abs/2610.08183) | KTH（自变量作者：Yuquan Wang） |
| 23 | 2026-10 | **EgoJEPA: Beyond Retargeting for Dexterous Manipulation from Egocentric Videos** | [arXiv:2610.20904](https://arxiv.org/abs/2610.20904) | MBZUAI、上海交大、Xense Robotics |

## 三、已发布但暂无论文 / 技术报告

| 项目 | 时间 | 状态 |
|---|---|---|
| **TwinDEX**（三指 9 自由度孪生灵巧手采集/部署系统） | 2026-09-02 | [项目页](https://x2robot.com/pages/twindex) 标注 "Paper (coming soon)" |
| **WALL-A**（闭源具身基础模型） | 据报道 2024-10 | 仅有新闻稿，未公开技术报告 |
| **WALL-B**（"世界统一模型" WUM） | 2026-04-21 | 仅发布会与新闻稿，未找到技术报告 |
| **WALL-OSS 1.0 Lite — RoboDojo** | 2026-10-23 | 仅 [HF 模型卡](https://huggingface.co/x-square-robot/wall-oss-1.0-lite-robodojo)，无论文 |

## 检索说明

- 第二部分靠 OpenAlex 的作者单位字段，以及在 arXiv 上按约 20 位自变量作者逐一检索后核对论文 HTML 中的单位。没有 HTML 版本的论文、单位写法不同的论文可能漏掉。
- 检索中出现过的 *Muon is Scalable for LLM Training*（Moonshot）和 *InfinityStar*（字节）只是自变量仓库引用的外部论文，不算在内。
- 2025 年 9 月之前没有找到署名自变量的公开论文。唯一例外是 #16：它的 arXiv 预印本 v1 发于 2024-12，但核实过的自变量单位来自 2026 年的 RSS 版本。
- 官网另有 Wall-OSS-0.5、WALL-WM、WALL-SS 三份 PDF，内容对应 arXiv 版本，没有重复下载。
