<h1 align="center">Horse Generation</h1>

<h4 align="center">Comprehensive experiment of artificial intelligence</h4>

### 组员信息

方桂安，20354027，(e-mail: fanggan@mail2.sysu.edu.cn)
刘梦莎，20354091，(e-mail: liumsh6@mail2.sysu.edu.cn)
刘    玥，20354229，(e-mail: liuy2236@mail2.sysu.edu.cn)
罗秋琳，20354095，(e-mail: luoqlin3@mail2.sysu.edu.cn)
马梓玚，20354103，(e-mail: mazy23@mail2.sysu.edu.cn)
唐    迅，20354121，(e-mail: tangx66@mail2.sysu.edu.cn)

### Requirements

1. 64x,python3.8/3.9.
2. CUDA toolkit 11.1.
3. GCC 7.
4. sh setup.sh/pip install -r requirements.txt

### 文件目录

```python
├─Intro.pptx				  #介绍与展示的PowerPoint
├─tf_aae                      #AAE的tensorflow实现
├─VAE                         #VAE的pytorch实现
├─GAN.ipynb                   #所有GAN的pytorch实现与运行结果
├─requirements.txt			  #本次任务运行环境中的包
├─setup.sh					  #配置环境的安装脚本
│
├─result                      #存放用于展示的结果
├─apps
│    └─interpolate_sample.py  #用于生成视频
│
├─fake_horse                  #一千张生成所得马的图片
├─mmgen                       #一个基于 PyTorch 和MMCV的强有力的生成模型工具箱
│  ├─apis
│  ├─core
│  ├─datasets
│  ├─models
│  ├─ops
│  └─utils
├─configs                     #运行stylegan3的配置文件
│  ├─styleganv3
│  │    └─stylegan3.py
│  │
│  └─_base_
│      ├─ default_runtime.py	      #训练配置
│      │
│      ├─datasets
│      │    └─horse.py                #数据处理
│      │
│      └─models
│          └─stylegan
│                └─stylegan3_base.py  #模型搭建
│
└─tools
    ├─ dist_train.sh 				  #训练模型的脚本
    ├─ train.py						  #训练模型的代码
    │
    └─utils
          └─inception_stat.py         #生成用于计算fid的inception模型
```

### 结果展示

#### 部分fake马

<p> <img align="center" src="https://img.enderfga.cn/img/625.png"/></p>

#### 生成训练可视化

<p> <img align="center" src="https://img.enderfga.cn/img/GAN_generate_animation.gif"/></p>

#### 动态结果展示

<p> <img align="center" src="https://img.enderfga.cn/img/lerp.gif"/></p>

### FID一览

![](https://img.enderfga.cn/img/image-20220618194023873.png)

### 代码说明

1. VAE/

2. tf_aae/

3. GAN.ipynb

   前两者为文件夹，存放了模型，配置，数据集，辅助函数等相关py文件，主体为main.py;

   后者为ipynb文件，记录了所有GAN模型的运行结果，并用于计算FID分数。

   上述代码均可以通过修改数据路径来训练或测试。

   
