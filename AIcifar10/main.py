import torch as t
from torchvision import transforms
from torch.utils.data import Dataset,DataLoader
from PIL import Image
import glob
import torch.nn as nn
data_transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize(mean = [0.5], std = [0.5])
    ])
class my_dataset(Dataset):
    def __init__(self, store_path,split,name,data_transform=None):
        self.store_path = store_path
        self.split = split
        self.name = name
        self.transforms = data_transform
        self.img_list = []
        self.label_list = []
        for file in glob.glob(self.store_path + '/' + split + '/*.png'):
            cur_path = file.replace( '\\', '/')
            cur_label = cur_path.split('_')[-1].split('.png')[0]
            self.img_list.append(cur_path)
            self.label_list.append(self.name[cur_label])
    def __getitem__(self, item):
        img = Image.open(self.img_list[item]).convert( 'RGB')
        if self.transforms is not None:
            img = self.transforms (img)
        label = self.label_list[item]
        return img, label
    def __len__(self):
        return len(self.img_list)
class CIFAR(nn.Module):
    def __init__(self, features, n_channel, num_classes):
        super(CIFAR, self).__init__()
        assert isinstance(features, nn.Sequential), type(features)
        self.features = features
        self.classifier = nn.Sequential(
            nn.Linear(n_channel, num_classes)
        )

    def forward(self, x):
        x = self.features(x)
        x = x.view(x.size(0), -1)
        x = self.classifier(x)
        return x
def make_layers(cfg, batch_norm=False):
    layers = []
    in_channels = 3
    for i, v in enumerate(cfg):
        if v == 'M':
            layers += [nn.MaxPool2d(kernel_size=2, stride=2)]
        else:
            padding = v[1] if isinstance(v, tuple) else 1
            out_channels = v[0] if isinstance(v, tuple) else v
            conv2d = nn.Conv2d(in_channels, out_channels, kernel_size=3, padding=padding)
            if batch_norm:
                layers += [conv2d, nn.BatchNorm2d(out_channels, affine=False), nn.ReLU()]
            else:
                layers += [conv2d, nn.ReLU()]
            in_channels = out_channels
    return nn.Sequential(*layers)



if __name__ == '__main__':
    store_path = 'cifar'
    split = 'test'
    name = { 'airplane': 0,'automobile':1,'bird':2, 'cat':3,'deer':4, 'dog':5, 'frog':6,'horse':7, 'ship':8,'truck':9}
    test_dataset = my_dataset(store_path, split, name,data_transform)
    testloader = DataLoader(test_dataset, batch_size=4, shuffle=False,num_workers=1)
    device = t.device('cuda:0' if t.cuda.is_available() else 'cpu')
    net = t.load('best_model.pth', map_location=device)
    # 计算模型分类准确率
    correct = 0
    total = 0
    for images, labels in testloader:
        images = images.to(device)
        labels = labels.to(device)
        outputs = net(images)
        _, predicted = t.max(outputs.data, 1)
        total += labels.size(0)
        correct += (predicted == labels).sum()
    print('Accuracy of the network on the 10000 test images: %d %%' % (100 * correct / total))