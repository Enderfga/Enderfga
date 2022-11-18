import gym
import numpy as np
from matplotlib import pyplot as plt
from metric import *
is_slip = False
empty_custom_map =['SFFFFFFFFF',
                 'FFFFFFFFFF',
                 'FFFFFFFFFF',
                 'FFFFFFFFFF',
                 'FFFFFFFFFF',
                 'FFFFFFFFFF',
                 'FFFFFFFFFF',
                 'FFFFFFFFFF',
                 'FFFFFFFFFF',
                 'FFFFFFFFFG',
                 ]

custom_map_deterministic = [
                 'SFFFFFFF',
                 'FFHFFFFF',
                 'FHFFFFFF',
                 'FFFHFFFF',
                 'HFFFFFHF',
                 'FFFHFFFF',
                 'FFHFFHFF',
                 'FFFFFFFG',
                 ]

custom_map_stochastic = [
            'SFFF',
            'FFFH',
            'FFFF',
            'HFFG',
            ]

custom_map0 =['SFFF',
            'FHFH',
            'FFFH',
            'HFFG',
            ]

custom_map1 =['SFFFFFFFFF',
            'FFFFFHFFFF',
            'FFFFHFFFFF',
            'FFFHFFFFFF',
            'FFHFFFFFHH',
            'FHFFFFFFFF',
            'FFFFFFFFFF',
            'FFFFFFFFFF',
            'FFFFHFFFFF',
            'FFFFHFFFFG',
            ]

custom_map2 =['SFFHF',
            'HFHFF',
            'HFFFH',
            'HHHFH',
            'HFFFG',
            ]

custom_map3 =['SFFFF',
            'FFFFF',
            'FFFFF',
            'FFFFF',
            'FFFFG',
            ]

custom_map4 =['SFHFFFFF',
            'FFHFFHFF',
            'FFHFFHFF',
            'FFFFFHFF',
            'FFFFFHFG',
            ]

custom_map =['SFFFFFFFFFF',
            'FFFFFFFFFFF',
            'FFHHHFFFFFF',
            'FFFHFFFFFFF',
            'FFHHFFFFFFF',
            'FFFFFFFFHHH',
            'HHHHHHHFFFF',
            'FFFFFFFFFFF',
            'FFFFFHHHFFF',
            'FFFFFFFFFFF',
            'FFFHHFFFFFF',
            'FFFFHFFFFFF',
            'HHHHHFFFFFF',
            'FFFFFFFHHHF',
            'FFFFFFFFFFF',
            'FFFFFFFFHFF',
            'FFFFFFFFHFG',
            ]
class Arguments:
    def __init__(self):
        self.env = None
        self.obs_n = None
        self.act_n = None
        self.agent = None

        # Set your parameters here
        self.episodes = 10000
        self.max_step = 100
        self.lr = 0.05
        self.gamma = 0.9
        self.epsilon = 0.0001


class QLearningAgent:
    def __init__(self, args):
        self.obs_n = args.obs_n
        self.act_n = args.act_n
        self.lr = args.lr
        self.gamma = args.gamma
        self.epsilon = args.epsilon
        try:
            self.Q = args.Q
        except AttributeError:
            self.Q = np.zeros((args.obs_n, args.act_n))

    def select_action(self, obs, if_train=True):
        # Implement your code here
        # ...
        Q_list = self.Q[obs, :]
        maxQ = np.max(Q_list)
        action_list = np.where(Q_list == maxQ)[0]  # maxQ可能对应多个action
        action1 = np.random.choice(action_list)

        if np.random.uniform(0, 1) < (1.0 - self.epsilon):  # 根据table的Q值选动作
            action = action1
        else:
            action = np.random.choice(self.act_n)  # 有一定概率随机探索选取一个动作
        return action

    def update(self, transition):
        obs, action, reward, next_obs, done = transition
        # Implement your code here
        # ...
        predict_Q = self.Q[obs, action]
        if done:
            target_Q = reward  # 没有下一个状态了
        else:
            Q_list = self.Q[next_obs, :]
            maxQ = np.max(Q_list)
            action_list = np.where(Q_list == maxQ)[0]  # maxQ可能对应多个action
            next_action = np.random.choice(action_list)
            target_Q = reward + self.gamma * self.Q[next_obs, next_action]
        self.Q[obs, action] += self.lr * (target_Q - predict_Q)  # 修正q
    
    def save_Q(self, mode):
        np.save(f'qlearning_{mode}.npy', self.Q)


