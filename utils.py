import itertools
import os
import shutil

def get_patterns(n):
    patterns = list(itertools.product([0, 1], repeat=n))
    patterns = [f"`{''.join(map(str, p))}" for p in patterns]
    return patterns

def create_or_clean_folder(path):
    if os.path.exists(path):
        shutil.rmtree(path)
    os.makedirs(path)
    return None