# 代码使用指南

## 参数列表

```python
parser.add_argument(
        '--rl_model',
        '-M',
        type=str,
        default='sarsa',
        help='used model(ddqn, sarsa, qlearning)'
    )
    parser.add_argument(
        '--mode',
        '-m',
        type=str,
        default='s',
        help='mode(d: deterministic, s: stochastic)'
    )
    parser.add_argument(
        '--is_train',
        type=int,
        default=0
    )
```

可供选择的算法/模型有ddqn，sarsa和qlearning；

选择deterministic模式会加载实机演示时环境2的8x8地图，

选择stochastic模型则加载4x4地图；

不令is_train=1的话，默认会加载训练好的模型进行仿真测试。

## 使用方法

使用sarsa进行stochastic的4x4地图测试：

```shell
python SerialThread.py -M=sarsa -m=s
```

使用ddqn进行deterministic的8x8地图训练：

```shell
python SerialThread.py -M=ddqn -m=d --is_train=1
```

注意：ddqn虽然可以训练，但是效果并不可观，故压缩包中没有存储ddqn的权重文件。