import serial
from queue import Queue, Empty
from time import sleep
import argparse
from threading import Thread
from dqn import *
from RL import *
from random import choice # 引入随机函数
import numpy as np
import torch
import gym

from ReadDataParser import ReadDataParser, BaseInfo, SensorInfo, VisionSensorInfo, HardwareInfo, SingleSettingInfo, \
    MultiSettingInfo
from CommandConstructor import CommandConstructor
from QueueSignal import QueueSignal


class ThreadLocal:
    """used by thead"""
    latest_cmd: bytearray = None
    q: Queue = None
    s: serial.Serial = None
    t: Thread = None
    exit_queue: Queue = Queue()

    rdp: ReadDataParser = None

    def __init__(self):
        pass

def task_write(thead_local: ThreadLocal):
    """
    serial port write worker thread, this function do the write task in a independent thread.
    this function must run in a independent thread
    :param thead_local: the thread local data object
    """
    print("task_write")
    while True:
        sleep(0.1)
        try:
            # check if exit signal comes from main thread
            if thead_local.exit_queue.get(block=False) is QueueSignal.SHUTDOWN:
                break
        except Empty:
            pass
        try:
            # check if new command comes from CommandConstructor
            d = thead_local.q.get(block=False, timeout=-1)
            if isinstance(d, tuple):
                if d[0] is QueueSignal.CMD and len(d[1]) > 0:
                    thead_local.latest_cmd = d[1]
        except Empty:
            pass
        # send cmd
        # must send multi time to ensure command are sent successfully
        if thead_local.latest_cmd is not None and len(thead_local.latest_cmd) > 0:
            # print("write:", thead_local.latest_cmd)
            thead_local.s.write(thead_local.latest_cmd)
    print("task_write done.")


def task_read(thead_local: ThreadLocal):
    """
    serial port read worker thread, this function do the write task in a independent thread.
    this function must run in a independent thread
    :param thead_local: the thread local data object
    """
    print("task_read\n")
    while True:
        sleep(0.1)
        try:
            # check if exit signal comes from main thread
            if thead_local.exit_queue.get(block=False) is QueueSignal.SHUTDOWN:
                break
        except Empty:
            pass
        # read from serial port
        d = thead_local.s.read(65535)
        # write new data to ReadDataParser
        thead_local.rdp.push(d)
    print("task_read done.")


class SerialThreadCore:
    """
    the core function of serial control , this can run in main thread or a independent thread.
    """

    s: serial.Serial = None
    port: str = None
    thead_local_write: ThreadLocal = None
    thead_local_read: ThreadLocal = None

    def __init__(self, port: str):
        self.port = port
        self.q_write = Queue()
        self.q_read = Queue()
        self.s = serial.Serial(port, baudrate=115200, timeout=0.01)

        self.thead_local_write = ThreadLocal()
        self.thead_local_write.q = self.q_write
        self.thead_local_write.s = self.s
        self.thead_local_write.t = Thread(target=task_write, args=(self.thead_local_write,))

        self.thead_local_read = ThreadLocal()
        self.thead_local_read.q = self.q_read
        self.thead_local_read.s = self.s
        self.thead_local_read.rdp = ReadDataParser(self.thead_local_read.q)
        self.thead_local_read.t = Thread(target=task_read, args=(self.thead_local_read,))

        self.thead_local_write.t.start()
        self.thead_local_read.t.start()

    def shutdown(self):
        """
        this function safely shutdown serial port and the control thread,
         it do all the cleanup task.
        """
        # send exit signal comes to worker thread
        self.thead_local_write.exit_queue.put(QueueSignal.SHUTDOWN)
        self.thead_local_read.exit_queue.put(QueueSignal.SHUTDOWN)
        self.thead_local_write.t.join()
        self.thead_local_read.t.join()
        self.s.close()

    def base_info(self) -> BaseInfo:
        return self.thead_local_read.rdp.get_base_info()

    def sensor_info(self) -> SensorInfo:
        return self.thead_local_read.rdp.get_sensor_info()

    def vision_sensor_info(self) -> VisionSensorInfo:
        return self.thead_local_read.rdp.get_vision_sensor_info()

    def hardware_info(self) -> HardwareInfo:
        return self.thead_local_read.rdp.get_hardware_info()

    def single_setting_info(self) -> SingleSettingInfo:
        return self.thead_local_read.rdp.get_single_setting_info()

    def multi_setting_info(self) -> MultiSettingInfo:
        return self.thead_local_read.rdp.get_multi_setting_info()


class SerialThread(SerialThreadCore):
    """
    this class extends SerialThreadCore, and implements more useful functions
    """

    cc: CommandConstructor = None

    def __init__(self, port: str):
        super().__init__(port)
        self.ss = CommandConstructor(self.thead_local_write.q)

    def send(self) -> CommandConstructor:
        return self.ss



