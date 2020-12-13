# PROBLEM 1
#
# Linear arrangement of variables: 4!
# Arrangement of operators: 3!
#
# ANSWER: 4! * 3! = 24 * 6 = 144



# PROBLEM 2
#
# learning_curve function
def learning_curve(x, y, filename):
    # 1. Scan the maximal number of iterations from 50 to 2,000 with a step of 50 while logging the corresponding score sequentially (the return of test_NN)
    max_iters = np.array([]) # array of 50 - 2000 with iteration of 50
    t_score = np.array([]) # training score
    for i in range(50, 2050, 50):
        max_iters = np.append(max_iters, i)
        t_score = np.append(t_score, test_NN(x, y, i))
    print(max_iters)
    print(t_score)

    #  2. Make a line plot between the maximal number of iterations and the score of the NN, and save as a PNG file.
    figure = plt.figure(figsize=(10, 10))
    plt.title("Training score as a function of # iterations")
    plt.xlabel("Iterations")
    plt.ylabel("Training Score")
    plt.plot(max_iters, t_score)
    plt.grid()
    plt.show()
    figure.savefig(filename + ".png")

    # 3. Return the two vectors (as 1-D numpy array or 1-D list) used for plotting (first the sequence of maximal numbers of iterations, and then the scores).
    return np.vstack((max_iters, t_score))