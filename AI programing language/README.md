
![人工智能编程语言](人工智能编程语言.svg)

![C语言，matlab，python的异同](C语言，matlab，python的异同.svg)


# 人工智能编程语言

## Python

### 第五周

- Python的简介

	- 简单，易学，好用
	- 深度学习，计算机建模，云计算，金融分析······

- Python变量及其赋值、输入与输出

	- 常量用大写字母表示
	- 变量以字母或下划线开头（下划线有特殊含义）
	- 合并赋值，按顺序赋值，简写赋值
	- input()   print()

- Python基本数据类型

	- 数值（整型int，浮点型float）
	- 字符
	- 布尔值（逻辑值）

- 流程控制

	- 顺序流程
	- 条件控制语句（if：elif：else：）
	- 循环控制语句（while：for in ：）

- Python序列操作

	- list（可变）
	- tuple
	- dictionary（可变）

### 第六周

- set（可变/不可变两种，一般可变）
- Python函数

	- def 函数名([参数列表]):函数体
	- 形参，实参
	- 变量作用域
	- 递归，map(),lambda

- Python模块

	- Module
	- Package
	- import/from  import  /import  as
	- sys

### 第七周

- Python文件操作

	- open() close() 
	- read() write()
	- with open() as    :
	- csv,excel,pdf

- Python面向对象编程

	- 封装性，继承性，多态性
	- class <类名>:def __init__(): private

### 第八周

- Numpy的简介与使用

	- 科学计算import numpy as np
	- ndarray
	- arange()
	- linspace()
	- logspace()
	- Broadcast

- Pandas的简介与使用

	- 核心数据分析支持库import pandas as pd
	- Series
	- DataFrame
	- Panel(以另外两种为主)

- Matplotlib的简介与使用

	- 强大的画图工具，数据可视化import matplotlib.pyplot as plt
	- title,xlabel,ylabel,axis,xlim,ylim,legend,text
	- plot,hist,bar,barh,pie....

### 第九周

- 初识人工智能

	- 弱人工智能，通用人工智能，强人工智能
	- 虚拟个人助理，智能图像搜索，拍照软件，个性化推荐····
	- 回归，分类，生成

- Python在人工智能中的应用-示例

	- KNN分类算法

## MATLAB

### 第一周

- MATLAB的简介

	- 高性能的数值计算和可视化软件

- MATLAB视窗介绍

	- 命令行窗口
	- 工作区
	- 命令历史记录
	- 工作文件夹

- MATLAB的基本运算

	- 结果显示为ans
	- 基本运算+-*/^优先级等无特殊之处

- 变量和数据类型

	- 数字
	- 字符或字符串
	- 元胞数组
	- 结构体
	- 函数句柄
	- 逻辑值

- 矩阵运算

	- array(vector)
	- 数组索引，冒号算子，.*，./，cat()

- 多项式

	- poly2sym
	- roots
	- conv
	- deconv
	- polyder
	- polyint

### 第二周

- MATLAB脚本和M文件

	- script
	- 脚本运行，断点，注释···
	- 结构化程序

- 控制流语句

	- if elseif else end
	- switch case  otherwise  end
	- while  end
	- for var=initial:incremental:final  end
	- break,continue,pause,return

- 函数的编写和调用

	- function  [返回变量列表]  =  函数名（输入变量列表） 函数体  end
	- 函数全局，局部变量
	- 函数句柄

- 函数的书写规范

	- 代码千万条，注释第一条

### 第三周

- 变量:字符(串)、结构体和元胞数组

	- char，str
	- struct
	- Structure array，Nest structure
	- Cell array

- 文件的存取

	- mat:save,load
	- txt:fprintf,fscanf
	- xls/xlsx:xlswrite,xlsread

- 函数的调用

### 第四周

- MATLAB基础绘图

	- linewidth,markersize,markerfacecolor,makeredgecolor
	- subplot,gca,gcf
	- title,xlabel,ylabel,axis,xlim,ylim,legend,text

- MATLAB进阶绘图

	- 2D

		- stair/ stem
		- histogram
		- box
		- bar
		- errorbar
		- plotyy
		- pie

	- 3D

		- plot3
		- surf
		- meshgrid
