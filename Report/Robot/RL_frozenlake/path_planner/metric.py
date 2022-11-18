from time import time

def run_time(func):
    def warp(*args, **kwargs):
        t1 = time()
        temp = func(*args, **kwargs)
        t2 = time()
        print(f'run time: {t2 - t1}')
        return temp
    return warp