

# 1. (简答题) 

### 1.1. 让用户输入自己的年龄和性别，并写入文件“problem1_1.txt”中。 (5 分)

### 1.2. 再次打开“problem1_1.txt”，首先将自己名字拼音作为新的一行写在文件开头，使得原文件内容从第二行开始。然后将当前时间作为新的一行写在文件末尾。(5 分)

### 1.3. 输入下面的一段话并存入一个文本文件中, 将该文件中的每个字母加密后写入到一个新文件, 加密的方法是:将A变成B , B变成C, … Y变成Z , Z变成A ; a变成b, b变成…z变成a , 其他字符不变化。(10 分)

“BEIJING -- More than 161.12 million doses of COVID-19 vaccines had been administered across China as of Friday, the National Health Commission said Saturday.”

```python
#Problem 1.1
data1 = input('Please enter your name and gender:')
#使用with的话，能够减少冗长，还能自动处理上下文环境产生的异常。
with open('problem1_1.txt','w+') as f1:
    f1.write(data1)
```


```python
#Problem 1.2
import time #引入time模块并以常见格式保存当前时间
data2 = time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))
data3 = input('Please enter your name in pinyin:')
with open('problem1_1.txt','r+') as f1:
    content = f1.read()    #保存原有内容
    f1.seek(0,0)           #将游标移到文件开头
    f1.write(data3+'\n'+data1+'\n'+data2)  #将三行数据及换行符写入文件中
```


```python
#Problem 1.3
plaintext = 'BEIJING -- More than 161.12 million doses of COVID-19 vaccines had been administered across China as of Friday, the National Health Commission said Saturday.'
password = []    #创建空列表
for char in plaintext:    #遍历字符串，分情况按要求加到列表末尾
    if (char >= 'A' and char < 'Z') or (char >= 'a' and char < 'z'):
        password.append(chr(ord(char) + 1) )
    elif char == 'Z': password.append('A')
    elif char == 'z': password.append('a')
    else:password.append(char)
with open('plaintext.txt','w') as pl:
    pl.write(plaintext)
with open('password.txt','w') as ps:
    ps.write("".join(password))   #使用join函数将所获得列表转换为字符串再写入
```

![image-20210416111031550](C:\Users\User\AppData\Roaming\Typora\typora-user-images\image-20210416111031550.png)

![image-20210416110930593](C:\Users\User\AppData\Roaming\Typora\typora-user-images\image-20210416110930593.png)

![image-20210416111224132](C:\Users\User\AppData\Roaming\Typora\typora-user-images\image-20210416111224132.png)

![image-20210416111249992](C:\Users\User\AppData\Roaming\Typora\typora-user-images\image-20210416111249992.png)

1.1考察基础的txt文件写入操作，如果没有使用with，应注意open()之后需close();

1.2中时间追加到末尾可以使用‘a’，但无法实现拼音写在开头，原内容放到第二行；故我选择了先读取原有内容，然后将三行数据按顺序写入；

1.3其他字符不变化且Z变成A，z变成a，应该做特殊处理。

# 2. (简答题) 

### 2.1.  

（1）创建一个类People，至少包含共有属性name和city，至少包含共有方法moveto(self, newcity), 表明一个城市的居民可以搬迁至另一个城市，调用该函数会在屏幕上打印“XXX moves to XXX.”。然后还至少包含一个私有方法sort_city表明可以根据城市人口给城市排序。(10 分)

（2）创建8个人的People类实例化对象，并从北京、上海、广州、深圳，4个城市中随机给他们8个人定义目前所在的城市。并把人名和城市写入一个字典中。例如，{‘xiaoming’：‘Shenzhen’，‘xiaohong’：‘Guangzhou’…}。(10 分)

（3）随机抽取4个人，并让他们搬迁至新的居住城市。新的居住城市仍旧从北上广深中随机确定，4个人新的居住城市可以有重复但是必须不同于他们现在居住的城市。(10 分)

