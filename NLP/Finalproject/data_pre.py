# %%
import re
import json

# 读取 data1.txt 中的数据
with open("nlpcc-iccpol-2016.kbqa.testing-data", "r", encoding="utf-8") as f:
    data1 = f.read()

# 读取 data2.txt 中的数据
with open("nlpcc-iccpol-2016.kbqa.training-data", "r", encoding="utf-8") as f:
    data2 = f.read()

# 正则表达式提取所有问题和答案
pattern = r"<question id=\d+>(.+)\n<triple id=\d+>.+\n<answer id=\d+>(.+)"

matches1 = re.findall(pattern, data1, re.MULTILINE)
matches2 = re.findall(pattern, data2, re.MULTILINE)

# 合并匹配结果
matches = matches1 + matches2

# 转换数据为 JSON 格式
instances = [{"input": q, "output": a} for q, a in matches]

output_dict = {"type": "text2text", "instances": instances}

output_json = json.dumps(output_dict, ensure_ascii=False, indent=4)

# 将数据写入输出文件
with open("output.json", "w", encoding="utf-8") as f:
    f.write(output_json)


