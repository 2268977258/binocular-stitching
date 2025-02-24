# 基于Ti60F225的双目拼接

第一部分  设计概述

  1.1设计目的
    基于易灵思Ti60F225开发板和MT9M001双目摄像头，充分利用易灵思开发板的低功耗特点，获取双目图像，设计视觉算法，实现双目图像的拼接，并且将双目融合图像实时显示于HDMI显示器上，分辨率为1280*720，帧率尽可能高。同时，设计尽可能利用FPGA并行高速流水线特性， 提高算法的实时性。
    
  1.2应用领域
    双目拼接的匹配算法是计算视觉深度的重要部分，实时的双目拼接算法可以广泛应用于宽视角视频监控、汽车辅助及自动驾驶、VR、AR、无人机影像等诸多细分领域中，起到了增强汽车驾驶和视频监控的安全性，提高VR用户体验，拓宽无人机成像视野等等作用。在数字图像处理的未来发展中占据了重要地位。
    
  1.3主要技术特点
    作品中采用的匹配算法为ORB(Oriented-Fast Rotated-Brief)，小队进行广泛的算法调研，其中包括census、SGBM、SIFT、SURF等算法，为了让算法更适合部署在FPGA上，ORB算法的主要计算可以用位运算表示，与需要大量指数运算与乘除法的SIFT相对友好，适合高速并行流水化计算，提高实时性。
    
  1.4关键性能指标
  
    1.4.1 双目拼接的关键测试指标为拼接处是否有明显异常。
    
    1.4.2为了提高算法实时性，应尽可能提高帧率。
    
  1.5主要创新点
    1.5.1 经研读相关论文与小组讨论后，我们发现相较于其他算法，ORB算法在视频处理的特征点识别与描述上具有速度上的优势。故决定采用ORB算法的FAST和BRIEF算法来完成图像特征点的识别与描述工作。
    
    1.5.2为了尽可能提高计算速度，提升FPGA资源利用率，我们决定采用FAST与BRIEF算法并行计算的方式构建代码。
    图像输入开发板后，在使用FAST计算图像特征点的同时，构建滑动窗口计算图像各个像素点的BRIEF描述符。计算完成后，筛选出特征点的BRIEF描述符与坐标，共同输出到下一步的拼接模块中。
    
    1.5.3采用了优化的裁剪算法，通过将参数变为接口传入裁剪模块，尽管增加了一些开销，但是提高了模块的复用性，并且全程只需做一次裁剪，实际上节省了总开销与总延迟。
    
第二部分  系统组成及功能说明

  2.1整体介绍
 
