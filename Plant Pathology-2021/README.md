助教您好，以下是压缩包内文件的解释：

```powershell
    Augmentation.ipynb  ——数据分析与数据增强
    best.ckpt			——训练过程中最好的模型权重
    test.py				——用于计算测试结果
    test_label_pre.csv	——用于适配我的多标签训练
    toy.ipynb			——lenet5，vgg16，resnet50，vit的完整训练和验证，用于了解mindspore
    train.ipynb			——模型代码，训练代码
    作业文档.pdf		 ——实验报告
```

其中test.py是用于协助助教测试实验结果的，如果有需要使用，需要提供测试集路径，方法如下：

```shell
python test.py --path=plant_dataset/test/images
```

test.py与test_label_pre.csv，best.ckpt需要放在同一目录下，使用的是相对路径

运行输出结果为：

```powershell
load success
Test: 
 Accuracy: 90.5%, Avg loss: 0.082346 
```

