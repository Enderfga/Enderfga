from asyncio import selector_events
import os
from skimage import io
import numpy as np 
import random
import tensorflow as tf

from src.utils.dataflow import get_rng

def identity(im):
    return im

class HorseData(object):
    def __init__(self, name, data_dir='', n_use_label=None, n_use_sample=None,
                 batch_dict_name=None, shuffle=True, pf=identity):
        assert os.path.isdir(data_dir)
        self._data_dir = data_dir

        self._shuffle = shuffle
        self._pf = pf

        if not isinstance(batch_dict_name, list):
            batch_dict_name = [batch_dict_name]
        self._batch_dict_name = batch_dict_name

        assert name in ['train', 'test', 'val']
        self.setup(epoch_val=0, batch_size=1)

        self._load_files(name, n_use_label, n_use_sample)
        self._image_id = 0

    def next_batch_dict(self):
        batch_data = self.next_batch()
        data_dict = {key: data for key, data in zip(self._batch_dict_name, batch_data)}
        return data_dict

    def _load_files(self, name, n_use_label, n_use_sample):
        if name=='train':
            img_list = list()
            label_list = list()
            for file in os.listdir(self._data_dir):
                img = io.imread(os.path.join(self._data_dir, file))
                img_list.append(self._pf(img))
                label_list.append(0)
            self.im_list = np.array(img_list)
            self.label_list = np.array(label_list)
        else:
            img_list = list()
            label_list = list()            
            dir_list = os.listdir(self._data_dir)
            index = random.sample(range(0, 5000), 1000)
            select_dir = list()
            for i in index:
                select_dir.append(dir_list[i])
            for file in select_dir:
                img = io.imread(os.path.join(self._data_dir, file))
                img_list.append(self._pf(img))
                label_list.append(0)
            self.im_list = np.array(img_list)
            self.label_list = np.array(label_list)


    def _suffle_files(self):
        if self._shuffle:
            idxs = np.arange(self.size())

            self.rng.shuffle(idxs)
            self.im_list = self.im_list[idxs]
            self.label_list = self.label_list[idxs]

    def size(self):
        return self.im_list.shape[0]

    def next_batch(self):
        assert self._batch_size <= self.size(), \
          "batch_size {} cannot be larger than data size {}".\
           format(self._batch_size, self.size())
        start = self._image_id
        self._image_id += self._batch_size
        end = self._image_id
        batch_files = self.im_list[start:end]
        batch_label = self.label_list[start:end]

        if self._image_id + self._batch_size > self.size():
            self._epochs_completed += 1
            self._image_id = 0
            self._suffle_files()
        return [batch_files, batch_label]

    def setup(self, epoch_val, batch_size, **kwargs):
        self.reset_epochs_completed(epoch_val)
        self.set_batch_size(batch_size)
        self.reset_state()
        try:
            self._suffle_files()
        except AttributeError:
            pass

    def reset_epoch(self):
        self._epochs_completed = 0

    @property
    def batch_size(self):
        return self._batch_size

    @property
    def epochs_completed(self):
        return self._epochs_completed

    def set_batch_size(self, batch_size):
        self._batch_size = batch_size

    def reset_epochs_completed(self, epoch_val):
        self._epochs_completed  = epoch_val

    def reset_state(self):
        self.rng = get_rng(self)
        