![image](https://github.com/2268977258/binocular-stitching/blob/main/photo/%E5%9B%BE%E7%89%871.png)
 
  图2.1	系统框架

系统代码框架如上图所示，摄像头采集视频数据后输入开发板，首先同时使用BRIEF算法与FAST算法对两幅图像进行像素描述符生成与特征点的识别，完成后根据BRIEF描述符对两幅图像上的特征点进行暴力匹配，最后通过匹配结果计算拼接参数，完成图像的拼接。

2.2各模块介绍
 
![image](https://github.com/2268977258/binocular-stitching/blob/main/photo/%E5%9B%BE%E7%89%872.png)

图2.2	FAST算法(1)

![image](https://github.com/2268977258/binocular-stitching/blob/main/photo/%E5%9B%BE%E7%89%873.png)

图2.3	FAST算法(2)

FAST算法模块的各个模块如图2.1与2.2所示，首先将初始图像数据和同步信号、时钟信号等输入到FAST_WINDOW_7x7模块中，在该模块中生成一个遍历整个图像的7*7窗口。将这个窗口输出到compare和weight模块中。Compare模块对于窗口中的每个像素，都会选取周围16个点，比对这16个点与目标点的亮度值，如果有连续的12-15个点的亮度都比目标点大或小，那么将目标点视为角点。Weight模块则会计算每个像素的亮度值在整个窗口内的相对大小，并将这个权重值输入到下一模块。
FAST_INFO模块将会把compare模块的角点比对结果和weight模块的亮度权重值结合在一起，整个窗口中的像素点都被分为三种：00，非特征点；01，亮角点；10，暗角点。其中info信号的高2位为角点信息，低位为权重信息。计算结果会进入NMS模块中进行非极大值抑制处理，每个窗口中都会挑出一个info最大的角点保留，并作为特征点输出到下一模块。

![image](https://github.com/2268977258/binocular-stitching/blob/main/photo/%E5%9B%BE%E7%89%874.png)

图2.4	BRIEF算法

如上图，BRIEF算法主要由两个主模块构成，BRIEF_WINDOW31x31模块接收时钟、使能和垂直与水平同步信号，以及图像像素，在模块中生成一个31*31像素的滑动窗口，这个窗口将遍历整个图像，同时将这个窗口中的像素点输出到BRIEF_Descriptor模块中。
BRIEF_Descriptor模块为BRIEF算法的顶层模块，接收到31*31的窗口后，在其中选取256对像素点，比对各对像素点的亮度值大小并用0、1记录，这256位数据与32位的像素坐标信息构成了288位的BRIEF描述符，在延迟一段时间后输出到下一模块。

![image](https://github.com/2268977258/binocular-stitching/blob/main/photo/%E5%9B%BE%E7%89%875.png)

图2.5	暴力匹配算法

暴力匹配算法各模块如上图所示，在BRIEF_Valid_Descriptor模块中，BRIEF算法输出的各个像素点的描述符与FAST模块输出的特征点数据进行比对，保留特征点的BRIEF描述符，其余无关点的描述符清零。结果输出到Descriptor_Buffer中，该模块定义了四个RAM作为分别存储两张图像的描述符信息和坐标信息。
BF_match模块从RAM中分别读取两幅图像各个特征点的BRIEF描述符数据和坐标数据，依次计算各个特征点描述符和另一图像所有特征点描述符的汉明距离，将汉明距离最短的一对点作为匹配结果。
考虑到特征点对形成的向量应几乎平行，基于这个前提下，可以对匹配做优化，即统计大多数匹配点对形成的向量方向主值，对于偏离方向主值的匹配点对则删除。实际上，双目图像应当只在水平坐标上存在不同，因此可以认为方向主值为x方向，将匹配点对中纵坐标误差相对较大的点对删除实现匹配优化。最终将优化后匹配点对的坐标输出。
在最后的视频拼接阶段，我们计算两幅图像特征点的x轴坐标差值，计算其加权平均差值，并根据差值计算裁剪参数，进行剪裁放入FIFO中依次取出实现数据的拼接，并存入DDR，利用lcd_driver模块读取DDR数据并生成HDMI信号显示。
第三部分  完成情况及性能参数
3.1拼接结果
图3 拼接结果显示
应用上述算法后，最终实现的图像拼接效果见图3所示，可以发现在拼接处无明显异常。
3.2帧率测试
帧率测试代码见附录6.6
经检测，帧率为。



第五部分  参考文献
[1]Z. Yao, D. Yu, W. Geng, H. Zhang, Y. Xu and W. Xue, "Research and Implementation of Binocular Image Stitching Algorithm Based on FPGA," 2024 5th International Conference on Computer Vision, Image and Deep Learning (CVIDL), Zhuhai, China, 2024, pp. 248-252, doi: 10.1109/CVIDL62147.2024.10603777. 

[2]T. Zhou, J. Ruan and K. Wang, "Real-time sub-pixel binocular ranging based on FPGA," 2022 International Conference on Advanced Computer Science and Information Systems (ICACSIS), Depok, Indonesia, 2022, pp. 31-38, doi: 10.1109/ICACSIS56558.2022.9923492. 

[3]Z. Chen et al., "Real-Time FPGA-Based Binocular Stereo Vision System with Semi-Global Matching Algorithm," 2021 IEEE 34th International System-on-Chip Conference (SOCC), Las Vegas, NV, USA, 2021, pp. 158-163, doi: 10.1109/SOCC52499.2021.9739626.

[4]E. Rublee, V. Rabaud, K. Konolige and G. Bradski, "ORB: An efficient alternative to SIFT or SURF," 2011 International Conference on Computer Vision, Barcelona, Spain, 2011, pp. 2564-2571, doi: 10.1109/ICCV.2011.6126544.

[5]Qi Ni, Fei Wang, Ziwei Zhao, and Peng Gao. 2019. FPGA-based Binocular Image Feature Extraction and Matching System. In Proceedings of the 2019 4th International Conference on Multimedia Systems and Signal Processing (ICMSSP '19). Association for Computing Machinery, New York, NY, USA, 182–187. 
