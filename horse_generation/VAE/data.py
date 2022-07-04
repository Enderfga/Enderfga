from torchvision import datasets, transforms

_CIFAR_TRAIN_TRANSFORMS = [
    transforms.RandomCrop(32, padding=4),
    transforms.RandomHorizontalFlip(),
    transforms.ToTensor(),
]

_CIFAR_TEST_TRANSFORMS = [
    transforms.ToTensor(),
]


TRAIN_DATASETS = {
    'cifar10': datasets.ImageFolder(
        'horse/cifar10_horse/', 
        transform=transforms.Compose(_CIFAR_TRAIN_TRANSFORMS)
    )
}


TEST_DATASETS = {
    'cifar10': datasets.ImageFolder(
        'horse/cifar10_horse/', 
        transform=transforms.Compose(_CIFAR_TEST_TRANSFORMS)
    )
}


DATASET_CONFIGS = {
    'cifar10': {'size': 32, 'channels': 3, 'classes': 10},
}
