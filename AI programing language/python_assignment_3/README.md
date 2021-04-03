# Problem 1 (15 分)

### Problem 1.1. 请随机生成2个整数，若这两个数不一致则输出他们的和；若两个数一致则输出他们的和的平方。(5 分)

例如，sum_double(1, 2) → 3   sum_double(3, 2) → 5   sum_double(2, 2) → 16

### Problem 1.2. 若用户输入一个字符串ABCD，要输出AABABCABCD。(5 分)

例如，string_splosion('Code') → 'CCoCodCode'   string_splosion('abc') → 'aababc'   string_splosion('ab') → 'aab'

### Problem 1.3. 计算一个用户输入的长度不小于10字符串中含有的不同字符的个数。字符在ACSII码范围内(0~127)。不在范围内的不作统计。(5 分)

例如，input_str = ‘hello world’,则字符‘h’ → 1； ‘e’ → 1；‘l’ → 3；‘o’ → 2；‘w’ → 1；‘r’ → 1；‘d’ → 1.

```python
#Problem 1.1
import random                           #引入python标准库中的random模块
num1 = random.randint(0,100)            #生成[0,100)中的随机整数num1和num2
num2 = random.randint(0,100)
print(num1,num2)
if num1 == num2 :                       #进行判断，若相等输出和的平方，若不等输出和
    print((num1 + num2) ** 2)
else :
    print(num1 + num2)
```

```python
#Problem 1.2
str = input("please enter a strin:")      #让用户输入一个字符串
for i in range(0,len(str) + 1):            #循环打印前i位字符，注意range为左闭右开，故长度length需要加1
    print(str[0:i],end = '')               #将print默认的属性 end='\n' 改为 end=''，使其不换行连续打印
```


```python
#Problem 1.3
def scanf():     #编写函数scanf，确保输入的字符串长度符合要求
    global str   #声明全局变量str
    str = input('Please enter a string of length not less than 10:')   
    if len(str) < 10:
        print("Warning! The length of string is less than 10,please enter again.")
        scanf()     #若长度小于10，重新调用函数
scanf()
count = []          #创建空列表
for i in range(0,len(str)):
    if ord(str[i]) >= 0 & ord(str[i]) <= 127:
        count.append(str[i]) #将ASCII码0~127的字符加入待计数列表count中
from collections import Counter  
print(Counter(count))
#容器Counter将元素被作为字典的key存储，它们的计数作为字典的value存储
```

在1.3中除了上述方法还可以直接创建空字典

```python
count = {}
for i in str:
    count[i]=str.count(i)
print(count)
```

另外在测试过程中我发现，键盘上能输入的字符都有对应的ASCII码，都在范围0~127内。

# Problem 2 (20 分)

### Problem 2.1. 给定两个整数序列list1和list2。若他们的第一个元素或者最后一个元素相同则返回真，否则返回假。(5 分)

例如，common_end([1, 2, 3], [7, 3]) → True   common_end([1, 2, 3], [7, 3, 2]) → False common_end([1, 2, 3], [1, 3]) → True

### Problem 2.2. 输入一个有15位数字的整数，按照从右向左的阅读顺序，返回一个不含重复数字的新的整数。(5 分)

例如，input_int = 1234566, output_int = 654321

### Problem 2.3. 判断101-200之间有多少个素数，并输出所有素数。（提示：你可能会用到math或cmath模块）。(10 分)

```python
#Problem 2.1
list1 = input("请输入一个整数列表1，以空格分割").split()
list2 = input("请输入一个整数列表2，以空格分割").split() 
#split函数默认以空格为分割符
if list1[0] == list2[0] or list1[-1] == list2[-1] :  
    #list[-1]即取最后一个元素
    print('True')
else :
    print('False')
```

```python
#Problem 2.2
num1 = input("请输入一个有15位数字的整数:")
from collections import OrderedDict  
#引入collections模块中子类OrderedDict
str="".join(OrderedDict.fromkeys(num1)) #将重复元素去除
print(str[::-1])                        #反序输出
```

