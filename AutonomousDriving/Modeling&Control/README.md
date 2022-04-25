---
title: 自动驾驶技术基础之建模与控制
date: 2022-04-25 16:57:56
tags: 自动驾驶
index_img: https://cdn.jsdelivr.net/gh/Enderfga/image1@master/img/clip_image002.png
hide: true
---

自动驾驶技术基础的建模与控制作业

<!-- more -->

概念题（18分）

1. 自动驾驶为了出色地完成驾驶任务，可分为哪四大模块？（4分）

2. 系统建模一般分哪两种建模方式？（2分）

3. 请写出高速转向车辆模型的简化横向误差模型（即四个状态为误差）（4分）

4. 二次型性能指标函数一般包含哪三项优化项？（3分）

5. 线性二次问题三种重要形式分别是？（3分）

6. Kalman Filter（LQE）如何通过LQR求得，请写出matlab关键代码，即：xxx=lqr(xxx) （2分）

 

编程实践题（12分）

![img](https://cdn.jsdelivr.net/gh/Enderfga/image1@master/img/clip_image002.png)

 

给定一个双质系统:  m~1~ =2, m~2~=1, 弹簧系数 k=5, 阻尼σ=0.1, 质量块与地面的滑动阻尼 δ=0.1 (与速度有成正比)。初始时刻 m~1~ 质量块处于 x=0 的位置, 两质量块距离为 0 。现在 m~2~ 处作用一外力 F 拖动系统使 m~1~ 与 m~2~ 质量块均处于 x=5 的位置。

1. 对系统建模（系统可以直接测量两个物体的位置）

2. 判断系统可控性与可观

3. 结合给定的simulink和脚本文件，设计实现上述系统的LQG控制器并绘制闭环控制性能曲线

![img](https://cdn.jsdelivr.net/gh/Enderfga/image1@master/img/clip_image020.jpg)

<embed src="auto1.pdf" width="100%" height="750" type="application/pdf">
