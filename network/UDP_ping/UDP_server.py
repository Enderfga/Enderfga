# 实验1.1 套接字基础与UDP通信
# 服务端代码
import random
from socket import *
# 创建一个 UDP 套接字 （SOCK_DGRAM）
with socket(AF_INET, SOCK_DGRAM) as s:
    # 绑定端口
    s.bind(('0.0.0.0', 12000))
    while True:
        rand = random.randint(0, 10)
        # 接收 UDP 数据，其中 message 是包含接收数据的字符串，address 是发送数据的套接字地址。
        message, address = s.recvfrom(1024)
        # 打印message
        print("Received: %s" % message.decode("utf-8"))
        # 字符串中的小写字母转为大写字母。
        message = message.upper()
        # 模拟 30% 的数据包丢失
        if rand < 4:
            continue
        s.sendto(message, address)