```python
#Problem 2.3
import math
count = 0 #记录素数个数
prime = [] #存储素数
for i in range(101,201):
    for num in range(2, int(math.sqrt(i))+1):
        if i % num == 0:
            break
    else:
        prime.append(i)
        count += 1
print(" There are %d prime numbers:" % count)
print(prime)
```

     There are 21 prime numbers:
    [101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199]

在2.2中如果使用set可以将重复的元素去除，但顺序会打乱，最终我选择了有序字典OrderedDict

既可以保持原有顺序，又能去除重复元素，最终再反序输出即可完成要求。

# Problem 3 (10 分)

### 已知一个字典为dict = {‘student’: [{‘Rita’: ‘female’, ‘Peter’: ‘male’, ‘Simon’: ‘male’, ‘Lily’: female, ‘Jack’: ‘male’}]}.

### Problem 3.1 请输出给定字典中男生、女生各自的人数。(5 分)

### Problem 3.2 请打印男生的人名打印出来。(5 分)

```python
#Problem 3.1
dict = {'student':[{'Rita':'female','Peter':'male','Simon':'male','Lily':'female','Jack':'male'}]}   #将题目所给信息完整输入
list = dict['student']  #将key：student的value存储为列表，便于后续操作
dict1 = list[0]          #list中只有一个元素，作为字典取出
mcount = 0 #记录男生人数
fcount = 0 #记录女生人数
for value in dict1.values():    #遍历字典中value值，给男女生计数
    if value == 'female' :
        fcount += 1
    else :
        mcount += 1
print('Number of girls is %d'%fcount)
print('Number of boys is %d'%mcount)
```

    Number of girls is 2
    Number of boys is 3

```python
#Problem 3.2
for key,value in dict1.items(): #遍历字典中key和value值
    if value == 'male' :        #若为男生，打印姓名；否则跳出当前循环
        print(key)
    else :
        continue
```

    Peter
    Simon
    Jack

由于题目不是直接给字典{‘Rita’: ‘female’, ‘Peter’: ‘male’, ‘Simon’: ‘male’, ‘Lily’: female, ‘Jack’: ‘male’}

所以做题时得格外注重数据类型，可以多次使用type函数，确定好类型再做下一步判断；

并且要熟练掌握list，dict，string几种类型的相互转换。

# Problem 4 (35 分)

### Problem 4.1. 编写一个函数calculate, 可以接收任意多个数,返回的是一个元组. 元组的第一个值为所有参数的平均值, 第二个值是大于平均值的所有数之和. （10 分）

### Problem 4.2. 编写一个函数, 接收字符串参数, 返回一个元组, 元组的第一个值为大写字母的个数, 第二个值为小写字母个数. （10 分）

例如输入：'hello WORLD'    输出：（5，5）。

### Problem 4.3. 【模拟抽奖游戏】奖项分为: 一等奖, 二等奖和三等奖; 抽奖是随机的,

如果抽奖得到的数值范围在[0,0.08)之间,代表1等奖,

如果抽奖得到的数值范围在[0.08,0.3)之间,代表2等奖,

如果抽奖得到的数值范围在[0.3, 1.0)之间,代表3等奖,  

模拟本次活动50人参加, 模拟游戏时需要准备各等级奖品的个数.（15 分）

```python
#Problem 4.1
import numpy as np    #导入numpy包并简写为np
def calculate(arr):   #编写函数：传入列表参数，返回元组
    m = np.mean(arr)
    sum = 0           #将大于平均数的元素求和
    for i in range(0,n):
        if arr[i] > m:
            sum += arr[i]
    tub = (m,sum)
    return tub 
n = int(input("How many numbers are you going to enter:"))
arr = []         #创建空列表，并存入n个数
for i in range(0,n):
    arr.append(int(input()))
print(type(calculate(arr)),":",calculate(arr))

```

```python
#Problem 4.2
def count(str):  #U为大写字母个数，L为小写字母个数
    U = L = 0
    for char in str:    #遍历字符串所有元素，利用“与”来判断大小写
        if char >= 'A' and char <= 'Z':
            U += 1
        elif char >= 'a' and char <= 'z':
            L += 1
        else :
            continue    #如果是非字母类字符，跳出当前循环且不计数
    tub = (U,L)
    return tub
str = input("Please enter a string:")
print(type(count(str)),":",count(str))
```