（4）将四个城市按照居住人口数从大到小排序，并写入字典中输出。例如，{‘Shenzhen’：4，‘Guangzhou’：3，‘Beijing’：1，‘Shanghai’：0}. (10 分) 

### 2.2

在Problem 2.1. People类的基础之上，再增加一个Teacher的子类（People是Teacher的父类）。Teacher需要增加一个新的私有属性school，表明老师的工作学校，再将方法moveto改为输出去其他学校工作,调用该函数会在屏幕上打印“XXX moves to XX University”。创建4个人的Teacher类实例化对象。(10 分)

```python
#Problem 2.1_(1)
import random
cities = {'Beijing':0,'Shanghai':0,'Guangzhou':0,'Shenzhen':0} #给北上广深4个城市初始化，value值为居住人口 
times = 0
class People:
   '所有人的基类'
   Count = 0  #实例化对象数（即总人数）
   global message  
   message = {}  
 
   def __init__(self, name):  #给对象初始化，并随机分配城市
      self.name = name
      People.Count += 1      
      for c in cities.keys():
        self.city = random.sample(cities.keys(), 1) # 随机一个字典中的key，第二个参数为限制个数
      message[self.name] = self.city[0]
      cities[self.city[0]] += 1 #对应城市人口增加
   
   def displaymessage(self):  #展示该对象姓名与城市
      print("Name : ", self.name,  ", City: ", self.city[0])

   def displaytotal(self):    #展示目前所有信息包括总人数
      print("Total people:%d"%People.Count)
      print(message)

   def moveto(self, newcity):
      cities[self.city[0]] -= 1 #原城市人口减少
      self.city = newcity
      cities[self.city[0]] += 1 #新城市人口增加
      print(self.name,end='')
      print(" moves to ",end='')    
      print(self.city[0])

   def __sort_city(self):    #按照居住人口数降序给4个城市排序
      print(sorted(cities.items(), key = lambda kv:(kv[1], kv[0]),reverse=True)) 
```


```python
#Problem 2.1_(2)
P1 = People("Enderfga")
P1.displaymessage()
P2 = People("xiaoming")
P2.displaymessage()
P3 = People("xiaohong")
P3.displaymessage()
P4 = People("xiaobai")
P4.displaymessage()
P5 = People("xiaohei")
P5.displaymessage()
P6 = People("xiaolv")
P6.displaymessage()
P7 = People("xiaolan")
P7.displaymessage()
P8 = People("xiaozi")
P8.displaymessage()
P8.displaytotal()
P8._People__sort_city()
```

```markdown
Name :  Enderfga , City:  Guangzhou
Name :  xiaoming , City:  Beijing
Name :  xiaohong , City:  Guangzhou
Name :  xiaobai , City:  Shanghai
Name :  xiaohei , City:  Beijing
Name :  xiaolv , City:  Guangzhou
Name :  xiaolan , City:  Shanghai
Name :  xiaozi , City:  Shanghai
Total people:8
{'Enderfga': 'Guangzhou', 'xiaoming': 'Beijing', 'xiaohong': 'Guangzhou', 'xiaobai': 'Shanghai', 'xiaohei': 'Beijing', 'xiaolv': 'Guangzhou', 'xiaolan': 'Shanghai', 'xiaozi': 'Shanghai'}
[('Shanghai', 3), ('Guangzhou', 3), ('Beijing', 2), ('Shenzhen', 0)]
```

```python
#Problem 2.1_(3)
P = [P1,P2,P3,P4,P5,P6,P7,P8]   #构建含有当前8个对象的列表
def ran(city):     #该函数用于判断随机城市是否与原居住城市不同
    temp = random.sample(cities.keys(), 1)
    if temp == city:
        ran(temp)
    else :
        return temp
for obj in random.sample(P, 4): #从中随机抽取4人
    obj.moveto(ran(obj.city))
```

```markdown
xiaoming moves to Shanghai
xiaozi moves to Beijing
xiaolv moves to Shenzhen
xiaohei moves to Guangzhou
```

