from ddm import Unet, GaussianDiffusion, Trainer
from mindspore import context
context.set_context(mode=context.GRAPH_MODE, device_target="GPU")
path = '/hy-tmp/denoising-diffusion-mindspore-master/cifar10_horse'

model = Unet(
    dim = 32,
    dim_mults = (1, 2, 4, 8)
)

diffusion = GaussianDiffusion(
    model,
    image_size = 32,
    timesteps = 10,             # number of steps
    sampling_timesteps = 5,     # number of sampling timesteps (using ddim for faster inference [see citation for ddim paper])
    loss_type = 'l1'            # L1 or L2
)

trainer = Trainer(
    diffusion,
    path,
    train_batch_size = 1,
    train_lr = 8e-5,
    train_num_steps = 1000,         # total training steps
    gradient_accumulate_every = 2,    # gradient accumulation steps
    ema_decay = 0.995,                # exponential moving average decay
    amp_level = 'O1',                        # turn on mixed precision
)

trainer.train()