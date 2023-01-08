### 文件说明

以下是本次作业中编写的代码说明：

```ABAP
├── mmpose       				  #工具箱中有关nyu和awr的代码
│   ├── configs
│   │   ├── _base_
│   │   │   ├── datasets
│   │   │   │   ├── nyu.py
│   │   ├── hand
│   │   │   ├── 3d_kpt_sview_depth_img
│   │   │   │   └── awr
│   │   │   │       └── nyu
│   │   │   │           └── res50_nyu_all_128x128.py
│   ├── mmpose
│   │   ├── core
│   │   │   ├── evaluation
│   │   │   │   └── top_down_eval.py
│   │   ├── datasets
│   │   │   ├── datasets
│   │   │   │   ├── base
│   │   │   │   │   ├── __init__.py
│   │   │   │   │   ├── kpt_3d_sview_depth_img_top_down_dataset.py
│   │   │   │   ├── hand
│   │   │   │   │   ├── __init__.py
│   │   │   │   │   ├── nyuhand_dataset.py
│   │   │   ├── pipelines
│   │   │   │   ├── hand_transform.py
│   │   │   │   └── top_down_transform.py
│   │   ├── models
│   │   │   ├── backbones
│   │   │   │   ├── __init__.py
│   │   │   │   ├── awr_resnet.py
│   │   │   ├── detectors
│   │   │   │   ├── __init__.py
│   │   │   │   ├── depthhand_3d.py
│   │   │   ├── heads
│   │   │   │   ├── __init__.py
│   │   │   │   ├── awr_head.py
│   │   │   ├── losses
│   │   │   │   ├── __init__.py
│   │   │   │   └── regression_loss.py
│   ├── tests
│   │   ├── test_models
│   │   │   ├── test_awr_3d_head.py
│   │   │   ├── test_depthhand_3d_forward.py
├── model.pth                      #resnet50模型权重
└── regression.ipynb			   #回归分析
```

mmpose的官方安装方式如下：

```shell
conda create -n openmmlab python=3.8 pytorch=1.10 cudatoolkit=11.3 torchvision -c pytorch -y
conda activate openmmlab
pip3 install openmim
mim install mmcv-full==1.6.0
# git clone https://github.com/open-mmlab/mmpose.git
cd mmpose
pip3 install -e .
pip install mmtrack mmdet
```

### 测试

可使用以下命令测试数据集

```shell
# 单 GPU 测试
python tools/test.py ${CONFIG_FILE} ${CHECKPOINT_FILE} [--out ${RESULT_FILE}] [--fuse-conv-bn] \
    [--eval ${EVAL_METRICS}] [--gpu_collect] [--tmpdir ${TMPDIR}] [--cfg-options ${CFG_OPTIONS}] \
    [--launcher ${JOB_LAUNCHER}] [--local_rank ${LOCAL_RANK}]

# CPU 测试：禁用 GPU 并运行测试脚本
export CUDA_VISIBLE_DEVICES=-1
python tools/test.py ${CONFIG_FILE} ${CHECKPOINT_FILE} [--out ${RESULT_FILE}] \
    [--eval ${EVAL_METRICS}]
```

可选参数:

- `RESULT_FILE`：输出结果文件名。如果没有被指定，则不会保存测试结果。
- `--fuse-conv-bn`: 是否融合 BN 和 Conv 层。该操作会略微提升模型推理速度。
- `EVAL_METRICS`：测试指标。其可选值与对应数据集相关，如 `mAP`，适用于 COCO 等数据集，`PCK` `AUC` `EPE` 适用于 OneHand10K 等数据集等。
- `--gpu-collect`：如果被指定，姿态估计结果将会通过 GPU 通信进行收集。否则，它将被存储到不同 GPU 上的 `TMPDIR` 文件夹中，并在 rank 0 的进程中被收集。
- `TMPDIR`：用于存储不同进程收集的结果文件的临时文件夹。该变量仅当 `--gpu-collect` 没有被指定时有效。
- `CFG_OPTIONS`：覆盖配置文件中的一些实验设置。比如，可以设置'--cfg-options model.backbone.depth=18 model.backbone.with_cp=True'，在线修改配置文件内容。
- `JOB_LAUNCHER`：分布式任务初始化启动器选项。可选值有 `none`，`pytorch`，`slurm`，`mpi`。特别地，如果被设置为 `none`, 则会以非分布式模式进行测试。
- `LOCAL_RANK`：本地 rank 的 ID。如果没有被指定，则会被设置为 0。

### 训练

```shell
python tools/train.py ${CONFIG_FILE} [optional arguments]
```

使用 CPU 训练的流程和使用单 GPU 训练的流程一致，我们仅需要在训练流程开始前禁用 GPU。

```shell
export CUDA_VISIBLE_DEVICES=-1
```

之后运行单 GPU 训练脚本即可。



上述所有${CONFIG_FILE}均为./configs/hand/3d_kpt_sview_depth_img/awr/nyu/res50_nyu_all_128x128.py
