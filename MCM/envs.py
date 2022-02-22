from nbformat import read
import pandas as pd
import numpy as np
MAX_GOLD_NUM=2
MIN_GOLD_PRICE=1125.7
MAX_GOLD_PRICE=2061.75
MAX_BIT_NUM=2
MIN_BIT_PRICE=63554.44
MAX_BIT_PRICE=594.08
MAX_DAY=1826
INITIAL_WORTH=1000

def read_data(filepath):
    data = pd.read_csv(filepath)
    data['Date'] = pd.to_datetime(data['Date'])
    return data


class my_env(object):
    action_space = np.array([[-3, 3], [0, 1], [-3, 3], [0, 1]])
    # 动作空间：是否交易黄金，交易多少，是否交易比特币，交易多少
    observation_space = np.array([[0, 1000], [0, MAX_GOLD_NUM], [MIN_GOLD_PRICE, MAX_GOLD_PRICE], [0, MAX_BIT_NUM],[MIN_BIT_PRICE, MAX_BIT_PRICE]])
    # 环境状态空间：当前的美金，黄金的持有数和当日价格，比特币的持有数和当日价格
    def __init__(self):
        self.gold_data = read_data('LBMA-GOLD.csv')
        self.bit_data = read_data('BCHAIN-MKPRU.csv')
        print(self.gold_data)
        #self.cash = 1000
        #self.gold = 0
        #self.bit = 0
        #self.day = 0
        #self.gold_prize = 0
        #self.bit_prize = 0
        #self.acnum = 0
        #self.state = [self.cash, self.gold, self.bit, self.gold_prize, self.bit_prize]

    def seed(self, seed):
        np.random.seed(seed)

    def reset(self):
        self.gold = 0
        self.bit = 0
        self.gold_prize = -1
        self.bit_prize = self.bit_data['Value'][0]
        self.cash = 1000
        self.day = 1
        self.worth = 1000
        #self.acnum = 0
        #self.update_state()

    def take_action(self,action):
        #当天黄金和比特币的价格
        self.bit_prize = self.bit_data['Value'][self.day]
        date = self.bit_data['Date'][self.day]
        if len(self.gold_data[self.gold_data['Date'] == date]):
            self.gold_prize = self.gold_data[self.gold_data['Date'] == date]['USD (PM)'][0]
        else:
            self.gold_prize = -1
        #交易动作和交易量
        action_type_gold = action[0]
        action_amount_gold = action[1]
        action_type_bit = action[2]
        action_amount_bit = action[3]
        #计算资产
        if action_type_gold>1: #买入黄金
            self.cash -= action_amount_gold*self.cash*(1+0.01) #手头美金=原有美金-买黄金的钱-佣金
            self.gold += action_amount_gold*self.cash/self.gold_prize #手头黄金=原有黄金+新买黄金
        if action_type_gold<-1: #卖出黄金
            self.cash += action_amount_gold*self.gold*self.gold_prize*(1-0.01) #手头美金=原有美金+卖黄金的钱-佣金
            self.gold -= action_amount_gold*self.gold #手头黄金=原有黄金-卖出黄金
        if action_type_bit > 1:
            self.cash -= action_amount_bit*self.cash*(1+0.02)
            self.bit += action_amount_bit*self.cash/self.bit_prize
        if action_type_bit < -1:
            self.cash += action_amount_bit*self.bit*self.bit_prize*(1-0.02)
            self.bit -= action_amount_bit*self.bit

    def step(self, action):
        # 当天黄金和比特币的价格
        self.bit_prize = self.bit_data['Value'][self.day]
        date = self.bit_data['Date'][self.day]
        if len(self.gold_data[self.gold_data['Date'] == date]):
            self.gold_prize = self.gold_data[self.gold_data['Date'] == date]['USD (PM)'][0]
        else:
            self.gold_prize = -1
        #在环境内执行动作
        self.take_action(action)
        done = False #done判断是否终止
        self.day+=1
        #在终止日期结束
        if self.day>MAX_DAY:
            done = True
        # 计算资产值。
        self.worth = self.cash + self.gold * self.gold_prize + self.bit * self.bit_prize
        #计算收益和收益比(加强奖励和惩罚)
        profit=self.worth-INITIAL_WORTH
        profit_percent=profit/INITIAL_WORTH
        if profit_percent >= 0:
            reward = max(1, profit_percent / 0.001)
        else:
            reward = -100
        if self.worth <= 0:#当前总价值<0，停止（还不如乱买）
            done = True
        obs = np.array([self.cash,self.gold,self.gold_prize,self.bit,self.bit_prize])
        return obs,reward,done,{}

