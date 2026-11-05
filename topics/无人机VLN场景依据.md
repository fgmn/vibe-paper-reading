---
title: 无人机 VLN 基准的场景依据
tags: [topic]
updated: 2026-11-05
---

# 无人机 VLN 基准的场景依据

[[topics/无人机VLN#六、各基准使用的场景|无人机 VLN 专题第六节]]的对比表和观察，都来自这里逐篇整理的字段。每个字段下面折叠着论文原句和所在位置；原句都核对过，确实出现在论文全文里（arXiv HTML 版，BEDI 没有 HTML 版，用的是 PDF 文字）。论文没写的字段直接省略。

## AVDN (Aerial Vision-and-Dialog Navigation)

[arXiv 2205.12219](https://arxiv.org/abs/2205.12219) · 2022-05 · [[topics/papers/视觉语言导航VLN/4-23_2205.12219_AVDN.pdf|PDF]]

- **任务**：对话导航
- **场景来源**：卫星/航拍影像
- **引擎 / 数据来源**：自建连续空间俯视无人机模拟器（从 xView 高分辨率卫星图裁剪观测）
- **场景内容**：xView 开源大规模卫星图像目标检测数据集；目的地区域从 xView 目标中采样
- **场景数**：非重叠卫星图：训练 350、Seen-val 197、Unseen-val 30、Unseen-test 65
- **面积**：卫星图平均覆盖面积 1.2 km²；起点与目的地相距 1.5 km 以内
- **地域**：xView 覆盖的城市与乡村场景（未列具体城市/国家）
- **室内外**：室外
- **轨迹长度**：平均 287 m；子轨迹平均 142–148 m
- **规模**：3,064 条轨迹（人-人对话），可拆为 6,269 条子轨迹；平均 2 轮对话
- **动作空间**：连续空间；模型输出 3D 航点 (x, y, h)，朝向随运动方向；采集时键盘 8 键 4 自由度（水平 2、高度 1、旋转 1）离散控制
- **观测**：相机朝正下方的方形俯视图（裁剪卫星图）+ 无人机朝向（数字罗盘）+ 对话历史；另记录人类注意力掩码
- **划分**：训练 / seen-val / unseen-val / unseen-test；seen 与 unseen 场景位置相距 100 km 以上
- **真机**：无真机数据/实飞；附录仅用约 200 m 高度的真实无人机图像与模拟观测做对比
- **复用**：xView 卫星数据集；任务设定沿用室内对话导航 CVDN/NDH（Thomason 2020）与 NDH-Full（Kim 2021）
- **动态因素**：无，作者指出卫星图只能提供 2D 静态场景
- **备注**：视野越界的动作被自动判为无效；假设完美控制；成功条件为终点视野中心在目的地内且 IoU>0.4

> [!quote]- 原文依据（17 句）
> - 引擎 / 数据来源（§3.1）：“The drone’s visual observations are square images generated corresponding to the drone’s view area by cropping from high-resolution satellite images in the xView dataset Lam et al. (2018), an open-source large-scale satellite image object detection dataset.”
> - 场景来源（§3.1）：“We build a simulator to simulate the drone with a top-down view area. Our simulation environment is a continuous space so that the simulated drone can move continuously to any point within the environment.”
> - 场景内容（§3.3）：“Before the start of data collection, we first sample objects in the xView dataset Lam et al. (2018) as the destination areas and pair them with randomly selected initial follower’s view areas within 1.5km distance.”
> - 场景数（Table 2）：“#areas refers to the number of non-overlapped satellite images used. Destination area-dim is the average dimension of the sampled destination areas.”
> - 面积（§3.4）：“The visual scenes in our dataset come from the xView dataset Lam et al. (2018), which covers both urban and rural scenes. The average covered area of the satellite images is 1.2 km^{2} .”
> - 地域（§3.4）：“The visual scenes in our dataset come from the xView dataset Lam et al. (2018), which covers both urban and rural scenes.”
> - 室内外（Table 1）：“modified LANI | aerial | ✗ | ✓ | ✗ | ✓ | AVDN (ours) | aerial | ✓ | ✓ | ✓ | ✓ |”
> - 轨迹长度（§3.4）：“The recorded AVDN trajectory path length has an average of 287 m , and its distribution is shown in Figure 3b. The trajectories and dialogs can be further separated into 6,269 sub-trajectories corresponding to the dialog rounds.”
> - 规模（§3.4）：“Our AVDN dataset includes 3,064 aerial navigation trajectories, each with multi-round natural language dialog. There are two rounds of dialog on average per trajectory”
> - 动作空间（§5）：“The predicted waypoint action \hat{w} is a 3-D coordinate (\hat{x},\hat{y},\hat{h}) , where (\hat{x},\hat{y}) corresponds to an position in the current view area u and \hat{h} corresponds to an altitude.”
> - 动作空间（Appendix D）：“We defined 8 keys for the control with a total of four degrees of freedoms (DoFs), where there are 2 DoFs for horizontal movement, 1 DoF for altitude control, and 1 DoF for rotation control.”
> - 观测（§5）：“The input has three modalities, the drone’s direction, images from the drone’s visual observation, and history dialogs.”
> - 观测（Appendix D）：“We design a simulator to simulate a drone flying with its onboard camera facing straight downward, as in Figure 7a.”
> - 划分（§3.4）：“We split our dataset into training, seen-validation, unseen-validation, and unseen-testing sets, where seen and unseen sets are pre-separated by making sure the area locations of the visual scenes are over 100 km apart from each other.”
> - 真机（Figure 7 / Appendix D）：“We compare the simulated drone’s visual observation from satellite images, (b), with images from a drone’s onboard camera at about 200m above ground, (c).”
> - 复用（§4）：“Following indoor dialog navigation Thomason et al. (2020); Kim et al. (2021), we introduce an Aerial Navigation from Dialog History (ANDH) task and an Aerial Navigation from Full Dialog History (ANDH-Full) task”
> - 动态因素（Limitation）：“using satellite images for simulating top-down visual observation of the drone introduces the shortcoming of having only 2D static scenes while adopting the strength of the satellite images where rich labels and visual features are included.”

## AerialVLN（含小场景版 AerialVLN-S）

[arXiv 2308.06735](https://arxiv.org/abs/2308.06735) · 2023-08 · [[topics/papers/视觉语言导航VLN/4-24_2308.06735_AerialVLN.pdf|PDF]]

- **任务**：VLN
- **场景来源**：游戏引擎合成
- **引擎 / 数据来源**：Unreal Engine 4 + AirSim
- **场景内容**：25 个城市级环境，含市中心、工厂、公园、村庄等，870 余种物体（资产来源未说明）
- **场景数**：25（AerialVLN-S 为 17 个较小场景）
- **面积**：环境平均尺寸（半径）约 3867.8 m
- **室内外**：室外
- **轨迹长度**：平均 661.8 m（AerialVLN-S 321.3 m）；平均 204 个动作，多数路径 50–240 个动作
- **规模**：8,446 条飞行路径、25,338 条指令（每条路径 3 条指令）；AerialVLN-S 3,916 路径 / 11,748 指令
- **动作空间**：离散 8 动作（4 DoF）：前进 5 m、左/右转 15°、上升/下降 2 m、左/右平移 5 m、停止
- **观测**：前视 RGB + 深度图（深度可感知 100 m），语义分割可用；模拟器可提供全景但基线只用前视
- **划分**：train / val_seen 共用 17 个场景；val_unseen 与 test 各 8 个未见场景；test 目标不公开，通过评测服务器打分
- **真机**：无真机数据；路径由持 AOPA 证书的人类飞手在模拟器中飞行采集
- **复用**：基于 AirSim 与 Unreal Engine 4；基线沿用 Seq2Seq、CMA 及 LANI 的 LingUNet
- **动态因素**：支持吹动的树叶、行驶车辆、光照变化（早/午/夜）与天气（晴/雨/雪/雾）
- **备注**：无预建导航图，未被物体占据的点均可通行；成功阈值 20 m（直升机坪尺寸）；智能体可降落在建筑上

> [!quote]- 原文依据（18 句）
> - 引擎 / 数据来源（§1）：“AerialVLN is implemented using Unreal Engine 4 [14] and Microsoft AirSim plugins [31], which enables continuous navigation and near-realistic rendering.”
> - 场景来源（Abstract）：“We develop a 3D simulator rendered by near-realistic pictures of 25 city-level scenarios.”
> - 场景内容（§1）：“In total, we have collected 25 different city-level environments, covering a variety of scenes such as downtown cities, factories, parks, and villages, including more than 870 different kinds of objects.”
> - 场景数（§5.2）：“Besides the standard dataset setting (with all 25 scenes), we also present a variant for small scenes, AerialVLN-S. It preserves the same split, but it has 17 scenes with a smaller scale and evenly-distributed path length”
> - 面积（§3）：“Considering the average size (radius) of our environment is around 3867.8 meters, this 20 metres landing area is rather small and challenging.”
> - 室内外（Abstract）：“To fill this gap and facilitate research in this field, we propose a new task named AerialVLN, which is UAV-based and towards outdoor environments.”
> - 轨迹长度（§1）：“Third, to mimic multirotor flying in real life, our AerialVLN has a much longer path than ground VLNs. On average, our AerialVLN involves a path length of 661.8 units”
> - 轨迹长度（Table 1）：“AerialVLN | 8,446 | 25,338 | Outdoor, continuous | Instruction | 4 DoF | 661.8 | 204 | 4.5k | 83 | AerialVLN-S | 3,916 | 11,748 | Outdoor, continuous | Instruction | 4 DoF | 321.3 | 115 | 2.8k | 82 |”
> - 规模（§1）：“Our AerialVLN dataset consists of 8,446 flying paths obtained by experienced human UAV pilots who hold the AOPA (Aircraft Owners and Pilots Association) certificate. We pair each path with 3 instructions annotated by AMT workers in the standard dataset setting.”
> - 动作空间（§4）：“the Move Forward action continuously moves 5 units along its current direction. The Move Left and Move Right actions continuously move 5 units along the corresponding direction, respectively. The Turn Left and Turn Right actions turn 15 degrees horizontally. The Ascend and Descend actions continuously move 2 units vertically.”
> - 动作空间（§4）：“we consider the eight most common low-level actions in UAVs: Move Forward, Turn Left, Turn Right, Ascend, Descend, Move Left, Move Right and Stop.”
> - 观测（§4）：“At each step t , the simulator outputs an RGB image v_{t}^{R} and a depth image v_{t}^{D} of its front view. Considering the outdoor environment setting, the depth sensor is allowed to perceive 100 meters ahead. In addition, semantic segments are also accessible for future usage.”
> - 划分（§5.2）：“As shown in Table 3, we assign 17 scenes for training and val_seen split, where the train set contains 16,380 instructions from 5,460 paths.”
> - 划分（§5.2）：“The val_unseen and the test split are both assigned 8 scenes, but the test split is about double the size of the val_unseen split, including 1610 paths with 4,830 instructions. Please note that the test split is built on unseen scenes as well and the goal locations for the test set will not be released.”
> - 真机（§5.1）：“In contrast to R2R [2, 4, 5], of which the ground truth trajectories are automatically generated from navigation graph, we employed experienced multirotor manipulators (AOPA licensed) to complete the flying.”
> - 复用（§4）：“Our simulator is developed based on AirSim [31] and Unreal Engine 4 [14].”
> - 复用（§6.2.1）：“LingUNet [25] is a baseline model used by previously aerial VLN task LANI.”
> - 动态因素（§4）：“The simulator supports dynamic environments, such as blowing leaves, running cars, varying illumination (morning, noon, night) and different climate patterns (sun, rain, snow, fog).”

## CityNav（环境 CityFlight）

[arXiv 2406.14240](https://arxiv.org/abs/2406.14240) · 2024-06 · [[topics/papers/视觉语言导航VLN/4-25_2406.14240_CityNav.pdf|PDF]]

- **任务**：VLN
- **场景来源**：真实城市三维重建
- **引擎 / 数据来源**：CityFlight：基于 SensatUrban 点云，用 Potree（WebGL 点云渲染器）实现，与 OpenStreetMap 同步
- **场景内容**：SensatUrban 的 Cambridge 与 Birmingham 真实 3D 扫描点云；目标点与描述取自 CityRefer（5,800 个物体的 35,196 条表达）
- **场景数**：34（train/val-seen 共用 24 个，val-unseen 4 个，test-unseen 6 个）
- **面积**：4.65 km²
- **地域**：英国 Cambridge 与 Birmingham 两座真实城市
- **室内外**：室外
- **飞行高度**：最高可飞 200 m；起点高度随机 100–150 m；人类飞行平均高度 35.96 m
- **轨迹长度**：起点到目标 50–500 m，典型约 200 m；平均 240 个动作
- **规模**：32,637 条人类示范轨迹（各配 1 条描述），171 名标注者
- **动作空间**：离散 6 动作：前进 5 m、左/右转 30°、上升/下降 2 m、停止；位姿为 5D (x,y,z,pitch,yaw)
- **观测**：按位姿渲染的视图（基线用 RGB + 深度）+ 文本描述；可提供任意精度 GNSS 与 OpenStreetMap 地图/地标分割（构建 GSM 语义地图）；目标绝对坐标不提供
- **划分**：train 22,002 / val-seen 2,498 共用 24 个场景；val-unseen（2,826，4 个场景）与 test-unseen（5,311，6 个场景）为训练未见场景
- **复用**：SensatUrban 点云、CityRefer 目标描述、OpenStreetMap、Potree；动作空间沿用 AerialVLN
- **动态因素**：环境本身未述动态元素；附录另造 2D 洪水淹没模拟数据，更多动态场景留待未来
- **备注**：作者承认覆盖范围相对全球城市仍有限，扩展受户外 3D 扫描成本制约；目标类型 48.3% 建筑、40.7% 车辆、7.4% 地面、3.6% 停车场

> [!quote]- 原文依据（23 句）
> - 场景来源（§1）：“To support this, we developed CityFlight, a realistic environment for flight simulation based on real-world 3D scan data.”
> - 引擎 / 数据来源（§3.1）：“CityFlight is implemented with Potree [41], an open-source WebGL-based point cloud renderer. This enables 3D scene visualization in a web browser and thereby supports crowdsourced data collection via manual UAV operation.”
> - 引擎 / 数据来源（§3.1）：“To provide a realistic environment for flight simulation, we develop CityFlight on real-world 3D scan data. As shown in Figure 2, this environment is synchronized with OpenStreetMap to allow agents to verify their location.”
> - 场景内容（§3.1）：“We build CityFlight upon 3D point cloud data of Cambridge and Birmingham obtained from SensatUrban [18] because this data is derived from real-world 3D scans, accurately representing actual cityscapes”
> - 场景内容（§3.2）：“To select candidate goal points, we use the CityRefer dataset [35], which provides 35,196 natural language expressions for 5,800 objects in the SensatUrban dataset.”
> - 场景数（§5.1）：“The train and val-seen subsets, which contain 22,002 and 2,498 descriptions, respectively, share the same 24 scenes. The val-unseen (2,826 descriptions, 4 scenes) and test-unseen (5,311 descriptions, 6 scenes) subsets”
> - 面积（Abstract）：“Our dataset consists of 32,637 human demonstration trajectories, each paired with a natural language description, covering 4.65 km2 across two real cities: Cambridge and Birmingham.”
> - 地域（§1）：“we introduce CityNav, the first large-scale real-world 3D dataset for aerial VLN, which covers 4.65 km2 across two real cities: Cambridge and Birmingham.”
> - 室内外（Table 1）：“AVDN [13] | ✓ | Aerial | Outdoor | 3,064 | 6,269 | 0.9M | 3 DoF | 3.3k | AerialVLN [29] | | Aerial | Outdoor | 8,446 | 25,338 | 5.6M | 4 DoF | 4.5k | CityNav (Ours) | ✓ | Aerial | Outdoor | 32,637 | 32,637 | 17.8M | 4 DoF | 6.4k |”
> - 飞行高度（§3.1）：“this environment is synchronized with OpenStreetMap to allow agents to verify their location. UAVs can fly up to an altitude of 200 meters during navigation.”
> - 飞行高度（§3.2）：“The starting point is randomly chosen within a 500-meter radius of the goal on the map. The altitude is randomly set between 100 and 150 meters.”
> - 飞行高度（Appendix B）：“Given that the average 3D altitude is 35.96 meters, this result indicates that most human operators flew above building-level heights, gradually descending as they approached their targets.”
> - 轨迹长度（§3.4）：“Figure 4 shows the distribution of distances from the starting point to the goal. The distance varies from 50 meters to 500 meters, with a typical distance of around 200 meters.”
> - 轨迹长度（§3.4）：“Figure 6 shows the distribution of the number of actions required to reach the goal. The average number of actions is 240.”
> - 规模（§3.3）：“A total of 171 annotators who passed the qualification test contributed to the data collection, resulting in 32,637 high-quality description-trajectory pairs.”
> - 动作空间（§3.1）：“The move-forward action moves the UAV forward by 5 meters in the direction it is facing. The turn-left and turn-right actions rotate the UAV by 30 degrees counterclockwise and clockwise, respectively. The ascend and descend actions move the UAV up and down by 2 meters, respectively.”
> - 观测（§3.1）：“Our simulator can provide UAVs with absolute GNSS coordinates at any level of precision, which they may use during navigation. However, our CityNav setting assumes that the absolute coordinates of the goal are not available, in line with existing VLN settings.”
> - 观测（Appendix C.1）：“It utilizes four input modalities: RGB images, depth images, GSM images, and textual navigation descriptions.”
> - 观测（§3.1）：“Specifically, we offer 1) a function to convert between 3D coordinates in the environment and real-world 2D map coordinates, and 2) a function to obtain segments from landmark names.”
> - 划分（§5.1）：“consist of distinct scenes not encountered during training, enabling evaluation of the model’s generalizability to novel scenarios.”
> - 复用（§3.1）：“These actions are chosen for their effectiveness in aerial VLN [29], as they balance simplicity and expressiveness.”
> - 动态因素（Appendix D）：“We created 2D simulation data for flood scenarios. Table 7 summarizes the navigation performance. As shown, all models exhibit reduced performance; however, the effectiveness of GSM remains. Simulating other types of disasters and more dynamic scenarios is left for future work.”
> - 备注（§6 Limitations）：“Although CityNav spans large areas of two real cities, its coverage remains limited when compared to cities worldwide. Expanding the dataset to cover more urban regions would require reducing the cost of conducting 3D scans of outdoor environments.”

## AeroVerse（AeroSimulator / AerialAgent-Ego15k / CyberAgent-Ego500k / SkyAgent-*3k）

[arXiv 2408.15511](https://arxiv.org/abs/2408.15511) · 2024-08 · [[topics/papers/无人机VLN/1-04_2408.15511_AeroVerse.pdf|PDF]]

- **任务**：具身问答
- **场景来源**：混合（UrbanScene3D 真实城市三维重建场景载入 UE4 仿真 + UrbanBIS 真实航拍影像用于预训练）
- **引擎 / 数据来源**：Unreal Engine 4 + AirSim（AeroSimulator）
- **场景内容**：仿真场景取自 UrbanScene3D 的 4 个场景：Shanghai、Shenzhen、School、Residence；真实图像取自 UrbanBIS 航测照片（Lihu、Longhua、Yingrenshi、Yuehai 区域，共 15,094 张，随机选 10,000 张）
- **场景数**：4（作者称已扩展到 20 个真实城市场景）
- **面积**：1.0×10^5 至 3.7×10^7 m²：Shanghai 3,700 公顷（6,850 个物体）、Shenzhen 300 公顷（1,126）、校园 130 公顷（178）、住宅区 30 公顷（34）
- **地域**：上海、深圳、某校园、某住宅区（UrbanScene3D）；UrbanBIS 的 Lihu、Longhua、Yingrenshi、Yuehai
- **室内外**：室外
- **飞行高度**：SkyAgent-Act3k 飞行高度限制在 30 m 以内；AeroSimulator 内置禁飞设置（不得低于 30m 或高于 50m）
- **轨迹长度**：SkyAgent-Act3k 动作序列长度多为 50–150 步，平均 82 步；起终点间至少隔 10 栋建筑
- **规模**：AerialAgent-Ego15k（15,094 张真实航拍图）、CyberAgent-Ego500k（500K 图像-文本-位姿）、五个约 3k 的指令数据集（Scene3k、Reason3k、Nav3k、Plan3k、Act3k）
- **动作空间**：离散 8 个低层动作：前进 5 m、左/右转 15°、上升/下降 1 m、左/右平移 1 m、停止；模拟器本身也支持连续位置/姿态/速度控制
- **观测**：AirSim 无人机 5 个相机（前、后、左、右、俯视），各有 RGB/深度/语义分割三种模式（1920×1080）；任务输入为多视角图像、深度图、相机位姿与无人机位姿
- **划分**：按四个城市场景分别报告测试集结果，具体训练/测试划分方式未说明
- **真机**：AerialAgent-Ego15k 为真实航拍图像；作者称已在实体无人机上做初步部署，实现真实城市中的自主感知与导航（未给数量）
- **复用**：UrbanScene3D（仿真场景）、UrbanBIS（真实航拍图）、AirSim、Unreal Engine 4；LLaVA-1.5-13B 生成图像描述
- **动态因素**：支持光照（白天、傍晚、夜晚）、季节（春夏秋冬）与天气（晴、多云、小雪等）变化；未提行人车辆
- **备注**：下游指令数据由 10 名受训标注员历时 8 个月在仿真城市中操控无人机采集标注；做了相机倾斜与运动模糊增强；作者承认仅 4 个城市场景、缺乏乡村/山地/海岸场景。

> [!quote]- 原文依据（31 句）
> - 场景来源（§IV Simulator）：“we select four representative scenes from the high-quality UrbanScene3D dataset[18] created by Lin et al.: Shenzhen, Shanghai, School, and Residence, all derived from 3D reconstructions of actual physical locations.”
> - 场景来源（§V-A）：“The first-person view images of real cities captured by drones are derived from the UrbanBIS dataset, which is collected using aerial photogrammetry and encompasses a wide array of urban scenes.”
> - 引擎 / 数据来源（§IV Simulator）：“To simulate a realistic drone flight scenario, we utilize Unreal Engine 4 to load urban environments and select AirSim[17] for constructing the drone model.”
> - 场景内容（§I）：“These datasets are constructed using our established simulation platform, AeroSimulator, which employs Unreal Engine 4, the Microsoft AirSim drone simulator[17], and the 3D UrbanScene virtual city dataset[18].”
> - 场景内容（§V-A）：“We have requested images from the authors for the regions of Lihu, Longhua, Yingrenshi, and Yuehai, with resolutions of 6000\times 4000 , 8192\times 5640 , 5472\times 3648 , and 5472\times 3648 , respectively, yielding a total of 15,094 images.”
> - 场景数（Abstract）：“We develop AeroSimulator, a simulation platform that encompasses four realistic urban scenes for UAV flight simulation.”
> - 场景数（§VIII Limitations）：“We have already expanded our platform to include 20 high-fidelity 3D real-world urban scenes, significantly increasing the benchmark’s richness and the potential for model generalization.”
> - 面积（§I）：“This encompasses four real-world urban scenarios, i.e., Shanghai, Shenzhen, School, and Residence, with a coverage area ranging from 1.0\times 10^{5} to 3.7\times 10^{7}m^{2} .”
> - 面积（§IV Scenes）：“Among the cities, Shanghai presents the most extensive urban scene, featuring 6,850 objects and covering an area of 3,700 hectares.”
> - 面积（§IV Scenes）：“the campus area, which spans 130 hectares and contains 178 objects, and the residential zone, covering 30 hectares with 34 objects, focus on localized environments”
> - 地域（Fig. 3 caption）：“This simulator features four realistic urban environments: Shanghai, Shenzhen, a school, and a residential area.”
> - 地域（§V-A）：“We have requested images from the authors for the regions of Lihu, Longhua, Yingrenshi, and Yuehai”
> - 室内外（§II-A）：“we have pioneered the development of a constructed 3D dataset that emphasizes large-scale urban scenes.”
> - 飞行高度（§V-G）：“This task involves recording the dense motion sequence and orientation of the drone, with a particular emphasis on its flight path. Consequently, we restrict the drone’s flight altitude to within 30 meters.”
> - 飞行高度（§VIII Technology Ethics）：“We have built no-fly zone settings into AeroSimulator (drones must not fly below 30m or above 50m).”
> - 轨迹长度（§V-G）：“Figure 9 (c) indicates that the lengths of motion sequences in the dataset predominantly range from 50 to 150, significantly exceeding the action lengths of intelligent agents in existing indoor scenarios.”
> - 轨迹长度（§V-G）：“The average length of the action sequences depicted in Figure 9 (e) is 82 , further emphasizing that our dataset focuses on long-distance drone flights in large-scale urban environments.”
> - 轨迹长度（§V-G）：“there must be a minimum of ten buildings situated between the starting and ending points, with these buildings not aligned on the same straight line.”
> - 规模（§I）：“This dataset contains 500K aligned UAV postures, first-person view images, and text descriptions, collected from four 3D urban environments.”
> - 规模（Fig. 1 caption）：“comprises one simulation platform (AeroSimulator), two real-virtual pre-training datasets (AerialAgent-Ego15k and CyberAgent-Ego500k), five downstream task instruction datasets (SkyAgent-Scene3k, SkyAgent-Reason3k, SkyAgent-Nav3k and SkyAgent-Plan3k, and SkyAgent-Act3k”
> - 动作空间（§IV Actions）：“we have preliminarily identified the eight most common low-level actions for drones: forward, left turn, right turn, ascend, descend, left shift, right shift, and stop.”
> - 动作空间（§IV Actions）：“the “forward movement” action propels the drone continuously for 5 meters in the current direction, while the “left movement” and “right movement” actions shift the drone continuously for 1 meter in their respective directions.”
> - 动作空间（§IV Actions）：“The left and right rotation actions enable horizontal rotation by 15 degrees, and the ascending and descending actions allow vertical movement for 1 meter.”
> - 观测（§IV Observations）：“In the simulator, the drone is generated using AirSim, which features five built-in cameras: forward, backward, left, right, and overhead views. Each camera operates in three modes:”
> - 观测（§III）：“Input: Multi-perspective 2D images of urban 3D scenes, including I_{t}=\{i_{t,k}\}_{k=1}^{K} , depth map D_{t}=\{d_{t,k}\}_{k=1}^{K} , multi-perspective camera pose”
> - 划分（Table I）：“TABLE I: Evaluation results on the shanghai city test dataset:SkyAgent-Scene3k, SCENE refers to LLM-JUDGE-SCENE. City \rightarrow | ShangHai | ShenZhen | Campus | Residence |”
> - 真机（§VIII Bridging Simulation to the Real World）：“An aerospace embodied world model trained on the AeroVerse benchmark is successfully deployed on a physical UAV, achieving autonomous perception and navigation in real urban scenarios.”
> - 真机（§V-A）：“From this dataset, we randomly selected 10,000 images to serve as first-person view representations of real cities captured by drones.”
> - 复用（§IV Scenes）：“To bridge the gap between transferring drone intelligent agents from simulated environments to real-world scenarios, we utilize UrbanScene3D[18], a large-scale data platform specifically designed for urban scene perception and reconstruction.”
> - 复用（§V-A）：“To generate high-quality environmental descriptions, we utilize LLaVA-1.5-13B[33] to produce detailed accounts of surrounding buildings, roads, trees, and other scenery from first-person perspective images captured by a drone”
> - 动态因素（§IV Simulator）：“the simulator accommodates various lighting conditions (day, evening, night, etc.), seasonal variations (spring, summer, autumn, winter), and climatic modes (sunny, cloudy, light snow, etc.)”

## OpenUAV 平台 + UAV-Need-Help 基准（目标导向真实 UAV VLN 数据集）

[arXiv 2410.07087](https://arxiv.org/abs/2410.07087) · 2024-10 · [[topics/papers/视觉语言导航VLN/4-26_2410.07087_OpenUAV.pdf|PDF]]

- **任务**：目标搜索
- **场景来源**：游戏引擎合成
- **引擎 / 数据来源**：Unreal Engine 4 + AirSim（支持 PX4 遥控器操作）
- **场景内容**：在线资源库的高质量场景 + 从 CARLA 模拟器迁移的 11 个城市场景；类型含城市、城镇、乡村、森林、沙漠等；89 类独立物体资产（人、车辆、动物、路标、桌子等），可用放置 API 自动放入预定义可行区域
- **场景数**：22
- **室内外**：室外
- **轨迹长度**：平均轨迹长 255（Table 1），平均 264 步；<250 m 为 easy、>250 m 为 hard；起点到目标 50–400 m
- **规模**：12,149 条有效轨迹（约 12k 轨迹-指令对），89 类目标物体
- **动作空间**：连续 6 DoF 轨迹（x, y, z, pitch, roll, yaw），模型预测位姿序列，经飞控 API 遵循飞行动力学执行；人类通过遥控器（PX4）或 manual/position 模式 API 控制
- **观测**：前/后/左/右/下 5 视角 RGB 与深度 + 自身状态（位置、姿态、速度）+ 目标描述 + 助手指令；平台另支持 IMU、LiDAR、GPS
- **划分**：Train 9,152 条（76 物体、20 场景）/ Test Seen 1,410 / Test Unseen Map 958（2 个未见场景）/ Test Unseen Object 629（13 个未见物体），各测试集再分 easy/hard
- **复用**：UE4、AirSim、PX4；城市场景迁移自 CARLA；目标描述由 GPT-4 生成后人工审核
- **动态因素**：可模拟植被摇摆与光照变化
- **备注**：轨迹接近目标 5 m 内终止，检测到碰撞即丢弃；8 张 A100 并行仿真帧率 160–1600 fps；成功阈值 20 m

> [!quote]- 原文依据（20 句）
> - 引擎 / 数据来源（§1）：“we utilize UE4’s realistic rendering capabilities, integrate 22 scenarios and 89 objects, and provide APIs for object placement and scenario configuration. We integrate AirSim plugin to translate trajectory sequences into continuous paths with realistic flight dynamics”
> - 引擎 / 数据来源（§3.2）：“Firstly, we integrate with PX4 to support remote controller operation. Additionally, the OpenUAV platform offers two operation APIs for UAVs: manual and position modes.”
> - 场景来源（§3.1）：“OpenUAV offers a wide range of scenarios and achieves high-fidelity visual effects through the advanced graphical rendering capabilities of UE4.”
> - 场景内容（§3.1）：“We integrate high-quality scenarios from online repositories and urban scenarios from the CARLA simulator (Dosovitskiy et al., 2017), resulting in the OpenUAV platform featuring 22 distinct scenarios, including urban, rural, and natural landscapes, as detailed in Appendix A.”
> - 场景内容（Appendix A）：“We collected a total of 22 high-fidelity scenarios. In addition to those shown in Fig. 5, we have also included 11 urban scenes transferred from the CARLA simulator.”
> - 场景内容（§3.1）：“OpenUAV platform features a wide variety of standalone object assets, including humans, vehicles, animals, road signs, tables and other items suited for urban and natural environments.”
> - 场景数（§3.1）：“resulting in the OpenUAV platform featuring 22 distinct scenarios, including urban, rural, and natural landscapes”
> - 室内外（§1）：“UAVs frequently operate in diverse outdoor, open environments, where navigation paths are often long and complex.”
> - 轨迹长度（Table 1）：“CityNav 4 ✗ 32637 6.6K 545 26 - SensatUrban Ours 6 ✓ 12149 10.8K 255 104 264 OpenUAV”
> - 轨迹长度（§4.2）：“trajectories shorter than 250 meters are classified as easy, and those exceeding 250 meters are classified as hard. The diversity in trajectory lengths ensures the challenge and complexity of the tasks. Fig. 2 (c) illustrates that the distance to the targets ranges from 50 meters to 400 meters”
> - 规模（§4.1）：“The trajectory recording terminates when the UAV approaches within 5 meters of the target, and any trajectory is discarded if a collision is detected. Ultimately, a total of 12,149 valid trajectories are obtained.”
> - 动作空间（§5.1）：“In the closed-loop simulation, the UAV navigation model predicts a 6 DoF trajectory sequence based on \{I,S,R,D\} . Using the OpenUAV platform’s flight API, the UAV navigates to each predicted position with a 6 DoF attitude”
> - 动作空间（§3.2）：“The pose of the UAV at each time is represented as P=\{x,y,z,\theta,\phi,\psi\} , where (x,y,z) represent the position coordinates, and (\theta,\phi,\psi) denote the pitch, roll, and yaw angles respectively.”
> - 观测（§5.1）：“At each time step, the UAV obtains its state S (position, posture, velocity), along with RGB images R and depth images D from five perspectives: front, left, right, rear, and below.”
> - 观测（§3.2）：“OpenUAV platform supports the simulation of various sensor payloads during UAV flight, including IMU, RGB and depth cameras, LiDARs and GPS.”
> - 划分（§4.2）：“Train - 9152 trajectories with 76 objects across 20 scenes as the training set.”
> - 划分（§4.2）：“Test Seen - 1410 trajectories generated using objects and scenes seen in the training set. • Test Unseen Map - 958 trajectories with 2 scenes unseen in the training set. • Test Unseen Object - 629 trajectories with 13 objects unseen in the training set.”
> - 复用（§4.1）：“Object descriptions and environment information are then obtained by positioning a camera above the object to capture images from five different views (front, back, left, right, and down), followed by generating textual descriptions using GPT-4”
> - 复用（§3.2）：“OpenUAV platform integrates the AirSim plugin to achieve realistic UAV flight simulation, enabling more precise flight control.”
> - 动态因素（§3.1）：“The platform can also simulate dynamic environments, such as vegetation swaying and variations in lighting. This further enhances the platform’s realism, reducing the gap when transitioning to real-world environments.”

## EmbodiedCity

[arXiv 2410.09604](https://arxiv.org/abs/2410.09604) · 2024-10 · [[topics/papers/无人机VLN/1-24_2410.09604_EmbodiedCity.pdf|PDF]]

- **任务**：具身问答
- **场景来源**：游戏引擎合成（按北京真实街区用 Blender 手工建模）
- **引擎 / 数据来源**：Unreal Engine 5.3 + AirSim 接口（另有基于 HTTP 的 Python SDK/代理服务器）
- **场景内容**：参考百度地图、高德街景，用 Blender 手工制作约 200 栋建筑（写字楼、商场、住宅、公共设施）、100 条街道（总长约 50 km）及 6k+ 城市元素（街道家具、植被、公交站、地铁口等）；另建附近带室内建模的住宅区
- **场景数**：1 个商业区（另含附近一个带室内建模的住宅区）
- **面积**：2.8km × 2.4km
- **地域**：中国北京某商业区
- **室内外**：室内外（以室外城市为主，住宅区支持室内任务）
- **规模**：共 87.1k 例：场景理解 12.2k、具身问答 50.4k、具身对话 12.6k、VLN 1.3k、任务规划 10.6k
- **动作空间**：连续：无人机设定目标位置 (x,y,z)、目标速度 (vx,vy,vz)、目标姿态 (roll,pitch,yaw)，相机 pan/tilt，起飞/停止；车辆有转向、油门、刹车、挡位
- **观测**：RGB、深度、语义分割图像，IMU、GPS、LiDAR，位置/速度/姿态状态；问答类任务输入为八个方向 + 一张俯视图
- **复用**：AirSim（观测与控制接口）、Unreal Engine 5.3、Mirage Simulation System（行人车流仿真）、百度地图/高德街景作参考
- **动态因素**：基于 Mirage 仿真系统并结合历史真实交通数据模拟行人与车流
- **备注**：覆盖五类任务：第一视角场景理解、问答、对话、VLN、任务规划；真值以 LLM 自动生成 + 人工修正为主，VLN 由人工标注；在线平台最多同时仿真控制 8 个智能体；作者计划后续做 Sim2Real 验证。

> [!quote]- 原文依据（23 句）
> - 场景来源（§1）：“The environment is based on the real streets, buildings, city elements, pedestrians, and traffic in one commercial district from one of China’s largest cities, Beijing.”
> - 场景来源（§2）：“Specifically, we propose an urban embodied benchmark that creates a highly realistic large-scale city model using Unreal Engine.”
> - 引擎 / 数据来源（§3.1）：“we meticulously build 3D models for buildings, streets, and other outdoor elements, ensuring high-fidelity urban simulations, all hosted by Unreal Engine 5.322”
> - 引擎 / 数据来源（§3.2）：“To implement it, we develop the input/output interfaces based on AirSim66 6 https://github.com/microsoft/AirSim, based on which the observations can be conducted in a first-view manner”
> - 场景内容（§3.1）：“We first manually use Blender33 3 https://www.blender.org/ to create the 3D assets of the buildings, for which we use the streetview services of Baidu Map44”
> - 场景内容（§3.1）：“The city-level detail includes approximately 200 buildings, encompassing a variety of types such as office towers, shopping malls, residential complexes, and public facilities.”
> - 场景内容（§3.1）：“The city contains a total of 100 streets, with a combined length of approximately 50 km.”
> - 场景内容（§3.1）：“Over 6k urban elements are created using Blender, based on real-world references from the streetview services mentioned above, further enhancing the authenticity of the urban simulation.”
> - 场景数（§3.1）：“In addition to this business district, we have also developed a nearby residential area that features detailed interior modeling, allowing the simulator to support both indoor and outdoor tasks.”
> - 面积（§3.1）：“The basic environment of the simulator includes a 2.8km \times 2.4km district in Beijing, one of the biggest cities in China”
> - 地域（§3.1）：“The basic environment of the simulator includes a 2.8km \times 2.4km district in Beijing, one of the biggest cities in China”
> - 室内外（§3.1）：“In addition to this business district, we have also developed a nearby residential area that features detailed interior modeling, allowing the simulator to support both indoor and outdoor tasks.”
> - 规模（§4）：“Using the constructed simulator platform, we have built a dataset comprising 87.1k cases, as shown in Table 2. This dataset includes five essential embodied tasks”
> - 规模（Table 2）：“Embodied QA | ✓ | ✓ | 16.5 | AutoGen+Human | AutoGen+Refinement | 50.4k | Embodied dialogue | ✓ | ✓ | 48.7 | AutoGen+Human | AutoGen+Refinement | 12.6k | Embodied VLN | ✓ | ✓ | 56.5 | Human | Human | 1.3k”
> - 动作空间（§3.2）：“For drones, motion control involves setting target positions (x, y, z), target velocities (vx, vy, vz), and target orientations (roll, pitch, yaw). Camera control allows for viewpoint adjustments (changing camera direction pan, tilt)”
> - 动作空间（Table 1）：“EmbodiedCity | ✓ | UE | Real | ★★★ | All | All | Continous | ✓ | Scene Understanding /QA”
> - 观测（§3.2）：“For drones, these include image data such as RGB images (color images from the camera), depth images (showing the distance of each pixel from the camera), and segmentation images”
> - 观测（§3.2）：“Sensor data like IMU data (accelerometer and gyroscope data for measuring acceleration and angular velocity), GPS data (providing global positioning coordinates), and LiDAR data (3D point cloud information of the environment) are also included.”
> - 观测（Figure 12 caption）：“based on a series of images taken from eight different directions (forward, forward-right, right, rear-right, rear, rear-left, left, forward-left) and one top-down view.”
> - 复用（§3.1）：“The simulation algorithms for these elements are based on the Mirage Simulation System (Zhang et al., 2022), providing realistic interactions and behaviors that mimic real-world traffic and pedestrian dynamics.”
> - 复用（Appendix A.1）：“In our city simulator, AirSim serves as a powerful plugin to facilitate realistic simulations of drones and unmanned vehicles.”
> - 动态因素（§1）：“Furthermore, we combine the historically collected real-world traffic data and simulation algorithms to conduct simulations of pedestrian and vehicle flows.”
> - 动态因素（§3.1）：“Vehicles and Pedestrians. Dynamic elements such as vehicles and pedestrians are simulated to move realistically within the environment.”

## CityEQA-EC

[arXiv 2502.12532](https://arxiv.org/abs/2502.12532) · 2025-02 · [[topics/papers/无人机VLN/2-01_2502.12532_CityEQA.pdf|PDF]]

- **任务**：具身问答
- **场景来源**：游戏引擎合成（EmbodiedCity，按真实城市的建筑、道路等元素构建）
- **引擎 / 数据来源**：EmbodiedCity（Unreal Engine 4 + Microsoft AirSim 插件）
- **场景内容**：直接使用 EmbodiedCity 单一连续的大型城市场景（基于真实城市的建筑、道路等元素）；5 名标注员在场景中自由探索、依据 RGB 图像编写问答并记录观测位姿与目标位姿
- **场景数**：1 个（EmbodiedCity 连续大场景，所有实例共用）
- **室内外**：室外
- **轨迹长度**：起始位姿距目标 200 m 以内；PMA 实验中导航+探索限 50 步、收集限 10 步（人类平均 9.31 步，PMA 24.44 步）
- **规模**：443 条原始问答 → 扩展为 2,212 个任务 → 审核后保留 1,412 个任务，6 类任务；实验随机抽 200 个
- **动作空间**：基准定义为每步移动到指定位姿（未规定统一动作集）；PMA 的 Collector 使用离散动作 {MoveForward, MoveBack, MoveLeft, MoveRight, MoveUp, MoveDown, TurnLeft, TurnRight, KeepStill}；人类与随机探索基线用 {MoveForward（≤10 m）, TurnLeft/TurnRight（30°）, Stop}
- **观测**：每步 RGB + 深度图（640×480）；给定开放词汇问题与初始位姿
- **划分**：未给 train/test 划分，零样本评测；因 API 限制随机抽 200 个任务做实验
- **复用**：EmbodiedCity 平台；任务类型参考 OpenEQA 与 EQA-v1；答案打分借鉴 OpenEQA 的 LLM-Match
- **动态因素**：摘要称“dynamic city spaces”，但作者在局限中说明任务只涉及静态实体，未考虑交通拥堵、人群等动态事件；附录案例提到室外光照会改变物体外观
- **备注**：所有实例共用同一场景 e；问题用地标（主要是建筑）和空间关系消除歧义；两名审核员独立审核，Kappa 为 0.93 / 0.89

> [!quote]- 原文依据（28 句）
> - 引擎 / 数据来源（§2.2）：“It is implemented using Unreal Engine 4 Sanders (2016) and Microsoft AirSim plugins Shah et al. (2018).”
> - 场景来源（§2.2）：“To obtain a high-quality dataset, we employed EmbodiedCity Gao et al. (2024), which is a highly realistic 3D simulation platform based on the buildings, roads, and other elements in a real city.”
> - 场景内容（§2.2）：“To obtain a high-quality dataset, we employed EmbodiedCity Gao et al. (2024), which is a highly realistic 3D simulation platform based on the buildings, roads, and other elements in a real city.”
> - 场景内容（§2.2）：“We instructed human annotators to explore the EmbodiedCity environment freely and generate question-answer pairs based on their observations of RGB images.”
> - 场景内容（§2.2）：“The dataset collection process involves two steps, completed by five human annotators.”
> - 场景数（§2.2）：“Unlike indoor simulators with many different scenes, EmbodiedCity is a coherent and extensive scene. As a result, for all instances, their scene e corresponds to EmbodiedCity.”
> - 室内外（§6）：“This paper pioneers the exploration of EQA tasks in outdoor urban environments. First, we introduced CityEQA-EC, the inaugural open-ended benchmark for CityEQA, comprising 1,412 tasks divided into six distinct categories.”
> - 轨迹长度（§2.2）：“For each raw task, the initial pose p_{0} of the agent was set within a 200-meter range of the target object’s pose p^{tar} .”
> - 轨迹长度（§4.1）：“Additionally, the total number of time steps for navigation and exploration is limited to 50 steps and the maximum steps for collection is 10.”
> - 轨迹长度（§6）：“Nevertheless, challenges remain, including efficiency discrepancies (24.44 vs. 9.31 mean time steps taken by humans) and limitations in visual thinking capabilities.”
> - 规模（§2.2）：“After basic revision process, we have finally collected a total of 443 such instances, with each raw task instance denoted as”
> - 规模（§2.2）：“For each raw task, we generated at least four distinct initial poses and transformed each raw question into at least four different inquiries. Ultimately, this process yielded a total of 2,212 task instances.”
> - 规模（§2.2）：“Any task instance identified with issues was excluded. The final dataset comprises 1,412 task instances, with detailed statistics presented in Figure 2.”
> - 动作空间（§2.1）：“Specifically, the agent starts at the initial pose {{p}_{0}} and interacts with the scene e step by step. At each time step t , the agent can move to a specific pose {{p}_{t}} ,”
> - 动作空间（Appendix A.2）：“The second is action selection, which requires choosing an appropriate action from a discrete set of actions to adjust the observation. The action set used in this study includes {MoveForward, MoveBack, MoveLeft, MoveRight, MoveUp, MoveDown, TurnLeft, TurnRight, KeepStill}.”
> - 动作空间（Appendix A.3）：“At each step, H-EQA can only access the RGB image of the current pose and must choose one action from {MoveForward, TurnLeft, TurnRight, Stop}. The angles for TurnLeft and TurnRight are set at 30°.”
> - 观测（§2.1）：“and obtain an observation {{o}_{t}}=(I_{t}^{rgb},I_{t}^{d}) from the scene, where I_{t}^{rgb}\in{{\mathbb{R}}^{H\times W\times 3}} is the RGB image and I_{t}^{d}\in{{\mathbb{R}}^{H\times W}} is the depth image.”
> - 观测（§4.1）：“The dimension of the images obtained by the agent is 640×480, and we considered buildings as landmarks and accounted for four spatial relationships: north, south, east, and west.”
> - 划分（§4.1）：“GPT-4o and GPT-4 are the default VLM and LLM used in the PMA. Due to API limitations, 200 tasks are randomly selected from CityEQA-EC for the experiments.”
> - 划分（§4.1）：“We compare various models in a zero-shot setting, including five categories of baselines that are widely used in studies of EQA tasks.”
> - 复用（§2）：“To address real-world demands, such as urban governance and public services, we draw upon previous research Majumdar et al. (2024); Das et al. (2018) to define six distinct task types.”
> - 复用（Appendix A.3）：“For QAA, we designed an LLM-based automated scoring method by referring to the LLM-Match mechanism in OpenEQA Majumdar et al. (2024).”
> - 复用（§2.2）：“To obtain a high-quality dataset, we employed EmbodiedCity Gao et al. (2024), which is a highly realistic 3D simulation platform based on the buildings, roads, and other elements in a real city.”
> - 动态因素（Abstract）：“To bridge this gap, we introduce CityEQA, a new task where an embodied agent answers open-vocabulary questions through active exploration in dynamic city spaces.”
> - 动态因素（§7）：“Further, while our approach is effective for tasks involving static physical entities, it overlooks the importance of social interactions and dynamic events, which are also critical in urban settings.”
> - 动态因素（Appendix A.3）：“However, in this image, due to the influence of outdoor lighting, the originally black car appears gray, thus H-VQA provided an incorrect answer.”
> - 备注（Appendix A.1）：“The Kappa coefficients \kappa for the two phases were 0.93 and 0.89, respectively, indicating a high level of agreement among annotators.”
> - 备注（Appendix A.1）：“Buildings are primarily used as landmark objects to expand the question. Then, in the validation stage, each task was independently evaluated by two human reviewers.”

## OpenFly

[arXiv 2502.18041](https://arxiv.org/abs/2502.18041) · 2025-02 · [[topics/papers/语义3DGS与具身导航/2-02_2502.18041_Openfly.pdf|PDF]]

- **任务**：VLN
- **场景来源**：混合（游戏引擎合成 UE/GTA V + 卫星/航拍影像 Google Earth + 3DGS 重建真实无人机航拍）
- **引擎 / 数据来源**：Unreal Engine 4 + AirSim、UE5 + UnrealCV、GTA V（Script Hook V 接口）、Google Earth / Google Earth Studio、hierarchical 3D GS + SIBR viewers
- **场景内容**：UE5 官方 City Sample（大城 25.3 km² + 小城 2.7 km²）；UE4 上海、广州市中心（30.88 / 58.56 km²）及 4 个取自 AerialVLN 的场景（约 26.64 km²）；GTA V 仿洛杉矶城市；Google Earth 四个城区；DJI M30T 倾斜摄影采集 5 个校园做 3DGS 重建
- **场景数**：18
- **面积**：UE 8 个城市场景超 100 km²；Google Earth 四城区 53.60 km²；3DGS 五校园超 7 km²
- **地域**：上海、广州（UE4）；GTA V 仿洛杉矶；Berkeley、Osaka、Washington D.C.、St. Louis（Google Earth）；华东理工奉贤、西工大友谊/长安、上交闵行东/西校区（3DGS）
- **室内外**：室外
- **飞行高度**：0–210 m
- **轨迹长度**：0–300 m，平均 99.1 m；平均 35 个动作
- **规模**：100K 条轨迹，词表 15.6K，平均指令长 59
- **动作空间**：离散：Forward（步长 3/6/9 m）、Turn Left、Turn Right、Move Up、Move Down、Stop；平台也支持基于轨迹规划算法直接生成连续航点
- **观测**：无人机第一视角 RGB 图像序列 + 语言指令；各环境提供点云用于碰撞检测
- **划分**：Train / Test Seen（11 个已见场景均匀采样 1,800 条）/ Test Unseen（3 个未见场景 UE-smallcity、3D GS-sjtu02、GTA V 仿洛杉矶城市共 1,200 条）；训练集中 7 个 UE 场景占 75.7%、4 个 3DGS 场景近 20%、Google Earth 4.46%
- **真机**：有：23 个真实户外场景实飞评测（Q250 机架 + Jetson Xavier NX，轨迹 50–500 m）；另用 DJI M30T 实拍图像重建 3DGS 场景
- **复用**：UE5 City Sample、AerialVLN 的 4 个 UE4 场景、AirSim、UnrealCV、GTA V、Google Earth、hierarchical 3DGS、COLMAP、Octree-Graph、GPT-4o
- **动态因素**：UE4 可调场景时间以呈现不同光照；GTA V 含动态车流与光影变化；UE5 场景含车辆与行人资产
- **备注**：Google Earth 只采高空视角保证画质，且不能任意位姿取图，改为网格化预采图；因无人机会穿过树木模型，剔除低于树高的轨迹；碰撞即判失败；轨迹由 A* 在体素地图上自动生成，指令由 GPT-4o 自动生成，抽检合格率 91%

> [!quote]- 原文依据（35 句）
> - 场景来源（Abstract）：“Firstly, OpenFly integrates 4 rendering engines and advanced techniques for diverse environment simulation, including Unreal Engine, GTA V, Google Earth, and 3D Gaussian Splatting (3D GS). Particularly, 3D GS supports real-to-sim rendering, further enhancing the realism of our environments.”
> - 引擎 / 数据来源（Appendix A）：“We integrate the AirSim plugin into UE4 to obtain image data easily from the perspective of a UAV. Since AirSim does not support UE5 and stopped updating in 2022, we use the UnrealCV (Weichao et al., 2017) plugin as an alternative for image acquisition in UE5.”
> - 引擎 / 数据来源（Table 1）：“Ours 100K 15.6K 99.1 59 4 DoF 35 AirSim + UE, GTA V, Google Earth Studio, 3D GS + SIBR viewers”
> - 引擎 / 数据来源（Appendix A）：“Script Hook V is a third-party library with the interface to GTA V’s native script functions. With the help of Script Hook V, we build an efficient and stable interface, which receives the pose information and returns accurate RGB images and lidar data.”
> - 场景内容（Appendix A）：“In UE5, we meticulously select an official sample project named ‘City Sample’, which provides us with a large urban scene covering 25.3km^{2} and a smaller one covering 2.7km^{2} .”
> - 场景内容（Appendix A）：“Specifically, there are two large scenes showcasing the central urban areas of Shanghai and Guangzhou, covering areas of 30.88km^{2} and 58.56km^{2} , respectively. The remaining four scenes are selected from AerialVLN (Liu et al., 2023). They have smaller areas for totally about 26.64km^{2} .”
> - 场景内容（Appendix A）：“We utilize the DJI M30T drone as the data collection device, which offers an automated oblique photography mode, enabling us to capture a large area of real-world data with minimal manpower. Practically, we gathered data from five campuses across three universities”
> - 场景数（§1）：“We have constructed a large-scale aerial VLN benchmark comprising 100k trajectories across 18 high-quality scenes.”
> - 面积（§3.1）：“Specifically, Unreal Engine provides eight urban scenes spanning over 100km^{2} with rich assets such as buildings, vehicles, and pedestrians. GTA V contributes a highly realistic cityscape modeled after Los Angeles. Google Earth offers four urban regions (Berkeley, Osaka, Washington D.C., and St. Louis) covering 53.60km^{2} .”
> - 面积（§3.1）：“hierarchical 3D Gaussian Splatting (Kerbl et al., 2024) is employed for the reconstruction of real-world environments from UAV data, encompassing more than 7km^{2} across five campuses with diverse landmarks.”
> - 地域（§3.1）：“Google Earth offers four urban regions (Berkeley, Osaka, Washington D.C., and St. Louis) covering 53.60km^{2} .”
> - 地域（Appendix A）：“which are East China University of Science and Technology, Northwestern Polytechnical University, and Shanghai Jiao Tong University (referred to as ECUST, NWPU, and SJTU).”
> - 地域（Figure 7）：“Figure 7: High-quality examples from different rendering engines and techniques, including several large cities such as Shanghai, Guangzhou, Los Angeles, Osaka, and etc., cover an area of over a hundred square kilometers in total.”
> - 室内外（§6.4）：“The real-world experiments are conducted in 23 real outdoor scenes, where each scene corresponds to an unseen VLN task created by human operators”
> - 飞行高度（§4.1）：“Fig. 3(a) and 3(b) exhibit the distribution of these data, with their lengths ranging from 0 to 300 meters, and the heights ranging from 0 to 210 meters.”
> - 轨迹长度（§4.1）：“Fig. 3(a) and 3(b) exhibit the distribution of these data, with their lengths ranging from 0 to 300 meters, and the heights ranging from 0 to 210 meters.”
> - 轨迹长度（Table 1 caption）：“Path Len: the average length of trajectories, measured in meters. Intr Len: the average length of instructions. N_{act} : the average number of actions per trajectory.”
> - 规模（§4.1）：“Using our toolchain, we collect a dataset of 100K trajectories, which is much larger than other aerial VLN datasets.”
> - 规模（§4.1）：“For instruction analysis, the vocabulary size of our dataset is 15.6K, and the average length of instructions is 59.”
> - 动作空间（§4.1）：“we follow the mainstream methods (Krantz et al., 2020; Liu et al., 2023) to use discrete actions, e.g., ‘Forward’ and ‘Turn left’, for trajectory generation, where the step size of the ‘Forward’ action is set to 3 m, 6 m, and 9 m to adapt to targets at different distances.”
> - 动作空间（§6.1）：“Similar to (Liu et al., 2023; Lee et al., 2024), 6 actions for UAVs are defined as \{ Forward, Turn Left, Turn Right, Move Up, Move Down, Stop \} .”
> - 动作空间（§4.1）：“Besides, the OpenFly platform supports trajectory generation with continuous waypoints directly based on drone trajectory planning algorithms”
> - 观测（§3.2）：“Finally, utilizing OpenFly’s interface, UAV-egocentric images corresponding to the trajectory points are obtained as visual observations.”
> - 观测（§6.2）：“Each environment provides corresponding point clouds that enable collision checking. If a collision occurs, the task is counted as a failure.”
> - 划分（§4.2）：“The Test Seen data consists of 1800 trajectories uniformly sampled from 11 seen scenarios, and the Test Unseen data comprises 1200 trajectories uniformly generated from 3 unseen scenes, i.e., UE-smallcity, 3D GS-sjtu02, and a Los Angeles-like city in GTA V.”
> - 划分（§4.2）：“For the Train split, 7 scenes under the UE rendering engine account for 75.7\% of all data, since UE provides the largest number of scenes, where different amounts of trajectories are sampled according to the areas of scenes.”
> - 真机（§6.4）：“The real-world experiments are conducted in 23 real outdoor scenes, where each scene corresponds to an unseen VLN task created by human operators, and the trajectory lengths range from 50m to 500m. We use a Q250 airframe as a real agent, carrying an NVIDIA Jetson Xavier NX running Ubuntu 18.04 as the onboard computer.”
> - 真机（§1）：“In particular, we use UAVs to capture numerous real-world images and integrate 3D GS technology into our platform to reconstruct realistic 3D scenes, empowering real-to-sim simulation.”
> - 复用（Appendix A）：“The remaining four scenes are selected from AerialVLN (Liu et al., 2023). They have smaller areas for totally about 26.64km^{2} .”
> - 复用（§3.2）：“In 3D GS, the scene reconstruction process begins with the open-source COLMAP (Schönberger and Frahm, 2016) framework, which generates a sparse point cloud from input images.”
> - 动态因素（Appendix A）：“Additionally, the UE4 engine allows us to make adjustments in scene time to achieve different appearances of scenes under varying lighting conditions.”
> - 动态因素（Appendix A）：“The game features a meticulously crafted cityscape modeled after Los Angeles, encompassing various buildings and locations such as skyscrapers, gas stations, parks, and plazas, along with dynamic traffic flows and changes in lighting and shadows.”
> - 备注（§4.2）：“To ensure visual quality, we only collect data from a high-altitude perspective using Google Earth, which accounts for 4.46\% .”
> - 备注（Appendix E）：“Google Map data does not allow image retrieval at arbitrary poses in the space. Thus, we rasterize a pre-selected area and collect images from each grid point in all possible orientations.”
> - 备注（Appendix G）：“We find that UAVs sometimes appear to pass through the tree models. Therefore, we exclude the trajectories where the altitude is lower than that of the trees.”

## CognitiveDroneBench（CognitiveDrone 数据集）

[arXiv 2503.01378](https://arxiv.org/abs/2503.01378) · 2025-03 · [[topics/papers/无人机VLN/1-06_2503.01378_CognitiveDrone.pdf|PDF]]

- **任务**：细粒度飞控
- **场景来源**：游戏引擎合成（实为 Gazebo 物理仿真中合成的竞速赛道与门）
- **引擎 / 数据来源**：Gazebo + ArduPilot Gazebo 插件 + SITL ArduPilot；ROS-Gazebo 插件动态生成物体，Gazebo RealSense 插件模拟相机
- **场景内容**：竞速赛道上的虚拟门与标签（*.sdf + *.dae 模型），任务由 JSON 定义（提示、选项、正确答案、门的尺寸/形状/颜色）；门上内容包括人物、字母数字、企业 logo、动物图案等
- **规模**：8,062 条连续轨迹，分三类任务：Human Recognition、Symbol Understanding、Reasoning
- **动作空间**：连续 4D 速度指令 (Vx, Vy, Vz, ω)，以速度设定点控制，VLA 以 10 Hz 输出
- **观测**：第一视角 FPV 图像（256x256）+ 文本任务指令
- **划分**：数据集划分为训练集和测试集，三类任务在两者中分布均衡；测试集构成 CognitiveDroneBench
- **复用**：Gazebo、ArduPilot（SITL）、ROS；模型基于 OpenVLA，数据采用 RLDS 格式；对比基线 RaceVLA
- **备注**：每段赛道需通过解决认知任务选择正确的门，穿过正确门得 1 分；采集时相机无人机在起点附近随机初始化，沿样条轨迹飞向目标门中心。论文未给场景数量、面积、高度或室内外信息。

> [!quote]- 原文依据（15 句）
> - 场景来源（§I）：“we propose CognitiveDroneBench, an open-source benchmark built upon a Gazebo-based physical simulation environment that integrates a drone racing track with cognitive checkpoints.”
> - 引擎 / 数据来源（§III-B）：“The simulation environment is built using Gazebo with the ArduPilot Gazebo plugin and SITL ArduPilot. Each model (gates, labels) for dataset collection is described using an *.sdf file along with a *.dae model.”
> - 引擎 / 数据来源（§III-B）：“The camera simulation is handled using the Gazebo RealSense plugin, with all data collected via ROS topics.”
> - 场景内容（§III-B）：“Tasks in the simulation are defined by a JSON file, which includes a task prompt, task options, the correct answer, and gate parameters such as size, shape, and color. The ROS-Gazebo plugin is used to dynamically spawn objects for drone tasks via Python scripts.”
> - 场景内容（§IV-A）：“Symbol Understanding: The model is required to differentiate between a variety of symbols, including alphanumeric characters (e.g., numbers and letters), corporate logos, and pictorial representations of animals.”
> - 规模（§IV-A）：“We collected a dataset of 8,062 continuous trajectory samples to train the VLA model in a simulated environment, grouped into three categories.”
> - 动作空间（§III-B）：“Gazebo with ArduPilot was chosen for its simulation capabilities, allowing accurate replication of real-world drone dynamics, including flight control; additionally, the drone in simulation is controlled using velocity setpoints”
> - 动作空间（§IV-A）：“Throughout each flight, the UAV’s velocity and the head profile (V_{x},V_{y},V_{z},omega) was continuously logged, providing a comprehensive record of its dynamic behavior.”
> - 动作空间（§III-A）：“Consequently, it excels at generating high-frequency control commands—operating at 10 Hz—to produce smooth and continuous trajectories.”
> - 观测（§V-A）：“At each stage of the track, the drone receives a first-person view (FPV) image along with a task-specific textual instruction.”
> - 观测（§III-B）：“As the camera moves along this trajectory, frames with size of 256x256 pixels and applied actions are recorded at each step.”
> - 划分（§IV-A）：“The dataset was divided into training and test subsets, ensuring an equitable distribution of samples across all three categories in both sets.”
> - 划分（§IV-A）：“The training subset was employed to optimize the VLA model parameters, while the test subset forms the foundation of the CognitiveDroneBench benchmark for performance evaluation.”
> - 复用（§III-A）：“To achieve this, we integrate a VLA model adapted from the open-source OpenVLA model, which comprises 7 billion parameters.”
> - 复用（§IV-B）：“The collected data was structured in accordance with the Reinforcement Learning Dataset (RLDS) format to ensure seamless compatibility with OpenVLA.”

## UrbanVideo-Bench

[arXiv 2503.06157](https://arxiv.org/abs/2503.06157) · 2025-03 · [[topics/papers/无人机VLN/1-07_2503.06157_UrbanVideo-Bench.pdf|PDF]]

- **任务**：静态问答
- **场景来源**：混合（真机实飞视频 + 游戏引擎合成）
- **引擎 / 数据来源**：真实：2 台 DJI Mini 4K 无人机；仿真：EmbodiedCity 与 AerialVLN（均基于 Unreal Engine，内置 AirSim 插件）
- **场景内容**：真实城市深圳、肇庆实拍；EmbodiedCity 仿真器基于真实城市北京构建；AerialVLN 仿真器基于虚拟城市；仿真环境含上百类城市微元素
- **场景数**：3 类数据源：广东 2 座真实城市（深圳、肇庆）+ 2 个仿真城市（EmbodiedCity、AerialVLN）
- **地域**：中国广东省深圳、肇庆（真实）；北京（EmbodiedCity 仿真）；AerialVLN 为虚拟城市
- **室内外**：室外
- **轨迹长度**：视频时长 10 秒到 10 分钟，涵盖短程精细动作、中程指令执行到长距离导航
- **规模**：1,547 段视频（约 1.5k）+ 5.2k 道选择题，4 类能力 16 项任务
- **动作空间**：无闭环控制；导航类任务以选择题形式给出下一步控制动作
- **观测**：第一人称连续视频（单相机云台，可向下倾 0–90°）；分辨率真机 1280x720、EmbodiedCity 960x720、AerialVLN 520x520
- **划分**：整体用于零样本评测；Sim-to-Real 微调实验以 EmbodiedCity 与 AerialVLN 数据为训练集、真实数据为测试集
- **真机**：是：在深圳、肇庆用 2 台 DJI Mini 4K 由飞手实飞采集视频（真实视频具体数量正文未给出）
- **复用**：EmbodiedCity 与 AerialVLN 仿真器及其已有 VLN 路线/指令作为参考
- **动态因素**：引言称城市场景含行人、车辆等动态元素；数据中具体动态设置未说明
- **备注**：所有视频为执行 VLN 任务时由飞手（1000 小时以上飞行经验）手动飞行采集；作者称 AerialVLN 多数原路线含大量无意义重复动作，不能直接使用。

> [!quote]- 原文依据（21 句）
> - 场景来源（Abstract）：“We have manually control drones to collect 3D embodied motion video data from real-world cities and simulated environments, resulting in 1.5k video clips.”
> - 引擎 / 数据来源（§3.2.1）：“We collecte drone flight video data in two cities, Shenzhen and Zhaoqing, in Guangdong Province, China. The data collection was conducted using two DJI Mini 4K drones.”
> - 引擎 / 数据来源（Appendix B.1）：“Both EmbodiedCity and AerialVLN are built on Unreal Engine and include various building types and streets, with more than a hundred categories of micro urban elements”
> - 引擎 / 数据来源（Appendix B.1）：“b) Support for aerial agents. Both simulators have built-in AirSim plugins, allowing easy control of aerial agents.”
> - 场景内容（§1）：“we manually operate drones to collect embodied video data from 1) the real cities in Guangdong Province, China, 2) a simulator EmbodiedCity Gao et al. (2024) built on the real city Beijing, China, and 3) a simulator AerialVLN Liu et al. (2023) built on virtual cities.”
> - 场景内容（Appendix B.1）：“Both EmbodiedCity and AerialVLN are built on Unreal Engine and include various building types and streets, with more than a hundred categories of micro urban elements”
> - 场景数（§3.2.1）：“We collecte drone flight video data in two cities, Shenzhen and Zhaoqing, in Guangdong Province, China.”
> - 场景数（§3.2.1）：“To further expand the dataset, we chose to acquire data from simulators with two city benchmarks: EmbodiedCity Gao et al. (2024) and AerialVLN Liu et al. (2023).”
> - 地域（Figure 1 caption）：“real cities in Guangdong Province, China; the simulator EmbodiedCity constructed based on the real city of Beijing, China; and the simulator AerialVLN built on virtual cities.”
> - 室内外（§2）：“we independently record embodied motion video data along with corresponding MCQs to evaluate models’ cognitive abilities in complex, dynamic urban 3D spaces.”
> - 轨迹长度（§3.3）：“the durations of these video clips range from 10 seconds to 10 minutes, and the trajectories of the UAV in the videos encompasses different directions and movement patterns in 3-dimensional spaces”
> - 规模（§3.3）：“The proposed dataset includes 1,547 video clips with resolutions of 1280x720 pixels for real drone frames, 960x720 pixels for EmbodiedCity frames, and 520x520 pixels for AerialVLN frames.”
> - 规模（§1）：“We consequently develop 5.2k multiple-choice questions and 1.5k video clips, derived from real world and simulated environments.”
> - 动作空间（Table 1）：“Given [navigation goal/route] initially, generate the next control action from the current location.”
> - 观测（§3.3）：“The proposed dataset includes 1,547 video clips with resolutions of 1280x720 pixels for real drone frames, 960x720 pixels for EmbodiedCity frames, and 520x520 pixels for AerialVLN frames.”
> - 观测（Appendix B.1）：“Drone Setup: The drone has only one camera equipped with a gimbal, which can tilt from 0 degrees to 90 degrees downward.”
> - 划分（§4.4）：“Here, we used data from EmbodiedCity and AerialVLN as the training set, and real-world data as the test set.”
> - 真机（§3.2.1）：“We collecte drone flight video data in two cities, Shenzhen and Zhaoqing, in Guangdong Province, China. The data collection was conducted using two DJI Mini 4K drones.”
> - 复用（Appendix B.1）：“Research work on vision-language navigation Zhu et al. (2020) has already been conducted in these simulators, allowing us to obtain some route coordinates and instruction data.”
> - 复用（§3.2.1）：“To further expand the dataset, we chose to acquire data from simulators with two city benchmarks: EmbodiedCity Gao et al. (2024) and AerialVLN Liu et al. (2023).”
> - 动态因素（§1）：“Urban areas are vast, containing diverse elements like skyscrapers, bridges, and tunnels that provide rich semantic information and pose comprehension and navigation challenges, while dynamic elements like pedestrians and vehicles require real-time adaptation”

## Open3D-VQA

[arXiv 2503.11094](https://arxiv.org/abs/2503.11094) · 2025-03 · [[topics/papers/无人机VLN/1-08_2503.11094_Open3D-VQA.pdf|PDF]]

- **任务**：静态问答
- **场景来源**：混合（真机航拍图像 + 真实城市三维重建 UrbanScene3D（UE4）+ 数字孪生仿真 EmbodiedCity）
- **引擎 / 数据来源**：UrbanScene3D 的 UE4 仿真重建场景、EmbodiedCity 仿真器（基于 AirSim 的仿真无人机）；真实平台 DJI M300RTK、DJI Matrice 210、自制无人机
- **场景内容**：UrbanScene3D：UE4 中的重建城市场景 + 深圳 6 个区域的真实航拍图；EmbodiedCity：北京、武汉数字孪生城市；WildUAV：罗马尼亚真实俯视航拍；另自采深圳实飞视频
- **场景数**：4 个真实区域 + 3 个合成场景，共采集 4,675 张图像
- **地域**：中国深圳（UrbanScene3D 及自采）、北京与武汉（EmbodiedCity 数字孪生）、罗马尼亚（WildUAV）
- **室内外**：室外
- **飞行高度**：WildUAV 与 UrbanScene3D 多为低空俯视/斜视；仿真中手动控制无人机由低到高遍历不同高度（未给数值）
- **规模**：4,675 张图像经人工筛选保留 1,168 张；73,324 个 QA（7 类空间推理任务，34/12/12 个 SAQ/MCQ/TFQ 模板）
- **观测**：单张航拍 RGB（640x480）+ 深度图、相机位姿、目标掩码；3D LLM 输入场景/物体点云
- **划分**：仿真 QA 的 80% 训练、10% 验证，余下 10% 与全部真实场景 QA 一起做 sim-to-real 测试
- **真机**：含真实无人机航拍数据（DJI M300RTK、DJI Matrice 210、自制无人机，及深圳自采视频）；无真机闭环评测
- **复用**：UrbanScene3D、EmbodiedCity、WildUAV
- **备注**：QA 由 GPT-4o 描述物体 + SegCLIP/SAM 分割 + VGGT 深度估计投影到 3D 后按模板生成；多模态纠错流利用真值深度、位姿与 3D 扫描减少误差。§4.3 提到 'UrbanUAV dataset' 但正文未定义。

> [!quote]- 原文依据（18 句）
> - 场景来源（§1）：“we collaborate with experienced UAV pilots to fly drones across both real-world urban areas and high-fidelity digital twin environments, such as EmbodiedCity (Gao et al., 2024) and UrbanScene3D (Lin et al., 2022).”
> - 场景来源（§3.2.1）：“Urbanscene3D provides reconstructed urban scenes in the UE4 simulator along with real-world aerial images from six distintive areas in Shenzhen.”
> - 引擎 / 数据来源（§3.2.1）：“Specifically, our benchmark includes data collected using four different UAV platforms, including a DJI M300RTK, a DJI Matrice 210, a self-made UAV, and an AirSim simulator-based drone.”
> - 引擎 / 数据来源（§3.2.1）：“Urbanscene3D provides reconstructed urban scenes in the UE4 simulator along with real-world aerial images from six distintive areas in Shenzhen.”
> - 场景内容（§3.2.1）：“Urbanscene3D provides reconstructed urban scenes in the UE4 simulator along with real-world aerial images from six distintive areas in Shenzhen. EmbodiedCity offers high-fidelity digital twin cities of Beijing and Wuhan.”
> - 场景内容（§3.2.1）：“WildUAV provides real-world overhead imagery from Romania. In addition, we self-collect real-world drone flight videos in Shenzhen.”
> - 场景数（§3.2.1）：“As a result, our dataset covers 4 distinctive real-world areas and 3 synthetic scenes, totaling 4,675 images.”
> - 地域（§3.2.1）：“EmbodiedCity offers high-fidelity digital twin cities of Beijing and Wuhan. WildUAV provides real-world overhead imagery from Romania. In addition, we self-collect real-world drone flight videos in Shenzhen.”
> - 室内外（§4）：“For the proposed outdoor spatial reasoning tasks, we evaluated the performance of 13 popular MLLMs, including visual and 3D LLMs.”
> - 飞行高度（§3.2.1）：“WildUAV and UrbanScene3D primarily include nadir (top-down) and oblique views from low altitudes. EmbodiedCity provides front-view images in the simulators.”
> - 飞行高度（§3.2.1）：“To further enrich viewpoint diversity, we manually control UAVs in simulators to traverse various altitudes from low to high and capture multi-view images.”
> - 规模（§3.3）：“we collected a total of 4,675 images from four real-world scenes and three virtual scenes. After manual refinement, 1,168 high-quality images were retained.”
> - 规模（§3.3）：“To guarantee the diversity of QA types, we designed 34, 12, and 12 templates to generate SAQs, MCQs, and TFQs, respectively, resulting in 73,324 QA pairs in total.”
> - 观测（§3.3）：“The dataset comprises multiple modalities, poses, and target masks, with image resolutions set to 640x480, commonly used by current UAV platforms.”
> - 观测（§4.1.2）：“For 3D MLLMs inference, scene point clouds are obtained via the pipeline in Figure 2 and object point clouds are segmented by the 2D object masks.”
> - 划分（§3.3）：“We adopt 80% of QAs from simulators for training, 10% for validation, and the remaining 10% combined with QAs from the real world for sim-to-real testing.”
> - 真机（§3.2.1）：“Specifically, our benchmark includes data collected using four different UAV platforms, including a DJI M300RTK, a DJI Matrice 210, a self-made UAV, and an AirSim simulator-based drone.”
> - 复用（§3.2.1）：“we collect drone flight images and videos from multiple open-source datasets and simulators, including Urbanscene3D, EmbodiedCity, and WildUAV.”

## CityAVOS

[arXiv 2505.08765](https://arxiv.org/abs/2505.08765) · 2025-05 · [[topics/papers/无人机VLN/2-02_2505.08765_CityAVOS.pdf|PDF]]

- **任务**：目标搜索
- **场景来源**：游戏引擎合成
- **引擎 / 数据来源**：EmbodiedCity（Unreal Engine 5.3）+ AirSim
- **场景内容**：基于 EmbodiedCity 城市环境（街道、建筑、树木、车辆、行人），在场景中嵌入专为 AVOS 设计的可识别目标物体；目标分 building、vehicle、shop、billboard、sign、facility 六类
- **场景数**：6 个搜索场景（如街道、社区、公园）
- **面积**：单场景面积 5,600 至 82,800 平方米
- **室内外**：室外
- **轨迹长度**：平均轨迹长度 174.7 m
- **规模**：2,420 个任务及对应轨迹（easy 1320 / medium 720 / hard 380）
- **动作空间**：论文未列出具体动作；步长按场景范围和目标尺寸确定，含 Stop 动作
- **观测**：第一人称 RGB 图像 + 深度图 + 当前位姿；目标由图像和文本描述共同给出
- **划分**：未给出 train/test 划分；因 API 限制，实验随机抽取 605 个任务（25%）
- **复用**：EmbodiedCity 平台（UE 5.3 + AirSim），对其城市环境加以修改
- **动态因素**：EmbodiedCity 平台模拟车辆与行人（未说明任务中是否运动）
- **备注**：难度按场景大小与目标唯一性划分：easy=小场景唯一目标，medium=大场景唯一目标，hard=大场景非唯一目标；轨迹由 Python 脚本自动采集并人工复核；成功阈值 20 m；任务示例涉及中国工商银行、中国海关标识等，但论文未写明城市

> [!quote]- 原文依据（25 句）
> - 引擎 / 数据来源（§3.2）：“We develop CityAVOS based on EmbodiedCity(Gao et al., 2024b), a platform built on Unreal Engine 5.3 that features high-fidelity simulations of urban streets, buildings, trees, vehicles, and pedestrians(Zhao et al., 2025).”
> - 引擎 / 数据来源（§3.2）：“By integrating AirSim (Shah et al., 2018), the platform provides a realistic environment for evaluating the performance of autonomous UAVs in urban settings.”
> - 场景来源（§3.2）：“We develop CityAVOS based on EmbodiedCity(Gao et al., 2024b), a platform built on Unreal Engine 5.3 that features high-fidelity simulations of urban streets, buildings, trees, vehicles, and pedestrians(Zhao et al., 2025).”
> - 场景内容（Appendix A.1）：“We modified the urban environment in EmbodiedCity by introducing target objects specifically designed for AVOS tasks.”
> - 场景内容（§3.2）：“To adapt these scenarios for the AVOS task, we embed specific recognizable objects within the scenes.”
> - 场景内容（§3.3）：“The CityAVOS dataset contains 2,420 AVOS tasks and their corresponding trajectories, which consist of objects in the following six categories: building, vehicle, shop, billboard, sign, and facility.”
> - 场景数（§3.2）：“Using this environment, we define six distinct search scenarios (e.g., streets, neighborhoods, parks), with areas ranging from 5,600 to 82,800 square meters.”
> - 面积（§3.2）：“Using this environment, we define six distinct search scenarios (e.g., streets, neighborhoods, parks), with areas ranging from 5,600 to 82,800 square meters.”
> - 室内外（§5.1）：“To adapt the baseline indoor object search methods for urban outdoor settings, we have made some adjustments to these methods, including (but not limited to) input matching and converting 2D structures into 3D structures.”
> - 轨迹长度（Table 1）：“N_{traj} : the number of total trajectories. Path Len: the average length of trajectories, measured in meters.”
> - 轨迹长度（Table 1）：“CityAVOS (Ours) | City (Aerial) | 2420 | 2420 | 174.7 | Object Search | ✓ |”
> - 规模（Abstract）：“This dataset comprises 2,420 tasks across six object categories with varying difficulty levels, enabling comprehensive evaluation of UAV agents’ search capabilities.”
> - 规模（Table 6）：“Scene Size | Small | Large | Large | Goal Uniqueness | Unique | Unique | Non-Unique | Number of Tasks | 1320 | 720 | 380 |”
> - 动作空间（Appendix A.1）：“Define the boundaries of the scene and determine the step size based on the overall scene range and the dimensions of the target objects.”
> - 动作空间（§3.1）：“The agent determines whether to search and locate the target successfully based on observations. Finally, the search task ends when the agent executes the stop action.”
> - 观测（§3.1）：“At each step t , the agent perceives the RGB image V_{t} and depth image D_{t} in its current pose P_{t}=[{pos_{t},ori_{t}}] .”
> - 观测（§1）：“Task dataset involves searching for and identifying common urban targets by a UAV agent, described by both images and text descriptions, within complex scenes featuring intricate semantic information and spatial structures.”
> - 观测（Appendix A.3.2）：“Since the UAV in our environment can only obtain first-person view images, we modified the WMNav algorithm accordingly to ensure fairness in the comparative experiments.”
> - 划分（§5.1）：“The dataset used for the experiment is CityAVOS, and the platform is the EmbodiedCity modified for AVOS. Due to API limitations, 605 tasks (25%) are randomly selected from the CityAVOS dataset for extensive experiments.”
> - 复用（Appendix A.1）：“We modified the urban environment in EmbodiedCity by introducing target objects specifically designed for AVOS tasks.”
> - 复用（§3.2）：“We develop CityAVOS based on EmbodiedCity(Gao et al., 2024b), a platform built on Unreal Engine 5.3 that features high-fidelity simulations of urban streets, buildings, trees, vehicles, and pedestrians(Zhao et al., 2025).”
> - 动态因素（§3.2）：“a platform built on Unreal Engine 5.3 that features high-fidelity simulations of urban streets, buildings, trees, vehicles, and pedestrians(Zhao et al., 2025).”
> - 备注（§3.3）：“For easy tasks, the agent is required to locate a unique object within a small-scale scene. Medium tasks involve the agent searching for a unique object in a large-scale scene. Hard tasks require the agent to identify non-unique targets in a large-scale scene.”
> - 备注（§5.1）：“SR calculates the percentage of episodes in which the agent terminates within a predefined success threshold (20 meters) and successfully identifies the target.”
> - 备注（Appendix A.1）：“Each trajectory is manually reviewed to identify and filter out incorrect paths. Any erroneous trajectories are then regenerated manually.”

## UAV-Flow（UAV-Flow Colosseo；含 UAV-Flow-Sim）

[arXiv 2505.15725](https://arxiv.org/abs/2505.15725) · 2025-05 · [[topics/papers/无人机VLN/1-28_2505.15725_UAV-Flow-Colosseo.pdf|PDF]]

- **任务**：细粒度飞控
- **场景来源**：混合（真机实飞采集的真实数据 + 游戏引擎合成的 UE 校园仿真环境）
- **引擎 / 数据来源**：真实数据：DJI Mavic 3T RTK 等商用无人机（4K 相机 + RTK GPS）；仿真：UE 校园环境 + UnrealCV
- **场景内容**：真实：三所大学校园，含行人、车辆、植被、建筑与地标；仿真：基于 UE 的校园环境，UnrealCV 支持放置和移动人、车、四足机器人等交互物体
- **场景数**：真实 3 个校园；仿真 1 个 UE 校园环境
- **面积**：5.02 km²（三个真实校园合计）
- **地域**：三所大学校园（未具名）
- **室内外**：室外
- **轨迹长度**：大多数轨迹在 20 米以内；原地旋转类指令存在近零位移轨迹
- **规模**：真实数据 30692 条轨迹（8 大类动作）；UAV-Flow-Sim 10109 条；仿真测试集 273 条
- **动作空间**：连续：6-DoF 位姿/低层控制动作（OpenVLA-UAV 将动作离散为 256 个 token，Pi-0-UAV 输出 6-DoF 动作块）；仿真控制模拟真实遥控器的位置模式
- **观测**：第一视角图像 + 6-DoF 状态 + 语言指令；视频以 5 Hz 采样并与状态对齐；Pi-0-UAV 输入首帧 + 当前帧
- **划分**：真实数据用于训练和真机部署；仿真数据用于验证分析，另建 273 条标注轨迹的仿真测试集覆盖所有主要动作类型
- **真机**：核心数据为真机实飞：持证飞手（800+ 小时经验）操控 DJI Mavic 3T RTK 采集 30692 条轨迹；并经地面站协同框架将 Pi-0-UAV 部署到真机做定性演示（无系统定量评测）
- **复用**：UnrealCV（仿真）；基线改造自 Seq2Seq、CMA、Travel、OpenVLA、Pi-0；用 GPT 系列模型扩充指令
- **动态因素**：真实校园含行人与车辆；仿真中 UnrealCV 支持可移动交互物体（人、车、四足机器人）
- **备注**：仿真数据采用人工飞行 + 基于真值状态的规则生成混合策略；作者承认仿真在视觉与飞控动力学上与真实存在差异，且受飞行安全限制难以做系统性真机定量评测；仅关注视距内短程控制。

> [!quote]- 原文依据（29 句）
> - 场景来源（§1）：“we depart from conventional simulator-based data collection paradigms and construct the UAV-Flow dataset directly in real-world environments.”
> - 场景来源（§2.3）：“To establish a unified evaluation benchmark, we follow the principles of Flow task and construct a simulation dataset named UAV-Flow-Sim within a UE-based campus environment.”
> - 引擎 / 数据来源（§2.2）：“We use commercial-grade platforms, such as the DJI Mavic 3T RTK, equipped with 4K cameras and RTK GPS modules, providing high-resolution first-person view video and centimeter-level trajectory accuracy”
> - 引擎 / 数据来源（§2.3）：“We utilize UnrealCV [16, 25] as the simulation environment for the UAV, controlling its motion through the control interface provided by the simulator.”
> - 场景内容（§2.2）：“Each campus serves as a compact urban environment containing varied semantic elements such as pedestrians, vehicles, vegetation, buildings, and other landmarks, enabling rich visual contexts for diverse flight behaviors.”
> - 场景内容（§2.3）：“Moreover, UnrealCV supports a variety of placeable and movable interactive objects (e.g., humans, cars, quadruped robots), enabling the simulation of rich object interactions during data collection.”
> - 场景数（§1）：“Data is collected by professional pilots across three large-scale campus environments selected for their architectural diversity and spatial complexity.”
> - 场景数（§2.3）：“To establish a unified evaluation benchmark, we follow the principles of Flow task and construct a simulation dataset named UAV-Flow-Sim within a UE-based campus environment.”
> - 面积（§2.2）：“We conduct data acquisition across three university campuses spanning 5.02 km2.”
> - 地域（§2.2）：“We conduct data acquisition across three university campuses spanning 5.02 km2.”
> - 室内外（Abstract）：“As far as we are aware, we present the first real-world deployment of a VLA system for language-conditioned UAV control in open environments.”
> - 轨迹长度（§2.4）：“Given that the Flow task emphasizes short-range, fine-grained control, most trajectories are within 20 meters in length, as illustrated in the center of Fig. 5.”
> - 轨迹长度（§2.4）：“Notably, due to the inclusion of instructions such as in-place rotations, there remains a frequency of trajectories with near-zero displacement.”
> - 规模（§2.4）：“The real-world dataset contains 30692 flight trajectories categorized into 8 major motion types, each exhibiting diverse trajectory patterns.”
> - 规模（§2.4）：“The UAV-Flow-Sim dataset includes 10109 trajectories, built by referencing the typical actions in the real-world dataset and leveraging information accessible in simulation environments.”
> - 动作空间（§2.1）：“The agent is expected to generate UAV action sequence that reflects the intent of the instruction while satisfying dynamic feasibility, thereby emulating maneuvers characteristic of expert pilots.”
> - 动作空间（§4.1）：“The action space is discretized into 256 tokens, and the model predicts 6-DoF poses via token outputs. The adapted version is referred to as OpenVLA-UAV.”
> - 动作空间（§2.3）：“This control scheme closely mimics the position-mode control used in real-world UAV remote controllers, ensuring high fidelity to actual flight behavior.”
> - 观测（§2.1）：“Each Flow task instance provides the UAV with three modalities at every time step: a natural language instruction \mathbf{I} , the UAV’s 6-DoF state \mathbf{S}_{t} , and an egocentric visual observation \mathbf{O}_{t} .”
> - 观测（§2.2）：“We uniformly sample the video at 5 Hz and pair each frame with its aligned UAV state, resulting in a high-quality sequence of visual observations and corresponding flight poses”
> - 划分（§2.3）：“Therefore, we primarily use simulated data in virtual environments for model validation and analysis, while real-world UAV data is employed for training and deploying models in real-world scenarios.”
> - 划分（§2.4）：“Additionally, we construct a simulation test set including 273 annotated trajectories, covering all major action types in the simulation dataset, to facilitate systematic evaluation on the Flow task.”
> - 真机（§2.2）：“All flights are manually operated by certified UAV pilots, each with over 800 hours of experience.”
> - 真机（§4.3）：“we draw upon the validation results from the simulation environment, and train the Pi-0-UAV model on the UAV-Flow real-world dataset. Deployment is conducted via our proposed ground-drone collaborative framework.”
> - 真机（§4.3）：“Due to the safety constraints of UAV flight and the variability of outdoor environments, it remains challenging to adopt quantitative evaluation metrics in real-world scenarios.”
> - 复用（§4.1）：“We draw inspiration from recent advances in robotic manipulation and adopt OpenVLA [22] and Pi-0 [23] as base VLA models for Flow task.”
> - 复用（§2.2）：“We employ GPT series [24] models to enrich the base instructions, thereby creating an Open Vocabulary Command Set that includes diverse expressions.”
> - 动态因素（§2.2）：“Each campus serves as a compact urban environment containing varied semantic elements such as pedestrians, vehicles, vegetation, buildings, and other landmarks”
> - 动态因素（§2.3）：“Moreover, UnrealCV supports a variety of placeable and movable interactive objects (e.g., humans, cars, quadruped robots), enabling the simulation of rich object interactions during data collection.”

## BEDI（Benchmark for Embodied Drone Intelligence）

[arXiv 2505.18229](https://arxiv.org/abs/2505.18229) · 2025-05 · [[topics/papers/无人机VLN/1-09_2505.18229_BEDI.pdf|PDF]]

- **任务**：任务级评测
- **场景来源**：混合（公开数据集中的真实无人机航拍图像 + 自录真实无人机飞行视频 + Unreal Engine 游戏引擎合成仿真）
- **引擎 / 数据来源**：Unreal Engine 4.27.2 + AirSim 插件（二次开发，经 HTTP 代理服务器与 Python 客户端交互）；静态与动态真实部分直接使用无人机图像/视频
- **场景内容**：静态：从多个公开无人机数据集选取图像，覆盖火灾救援、交通监控、城市巡逻、野外勘探，地形含海洋/城市/丘陵，场景含火灾/洪水/交通，光照含明亮/昏暗/黑暗；动态真实：自录飞行视频（停车场车辆识别、骑手跟踪）；虚拟：自建货运港口、城市建筑群/城市火灾、城市道路网，街道、车辆、货物、货船等精细建模
- **场景数**：虚拟 3 个主要场景（货运港口、城市火灾、城市移动目标跟踪）；真实视频 2 个动态场景；静态感知 154 张、决策 30 张图像
- **室内外**：室外
- **轨迹长度**：以决策步数计：车辆识别任务 19 个节点、最短 7 步；骑手跟踪 14 个节点；货运投送与建筑灭火最短各 3 步
- **规模**：感知：154 张图像、2,740 题；决策：30 张图像、357 题；动作：195 个测试用例（每个生成 1–4 个动作字典）；另有 2 个真实视频动态任务 + 3 个虚拟动态任务（每模型各跑 5 次）
- **动作空间**：离散/结构化：静态动作任务输出含 8 类参数的动作字典（move/rotate/adjust/zoom 及方向、距离、速度、时长等）；虚拟环境提供起降、方向飞行、转向 90°、飞往坐标 (x,y)、切换视角及投货/喷水等任务专用动作；真实视频任务在决策树节点上从多个选项中选择
- **观测**：第一视角可见光相机，可切换前/后/左/右/下五个视角；状态接口提供位置、朝向、视角及火情、是否降落等环境状态；仅用 2D 视觉输入，无 LiDAR/深度
- **真机**：静态部分使用公开数据集的真实无人机图像，动态真实部分使用录制的真实无人机飞行视频并提取关键帧构建决策树式交互测试；真实测试样本公开发布
- **复用**：多个公开无人机数据集（未具名）、Unreal Engine 4.27.2、AirSim 插件；GPT-4o 作为评分裁判
- **动态因素**：真实视频含光照变化、遮挡与干扰；虚拟环境有动态火焰与烟雾、水火交互、随机或自定义路径的移动车辆；作者指出仿真未考虑天气变化与传感器噪声
- **备注**：以感知-决策-动作循环（Dynamic Chain-of-Embodied-Task）评测六项子技能；真实视频任务的节点选项分最优/次优/错误三类；虚拟动态任务由人工评审打分；虚拟场景内容文件计划后续公开。PDF 抽取文本缺字（如 erception、oving、ort），引用均按原文件照抄。

> [!quote]- 原文依据（38 句）
> - 场景来源（p.13 §4）：“BEDI is a hybrid benchmark designed for the comprehensive evaluation of UAV-EAs, systematically integrating real-world data and virtual simulation.”
> - 场景来源（p.13 §4）：“test setting, covering static real-world datasets built from UAV imagery, dynamic real-world scenarios utilizing UAV videos, and a high-fidelity virtual environment developed with Unreal Engine and AirSim”
> - 引擎 / 数据来源（p.16 §4.1.3）：“To expand more test scenarios, we further develop a simulated environment based on Unreal Engine 4.27.2, which enables UAV-EAs to perform tasks from a first-person perspective”
> - 引擎 / 数据来源（p.17 §4.2）：“Through secondary development of the AirSim plugin, we have encapsulated and redesigned its underlying control operations to provide three main categories of interaction interfaces: perception, action, and state.”
> - 场景内容（p.15 §4.1.1）：“we collected images from multiple public UAV datasets, selecting representative scenes from domains including fire rescue, traffic surveillance, urban patrol, and field exploration.”
> - 场景内容（p.2 §1）：“Specifically, in the static real-world setting, we collect real UAV imagery under diverse conditions, including various terrains (e.g., ocean, city, hills), scenarios (e.g., fire, flood, traffic), and lighting”
> - 场景内容（p.16 §4.1.3）：“To accommodate a range of embodied tasks, we design multiple scene types, including cargo ports, urban building clusters, and urban fire scenarios.”
> - 场景内容（p.16 §4.1.3）：“Key elements such as streets, vehicles, cargo, and freight ships are meticulously modeled to enhance visual fidelity and interactivity, making the simulation closely reflect real operational conditions.”
> - 场景内容（p.3 §1）：“In the dynamic real-world setting, we record UAV flight videos and extract key frames from single-task execution sequences.”
> - 场景数（p.17 §4.1.3）：“Cargo ort Scenario: This scenario simulates a modern container port with neatly arranged containers, quay cranes, and cargo vessels engaged in loading and unloading operations.”
> - 场景数（p.17 §4.1.3）：“Urban Fire Scenario: This scenario recreates a dense urban setting with high-rise buildings and detailed textures for enhanced realism.”
> - 场景数（p.17 §4.1.3）：“Urban oving Target Tracking Scenario: This scenario simulates moving vehicles navigating an urban road network.”
> - 场景数（p.16 §4.1.2）：“The selections made by UAV-EAs generate divergent task trajectories, allowing the assessment of adaptive capabilities through path analysis and integrated scoring. Specifically, our benchmark implements two representative dynamic scenarios:”
> - 室内外（p.2 §1）：“Specifically, in the static real-world setting, we collect real UAV imagery under diverse conditions, including various terrains (e.g., ocean, city, hills), scenarios (e.g., fire, flood, traffic), and lighting”
> - 轨迹长度（p.29 §5.3.1）：“This task is structured with a total of 19 distinct nodes. The shortest possible execution path requires 7 steps, distributed across the three phases as 3, 3, and 1 step(s), respectively.”
> - 轨迹长度（p.32 §5.3.2）：“This task is structured with a total of 14 distinct nodes, and the UAV must make accurate decisions at each task node to avoid losing the target.”
> - 轨迹长度（p.36 §5.4.2）：“The shortest possible execution path requires 3 steps, distributed across the three phases as 1, 1, and 1 step, respectively.”
> - 规模（p.15 §4.1.1）：“The final test dataset comprises 154 images dedicated to perception evaluation, encompassing a total of 2,740 questions: 1,020 for semantic discrimination, 422 for semantic description, 582 for semantic target determination, 455 for spatial direction, and 261 for spatial distance assessment.”
> - 规模（p.15 §4.1.1）：“For decision evaluation, the dataset includes 30 images with 357 questions, distributed across 140 motion”
> - 规模（p.16 §4.1.1）：“The action evaluation subset contains 195 test cases, each involving the generation of 1 to 4 motion dictionaries.”
> - 动作空间（p.14 §4.1.1）：“As illustrated in Fig. 5, the action command dictionary includes eight types of control parameters derived from real UAV control systems.”
> - 动作空间（p.17 §4.2）：“The action interface allows the agent to control the UAV's behavior through a set of motion commands, supporting goal-directed task execution. The platform includes basic action APIs, such as takeoff, landing, directional navigation, turning, and view switching.”
> - 动作空间（p.18 §4.2）：“task-specific actions are supported, such as cargo loading/unloading for freight tasks or activating/deactivating water sprayers in firefighting missions.”
> - 动作空间（p.23 Fig. 7）：“1. Turn (left/right) 90 degrees. 2. Fly in a specific direction (left/right/forward/backward/up/down/ upleft/upright/downleft/downright). 3. Fly to specified coordinates, where the coordinates are specified by params (x, y).”
> - 动作空间（p.16 §4.1.2）：“Key task nodes extracted from drone videos form a decision-tree-based structure where each node offers multiple action options scored by strategic rationality.”
> - 观测（p.17 §4.2）：“The UAV is equipped with five configurable viewpoints: front, rear, left, right, and bottom. The agent can autonomously switch between these views to gather environmental information.”
> - 观测（p.17 §4.2）：“To reflect realistic UAV sensing capabilities, the interface provides access to a visible-light camera, considering payload and weight constraints.”
> - 观测（p.18 §4.2）：“Examples include UAV position, orientation, and viewpoint, as well as environmental conditions like fire status or whether the UAV has successfully landed on a moving platform.”
> - 观测（p.40 §6）：“The evaluation pipeline also relies exclusively on 2D visual inputs, without incorporating 3D sensory modalities such as LiDAR or depth maps”
> - 真机（p.3 §1）：“In the dynamic real-world setting, we record UAV flight videos and extract key frames from single-task execution sequences.”
> - 真机（p.3 §1）：“To address this, BEDI publicly releases real-world test samples as accessible datasets and provides a modular testing interface for virtual environments.”
> - 复用（p.15 §4.1.1）：“we collected images from multiple public UAV datasets, selecting representative scenes from domains including fire rescue, traffic surveillance, urban patrol, and field exploration.”
> - 复用（p.17 §4.2）：“Through secondary development of the AirSim plugin, we have encapsulated and redesigned its underlying control operations to provide three main categories of interaction interfaces: perception, action, and state.”
> - 复用（p.20 §4.3.1）：“this metric treats GPT-4o as an evaluation expert, using carefully designed prompts to guide the model in objectively assessing the relevance between the UAV-EA's response and the ground-truth answer.”
> - 动态因素（p.16 §4.1.2）：“This scenario simulates a continuously moving rider target within a complex environment featuring illumination changes, occlusions, and various distractions.”
> - 动态因素（p.17 §4.1.3）：“A building firefighting task is embedded, featuring dynamic flame and smoke effects along with simulated water-fire interaction.”
> - 动态因素（p.17 §4.1.3）：“A built-in route generation module supports both custom and random vehicle paths, increasing variability in the tracking task.”
> - 动态因素（p.40 §6）：“Furthermore, the simulation environment does not account for physical disturbances like weather variations or sensor noise, potentially overestimating model robustness in real- world conditions.”

## FlySearch

[arXiv 2506.02896](https://arxiv.org/abs/2506.02896) · 2025-06 · [[topics/papers/无人机VLN/2-03_2506.02896_FlySearch.pdf|PDF]]

- **任务**：目标搜索
- **场景来源**：游戏引擎合成（UE5 程序化生成）
- **引擎 / 数据来源**：Unreal Engine 5（自研仿真器，基于 UnrealCV 扩展的 UE 插件 + Python 评测控制器）
- **场景内容**：森林环境基于 UE 产品 demo “Electric Dreams Environment”，运行时完全程序化生成（随机岩石、树木密度）；城市环境基于 UE demo “City sample”，半程序化生成；另用 Unreal 官方市场免费资产；运行时生成干扰物（停放车辆、行走行人）
- **场景数**：2 类环境（森林、城市），可程序化生成无限场景；标准化挑战集 FS-1 400 个、FS-Anomaly-1 200 个、FS-2 200 个场景
- **面积**：城市地图约 4×4 km；FS-1 搜索区域 400×400×120 m，FS-2 为 2h×2h（h 为起始高度）
- **地域**：大型现代美式城市（基于 UE “City sample” demo）+ 稀疏森林（基于 “Electric Dreams Environment” demo）；未对应真实地点
- **室内外**：室外
- **飞行高度**：FS-1/FS-Anomaly-1 起始高度 30–100 m、最高 120 m；FS-2 起始 100–125 m、最高 300 m；成功需在目标最高点上方 10 m 以内
- **轨迹长度**：按步数限定：FS-1/FS-Anomaly-1 最多 10 步，FS-2 最多 20 步
- **规模**：FS-1 400 个、FS-Anomaly-1 200 个、FS-2 200 个场景；GRPO 微调用 Forest 生成 6750 个场景、67500 个训练样本
- **动作空间**：连续（1 m 分辨率）：文本命令 <action>(X, Y, Z)</action> 给出相对位移（米），由自动驾驶仪执行；FOUND 结束；0.5 m 内有障碍时碰撞规避系统停止移动
- **观测**：下视 500×500 RGB 图像（叠加坐标网格）+ 离地高度（1 m 精度）；目标文本描述；FS-2 额外提供目标俯视参考图
- **划分**：无固定训练集，提供 FS-1、FS-Anomaly-1、FS-2 三个标准化挑战集；微调基线在 Forest 环境训练、在 City 环境评测
- **复用**：UE demo “Electric Dreams Environment” 与 “City sample”、Unreal 市场免费资产；在 UnrealCV 基础上扩展
- **动态因素**：森林植被受风变化；城市中随机生成行走行人与停放车辆作干扰；太阳高度/方位角随机（FS-1 森林、FS-2），FS-2 开启动态光照模拟不同时段；不模拟阵风与天气突变，目标静止
- **备注**：成功判据：目标中心在视锥内、高度不超过目标最高点 10 m 且输出 FOUND；城市中目标放在语义合理位置（附录 B.1 题注写 31852 处、表 S1 写 38152 处，原文前后不一）；附录 H 讨论 sim2real 差距（无多相机/LiDAR/GPS、无硬件故障模拟）

> [!quote]- 原文依据（47 句）
> - 引擎 / 数据来源（§3.2）：“The FlySearch system consists of two main components: a simulator based on Unreal Engine 5 and a controller module.”
> - 引擎 / 数据来源（§3.2）：“The simulator-side implementation is provided as a native Unreal Engine plugin. We build upon the UnrealCV project [50], extending its functionality to allow full use of the aforementioned Unreal Engine 5 features.”
> - 场景来源（§1）：“It is built from scratch using the realistic Unreal Engine 5 [15], widely used for video games, providing dynamic 3D scenes with many assets.”
> - 场景来源（§3.1）：“The evaluation environment is a square outdoor area consisting of a fragment of a photorealistic procedurally generated map.”
> - 场景内容（§3.3）：“Forest environment is based on the “Electric Dreams Environment” Unreal Engine product demo [14]. It consists of sparse forest scenery, including randomly placed rock formations. The map is procedurally generated entirely at runtime by the scenario generator.”
> - 场景内容（§3.3）：“City environment is a large, modern, American-style city, based on the “City sample” Unreal Engine demo [13].”
> - 场景内容（§3.2）：“We also leveraged Unreal’s extensive online marketplace of free assets to create evaluation scenarios.”
> - 场景内容（§3.3）：“Furthermore, random distractor assets (parked cars and walking pedestrians) are spawned by the scenario generator at runtime.”
> - 场景数（Figure 3）：“Our benchmark consists of two types of evaluation environments, forest and city. For each environment, we can generate an infinite number of procedurally generated test scenarios.”
> - 场景数（§4）：“FS-1 contains 400 scenes of finding particular objects in the city and forest environments.”
> - 面积（§3.3）：“The city layout is a large, semi-procedurally generated map of roughly 4\times 4 km.”
> - 面积（§4）：“The search area is limited to 400\times 400\times 120 m, and the starting altitude to between 30 and 100 m, and the agent may not fly outside its field of view.”
> - 面积（Table S2）：“Search area bounds [m] | 400\times 400 | 2h\times 2h | Maximum altitude [m] | 120 | 300 |”
> - 地域（§3.3）：“City environment is a large, modern, American-style city, based on the “City sample” Unreal Engine demo [13].”
> - 地域（§3.3）：“Forest environment is based on the “Electric Dreams Environment” Unreal Engine product demo [14]. It consists of sparse forest scenery, including randomly placed rock formations.”
> - 室内外（Abstract）：“In this paper, we answer this question by introducing FlySearch, a 3D, outdoor, photorealistic environment for searching and navigating to objects in complex scenes.”
> - 飞行高度（§4）：“The search area is limited to 400\times 400\times 120 m, and the starting altitude to between 30 and 100 m, and the agent may not fly outside its field of view.”
> - 飞行高度（§4）：“Base setting is the same as in FS-1; however, starting altitude range is raised to between 100 and 125 m”
> - 飞行高度（§4）：“Moreover, dynamic scene lightning is enabled, simulating different times of day and the maximum allowed altitude is 300 m.”
> - 飞行高度（Appendix E）：“For a trajectory to be considered successful, at the end of it the agent must be located less than 10 meters above the object’s highest point.”
> - 轨迹长度（§4）：“The agent is explicitly instructed to find an object with a unique description in at most 10 actions.”
> - 轨迹长度（Appendix H）：“The benchmark limits agent interaction with the world to up to 20 steps due to the model context length limitations of most open-source VLMs.”
> - 规模（§4）：“FS-Anomaly-1 is a set of 200 scenes in the city and the forest, where the agent is instructed to find an object that seems out of place”
> - 规模（§4）：“FS-2 consists of 200 additional harder scenarios in the city environment.”
> - 规模（§4）：“FS-1 contains 400 scenes of finding particular objects in the city and forest environments.”
> - 规模（Appendix D）：“Using the Forest environment, we generate 6750 unique exploration scenarios. In each scenario, we pre-record a flight trajectory from the starting point to the target.”
> - 动作空间（§3.1）：“Instead, it can focus on exploration by providing simple text commands with the tag <action>(X, Y, Z)</action>, where each of the coordinates represents a relative position change in meters in the corresponding direction.”
> - 动作空间（§3.1）：“We introduce a collision avoidance system that stops the movement if an obstacle is detected within a 0.5 meter radius of the camera position, or if it tries to move out of the fly zone.”
> - 动作空间（Appendix H）：“FlySearch uses high-level relative movement actions with 1 m resolution.”
> - 动作空间（§3.1）：“When the agent decides that it has completed the task, it should respond with the FOUND text and end the exploration.”
> - 观测（§3.1）：“At each exploration step, we provide the agent with a 500\times 500 pixel RGB image from the simulated UAV camera. To simplify the task, the camera is always facing the ground.”
> - 观测（§3.1）：“The camera image is overlaid with a grid of coordinates to help the model understand movement directions and distances [29]. Additionally, we provide the agent with its height above the ground.”
> - 观测（§3.1）：“In case of FS-2, we also provide the agent with the image specifying how searched object should look like from above”
> - 观测（Appendix H）：“Our benchmark limits sensor inputs to a downward-facing camera and altitude reading with 1 m accuracy.”
> - 划分（§4）：“However, to facilitate further research and enable fair comparisons, we propose three standardized challenges, i.e., sets of reproducible scenes that can be used to evaluate agents under the same conditions.”
> - 划分（Appendix D）：“To provide a reasonable baseline score for fine-tuning VLMs for spatial reasoning we train the Qwen VL 2.5 7B [5] model on the Forest environment and evaluate it on the City environment in both FS-1 and FS-2.”
> - 复用（§3.3）：“City environment is a large, modern, American-style city, based on the “City sample” Unreal Engine demo [13].”
> - 复用（§3.3）：“Forest environment is based on the “Electric Dreams Environment” Unreal Engine product demo [14].”
> - 复用（§3.2）：“The simulator-side implementation is provided as a native Unreal Engine plugin. We build upon the UnrealCV project [50], extending its functionality to allow full use of the aforementioned Unreal Engine 5 features.”
> - 动态因素（§3.3）：“The map is procedurally generated entirely at runtime by the scenario generator. Moreover, all vegetation on the map is subject to wind changes.”
> - 动态因素（§3.3）：“Furthermore, random distractor assets (parked cars and walking pedestrians) are spawned by the scenario generator at runtime.”
> - 动态因素（§4）：“Moreover, dynamic scene lightning is enabled, simulating different times of day and the maximum allowed altitude is 300 m.”
> - 动态因素（§1）：“Moreover, procedural generation allows the generation of an unlimited number of scenarios with varying environmental characteristics, such as time of day, forest density, and UAV launch altitude.”
> - 动态因素（Appendix H）：“Moreover, FlySearch omits some of the flight-related dynamics, such as sudden gusts of wind or abrupt weather changes, that were deemed too complex for current foundational VLMs.”
> - 动态因素（Appendix H）：“The searched object is stationary (may be animated but remains in the same location), unique for the scenario (visually similar but semantically different objects may exist on the map), and visible from the top.”
> - 备注（Table S1）：“Lastly, objects can be placed anywhere in the forest environment and in one of 31852 semantically correct locations in the city environment.”
> - 备注（Appendix H）：“Furthermore, real-life platforms may feature multiple cameras, LIDAR/RADAR, GPS units, IMU, and other sensor modalities that are not simulated in FlySearch.”

## UAV-ON

[arXiv 2508.00288](https://arxiv.org/abs/2508.00288) · 2025-08 · [[topics/papers/无人机VLN/2-04_2508.00288_UAV-ON.pdf|PDF]]

- **任务**：目标搜索
- **场景来源**：游戏引擎合成
- **引擎 / 数据来源**：Unreal Engine + Microsoft AirSim
- **场景内容**：UE 高保真室外环境（论文未说明资产来源），场景按语义区域标注；目标物体由 LLM（GPT-4o-mini-high）按区域类型生成候选、人工筛选后放置到合适位置，共 1270 个目标；目标描述由 GPT-4 基于多视角图像生成
- **场景数**：14 个（训练 10 + 额外测试 4）
- **面积**：单场景水平尺度 350×250 至 1400×1250 units；总水平面积约 900 万平方 units
- **地域**：未给出真实地名；区域类别含 village、town、city、park、road、forest、mountain、snowy mountain、water area（城市、公路、森林、水域、山地等）
- **室内外**：室外
- **飞行高度**：未规定飞行高度范围；步数上限推导时假设下视相机在 5 m 高度悬停
- **轨迹长度**：目标位于起点水平半径 50 units 内；每回合最多 150 步
- **规模**：1270 个目标；训练 10,000 episodes + 测试 1,000 episodes（共 11,000+ 任务）
- **动作空间**：参数化动作（离散原语 + 连续幅度）：Move Forward/Left/Right、Ascend、Descend、Rotate Left/Right、Stop，每个动作带距离或角度参数；动作物理执行而非瞬移
- **观测**：前/左/右/下四路同步 RGB-D；无 GPS、俯视地图或外部定位；训练时可获取绝对位置与到目标的实时欧氏距离
- **划分**：训练：10 个环境 10,000 episodes；测试：1,000 episodes，覆盖 10 个训练环境 + 4 个新环境；训练环境中部分目标替换为未见类别，新环境含复用和全新类别
- **复用**：Unreal Engine + AirSim；成功判定沿用 AerialVLN（停在目标 20 units 内）
- **备注**：碰撞即失败；场景体素化为 1-unit 网格并用 3D A* 计算最短路径作为专家轨迹/SPL 参考；轨迹可视化示例场景名 BrushifyUrban

> [!quote]- 原文依据（27 句）
> - 引擎 / 数据来源（§4）：“We build our benchmark using Unreal Engine [11] and Microsoft AirSim [33], which support realistic UAV navigation and large-scale task design across diverse environments.”
> - 场景来源（§5.1）：“UAV-ON consists of high-fidelity outdoor environments developed in Unreal Engine, capturing a broad spectrum of natural and artificial landscapes.”
> - 室内外（§5.1）：“UAV-ON consists of high-fidelity outdoor environments developed in Unreal Engine, capturing a broad spectrum of natural and artificial landscapes.”
> - 场景内容（§5.1）：“For each region type, a large language model (LLM) is queried with scene-specific prompts to generate candidate objects that are likely to appear in that setting.”
> - 场景内容（§5.1）：“The generated results are manually filtered to ensure semantic relevance and spatial plausibility. Ambiguous or visually indistinct categories are removed, and selected objects are placed at navigable, context-appropriate locations.”
> - 场景内容（Appendix A）：“we propose a prompt-based knowledge extraction method using the GPT-4o-mini-high model. The goal is to establish a mapping from high-level scene semantics (e.g., village, forest, road) to object categories that are commonly found in those settings.”
> - 场景数（Abstract）：“UAV-ON comprises 14 high-fidelity Unreal Engine environments with diverse semantic regions and complex spatial layouts, covering urban, natural, and mixed-use settings.”
> - 面积（§5.2）：“Each scene contains multiple semantically labeled regions and varies in horizontal scale (e.g., from 350\times 250 to 1400\times 1250 units), resulting in rich spatial and structural diversity for aerial navigation.”
> - 面积（§5.2）：“Across all scenes, we place a total of 1270 unique target objects over a total horizontal area of approximately 9 million square units, yielding an average object density of about 1.4 per 100 square units.”
> - 地域（§5.1）：“All environments are segmented into regions labeled with semantic categories, including village, town, city, park, road, forest, mountain, snowy mountain, and water area.”
> - 地域（§1）：“UAV-ON features a diverse range of outdoor settings, including urban landscapes, highways, forests, waterways, and mountainous terrain, designed to capture the semantic richness and visual complexity of real-world environments.”
> - 飞行高度（Appendix C）：“For typical small to medium-sized objects, we assume that the downward-facing camera provides sufficient coverage when the UAV hovers at an altitude of 5 meters, enabling reliable ground-level visibility without excessive occlusion”
> - 轨迹长度（§3）：“The goal object is guaranteed to lie within a horizontal search radius r=50 units centered at the starting location.”
> - 轨迹长度（§3）：“Each episode terminates when the agent outputs a Stop command, collides with an obstacle, or reaches the maximum step limit of 150.”
> - 规模（§1）：“UAV-ON defines over 11,000 navigation tasks using compact semantic goal instructions, spanning 14 high-fidelity outdoor scenes with diverse layouts and realistic object placements.”
> - 规模（Abstract）：“It defines 1270 annotated target objects, each characterized by an instance-level instruction that encodes category, physical footprint, and visual descriptors, allowing grounded reasoning.”
> - 动作空间（§4.2）：“Translational primitives include Move Forward, Move Left, Move Right, Ascend, and Descend, while rotational actions comprise Rotate Left and Rotate Right. Each selected action is defined by a corresponding distance or angular displacement”
> - 动作空间（§4.2）：“Actions are physically executed rather than teleported, requiring agents to ensure each selected motion yields a collision-free trajectory. Any contact with obstacles is considered a failure”
> - 观测（§4.1）：“the UAV obtains multi-modal observations through four synchronized RGB-D cameras oriented forward, leftward, rightward, and downward, enabling diverse perception of the environment from a limited egocentric perspective.”
> - 观测（§4.1）：“The agent operates without access to any global localization signals, including GPS, top-down maps, or external positioning systems.”
> - 观测（§5.3）：“During training, the UAV can access its absolute position and the real-time Euclidean distance to the target, allowing reinforcement learning [34] methods to optimize navigation strategies”
> - 划分（§5.3）：“We construct the training set using 10 diverse outdoor environments, generating a total of 10,000 navigation episodes.”
> - 划分（§5.3）：“For evaluation, we collect a total of 1,000 test episodes across both the 10 training environments and 4 additional environments.”
> - 划分（§5.3）：“In addition, several targets in the training environments are replaced with unseen categories, while the held-out environments include both reused and entirely new object categories.”
> - 复用（§3）：“Following [21], a success episode is defined by the agent stopping within 20 units of the target object.”
> - 复用（§4）：“We build our benchmark using Unreal Engine [11] and Microsoft AirSim [33], which support realistic UAV navigation and large-scale task design across diverse environments.”
> - 备注（§5.3）：“we voxelize each scene into 1-unit 3D grids and apply a three-dimensional A* algorithm [15] to compute the shortest traversable path from the agent to the target.”

## HaL-13k 数据集 / DuAl-VLN 任务（框架 AeroDuo）

[arXiv 2508.15232](https://arxiv.org/abs/2508.15232) · 2025-08 · [[topics/papers/无人机VLN/1-10_2508.15232_AeroDuo.pdf|PDF]]

- **任务**：目标搜索
- **场景来源**：游戏引擎合成
- **引擎 / 数据来源**：OpenUAV 平台（AirSim 支持航点/速度控制）；低空避障策略另在 Isaac Sim 中训练
- **场景内容**：沿用 OpenUAV 平台环境；低空路径由 UAV-Need-Help 路径经点云占据图 + A* 优化，高空路径在可见性约束下随机采样
- **场景数**：14
- **室内外**：室外
- **飞行高度**：高低双机：两机水平起点相同、高空机初始高度高于低空机（具体高度未给出）
- **规模**：13,838 对同步的高-低双机轨迹，各配目标导向指令
- **动作空间**：连续：预测后续航点序列或速度（AirSim 支持），低空机控制频率 10 Hz
- **观测**：低空机：前向图像 + 全向点云；高空机：BEV 图像 + LiDAR 点云图（同视场），并拼接为正射全局地图；语言指令
- **划分**：验证集分 Unseen Map（2 个未见场景，175 个 episode）与 Unseen Object（训练场景中的未见物体类别，175 个 episode）
- **复用**：OpenUAV 平台与 UAV-Need-Help（TravelUAV）路径；目标定位沿用其 GroundingDINO；避障导航器在 Isaac Sim 训练；Pilot-LLM 用 RefCOCO 预训练
- **备注**：轨迹由 A* 规划/随机采样生成而非人工飞行；碰撞或超时即失败，成功阈值 20 m；两机只交换坐标信息

> [!quote]- 原文依据（18 句）
> - 场景来源（§3.2）：“To advance the DuAl-VLN task, we deliberately construct a dataset, HaL-13k, upon the OpenUAV (Wang et al., 2024b) platform, which could provide realistic UAV sensory data, diverse environments, and dynamic flight characteristics.”
> - 引擎 / 数据来源（§3.1）：“Leveraging these multi-modal inputs, the UAVs dynamically adjust their flight trajectories by predicting either subsequent waypoint sequences or velocity profiles supported by Airsim (Shah et al., 2018).”
> - 引擎 / 数据来源（§1）：“For the low-altitude UAV, we deploy a navigation policy trained in the Isaac Sim (Makoviychuk et al., 2021) simulation environment, combining a lightweight obstacle avoidance controller and a visual grounding model to precisely localize target objects.”
> - 场景内容（§3.2）：“Specifically, for the low-altitude UAV path planning, we first construct an occupancy map from point clouds. The A* algorithm (Hart et al., 1968) is then used to compute optimized navigation paths that conform to these occupancy constraints.”
> - 场景内容（Figure 2）：“(a) We optimize the paths from UAV-needs-Help (Wang et al., 2024b) to maintain an effective exploration altitude for the low-altitude UAV. (b) We randomly sample paths of the high-altitude UAV that obey visibility constraints”
> - 场景数（§1）：“To advance this task, we curate a dataset, HaL-13k, based on the OpenUAV platform (Wang et al., 2024b) with 13,838 synchronized dual-altitude trajectories across 14 scenarios.”
> - 室内外（Abstract）：“Aerial Vision-and-Language Navigation (VLN) is an emerging task that enables Unmanned Aerial Vehicles (UAVs) to navigate outdoor environments using natural language instructions and visual cues.”
> - 飞行高度（§3.1）：“At the beginning of each episode, the low-altitude UAV U_{l} and the high-altitude UAV U_{h} are initialized at positions P^{l}_{0}=(x^{l}_{0},y^{l}_{0},z^{l}_{0}) and P^{h}_{0}=(x^{h}_{0},y^{h}_{0},z^{h}_{0}) , respectively, with x^{l}_{0}=x^{h}_{0} , y^{l}_{0}=y^{h}_{0} , and z^{h}_{0}>z^{l}_{0} .”
> - 规模（§3.2）：“As shown in Fig. 2, this generation strategy yields a dataset of 13,838 collaborative trajectory pairs, each annotated with target-oriented language instructions for search target”
> - 动作空间（§3.1）：“Leveraging these multi-modal inputs, the UAVs dynamically adjust their flight trajectories by predicting either subsequent waypoint sequences or velocity profiles supported by Airsim”
> - 动作空间（§5.1）：“The low-altitude UAV U_{l} operates at a control frequency of 10 Hz, with each time step t spanning 0.1 seconds.”
> - 观测（§3.1）：“Specifically, at each time step t , U_{l} captures forward-facing visual image I^{l}_{t} and omnidirectional point cloud data V^{l}_{t} . At each time step \tau , U_{h} captures a BEV observation I^{h}_{\tau} along with a Lidar point cloud map V^{h}_{\tau} , both covering the same field of view.”
> - 观测（§4.2）：“These reprojected views are then stitched together to produce the global orthographic map G_{\tau} .”
> - 划分（§3.2）：“Unseen Map Set consists of environments absent from the training data. We sample 2 scenes as unseen maps and extract all associated trajectories for testing, resulting in 175 episodes.”
> - 划分（§3.2）：“Unseen Object Set comprises trajectories from training-familiar scenes but introduces object categories never encountered during training, yielding 175 test episodes.”
> - 复用（§4.3）：“We follow (Wang et al., 2024b) to adopt GroundingDINO (Liu et al., 2023a) as the detector f_{g} , enabling target localization based on textual instructions.”
> - 复用（§4.4）：“To boost the model’s general perception ability, we first train the Pilot-LLM on referring segmentation and depth estimation based on the RefCOCO dataset (Yu et al., 2016).”
> - 备注（§3.1）：“A navigation episode is considered failed if either the U_{l} exceeds the navigation-time upper-bound without reaching the target or the UAVs collide with obstacles.”

## SpatialSky-Bench（配套训练集 SpatialSky-Dataset、模型 Sky-VLM）

[arXiv 2511.13269](https://arxiv.org/abs/2511.13269) · 2025-11 · [[topics/papers/无人机VLN/1-11_2511.13269_SpatialSky-Bench.pdf|PDF]]

- **任务**：静态问答
- **场景来源**：卫星/航拍影像（复用 UAVScenes 无人机多模态数据集：图像 + LiDAR + 位姿 + 掩码标注）
- **引擎 / 数据来源**：UAVScenes 数据集（RGB 图像、LiDAR 点云、无人机位姿、语义掩码），按规则 + VLM 自动生成 QA
- **场景内容**：UAVScenes 的 20,000 张图像及对应 LiDAR（文中称 radar data）与掩码级类别标注，覆盖 22 类物体
- **规模**：基准约 1,000 个 QA（13 个细粒度任务、22 类物体）；训练集 SpatialSky-Dataset 1M 样本；RL 数据 30K 样本
- **观测**：单张无人机视角图像或多图序列（时序描述任务）；数据生成用到 RGB、语义掩码、LiDAR 深度、位姿与边界框
- **划分**：从生成数据中分层采样约 1,000 个 QA 作基准，并从训练集删除同一图像的所有其他 QA，保证基准图像全部未见
- **复用**：UAVScenes（Wang et al. 2025, ICCV）
- **备注**：论文对场景本身（地点、高度、场景数）几乎未作说明，只说复用 UAVScenes。文本中基准名被 LaTeX 颜色宏打乱（显示为 'SpatialSk0.75294 0 0y'）。

> [!quote]- 原文依据（10 句）
> - 场景来源（§3.1）：“-Dataset integrates annotations from UAVScenes [37], which include 20,000 images along with corresponding radar data and class labels at the mask level, covering 22 object categories.”
> - 引擎 / 数据来源（Figure 3 caption / §3）：“Our generation pipeline take multimodal inputs, including RGB images, semantic labels, LiDAR depth data, UAV pose information, and bounding boxes. Using a VLM-based generation method and human expert validation, we automatically generate diverse question-answer pairs for 13 spatial reasoning tasks.”
> - 场景内容（§3.1）：“-Dataset integrates annotations from UAVScenes [37], which include 20,000 images along with corresponding radar data and class labels at the mask level, covering 22 object categories.”
> - 规模（§3.3）：“we carefully selected approximately 1,000 QA pairs from the generated dataset, ensuring balanced coverage of all 13 fine-grained tasks, 22 object categories, and various scene types.”
> - 规模（§1 contributions）：“-Dataset, a large-scale dataset containing 1 M samples generated through an automated process, including various annotation formats including open question-answer, multiple choice, pointing, and bounding boxes, covering all benchmark tasks.”
> - 规模（§4）：“We constructed a reinforcement learning dataset containing 30,000 samples, focusing on tasks requiring precise localization and structured output.”
> - 观测（§4）：“The model employs a multimodal architecture flexibly handling both single-image and multi-image inputs for UAV spatial reasoning.”
> - 观测（§1）：“Our data generation process utilizes multimodal inputs, including RGB images, semantic mask labels, LiDAR depth data, pose information, and bounding box annotations, to automatically generate origin dataset and question-answer pairs covering all 13 benchmark tasks.”
> - 划分（§3.3）：“Crucially, after selecting these benchmark samples, we removed all other QA pairs associated with the same images from the training dataset, ensuring the benchmark consists entirely of unseen images to prevent data leakage”
> - 复用（References [37]）：“UAVScenes: a multi-modal dataset for uavs. In Proceedings of the IEEE/CVF International Conference on Computer Vision,”

## IndoorUAV（IndoorUAV-VLN / IndoorUAV-VLA）

[arXiv 2512.19024](https://arxiv.org/abs/2512.19024) · 2025-12 · [[topics/papers/无人机VLN/1-12_2512.19024_IndoorUAV.pdf|PDF]]

- **任务**：VLN
- **场景来源**：室内扫描数据集
- **引擎 / 数据来源**：Habitat 模拟器（移除 navmesh 约束以允许三维自由飞行）
- **场景内容**：从 Matterport3D (MP3D)、Gibson、HM3D、Replica 四个室内数据集中人工挑选整理，涵盖住宅、办公与公共空间
- **场景数**：1075（“over 1,000”）
- **室内外**：室内
- **轨迹长度**：IndoorUAV-VLN 平均 21.6 m；IndoorUAV-VLA 平均 2.2 m
- **规模**：共 50965 条轨迹：IndoorUAV-VLN 16040 条，IndoorUAV-VLA 34925 条
- **动作空间**：离散 4 DoF：前进、升降、左右平移、偏航；双尺度动作（前进 0.15 m / 0.9 m，转向 3° / 15°）；VLA 基线则输出连续位姿序列 (x,y,z,θ)
- **观测**：第一视角视觉观测（VLA：初始观测 + 当前观测 + 当前状态 (x,y,z,θ)；VLN：历史观测序列）+ 语言指令
- **划分**：IndoorUAV-VLN 测试分 seen / unseen 环境（TEST SEEN / TEST UNSEEN）；IndoorUAV-VLA 有 test split，具体划分规则未说明
- **复用**：Habitat 模拟器；MP3D、Gibson、HM3D、Replica 场景
- **备注**：轨迹由经验丰富的操作员在模拟器中人工遥控采集，再做轨迹反转增广；GPT-4o/GPT-4 基于关键帧自动生成两种粒度指令；VLA 子集由长轨迹按关键帧切分而来。

> [!quote]- 原文依据（18 句）
> - 引擎 / 数据来源（IndoorUAV Benchmark / Environment Source）：“All selected environments are compatible with the Habitat simulator, enabling efficient data generation with realistic physics and photorealistic rendering.”
> - 引擎 / 数据来源（IndoorUAV Benchmark / Data Collection）：“we first remove the built-in navigation mesh (navmesh) constraints from the environmints, allowing agents to move freely in three dimensions of space.”
> - 场景来源（IndoorUAV Benchmark / Environment Source）：“We construct the IndoorUAV benchmark within high-fidelity simulated 3D indoor environments drawn from four widely-used 3D indoor space datasets in the embodied AI community: Matterport3D (MP3D), Gibson, HM3D, and Replica.”
> - 场景内容（IndoorUAV Benchmark / Environment Source）：“These environments encompass a diverse range of residential, office, and public spaces, offering rich variability in layout, appearance, and object distribution. From these sources, we manually select and curate over 1,000 high-quality scenes”
> - 场景数（Dataset Analysis）：“As shown in Table 1, IndoorUAV is constructed from a diverse collection of 1,075 photorealistic indoor scenes, significantly surpassing all previous VLN datasets in terms of scene diversity.”
> - 室内外（Introduction）：“we introduce IndoorUAV benchmark specifically designed for aerial VLN in 3D indoor environments.”
> - 轨迹长度（Table 1）：“IndoorUAV-VLN | 16040 | 3.9K | 21.6 | 112 | 4 DoF | 1075 | Mp3D, Gibson, HM3D, Replica | IndoorUAV-VLA | 34925 | 2.2K | 2.2 | 14.5 | 4 DoF | 1075 | Mp3D, Gibson, HM3D, Replica”
> - 轨迹长度（Table 1 caption）：“Path Len: the average length of trajectories, measured in meters.”
> - 规模（Dataset Analysis）：“In total, the dataset comprises 50965 navigation trajectories, each representing a 4-DoF UAV trajectory that supports horizontal translation, vertical movement, and yaw rotation.”
> - 规模（IndoorUAV-VLA Collection）：“As shown in the Table 1, IndoorUAV-VLA contains 34,925 short trajectories, but the average instruction length is only 14.5 words.”
> - 动作空间（Data Collection）：“We define a 4 degree-of-freedom (4 DoF) UAV action space, consisting of (1) forward movement, (2) vertical translation (up/down), (3) lateral motion (left/right), and (4) yaw rotation”
> - 动作空间（Dataset Analysis）：“fly_forward_small moves the UAV forward by 0.15 meters, while fly_forward_large performs a 0.9 meters step; turn_left_small and turn_right_small rotate the UAV by 3°, while turn_left_large and turn_right_large perform turns of 15°.”
> - 动作空间（Model Architecture）：“This model takes as input the current egocentric visual observation and a short natural language instruction, and outputs continuous low-level controls in the form of a predicted trajectory.”
> - 观测（Baseline Models / VLA Models）：“At each time step t , the agent receives the initial observation o_{1} , current observation o_{t} , and current state s_{t} . The state is defined as a tuple of 3D coordinates and a yaw angle”
> - 观测（Baseline Models / VLN Models）：“At each time step t , the agent receives a navigation instruction \mathcal{I} , along with a sequence of past observations”
> - 划分（Quantitative results / IndoorUAV-VLN）：“Our IndoorUAV-Agent method achieves the best performance across all metrics, attaining 7.29% and 5.06% SR in seen and unseen environments respectively”
> - 划分（Table 2 caption）：“Table 2: Comparison results on the IndoorUAV-VLA test split. ∗ indicates models fine-tuned on the dataset.”
> - 复用（Introduction）：“To construct IndoorUAV, we first curate over 1,000 high-quality 3D indoor environments from the Habitat simulator (szot2021habitat; habitat19iccv).”

## AirNav

[arXiv 2601.03707](https://arxiv.org/abs/2601.03707) · 2026-01 · [[topics/papers/视觉语言导航VLN/4-27_2601.03707_AirNav.pdf|PDF]]

- **任务**：VLN
- **场景来源**：真实城市三维重建
- **引擎 / 数据来源**：CityFlight 交互飞行环境（SensatUrban 点云对齐 OpenStreetMap）
- **场景内容**：SensatUrban 高密度 3D 点云（Cambridge、Birmingham）+ CityRefer 物体自然语言描述；起点随机采样，目标与中间地标由 MLLM 选取描述
- **地域**：英国 Cambridge 与 Birmingham
- **室内外**：室外（实机测试另含室内）
- **飞行高度**：固定高度的平面导航（具体高度未给出）
- **轨迹长度**：按训练集路径长度分位数分级：Easy <135 m、Medium 135–230 m、Hard ≥230 m；多数轨迹含 2–6 个中间地标
- **规模**：137K 导航样本；词表 20.3K；10 种用户画像生成指令，指令长度峰值约 100 词
- **动作空间**：离散：MOVE_FORWARD 5 m、TURN_LEFT/TURN_RIGHT 30°、STOP；每步输出至多 8 个动作的序列
- **观测**：当前与历史第一视角图像 + 无人机状态（位置与航向角）+ 历史动作序列 + 语言指令
- **划分**：Train / val-seen（与 Train 同环境）/ val-unseen / test-unseen（取自新环境）
- **真机**：有：DJI Tello TLW004 实机，室内、室外各 100 个任务共 200 个，无额外微调，固定高度；AirVLN-R1 成功 53/200
- **复用**：SensatUrban、CityRefer、CityFlight（CityNav）、OpenStreetMap；轨迹合成沿用 AerialVLN 的 look-ahead 策略；GPT-4o 生成指令
- **动态因素**：未涉及；作者指出季节变化与极端光照等条件未覆盖
- **备注**：轨迹为自动合成而非人工飞行；Table 1 将动作空间标为 4 DoF，但实际动作集仅含前进/左右转/停止；作者承认数据源与场景覆盖受 SensatUrban/CityRefer 区域限制，航拍视角与高度分布相对固定

> [!quote]- 原文依据（23 句）
> - 场景来源（Abstract）：“To address this, we propose AirNav, a large-scale benchmark built on real urban aerial data, comprising 137K navigation samples with natural and diverse instructions generated via a human–LLM collaborative pipeline with 10 user personas.”
> - 引擎 / 数据来源（§3.2）：“The environment is constructed based on the CityFlight Lee et al. (2024), which aligns the SensatUrban data with OpenStreetMap. CityFlight forms an interactive flight environment and provides interfaces for accessing various types of information, such as environmental images and object coordinates.”
> - 场景内容（§3.2）：“AirNav is built upon the SensatUrban Hu et al. (2022) and CityRefer Miyanishi et al. (2023) datasets. SensatUrban provides high-density 3D point cloud data with rich geographic structures, covering two cities, Cambridge and Birmingham.”
> - 场景内容（§3.2）：“The start point is randomly sampled from the map as a feasible coordinate to initialize the navigation episode. A geographical object with well-defined spatial boundaries is selected as the navigation target.”
> - 地域（§3.2）：“SensatUrban provides high-density 3D point cloud data with rich geographic structures, covering two cities, Cambridge and Birmingham.”
> - 室内外（Appendix H）：“The UAV operates in an urban environment with visible roads, buildings, and landmarks.”
> - 室内外（§1）：“We deploy AirVLN-R1 on a physical UAV platform and conduct real-world navigation experiments across indoor and outdoor scenarios, providing initial evidence for practical deployment and sim-to-real transfer.”
> - 飞行高度（Appendix K）：“In both indoor and outdoor settings, the UAV maintains a fixed altitude throughout each navigation task; ascending and descending actions are excluded from the action space. Navigation trajectories are therefore planar, which is consistent with the benchmark design”
> - 轨迹长度（§3.3）：“We categorize navigation paths into three difficulty levels based on path length percentiles of the training set: Easy ( <135 m), Medium (135–230m), and Hard ( \geq 230 m).”
> - 轨迹长度（§3.3）：“As shown in Fig. 2 (c), most trajectories contain between 2 and 6 intermediate landmarks, with 4 to 5 being the most prevalent”
> - 规模（§1）：“AirNav contains 137K navigation samples and explicitly models instruction diversity through 10 user personas.”
> - 规模（§3.3）：“In addition, AirNav exhibits a vocabulary size of 20.3k, which is significantly larger than that of existing UAV VLN datasets, indicating higher linguistic diversity and reduced repetition in instruction expressions.”
> - 动作空间（Appendix H）：“Discrete Action Space: - MOVE_FORWARD: move straight 5 meters in the current heading - TURN_LEFT: rotate left 30 degrees - TURN_RIGHT: rotate right 30 degrees - STOP: stop the flight”
> - 动作空间（§4.2.2）：“The model outputs a variable-length sequence of up to 8 discrete actions, representing the actions required to proceed from the current state.”
> - 观测（§3.1）：“where v_{i} denotes the first-person image captured by the UAV at step i , S_{t} represents the current UAV state including its spatial position and heading angle, A_{1:t-1} is the sequence of actions executed from the start up to the previous step, and L denotes the instruction”
> - 划分（§3.3）：“The val-seen split shares the same environments as Train and is used to evaluate model performance in known scenes, while val-unseen and test-unseen are sampled from novel environments to assess generalization under unseen conditions.”
> - 真机（§5.5.1）：“The experiments cover two typical settings—indoor and outdoor—each containing 100 navigation tasks with varying levels of path complexity.”
> - 真机（Appendix K）：“The experimental UAV was a DJI Tello TLW004, equipped with a camera, a Vision Positioning System, a barometer, an infrared sensor, and an inertial measurement unit.”
> - 真机（§5.5.2）：“Compared with all baselines, AirVLN-R1 reaches SR =53/200 and achieves the lowest NE (70.6), maintaining a consistent relative advantage in the real-world environment that aligns with the simulation evaluation.”
> - 复用（§3.2）：“For each pair of consecutive nodes, such as the start point and the first landmark or two adjacent landmarks, we apply a look-ahead strategy Liu et al. (2023) to generate an executable action sequence for the corresponding path segment.”
> - 复用（§3.2）：“The trajectory, map, and the spatial positions and semantic descriptions of all nodes are provided as inputs to GPT-4o, which generates navigation instructions covering target descriptions, path guidance, spatial relations, and trigger conditions.”
> - 动态因素（§7.1）：“As a result, the generalization ability of models across different cities, countries, and seasonal conditions remains to be validated with more diverse data.”
> - 备注（§7.1）：“In addition, aerial imagery often exhibits relatively fixed viewpoints and altitude distributions, which may not fully capture the more complex altitude variations, occlusion patterns, and extreme lighting conditions encountered in real-world UAV VLN tasks.”

## HUGE-Bench

[arXiv 2603.19822](https://arxiv.org/abs/2603.19822) · 2026-03 · [[topics/papers/语义3DGS与具身导航/2-10_2603.19822_HUGE-Bench.pdf|PDF]]

- **任务**：任务级评测
- **场景来源**：3DGS 重建
- **引擎 / 数据来源**：Isaac Sim（PhysX）+ 对齐的 3DGS–Mesh 数字孪生（3DGS 负责渲染，mesh 负责碰撞/深度）
- **场景内容**：用 DJI M400 + Zenmuse L2 实地航拍采集，经工业航测流程重建 mesh 并训练 3DGS；四类场景：办公楼、密集城市街区、沼泽与农田、施工道路
- **场景数**：4
- **面积**：约 6.45 km²
- **室内外**：室外
- **飞行高度**：实采航拍约 85 m 离地，另补充低空视角；地标定位用约 60 m 俯视相机；任务轨迹高度随机化（未给统一范围）
- **轨迹长度**：轨迹总长 2.56M 米；轨迹长度/指令词数 32.07 m/w；Mapping 最长，Landing/Orbit/Spiral Down 较短
- **规模**：8 类高层任务；train 5,330 条，test-seen 593 条，test-unseen 294 条
- **动作空间**：连续：策略预测速度指令或下一状态（4-DoF 状态）
- **观测**：RGB（或 RGBD）、深度（mesh 光线投射）、4-DoF 状态、子任务阶段；基线输入首帧 + 当前帧
- **划分**：train / test-seen / test-unseen：seen 为目标地标出现在训练集但初始位姿随机；unseen 由留出地标（Landmark-unseen）和 LLM 改写指令（Instruction-unseen）构成
- **真机**：场景来自真机航拍采集；另采集 500 条真实 Inspection-B 轨迹用于 real-to-sim 对比（评测仍在仿真中）
- **复用**：Isaac Sim；沿用 UAV-Flow 的首帧 + 当前帧输入设定；RRT 规划器生成避障轨迹
- **动态因素**：无：当前基准主要是静态环境，作者将移动障碍、光照与天气变化列为局限
- **备注**：每个场景需 8–10 小时专业飞行 + 12–15 小时重建对齐；mesh 做去漂浮物与减面；水平视角渲染时 3DGS 背景空洞，用固定天空图合成背景。

> [!quote]- 原文依据（24 句）
> - 场景来源（Figure 1 caption）：“Our benchmark comprises four 3DGS–Mesh digital-twin environments reconstructed from real-world scenes, eight high-level UAV VLA tasks, and 2.56 million meters of trajectory data.”
> - 引擎 / 数据来源（§3.2）：“Trajectory collection is conducted in Isaac Sim [22], which offers GPU-accelerated rendering and PhysX-based rigid-body simulation. First, we import the aligned 3DGS–Mesh digital twin into the simulator.”
> - 引擎 / 数据来源（§3.2）：“3DGS provides high-fidelity renderings for realistic perception inputs. The mesh provides collision-enabled geometry and supports physics-based queries, as well as depth via ray casting.”
> - 场景内容（§3.2）：“We collect data using a DJI M400 UAV equipped with a Zenmuse L2 payload across four representative outdoor scenes: office buildings, dense urban blocks, swamp and farmland, and construction roads.”
> - 场景内容（Appendix 0.A）：“We first process the raw data with an industrial aerial mapping pipeline to recover georeferenced camera poses and a metrically consistent mesh reconstruction. Based on the recovered poses, we further train a 3DGS model for photorealistic view synthesis.”
> - 场景数（Abstract）：“HUGE-Bench comprises 4 real-world digital twin scenes, 8 high-level tasks, and 2.56M meters of trajectories”
> - 面积（§3.2）：“The total covered area is approximately 6.45~\mathrm{km}^{2} . Flights are performed at \sim 85~\mathrm{m} above ground”
> - 室内外（§3.4）：“This design aims to evaluate a model’s ability to generalize across both outdoor environments and natural-language instructions.”
> - 飞行高度（§3.2）：“Flights are performed at \sim 85~\mathrm{m} above ground, recording GPS from GNSS, UAV pose, camera pose, and high-resolution RGB images ( 5280\times 3956 ). To improve reconstruction quality at near-ground altitudes, we additionally capture supplementary low-altitude views.”
> - 飞行高度（§3.2）：“We place a grid of top-down cameras at \sim 60~\mathrm{m} altitude and render the 3DGS scene to obtain global 2D map views, while rendering the mesh to obtain aligned depth.”
> - 飞行高度（§3.4）：“the initial observation in the first frame is randomized, including the agent’s altitude, horizontal distance to the target, and the relative direction with respect to the landmark.”
> - 轨迹长度（§3.3）：“Trajectory lengths vary substantially across tasks: Mapping exhibits the longest and most diverse trajectories, while Landing, Orbit-H, Orbit-R, and Spiral Down are shorter and more concentrated.”
> - 轨迹长度（Table 1）：“UAV-Flow [31] | Syn., Real | Mesh | \times | <4 | \times | VLA | HUGE-Bench | Real | 3DGS-Mesh | \checkmark | 32.07 | \checkmark | VLA”
> - 规模（§3.4）：“In total, our dataset contains: 5,330 trajectories in train, 593 trajectories in test-seen, and 294 trajectories in test-unseen.”
> - 动作空间（§3.1）：“\mathbf{a}_{t} is the action target (e.g., velocity \mathbf{v}_{t} or the next state \mathbf{s}_{t+1} ) predicted by the policy”
> - 观测（Figure 2 caption）：“Trajectories are collected in the simulation platform with multimodal observations, including RGB, depth, 4-DoF state, and subtask phases.”
> - 观测（§4.1）：“we provide the model with visual observations from two time steps: the first frame of the trajectory and the current frame.”
> - 划分（§3.4）：“we define test-seen as trajectories whose target landmark appears in the training set. Although the landmark itself is seen during training, the initial observation in the first frame is randomized”
> - 划分（§3.4）：“(1) Landmark-unseen: we hold out a subset of landmarks that never appear in training. (2) Instruction-unseen: we apply instruction-level generalization by randomly diversifying the language.”
> - 真机（Appendix 0.B）：“Specifically, we collect 500 real UAV trajectories in the physical world for Inspection-B task and render their synthetic counterparts in the aligned 3DGS environment using the same camera intrinsics and extrinsics.”
> - 真机（Appendix 0.A）：“In terms of construction cost, each scene requires 8–10 hours of professional UAV flight and 12–15 hours of reconstruction and alignment on an RTX 5090 GPU workstation.”
> - 复用（§4.1）：“Following prior work [31], we provide the model with visual observations from two time steps: the first frame of the trajectory and the current frame.”
> - 复用（§3.2）：“For the obstacle-avoidance traversal task, we generate paths using an RRT-based planner [14].”
> - 动态因素（Limitations）：“The current benchmark primarily focuses on static environments. Incorporating diverse and realistic dynamics, e.g., moving obstacles, changing illumination and weather, or non-stationary objects, remains an important direction”

## CARLA-Air

[arXiv 2603.28032](https://arxiv.org/abs/2603.28032) · 2026-03 · [[topics/papers/无人机VLN/1-26_2603.28032_CARLA-Air.pdf|PDF]]

- **任务**：平台/数据生成
- **场景来源**：游戏引擎合成
- **引擎 / 数据来源**：Unreal Engine 4.26 单进程内集成 CARLA 0.9.16 + AirSim 1.8.1（共享物理 tick 与渲染管线）
- **场景内容**：继承 CARLA 自带地图（示例用 Town01–05、Town10HD）；可通过 UE 资产管线导入自定义机器人、无人机、车辆与环境地图
- **场景数**：未给总数；W4 演示 6 张 CARLA 地图（Town 01–05、Town 10HD）
- **室内外**：室外
- **飞行高度**：W1 精准降落示例中无人机从约 12 m 高度开始下降
- **规模**：无固定数据集；示例 W3 采集 1 000 条 12 路同步记录，W4 产出 500 对空地配准数据
- **动作空间**：连续：速度指令、航点目标、autopilot 开关可作为动作空间；RL 示例为 3D 速度指令
- **观测**：每 tick 同步最多 18 种传感器：RGB、深度、语义分割、LiDAR、雷达、IMU、GNSS、气压计等；空中与地面视角配对
- **复用**：CARLA（地面交通、行人、天气）+ AirSim（多旋翼动力学与空中传感器），均基于 UE4；保留两者原生 Python API 与 ROS 2 接口
- **动态因素**：规则遵从的交通流与具社会意识的行人；14 种官方天气预设（晴天正午、多云、浓雾、大雨、夜晚、小雨、日落等）
- **备注**：定位为空地协同基础设施，非固定基准；联合负载约 20 FPS；作者列出局限：仅在中等密度交通下验证、切换地图需重启进程、超过两架无人机未正式验证。

> [!quote]- 原文依据（19 句）
> - 场景来源（Abstract）：“We present CARLA-Air, an open-source infrastructure that unifies high-fidelity urban driving and physics-accurate multirotor flight within a single Unreal Engine process”
> - 引擎 / 数据来源（Appendix A.1 Software stack）：“CARLA 0.9.16, AirSim 1.8.1 (final stable open-source release), Unreal Engine 4.26, Python 3.8+.”
> - 引擎 / 数据来源（§3）：“CARLA-Air integrates CARLA [2] and AirSim [15] within a single Unreal Engine [3] process through a minimal bridging layer that resolves a fundamental engine-level initialization conflict”
> - 场景内容（Figure 12 caption）：“Each row shows an aerial RGB view from the drone across six representative CARLA maps (Town 01–05 and Town 10HD); each column corresponds to a different weather preset”
> - 场景内容（Abstract）：“An extensible asset pipeline further allows researchers to integrate custom robot platforms, UAV configurations, and environment maps into the shared simulation world.”
> - 场景数（Figure 12 caption）：“Each row shows an aerial RGB view from the drone across six representative CARLA maps (Town 01–05 and Town 10HD); each column corresponds to a different weather preset”
> - 室内外（Abstract）：“Within a shared physics tick and rendering pipeline, CARLA-Air delivers photorealistic urban and natural environments populated with rule-compliant traffic flow, socially-aware pedestrians, and aerodynamically consistent UAV dynamics”
> - 飞行高度（§5.1）：“A drone starts at {\approx}12 m altitude above the vehicle and is tasked with landing on the vehicle’s roof.”
> - 规模（§5.3）：“Over 1 000 ticks, the workflow produces 1 000 fully synchronized 12-stream records at a mean collection rate of {\approx}17 Hz.”
> - 规模（§5.4）：“Over 500 ticks, the workflow produces 500 co-registered aerial-depth / ground-segmentation pairs at {\approx}18 Hz with zero RPC errors.”
> - 动作空间（§5.5）：“(ii) both aerial and ground agents expose programmatic control interfaces (velocity commands, waypoint targets, autopilot toggles) that can serve as action spaces;”
> - 动作空间（§5.5）：“The observation space comprises the drone’s pose, the vehicle’s pose, and surrounding traffic state; the action space is a 3D velocity command;”
> - 观测（Abstract）：“while synchronously capturing up to 18 sensor modalities—including RGB, depth, semantic segmentation, LiDAR, radar, IMU, GNSS, and barometry—across all aerial and ground platforms at each simulation tick.”
> - 观测（§5.2）：“(i) both aerial and ground agents can be equipped with egocentric RGB, depth, and semantic segmentation cameras, providing paired bird’s-eye and street-level visual observations along any navigation trajectory;”
> - 复用（Figure 5 caption）：“CARLAAirGameMode inherits all ground functionality from CARLA’s game mode base while composing the aerial flight actor as a spawned world actor.”
> - 复用（Abstract）：“The platform preserves both CARLA and AirSim native Python APIs and ROS 2 interfaces, enabling zero-modification reuse of existing codebases.”
> - 动态因素（§1）：“The platform delivers rich urban and natural environments populated with rule-compliant traffic flow, socially-aware pedestrians, and aerodynamically consistent multirotor dynamics”
> - 动态因素（§5.4）：“To verify rendering consistency across both sensor layers, the workflow iterates through all 14 official weather presets.”
> - 动态因素（Figure 12 caption）：“each column corresponds to a different weather preset (Clear Noon, Cloudy Noon, Dense Fog, Hard Rain, Night, Soft Rain, and Sunset).”

## LinkS²Bench（LinkS2Bench）

[arXiv 2604.02020](https://arxiv.org/abs/2604.02020) · 2026-04 · [[topics/papers/无人机VLN/1-15_2604.02020_LinkS2Bench.pdf|PDF]]

- **任务**：静态问答
- **场景来源**：混合（真实无人机视频 + 卫星影像）
- **引擎 / 数据来源**：无人机视频：自采（3 台 DJI Mini 3）、公开网站、已有数据集；卫星影像来自 Google Earth 并与视频人工匹配
- **场景内容**：西安数据由团队用 3 台 DJI Mini 3 自采；肇庆、深圳视频取自 UrbanVideo-Bench；其余为 Pexels、Pixabay 等网站上的全球多地无人机视频（视频来源：人工采集 69%、公开网站 15%、已有数据集 16%）
- **场景数**：全球 16 座城市；1,500 段无人机视频、43,273 张卫星图像
- **面积**：卫星影像覆盖超过 200 km²
- **地域**：全球 16 座城市，明确提到西安、肇庆、深圳，其余来自世界各地区
- **室内外**：室外
- **轨迹长度**：视频多为 30–45 秒，总计 1,022 分钟（>17 小时）
- **规模**：17,903 个 QA（约 17.9k），4 个维度 12 项细粒度任务；人类评测子集 LinkS2Bench (tiny) 720 题
- **观测**：无人机视频与卫星图像联合输入，卫星图上标注椭圆（目标）、点、多边形（区域）、线（轨迹）
- **划分**：正文未给出训练/测试划分（SFT 细节见补充材料）；从全集每任务抽 60 题共 720 题构成 LinkS2Bench (tiny)，用于人类基线与误差分析
- **真机**：是（仅数据）：全部为真实无人机视频，其中西安数据为团队自飞采集；无真机闭环评测
- **复用**：UrbanVideo-Bench（肇庆、深圳视频）；Pexels、Pixabay 公开视频；Google Earth 卫星影像
- **动态因素**：视频含运动车辆、行人等动态目标（区域计数、轨迹匹配、区域交互等任务依赖）；天气/光照未提
- **备注**：核心难点为无人机局部动态视角与静态卫星全局图之间的跨视角对齐；作者称质量控制中的错误主要来自无人机视频视角剧变、视野有限及跨视角对齐困难。

> [!quote]- 原文依据（24 句）
> - 场景来源（§1）：“Built from 1,022 minutes of real-world UAV footage and high-resolution satellite imagery covering over 200 km2, LinkS2Bench comprises 17.9k high-quality VQA pairs curated through an LMM-assisted pipeline and human annotation.”
> - 引擎 / 数据来源（§3.3）：“In particular, the Xi’an data were collected by our team using three DJI Mini 3 drones.”
> - 引擎 / 数据来源（§3.3）：“The satellite images were acquired through Google Earth and then matched to the UAV videos.”
> - 场景内容（§3.3）：“To further expand the dataset, we additionally incorporated video data from two cities, Zhaoqing and Shenzhen, from the public UrbanVideoBench (Zhao et al., 2025a). In addition, we supplemented the dataset with UAV videos from diverse regions around the world, sourced from public websites such as Pexels and Pixabay.”
> - 场景内容（§3.1）：“The videos span diverse durations (primarily 30–45s) and are sourced via manual collection (69%), public websites (15%), and existing datasets (16%).”
> - 场景数（§1）：“We build LinkS2Bench on a real-world UAV-satellite data foundation comprising 1,500 UAV videos and 43,273 satellite images from 16 cities worldwide”
> - 面积（§3.1）：“LinkS2Bench comprises 17,903 QA pairs derived from 1,500 real-world videos (>17 hours) and 43,273 satellite images (>200 km² coverage).”
> - 地域（§3.3）：“Data Collection. We collected UAV flight videos and corresponding satellite imagery from 16 cities worldwide. In particular, the Xi’an data were collected by our team using three DJI Mini 3 drones.”
> - 地域（§3.3）：“we additionally incorporated video data from two cities, Zhaoqing and Shenzhen, from the public UrbanVideoBench (Zhao et al., 2025a).”
> - 室内外（§1）：“Built from 1,022 minutes of real-world UAV footage and high-resolution satellite imagery covering over 200 km2, LinkS2Bench comprises 17.9k high-quality VQA pairs”
> - 轨迹长度（§3.1）：“The videos span diverse durations (primarily 30–45s) and are sourced via manual collection (69%), public websites (15%), and existing datasets (16%).”
> - 轨迹长度（Abstract）：“LinkS2Bench links 1,022 minutes of dynamic UAV footage with high-resolution satellite imagery covering over 200 km².”
> - 规模（§3.1）：“LinkS2Bench comprises 17,903 QA pairs derived from 1,500 real-world videos (>17 hours) and 43,273 satellite images (>200 km² coverage).”
> - 规模（§4.1.3）：“We construct LinkS2Bench (tiny) by sampling 720 questions from the full benchmark, with 60 questions for each task.”
> - 观测（§2.2）：“In contrast, LinkS2Bench takes UAV videos and satellite imagery as joint inputs and systematically evaluates VLMs’ cross-view spatial intelligence under dynamic and cross-view conditions.”
> - 观测（§3.3）：“Annotators visually ground spatial elements using four formats: ellipses (target instances), points (key locations), polygons (region boundaries), and lines (trajectories).”
> - 划分（§4.1.3）：“We construct LinkS2Bench (tiny) by sampling 720 questions from the full benchmark, with 60 questions for each task. Human evaluators answer all questions independently”
> - 划分（§4.5.2）：“As shown in Table 2, both models benefit substantially from fine-tuning, with the overall average reaching 52.6% (+24.4%) for Qwen3.5-4B and 53.1% (+18.4%) for Qwen3.5-9B.”
> - 真机（§3.3）：“In particular, the Xi’an data were collected by our team using three DJI Mini 3 drones.”
> - 真机（§3.1）：“LinkS2Bench comprises 17,903 QA pairs derived from 1,500 real-world videos (>17 hours) and 43,273 satellite images (>200 km² coverage).”
> - 复用（§3.3）：“To further expand the dataset, we additionally incorporated video data from two cities, Zhaoqing and Shenzhen, from the public UrbanVideoBench (Zhao et al., 2025a).”
> - 复用（§3.3）：“we supplemented the dataset with UAV videos from diverse regions around the world, sourced from public websites such as Pexels and Pixabay. The satellite images were acquired through Google Earth”
> - 动态因素（§3.2）：“Zone Counting estimates the number of vehicles or pedestrians within an annotated satellite region.”
> - 动态因素（§3.2）：“Trajectory Matching identifies the annotated satellite trajectory that best aligns with a dynamic target in the video.”

## 城市空域目标导向具身导航基准（论文未命名，项目仓库 Embodied-Navigation-Bench）

[arXiv 2604.07973](https://arxiv.org/abs/2604.07973) · 2026-04 · [[topics/papers/无人机VLN/1-16_2604.07973_How-Far-Are-Large-Multimodal-Models-from.pdf|PDF]]

- **任务**：目标搜索
- **场景来源**：游戏引擎合成
- **引擎 / 数据来源**：UE + AirSim（选用 EmbodiedCity 开源模拟器）
- **场景内容**：EmbodiedCity 模拟器：基于一座真实城市构建，集成多种城市元素（建筑、道路、路口、植被、功能区等）
- **地域**：基于一座真实城市（文中未点名）
- **室内外**：室外
- **轨迹长度**：平均约 203.4 m；短 <118.2 m、中 118.2–223.6 m、长 >223.6 m
- **规模**：5,037 条目标导向导航轨迹；10 名志愿者、500 余人时；评测 17 个模型
- **动作空间**：离散：turn-left/right、move-forth/back/left/right/up/down（固定位移）、云台上调/下调，可任意组合；水平/垂直/旋转动作占比 45.0%/28.2%/26.8%
- **观测**：RGB 第一视角（560×560，90° 视场）+ 相机云台角（-90° 至 0°）+ 目标指令；LMM 另有 30 个时刻的历史记忆；部分 agent 方法使用深度
- **真机**：无真机评测；真值轨迹由有 100 小时以上真实飞行经验的专业飞手在模拟器中执行
- **复用**：EmbodiedCity 模拟器（UE + AirSim），无人机其余设置沿用 AirSim 默认
- **备注**：作者排除了 2D（AVDN）、低质量（CityNav）和编辑权限受限（AerialVLN、AeroVerse、TRAVEL）的模拟器；强调垂直动作，下降多于上升

> [!quote]- 原文依据（21 句）
> - 场景来源（§4.1）：“EmbodiedCity (Gao et al., 2024b) consists of an open-source simulator and a route-oriented VLN dataset. The route-oriented VLN dataset differs from the focus of this work, but the simulator is highly adaptable for further development.”
> - 引擎 / 数据来源（Table 1）：“EmbodiedCity (Gao et al., 2024b) | UE + Airsim | Route-Oriented Navigation | Horizontal-Dominant | ✓ |”
> - 引擎 / 数据来源（Table 1）：“Ours | UE + Airsim | Goal-Oriented navigation | Balanced Horizontal–Vertical | ✓ |”
> - 场景内容（§4.1）：“The route-oriented VLN dataset differs from the focus of this work, but the simulator is highly adaptable for further development. It is built on a real city and integrates various urban elements.”
> - 场景内容（Appendix A）：“Successfully completing these tasks therefore requires reasoning over urban semantic elements, including buildings, roads, intersections, vegetation, and functional areas.”
> - 地域（§4.1）：“but the simulator is highly adaptable for further development. It is built on a real city and integrates various urban elements.”
> - 室内外（Abstract）：“In this work, we investigate whether LMMs can achieve embodied spatial action like human through a challenging scenario: goal-oriented navigation in urban 3D spaces.”
> - 轨迹长度（§4.3）：“Figure 2b shows the distribution of ground-truth trajectory lengths, with an average of approximately 203.4 meters.”
> - 轨迹长度（Table 2 caption）：“The short, middle, and long groups correspond to ground truth trajectories of less than 118.2 meters, between 118.2 meters and 223.6 meters, and greater than 223.6 meters, respectively.”
> - 规模（§1）：“To ensure reproducible experiments, we collected 5,037 high-quality navigation trajectories with goal-oriented instructions through over 500 hours of human-controlled data collection in a realistic simulator.”
> - 规模（§4.2）：“To approximate a zero-shot setting, task design and ground-truth trajectory execution are conducted by separate groups. Overall, the process involved 10 volunteers and required more than 500 person-hours of manual effort.”
> - 动作空间（§3）：“The action a_{t} can be formed by the arbitrary combination of discrete control commands: turn-left, turn-right, move-forth, move-left, move-right, move-back, move-up, move-down, adjust-camera-gimbal-upwards, and adjust-camera-gimbal-downwards.”
> - 动作空间（Appendix B.4）：“Drone motion is discretized into translational actions (move_forth, move_back, move_left, move_right, move_up, move_down), each corresponding to a fixed displacement, as well as rotational actions (turn_left, turn_right) with a fixed rotation angle.”
> - 动作空间（§4.3）：“Figure 2c shows the average proportions of horizontal movement, vertical movement, and rotation actions in a complete navigation task, accounting for 45.0%, 28.2%, and 26.8%, respectively.”
> - 观测（§3）：“At each time step t , the agent obtains an RGB observation o_{t} with camera gimbal angle \alpha .”
> - 观测（Appendix B.2）：“To manage memory under the token constraints and computational overhead of most LMMs, we utilize a fixed-size memory window of 30 moments.”
> - 观测（Appendix B.2）：“All RGB observations have a resolution of 560x560 and a 90-degree Field of View. Other settings for drones remain as the AirSim default (Shah et al., 2017).”
> - 观测（Appendix B.4）：“the camera gimbal angle ranges from -90^{\circ} (vertical downward view) to 0^{\circ} (horizontal view), and the model can explicitly issue angle_up or angle_down commands to adjust its visual perspective.”
> - 真机（§4.2）：“Third, professional UAV pilots with over 100 hours of real-world flight experience execute the task by navigating from the start point to the destination according to the instruction.”
> - 复用（Appendix B.2）：“All RGB observations have a resolution of 560x560 and a 90-degree Field of View. Other settings for drones remain as the AirSim default (Shah et al., 2017).”
> - 备注（§4.1）：“After evaluating simulators in Table 1, we excluded simulators that are 2D (AVDN), low-quality (CityNav), and those with restricted editing permissions (AerialVLN, AeroVerse, TRAVEL).”

## ESARBench（UAV-ESAR Simulator）

[arXiv 2605.01371](https://arxiv.org/abs/2605.01371) · 2026-05 · [[topics/papers/无人机VLN/2-05_2605.01371_ESARBench.pdf|PDF]]

- **任务**：目标搜索
- **场景来源**：混合（真实 GIS：卫星影像 + DEM 高程数据导入 UE5 生成地形 + 引擎内线索/遇险者模型）
- **引擎 / 数据来源**：Unreal Engine 5 + AirSim（AirSim-Colosseum 插件）
- **场景内容**：ALOS PALSAR 12m DEM 与卫星影像映射到 UE5 生成真实地形；部署遇险者与 12 类线索模型（帐篷、背包、丢弃衣物、篝火、信号弹等），位置依据当地真实历史救援事件
- **场景数**：4 个
- **面积**：2km×2km、2km×2km、3km×3km、5km×5km（§3.2.1）；附录 C 中鳌太线、K2、大鹏半岛均为 2 km×2 km，罗布泊 5 km×5 km
- **地域**：中国四处搜救高发地：鳌太线（秦岭，高山草甸）、罗布泊（塔里木盆地，沙漠戈壁）、K2（雪峰）、大鹏半岛（深圳附近，海岸）
- **室内外**：室外
- **轨迹长度**：未给轨迹长度；起点到遇险者平均距离的 25/50/75 分位数为 116.6 / 230.3 / 373.6 m
- **规模**：12 个 Event、60 个 snapshot、600 个任务
- **动作空间**：基准未明确规定；每步联合输出飞行动作与新发现线索的语义和坐标，最终报告遇险者 3D 坐标；基线（Random、Pure-MLLM）使用离散 UAV 动作
- **观测**：仿真器提供 IMU、GPS、LiDAR、多视角 RGB 与深度图；文本提示描述目标最后已知轨迹；基线统一使用四相机 YOLO-World RGB-D 模块报告线索
- **划分**：未给 train/test 划分；按距离、天气、光照、遇险者数量、强线索打分，分 Simple/Medium/Hard/Extreme 四档难度
- **复用**：AirSim-Colosseum 插件；ALOS PALSAR 12m DEM；任务依据真实搜救事件
- **动态因素**：13 种天气、可自定义时段；特定天气下地表有积雪、水洼、沙尘等物理状态变化；每个 snapshot 内遇险者与线索静止
- **备注**：Event-Snapshot-Task 三级生成：每个连续真实事件离散为静态快照，再随机采样时段、天气、起点生成任务；附录 E 论证静态快照近似；§3.2.1 与附录 C 的地图尺寸不一致

> [!quote]- 原文依据（36 句）
> - 引擎 / 数据来源（§3.2.1）：“By integrating UE5’s high-fidelity rendering pipeline with the rigorous flight dynamics of the AirSim-Colosseum plugin, the UAV-ESAR Simulator achieves SOTA performance in embodied rescue simulation.”
> - 引擎 / 数据来源（§1）：“To achieve this, we employ Unreal Engine 5 (UE5) for its high-fidelity rendering capabilities and AirSim[44] for accurate flight dynamics and physics simulation.”
> - 场景来源（Figure 2）：“(1) Environment Construction, which utilizes satellite imagery and DEM data to reconstruct high-fidelity terrains in Unreal Engine 5.”
> - 场景来源（Abstract）：“Leveraging Unreal Engine 5 and AirSim, we construct four high-fidelity, large-scale open environments mapped directly from real-world Geographic Information System (GIS) data to ensure photorealistic landscapes.”
> - 场景内容（§3.2.1）：“The UAV-ESAR Simulator precisely maps ALOS PALSAR 12m Digital Elevation Model (DEM) data into UE5, generating natural landscapes that strictly adhere to real-world topographical features.”
> - 场景内容（§3.2.2）：“To reconstruct real-world rescue operations, the simulator deploys victims and 12 types of mission-critical clue models—including tents, backpacks, discarded clothing, campfires, and signal flares—at various strategic locations.”
> - 场景内容（§3.2.2）：“Crucially, the spatial distribution and contextual placement of these elements are deeply rooted in historical, real-world SAR incidents reported in their respective environments.”
> - 场景数（§3.2.1）：“Based on these, as shown in Figure 3, we constructed four large-scale, open-world simulation environments spanning 2km x 2km, 2km x 2km, 3km x 3km, and 5km x 5km.”
> - 面积（§3.2.1）：“Based on these, as shown in Figure 3, we constructed four large-scale, open-world simulation environments spanning 2km x 2km, 2km x 2km, 3km x 3km, and 5km x 5km.”
> - 面积（Appendix C）：“The simulation environment models a 5 km × 5 km area centered around the tomb of explorer Yu Chunshun.”
> - 面积（Appendix C）：“The simulation environment incorporates a 2 km × 2 km area surrounding the summit.”
> - 面积（Appendix C）：“The simulation environment reconstructs a 2 km × 2 km area surrounding the "2800 Campsite" on the trail.”
> - 面积（Appendix C）：“Since 2025, at least five fatalities have occurred in this region. The simulation environment covers a 2 km × 2 km area around Wanglanggui.”
> - 地域（§3.2.1）：“we selected four geographical hotspots in China renowned for high frequencies of rescue incidents, meticulously mapping to four representative geomorphologies: the Aotai Trail (Alpine), Lop Nur (Desert), K2 (Snowy Peak), and the Dapeng Peninsula (Coastal cliffs).”
> - 地域（Appendix C）：“Located along the main ridge of the Qinling Mountains, this is one of the most well-known hiking routes in China.”
> - 地域（Appendix C）：“Situated in the Tarim Basin, Lop Nur is a desiccated salt lake and one of China’s most widely recognized uninhabited regions. The terrain is predominantly desert and Gobi.”
> - 地域（Appendix C）：“Located near Shenzhen, China, this peninsula is a popular tourist destination characterized by hilly terrain, forests, and coastal landscapes.”
> - 室内外（§4.2.1）：“UAV agents must handle large-scale outdoor viewpoints, 3D motion, and search-oriented exploration rather than only transferring ground navigation policies.”
> - 轨迹长度（Appendix A）：“Specifically, we utilize the 25th, 50th (median), and 75th percentiles of the average distance between the starting point and the victims to formulate the distance-based scoring criteria.”
> - 轨迹长度（Table 4）：“A. Average Distance | d\leq 116.6 m | +1 | 116.6<d\leq 230.3 m | +2 | 230.3<d\leq 373.6 m | +3 | d>373.6 m | +4 |”
> - 规模（§3.3.1）：“In total, the ESARBench comprises 12 Events, 60 snapshots, and 600 unique tasks. Figure 7 shows four representative event examples.”
> - 动作空间（§3.1）：“Unlike traditional navigation tasks that simply output flight actions, the ESAR agent must also explicitly recognize and output the semantic and spatial information of newly discovered clues, denoted as M_{t+1} .”
> - 动作空间（§4.1）：“Random (Basic): A lower-bound policy that uniformly samples discrete UAV actions without mapping or task reasoning.”
> - 动作空间（Figure 1）：“Ultimately, the agent locates the human target and reports precise 3D spatial coordinates.”
> - 观测（§3.2.3）：“The simulator provides a comprehensive suite of UAV sensors, encompassing an IMU, GPS, LiDAR, alongside multi-view RGB imagery and depth maps.”
> - 观测（Figure 1）：“The UAV agent is initialized with basic environmental conditions and a textual prompt describing the target’s last known trajectory.”
> - 观测（§4.1）：“For fair comparison, all baselines are connected to the same AirSim interface and use the same four-camera YOLO-World[9] RGB-D module for clue and victim reporting.”
> - 划分（§3.3.2）：“We stratify the tasks within the ESARBench into four distinct difficulty tiers: Simple, Medium, Hard, and Extreme. This difficulty rating is comprehensively quantified based on a confluence of factors, including weather severity, sky illumination, the average Euclidean distance between the initial starting point and the targets, and the presence of critical clues.”
> - 复用（§3.2.1）：“By integrating UE5’s high-fidelity rendering pipeline with the rigorous flight dynamics of the AirSim-Colosseum plugin, the UAV-ESAR Simulator achieves SOTA performance in embodied rescue simulation.”
> - 复用（§3.2.1）：“The UAV-ESAR Simulator precisely maps ALOS PALSAR 12m Digital Elevation Model (DEM) data into UE5, generating natural landscapes that strictly adhere to real-world topographical features.”
> - 复用（Appendix G）：“Figure 7 illustrates some of the real-world search and rescue (SAR) incidents utilized as references for task generation.”
> - 动态因素（§3.2.3）：“Depending on the specific task, the weather can be dynamically altered among 13 distinct types tailored to the specific environmental climate.”
> - 动态因素（§3.2.3）：“Importantly, under specific meteorological conditions, the simulated natural landscapes undergo corresponding physical state changes, such as dynamic snow accumulation, water puddles, and dust coverage”
> - 动态因素（§3.2.3）：“Furthermore, UAV-ESAR supports highly customizable configurations for weather and time of day.”
> - 动态因素（§3.3.1）：“Within any given snapshot, the spatial distribution of the victims and clues remains stationary, representing a specific developmental stage of the overall rescue timeline.”
> - 备注（§3.3.1）：“Finally, from each snapshot, we instantiate multiple distinct Tasks by randomly sampling combinations of environmental and initialization parameters, specifically the time of day, weather conditions, and the UAV’s starting location.”

## FlyMirage

[arXiv 2605.19600](https://arxiv.org/abs/2605.19600) · 2026-05 · [[topics/papers/无人机VLN/1-27_2605.19600_FlyMirage.pdf|PDF]]

- **任务**：平台/数据生成
- **场景来源**：混合（训练场景为生成式世界模型 Marble 生成的 3DGS 场景；评测用 ScanNet++ 室内扫描场景 + 真机实飞）
- **引擎 / 数据来源**：Marble 1.1 Plus 生成 3DGS 场景，GSplat 渲染 RGB 与估计深度；GCOPTER 规划轨迹
- **场景内容**：按场景分层分类随机抽子类，GPT-5.4 写场景描述 → GPT Images 2.0 生成图像 → Marble 1.1 Plus 文+图生成 3DGS；Boxer 开放词表检测得到 3D 包围框；六大类场景（公共/机构、商业休闲、办公、工业、住宅、交通）
- **场景数**：1100
- **室内外**：室内外
- **轨迹长度**：平均 4.83 m，中位 4.37 m；导航目标点距当前位置 2–10 m；一次连续飞行最多记录 5 个导航任务
- **规模**：110K+ 条轨迹；评测集为 ScanNet++ 中约 200 条人工飞行轨迹；真机室内、室外各 10 次
- **动作空间**：连续：数据集为 6 DoF；π0 基线预测 h 步相对位移 (Δx,Δy,Δz,Δθ)；真机时预测下一航点由 EGO-Planner 执行
- **观测**：沿轨迹渲染的 RGB 图像与估计深度图 + UAV 位姿；模型输入视觉观测序列、语言指令、当前状态 (x,y,z,θ)
- **划分**：训练用 FlyMirage 生成数据；评测在训练中未见的 ScanNet++ 环境（约 200 条人工飞行轨迹、人工标注指令）及真实室内/室外环境
- **真机**：有真机评测：π0 在服务器推理，四旋翼回传观测与里程计；FlyMirage 训练模型室内 5/10、室外 5/10 成功；数据本身不含真机数据
- **复用**：Marble 1.1 Plus 世界模型、GPT-5.4、GPT Images 2.0、Boxer、GSplat、GCOPTER、Qwen-3.5-Flash（质量过滤与指令生成）；评测用 ScanNet++；真机用 EGO-Planner
- **备注**：全自动、每场景 API 成本约 $2、约 1 小时，渲染只需消费级 RTX 4070；超过 10,000 个唯一物体标签，典型场景 80–120 个物体实例；Boxer 对远处物体 3D 框不准，需迭代近距观测；用 Qwen-3.5-Flash 过滤渲染伪影严重的轨迹。

> [!quote]- 原文依据（27 句）
> - 场景来源（Abstract）：“Our approach leverages large language models (LLM) as an environment designer to promote scene diversity, paired with a generative world model that instantiates these designs into high-fidelity 3D Gaussian Splatting (3DGS) scenes.”
> - 场景来源（§IV-C2）：“we construct an evaluation split of around 200 trajectories in ScanNet++ [29] environments. ScanNet++ provides high-fidelity real-world scenes captured using sub-millimeter-resolution laser scans and high-resolution DSLR images.”
> - 引擎 / 数据来源（§I）：“To reduce the visual sim-to-real gap, we use Marble 1.1 Plus as the generative world model, following a text \& image-to-world paradigm to create high-fidelity 3D Gaussian Splatting (3DGS) [9] scenes.”
> - 引擎 / 数据来源（§III-C）：“Along each trajectory, RGB images and estimated depth maps are rendered from the 3D Gaussian Splatting representation using GSplat and recorded together with the corresponding UAV poses.”
> - 场景内容（§III-A）：“we first randomly select a subcategory from a broader category, such as “living room” under “residential spaces” and then prompt GPT-5.4 to generate a description consistent with the selected scene type.”
> - 场景内容（§III-A）：“Given the resulting textual description, we next generate a corresponding image using GPT Images 2.0.”
> - 场景内容（§III-A）：“We then use both the generated image and the original textual description as inputs to Marble 1.1 Plus to generate a 3DGS-based scene, as illustrated in Fig. 3.”
> - 场景内容（§IV-A）：“Our dataset contains 1100 3DGS scenes spanning six categories as shown in Fig. 6: public and institutional spaces; commercial and leisure spaces; workplace and office spaces; industrial and utility spaces; residential spaces; transportation spaces.”
> - 场景内容（§III-B）：“Marble produces only a 3DGS scene representation, without training images or object-level semantic information. To obtain object-level annotation, we use Boxer [3] to perform open-vocabulary object detection and estimate 3D bounding boxes for the detected objects.”
> - 场景数（§I）：“To validate its potential, we generate 1100 distinct example scenes from indoor to outdoor and 110K+ navigation trajectories automatically.”
> - 室内外（§I）：“This design enables a dataset to cover a broad spectrum of environments, ranging from common indoor and outdoor scenes to hazardous, access-restricted, and hard-to-reconstruct spaces such as radiation-risk areas or chemical facilities.”
> - 轨迹长度（§IV-A）：“The mean and median trajectory lengths are 4.83 m and 4.37 m. As we also record up to five navigation tasks within a continuous run”
> - 轨迹长度（§III-C）：“For each valid candidate, a navigation target point is generated near the object and retained only if its distance from the current position lies between 2\mathrm{m} and 10\mathrm{m} .”
> - 规模（§IV-A）：“Using this data, we collect over 110,000 navigation trajectories, primarily between object-centric waypoints, achieving the largest scale among the compared datasets, as shown in Table I.”
> - 规模（§IV-C2）：“All evaluation trajectories are collected by human pilots, with the corresponding language instructions manually annotated.”
> - 动作空间（Table I）：“FlyMirage | 110K+ | 6 DoF | 1100 | 3DGS | Dynamics-Aware Planner | LLM-based | Yes | Auto/Auto”
> - 动作空间（§IV-B）：“and each predicted displacement consists of a three-dimensional position offset and a relative yaw angle,”
> - 动作空间（§IV-D）：“where \pi_{0} predicts the next waypoint. This waypoint is then sent back to the quadcopter and executed using EGO-Planner [30], which performs real-time collision-aware trajectory planning.”
> - 观测（§IV-B）：“Formally, at time step t , the model receives the natural-language instruction \mathcal{I} , the available visual observations \mathcal{O}_{1:t} , and the current agent state”
> - 观测（§III-C）：“Along each trajectory, RGB images and estimated depth maps are rendered from the 3D Gaussian Splatting representation using GSplat and recorded together with the corresponding UAV poses.”
> - 划分（§IV-C2）：“To evaluate cross-domain generalization and mitigate dataset-specific evaluation bias, we construct an evaluation split of around 200 trajectories in ScanNet++ [29] environments.”
> - 划分（Abstract）：“We further fine-tune the widely used \pi_{0} model on this dataset and demonstrate the improvement our data brings to the model’s ability to navigate in completely unseen environments, both in simulation and in the real world.”
> - 真机（§IV-D）：“At each inference step, the quadcopter transmits its current visual observation and odometry information to the server, where \pi_{0} predicts the next waypoint.”
> - 真机（§IV-D）：“the FlyMirage-trained model achieves a higher success rate in indoor environments, completing 5/10 trials compared with 3/10 for the IndoorUAV-trained model.”
> - 真机（§IV-D）：“The FlyMirage-trained model completes 5/10 outdoor trials, whereas the IndoorUAV-trained model succeeds in only 1/10.”
> - 复用（§III-C）：“After all N_{s} target sets are generated, the target sequences are passed to GCOPTER [24] to optimize smooth, collision-free trajectories subject to UAV motion constraints.”
> - 复用（§III-C）：“we sample RGB images from each trajectory to query Qwen-3.5-Flash for automated visual quality assessment, filtering out trajectories with severe rendering artifacts, poor visibility, or unclear flight intent.”

## CARLA-Air（诊断任务：Cooperative Moving-Platform Landing / Occlusion-Recovery Escort）

[arXiv 2605.31066](https://arxiv.org/abs/2605.31066) · 2026-05 · [[topics/papers/无人机VLN/2-06_2605.31066_Can-Aerial-VLA-Models-Cooperate.pdf|PDF]]

- **任务**：空地协同
- **场景来源**：游戏引擎合成
- **引擎 / 数据来源**：CARLA-Air：CARLA 0.9.16 + AirSim 1.7.0（Colosseum 分支）集成于单个 Unreal Engine 4.26.2 进程
- **场景内容**：沿用 CARLA 城市道路、交通与天气系统；着陆任务中 UGV 为带平板后货箱的卡车，护航任务的遮挡物为桥梁、建筑和大型人造物；运行时一致性验证用 Town10 预设路线
- **地域**：CARLA 城市地图；运行时一致性验证使用 Town10（诊断任务所用地图未写明）
- **室内外**：室外
- **轨迹长度**：按时长限定：着陆 episode 60 s，护航 episode 90 s
- **规模**：每个条件 3 seeds × 50 episodes；运行时一致性验证 100 个匹配 episode
- **动作空间**：仅输出 UAV 动作，沿用各基线原生接口：AerialVLA 连续速度、OpenUAV 连续轨迹、SPF 单航点；OpenFly（Forward 3/6/9 m、左右转、升降、Stop）与 AerialVLN 为离散动作，映射为固定时长速度脉冲；UGV 按预设路线/速度行驶（C2 下速度随 UAV 前向速度调节）
- **观测**：机载 RGB 观测 + 语言指令；C1/C2 附加 UGV→UAV 的语义伙伴状态提示；平台另支持深度、语义/实例分割、LiDAR、IMU、GNSS、气压计、磁力计、事件相机等 18 类传感器，UAV 与 UGV 同 tick 采样
- **划分**：无训练/测试划分，零样本评测；各方法在相同路线、出生点、天气与随机种子协议下评测
- **真机**：无，仅仿真；作者称 sim-to-real 效果仍待验证
- **复用**：CARLA（城市交通、天气、场景管理）与 AirSim/Colosseum（多旋翼动力学）；评测基线 AerialVLA、OpenFly、OpenUAV、SPF、AerialVLN
- **动态因素**：保留 CARLA 动态城市交通与天气系统，压力测试含 dense traffic 设置；地面伙伴为移动卡车（名义速度 4.0 m/s）；护航 episode 含 1–3 次遮挡（桥下 40%、建筑 35%、大型人造物 25%），每次 4–12 s；评测中天气按协议固定
- **备注**：论文重点是平台的单进程同 tick 运行（UAV–UGV 传感器时间戳偏差 0 ms，对比 ROS 桥接平均 12.4 ms）；两项任务为诊断套件，不提供数据集；作者列出局限：仅仿真、协作负担主要在 UAV 侧、遮挡类型有限

> [!quote]- 原文依据（34 句）
> - 引擎 / 数据来源（Abstract）：“We study this question with CARLA-Air, a single-process air-ground evaluation environment that unifies CARLA and AirSim inside one Unreal Engine runtime.”
> - 引擎 / 数据来源（Table 8）：“Component | Version | Unreal Engine | 4.26.2 | CARLA | 0.9.16 | AirSim | 1.7.0 | Python | 3.8.18 |”
> - 引擎 / 数据来源（Appendix A.3）：“The original open-source AirSim project is no longer actively maintained by Microsoft. We build on Colosseum [32], a community-maintained fork that preserves the AirSim API surface and remains compatible with Unreal Engine.”
> - 场景来源（§1）：“CARLA-Air preserves CARLA’s urban traffic simulation and AirSim’s multirotor dynamics while placing UAVs and UGVs under the same world state, physics tick, and sensing pipeline.”
> - 场景内容（§4.1）：“In Moving-Platform Landing, a UGV truck drives along an urban road while providing a flat rear cargo bed as the landing surface.”
> - 场景内容（§4.1）：“In Occlusion-Recovery Escort, the UGV becomes temporarily occluded by bridges, buildings, or large artifacts; the UAV must use partner-state cues to re-establish visual contact”
> - 场景内容（Appendix A.4）：“The UGV drives along a predefined route in Town10 at constant speed, while the UAV is driven by a position P-controller to follow the UGV at a fixed relative offset”
> - 场景内容（§3.1）：“Concretely, CARLAAirGameMode inherits CARLA’s native GameMode to retain ground-vehicle simulation, traffic, weather, episode, sensor, and RPC functionalities”
> - 地域（Appendix A.4）：“The UGV drives along a predefined route in Town10 at constant speed, while the UAV is driven by a position P-controller to follow the UGV at a fixed relative offset”
> - 室内外（Appendix B.1）：“A UGV truck drives along an urban road while providing a flat rear cargo bed as the landing surface. The UAV receives the instruction:”
> - 轨迹长度（Appendix B.1）：“The task consists of tracking, alignment, and landing, with a 60 s episode time limit.”
> - 轨迹长度（Appendix B.1）：“The UAV must escort the UGV and recover visual contact after the target becomes invisible. Each escort episode has a 90 s time limit.”
> - 规模（Appendix B.4）：“All values are reported as mean \pm std over 3 seeds \times 50 episodes per condition.”
> - 规模（Appendix A.4）：“Both runtimes execute the same 100 episodes with matched random seeds, identical spawn points, and the same follow controller; the only varied factor is the runtime architecture.”
> - 动作空间（§4.1）：“Both tasks keep the native aerial VLA interface unchanged: the policy receives visual observations and language instructions, and outputs only UAV actions.”
> - 动作空间（Appendix B.5）：“AerialVLA is an end-to-end aerial VLA policy outputting continuous UAV velocity commands directly from onboard visual observations and language instructions.”
> - 动作空间（Appendix B.5）：“Its native output is a discrete action vocabulary {Forward 3/6/9 m, Turn left, Turn right, Up, Down, Stop}, which we map to fixed-duration velocity bursts in CARLA-Air”
> - 动作空间（Appendix B.5）：“SPF uses explicit spatial reasoning via a VLM planner and outputs a single waypoint per inference. The waypoint is tracked by a position controller.”
> - 动作空间（Appendix B.2）：“C2 is used only for Moving-Platform Landing. The UAV receives the same semantic cue as in C1. The magnitude of the UAV’s commanded forward velocity is passed directly to a fixed UGV longitudinal controller”
> - 观测（Appendix B.2）：“The UAV and UGV do not communicate. The UGV follows a predefined speed profile or route, while the UAV relies only on onboard RGB observations and the task instruction.”
> - 观测（Appendix B.2）：“The UGV provides a compact semantic cue to the UAV. For landing, the cue describes the relative direction to the cargo bed, coarse truck motion, and landing phase.”
> - 观测（Appendix A.2）：“Table 7 lists the sensor modalities supported by CARLA-Air. All enabled sensors are sampled at the shared simulation tick, so cross-agent correspondence does not require interpolation or extrapolation.”
> - 划分（Appendix B.7）：“Unless otherwise specified, each method is evaluated under the same route, spawn, weather, and random-seed protocol within each diagnostic task.”
> - 划分（§5）：“(iii) information asymmetry between Rule-Coop-State and VLA baselines; (iv) zero-shot VLA evaluation without cooperation-aware fine-tuning;”
> - 真机（§5）：“Our study has five principal boundaries: (i) simulation only; (ii) the cooperative burden falls primarily on the UAV side, with UGV-side cooperative planning unstudied;”
> - 真机（§5）：“(v) a limited set of occlusion types, with learned cooperation policies and non-VLA baselines left for future work. The sim-to-real effect remains empirically open.”
> - 复用（§3.1）：“CARLA-Air preserves CARLA as the authoritative world manager and instantiates AirSim as an actor-level aerial subsystem in the same simulation world.”
> - 复用（§4.2）：“Table 3 summarizes the evaluated methods, spanning end-to-end VLA, VLM-based planning, and traditional aerial VLN. Each baseline is run through its native low-level wrapper (Appendix B);”
> - 复用（Appendix B.5）：“OpenFly is a keyframe-aware aerial VLA model fine-tuned from OpenVLA-7B on the OpenFly aerial VLN dataset [5].”
> - 动态因素（§3.1）：“CARLA behaves as a controller-dominant backend: its traffic manager, weather system, episode management, sensor scheduling, and RPC services are tightly bound to the global lifecycle controller.”
> - 动态因素（Appendix B.4）：“Each escort episode contains 1–3 occlusion events sampled from three geometry types (bridge underpass: 40%, building: 35%, large artifacts: 25%), with occlusion duration drawn uniformly from 4–12 s.”
> - 动态因素（Appendix B.2）：“where v_{0}=4.0 m/s is the nominal UGV speed and v_{\mathrm{ref}}=2.0 m/s is a reference scaling constant.”
> - 动态因素（Appendix A.4）：“Table 9 extends this protocol to heavier sensor payloads, higher control rates, multi-agent settings, and dense traffic.”
> - 备注（§3.2）：“the bridge configuration introduces non-zero UAV–UGV sensor offsets (mean 12.4 ms, max 34 ms—roughly one third of a 10 Hz control cycle), whereas CARLA-Air samples matched frames from the same simulation tick”

## FLIGHT（Fine-grained VLN 与 Long-horizon Flow 两个子集；论文标题 Think Like a Pilot）

[arXiv 2606.06836](https://arxiv.org/abs/2606.06836) · 2026-06 · [[topics/papers/无人机VLN/1-17_2606.06836_Think-Like-a-Pilot.pdf|PDF]]

- **任务**：细粒度飞控
- **场景来源**：游戏引擎合成
- **引擎 / 数据来源**：UnrealZoo 构建的 3D 仿真环境（未写明具体引擎版本与飞控模拟器）
- **场景内容**：UnrealZoo 的城市、工业、乡村场景，含逼真建筑与植被等复杂资产
- **室内外**：室外
- **轨迹长度**：Fine-grained VLN 平均 154.5 m、平均 475 个动作（10 Hz 采样）；Long-horizon Flow 平均轨迹 32.8 m、平均目的地距离 17.8 m
- **规模**：Fine-grained VLN 6,689 条轨迹；Long-horizon Flow 4,098 条轨迹，共 13,815 个动作实例（平均每条 3.37 个）
- **动作空间**：连续：记录完整 6-DoF 轨迹点（经纬度、高度 + roll/pitch/yaw），以相邻点相对位移作为 VLA 式动作序列；每个动作为局部坐标系下的相对位移与姿态变化
- **观测**：第一视角 FPV 视频帧（近期窗口）+ 无人机传感器状态（IMU 与位姿）+ 语言指令 + 历史 Pilot Reasoning 记忆
- **复用**：UnrealZoo 场景；Long-horizon Flow 继承 UAV-Flow 的 Flying-on-a-Word 设定及其 8 类原子动作
- **备注**：轨迹主要由人类飞手采集，少量简单路线由路径规划补充；FPV 视频与轨迹点时间对齐；指令与 Pilot Reasoning 文本由 VLM 分段标注后 LLM 合并；Fine-grained VLN 成功阈值 15 m

> [!quote]- 原文依据（14 句）
> - 场景来源（Figure 1）：“FLIGHT is constructed from high-quality flight videos collected in 3D simulation environments, paired with fine-grained trajectory records and language annotations”
> - 引擎 / 数据来源（§3.2.1）：“For precise language-driven UAV navigation, we collect demonstration data across diverse, semantically rich simulation environments (urban, industrial, and rural) built via Unrealzoo (Zhong et al., 2024).”
> - 场景内容（§3.2.1）：“built via Unrealzoo (Zhong et al., 2024). Featuring complex assets like realistic buildings and vegetation, these high-fidelity scenes provide the multi-modal variance necessary to effectively align textual instructions with grounded environmental semantics.”
> - 室内外（§3.2.1）：“we collect demonstration data across diverse, semantically rich simulation environments (urban, industrial, and rural) built via Unrealzoo”
> - 轨迹长度（§3.3）：“We sample continuous actions at 10 Hz, resulting in an average of 475 actions per trajectory and an average trajectory length of 154.5 m.”
> - 轨迹长度（§3.3）：“It contains 13,815 action instances in total, with each trajectory averaging 3.37 action instances. The average destination distance is 17.8 m, and the average trajectory length is 32.8 m”
> - 规模（§3.3）：“We construct two trajectory datasets for long-horizon, fine-grained UAV navigation: Fine-grained VLN and Long-horizon Flow, containing 6,689 and 4,098 trajectories, respectively.”
> - 动作空间（§3.2.1）：“our dataset records full 6-DoF trajectory points, including coordinates (latitude, longitude, altitude) and orientation (roll, pitch, yaw). We further compute the relative displacement between consecutive trajectory points to obtain VLA-style action sequences.”
> - 动作空间（§4.2）：“Each action consists of relative displacement and attitude changes in the local coordinate frame. Since the model predicts an action sequence rather than a single-step control command”
> - 观测（§3.1）：“At time step t , the task input consists of the language instruction I , the recent visual observation window V_{[t-W,t]} of length W , and the UAV sensor state S_{t} .”
> - 观测（§4）：“Given a language instruction I , FPV video frames \{V_{t}\} , and IMU and pose states \{S_{t}\} , the agent predicts a horizon of future actions at each control step t”
> - 复用（§3.1）：“Long-horizon Flow inherits the Flying-on-a-Word task setting proposed in (Wang et al., 2025a) and further extends it from single-stage atomic actions to multi-stage compositional action tasks.”
> - 复用（§3.3）：“The Long-horizon Flow dataset inherits eight action categories from UAV-Flow (Wang et al., 2025a), with the category distribution shown in the left panel of Fig. 5(a).”
> - 备注（§3.2.1）：“The dataset covers diverse trajectories mainly collected by human pilots, with a small portion of simple-route scenarios supplemented by path-planning models.”

## SpatialUAV

[arXiv 2606.27876](https://arxiv.org/abs/2606.27876) · 2026-06 · [[topics/papers/无人机VLN/1-18_2606.27876_SpatialUAV.pdf|PDF]]

- **任务**：静态问答
- **场景来源**：真机实飞（复用 5 个现有低空无人机数据集的真实图像/视频与元数据，非作者自飞）
- **引擎 / 数据来源**：无仿真器；基于已有数据集元数据 + 检测器框 + Metric3D 深度估计 + 人工标注构造
- **场景内容**：BEDI、AirCopBench、MAVREC、AirScape、University-1652 五个数据源的无人机图像、视频及配对视角、场景 ID、时序、相机/轨迹标注
- **飞行高度**：低空（未给具体数值）
- **规模**：4,331 个实例、14 类任务：单图 1,315、空–空协同 1,231、空–地协同 785、视频运动 1,000；7 种输入配置、9 种答案格式
- **观测**：K∈{1,2,5,16} 张图：单图、成对视角、5 选 1 候选视角、16 帧视频；区域类任务图像带检测框与中性区域 ID，跨视角任务用无标注原图
- **划分**：正文未提训练/测试划分（纯评测）；人类水平及部分模型（带 ∗）在每任务随机抽取 20% 的子集上评测
- **真机**：数据为真实无人机观测（复用现有数据集，非作者自飞）；无真机飞行评测
- **复用**：BEDI、AirCopBench、MAVREC、AirScape、University-1652；深度用 Metric3D 估计
- **备注**：正文未说明场景地点、数量、高度数值。经纯文本盲过滤（DeepSeek-V4-Pro、Qwen3.6-27B）与两轮人工+模型验证；作者指出低空视角存在透视畸变、随高度变化的尺度、遮挡和空地视角不匹配。

> [!quote]- 原文依据（15 句）
> - 场景来源（§III Data Collection）：“We first conduct a comprehensive survey of existing low-altitude UAV resources and select five data sources that support the requirements of our task taxonomy: BEDI [26], AirCopBench [17], MAVREC [27], AirScape [28], and University-1652 [29].”
> - 场景来源（§II-B）：“SpatialUAV complements these efforts by providing a diagnostic evaluation grounded in real low-altitude UAV observations.”
> - 引擎 / 数据来源（§I）：“To ensure reliable and grounded evaluation, its annotations are constructed from detector-assisted regions, depth supervision, metadata-derived rules, and extensive manual labeling, followed by multi-turn human validation.”
> - 引擎 / 数据来源（§III-3）：“Depth-related answers are computed from regional Metric3D [30] estimates and further checked during validation, as in Distance Comparison.”
> - 场景内容（§III Data Collection）：“From these sources, we curate UAV images, videos, and associated metadata, while preserving supervision-relevant information, including source labels, paired-view correspondences, scene identifiers, temporal ordering, and available camera or trajectory annotations.”
> - 飞行高度（Abstract）：“we introduce SpatialUAV, a real low-altitude UAV benchmark comprising 4,331 curated instances across 14 fine-grained task types”
> - 规模（§III Statistical Analysis）：“The resulting SpatialUAV dataset contains 4,331 curated instances spanning four reasoning settings and 14 fine-grained tasks: 1,315 single-image samples, 1,231 aerial–aerial samples, 785 aerial–ground samples, and 1,000 video-motion samples.”
> - 规模（Abstract）：“SpatialUAV organizes all samples into a unified visual-input–question–answer schema, while supporting seven input configurations and nine answer formats”
> - 观测（§III）：“Here K\in\{1,2,5,16\} covers single images, paired views, candidate-view selection, and video frames, respectively.”
> - 观测（§III-1）：“For region-level tasks, the input images are annotated with bounding boxes and neutral region identifiers, such as Region 0.”
> - 观测（§III-1）：“For tasks in which visible annotations may introduce shortcut cues or bias cross-view matching, such as Collaboration Recognition and Camera Transformation, we use clean images without overlays.”
> - 划分（Table III caption）：“Best and second-best model results are shown in bold and underlined, respectively. ∗ denotes results on the randomly sampled 20% per-task subset.”
> - 真机（§II-A）：“In contrast, SpatialUAV is built upon real UAV observations to evaluate spatial reasoning in aerial scenarios involving perception, collaboration, and navigation.”
> - 复用（§III Data Collection）：“We first conduct a comprehensive survey of existing low-altitude UAV resources and select five data sources that support the requirements of our task taxonomy: BEDI [26], AirCopBench [17], MAVREC [27], AirScape [28], and University-1652 [29].”
> - 复用（§III-3）：“Depth-related answers are computed from regional Metric3D [30] estimates and further checked during validation, as in Distance Comparison.”

## AirGroundBench

[arXiv 2606.28049](https://arxiv.org/abs/2606.28049) · 2026-06 · [[topics/papers/无人机VLN/2-07_2606.28049_AirGroundBench.pdf|PDF]]

- **任务**：空地协同
- **场景来源**：游戏引擎合成
- **引擎 / 数据来源**：Unreal Engine + AirSim
- **场景内容**：11 个高保真仿真环境（论文未说明资产来源），表 3 环境名：CityEnv、AirSim、IndCity、SanFran、MSBuild、MtLand、Nordic、Coast、RusWin、RuralAus、Desert；采集时同步记录 RGB、深度、分割与仿真器状态，并标注跨视角物体 ID、2D 框与米制 3D 框
- **场景数**：11 个评测环境（分 City 与 Wild 两类）
- **地域**：未给出真实地名；城市街区、住宅社区、海岸、沙漠、山地、工业区等室外场景类型
- **室内外**：室外
- **规模**：1,021 对同步 UAV–UGV 图像；62k 道双视角四选一 VQA（9 类任务）+ 115 个闭环 VLN episode
- **动作空间**：VLN 为离散动作空间（具体动作未在正文给出）；VQA 输出单个选项
- **观测**：同一时刻的 UAV 航拍视角 + UGV 第一人称视角（另存深度、分割与仿真器状态）；评测分 UGV-only、UAV-only、Dual-view 三种输入；VLN 另给语言指令
- **划分**：无 train/test 划分，全部模型零样本评测；按 City / Wild 环境分组分析场景泛化
- **复用**：Unreal Engine + AirSim 仿真栈
- **备注**：UAV 相机位姿不在世界坐标中采样，而是按 UGV 局部 NED 系下的预设相对位姿生成，以控制基线与视差；正文多处称细节（预设分布、成功判据、人工评测）见附录，但文本中无附录

> [!quote]- 原文依据（20 句）
> - 引擎 / 数据来源（§5.1）：“AirGroundBench is built in a high-fidelity simulation stack based on Unreal Engine and AirSim, enabling synchronized control of a ground vehicle (UGV) and an aerial vehicle (UAV).”
> - 场景来源（§5.1）：“AirGroundBench is built in a high-fidelity simulation stack based on Unreal Engine and AirSim, enabling synchronized control of a ground vehicle (UGV) and an aerial vehicle (UAV).”
> - 场景内容（Table 3）：“Method | Avg. | CityEnv | AirSim | IndCity | SanFran | MSBuild | MtLand | Nordic | Coast | RusWin | RuralAus | Desert |”
> - 场景内容（§5.1）：“Along with RGB frames, we also store auxiliary visual modalities (e.g., depth and segmentation) and the simulator states required for metric grounding and structured annotation.”
> - 场景内容（§5.3）：“Each synchronized dual-view pair is annotated at collection time with structured spatial metadata, including object identifiers, 2D bounding boxes, and metric 3D bounding boxes.”
> - 场景数（§3.1）：“In this paper, we evaluate models on 11 environments and collect 1,021 synchronized UAV–UGV image pairs.”
> - 场景数（Table 3）：“Environments are grouped into City and Wild, and we report the average accuracy over the nine VQA tasks (Avg., %) for each evaluated environment.”
> - 地域（§3.1）：“We construct the benchmark in high-fidelity simulation environments spanning diverse outdoor scene types (e.g., urban districts, residential communities, coastlines, deserts, mountains, and industrial zones).”
> - 室内外（§3.1）：“We construct the benchmark in high-fidelity simulation environments spanning diverse outdoor scene types (e.g., urban districts, residential communities, coastlines, deserts, mountains, and industrial zones).”
> - 规模（Abstract）：“AirGroundBench is built from 11 high-fidelity simulated environments with 1,021 synchronized air-ground observation pairs, yielding 62k dual-view 4-way single-choice VQA instances and 115 closed-loop vision-language navigation (VLN) episodes.”
> - 动作空间（§5.4）：“For navigation, we generate interactive VLN episodes under a closed-loop protocol with a discrete action space, and standard metrics (SR/SPL/NE) are computed from simulator trajectories.”
> - 动作空间（§6.1）：“For VQA tasks, each instance provides synchronized UAV and UGV observations at the same timestamp, together with the question and four answer options; the model outputs a single option as the final prediction.”
> - 观测（§5.1）：“For each timestamp, we record a temporally aligned dual-view observation pair, consisting of the UGV egocentric view and the UAV aerial view.”
> - 观测（§3.3）：“To isolate the contribution of heterogeneous views, we evaluate models under three controlled input configurations: UGV-only, UAV-only, and Dual-view (UAV+UGV).”
> - 观测（§6.1）：“At each step, the model receives the current synchronized UAV/UGV observations and the navigation instruction, and outputs an action from a discrete action space.”
> - 划分（§6.1）：“All models are evaluated in a zero-shot setting without any fine-tuning on AirGroundBench data.”
> - 划分（§6.3）：“To evaluate how spatial understanding generalizes across environment structures, we group the evaluated environments into City and Wild categories and report the average accuracy over the nine VQA tasks in Table 3.”
> - 复用（§5.1）：“AirGroundBench is built in a high-fidelity simulation stack based on Unreal Engine and AirSim, enabling synchronized control of a ground vehicle (UGV) and an aerial vehicle (UAV).”
> - 备注（§5.2）：“Instead, each UAV camera pose is specified by a preset defined in the UGV-local NED frame as a fixed relative transformation.”
> - 备注（§5.2）：“low-quality frames (e.g., artifacts or abnormal dynamics) are filtered during post-processing, and final distribution statistics are reported in the Appendix.”

## ActiveFly-Bench

[arXiv 2607.10180](https://arxiv.org/abs/2607.10180) · 2026-07 · [[topics/papers/无人机VLN/2-08_2607.10180_ActiveFly-Bench.pdf|PDF]]

- **任务**：具身问答
- **场景来源**：混合（游戏引擎合成 + 真机实飞）
- **引擎 / 数据来源**：Unreal Engine（Beijing、Citypark 两个城市环境）+ 内置 AirSim 插件；真实场景用自研无人机（PX4、Livox Mid-360、FAST-LIO2、EGO-Planner）采集
- **场景内容**：两个高保真城市仿真环境（引用 EmbodiedCity [Gao et al. 2024] 与 AerialVLN [Liu et al. 2023c]），含上百种城市微元素；另有 1 个真实校园场景和 1 个真实室内场景
- **场景数**：4（1 个真实校园 + 1 个真实室内 + 2 个仿真城市环境）
- **地域**：仿真环境 Beijing 与 Citypark；真实校园未写明地点
- **室内外**：室内外（3 个室外 + 1 个室内）
- **轨迹长度**：多数轨迹 10–40 米（短程、细粒度）
- **规模**：10k FLUC 轨迹（6.2k 仿真、1.9k 真实室内、1.9k 真实室外）+ 1.3k Air-EQA + 1.3k OBP；每条指令经扰动生成 5–40 条示范
- **动作空间**：连续 5-DoF（3D 平移 + 偏航 + 云台俯仰），机体与云台联合控制；另设 10 种基本动作（前后、左右、上下、左右转、云台上下）
- **观测**：第一人称 RGB 视频 + 无人机状态 + 语言指令；云台相机俯仰 0–90°；真机以 30 Hz 回传 1K 视频与状态
- **划分**：FLUC 按类别 80%/20% 划分：8k 训练、2k 测试；Air-EQA 与 OBP 全部用于评测
- **真机**：是：1.9k 真实室内 + 1.9k 真实室外轨迹；ActiveFly 智能体（GPT-5.4 + OpenVLA）在室内外真机闭环部署，地面站推理
- **复用**：仿真环境复用 EmbodiedCity 与 AerialVLN 的城市场景及已有 VLN 路线参考；数据增广借鉴 LIBERO 与 UAV-Flow；地-机协同框架类似 UAV-Flow
- **备注**：四类观测受限场景：遮挡、非正面朝向、视野边缘、远距模糊。附录称真实场景采集 4,000 条室内外专家轨迹、8 种原子动作 + 5 类 VLA 动作，与正文（1.9k+1.9k、10 种基本 + 4 种复杂）表述不一致。

> [!quote]- 原文依据（24 句）
> - 场景来源（§4.1）：“Finally, we collect 10k trajectories from one real-world campus scene, one real-world indoor scene, and two high-fidelity urban environments Gao et al. (2024); Liu et al. (2023c).”
> - 场景数（§4.1）：“Finally, we collect 10k trajectories from one real-world campus scene, one real-world indoor scene, and two high-fidelity urban environments Gao et al. (2024); Liu et al. (2023c).”
> - 引擎 / 数据来源（Appendix A.1.1）：“Both Beijing and Citypark are built on the Unreal Engine, encompassing diverse architectural styles and street layouts.”
> - 引擎 / 数据来源（Appendix A.1.1）：“b) Support for aerial agents: Both simulators are equipped with the built-in AirSim plugin, facilitating the control of aerial agents.”
> - 引擎 / 数据来源（Appendix A.2.2）：“State estimation is powered by FAST-LIO2, a tightly-coupled LiDAR-inertial odometry framework that fuses LiDAR scans and IMU measurements.”
> - 场景内容（Appendix A.1.1）：“They feature over a hundred micro-city elements, significantly enriching the semantic information of the acquired embodied agent video data.”
> - 场景内容（References [41]（§4.1 引用））：“Embodiedcity: a benchmark platform for embodied agent in real-world city environment.”
> - 地域（Appendix A.1.1）：“Both Beijing and Citypark are built on the Unreal Engine, encompassing diverse architectural styles and street layouts.”
> - 室内外（§1）：“All UAV trajectories are collected from both real-world and simulated environments, covering three outdoor scenarios and one indoor scenario.”
> - 轨迹长度（§4.4）：“Most trajectories range from 10 to 40 meters. The instruction lengths are mainly distributed between 15 and 30 words.”
> - 规模（§4.4）：“the proposed benchmark contains 10k FLUC trajectories, 1.3k Air-EQA pairs, and 1.3k OBP pairs. FLUC includes 6.2k simulated trajectories, 1.9k real-world indoor trajectories, and 1.9k real-world outdoor trajectories.”
> - 规模（§4.1）：“A path planning algorithm is then applied to optimize a smooth trajectory, which is replayed by the UAV to automatically generate 5 to 40 demonstrations for each instruction.”
> - 动作空间（§1）：“It extends the action space to 5 DoF by jointly modeling UAV-body and camera-gimbal control, making it more realistic for real-world UAV platforms DJI (2026).”
> - 动作空间（§4.1）：“we design ten elementary behaviors, including move forward/backward, move left/right, move up/down, turn left/right, and gimbal up/down, to support fine-grained 5-DoF control learning.”
> - 观测（§5）：“This predicted plan is then used as the language instruction for the VLA model, together with the current observation and UAV state, to predict fine-grained UAV actions.”
> - 观测（§5）：“The UAV streams 1K first-person video and state information to the ground station via WiFi at 30 Hz, and receives predicted actions in return for closed-loop execution.”
> - 观测（Appendix A.1.1）：“Drone Settings in the Simulator: The drone is equipped with a gimbal-mounted camera supporting pitch movements ranging from 0 to 90 degrees.”
> - 划分（§4.4）：“the FLUC dataset is split into 80% training data and 20% testing data, with the same ratio maintained across all trajectory categories, yielding 8k training trajectories and 2k testing trajectories.”
> - 划分（§4.4）：“In contrast, all Air-EQA and OBP pairs are reserved for evaluating scene understanding and planning capabilities.”
> - 真机（§6.5）：“We present the real-world deployment and validation results of the ActiveFly Agent in both indoor and outdoor environments. The agent uses GPT-5.4 for QA and OpenVLA for action prediction.”
> - 真机（§4.4）：“FLUC includes 6.2k simulated trajectories, 1.9k real-world indoor trajectories, and 1.9k real-world outdoor trajectories.”
> - 复用（§4.1）：“To support sample-efficient imitation learning, we draw inspiration from LIBERO Liu et al. (2023a) and UAV-Flow Wang et al. (2025) and provide multiple demonstrations for each instruction based on existing trajectories.”
> - 复用（Appendix A.1.1）：“Previous research on vision-language navigation has been conducted in these simulators [50], enabling us to obtain specific route coordinates and instruction data.”
> - 复用（§1）：“We adopt a ground–drone collaborative framework similar to UAV-Flow Wang et al. (2025), in which the UAV transmits its state and visual inputs to a ground station for inference”

## SIS-Bench（Self in Space；配套训练集 SIS-Motion-54K）

[arXiv 2607.12477](https://arxiv.org/abs/2607.12477) · 2026-07 · [[topics/papers/无人机VLN/1-19_2607.12477_Self-in-Space.pdf|PDF]]

- **任务**：静态问答
- **场景来源**：真机实飞（复用公开数据集中的真实无人机视频，非作者自飞）
- **引擎 / 数据来源**：无仿真器；视频取自 AirScape、UrbanVideo-Bench（真实部分）、VisDrone，经转换/拼接/打乱处理；下游迁移测试用 OpenUAV 仿真场景
- **场景内容**：AirScape（由 UrbanVideo、NAT2021、WebUAV3M 构成，基准侧 2,067 段短视频：923/444/700）；UrbanVideo-Bench 中 174 段深圳真实视频；VisDrone 63 个场景级帧序列
- **地域**：UrbanVideo-Bench 部分为中国广东深圳（街道、小区、学校、公园）；其余来源地点未说明
- **室内外**：室外（城市、住宅、工业、自然场景）
- **飞行高度**：低空（VisDrone 部分明确为城市上空低空视角），未给数值
- **轨迹长度**：视频约 5 秒到 2 分钟以上（正文写 10 秒到 2 分钟以上），总时长约 14.9 小时
- **规模**：4,856 道选择题、13 项任务，来自 1,646 段视频（689 单段、467 拼接、237 长视频、253 打乱）；由 6,174 道候选题经双专家审核得到
- **动作空间**：无闭环控制（开环视频理解；动作预测、路径规划均为选择题）
- **观测**：无人机视频：单段、2–4 段拼接、长视频、分段打乱四种形式；VisDrone 帧序列按 15 FPS 转成视频
- **划分**：AirScape 原测试集作基准池、训练集留作 SIS-Motion-54K；为防泄漏重分：UrbanVideo 来源片段全部归基准侧，NAT2021 不变，WebUAV3M 再平衡使基准保留 700 段；训练池为 1349 NAT2021 + 7596 WebUAV3M
- **真机**：数据为真实无人机视频（复用）；无真机飞行评测
- **复用**：AirScape（含 UrbanVideo、NAT2021、WebUAV3M）、UrbanVideo-Bench、VisDrone；下游导航迁移测试由 OpenUAV 构建（22 个仿真场景、3,895 题）
- **备注**：作者自述局限：基准由现有数据集标准化重组，范围受限于这些来源、选择题形式和开环视频理解。下游 OpenUAV 测试涵盖城市、沙漠、森林、港口、海岛等 22 个仿真场景。

> [!quote]- 原文依据（23 句）
> - 场景来源（§3.3）：“SIS-Bench contains 4,856 multiple-choice question–answer pairs from 1,646 real-world UAV videos collected from AirScape [60], UrbanVideo-Bench [59], and VisDrone [54].”
> - 引擎 / 数据来源（§3.2）：“We start from three public sources: AirScape [60], UrbanVideo-Bench [59], and VisDrone [54].”
> - 引擎 / 数据来源（§5.2）：“we test transferability on a downstream UAV navigation benchmark constructed from OpenUAV [50], where continuous path trajectories are converted into multiple-choice action decisions.”
> - 场景内容（Appendix 7.2）：“After the adjusted split, the AirScape benchmark pool contains 2067 short videos in total (923 from UrbanVideo, 444 from NAT2021, and 700 from WebUAV3M).”
> - 场景内容（Appendix 7.1）：“UrbanVideo-Bench contains both real-world and simulated UAV data. In this work, we select 174 real-world videos from UrbanVideo-Bench.”
> - 场景内容（Appendix 7.1）：“We collect 63 scene-level frame sequences from VisDrone. The content mainly consists of low-altitude UAV views over urban areas, such as streets, parks, and residential neighborhoods.”
> - 地域（Appendix 7.1）：“These videos are recorded in authentic urban environments in Shenzhen, Guangdong Province, China, including city streets, residential communities, schools, and parks.”
> - 室内外（§3.3）：“In total, these videos cover approximately 14.9 hours of UAV footage and span diverse environments, including urban, residential, industrial, and natural scenes.”
> - 飞行高度（Appendix 7.1）：“We collect 63 scene-level frame sequences from VisDrone. The content mainly consists of low-altitude UAV views over urban areas, such as streets, parks, and residential neighborhoods.”
> - 轨迹长度（Appendix 7.3）：“Overall, the resulting videos span a wide temporal range from about 5 seconds to more than 2 minutes and cover diverse environments such as urban streets, residential areas, schools, parks, and waterfront regions.”
> - 轨迹长度（§3.3）：“In total, these videos cover approximately 14.9 hours of UAV footage and span diverse environments, including urban, residential, industrial, and natural scenes.”
> - 规模（Appendix 7.3）：“After the above collection and processing steps, we obtain four video types in the benchmark: 689 Single Video samples, 467 Concatenated Video samples, 237 Long Video samples, and 253 Shuffled Video samples.”
> - 规模（Appendix 8.4）：“In total, the review starts from 6,174 generated QA pairs. Among them, 1,944 are approved without modification, 2,912 are modified and retained after review, and 1,318 are rejected, resulting in the final 4,856 QA pairs.”
> - 动作空间（Appendix 13.1）：“By standardizing existing datasets and reorganizing established tasks as QA probes, its scope remains limited to these sources, multiple-choice evaluation, and open-loop UAV video understanding.”
> - 观测（§3.1）：“(1) Single Video keeps one self-contained observation for instantaneous perception. (2) Concatenated Video composes 2–4 Single Video clips to add cross-segment dependency for memory evaluation.”
> - 观测（Appendix 7.2）：“For VisDrone, we convert raw frame sequences into videos at 15 FPS, i.e., every 15 frames correspond to 1 second of video time.”
> - 划分（Appendix 7.1）：“We use the original AirScape test split as the main source pool for benchmark construction and reserve the original training split for subsequent training-data construction.”
> - 划分（Appendix 7.1）：“In the adjusted protocol, all UrbanVideo-origin clips are placed on the benchmark side, the NAT2021 split remains unchanged, and the WebUAV3M portion is re-balanced so that the benchmark retains 700 clips while the remaining clips are moved to the training pool.”
> - 划分（Appendix 11.1）：“SIS-Motion-54K is built from the adjusted AirScape training pool (0 UrbanVideo clips, 1349 NAT2021 clips, and 7596 WebUAV3M clips) and uses the same task templates as the benchmark pipeline.”
> - 真机（Appendix 7.1）：“prioritizing authentic UAV observations from varied real-world environments to ensure practical relevance and broad generalization.”
> - 真机（§3.3）：“SIS-Bench contains 4,856 multiple-choice question–answer pairs from 1,646 real-world UAV videos collected from AirScape [60], UrbanVideo-Bench [59], and VisDrone [54].”
> - 复用（Appendix 7.1）：“AirScape is a UAV dataset with action-intent annotations, and its videos are generally short. The dataset is built from three underlying sources: UrbanVideo, NAT2021, and WebUAV3M.”
> - 复用（§5.4）：“The benchmark requires the model to make action decisions under realistic navigation contexts and contains 3,895 questions from 22 simulated environments, covering urban, desert, forest, port, and island scenes.”

## UAV-DualCog（配套训练集 UAV-DualCog-Train）

[arXiv 2607.16193](https://arxiv.org/abs/2607.16193) · 2026-07 · [[topics/papers/无人机VLN/1-20_2607.16193_UAV-DualCog.pdf|PDF]]

- **任务**：静态问答
- **场景来源**：混合（AirSim 仿真场景为主 + 3DGS 重建的真实航拍场景试点）
- **引擎 / 数据来源**：扩展 AirSim 的 State-aware UAV Simulation Platform (SUSP) + DualCog-aware Capture System (DCCS)；sim-to-real 试点用 CityGaussianV2 重建 GauU-Scene 真实航拍场景
- **场景内容**：SUSP 资产池 18 个场景，从 2,626 个候选中保留 746 个地标（场景本身来源未说明）；3DGS 试点为 GauU-Scene 真实航拍场景（校园与市中心）
- **场景数**：基准 12 个场景（512 个地标）；训练集另 6 个场景；资产池共 18 个；3DGS 试点 3 个
- **面积**：资产池 18 个场景共 5.04 km²
- **轨迹长度**：视频子集 1,024 条轨迹共 19,633.30 秒（按总时长折算平均约 19 秒）
- **规模**：4,096 个图像样本 + 2,048 个视频样本，6 个任务；训练集 11,232 个图像样本（234 个地标）；3DGS 试点 400 道图像题（30 个地标）
- **观测**：多视角图像与第一人称视频；模型需输出答案及 BBox 或时间区间；构建时平台同步记录 6-DoF 位姿、相机内外参、语义点云、LiDAR、RGB、分割与遥测
- **划分**：测试用 12 个场景；UAV-DualCog-Train 来自与测试不相交的 6 个场景
- **真机**：无；sim-to-real 仅在 3 个真实航拍场景的 3DGS 重建上做试点，作者称未来将扩展到实体无人机
- **复用**：AirSim（扩展 API）；GauU-Scene 真实航拍数据 + CityGaussianV2 重建
- **备注**：视频模块生成分层飞行行为（高层导航模式 + 原子机动），并验证运动学可行与无碰撞；仿真提供完整位姿、地标几何与可见性，用于自动生成 BBox/时间区间标注。

> [!quote]- 原文依据（18 句）
> - 场景来源（§II-B）：“State-aware simulation provides complete 6-DoF pose, geometry, and visibility metadata for controlled construction, while a separate real-scene 3DGS pilot tests protocol portability beyond simulation environments.”
> - 引擎 / 数据来源（§III-C）：“The State-aware UAV Simulation Platform (SUSP) consolidates scene scanning and landmark asset construction. It extends AirSim with unified APIs for 6-DoF pose, camera intrinsics/extrinsics, semantic point clouds, landmark geometry, and collisions.”
> - 引擎 / 数据来源（§IV-D）：“We extend the construction pipeline to three CityGaussianV2 [67] reconstructions built from real GauU-Scene [68] aerial scenes across campus and downtown.”
> - 场景内容（§III-D）：“The SUSP asset pool spans 18 scenarios ( 5.04\,\text{km}^{2} ) and retains 746 landmarks from 2,626 candidates.”
> - 场景内容（§IV-D）：“We extend the construction pipeline to three CityGaussianV2 [67] reconstructions built from real GauU-Scene [68] aerial scenes across campus and downtown.”
> - 场景数（§III-D）：“The released benchmark uses 12 scenarios and 512 landmarks to construct 4,096 image and 2,048 video samples balanced across six tasks.”
> - 场景数（§I）：“A pilot with 30 landmarks and 400 image questions from 3 real-scene 3DGS reconstructions reproduces the main capability separation.”
> - 面积（§III-D）：“The SUSP asset pool spans 18 scenarios ( 5.04\,\text{km}^{2} ) and retains 746 landmarks from 2,626 candidates.”
> - 轨迹长度（§III-D）：“The video subset is built from 1,024 trajectories totaling 19,633.30 seconds. Fig. 3 summarizes the statistics.”
> - 规模（§I）：“The released benchmark spans 6 grounded tasks, containing 4,096 image and 2,048 video samples from 12 scenes and 512 landmarks.”
> - 规模（§I）：“We also construct UAV-DualCog-Train with 234 landmarks and 11,232 samples from 6 disjoint scenes; a lightweight two-stage optimization probe shows that the benchmark design can provide structured supervision.”
> - 观测（§III-B）：“Four multi-view image tasks predict an answer option and a normalized landmark bounding box.”
> - 观测（§III-B）：“Two egocentric video tasks require semantic predictions and temporal intervals.”
> - 观测（§III-C）：“Coverage-aware pose sampling synchronizes LiDAR, RGB, segmentation, and telemetry. Multi-view spatial association and 3D instance aggregation then cluster candidate landmarks for geometric/semantic annotation and human verification, producing reusable multi-view assets.”
> - 划分（§IV-E）：“UAV-DualCog-Train contains 11,232 image samples from six scenes disjoint from testing, covering four tasks, two difficulty levels, 234 landmarks, and the answer–BBox output contract.”
> - 真机（§V）：“Our three-scene 3DGS pilot extends the protocol to real aerial reconstructions and reproduces the broad capability trends observed in simulation. Future work will extend evaluation to physical UAVs across more diverse real-world scenes”
> - 复用（§III-C）：“It extends AirSim with unified APIs for 6-DoF pose, camera intrinsics/extrinsics, semantic point clouds, landmark geometry, and collisions.”
> - 复用（§IV-D）：“We extend the construction pipeline to three CityGaussianV2 [67] reconstructions built from real GauU-Scene [68] aerial scenes across campus and downtown.”

## MissionBench

[arXiv 2607.22014](https://arxiv.org/abs/2607.22014) · 2026-07 · [[topics/papers/无人机VLN/1-21_2607.22014_MissionBench.pdf|PDF]]

- **任务**：任务级评测
- **场景来源**：游戏引擎合成
- **引擎 / 数据来源**：Unreal Engine 5 + Cosys-AirSim（AirSim 社区维护分支）
- **场景内容**：Forest 用 Unreal Fab 商店免费资产从零搭建；Neighborhood 在购买的小场景上扩展；City 在已有底图上搭建；AirSimNH 与 Savannah 取自 AirSim 官方预编译二进制；任务相关物体人工放置
- **场景数**：5（Neighborhood、City、Forest、Savannah、AirSimNH）
- **室内外**：室外
- **轨迹长度**：人工参考轨迹长度 13 m 至 4,171 m，中位数 93 m，平均 260 m
- **规模**：120 个任务：Reporting 57、Inspection 38、Manipulation 16、Patrol 9
- **动作空间**：连续幅度：8 个方向原语（前/后、左右平移、升/降、左/右转），每步幅度最大 d_max 米或 3×d_max 度（d_max 为起点到终点距离的 1/4），解析为航点执行；步数上限巡逻 50、其他 20
- **观测**：仅第一视角 RGB（1920×1080，相机俯仰固定 -45°）：当前图像 + 最多两张历史图像 + 动作历史；初始给出位姿 (x,y,z,ψ)
- **划分**：Proxy 10（N）、Ablation 5（Proxy 子集）、Test 30（N/F/C）、Held-out 80（全部 5 个环境，留作微调）
- **真机**：无：纯仿真基准，作者称不代表真机可用，真实世界评测为后续工作
- **复用**：Cosys-AirSim（AirSim 分支）+ UE5；AirSimNH 与 Savannah 环境来自 AirSim 官方发布
- **动态因素**：各环境物体密度、光照条件和地形复杂度不同；作者称无法覆盖动态障碍物等真实因素
- **备注**：任务均由人工设计并多位作者审核，参考轨迹由人工在模拟器中遥控飞行得到；起始位姿使目标部分可见但需主动接近；零样本评测 22 个冻结 MLLM，最佳 SR 34.8%，人类 84.4%。

> [!quote]- 原文依据（20 句）
> - 场景来源（§3.3 Simulation Suite）：“MissionBench is built on Unreal Engine 5 (Epic Games, 2019) and uses Cosys-AirSim (Jansen et al., 2023) for physics-based UAV simulation.”
> - 引擎 / 数据来源（Appendix C.1）：“First, CosysAirSim is a community-maintained fork of AirSim (Shah et al., 2017), which has been actively adopted in the drone research literature. Second, CosysAirSim supports Unreal Engine 5”
> - 场景内容（Appendix C.1）：“The Forest environment was built from scratch using free assets from the Unreal Fab store. The Neighborhood (NH) environment was developed by extending a small purchased scene, and the City environment was similarly built on top of an existing base.”
> - 场景内容（Appendix C.1）：“The AirSim Neighborhood (AirSimNH) and Savannah environments were sourced from pre-compiled binaries distributed with the official AirSim release.”
> - 场景内容（§3.3 Mission Definition）：“The objects or regions relevant to the mission are explicitly placed within the simulation environment during construction.”
> - 场景数（§3.3 Simulation Suite）：“It includes five high-fidelity environments drawn from real-world settings: Neighborhood, City, Forest, Savannah, and AirSimNH.”
> - 室内外（§3.3 Simulation Suite）：“Together, these environments cover a broad range of natural and urban scenes, with different object densities, lighting conditions, and terrain complexity.”
> - 轨迹长度（§3.3 Mission Definition）：“The benchmark spans a wide spectrum of operating ranges, featuring ground-truth trajectory lengths from 13 m up to 4,171 m, with a median of 93 m and a mean of 260 m”
> - 规模（Appendix A.1）：“MissionBench’s 120 missions are slightly skewed toward reporting (N=57) and inspection missions (N=38) with fewer manipulation (N=16) and patrol (N=9) missions”
> - 动作空间（§3.1）：“The agent can select from eight directional primitives (forward, backward, strafe left/right, ascend, descend, turn left/right) and move in each with a permissible magnitude up to d_{\max} meters or 3\times d_{\max} degrees.”
> - 动作空间（§4.1 Benchmark setup）：“The allowable per-step magnitude d_{\max} (i.e., the maximum distance the agent can traverse in any direction) is automatically chosen to be one fourth of the distance from the start pose to the final pose.”
> - 动作空间（§4.1 Benchmark setup）：“The maximum action budget is set to T_{\max}=50 for patrol missions and T_{\max}=20 otherwise.”
> - 观测（§4.1 Model setup）：“The visual inputs consist of the three most recent egocentric images at 1920\times 1080 resolution with a fixed camera pitch of -45^{\circ} .”
> - 观测（§3.1）：“At each subsequent step t , the agent receives the current image I_{t} , up to two previous images, and the history of past actions.”
> - 划分（Table 2）：“Test 30 N, F, C 17 R / 7 I / 3 M / 3 P Main evaluation (§4.2) Held-out 80 N, F, C, S, NH Remaining Future fine-tuning”
> - 划分（§4.1 Dataset splits）：“The Test split is used for the main cross-model evaluation. The remaining 80 missions form the Held-out split, which we reserve for future fine-tuning.”
> - 真机（Appendix A.1）：“MissionBench provides a controlled evaluation of zero-shot mission execution in high-fidelity simulation and does not imply real-world flight readiness as a sim-to-real gap may persist.”
> - 复用（Appendix C.1）：“The AirSim Neighborhood (AirSimNH) and Savannah environments were sourced from pre-compiled binaries distributed with the official AirSim release.”
> - 动态因素（Appendix A.1）：“Although the 120-mission set is diverse, it remains limited in scale and cannot capture real-world factors such as sensor noise, dynamic obstacles, or adversarial conditions.”
> - 动态因素（§3.3 Simulation Suite）：“Together, these environments cover a broad range of natural and urban scenes, with different object densities, lighting conditions, and terrain complexity.”

## DroneCATS

[arXiv 2609.01404](https://arxiv.org/abs/2609.01404) · 2026-09 · [[topics/papers/无人机VLN/1-29_2609.01404_DroneCATS.pdf|PDF]]

- **任务**：目标搜索
- **场景来源**：混合（仿真器合成场景 AirSim / Isaac Sim + 真机实飞）
- **引擎 / 数据来源**：AirSim 1.8.1（内置 SimpleFlight 飞控，非 PX4 SITL）；Isaac Sim + PX4 飞控栈（小规模套件）；真机 DJI Tello（Tello SDK）
- **场景内容**：AirSim：住宅街区（含房屋室内）、校园、AirSim 自带 block 地图；Isaac Sim：室外街道场景 Brownstone。住宅图目标为逐 episode 生成的资产（车辆、骑车人、无人机、滑板、家具、小物件），校园图为 7 个场景自带设施 + 3 架生成的无人机
- **场景数**：AirSim 3 张地图（住宅、校园、block）+ Isaac Sim 1 个街道场景；真机 2 个室内房间
- **室内外**：室内外
- **飞行高度**：真机起飞至 1.5 m；仿真未写明
- **轨迹长度**：真机静态目标距起点 5–10 m，移动目标固定路线 22.5 m；仿真单步最多 3 m，episode 上限 300 s
- **规模**：单机 80 个 episode（4 类任务 × 20，各飞两次 = 160 runs）；多机 / 指挥官+子智能体 3 难度 × 10 个 episode（N=4），共 600 episode；Isaac Sim 28 个 episode；真机单机 100 个 + 指挥官 18 个 episode
- **动作空间**：离散 4 类动作带连续参数：go（图像点 0–1000 坐标 + 距离 d 米）、rotate（偏航 ±90°）、think、finished；由规则控制器转为体坐标速度指令
- **观测**：前向相机单帧 RGB（渲染 1280×720，缩放到 640×360，FOV 90°）+ 指令 + 最近 5 个动作；指挥官另得 N 个无人机画面、子智能体上一动作与俯视地图；真机 Tello 960×720、56.4° FOV
- **划分**：无训练/测试划分；微调数据仅来自公开 RGB-D 数据集，不含基准帧，仿真器与真机对微调模型均未见
- **真机**：是：DJI Tello 在 2 个室内房间实飞，单机 5 个模型 × 4 任务 × 5 = 100 个 episode；2 架 Tello 指挥官+子智能体 18 个 episode（Three-sign sum）
- **复用**：AirSim 自带 block 地图；Isaac Sim（Gao et al. 2026）的 Brownstone 场景；微调用 NYU Depth v2、SUN RGB-D、TartanAir 与 MAmmoTH-VL 指令数据
- **动态因素**：移动目标沿单向路线运动，室外 0.3 m/s、室内 0.15 m/s；真机移动目标为人、玩具飞机、零食盒、另一架无人机；天气/光照未提
- **备注**：成功判据：在 δ（室外 5 m、室内 2.5 m、真机 1.5 m）内且目标可见时声明到达。Isaac Sim 场景大且开碰撞检测，仿真 1 s 约耗 11 s 墙钟时间，渲染质量与 AirSim 不同。真机只飞 2 架，因 Tello 为固定 IP 的 Wi-Fi 热点，多于 2 架会互相干扰。

> [!quote]- 原文依据（30 句）
> - 场景来源（§3.2）：“Episodes run in AirSim and Isaac Sim (Shah et al., 2017; Gao et al., 2026) (Appendix G). The maps cover indoor and outdoor scenes: a residential neighbourhood with house interiors, a campus, and the AirSim block map.”
> - 场景来源（§4.3）：“We use a DJI Tello controlled through the Tello SDK, with the agent, prompt and action space of Section 2 (settings in Appendix A.4).”
> - 引擎 / 数据来源（Appendix A.2）：“AirSim 1.8.1 with its built-in SimpleFlight flight controller, not PX4 SITL, so no autopilot firmware sits between the controller and the airframe.”
> - 引擎 / 数据来源（Appendix G）：“We also run a smaller single-drone suite in Isaac Sim (Gao et al., 2026) with the PX4 flight stack, on one large outdoor street scene, Brownstone.”
> - 场景内容（Appendix A.1）：“On the residential map every target is an asset spawned into the scene, one per episode: vehicles, a cyclist, drones, a skateboard, furniture and small objects, named by type and, where needed, by colour”
> - 场景内容（Appendix A.1）：“On the campus map the static targets are seven fixtures native to the scene and three spawned drones.”
> - 场景内容（Appendix A.1）：“License plate matching uses the residential map, and Sign matching and Three-sign sum use the block map that ships with AirSim.”
> - 场景数（§3.2）：“The maps cover indoor and outdoor scenes: a residential neighbourhood with house interiors, a campus, and the AirSim block map. The Isaac Sim suite uses one outdoor street map, Brownstone.”
> - 场景数（Appendix A.4）：“Each model flies five episodes per task type, one per target, in two indoor rooms.”
> - 室内外（Appendix A.1）：“Three of the ten static episodes and two of the ten moving ones on the residential map are set inside a house, where \delta is 2.5 m instead of 5 m.”
> - 飞行高度（Appendix A.4）：“The drone takes off to 1.5 m and holds position after a finished.”
> - 轨迹长度（Appendix A.4）：“Static targets (approach, search) are a gray water bottle, a pink laptop sleeve, a military uniform, a white umbrella and an egg, placed 5 – 10 m from the start pose.”
> - 轨迹长度（Appendix A.4）：“Every moving target follows a fixed route of 22.5 m over the 150 s cap, that is 0.15 m/s, the speed of the indoor moving targets in simulation.”
> - 轨迹长度（Appendix A.2）：“It then flies toward the point with a body-frame velocity command (moveByVelocityBodyFrameAsync) held for at most 2.5 s at up to 1.2 m/s, so one step moves at most 3 m.”
> - 规模（§3.2）：“The single-drone suite has 20 episodes per task type, 80 in total, and the multi-drone and commander + sub-agents suites 3 difficulty levels of 10 episodes each at N{=}4 , flown under every command structure and commander (Section 4.2).”
> - 规模（Appendix G）：“It has 28 episodes, eight approach, eight search, six track and six search + track, each flown once.”
> - 规模（§4.2）：“Table 2 covers 600 episodes: 30 per model, 10 at each difficulty level, under either the multi-drone or the commander + sub-agents structure.”
> - 动作空间（§2.1）：“The model returns the point (x,y) , normalised to 0 – 1000 , and a distance d in metres; the point defines a camera ray, and the controller advances the drone d along it, up to a step cap.”
> - 动作空间（Appendix A.2）：“The controller answers go with a turn and a move toward the point, rotate with a yaw in place, and think and finished by holding position.”
> - 观测（§2.1）：“a user prompt, which includes the user’s instruction (“go to the black chair” in the figure), the current frame I_{t} and the previous 5 actions.”
> - 观测（Appendix A.2）：“The field of view is \phi=90^{\circ} . The camera renders at 1280\times 720 , and the model receives the frame resized to 640\times 360 .”
> - 观测（§2.3）：“The commander sees the N frames, each sub-agent’s last action and a top-down map, and breaks the user’s instruction down into one command per drone”
> - 划分（Appendix C）：“The fine-tuning set contains no frames from the benchmark maps. AirSim is used only for evaluation.”
> - 划分（§1）：“With the simulator and the real drone unseen in training, its success rate rises from 0% to 31% in simulation, and it outperforms the frontier models on a real drone.”
> - 真机（§4.3）：“We flew 5 models: Gemini 3.7 Flash, Claude Opus 5, Qwen3.5-9B, and Cosmos3-Edge-2B zero-shot and fine-tuned. Table 3(a) reports 100 episodes, 5 per cell.”
> - 真机（§4.3）：“The sub-agents are 2 Tellos, each run by Gemini Robotics-ER 2 as in Section 4.2. Table 3(b) reports 18 episodes, 6 per commander.”
> - 复用（Appendix C）：“These are NYU Depth v2 (Silberman et al., 2012) (338 train / 25 val images, indoor, Kinect), SUN RGB-D (Song et al., 2015; Janoch et al., 2011; Xiao et al., 2013) (891 / 102, indoor, Kinect) and TartanAir”
> - 复用（Appendix A.1）：“License plate matching uses the residential map, and Sign matching and Three-sign sum use the block map that ships with AirSim.”
> - 动态因素（Appendix A.1）：“Moving targets travel at 0.3 m/s outdoors and 0.15 m/s indoors along one-way routes.”
> - 动态因素（Appendix A.4）：“Moving targets (track, search + track) are a person wearing the military uniform, a person carrying the pink laptop sleeve, a toy plane, a snack box and a second drone, moved during the episode.”

## AGOS-Bench / AGOS-Dataset

[arXiv 2609.08402](https://arxiv.org/abs/2609.08402) · 2026-09 · [[topics/papers/无人机VLN/2-09_2609.08402_AGOS.pdf|PDF]]

- **任务**：空地协同
- **场景来源**：游戏引擎合成
- **引擎 / 数据来源**：CARLA-Air（CARLA + AirSim 集成于单个 Unreal Engine 4 进程）
- **场景内容**：CARLA-Air 内置城市地图（CARLA towns）；搜索目标为车辆，Hard 难度加入 2–3 辆外观相似的干扰车；UGV 路网由 CARLA OpenDRIVE 道路拓扑生成
- **场景数**：6 个 CARLA 城镇（5 个训练/验证 + 1 个测试 Town03）
- **面积**：单 episode 搜索区域：Easy 150×150 m，Mid/Hard 300×300 m
- **地域**：CARLA 城镇地图（5 个训练/验证城镇未具名）；测试城镇 Town03
- **室内外**：室外
- **飞行高度**：UAV 固定飞行高度 80 m
- **轨迹长度**：未给平均轨迹长度；评测每 episode 限 80 个高层决策步
- **规模**：7,700 个 episode（5,500 训练 + 2,200 验证）+ 210 个测试 episode（每个难度 70 个）
- **动作空间**：离散航点：UAV 在 40 m 间距、80 m 高的网格上选 3×3 邻域节点（最多 8 个，轴向 40 m、对角约 56.6 m），并可 ANNOTATE_CANDIDATE / NO_RELIABLE_CANDIDATE / WAIT；UGV 在冻结路网上选约 10 m、30 m 前方锚点、路口出口或约 10 m 后退，及 GO_TO_CANDIDATE / STOP_OBSERVE / CONFIRM / REJECT / WAIT；双方可互发消息
- **观测**：UAV 俯视相机（俯仰 -90°，叠加 5×5 网格），UGV 六相机环视（行驶时仅前视，STOP_OBSERVE 后给六视图）；RGB、深度、语义图；默认可获得全局定位、城市地图与路网；区域俯视地图 + 去背景的多视角目标图像；队友消息
- **划分**：训练 5,500 + 验证 2,200 来自 5 张 CARLA-Air 地图；测试 210 个 episode 位于另一张未见地图 Town03，Easy/Mid/Hard 各 70
- **真机**：无；作者说明未测试 sim-to-real 迁移
- **复用**：CARLA-Air 平台（集成 CARLA 与 AirSim）；CARLA OpenDRIVE 路网与传感器 API；评测指标沿用 GeoNav
- **动态因素**：目标与干扰物均为静止车辆；未提及天气或光照变化
- **备注**：专家轨迹由 mTSP 求解覆盖全部航点、截断到发现目标为止，每 10 m 采集观测；成功需 UGV 在目标 50 m 内并视觉确认；通信理想化、地图已知；作者承认仅一个测试城镇，地理与外观泛化有限

> [!quote]- 原文依据（36 句）
> - 引擎 / 数据来源（Simulator Platform）：“The platform integrates the urban autonomous driving simulator CARLA (Dosovitskiy et al. 2017) and the multi-rotor UAV simulator AirSim (Cui et al. 2026) within a single Unreal Engine 4 process”
> - 场景来源（Simulator Platform）：“It is an open-source simulation infrastructure designed for research on air–ground collaborative embodied intelligence, and provides photorealistic urban and natural environments with multiple built-in urban scene maps.”
> - 场景内容（Difficulty Configuration）：“Vehicles are chosen as the search targets, as vehicle detection features moderate difficulty and considerable practical value.”
> - 场景内容（Difficulty Configuration）：“Table 2 summarizes the differences among these levels, where distractors refer to visually similar vehicles employed to examine the agent’s ability to discriminate the target.”
> - 场景内容（Appendix A.1.1）：“The UGV waypoints are generated from CARLA’s OpenDRIVE road topology rather than from a rectangular grid.”
> - 场景内容（Introduction）：“The AGOS-Dataset is a companion resource of 7,700 episodes across five CARLA towns (5,500 train + 2,200 validation), plus a 210-episode test split on a disjoint town”
> - 场景数（Expert Dataset）：“The AGOS dataset consists of 5,500 training episodes and 2,200 validation episodes collected over five CARLA-Air maps, with an additional 210 held-out episodes reserved for testing on a separate unseen map.”
> - 面积（Table 2）：“Difficulty | Region Size | Distractors | Core Challenge | Easy | 150\!\times\!150\, m | 0 | Close-range search | Mid | 300\!\times\!300\, m | 0 | Large-scale search | Hard | 300\!\times\!300\, m | 2 – 3 |”
> - 地域（Experimental Setup）：“We evaluate nine VLM backbones on the same 210 fixed Town03 episodes, with 70 episodes in each difficulty condition.”
> - 地域（Introduction）：“The AGOS-Dataset is a companion resource of 7,700 episodes across five CARLA towns (5,500 train + 2,200 validation), plus a 210-episode test split on a disjoint town”
> - 室内外（Introduction）：“no existing benchmark directly assesses whether they can instantiate a UAV-UGV system that efficiently completes the object search tasks in open urban spaces.”
> - 飞行高度（Appendix A.1.1）：“With grid spacing s_{A}=40\,\mathrm{m} and flight altitude h_{A}=80\,\mathrm{m} , the initial UAV grid is”
> - 飞行高度（Appendix A.4.1）：“The UAV prompt defines the UAV as an aerial search agent flying at a fixed altitude of 80\,\mathrm{m} with a top-down camera.”
> - 轨迹长度（Experimental Setup）：“We evaluate nine VLM backbones on the same 210 fixed Town03 episodes, with 70 episodes in each difficulty condition. Each run enforces an 80-step budget for high-level decisions.”
> - 规模（Expert Dataset）：“The AGOS dataset consists of 5,500 training episodes and 2,200 validation episodes collected over five CARLA-Air maps, with an additional 210 held-out episodes reserved for testing on a separate unseen map.”
> - 动作空间（Action Space）：“Instead of focusing on low-level actions, this task focuses more on high-level search path planning in AGOS tasks. We uniformly sample discrete waypoints to constrain the movement paths of the UAV and the UGV.”
> - 动作空间（Appendix A.1.2）：“Since s_{A}=40\,\mathrm{m} , this rule yields at most eight selectable neighbors. Axis-aligned moves cover 40\,\mathrm{m} , while diagonal moves cover approximately 56.6\,\mathrm{m} .”
> - 动作空间（Appendix A.1.2）：“These options include forward anchors at approximately 10\,\mathrm{m} and 30\,\mathrm{m} of road-network distance, valid intersection exits when a junction entry is near the current route, and a backward option of roughly 10\,\mathrm{m} based on the actual route history when a legal return path exists.”
> - 动作空间（Appendix A.4.1）：“When no candidate is active, the UAV may use MOVE_TO_UAV_WAYPOINT, ANNOTATE_CANDIDATE, NO_RELIABLE_CANDIDATE, or WAIT.”
> - 动作空间（Appendix A.4.1）：“The UGV action space includes MOVE_TO_ROAD_WAYPOINT, GO_TO_CANDIDATE, STOP_OBSERVE, CONFIRM, REJECT, and WAIT.”
> - 观测（Sensors for UAV and UGV）：“We deploy a camera on the UAV with a pitch angle of -90^{\circ} , and equip the UGV with six cameras to capture a surrounding six-view image set. At each timestep t , these cameras provide multi-modal observations including RGB images, depth maps, and semantic maps”
> - 观测（Sensors for UAV and UGV）：“Because our task is situated in urban scenarios, we assume by default that all platforms have access to global localization signals, urban maps, and road networks.”
> - 观测（Task Description）：“At the beginning of each episode, the UAV and the UGV receive their own location P_{0}^{A/G} , the top-down map M of region S and multi-view images I_{target} of the target.”
> - 观测（Appendix A.4.1）：“In driving mode, the UGV observes only a forward-facing camera image. After STOP_OBSERVE, the UGV receives six directional views for local 360-degree inspection.”
> - 观测（Appendix A.4.1）：“The aerial observation contains a 5\times 5 grid overlay whose cells are labeled from A1 to E5.”
> - 划分（Expert Dataset）：“The AGOS dataset consists of 5,500 training episodes and 2,200 validation episodes collected over five CARLA-Air maps, with an additional 210 held-out episodes reserved for testing on a separate unseen map.”
> - 划分（Experimental Setup）：“We evaluate nine VLM backbones on the same 210 fixed Town03 episodes, with 70 episodes in each difficulty condition.”
> - 真机（Limitations）：“Confirmation is a scene-level decision rather than an instance-ID or bounding-box prediction, and simulator-to-real transfer has not been tested.”
> - 复用（Simulator Platform）：“AGOS-Bench is built upon the CARLA-Air (Zeng et al. 2026) simulation platform.”
> - 复用（Related Work）：“AGOS-Bench is built on CARLA-Air (Zeng et al. 2026) to exploit its unified air-ground infrastructure.”
> - 复用（Evaluation Metrics）：“Following GeoNav (Xu et al. 2025), we adopt four standard metrics to evaluate the performance of the agents including Success Rate (SR),”
> - 复用（Stage 3）：“We additionally collect supplementary semantic images Sem by invoking CARLA’s sensor API for future research.”
> - 动态因素（Limitations）：“The evaluation contains 210 episodes from one test town, so geographic and appearance generalization remain limited. Targets and distractors are static vehicles; communication is idealized; the map is known; and control uses high-level discrete actions rather than low-level flight and driving.”
> - 备注（Stage 1）：“This optimization problem can be transformed into a multiple traveling salesman problem (mTSP) for solving the optimal trajectories.”
> - 备注（Stage 3）：“the image collector sequentially captures observation images O_{i}^{\text{A/G}} from the UAV and UGV perspectives at each waypoint p_{i}^{\text{A/G}} , and samples observations every 10 meters between two nodes.”
> - 备注（Task Description）：“The search task ends when the UGV halts within a 50-meter radius of the target object and completes visual confirmation within its sight.”

## SatNav

[arXiv 2609.31507](https://arxiv.org/abs/2609.31507) · 2026-09 · [[topics/papers/视觉语言导航VLN/4-28_2609.31507_SatNav.pdf|PDF]]

- **任务**：VLN
- **场景来源**：卫星/航拍影像
- **引擎 / 数据来源**：自建卫星地图环境：高分辨率卫星图（如 Google Maps）对齐 OpenStreetMap，按位姿旋转裁剪生成观测
- **场景内容**：高分辨率卫星图（瓦片 zoom 19，约 0.3 m/像素）+ OSM 标注（湖泊、道路、水道等）；场景含住宅、商业、工业、公园、海岸、河流及混合城区；线索描述由 Qwen3.5 生成
- **场景数**：59
- **面积**：总覆盖 813 km²；每个场景平均约 14 km²
- **地域**：五大洲 18 个城市：Amsterdam、Auckland、Berlin、Boston、Brugge、Dubai、Geneva、London、Los Angeles、Minneapolis、New York、Orlando、Paris、Rio de Janeiro、Rome、Rotterdam、Sydney、The Bay Area
- **室内外**：室外
- **飞行高度**：固定高度、移除高度自由度；观测足迹 100 m×100 m 对应 50 m 高度 + 90° 水平视场（敏感性实验另测 25 m / 100 m 对应足迹）
- **轨迹长度**：平均 379 m，中位 340 m；轨迹总长 44.95K km
- **规模**：118,494 个 episode（Boundary 25.5%、Landmark 38.1%、Route 36.3%）；词表 4,740，平均指令 41 词
- **动作空间**：离散 4 动作：forward 10 m、left/right 转 15°、stop；可输出单个动作或动作序列
- **观测**：以航向对齐的卫星裁剪图（448×448 像素，地面覆盖 100 m×100 m，前进方向朝上）+ 语言指令 + 导航历史
- **划分**：Train 56 个场景/15 个城市（占 88.7%）；Test Seen 4,574 个 episode 来自 3 个训练场景但用新轨迹与新指令；Test Unseen 8,756 个来自 3 个新城市的 3 个未见场景
- **真机**：有：DJI Matrice 4D 实飞 18 个 episode（每类任务 6 个）；卫星到 UAV 适配器用 24,467 对 UAV-卫星图训练；另在 94 个由真实 3D 资产渲染的 episode 上做迁移评测
- **复用**：Google Maps 卫星图、OpenStreetMap；适配器数据取自 DenseUAV、GTA-UAV、SUES、UAV-VisLoc；SwiftVLN 重构自 StreamVLN；指令由 Qwen3.5 与 Gemini 3 Flash 生成改写
- **备注**：作者列出的局限：只有 4 个离散动作且高度固定，生成时剔除需其他动作的路径，偏向平滑路线；实飞次数受系统延迟限制。Boundary 任务要求先离开起点 20 m 以上再返回才计成功

> [!quote]- 原文依据（31 句）
> - 场景来源（Abstract）：“SatNav targets city-level navigation missions and uses satellite crops as approximations of UAV nadir views for visual observations. Through an automated cue-to-episode pipeline, SatNav constructs 118K episodes from 59 scenes across 18 cities, with an average trajectory length of 379 m.”
> - 引擎 / 数据来源（§3.2）：“Specifically, we use high-resolution satellite imagery (e.g., Google Maps (Google LLC, 2026)) as the visual source and align it with OSM annotations (OpenStreetMap, 2026) for structured geographic information.”
> - 引擎 / 数据来源（§3.1）：“At each decision step t , the agent receives a satellite crop as its current observation o_{t} , generated from the corresponding satellite map through rotate-and-crop operations, as shown in the right panel of Figure 1.”
> - 场景内容（Appendix A.2）：“We use satellite imagery at tile zoom level 19 (approximately 0.3 m per pixel), which is suitable for low-altitude UAV navigation and preserves fine-grained semantic detail.”
> - 场景内容（Appendix A.2）：“The selected scenes span residential, commercial, industrial, park, coastal, riverine, and mixed urban areas. The final benchmark contains 59 scenes across 18 cities; detailed statistics are reported in Table 4.”
> - 场景内容（§3.2）：“Satellite imagery provides real-world top-down visual observations and appearance-based landmark cues, such as red roofs, while OSM provides structured semantic and geometric cues, such as lakes, roads, and waterways.”
> - 场景数（§3.2）：“SatNav currently covers 18 cities and 59 scenes, and can be extended by selecting new geographic regions and applying the same data-generation pipeline.”
> - 面积（Appendix A.2）：“Each scene covers about 14 km2 on average, providing sufficient spatial extent for long-horizon trajectory generation while keeping crop-based observation rendering efficient during training and evaluation.”
> - 面积（Table 5 (Appendix B)）：“CityNav | 4.65 | 2 | 32.6K | 17.80K | 545 | 1 | 4.1K | 0.354 | UAV-ON | 9 | 14 | 11.4K | 648 | 57 | 1 | 2.1K | 0.229 | Ours | 813 | 59 | 118.5K | 44.95K | 379 | 8 | 4.7K | 0.316 |”
> - 地域（§3.4）：“The benchmark contains 118,494 episodes constructed from 59 scenes across 18 cities on five continents.”
> - 地域（Table 4 (Appendix A.2)）：“Amsterdam (EU) | 2 | 6.56 | 6,424 | Minneapolis (NA) | 6 | 11.52 | 10,523 | Auckland (OC) | 1 | 15.17 | 2,391 | New York (NA) | 5 | 16.42 | 10,519 | Berlin (EU) | 5 | 11.58 | 8,942 | Orlando (NA) | 1 | 47.73 | 3,277 |”
> - 室内外（§1）：“SatNav automatically constructs navigation episodes from paired satellite imagery and OpenStreetMap (OSM) annotations, yielding 118K episodes across 18 cities with an average trajectory length of 379 m.”
> - 飞行高度（Appendix A.1）：“This fixed coverage matches the nadir-view setting of a UAV flying at 50\,\mathrm{m} altitude with a 90^{\circ} horizontal field of view.”
> - 飞行高度（Appendix A.1）：“To abstract UAV navigation as planar motion, we fix the observation footprint and remove altitude from the controllable state space.”
> - 飞行高度（Appendix I.4）：“The 50\times 50 m and 200\times 200 m footprints correspond to nominal altitudes of 25 m and 100 m, respectively, under the 90^{\circ} horizontal field of view used in our observation model.”
> - 轨迹长度（§3.4）：“SatNav emphasizes long-horizon navigation, with an average trajectory length of 379 m and a median length of 340 m.”
> - 规模（§3.4）：“The benchmark contains 118,494 episodes constructed from 59 scenes across 18 cities on five continents. At the episode level, Boundary, Landmark, and Route tasks account for 25.5%, 38.1%, and 36.3% of the dataset, respectively.”
> - 规模（§3.4）：“Linguistically, SatNav contains a 4,740-word vocabulary, with an average instruction length of 41 words.”
> - 动作空间（§3.1）：“We use four discrete actions: forward moves the agent 10\,\mathrm{m} along its current heading, left and right rotate the heading by 15^{\circ} , and stop terminates the episode.”
> - 动作空间（§3.1）：“Conditioned on \mathcal{I} , o_{t} , and the navigation history, the agent predicts either a single action a_{t} or an action sequence A_{t} , which is then executed in the satellite-map environment.”
> - 观测（Appendix A.1）：“Within this rotated frame, we sample a square region with side length 100k in Web Mercator meters, corresponding to a true ground footprint of 100\,\mathrm{m}\times 100\,\mathrm{m} .”
> - 观测（Appendix A.1）：“Because the sampling frame is already ego-aligned, the resulting crop has the agent’s forward direction pointing upward in the image. The crop is then resized to 448\times 448 pixels, ensuring a consistent metric scale across different cities and latitudes.”
> - 划分（§3.4）：“The Train split contains 56 scenes across 15 cities and accounts for 88.7% of the total data. Test Seen contains 4,574 episodes generated from three training scenes, but uses newly sampled trajectories and newly constructed instructions”
> - 划分（§3.4）：“Test Unseen contains 8,756 episodes from three previously unseen scenes in three new cities, and is designed to evaluate generalization to unseen geographic environments.”
> - 真机（§5.4）：“We use a DJI Matrice 4D UAV for real-world evaluation. Nadir-view images are transmitted via a video link to a local workstation, where SwiftVLN performs online inference on an NVIDIA RTX 4090 GPU. We construct 18 real-world episodes spanning all three SatNav task families, with six episodes per family.”
> - 真机（Appendix E.5）：“We train our satellite-to-UAV adapter on 24,467 paired UAV-satellite images compiled from DenseUAV [Dai et al., 2024], GTA-UAV [Ji et al., 2025], SUES [Zhu et al., 2023], and UAV-VisLoc [Xu et al., 2024]”
> - 真机（Appendix I.3）：“Table 14: Navigation performance on 94 episodes rendered from real-world 3D assets. SR, SPL, and OS are reported as percentages, and NE in meters.”
> - 复用（§4.1）：“The SwiftVLN framework refactors the training and evaluation pipeline of StreamVLN (Wei et al., 2025) within ms-swift (Zhao et al., 2025) into a flexible and extensible VLN structure.”
> - 复用（§3.3）：“Qwen 3.5 first composes cue-level descriptions into instruction prototypes in three styles: detailed, natural, and concise. To reduce within-style homogeneity, Gemini 3 Flash (Gemini Team, 2024) further rewrites these prototypes for linguistic diversity”
> - 备注（§6）：“First, navigation uses four discrete actions at a fixed altitude. We generate trajectories using these actions and remove paths that require other movements. This favors smooth routes and limits coverage of winding paths.”
> - 备注（§6）：“Third, system latency limits the number of long-duration real-flight trials. Our evaluation on 18 episodes provides preliminary evidence of satellite-to-UAV transfer.”

## AerialDojo-200K

[arXiv 2609.36066](https://arxiv.org/abs/2609.36066) · 2026-09 · [[topics/papers/无人机VLN/2-10_2609.36066_AerialDojo-200K.pdf|PDF]]

- **任务**：目标搜索
- **场景来源**：游戏引擎合成
- **引擎 / 数据来源**：Unreal Engine + ProjectAirSim
- **场景内容**：42 个仿真场景，4 个场景族 21 种场景类型、每类 2 个实例（论文未说明资产来源）；12 名标注员用两个月人工标注 109 个地标、2099 个目标物体、2099 个 object anchor（anchor 由 VLM 预选 3 个候选再人工选定）
- **场景数**：42 个（城市 18、自然 12、基础设施 6、灾害 6）
- **地域**：未给出真实地名；按场景类型：城市（商场、体育场、游乐园、停车场、社区、街区、小巷、工厂、工地）、自然（沙漠、森林、山地、雪原、海岛、海岸）、基础设施（桥梁、铁路走廊、港口）、灾害（地震、洪水、爆炸）
- **轨迹长度**：参考轨迹长度 5–100 m：Base [5,30) m（预算 90 步）、Standard [30,60) m（180 步）、Long-Horizon [60,100) m（300 步）；轨迹总长 4115.313 km
- **规模**：205,732 个任务实例（102,866 SemanticOGS + 102,866 ImageOGS）；Base 79,974 / Standard 82,424 / LH 43,334；覆盖 2,099 个目标、254 个语义类别
- **动作空间**：离散，4-DoF：MoveForward/Left/Right（1、3、5 m）、MoveUp/Down（1、2 m）、TurnLeft/Right（15°）、Stop，共 8 类 16 个离散选择；不含后退
- **观测**：前/左/右/下四路同步 RGB-D（640×640，90° FOV，15 FPS）；无 GPS、外部定位、全局地图；目标描述含物体名、最近地标名、相对地标的八方位方向及语义描述或参考图像
- **划分**：42 个场景分 21 个 ID 与 21 个 OOD（每种场景类型各一个实例）；ID 场景内 80% 任务训练、20% 评测；OOD 场景内 20% 作为适配子集、80% 测试
- **复用**：Unreal Engine、ProjectAirSim；改造 Hybrid A* 到 4-DoF 动作空间生成无碰撞参考轨迹
- **备注**：起点设在某一已标注物体的 anchor 处并朝向旋转 180°（不同于 UAV-ON 的随机起点）；成功 = 无碰撞且在 anchor 3 m 内 Stop；默认机体轴距与碰撞半径 250 mm；任务量在场景间极不均衡（Mall 场景占 28.82%，单场景 190 至 40,214 个）

> [!quote]- 原文依据（27 句）
> - 引擎 / 数据来源（§3.1）：“We build the AerialDojo-200K benchmark using Unreal Engine (Epic Games, 2008) and ProjectAirSim (Microsoft, 2023), enabling AerialOGS across diverse, high-fidelity simulated scenes.”
> - 场景来源（§3.1）：“We build the AerialDojo-200K benchmark using Unreal Engine (Epic Games, 2008) and ProjectAirSim (Microsoft, 2023), enabling AerialOGS across diverse, high-fidelity simulated scenes.”
> - 场景数（Abstract）：“we construct 42 simulation scenes spanning four scene families and 21 scene types, including 18 urban, 12 natural, six infrastructure, and six disaster scenes.”
> - 场景内容（§3.1）：“AerialDojo-200K contains 42 scenes spanning four scene families and 21 scene types, with two instances per type.”
> - 场景内容（§3.1）：“To ensure simulator quality, as shown in Table 2, 12 annotators spent two months manually annotating 109 landmarks, 2099 target objects, and 2099 object anchors across these scenes.”
> - 场景内容（§3.1）：“A vision-language model shortlists three candidate anchors based on visual informativeness and image–name correspondence. Human annotators then select one anchor per object as the spatial reference for task construction and success evaluation.”
> - 地域（§3.1）：“Specifically, the urban family comprises malls, stadiums, amusement parks, parking lots, communities, neighborhoods, alleys, factories, and construction sites; the natural family covers deserts, forests, mountains, snowfields, islands, and coasts;”
> - 地域（§3.1）：“the infrastructure family includes bridges, rail corridors, and harbors; and the disaster family depicts earthquake, flood, and explosion scenes.”
> - 轨迹长度（§4.1）：“Base and Standard tasks have reference lengths of [5,30) m and [30,60) m and action budgets of 90 and 180, respectively.”
> - 轨迹长度（Table 3）：“Setting | L(\tau^{\mathrm{ref}}) | Action budget | Base | [5,30) | 90 | Standard | [30,60) | 180 | Long-Horizon | [60,100) | 300 |”
> - 轨迹长度（§1）：“Each task instance includes a collision-free reference trajectory and corresponding multi-view video recordings, with the trajectories totaling 4115km across the dataset.”
> - 规模（§3.2）：“AerialDojo-200K contains 205,732 task instances, comprising 102,866 SemanticOGS and 102,866 ImageOGS instances across 42 scenes.”
> - 规模（Appendix B）：“AerialDojo-200K contains 79,974 Base, 82,424 Standard, and 43,334 Long-Horizon task instances, representing 38.87%, 40.06%, and 21.06% of the release, respectively.”
> - 规模（§3.2）：“The dataset covers 2,099 target objects across 254 semantic categories and reports a total planning distance of 4115.313 km.”
> - 动作空间（§3.1）：“AerialDojo-200K provides eight action types with discrete motion magnitudes, supporting four-DoF control of the aerial agent’s position and yaw.”
> - 动作空间（§3.1）：“MoveForward, MoveLeft, and MoveRight allow horizontal translations of 1 , 3 , or 5 m, while MoveUp and MoveDown allow vertical translations of 1 or 2 m. The rotational actions, TurnLeft and TurnRight, change the yaw angle by 15^{\circ} in the corresponding direction.”
> - 动作空间（§3.1）：“Together, these eight action types yield 16 discrete action choices, allowing the aerial agent to select movement magnitudes according to local geometry and target proximity. Backward translation is excluded”
> - 观测（§3.1）：“AerialDojo-200K can collect synchronized RGB-D streams from four onboard cameras facing forward, left, right, and downward. Both RGB and depth images have a resolution of 640\times 640 pixels, and each camera has a 90^{\circ} field of view (FOV).”
> - 观测（§3.1）：“All four views are sampled synchronously at 15 frames per second (FPS).”
> - 观测（§3.1）：“The observation interface excludes GPS measurements, external localization signals, and global maps.”
> - 观测（§3.2）：“comprising the target object’s name, the name of its nearest landmark, its direction relative to that landmark, and a target representation provided as either a semantic description or a reference image.”
> - 划分（§3.3）：“AerialDojo-200K divides its 42 scenes into 21 in-distribution (ID) scenes and 21 out-of-distribution (OOD) scenes, with one instance of each scene type in each split. Within ID scenes, 80% of the tasks are used for training and the remaining 20% for in-distribution performance evaluation.”
> - 划分（§3.3）：“Within OOD scenes, 20% of the tasks form an adaptation subset, while the remaining 80% are reserved for testing.”
> - 复用（§3.2）：“We adapt Hybrid A* (Dolgov et al., 2008) to the aerial agent’s four-DoF action space to plan a collision-free reference trajectory from the start pose to the target anchor.”
> - 复用（§3.1）：“We build the AerialDojo-200K benchmark using Unreal Engine (Epic Games, 2008) and ProjectAirSim (Microsoft, 2023), enabling AerialOGS across diverse, high-fidelity simulated scenes.”
> - 备注（§3.2）：“Unlike UAV-ON (Xiao et al., 2025), which randomly initializes the agent’s start pose, we initialize each task instance at the anchor position of a selected object, with the yaw rotated by 180^{\circ} relative to the anchor orientation.”
> - 备注（Appendix B）：“Urban scenes contribute 60.79% of all instances, followed by Natural (24.22%), Infrastructure (9.63%), and Disaster (5.36%). Mall scenes alone contribute 28.82%. Scene-level counts range from 190 in N_Mountain_1 to 40,214 in U_Mall_0.”

## AirGroundVLN

[arXiv 2610.10421](https://arxiv.org/abs/2610.10421) · 2026-10 · [[topics/papers/无人机VLN/2-11_2610.10421_AirGroundVLN.pdf|PDF]]

- **任务**：空地协同
- **场景来源**：游戏引擎合成
- **引擎 / 数据来源**：Unreal Engine + AirSim 接口（兼容 CARLA-Air 接口）
- **场景内容**：19 个 UE 室外场景（论文未说明资产来源）；标注员挑选 955 个目标实例，用 GPT-5.5 基于多视角观测生成目标与周边环境描述
- **场景数**：19 个（17 seen + 2 unseen）
- **地域**：未给出真实地名；城市、城镇、工业区等复杂室外环境
- **室内外**：室外
- **轨迹长度**：UAV 参考轨迹平均 79.0 m，UGV 平均 90.9 m；最大导航预算 200 步
- **规模**：10,281 个空地协同 episode（由 14,697 个候选筛得），955 个目标实例；指令平均 82 词
- **动作空间**：每步分别为 UGV 与 UAV 预测航点并输出终止信号（未注明离散/连续）；UGV 是到达目标的主平台
- **观测**：UGV 与 UAV 各自视觉观测 + 历史；指令含目标类别、外观、周边环境与八方位粗略方向；AG-CoNAV 中 UGV 仅用前视相机（每步 6 角度 360° 扫视做目标核验），UAV 用 RGB-D 融合 BEV 地图；免训练基线输入空地 BEV 观测
- **划分**：train / val-seen / test-seen / test-unseen = 7,538 / 933 / 962 / 848；按环境划分，seen 17 个训练环境，unseen 2 个留出环境（含未见目标）；测试集再分 aerial-visible（77.3%）与 aerial-occluded（22.7%）
- **复用**：AirSim 接口、CARLA-Air 接口兼容；参照 OpenFly 的做法用 A* 生成参考轨迹
- **备注**：UGV 轨迹由标注员给稀疏关键航点再用改进的地表 A* 生成，UAV 轨迹直接 A*；目标按俯视是否可见人工标注；成功阈值 5 m（评测 UGV）；初始 14,697 条中 6,375 条直接通过、3,906 条修正后保留、4,416 条丢弃

> [!quote]- 原文依据（26 句）
> - 引擎 / 数据来源（§3.2）：“The simulation environment is built in Unreal Engine using AirSim (Shah et al., 2017) interfaces for vehicle control and sensing, with CARLA-Air interface compatibility (Zeng et al., 2026).”
> - 场景来源（§3.2）：“AirGroundVLN comprises 19 outdoor scenes in Unreal Engine, covering urban areas, towns, industrial areas, and other complex outdoor environments.”
> - 场景数（§3.2）：“AirGroundVLN comprises 19 outdoor scenes in Unreal Engine, covering urban areas, towns, industrial areas, and other complex outdoor environments.”
> - 地域（§1）：“AirGroundVLN contains 10,281 navigation episodes, 955 target instances, and 19 Unreal Engine environments, covering urban areas, towns, industrial areas, and other complex outdoor environments.”
> - 室内外（§3.2）：“AirGroundVLN comprises 19 outdoor scenes in Unreal Engine, covering urban areas, towns, industrial areas, and other complex outdoor environments.”
> - 场景内容（Appendix B.1）：“For each selected target, we collect target-centric multi-view observations and use GPT-5.5 to generate a concise description of its semantic category and distinctive visual attributes.”
> - 场景内容（§3.2）：“As illustrated in Fig. 2, for each target selected by annotators, we collect multi-view observations to describe its appearance and surrounding environment, and derive a coarse relative direction for each start location.”
> - 轨迹长度（§3.3）：“As shown in Fig. 3 (a), the average length of UAV reference trajectories in AirGroundVLN is 79.0 m , whereas the corresponding UGV trajectories average 90.9 m.”
> - 轨迹长度（Appendix E）：“The maximum navigation budget is set to T_{\max}=200 steps. During navigation, the UGV uses only a front-facing camera.”
> - 规模（§3.3）：“By contrast, AirGroundVLN provides 10{,}281 air–ground collaborative navigation episodes across 19 simulation scenes, covering 955 target instances.”
> - 规模（Appendix B.3）：“Of the 14,697 initially constructed episodes, 6,375 were accepted without modification, 3,906 were retained after correction and re-verification, and 4,416 were discarded, resulting in the final 10,281 episodes.”
> - 规模（§3.3）：“As shown in Fig. 3 (b), navigation instructions in AirGroundVLN average 82 words.”
> - 动作空间（§3.1）：“For AirGroundVLN, the variables u_{t}^{g} and u_{t}^{a} denote the predicted waypoint decisions for the UGV and UAV, respectively, and q_{t}=1 indicates termination of the episode.”
> - 动作空间（§3.1）：“The UGV serves as the primary target-reaching platform, while the UAV provides complementary aerial perception and global spatial context.”
> - 观测（§3.1）：“At navigation step t , the UGV and UAV receive their current visual observations o_{t}^{g} and o_{t}^{a} , together with historical context available at the current step.”
> - 观测（§3.1）：“The instruction describes the target through its semantic category, visual attributes, surrounding environmental context, and coarse relative direction, without prescribing intermediate navigation actions.”
> - 观测（Appendix E）：“During navigation, the UGV uses only a front-facing camera. After executing each step, it performs a 360∘ sweep using 6 camera angles for target verification.”
> - 观测（§4）：“given a goal-oriented instruction, aerial–ground observations, and a UAV-maintained fused BEV map constructed by projecting and fusing sequential UAV RGB-D observations”
> - 观测（Appendix E）：“For the VLM-based training-free baselines, the model receives the goal-oriented instruction together with the current ground and aerial BEV observations and predicts the next UGV and UAV waypoints.”
> - 划分（§3.3）：“AirGroundVLN is divided into train, val-seen, test-seen, and test-unseen splits with 7{,}538 , 933 , 962 , and 848 episodes, respectively, where test-unseen evaluates generalization to unseen environments.”
> - 划分（Appendix A）：“The seen/unseen partition is defined at the environment level. The seen split contains 17 environments used during training, while the unseen split contains 2 held-out environments.”
> - 划分（Appendix C）：“The test episodes are categorized into aerial-visible and aerial-occluded cases, with 77.3% and 22.7% of episodes falling into each category, respectively.”
> - 复用（§3.2）：“The simulation environment is built in Unreal Engine using AirSim (Shah et al., 2017) interfaces for vehicle control and sensing, with CARLA-Air interface compatibility (Zeng et al., 2026).”
> - 复用（§3.2）：“Following prior aerial VLN benchmark construction (Gao et al., 2026), we generate platform-specific reference trajectories using A∗-based planning (Hart et al., 1968).”
> - 备注（§3.2）：“For the UGV, annotators specify sparse key waypoints that respect road topology and traversability, between which a modified surface-based A∗ planner generates the ground trajectory. UAV reference trajectories are generated directly using A∗ from the start pose to the end pose.”
> - 备注（Appendix B.2）：“A target is labeled aerial-visible if it is directly observable from the top-down aerial viewpoint, and aerial-occluded if it is hidden from this viewpoint by roofs, overhangs, tree canopies, or other scene elements.”

## CrossFly

[arXiv 2610.18381](https://arxiv.org/abs/2610.18381) · 2026-10 · [[topics/papers/无人机VLN/1-23_2610.18381_CrossFly.pdf|PDF]]

- **任务**：VLN
- **场景来源**：3DGS 重建
- **引擎 / 数据来源**：NVIDIA Isaac Sim（PhysX 动力学）+ 重建的 3DGS 场景作为视觉环境（另有 mesh 几何）
- **场景内容**：自采场景：用手持三维扫描仪采集多视角 RGB 与点云，重建为 3DGS 与 mesh；包含独立的室内、室外空间及可穿越室内外边界的连通区域
- **场景数**：23（“more than 20”）
- **室内外**：室内外
- **轨迹长度**：多数 100–400 帧；路径距离多数低于 20 m，少数接近 30 m；总飞行 120 km
- **规模**：15,263 条轨迹（15K），3M 帧，160+ 小时；Indoor 23.7% / Outdoor 25.1% / Indoor↔Outdoor 51.2%
- **动作空间**：连续 6-DoF：位置 (x,y,z) 与姿态（roll、pitch、yaw），经低层 PD 控制器执行；另可发出交互指令（如 <Manip>）调用操作策略
- **观测**：第一视角 RGB、6-DoF 飞行状态、夹爪状态、语言指令；CrossFly-Agent 使用初始帧 + 历史帧 + 当前帧
- **划分**：场景级划分：18 个训练场景、5 个 unseen 场景；seen 评测为训练场景中留出的轨迹，unseen 场景的所有轨迹不参与训练
- **真机**：无：基准目前完全在仿真中开发，真机部署与 sim-to-real 留待未来
- **复用**：NVIDIA Isaac Sim；Ego-Planner 生成无碰撞路径；平台为搭载 SO100-ARM 的四旋翼与 hand-like UAV
- **备注**：Indoor↔Outdoor 任务要求经门口/建筑入口跨越室内外边界，作者称该类最难（unseen 最高 SR 9.7%）；轨迹由稀疏航点经 Ego-Planner + PD 跟踪在 UAV 动力学下生成，碰撞或未到达的 rollout 自动剔除；Table 1 中的 Dynamics 指 UAV 动力学而非场景动态物体。

> [!quote]- 原文依据（19 句）
> - 场景来源（§3.2 Scene Collection）：“We reconstruct diverse heterogeneous environments from multi-view RGB images and point clouds captured by a handheld 3D scanner, including 3D Gaussian Splatting (3DGS) scenes and mesh representations”
> - 引擎 / 数据来源（§3.3）：“CrossFly is built on NVIDIA Isaac Sim, which provides physics simulation, collision detection, and closed-loop UAV control. UAV dynamics are simulated with PhysX, and the reconstructed 3D Gaussian Splatting scenes serve as the visual environments for navigation.”
> - 场景内容（§3.2 Scene Collection）：“The collected scenes cover both individual indoor and outdoor spaces as well as connected regions that allow trajectories to transition between the two domains.”
> - 场景内容（§3.2）：“First, tasks are defined through objects, key waypoints, and language instructions in self-collected scenes.”
> - 场景数（Appendix B.1）：“CrossFly contains 23 independently reconstructed scenes and 15,263 trajectories in total. We construct the benchmark split at the scene level, rather than randomly splitting individual trajectories.”
> - 室内外（§1）：“It contains 15K trajectories across more than 20 reconstructed scenes under a unified simulation framework, spanning diverse Indoor, Outdoor, and Indoor \leftrightarrow Outdoor task suites.”
> - 轨迹长度（§3.1）：“most trajectories span 100–400 frames, while trajectory distances are broadly distributed across different ranges, with the majority falling below 20 m and a small number extending to nearly 30 m.”
> - 轨迹长度（§3.1）：“CrossFly contains 15K trajectories with 3M frames, totaling 160+ hours and 120 km of flight.”
> - 规模（§3.1）：“cross-environment trajectories account for the largest portion (51.2%), compared with Indoor (23.7%) and Outdoor (25.1%) trajectories.”
> - 规模（§3.1）：“CrossFly contains 15K trajectories with 3M frames, totaling 160+ hours and 120 km of flight.”
> - 动作空间（§3.3 Action Space）：“We adopt a 6-DoF action space for UAV navigation, consisting of position (x,y,z) and orientation (roll, pitch, and yaw). Motion commands predicted by the agent are executed through a low-level PD controller.”
> - 动作空间（§3.3 Action Space）：“For object-interaction tasks, agents can additionally issue an interaction command to invoke the corresponding manipulation policy after reaching the target.”
> - 观测（§1）：“Each trajectory records synchronized egocentric RGB observations, 6-DoF flight states, language instructions, waypoints, fine-grained subtasks, and interaction-related annotations throughout the trajectory.”
> - 观测（§4.1）：“The planner predicts the subtask from the instruction, gripper state, and visual context comprising the initial frame, three uniformly sampled historical frames, and the current frame.”
> - 划分（Appendix B.1）：“|\mathcal{S}_{\mathrm{train}}|=18 and |\mathcal{S}_{\mathrm{unseen}}|=5 , with 18+5=23 . The split is fixed and shared by all evaluated methods.”
> - 划分（Appendix B.2）：“The seen split consists of held-out evaluation trajectories collected from scenes in \mathcal{S}_{\mathrm{train}} . Although the underlying scenes are represented during training, the evaluation trajectories themselves are excluded from optimization.”
> - 真机（§5 Limitations）：“First, CrossFly is currently developed in simulation environments. While the benchmark incorporates realistic rendering and physics-based UAV dynamics, the simulation-to-real gap caused by sensor noise, aerodynamic disturbances, and hardware constraints remains unexplored.”
> - 复用（§3.2 Trajectory Acquisition）：“Then the Ego-Planner (Zhou et al., 2022) generates a collision-free path between consecutive waypoints, transforming the sparse waypoints into an executable reference trajectory.”
> - 复用（§3.3 UAV Platform）：“Our main benchmark experiments are conducted on two mobile manipulation platforms: a quadrotor equipped with SO100-ARM (Cadene et al., 2024) and a hand-like UAV (Wu et al., 2026b).”
