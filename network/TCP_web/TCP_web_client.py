# 实验1.2 TCP通信与Web服务器
# 客户端代码
from socket import *
with socket(AF_INET, SOCK_STREAM) as s:
    # 将TCP欢迎套接字绑定到指定端口
    url = input('请输入要访问的网址：')
    IP = url.split('/')[2].split(':')[0]
    PORT = int(url.split('/')[2].split(':')[1])
    s.connect((IP, PORT))
    # 指定要访问的文件
    filename = url.split('/')[3]
    # 发送请求行
    request = ('GET /'+filename+' HTTP/1.1\r\n'+'Host: '+IP+':'+str(PORT)+'\r\n'+'Connection: keep-alive\r\n'+'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="100", "Google Chrome";v="100"\r\n'+'sec-ch-ua-mobile: ?0\r\n'+'sec-ch-ua-platform: "Windows"\r\n'+'Upgrade-Insecure-Requests: 1\r\n'+'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.88 Safari/537.36\r\n'+'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9\r\n'+'Sec-Fetch-Site: none\r\n'+'Sec-Fetch-Mode: navigate\r\n'+'Sec-Fetch-User: ?1\r\n'+'Sec-Fetch-Dest: document\r\n'+'Accept-Encoding: gzip, deflate, br\r\n'+'Accept-Language: zh-CN,zh;q=0.9\r\n')
    s.send(request.encode('utf-8'))
    # 接收响应行
    response = s.recv(1024)
    # 如果文件存在，则接收文件内容，否则输出错误信息
    if response.decode('utf-8').startswith('HTTP/1.1 200 OK'):
        print('文件存在，开始接收文件内容...')
        with open(filename, 'wb') as f:
                content = str(response.decode('utf-8').split('\r\n\r\n')[1])
                f.write(content.encode('utf-8'))
        print('文件接收完毕！')
    if response.decode('utf-8').startswith('HTTP/1.1 404 Not Found'):
        print('File not found')