```python
#Problem 2.1_(4)
P8._People__sort_city()    #再运行一次sort_city，由于第三问中的搬迁，结果与上一次不同
```

```markdown
[('Shanghai', 3), ('Guangzhou', 3), ('Shenzhen', 1), ('Beijing', 1)]
```

```python
#Problem 2.2
class Teacher(People):         #继承People类派生出Teacher类
   def __init__(self, name):  #给对象初始化，并随机分配城市,默认位于SYSU大学
      self.name = name
      self.__school = 'SYSU'
      People.Count += 1      
      for c in cities.keys():
        self.city = random.sample(cities.keys(), 1) # 随机一个字典中的key，第二个参数为限制个数
      message[self.name] = self.city[0]
      cities[self.city[0]] += 1 #对应城市人口增加
   def moveto(self, newschool):  #重写该方法，满足输出去其他学校工作的要求
      self.__school = newschool
      print(self.name,end='')
      print(" moves to ",end='')    
      print(self.__school,end=' ')
      print("University")
T1 = Teacher('A')
T2 = Teacher('B')
T3 = Teacher('C')
T4 = Teacher('D')
T1.moveto('a')
T2.moveto('b')
T3.moveto('c')
T4.moveto('d')
```

```markdown
A moves to a University
B moves to b University
C moves to c University
D moves to d University
```

第二题是本次作业中耗时最长的题目，通过阅读python官方关于类的文档也收获颇丰。

（1）中的两个共有属性可以通过_init_方法来初始化，由于sort_city方法要根据人口排序，所以初始化方法和moveto方法都应该实现人口的增减

（2）题目要求把人名和城市写入一个字典，可以作为整个people类的总体信息写入并展示

（3）这一题我研究了很久如何遍历类的对象，最终采取的是将所有对象存为列表，再从中随机抽取

（4）由于（1）中已经做好充分准备，故此时只需再调用一次sort_city，会发现搬迁后数据发生改变

而对于子类的问题，得益于继承机制，有代码的重用故非常方便，只需要添加新的属性重写原有方法即可。

# 3. (简答题) 

### 3.1 自定义x区间，用plot方法画一元二次函数画y = x2 - 2x + 1的抛物线 (5 分)

### 3.2 在同一张figure中画出3个子图，分别用同一组自定义数据绘制的一个条形图、一个水平方向条形图，一个饼状图。(5 分)

### 3.3 创建一个5x5每行为0到4的矩阵. (5 分)

### 3.4 从一个10x10矩阵中抽取出所有相邻的3x3矩阵(5 分)

### 3.5 创建一个由自定义随机数构成的5列（名为：A,B,C,D,E）、4行的DataFrame，求哪一列的随机数之和最小. (5 分)

### 3.6 创建一个Series，索引为2015年内的周末日期，值为自定义随机数。 (5 分)

```python
import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt  #将本题中所需所有模块导入
```


```python
#Problem 3.1
x = np.arange(-100,100,0.001)  #取点要保证足够细密，否则无法画出光滑的曲线
y = x**2 - 2*x + 1
plt.plot(x,y)
plt.show()
```


![svg](C:\Users\User\Downloads\output_1_0.svg)

```python
#Problem 3.2
data = [28,25,26,27,28,29,30]  #我选取了近7天的平均气温作为自定义数据
x = np.arange(14,21,1)
fig = plt.figure()
subplot = fig.add_subplot(1, 3, 1) # 1表示1行，3表示3列，1表示1行3列中的索引位置1
plt.bar(x,data)
plt.xlabel('date')            #增加相应标签，使图像更加准确美观
plt.ylabel('temperature')
subplot = fig.add_subplot(1, 3, 2) # 1表示1行，3表示3列，2表示1行3列中的索引位置2
plt.barh(x,data)
plt.yticks(x, ['4.14', '4.15', '4.16', '4.17', '4.18','4.19','4.20'])
plt.xlabel('temperature')
subplot = fig.add_subplot(1, 3, 3) # 1表示1行，3表示3列，3表示1行3列中的索引位置3
plt.pie(data,labels=['4.14', '4.15', '4.16', '4.17', '4.18','4.19','4.20'])
plt.show()
```


