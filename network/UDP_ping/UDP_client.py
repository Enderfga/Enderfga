# 实验1.1 套接字基础与UDP通信
# 客户端代码
from socket import*
import time
# 创建一个 UDP 套接字 （SOCK_DGRAM）
with socket(AF_INET, SOCK_DGRAM) as c:
    # 使用settimeout函数限制recvfrom()函数的等待时间为1秒
    c.settimeout(1)
    # 记录RTT
    rttTimes = []
    # 记录丢包次数
    count = 0
    # 发送10次ping报文
    for i in range(10):
        # RRT开始计数时间
        sendTime = time.perf_counter()
        # 将信息转换为byte后发送到指定服务器端
        c.sendto("ping".encode("utf-8"),("127.0.0.1",12000))
        try:
            # 调用recvfrom()函数接收服务器发来的应答数据
            message,address=c.recvfrom(1024)
            # 打印message
            print("Received: %s" % message.decode("utf-8"))
        #超时处理，等到时间超过1秒，捕获抛出的异常后打印丢失报文，进行下一步操作
        except:
            print("请求超时!")
            count += 1
            continue
        # 计算往返时间
        rtt = time.perf_counter() - sendTime 
        rttTimes.append(rtt)
        print('RTT = %.15f'%rtt)

# 计算ping消息的最小、最大和平均RRT，并计算丢包率
mintime = min(rttTimes)
maxtime = max(rttTimes)
avetime = sum(rttTimes) / len(rttTimes)
print('min_RRT:'+str(mintime))
print('max_RRT:'+str(maxtime))
print('average_RRT:'+str(avetime))
print('packet loss rate:'+str(count)+'0%')