# 实验1.2 TCP通信与Web服务器
# 服务端代码
#import socket module
from socket import *
import threading


def handle_client(client_socket,addr):
	print('Accept new connection from %s:%s...\r\n' % addr)
	with client_socket:
		# 获取客户发送的报文
		message = client_socket.recv(1024) 
		# 获取客户端发送的请求行
		# print(message.decode('utf-8'))
		filename = message.split(b"\r\n")
		outputdata = filename[0].split()[1].decode()
		# 映射“根”目录默认html文件
		if outputdata == '/':
			outputdata = 'index.html'
		else :
			outputdata = outputdata[1:]
		try:
			with open(outputdata,'rb') as f:
				# 读取文件内容
				content = f.read()
				# 发送响应行
				response = b'HTTP/1.1 200 OK\r\n' + b'Content-Type: text/html\r\n' + b'\r\n' + content
		except FileNotFoundError:
			with open('404.html','rb') as f:
				# 读取文件内容
				content = f.read()
			# 发送未找到文件的响应消息
			response = b'HTTP/1.1 404 Not Found\r\n'+ b'\r\n' + content
		client_socket.sendall(response)
# 创建一个 TCP 套接字 （SOCK_STREAM）
with socket(AF_INET, SOCK_STREAM) as s:
	# 将TCP欢迎套接字绑定到指定端口
	s.bind(('0.0.0.0', 12000)) 
	# 设置最大连接数为5
	s.listen(5) 

	while True:
		# 建立连接
		print('Ready to serve...')
		# 接收到客户连接请求后，建立新的TCP连接套接字
		connectionSocket, addr = s.accept() 
		# 创建新线程处理客户端请求,以实现多线程服务器
		t = threading.Thread(target=handle_client, args=(connectionSocket,addr))
		t.start()