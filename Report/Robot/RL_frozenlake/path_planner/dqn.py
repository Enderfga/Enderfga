import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
import gym
import time
import random
from metric import *
# 超参数
BATCH_SIZE = 256
LR = 0.0012                   # 学习率
EPSILON = 0.92              # 随机探索率
GAMMA = 0.9999                 # 折扣因子
TARGET_REPLACE_ITER = 150   # 延迟更新目标网络的步数
MEMORY_CAPACITY = 200      #经验回放池的大小
env = gym.make('FrozenLake8x8-v1', is_slippery=False)
state_size=8#状态空间的边长

env = env.unwrapped
#动作空间
N_ACTIONS = env.action_space.n
#状态空间
N_STATES = env.observation_space.n

ENV_A_SHAPE = 0 if isinstance(env.action_space.sample(), int) else env.action_space.sample().shape



class Net(nn.Module):
    def __init__(self, n_actions, n_states):
        #Q网络结构：256个神经元的单层网络，输入为状态的独热编码，输出为动作
        super(Net, self).__init__()
        self.n_actions = n_actions
        self.n_states = n_states
        self.fc1 = nn.Linear(n_states, 256)
        self.fc1.weight.data.normal_(0, 0.1)
        self.out = nn.Linear(256, n_states)
        self.out.weight.data.normal_(0, 0.1)

    def forward(self, x):
        x = self.fc1(x)
        x = F.relu(x)
        actions_value = self.out(x)
        return actions_value


class DDQN(object):
    def __init__(self, n_actions, n_states):
        #DDQN算法，使用目标网络与值网络两个网络解耦，防止过度估计
        self.eval_net, self.target_net = Net(n_actions, n_states), Net(n_actions, n_states)
        self.n_states = n_states
        self.n_action = n_actions
        #记录补偿用来延迟更新目标网络
        self.learn_step_counter = 0
        #记录经验回放池的容量
        self.memory_counter = 0
        #经验回放池
        self.memory = np.zeros((MEMORY_CAPACITY, self.eval_net.n_states * 2 + 2))
        #Adam优化器
        self.optimizer = torch.optim.Adam(self.eval_net.parameters(), lr=LR)
        #均方损失
        self.loss_func = nn.MSELoss()

    
    def onehot(self, s):#独热编码
        state=np.zeros(self.n_states)
        state[s]=1
        return state

    def choose_action(self, x,istrain=1):
        #动作选择函数
        x = torch.unsqueeze(torch.FloatTensor(x), 0)
        # 贪婪选择动作
        if np.random.randn() < EPSILON or istrain==0:
            actions_value = self.eval_net.forward(x)
            action = torch.max(actions_value, 1)[1].data.numpy()
            action = action[0] if ENV_A_SHAPE == 0 else action.reshape(ENV_A_SHAPE)#返回动作的索引，单个数字
        else:   #随机探索
            action = np.random.randint(0, self.n_action)
            action = action if ENV_A_SHAPE == 0 else action.reshape(ENV_A_SHAPE)
        # 如果action不在0-3之间，说明出错了
        if action not in range(0, 4):
            action = random.randint(0, 3)
        return action

    def store_transition(self, s, a, r, s_):
        #经验回放
        transition = np.hstack((s, [a, r], s_))
        index = self.memory_counter % MEMORY_CAPACITY
        self.memory[index, :] = transition
        self.memory_counter += 1

    def learn(self):
        # 延迟更新目标网络
        if self.learn_step_counter % TARGET_REPLACE_ITER == 0:
            self.target_net.load_state_dict(self.eval_net.state_dict())
        self.learn_step_counter += 1

        # 提取小批量样本
        sample_index = np.random.choice(MEMORY_CAPACITY, BATCH_SIZE)
        b_memory = self.memory[sample_index, :]
        b_s = torch.FloatTensor(b_memory[:, :self.eval_net.n_states])
        b_a = torch.LongTensor(b_memory[:, self.eval_net.n_states:self.eval_net.n_states+1].astype(int))
        b_r = torch.FloatTensor(b_memory[:, self.eval_net.n_states+1:self.eval_net.n_states+2])
        b_s_ = torch.FloatTensor(b_memory[:, -self.eval_net.n_states:])

        # 更新Q网络
        q_eval = self.eval_net(b_s).gather(1, b_a)  # shape (batch, 1)
        q_next = self.target_net(b_s_).detach()     # detach from graph, don't backpropagate
        q_target = b_r + GAMMA * q_next.max(1)[0].view(BATCH_SIZE, 1)   # shape (batch, 1)
        loss = self.loss_func(q_eval, q_target)

        self.optimizer.zero_grad()
        loss.backward()
        self.optimizer.step()

def ddqn_actions(ddqn, env, is_simulation=False):
    s = env.reset()
    s = np.array(s)
    s = ddqn.onehot(s)
    if is_simulation:
        env.render()
    ep_r = 0
    actions = []
    while True:
        #动作选择
        a = ddqn.choose_action(s,istrain=0)
        #状态转移
        s_, r, done, info = env.step(a)

        actions.append(a)

        s_ = ddqn.onehot(s_)
        if is_simulation:
            env.render()
            time.sleep(1)
        
        if done:
            break
        else:
            s = s_
    
    return actions

@run_time
def ddqn_train(dqn, env, mode):
    print('\n累计经验回放池...')
    rewards = []
    for i_episode in range(3000):
        s =  env.reset()
        s=np.array(s)
        s=dqn.onehot(s)
        last_s = None

        ep_r = 0
        step=1
        while True:
            # 动作选择
            a = dqn.choose_action(s)
            # 状态转移
            s_, r, done, info = env.step(a)
            #根据当前点到终点的距离，修改奖励值
            if r == 0 and done != 1:
                x = int(s_ / state_size)
                y = s_ % state_size
                r = 0.1 * ((x + 1) * (y + 1) - step/2) / (state_size * state_size)
            elif r == 1 and done == 1:
                r == 1
            # elif r != 1 and done == 1:
            #     r = -1
            if last_s is not None:
                if all(s_ == last_s):
                    r += -1

           

            s_ = dqn.onehot(s_)
            #放入经验回放池
            dqn.store_transition(s, a, r, s_)

            ep_r += r
            if dqn.memory_counter > MEMORY_CAPACITY:
                #当经验回放池满则可学习
                dqn.learn()
                if done:
                    print('迭代轮数 {:03d} | 步数:{:03d} | 平均奖励值:{:.03f}'.format(i_episode, step, ep_r / step))
                    rewards.append(ep_r / step)

            if done:
                if r != 1:
                    r += -10
                    dqn.store_transition(s, a, r, s_)
                    dqn.learn()
                    ep_r += -10
                if r == 1:
                    r += 100
                    dqn.store_transition(s, a, r, s_)
                    dqn.learn()
                    ep_r += 100
                break
            else:
                last_s = s
                s = s_
                step+=1
    torch.save(dqn.eval_net, f'ddqn_{mode}.pth')
    return rewards
