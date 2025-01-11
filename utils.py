import itertools

def get_patterns(n):
    patterns = list(itertools.product([0, 1], repeat=n))
    patterns = [f"`{''.join(map(str, p))}" for p in patterns]
    return patterns