if __name__ == '__main__':
    parser = argparse.ArgumentParser()
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
    args = parser.parse_args()
    model, mode, is_train = args.rl_model, args.mode, True if args.is_train == 1 else False

    if mode not in ('d', 's'):
        raise AttributeError(f'mode must be "d: deterministic" or "s: stochastic", but get mode: "{mode}"')

    dst = 50

    seed = 0
    np.random.seed(seed)


    # 设置网络参数
    env = gym.make("FrozenLake8x8-v1",
       is_slippery=True if mode == 's' else False,
       desc=custom_map_stochastic if mode == 's' else custom_map_deterministic)
    N_ACTIONS = env.action_space.n
    N_STATES = env.observation_space.n

    args = Arguments()
    args.env = env
    args.obs_n = env.observation_space.n
    args.act_n = env.action_space.n

    graph_len = 300 if mode == 'd' else int(1e4)
    if is_train:
        if model =='ddqn':
            net = DDQN(n_states=N_STATES, n_actions=N_ACTIONS)
            rewards = ddqn_train(net, env, mode)
            plt.plot(rewards)
        elif model == 'sarsa':
            args.agent = SARSAAgent(args)
            rewards = sarsa_train(args)
            args.agent.save_Q(mode)
            plt.plot(rewards[:graph_len])
        elif model == 'qlearning':
            args.agent = QLearningAgent(args)
            rewards = q_learning_train(args)
            args.agent.save_Q(mode)
            plt.plot(rewards[:graph_len])
        plt.show()
    else:
        if model =='ddqn':
            net = DDQN(n_states=N_STATES, n_actions=N_ACTIONS)
            net.eval_net = torch.load(f'ddqn_{mode}.pth')
            # net.eval_net = torch.load(f'ddqn_{mode}.pth')
        elif model == 'sarsa':
            args.Q = np.load(f'sarsa_{mode}.npy')
            args.agent = SARSAAgent(args)
            # actions = sarsa_test(args, is_simulation=False)
            choose_action = args.agent.select_action
        elif model == 'qlearning':
            args.Q = np.load(f'qlearning_{mode}.npy')
            args.agent = QLearningAgent(args)
            # actions = q_learning_test(args, is_simulation=False)
            choose_action = args.agent.select_action
    

        # 设置飞机接口参数，并且起飞
        st = SerialThread("COM7")
        st.send().vision_mode(4)
        st.send().takeoff(50)
        #print(st.vision_sensor_info().tag_id)
        sleep(3)

        # 设置模拟参数
        s = env.reset()
        if model =='ddqn':
            s = net.onehot(s)
        s = np.array(s)
        env.render()
        forward_steps = 3 
        right_steps = 3
        left_steps = 0
        back_steps = 0
        while True:
            if model =='ddqn':
                a = net.choose_action(s, istrain=0)   # 动作选择
            else:
                a = choose_action(s, False)
                # 以下用于实机演示时的“冰湖脚滑”模拟，仿真时请注释掉
                # if a == 1:  # a==1 表示无人机向前飞
                #     a = choice([1, 2, 0])  # 无人机在向前，向左，向右中随机选择一个方向
                # elif a == 2:  # a==2 表示无人机向右飞
                #     a = choice([1, 2, 3])
                # elif a == 3:  # a==3 表示无人机向后飞
                #     a = choice([2, 3, 0])
                # elif a == 0:  # a==0 表示无人机向左飞
                #     a = choice([1, 3, 0])
                
                # flag =0
                # if a == 1:
                #     if forward_steps == 0:
                #         flag = 1 # 无人机飞出边界
                #     else:
                #         forward_steps -= 1 
                #         back_steps += 1
                # elif a == 2:
                #     if right_steps == 0:
                #         flag = 1
                #     else:
                #         right_steps -= 1
                #         left_steps += 1
                # elif a == 3:
                #     if back_steps == 0:
                #         flag = 1
                #     else:
                #         back_steps -= 1
                #         forward_steps += 1
                # elif a == 0:
                #     if left_steps == 0:
                #         flag = 1
                #     else:
                #         left_steps -= 1
                #         right_steps += 1
                # if (flag == 0): # 如果无人机没有飞出边界，则跳出循环，执行飞行动作
                #     break


            s_, r, done, info = env.step(a)   # 状态转移

            if model =='ddqn':
                s_ = net.onehot(s_)
            env.render()
            if a == 0:
                st.send().right(dst)
                sleep(3)
            elif a == 1:
                st.send().forward(dst)
                sleep(3)
            elif a == 2:
                st.send().left(dst)
                sleep(3)
            elif a == 3:
                st.send().back(dst)
                sleep(3)

            if done:
                break
            else:
                s = s_


        # 完成后降落
        st.send().land()
        sleep(2)
        st.shutdown()
        sleep(2)
