# %%
#导入包以及设置随机种子
import numpy as np
import pandas as pd
import random
import matplotlib.pyplot as plt
import torch
import torch.nn as nn

seed = 42
torch.manual_seed(seed)
np.random.seed(seed)
random.seed(seed)
torch.cuda.manual_seed_all(seed)

# %%
# 读取第二列数据
all_data  = pd.read_csv('./data.csv',usecols=[1],header=None)
# 数据可视化
print(all_data.describe())
plt.plot(all_data)

# %%
# 数据预处理
from sklearn.preprocessing import MinMaxScaler
def sliding_windows(data, seq_length):
    x = []
    y = []

    for i in range(len(data)-seq_length):
        _x = data[i:(i+seq_length)]
        _y = data[i+seq_length]
        x.append(_x)
        y.append(_y)
    
    return np.array(x),np.array(y)

sc = MinMaxScaler()
training_data = sc.fit_transform(all_data)

seq_length = 2
x, y = sliding_windows(training_data, seq_length)

#train_size = int(len(y) * 0.67)
#test_size = len(y) - train_size
# 使用143个月的数据训练 不划分训练集和测试集
dataX = torch.Tensor(np.array(x))
dataY = torch.Tensor(np.array(y))

#trainX = torch.Tensor(np.array(x[0:train_size]))
#trainY = torch.Tensor(np.array(y[0:train_size]))

#testX = torch.Tensor(np.array(x[train_size:len(x)]))
#testY = torch.Tensor(np.array(y[train_size:len(y)]))

# %%
# 定义模型
class RNN(nn.Module):
    def __init__(self, rnn_layer, seq_length):
        super(RNN, self).__init__()
        self.rnn = rnn_layer
        if not self.rnn.bidirectional:
            self.num_directions = 1
            self.linear = nn.Linear(self.rnn.hidden_size*seq_length, 1)
        else:
            self.num_directions = 2
            self.linear = nn.Linear(self.rnn.hidden_size*self.num_directions*seq_length, 1)
        
    def forward(self, x, state):
        out, state = self.rnn(x, state)
        output = self.linear(out.reshape(out.size(0), -1))
        return output, state
    
    def begin_state(self, batch_size=1):
        if not isinstance(self.rnn, nn.LSTM):
            return  torch.zeros((self.num_directions * self.rnn.num_layers,
                                 batch_size, self.rnn.hidden_size))
        else:
            return (torch.zeros((
                self.num_directions * self.rnn.num_layers,
                batch_size, self.rnn.hidden_size)),
                    torch.zeros((
                        self.num_directions * self.rnn.num_layers,
                        batch_size, self.rnn.hidden_size)))

# %%
num_epochs = 1000
learning_rate = 0.01

input_size = 1
hidden_size = 2
num_layers = 1
multi_layers = 5


criterion = torch.nn.MSELoss()    # 定义损失函数

# %%
def train_model(model,
               criterion,
               x_train,
               y_train,
               epochs=1000):
    state = model.begin_state(x_train.size(0))

    optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate)
    for epoch in range(epochs):
        
        # put default model grads to zero
        optimizer.zero_grad()
        
        # predict the output
        pred,_ = model(x_train, state)
        
        # calculate the loss 
        error = criterion(pred,y_train)
        
        # backpropagate the error
        error.backward()
        
        # update the model parameters
        optimizer.step()

        
        
        
        if epoch % 100 == 0:
            print('Epoch :{}    Train Loss :{}'.format((epoch+1)/epochs, error.item()))
        # 测试模型
def test_model(model):
        model.eval()
        
        x = []
        for i in range(len(training_data)-seq_length+1):
            x.append(training_data[i:i+seq_length])
        testX = torch.Tensor(np.array(x))
        state = model.begin_state(testX.size(0))
        train_predict,_ = model(testX, state)

        data_predict = train_predict.detach().numpy()
        dataY_plot = dataY.data.numpy()

        data_predict = sc.inverse_transform(data_predict)
        dataY_plot = sc.inverse_transform(dataY_plot)

        # 数据可视化
        plt.plot(dataY_plot)
        # 蓝色是真实值
        plt.plot(data_predict)
        # 橘色是预测值
        plt.suptitle('Flight-passengers Prediction')
        # 增加图例
        plt.legend([ 'Real', 'Pred'])
        plt.show()
        print('第144个月的乘客人数为：%d k'%data_predict[-1])


# %%
#单层GRU
gru = nn.GRU(input_size, hidden_size, num_layers, bidirectional=False, batch_first=True)
gru = RNN(gru, seq_length)
train_model(gru,criterion,dataX,dataY,epochs=num_epochs)
test_model(gru)

# %%
#单层LSTM
lstm = nn.LSTM(input_size, hidden_size, num_layers, bidirectional=False, batch_first=True)
lstm = RNN(lstm, seq_length)
train_model(lstm,criterion,dataX,dataY,epochs=num_epochs)
test_model(lstm)

# %%
#多层LSTM
lstm_multi = nn.LSTM(input_size, hidden_size, multi_layers, bidirectional=False, batch_first=True)
lstm_multi = RNN(lstm_multi, seq_length)
train_model(lstm_multi,criterion,dataX,dataY,epochs=num_epochs)
test_model(lstm_multi)

# %%
#双向LSTM
lstm_bi = nn.LSTM(input_size, hidden_size, num_layers, bidirectional=True, batch_first=True)
lstm_bi = RNN(lstm_bi, seq_length)
train_model(lstm_bi,criterion,dataX,dataY,epochs=num_epochs)
test_model(lstm_bi)

# %%
#多层双向LSTM
lstm_multi_bi = nn.LSTM(input_size, hidden_size, multi_layers, bidirectional=True, batch_first=True)
lstm_multi_bi = RNN(lstm_multi_bi, seq_length)
train_model(lstm_multi_bi,criterion,dataX,dataY,epochs=num_epochs)
test_model(lstm_multi_bi)