class SARSAAgent:
    def __init__(self, args):
        self.obs_n = args.obs_n
        self.act_n = args.act_n
        self.lr = args.lr
        self.gamma = args.gamma
        self.epsilon = args.epsilon
        try:
            self.Q = args.Q
        except AttributeError:
            self.Q = np.zeros((args.obs_n, args.act_n))

    def select_action(self, obs, if_train=True):
        # Implement your code here
        # ...
        Q_list = self.Q[obs, :]
        maxQ = np.max(Q_list)
        action_list = np.where(Q_list == maxQ)[0]  # maxQ可能对应多个action
        action1 = np.random.choice(action_list)

        if np.random.uniform(0, 1) < (1.0 - self.epsilon):  # 根据table的Q值选动作
            action = action1
        else:
            action = np.random.choice(self.act_n)  # 有一定概率随机探索选取一个动作
        return action

    def update(self, transition):
        obs, action, reward, next_obs, next_action, done = transition
        # Implement your code here
        # ...
        predict_Q = self.Q[obs, action]
        if done:
            target_Q = reward  # 没有下一个状态了
        else:
            target_Q = reward + self.gamma * self.Q[next_obs, next_action]  # Sarsa
        self.Q[obs, action] += self.lr * (target_Q - predict_Q)  # 修正q
    
    def save_Q(self, mode):
        np.save(f'sarsa_{mode}.npy', self.Q)


@run_time
def q_learning_train(args):
    env = args.env
    agent = args.agent
    episodes = args.episodes
    max_step = args.max_step
    rewards = []
    d_obs = 0
    mean_100ep_reward = []
    for episode in range(episodes):
        episode_reward = 0
        # Implement your code here
        # ...
        obs = env.reset()#初始化环境
        for t in range(max_step):
            # Implement your code here
            # ...
            action = agent.select_action(obs)
            next_obs, reward, done, _ = env.step(action)  # 与环境进行一个交互
            '''
            if action == 0:
                d_obs = obs - 1 if obs%(len(custom_map[0]) - 1) > 0 else obs
            if action == 1:
                d_obs = obs + len(custom_map[0]) - 1 if obs < (len(custom_map))*(len(custom_map[0]) - 1) else obs
            if action == 2:
                d_obs = obs + 1 if obs%(len(custom_map[0]) - 1) < (len(custom_map[0]) - 1) else obs
            if action == 3:
                d_obs = obs - (len(custom_map[0]) - 1) if obs > (len(custom_map[0]) - 1) else obs

            if next_obs != d_obs:
                obs = next_obs  # 存储上一个观察值
                continue
            '''
            # 训练算法

            #reward = reward - 1
            if obs == next_obs:
                reward = reward - 1

            transition = obs, action, reward, next_obs, done
            agent.update(transition)
            episode_reward += reward
            if done:
                if reward != 1 and t != max_step-1:
                    transition = obs, action, -100, next_obs, done
                    agent.update(transition)
                    episode_reward += -100
                if reward == 1:
                    transition = obs, action, 10000, next_obs, done
                    agent.update(transition)
                    episode_reward += 10000
                break
            obs = next_obs  # 存储上一个观察值

        if episode % 1000 == 0: #统计奖励部分
            print(f'Episode {episode}\t Step {t}\t Reward {episode_reward}')
        rewards.append(episode_reward)
        if len(rewards) < 100:
            mean_100ep_reward.append(np.mean(rewards))
        else:
            mean_100ep_reward.append(np.mean(rewards[-100:]))
    return mean_100ep_reward

@run_time
def sarsa_train(args):
    env = args.env
    agent = args.agent
    episodes = args.episodes
    max_steps = args.max_step
    rewards = []
    d_obs = 0
    mean_100ep_reward = []
    for episode in range(episodes):
        episode_reward = 0
        # Implement your code here
        # ...
        obs = env.reset()
        action = agent.select_action(obs)
        for t in range(max_steps):
            # Implement your code here
            # ...
            next_obs, reward, done, _ = env.step(action)  # 与环境进行一个交互
            next_act = agent.select_action(next_obs)  # 根据算法选择一个动作

            '''
            if action == 0:
                d_obs = obs - 1 if obs%(len(custom_map[0]) - 1) > 0 else obs
            if action == 1:
                d_obs = obs + len(custom_map[0]) - 1 if obs < (len(custom_map))*(len(custom_map[0]) - 1) else obs
            if action == 2:
                d_obs = obs + 1 if obs%(len(custom_map[0]) - 1) < (len(custom_map[0]) - 1) else obs
            if action == 3:
                d_obs = obs - (len(custom_map[0]) - 1) if obs > (len(custom_map[0]) - 1) else obs
            if next_obs != d_obs:
                obs = next_obs  # 存储上一个观察值
                action = next_act
                continue
            '''

            #reward = reward - 1
            if obs == next_obs:
                reward = reward - 1

            # 训练Sarsa算法
            transition = obs, action, reward, next_obs, next_act, done
            agent.update(transition)

            episode_reward += reward
            if done:
                if reward != 1 and t != max_steps-1:
                    transition = obs, action, -100, next_obs, next_act, done
                    agent.update(transition)
                    episode_reward += -100
                if reward == 1:
                    transition = obs, action, 10000, next_obs, next_act, done
                    agent.update(transition)
                    episode_reward += 10000
                break
            action = next_act
            obs = next_obs  # 存储上一个观察值
        if episode % 1000 == 0:
            print(f'Episode {episode}\t Step {t}\t Reward {episode_reward}')
        rewards.append(episode_reward)
        if len(rewards) < 100:
            mean_100ep_reward.append(np.mean(rewards))
        else:
            mean_100ep_reward.append(np.mean(rewards[-100:]))
    return mean_100ep_reward


