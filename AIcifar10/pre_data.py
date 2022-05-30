import os
import random
path = 'data/cifar/train/'
#path = 'data/cifar/test/'
# 读取文件夹下所有文件
files = os.listdir(path)
# 读取label.txt内的10个标签
labels = []
with open('data/cifar/labels.txt', 'r') as f:
    for line in f.readlines():
        labels.append(line.strip())
# 创建文件夹
for label in labels:
    if not os.path.exists(label):
        os.mkdir(path + label)
    else:
         continue
count = {'airplane': 0, 'automobile': 0, 'bird': 0, 'cat': 0, 'deer': 0, 'dog': 0, 'frog': 0, 'horse': 0, 'ship': 0, 'truck': 0}
# 将文件夹下的文件分类
for file in files:
    # 获取文件名
    file_name = file.split('.')[0]
    # 获取文件label
    file_label = file_name.split('_')[1]
    count[file_label] += 1
    if count[file_label] <= random.randint(500, 1000):
        # 将文件移动到对应的文件夹
        os.rename(path + file, path +'/'+ file_label + '/' + file)
    else:
        os.remove(path + file)
    
