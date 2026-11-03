---
id: "18"
org: 自变量
short: "Full-Duplex-Floor"
title: "Full-Duplex Speech Models Take the Floor When Asked, Not When Needed"
aliases: ["Full-Duplex-Floor"]
date: 2026-09-17
category: 语音交互
source: 合作
partners: ["UConn", "UT Austin", "牛津大学"]
authors: ["Linkai Peng", "Baorian Nuchged", "Kaiqi Fu", "Yuyang Yao"]
arxiv: "2609.19596"
pdf: "[[xsquare/papers/18_2609.19596_Full-Duplex-Speech-Models-Take-the-Floor.pdf]]"
code: ""
project: ""
huggingface: []
license: CC BY 4.0
status: 未读
rating:
read_date:
tags: ["paper", "speech", "full-duplex", "dialogue"]
---

# Full-Duplex Speech Models Take the Floor When Asked, Not When Needed

> [!info] 论文信息
> arXiv [2609.19596](https://arxiv.org/abs/2609.19596) · v1 2026-09-17
> PDF：[[xsquare/papers/18_2609.19596_Full-Duplex-Speech-Models-Take-the-Floor.pdf|本地 PDF]]
> 合作单位：UConn、UT Austin、牛津大学

> [!note] 下面各节是 Claude 根据论文写的初稿，读的时候请核对并改成你自己的理解。

> [!quote]- 初稿依据：原文句子与位置（点开查看）
> - 实验设计：上下文匹配独白、10 种条件、压缩停顿：“we construct context-matched English monologues in which only the trigger utterance varies within a topic, define 10 conditions from turn-allocation rules, and compress inter-word pauses to limit opportunities created by silence.”（Abstract）
> - 40 段英文独白：“We wrote 40 first-person English monologues about everyday topics.”（§3.1）
> - 词间间隔压到至多 0.12 s：“we use word-level timestamps to compress every inter-word gap to at most 0.12 s, limiting pause-based opportunities to speak.”（§3.1）
> - 核心发现：被点名和静默才是可靠触发：“Across five model families, being addressed and silence are far more reliable triggers than false facts or hazards.”（Abstract）
> - 插入静默把 onset 提到最高 .83：“inserting 1.5 s of silence raises it from at most .10 under Neutral to as much as .83.”（§4.1）
> - 内容线索与 Neutral 差距至多 0.06：“By contrast, cues that require understanding the content in order to decide whether to speak, namely false facts, verbatim repetition and hazards, differ from Neutral by at most 0.06 across the seven configurations.”（§4.1）
> - token 概率探针与行为一致：“Question and silence raise text-token probability just as they raise onset, whereas neither content cue raises the tendency to speak even at the level of token probabilities.”（§4.2）
> - 增加机会或许可都不能让内容成为开口理由：“More opportunity makes the models speak more overall, and explicit permission changes little, but neither makes a false fact or a hazard a reason to speak.”（§4.3）
> - 需要帮助的线索回复相关性低：“For the three cues that call for help, namely false fact, hazard and word search, relevance falls to between .16 and .36.”（§4.4）
> - 纠错和危险提醒比例极低：“Among non-empty false-fact replies, Moshi and PPlex challenge or correct the claim at rates of only .14 and .15. Among hazard replies, warnings appear at only .04 and .07.”（§4.4）

## 一句话总结

全双工语音模型只在被点名或出现静默时接话，遇到错误说法或危险时很少主动开口，接了话也很少纠正或提醒。

## 要解决什么问题

全双工语音模型能边听边说，但还得决定什么时候开口。人类听者除了在被点名或对方停下时说话，还会主动接话来纠错、补词或提醒危险。现有评测（如 Full-Duplex-Bench、FD-Bench、HumDial）主要关注停顿处理、话轮转换和用户发起的事件，涉及模型主动介入的 FLEXI、Instruct-FD 也没有在相同上下文中控制停顿、比较不同触发因素。

## 方法

- 条件设计：依据 Sacks、Schegloff 和 Jefferson 的话轮分配规则（turn-allocation rules），把触发句分为被点名（addressed：Question、Request、Rhetorical）、自选发言（self-select：Word search、False fact、Repeat、Hazard）和让出话轮（yield：Turn end、Silence）三组，加上 Neutral 基线共 10 种条件（见 §3.1、Table 1）
- 刺激：40 段第一人称英文独白，同一话题内只有触发句不同，触发后用户继续说话；主实验把词间间隔压到至多 0.12 s 以限制停顿带来的发言机会，另做保留自然停顿的实验（见 §3.1）
- 系统：五个模型家族、七种配置（Moshi、Moshika-RL、PersonaPlex、PPlex-RL、VoiceChat-11B、MiniCPM-o 4.5、Raon-SpeechChat），均用官方默认解码（见 §3.2）
- 测量：主指标是触发结束后 4 s 内开始至少 4 个词语音段的比例（speech-onset rate）；对 Moshi 和 PPlex 另测帧级非静默文本 token 概率；附加控制包括插入 1.5 s 静默、保留自然停顿、开场给予打断许可；最后做话轮释放实验，由 DeepSeek-V4-Flash 判断回复是否切题、是否纠正或提醒（见 §3.3、§4.2–4.4）

## 实验与关键数字

- 主结果（Table 2）：在 Moshi/PersonaPlex 四种配置中，插入 1.5 s 静默可把 onset 从 Neutral 下的至多 .10 提高到最高 .83；而错误事实、逐字重复、危险这些需要理解内容的线索，在七种配置中与 Neutral 的差距都不超过 0.06
- 另两类模式：Raon-SpeechChat 几乎持续说话，各条件差异小；VoiceChat 和 MiniCPM-o 4.5 在语音进行中几乎不开口，主要在插入静默时开口（见 §4.1）
- 文本 token 概率探针（Figure 3）：提问和静默会提高非静默文本 token 概率，两个内容线索都不会（见 §4.2）
- 增加机会或许可（Table 3）：更多停顿让模型整体更爱说话，打断许可几乎无影响，但两者都没有让错误事实或危险成为开口的理由（见 §4.3）
- 话轮释放后（Table 4）：需要提供帮助的三类线索（错误事实、危险、找词）回复相关性只有 .16–.36；Moshi 和 PPlex 纠正错误说法的比例仅 .14 和 .15，提醒危险的比例仅 .04 和 .07（见 §4.4）

## 局限 / 存疑

## 与其他论文的关系

- [[11_X2-Turn]]：同样关注对话系统何时接话；X2-Turn 在 Full-Duplex-Bench 上与 Moshi、PersonaPlex 等对比话轮表现，本文则检验这些全双工模型能否因内容主动开口

## 我的想法

## 原文摘录

<!-- 由 scripts/extract_highlights.swift 自动填写，标记之间的内容会被覆盖 -->
<!-- highlights:start -->
共 9 条

> we construct context-matched English monologues in which only the trigger utterance varies within a topic, define 10 conditions from turn-allocation rules, and compress inter-word pauses to limit op- portunities created by silence.
> 批注：Claude：实验设计：上下文匹配独白、10 种条件、压缩停顿
> — [[xsquare/papers/18_2609.19596_Full-Duplex-Speech-Models-Take-the-Floor.pdf#page=1|p.1]]

> Across five model families, being addressed and silence are far more reliable triggers than false facts or hazards.
> 批注：Claude：核心发现：被点名和静默才是可靠触发
> — [[xsquare/papers/18_2609.19596_Full-Duplex-Speech-Models-Take-the-Floor.pdf#page=1|p.1]]

> We wrote 40 first-person English monologues about everyday topics.
> 批注：Claude：40 段英文独白
> — [[xsquare/papers/18_2609.19596_Full-Duplex-Speech-Models-Take-the-Floor.pdf#page=2|p.2]]

> we use word- level timestamps to compress every inter-word gap to at most 0.12 s, limiting pause-based opportunities to speak
> 批注：Claude：词间间隔压到至多 0.12 s
> — [[xsquare/papers/18_2609.19596_Full-Duplex-Speech-Models-Take-the-Floor.pdf#page=2|p.2]]

> inserting 1.5 s of silence raises it from at most .10 un- der Neutral to as much as .83.
> 批注：Claude：插入静默把 onset 提到最高 .83
> — [[xsquare/papers/18_2609.19596_Full-Duplex-Speech-Models-Take-the-Floor.pdf#page=2|p.2]]

> Question and silence raise text-token probability just as they raise onset, whereas neither content cue raises the tendency to speak even at the level of token probabilities.
> 批注：Claude：token 概率探针与行为一致
> — [[xsquare/papers/18_2609.19596_Full-Duplex-Speech-Models-Take-the-Floor.pdf#page=3|p.3]]

> For the three cues that call for help, namely false fact, hazard and word search, relevance falls to between .16 and .36.
> 批注：Claude：需要帮助的线索回复相关性低
> — [[xsquare/papers/18_2609.19596_Full-Duplex-Speech-Models-Take-the-Floor.pdf#page=4|p.4]]

> Among non-empty false-fact replies, Moshi and PPlex challenge or correct the claim at rates of only .14 and .15. Among hazard replies, warnings appear at only .04 and .07.
> 批注：Claude：纠错和危险提醒比例极低
> — [[xsquare/papers/18_2609.19596_Full-Duplex-Speech-Models-Take-the-Floor.pdf#page=4|p.4]]

> More opportunity makes the models speak more overall, and explicit permission changes lit- tle, but neither makes a false fact or a hazard a reason to speak.
> 批注：Claude：增加机会或许可都不能让内容成为开口理由
> — [[xsquare/papers/18_2609.19596_Full-Duplex-Speech-Models-Take-the-Floor.pdf#page=4|p.4]]
<!-- highlights:end -->

## 摘要（中文）

全双工语音模型可以同时听和说，有望成为始终在线的助手，但它们也必须决定什么时候该开口。人类听者会在被点名或对方停下时说话，也会主动接话（self-select）来纠正错误说法、补上对方想不起来的词，或者提醒危险。我们想知道全双工模型是否也会这样做。

为了把“开口的理由”和“开口的机会”分开，我们构造了上下文匹配的英文独白：同一话题内只改变触发句；依据话轮分配规则定义了 10 种条件；并压缩词间停顿，以限制静默带来的发言机会。

在五个模型家族中，被点名和静默是远比错误事实或危险情境更可靠的触发因素。在触发句结束后的前 2 s 内取平均，Moshi 和 PersonaPlex 在错误事实条件下的帧级文本 token 概率低于 Neutral 条件。加入停顿或给予打断许可，也无法弥合这一差距。把话轮交给模型后，Moshi 和 PersonaPlex 能回答大多数直接提问，但在非空的错误事实回复中，质疑该说法的比例只有 .14–.15；在危险情境回复中，提醒危险的比例只有 .04–.07。

因此，本文指出了全双工模型在“是否开口”和“说什么”两方面都存在差距。要弥合这一差距，需要真正理解内容，并基于这种理解做出是否介入的决定。

## 摘要（原文）

> Full-duplex speech models listen and speak at once, promising always-on assistants. Yet they must also decide when they should speak. Human listeners speak when addressed or when the speaker stops, but also self-select to correct a false claim, supply a missing word, or warn of danger. We ask whether full-duplex models do the same. To separate the reason to speak from the opportunity, we construct context-matched English monologues in which only the trigger utterance varies within a topic, define 10 conditions from turn-allocation rules, and compress inter-word pauses to limit opportunities created by silence. Across five model families, being addressed and silence are far more reliable triggers than false facts or hazards. Frame-level text-token probabilities in Moshi and PersonaPlex are lower for false facts than for Neutral when averaged over the first 2\,s after trigger end. Pauses or permission to interrupt do not close this gap either. Given the floor, Moshi and PersonaPlex answer most direct questions, yet the proportion of non-empty false-fact replies that challenge the claim is only .14--.15, and the proportion of hazard replies that warn of danger is .04--.07. This paper thus identifies a gap in both speech initiation and response content. Closing it requires genuine content understanding and intervention decisions grounded in it.