def q_learning_test(args):
    # Implement your code here
    # ...
    env = args.env
    agent = args.agent
    done = False
    obs = env.reset()
    env.render()
    plotter = np.ones([len(custom_map), len(custom_map[0])])/2
    actions = []
    while(done == False):
        Q_list = agent.Q[obs, :]
        maxQ = np.max(Q_list)
        action_list = np.where(Q_list == maxQ)[0]  # maxQ可能对应多个action
        action = np.random.choice(action_list)
        actions.append(action)
        obs, reward, done, info = env.step(action)
        print(obs)
        env.render()
    print(actions)
    plt.figure(1)
    for i in range(len(custom_map)):
        for j in range(len(custom_map[0])):
            if custom_map[i][j] == 'H':
                plotter[i][j] = 128
    i = 0
    j = 0
    for act in actions:
        plotter[i][j] = 255
        if act == 0:
            j = j - 1 if j > 0 else 0
        if act == 1:
            i = i + 1 if i < len(custom_map)-1 else len(custom_map)-1
        if act == 2:
            j = j + 1 if j < len(custom_map[0])-1 else len(custom_map[0])-1
        if act == 3:
            i = i - 1 if i > 0 else 0
        plt.imshow(plotter)
        plt.pause(0.2)
    plotter[i][j] = 255
    plt.imshow(plotter)



def _plot_sarsa_test(plotter, actions):
    plt.figure(2)
    for i in range(len(custom_map)):
        for j in range(len(custom_map[0])):
            if custom_map[i][j] == 'H':
                plotter[i][j] = 128
    i = 0
    j = 0
    for act in actions:
        plotter[i][j] = 255
        if act == 0:
            j = j - 1 if j > 0 else 0
        if act == 1:
            i = i + 1 if i < len(custom_map)-1 else len(custom_map)-1
        if act == 2:
            j = j + 1 if j < len(custom_map[0])-1 else len(custom_map[0])-1
        if act == 3:
            i = i - 1 if i > 0 else 0
        plt.imshow(plotter)
        plt.pause(0.2)
    plotter[i][j] = 255
    plt.figure(2)
    plt.imshow(plotter)

def sarsa_test(args, is_simulation=False):
    # Implement your code here
    # ...
    env = args.env
    agent = args.agent
    episodes = args.episodes
    max_steps = args.max_step
    done = False
    obs = env.reset()
    if is_simulation:
        env.render()
        
    plotter = np.ones([len(custom_map), len(custom_map[0])])/2
    actions = []
    while(done == False):
        Q_list = agent.Q[obs, :]
        maxQ = np.max(Q_list)
        action_list = np.where(Q_list == maxQ)[0]  # maxQ可能对应多个action
        action = np.random.choice(action_list)
        actions.append(action)
        obs, reward, done, info = env.step(action)
        
        if is_simulation:
            env.render()

    # _plot_sarsa_test(plotter, actions)

    return actions

def Sarsa_actions():
    sarsa_args = Arguments()
    env = gym.make("FrozenLake-v1", is_slippery=is_slip, desc=custom_map)
    sarsa_args.env = env
    sarsa_args.obs_n = env.observation_space.n
    sarsa_args.act_n = env.action_space.n
    sarsa_args.agent = SARSAAgent(sarsa_args)
    q_learning_rewards = q_learning_train(args)
    actions = sarsa_test(sarsa_args)
    return actions

def QL_actions():
    q_learning_args = Arguments()
    env = gym.make("FrozenLake-v1", is_slippery=is_slip, desc=custom_map)
    q_learning_args.env = env
    q_learning_args.obs_n = env.observation_space.n
    q_learning_args.act_n = env.action_space.n
    q_learning_args.agent = QLearningAgent(q_learning_args)
    sarsa_rewards = sarsa_train(args)
    actions = q_learning_test(q_learning_args)
    return actions


if __name__ == '__main__':
    seed = 0
    np.random.seed(seed)


    args = Arguments()
    env = gym.make("FrozenLake-v1", is_slippery=is_slip, desc=custom_map)
    args.env = env
    args.obs_n = env.observation_space.n
    args.act_n = env.action_space.n
    args.agent = QLearningAgent(args)


    args = Arguments()
    env = gym.make("FrozenLake-v1", is_slippery=is_slip, desc=custom_map)
    args.env = env
    args.obs_n = env.observation_space.n
    args.act_n = env.action_space.n
    args.agent = SARSAAgent(args)

    q_learning_rewards = q_learning_train(args)
    sarsa_rewards = sarsa_train(args)

    q_learning_test(args)
    sarsa_test(args)

    plt.figure(3)
    plt.plot(range(args.episodes), q_learning_rewards, label='Q Learning')
    plt.plot(range(args.episodes), sarsa_rewards, label='SARSA')
    plt.legend()
    plt.show()