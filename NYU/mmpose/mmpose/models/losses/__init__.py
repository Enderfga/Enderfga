# Copyright (c) OpenMMLab. All rights reserved.
from .classfication_loss import BCELoss
from .heatmap_loss import AdaptiveWingLoss
from .mesh_loss import GANLoss, MeshLoss
from .mse_loss import JointsMSELoss, JointsOHKMMSELoss
from .multi_loss_factory import AELoss, HeatmapLoss, MultiLossFactory
from .regression_loss import (AWRSmoothL1Loss, BoneLoss, L1Loss, MPJPELoss,
                              MSELoss, RLELoss, SemiSupervisionLoss,
                              SmoothL1Loss, SoftWingLoss, WingLoss)

__all__ = [
    'JointsMSELoss', 'JointsOHKMMSELoss', 'HeatmapLoss', 'AELoss',
    'MultiLossFactory', 'MeshLoss', 'GANLoss', 'SmoothL1Loss', 'WingLoss',
    'MPJPELoss', 'MSELoss', 'L1Loss', 'BCELoss', 'BoneLoss',
    'SemiSupervisionLoss', 'SoftWingLoss', 'AdaptiveWingLoss', 'RLELoss',
    'AWRSmoothL1Loss'
]
