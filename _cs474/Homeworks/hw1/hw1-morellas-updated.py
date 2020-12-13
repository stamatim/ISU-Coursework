# 144

import sklearn.neural_network as nn
import numpy as np
import matplotlib.pyplot as plt
import itertools

def test_NN(Ts, Hs, max_iter=200):
    NN = nn.MLPRegressor(
        hidden_layer_sizes=(4, 4),
        activation='tanh',
        random_state=1,
        max_iter=max_iter
    )
    Ts = Ts.reshape(-1, 1) # learned from error
    NN.fit(Ts, Hs)
    # predictions = NN.predict(Ts)
    score = NN.score(Ts, Hs)
    return score


def learning_curve(Ts, Hs, filename):
    max_iters = np.array([])  # array of 50 - 2000 with iteration of 50
    t_score = np.array([])  # training score
    for i in range(50, 2050, 50):
        max_iters = np.append(max_iters, i)
        t_score = np.append(t_score, test_NN(Ts, Hs, i))
    # print(max_iters)
    # print(t_score)

    figure = plt.figure(figsize=(10, 10))
    plt.title("Training score as a function of # iterations")
    plt.xlabel("Iterations")
    plt.ylabel("Training Score")
    plt.plot(max_iters, t_score)
    plt.grid()
    plt.show()
    figure.savefig(filename + ".png")

    return max_iters, t_score


def self_checker(*args):
    X, y = learning_curve(*args)
    print(type(X), X)
    print(type(y), y)
    import hashlib
    print(hashlib.md5(open(args[2], "rb").read()).hexdigest())


if __name__ == "__main__":
    import warnings
    warnings.filterwarnings("ignore")

    self_checker(np.array([1, 2]), np.array([3, 4]), "test.png")
    print()
    self_checker(np.array([1, 2, 3, 4]),
                 np.array([-1, -1, -1, -1]), "test.pdf")