```python
#Problem 4.3
import random
n1 = n2 = n3 = 0            #给记录中奖次数的n赋初值
def game(times):
    global n1,n2,n3         #声明n为全局变量
    for i in range(0,times):
        n = random.random() #随机生成[0,1)的浮点数
        if n < 0.08:        #[0,0.08)之间为一等奖
            #print("Congratulations, first prize!")
            n1 += 1
        elif n < 0.3:       #[0.08,0.3)之间为二等奖
            #print("Congratulations, second prize!")
            n2 += 1
        else :              #[0.3,1)之间为三等奖
            #print("Congratulations, third prize!")
            n3 += 1
game(50)    #模拟本次活动50人参加
print('first prize:%d'%n1,'second prize:%d'%n2,'third prize:%d'%n3)

```

    first prize:4 second prize:11 third prize:35

完成4.2过程中一直调试不成功，原来&指的是位运算，and指的是逻辑运算，使用时需区分；

4.3中虽然运行了抽奖函数50次，但是每次得到的n差异较大；只有试验次数足够多时，结果才能不断趋近理论值：4,11,35；故准备各等级奖品应按此个数。

# Problem 5 (20 分)

### 【模拟微信显示发消息的时间】

如果发消息的时间与某一个指定的时间，时间差大于1年，显示X年X月；如果时间差大于1个月且小于1年，显示X月X日；如果时间差大于1天且小于1个月，显示x天前，如果时间差大于1个小时且小于1天，显示x小时前；如果时间差大于1分钟且小于1个小时，显示x分钟前，如果时间差大于1秒且小于1分钟，显示x秒前。请编写代码实现以上功能，并对于每一种情况都进行测试。

```python
import time     #引入time模块

#模拟微信显示发消息的时间，通过差值来决定显示方式
#time_start为上一条消息发送时间，time_end为当前消息发送时间
def wechat_diff(time_start, time_end, fmt="%Y-%m-%d %H:%M:%S"):
    #匿名函数将两个参数转变为时间戳
    stamp_func = lambda t: time.mktime(time.strptime(t, fmt)) 
    t1 = stamp_func(time_end)
    t2 = stamp_func(time_start)
    t = t1 - t2
    diff = time.gmtime(t)       #相差时间的时间元组
    send = time.localtime(t1)   #发送时间的时间元组
    if t >= 31556736:
        print(time.strftime("%Y-%m", send))
    elif t >= 2629743:
        print(time.strftime("%m-%d", send))
    elif t >= 86400:
        print(time.strftime("%d days ago", diff))
    elif t >= 3600:
        print(time.strftime("%H hours ago", diff))
    elif t >= 60:
        print(time.strftime("%M minutes ago", diff))
    elif t >= 1:
        print(time.strftime("%S seconds ago", diff))

#分七种情况显示发消息的时间
wechat_diff('2018-6-1 9:26:32', '2020-4-1 8:30:00')#时间差大于1年
wechat_diff('2019-6-1 9:26:32', '2020-4-1 8:30:00')#时间差大于1个月
wechat_diff('2020-3-29 9:26:32', '2020-4-1 8:30:00')#时间差大于1天
wechat_diff('2020-4-1 7:26:32', '2020-4-1 8:30:00')#时间差大于1个小时
wechat_diff('2020-4-1 8:26:32', '2020-4-1 8:30:00')#时间差大于1分钟
wechat_diff('2020-4-1 8:29:32', '2020-4-1 8:30:00')#时间差大于1秒
wechat_diff('2020-4-1 8:30:00', '2020-4-1 8:30:00')
#第七种即时间差小于1秒的情况，模拟微信两条消息时间间隔短时中间不显示时间
```

    2020-04
    04-01
    03 days ago
    01 hours ago
    03 minutes ago
    28 seconds ago

为了显示出正确的差值，值得注意的地方是：

相差时间的时间元组是用time.gmtime()函数获得，

即接收时间戳（1970纪元后经过的浮点秒数）并返回格林威治天文时间下的时间元组t。

发送时间的时间元组是用time.localtime()函数获得，

即接收时间戳（1970纪元后经过的浮点秒数）并返回当地时间下的时间元组t。