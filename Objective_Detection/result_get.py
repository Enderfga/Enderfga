import cv2
import pandas
import random
csv = pandas.read_csv("/home/Enderfga/emotion/bulk_result.csv")
# {'xmin': 0.7832231521606445, 'ymin': 0.31923800706863403, 'xmax': 1.0, 'ymax': 1.0}
# 读取predict_rois并将归一化坐标转换成真实坐标
path = '/home/Enderfga/emotion/train/JPEGImages'
for i in range(len(csv)):
    name = csv['image'][i].split('/')[-1]
    JPG = cv2.imread(path+'//'+name)
    X = JPG.shape[1]
    Y = JPG.shape[0]
    rois = csv['predict_rois'][i]
    lois_list = rois[:-1].split(',')
    # 读取: 后的数字
    for j in range(len(lois_list)):
        lois_list[j] = float(lois_list[j].split(': ')[1])
    # 将归一化坐标转换成真实坐标
    lois_list[0] = int(lois_list[0]*X)
    lois_list[1] = int(lois_list[1]*Y)
    lois_list[2] = int(lois_list[2]*X)
    lois_list[3] = int(lois_list[3]*Y)
    if csv['predict_score'][i] < 0.5:
        with open('/home/Enderfga/emotion/a.txt', 'a') as f:
            if csv['predict_class'][i] == 'heightworker':
                f.write(name+','+str(lois_list[0])+','+str(lois_list[1])+','+str(lois_list[2])+','+str(lois_list[3])+','+'0'+','+str(random.randint(0,1))+'\n')
        with open('/home/Enderfga/emotion/b.txt', 'a') as f:
            if csv['predict_class'][i] == 'standardbelt':
                f.write(name+','+str(lois_list[0])+','+str(lois_list[1])+','+str(lois_list[2])+','+str(lois_list[3])+','+str(csv['predict_score'][i])+'\n')
        continue
    # 把结果写入txt
    with open('/home/Enderfga/emotion/a.txt', 'a') as f:
        if csv['predict_class'][i] == 'nobelt':
            f.write(name+','+str(lois_list[0])+','+str(lois_list[1])+','+str(lois_list[2])+','+str(lois_list[3])+','+'1'+','+'0'+'\n')
        elif csv['predict_class'][i] == 'belt':
            f.write(name+','+str(lois_list[0])+','+str(lois_list[1])+','+str(lois_list[2])+','+str(lois_list[3])+','+'1'+','+'1'+'\n')
    with open('/home/Enderfga/emotion/b.txt', 'a') as f:
        if csv['predict_class'][i] == 'standardbelt':
            f.write(name+','+str(lois_list[0])+','+str(lois_list[1])+','+str(lois_list[2])+','+str(lois_list[3])+','+str(csv['predict_score'][i])+'\n')