```python
├── data/
│   ├── cifar/
│   	├── test/
│   	├── train/
│   	└── labels.txt
├── models/
│   ├── clip_grad.pth
│   ├── crop_flip.pth
│   ├── cutmix.pth
│   ├── cutout.pth
│   ├── weight_decay.pth
│   ├── mixup.pth
│   ├── resnet34_bn.pth
│   └── resnet34_gn.pth
│   └── ······
├──	best_model.pth				  #用于main的所得最优模型
├── pre_data.py					  #数据处理
├── extension.ipynb				  #拓展与延伸
├── torch.ipynb                   #pytorch实现及结果
├── tensorflow.zip        		  #tensorflow实现
├── Report.pdf 					  #实验报告
├── main.py                       #可执行程序
├── requirements.txt              #依赖包及环境
├── MixMatch-pytorch-master.zip   #我们修改过的MixMatch
├── README.md
```

其中models文件夹保存了每次实验的模型，由于体积较大，特地分开打包。

data文件夹是老师发下来的压缩包解压出来的内容，但后续实验使用了pre_data.py来自由决定训练图片数量。

助教老师可以修改main.py中cifar10的路径，然后运行查验效果。

除了报告外，ipynb文件也记录了全部运行过程，可供检阅。

# 分工与评分

全体组员都参与了每次会议，讨论了作业的思路、方向、方法；

由刘梦莎，刘玥，罗秋琳，唐迅进行相关文献的调研与报告的撰写；

由方桂安负责pytorch部分的实现，由马梓玚负责tensorflow部分的实现；

方桂安：10分

马梓玚：10分

刘梦莎：10分

刘    玥：10分

罗秋琳：10分

唐    迅：10分