![svg](C:\Users\User\Downloads\output_2_0.svg)

```python
#Problem 3.3
row = np.linspace(0,4,5,dtype = np.int8)  #0到4的行向量
matrix1 = np.array([[row]*5])             #5个行向量构成矩阵
print(matrix1)
import random                            #或者是生成0到4范围内的5x5随机数矩阵
matrix2 = np.array([[random.randint(0,4) for _ in range(5)] for _ in range(5)])
print(matrix2)
```

    [[[0 1 2 3 4]
      [0 1 2 3 4]
      [0 1 2 3 4]
      [0 1 2 3 4]
      [0 1 2 3 4]]]
    [[3 0 4 2 2]
     [2 2 2 2 2]
     [1 1 0 4 1]
     [1 3 0 4 1]
     [3 2 4 3 2]]



```python
#Problem 3.4
import numpy as np   #生成幻方的代码改写自CSDN

#列表循环向左移offset位
def shift_left(lst, offset):
    return [lst[(i+offset)%len(lst)] for i in range(len(lst))]

#列表循环向右移offset位
def shift_right(lst, offset):
    return [lst[i-offset] for i in range(len(lst))]

#构造奇数阶幻方函数
def magic_of_odd_order(n):
    p = (int)((n-1)/2)

    #创建矩阵1
    initial_lst1 = list(range(p+1,n))+list(range(p+1))
    initial_mat1 = []
    for i in range(n):
        initial_mat1.append(shift_left(initial_lst1, i))
    mat1 = np.array(initial_mat1)

    #创建矩阵2
    initial_lst2 = list(range(p,-1,-1))+list(range(2*p,p,-1))
    initial_mat2 = []
    for i in range(n):
        initial_mat2.append(shift_right(initial_lst2, i))
    mat2 = np.array(initial_mat2)

    #创建矩阵3,即元素全为1的矩阵
    mat3= np.ones((n,n),dtype=np.int)

    #构造幻方
    magic = n*mat2+mat1+mat3
    return magic

#构造4n阶幻方函数
def magic_of_4n_order(n):
    mat = np.array(range(1,n*n+1)).reshape(n,n)
    for i in range((int)(n/4)):
        for j in range((int)(n/4)):
            for k in range(4): #将每个4*4小方块的对角线换成互补元素
                mat[k+4*j][k+4*i] = n*n+1-mat[k+4*j][k+4*i]
                mat[k+4*j][3-k+4*i] = n*n+1-mat[k+4*j][3-k+4*i]

    return mat

#构造4n+2阶幻方函数
def magic_of_4n2_order(n):
    p = (int)(n/2)
    matA = magic_of_odd_order(p)
    matD = matA+p**2
    matB = matD+p**2
    matC = matB+p**2

    #交换矩阵块A与矩阵块C中特定元素的位置
    row = (int)((p-1)/2)
    for i in range(p):
        if i != row:
            for k in range((int)((n-2)/4)):
                matA[i][k],matC[i][k] = matC[i][k],matA[i][k]
        else:
            for k in range((int)((n-2)/4)):
                matA[i][row+k],matC[i][row+k] = matC[i][row+k],matA[i][row+k]

    #交换矩阵块B与矩阵块D中特定元素的位置
    col = (int)((p-1)/2)
    for j in range(col+2-(int)((n-2)/4),col+1):
        for i in range(p):
            matB[i][j],matD[i][j] = matD[i][j],matB[i][j]

    #合并矩阵块A,B,C,D组成幻方
    magic = np.row_stack((np.column_stack((matA,matB)),np.column_stack((matC,matD))))
    return magic

def main():
    order = eval(input('Enter the order of magic square(>=3): '))

    if order%2 ==1:
        magic = magic_of_odd_order(order)
    elif order%4 == 0:
        magic = magic_of_4n_order(order)
    else:
        magic = magic_of_4n2_order(order)
    return magic


matrix = main()    #构造10阶幻方即10x10矩阵
print(matrix)
for j in range(8):        #通过双层循环 将所有3x3的矩阵打印出来
    for i in range(8):
        print(matrix[i:i+3, j:j+3])
        print(matrix[j:j+3, i:i+3])
```

    [[ 89  85   1  22  18  64  60  26  72  68]
     [ 95  86   7   3  24  70  61  32  53  74]
     [ 21  17  88  84   5  71  67  38  59  55]
     [ 77  98  19  15   6  52  73  44  65  56]
     [ 83  79  25  16  12  58  54  50  66  62]
     [ 14  10  76  97  93  39  35  51  47  43]
     [ 20  11  82  78  99  45  36  57  28  49]
     [ 96  92  13   9  80  46  42  63  34  30]
     [  2  23  94  90  81  27  48  69  40  31]
     [  8   4 100  91  87  33  29  75  41  37]]
    [[89 85  1]
     [95 86  7]
     [21 17 88]]
    [[89 85  1]
     [95 86  7]
     [21 17 88]]
    [[95 86  7]
     [21 17 88]
     [77 98 19]]
    [[85  1 22]
     [86  7  3]
     [17 88 84]]
    [[21 17 88]
     [77 98 19]
     [83 79 25]]
    [[ 1 22 18]
     [ 7  3 24]
     [88 84  5]]
    [[77 98 19]
     [83 79 25]
     [14 10 76]]
    [[22 18 64]
     [ 3 24 70]
     [84  5 71]]
    [[83 79 25]
     [14 10 76]
     [20 11 82]]
    [[18 64 60]
     [24 70 61]
     [ 5 71 67]]
    [[14 10 76]
     [20 11 82]
     [96 92 13]]
    [[64 60 26]
     [70 61 32]
     [71 67 38]]
    [[20 11 82]
     [96 92 13]
     [ 2 23 94]]
    [[60 26 72]
     [61 32 53]
     [67 38 59]]
    [[96 92 13]
     [2  23 94]
     [8  4 100]]
    [[26 72 68]
     [32 53 74]
     [38 59 55]]
    [[85  1 22]
     [86  7  3]
     [17 88 84]]
    [[95 86  7]
     [21 17 88]
     [77 98 19]]
    [[86  7  3]
     [17 88 84]
     [98 19 15]]
    [[86  7  3]
     [17 88 84]
     [98 19 15]]
    [[17 88 84]
     [98 19 15]
     [79 25 16]]
    [[ 7  3 24]
     [88 84  5]
     [19 15  6]]
    [[98 19 15]
     [79 25 16]
     [10 76 97]]
    [[ 3 24 70]
     [84  5 71]
     [15  6 52]]
    [[79 25 16]
     [10 76 97]
     [11 82 78]]
    [[24 70 61]
     [ 5 71 67]
     [ 6 52 73]]
    [[10 76 97]
     [11 82 78]
     [92 13  9]]
    [[70 61 32]
     [71 67 38]
     [52 73 44]]
    [[11 82 78]
     [92 13  9]
     [23 94 90]]
    [[61 32 53]
     [67 38 59]
     [73 44 65]]
    [[92  13 9]
     [23  94 90]
     [ 4 100 91]]
    [[32 53 74]
     [38 59 55]
     [44 65 56]]
    [[ 1 22 18]
     [ 7  3 24]
     [88 84  5]]
    [[21 17 88]
     [77 98 19]
     [83 79 25]]
    [[ 7  3 24]
     [88 84  5]
     [19 15  6]]
    [[17 88 84]
     [98 19 15]
     [79 25 16]]
    [[88 84  5]
     [19 15  6]
     [25 16 12]]
    [[88 84  5]
     [19 15  6]
     [25 16 12]]
    [[19 15  6]
     [25 16 12]
     [76 97 93]]
    [[84  5 71]
     [15  6 52]
     [16 12 58]]
    [[25 16 12]
     [76 97 93]
     [82 78 99]]
    [[ 5 71 67]
     [ 6 52 73]
     [12 58 54]]
    [[76 97 93]
     [82 78 99]
     [13  9 80]]
    [[71 67 38]
     [52 73 44]
     [58 54 50]]
    [[82 78 99]
     [13  9 80]
     [94 90 81]]
    [[67 38 59]
     [73 44 65]
     [54 50 66]]
    [[13  9  80]
     [94  90 81]
     [100 91 87]]
    [[38 59 55]
     [44 65 56]
     [50 66 62]]
    [[22 18 64]
     [ 3 24 70]
     [84  5 71]]
    [[77 98 19]
     [83 79 25]
     [14 10 76]]
    [[ 3 24 70]
     [84  5 71]
     [15  6 52]]
    [[98 19 15]
     [79 25 16]
     [10 76 97]]
    [[84  5 71]
     [15  6 52]
     [16 12 58]]
    [[19 15  6]
     [25 16 12]
     [76 97 93]]
    [[15  6 52]
     [16 12 58]
     [97 93 39]]
    [[15  6 52]
     [16 12 58]
     [97 93 39]]
    [[16 12 58]
     [97 93 39]
     [78 99 45]]
    [[ 6 52 73]
     [12 58 54]
     [93 39 35]]
    [[97 93 39]
     [78 99 45]
     [ 9 80 46]]
    [[52 73 44]
     [58 54 50]
     [39 35 51]]
    [[78 99 45]
     [ 9 80 46]
     [90 81 27]]
    [[73 44 65]
     [54 50 66]
     [35 51 47]]
    [[ 9 80 46]
     [90 81 27]
     [91 87 33]]
    [[44 65 56]
     [50 66 62]
     [51 47 43]]
    [[18 64 60]
     [24 70 61]
     [ 5 71 67]]
    [[83 79 25]
     [14 10 76]
     [20 11 82]]
    [[24 70 61]
     [ 5 71 67]
     [ 6 52 73]]
    [[79 25 16]
     [10 76 97]
     [11 82 78]]
    [[ 5 71 67]
     [ 6 52 73]
     [12 58 54]]
    [[25 16 12]
     [76 97 93]
     [82 78 99]]
    [[ 6 52 73]
     [12 58 54]
     [93 39 35]]
    [[16 12 58]
     [97 93 39]
     [78 99 45]]
    [[12 58 54]
     [93 39 35]
     [99 45 36]]
    [[12 58 54]
     [93 39 35]
     [99 45 36]]
    [[93 39 35]
     [99 45 36]
     [80 46 42]]
    [[58 54 50]
     [39 35 51]
     [45 36 57]]
    [[99 45 36]
     [80 46 42]
     [81 27 48]]
    [[54 50 66]
     [35 51 47]
     [36 57 28]]
    [[80 46 42]
     [81 27 48]
     [87 33 29]]
    [[50 66 62]
     [51 47 43]
     [57 28 49]]
    [[64 60 26]
     [70 61 32]
     [71 67 38]]
    [[14 10 76]
     [20 11 82]
     [96 92 13]]
    [[70 61 32]
     [71 67 38]
     [52 73 44]]
    [[10 76 97]
     [11 82 78]
     [92 13  9]]
    [[71 67 38]
     [52 73 44]
     [58 54 50]]
    [[76 97 93]
     [82 78 99]
     [13  9 80]]
    [[52 73 44]
     [58 54 50]
     [39 35 51]]
    [[97 93 39]
     [78 99 45]
     [ 9 80 46]]
    [[58 54 50]
     [39 35 51]
     [45 36 57]]
    [[93 39 35]
     [99 45 36]
     [80 46 42]]
    [[39 35 51]
     [45 36 57]
     [46 42 63]]
    [[39 35 51]
     [45 36 57]
     [46 42 63]]
    [[45 36 57]
     [46 42 63]
     [27 48 69]]
    [[35 51 47]
     [36 57 28]
     [42 63 34]]
    [[46 42 63]
     [27 48 69]
     [33 29 75]]
    [[51 47 43]
     [57 28 49]
     [63 34 30]]
    [[60 26 72]
     [61 32 53]
     [67 38 59]]
    [[20 11 82]
     [96 92 13]
     [ 2 23 94]]
    [[61 32 53]
     [67 38 59]
     [73 44 65]]
    [[11 82 78]
     [92 13  9]
     [23 94 90]]
    [[67 38 59]
     [73 44 65]
     [54 50 66]]
    [[82 78 99]
     [13  9 80]
     [94 90 81]]
    [[73 44 65]
     [54 50 66]
     [35 51 47]]
    [[78 99 45]
     [ 9 80 46]
     [90 81 27]]
    [[54 50 66]
     [35 51 47]
     [36 57 28]]
    [[99 45 36]
     [80 46 42]
     [81 27 48]]
    [[35 51 47]
     [36 57 28]
     [42 63 34]]
    [[45 36 57]
     [46 42 63]
     [27 48 69]]
    [[36 57 28]
     [42 63 34]
     [48 69 40]]
    [[36 57 28]
     [42 63 34]
     [48 69 40]]
    [[42 63 34]
     [48 69 40]
     [29 75 41]]
    [[57 28 49]
     [63 34 30]
     [69 40 31]]
    [[26 72 68]
     [32 53 74]
     [38 59 55]]
    [[96 92 13]
     [2  23 94]
     [8   4 100]]
    [[32 53 74]
     [38 59 55]
     [44 65 56]]
    [[92 13  9]
     [23 94 90]
     [4 100 91]]
    [[38 59 55]
     [44 65 56]
     [50 66 62]]
    [[13  9 80]
     [94 90 81]
     [100 91 87]]
    [[44 65 56]
     [50 66 62]
     [51 47 43]]
    [[ 9 80 46]
     [90 81 27]
     [91 87 33]]
    [[50 66 62]
     [51 47 43]
     [57 28 49]]
    [[80 46 42]
     [81 27 48]
     [87 33 29]]
    [[51 47 43]
     [57 28 49]
     [63 34 30]]
    [[46 42 63]
     [27 48 69]
     [33 29 75]]
    [[57 28 49]
     [63 34 30]
     [69 40 31]]
    [[42 63 34]
     [48 69 40]
     [29 75 41]]
    [[63 34 30]
     [69 40 31]
     [75 41 37]]
    [[63 34 30]
     [69 40 31]
     [75 41 37]]

