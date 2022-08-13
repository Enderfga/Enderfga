# 自动驾驶技术基础

## 项目简介

​		拿到GitHub仓库之后我就开始搜索相关资料，代码和苏黎世联邦理工学院自动控制实验室 (IfA)  的MPCC仿真有很大部分重合。但在实际调试之后我发现，老师使用的控制是LQR，车的模型参数是一致的但其他代码基本都是多余的，核心就是slx的仿真文件。

## 模型建立

​		关于高速转向车辆建模，老师在课上有详细的推导过程，这里只展示结果：

$$
\begin{aligned}
{\left[\begin{array}{c}
\dot{X} \\
\dot{Y} \\
\dot{\psi} \\
\dot{v}_{x} \\
\dot{v}_{y} \\
\dot{\omega}
\end{array}\right]=\left[\begin{array}{c}
v_{x} \cos \psi+v_{x} \sin \psi \\
v_{y} \cos \psi-v_{y} \sin \psi \\
\omega\\
\frac{1}{m}\left(F_{x r}+\cos \delta v_{x} \sin \psi\right. \\
\frac{1}{m}\left(F_{y r}+\sin \delta F_{y f}+m v_{y} \omega\right) \\
\frac{1}{I_{z}}\left(l_{f} F_{x f} \sin \delta+\cos \delta F_{y f}-m v_{x} \omega\right) \\
\end{array}\right] } \\
\alpha_{r}=\arctan \left(\frac{v_{y}-l_{r} \omega}{v_{x}}\right) \\
\alpha_{f}=-\delta+\arctan \left(\frac{v_{y}+l_{f} \omega}{v_{x}}\right) \\
F_{y r}=2 D_{r} \sin \left(C_{r} \arctan \left(-\alpha_{r} B_{r}\right)\right) \\
F_{y f}=2 D_{f} \sin \left(C_{f} \arctan \left(-\alpha_{f} B_{f}\right)\right) \\
F_{x r}=F_{x}=\left(C_{m 1}-C_{m 2} v_{x}\right) d-C_{r} N-C_{d} v_{x}^{2} \\
F_{x f}=-C_{r} N-C_{d} v_{x}^{2}
\end{aligned}
$$
​		体现在系统的s-function中如下：

![](https://img.enderfga.cn/img/image-20220713190531313.png)

## 控制仿真

​		简单介绍一下使用到的控制方法：

### LQR

​		最优控制理论主要探讨的是让动力系统以在最小成本来运作，若系统动态可以用一组线性微分方程表示，而其成本为二次泛函，这类的问题称为线性二次（LQ）问题。此类问题的解即为线性二次调节器（英语：linear–quadratic regulator），简称LQR。

​		有无限时间/有限时间，离散时间/连续时间几种类型。思路如下：

- 选择参数矩阵Q,R

- 求解Riccati方程得到矩阵 $P$

- 根据P计算 $K=R^{-1} B^{T} P$

- 计算控制量 $u=-K x$

### PID

​		PID控制器（比例-积分-微分控制器），由比例单元（Proportional）、积分单元（Integral）和微分单元（Derivative）组成。可以透过调整这三个单元的增益$K_P$，$K_I$和$K_D$来调定其特性。PID控制器主要适用于基本上线性，且动态特性不随时间变化的系统。
$$
\mathrm{u}(t)=\mathrm{MV}(t)=K_{p} e(t)+K_{i} \int_{0}^{t} e(\tau) d \tau+K_{d} \frac{d}{d t} e(t)
$$
其中
$K_{p}$ : 比例增益，是调适参数
$K_{i}$ : 积分增益，也是调适参数
$K_{d}$ : 微分增益，也是调适参数
$e$ : 误差 $=$ 设定值 $(\mathrm{SP})-$ 回授值 (PV)
$t$ : 目前时间
$\tau$ : 积分变数，数值从 0 到目前时间 $t$

​		PID的使用非常简单，在simulink中也只是添加一个单输入单输出的单元，本次实验的提升几乎靠的是PID控制。

### MPC

$$
\begin{array}{ll}
\min & \sum_{k=1}^{N}\left[\begin{array}{c}
\hat{e}_{k}^{c} \\
\hat{e}_{k}^{l}
\end{array}\right]^{T}\left[\begin{array}{cc}
q_{c} & 0 \\
0 & q_{l}
\end{array}\right]\left[\begin{array}{c}
\hat{e}_{k}^{c} \\
\hat{e}_{k}^{l}
\end{array}\right]-q_{v} v_{\theta, k}+\Delta u_{k}^{T} R_{\Delta} \Delta u_{k} \\
\text { s.t. } & x_{0}=x(0) \\
& x_{k+1}=f\left(x_{k}, u_{k}\right) \\
& \hat{e}^{c}\left(x_{k}\right)=\sin \left(\Phi^{\mathrm{ref}}\left(\theta_{k}\right)\right)\left(X_{k}-X^{\mathrm{ref}}\left(\theta_{k}\right)\right)-\cos \left(\Phi^{\mathrm{ref}}\left(\theta_{k}\right)\right)\left(Y_{k}-Y^{\mathrm{ref}}\left(\theta_{k}\right)\right) \\
& \hat{e}^{l}\left(x_{k}\right)=-\cos \left(\Phi^{\mathrm{ref}}\left(\theta_{k}\right)\right)\left(X_{k}-X^{\mathrm{ref}}\left(\theta_{k}\right)\right)-\sin \left(\Phi^{\mathrm{ref}}\left(\theta_{k}\right)\right)\left(Y_{k}-Y^{\mathrm{ref}}\left(\theta_{k}\right)\right) \\
& \Delta u_{k}=u_{k}-u_{k-1} \\
& x_{k} \in \mathcal{X}_{\text {Track }} \\
& \underline{x} \leq x_{k} \leq \bar{x} \\
& \underline{u} \leq u_{k} \leq \bar{u} \\
& \Delta u \leq \Delta u_{k} \leq \overline{\Delta u}
\end{array}
$$
$$
\begin{array}{ll}
F_{f, y}=D_{f} \sin \left(C_{f} \arctan \left(B_{f} \alpha_{f}\right)\right) \quad \text { where } & \alpha_{f}=-\arctan \left(\frac{\dot{\varphi} l_{f}+v_{y}}{v_{x}}\right)+\delta \\
F_{r, y}=D_{r} \sin \left(C_{r} \arctan \left(B_{r} \alpha_{r}\right)\right) \quad \text { where } \quad \alpha_{r}=\arctan \left(\frac{\dot{\varphi} l_{r}-v_{y}}{v_{x}}\right) \\
F_{r, x}=\left(C_{m 1}-C_{m 2} v_{x}\right) d-C_{r}-C_{d} v_{x}^{2}
\end{array}
$$
最后，问题的状态和输入结果如下：
$$
\begin{aligned}
&x=\left[X, Y, \varphi, v_{x}, v_{y}, \omega, \theta\right] \\
&u=\left[d, \delta, v_{\theta}\right]
\end{aligned}
$$
​		因为有MPCC的这个仓库作为参考，故这也是我最开始的改进方向，接下来会详细介绍过程与结果。

## 实验过程与结果分析

​		首先我把仓库中的所有代码文件简单浏览了一遍，将vx改到16，时间降低到17.2690s。然后我开始研究如何将MPC控制加入进来。

​		可以选择的方法有两种，一种是根据原理编写m文件，另外一种是利用simulink中的元件。可惜最后实现效果均不理想，我没能将控制成功使用进来，反而是让结果越来越差。

​		于是我就考虑既然IFA的MPCC仿真我可以成功运行，没能从中借鉴到控制的使用，能否将我的已知轨迹放到程序中规划，再将得到的最优轨迹导出，作为我的仿真的引导。

​		程序按照我设想地运行，但是结果很不理想，每次都运行一半车就跑出轨道，几个优化包算出来的结果都是inf，估计与约束有关。

​		不得已我放弃了这种想法，继续在仿真中的PID调参，结果有所提升。其中的某些结果路径比较符合我的期望，结合MPC的滚动优化的思想，我想是否可以将我每次运行的路径保存下来，作为下一次运行的引导线加入仿真中，再结合已有的控制器轨迹追踪，以此来提升效果。

​		可惜结果依旧不理想，最终我放弃了这个想法。这期间我还试着查询了MPC的相关论文，使用python，pytorch，ros等平台来仿真，但原本的控制没有让我从轨迹修改获得提升。不得已只能采取vx，PID的三个增益这4类参数的调优，调试思路总体沿着齐格勒－尼科尔斯方法，不断修改，直至获得最终时间为：12.866s。

![](https://img.enderfga.cn/img/image-20220713202724568.png)

​		默认将小车视为质点，已经放大检查过了，上述结果没有与边界发生碰撞。

​		由于没有使用PID tuner，参数是随机试出来的，且除了$K_i$均为整数。我估计如果愿意从小数点后一点点慢慢调试可能达到更优的结果，但试到这里我觉得再改下去没有什么意义了。本次项目是我目前做到的最“自由”的作业，老师从开学第一节课开始铺垫，我也尝试了卡尔曼滤波，Pure Pursuit，MPC等等方法，即使实力不够没能成功将这些控制实现，但在回忆老师指导内容，查阅资料的过程中也收获了很多乐趣，深刻感受到了控制之美。