```python
#Problem 3.5
df = pd.DataFrame(np.random.randn(4, 5), columns=['A', 'B', 'C', 'D', 'E'])   
#生成4*5的随机数DataFrame
print(df)
df.loc['sum'] = df.apply(lambda x: x.sum())                                   
#计算每一列之和并添加为新行
print(df)
df.sort_values(by=['sum'], axis=1, inplace=True)                              
#将DataFrame按照sum这一行的值排序
print(df)                                                                     
#由此可得D列随机数之和最小
```

              A         B         C         D         E
    0  0.418586  1.020164 -0.697526 -1.112230  0.305835
    1 -1.585667  0.426758  0.480073  0.100724  0.106594
    2 -0.382961  0.543760  0.505512  0.220012  0.841195
    3  0.980622 -0.212383 -0.123964  0.085467  0.017518
                A         B         C         D         E
    0    0.418586  1.020164 -0.697526 -1.112230  0.305835
    1   -1.585667  0.426758  0.480073  0.100724  0.106594
    2   -0.382961  0.543760  0.505512  0.220012  0.841195
    3    0.980622 -0.212383 -0.123964  0.085467  0.017518
    sum -0.569421  1.778299  0.164094 -0.706028  1.271143
                D         A         C         E         B
    0   -1.112230  0.418586 -0.697526  0.305835  1.020164
    1    0.100724 -1.585667  0.480073  0.106594  0.426758
    2    0.220012 -0.382961  0.505512  0.841195  0.543760
    3    0.085467  0.980622 -0.123964  0.017518 -0.212383
    sum -0.706028 -0.569421  0.164094  1.271143  1.778299

```python
#Problem 3.6
import datetime    #引入相关模块，为索引的生成做准备
import collections
import random
def week_date_end(year=2015):
    '该函数将2015年所有周日日期写入字典'
    start_date=datetime.datetime.strptime(str(int(year)-1)+'1224','%Y%m%d')  #2015年第一周的起始日期（在14年）
    end_date=datetime.datetime.strptime(str(int(year)+1)+'0107','%Y%m%d')    #2015年最后一周的终末日期（在16年）
    _u=datetime.timedelta(days=1)
    n=0
    week_date={}
    while 1:        
        _time=start_date+n*_u
        y,w=_time.isocalendar()[:2]
        if y==year :
            week_date.setdefault(w,[]).append(_time.strftime('%Y%m%d'))
        n=n+1
        if _time==end_date:
            break
    week_date_end={}     #创建字典，该字典存储所有周日日期
    for i in week_date:
       week_date_end[week_date[i][-1]]=[random.random()]   
    #周日日期为key，随机数为value
    return week_date_end
myvar = pd.Series(week_date_end())                         
#使用 key/value 对象（字典）来创建 Series
print(myvar)
```

    20150104     [0.24248444824366755]
    20150111      [0.5647841144066111]
    20150118     [0.37037651286463513]
    20150125     [0.04755799472520328]
    20150201     [0.48635089874260407]
    20150208     [0.19353606477413843]
    20150215       [0.693002790724669]
    20150222     [0.08919969280866835]
    20150301      [0.3619458506007056]
    20150308      [0.4931453003252909]
    20150315      [0.3836226068430185]
    20150322      [0.6890240651284053]
    20150329      [0.8203201618589786]
    20150405    [0.056225449879661715]
    20150412      [0.6575201448503729]
    20150419      [0.7376193102036451]
    20150426      [0.5128530168630541]
    20150503     [0.14169104723931403]
    20150510      [0.5024360911076023]
    20150517     [0.42307290989331514]
    20150524        [0.67369701420878]
    20150531     [0.37308139109992033]
    20150607      [0.0868590248761909]
    20150614     [0.21560088504684516]
    20150621      [0.7505166289475518]
    20150628      [0.6567972778386599]
    20150705       [0.526661319651762]
    20150712      [0.3282664778890598]
    20150719      [0.5061018526582389]
    20150726     [0.13790987882963013]
    20150802      [0.9422298724624409]
    20150809     [0.33870549427448005]
    20150816     [0.27532355942689224]
    20150823     [0.07161375505129752]
    20150830       [0.750602576384726]
    20150906     [0.20595383038576753]
    20150913     [0.04222131408368812]
    20150920      [0.8280955812145137]
    20150927      [0.6851771517882411]
    20151004     [0.19747882026986874]
    20151011         [0.9476145533319]
    20151018      [0.2236928241865218]
    20151025      [0.6346708087285773]
    20151101      [0.6600045932790531]
    20151108     [0.44414629719659326]
    20151115      [0.4410736786856513]
    20151122      [0.4629316989782172]
    20151129     [0.28158059050244466]
    20151206      [0.4849775290460011]
    20151213      [0.2570404270713269]
    20151220       [0.719348308928033]
    20151227      [0.7288919930945096]
    dtype: object

第三题考察了模块numpy，pandas和matplotlib的使用，3.1,3.2是基础的画图知识，应注意图像的美观清晰，添加相应的title，legend，label等；3.3,3.4是ndarray的使用；3.5,3.6分别考察了DataFrame，Series；这三种数据结构在数据分析中举足轻重，应熟练掌握。