# Copyright 2020 Forrest Sheng Bao
# GNU GPL v3.0 or later

import operator as op
import numpy as np 
import sklearn as skl
import sklearn.tree as tree


def estimate_gini_impurity(feature_values, threshold, labels, polarity):
    """
        Compute the gini impurity for comparing a feature value against a threshold under a given polarity
        feature_values: 1D numpy array, feature_values for samples on one feature dimension
        threshold: float
        labels: 1D numpy array, the label of samples, only +1 and -1. 
        polarity: operator type, only operator.gt or operator.le are allowed
        Examples
        -------------
        >>> feature_values = np.array([1,2,3,4,5,6,7,8])
        >>> labels = np.array([+1,+1,+1,+1, -1,-1,-1,-1])
        >>> for threshold in range(0,8): 
        ...     print("%.5f" % estimate_gini_impurity(feature_values, threshold, labels, op.gt))
        0.50000
        0.48980
        0.44444
        0.32000
        0.00000
        0.00000
        0.00000
        0.00000
        >>> for threshold in range(0,8): 
        ...     print("%.5f" % estimate_gini_impurity(feature_values, threshold, labels, op.le))
        1.00000
        0.00000
        0.00000
        0.00000
        0.00000
        0.32000
        0.44444
        0.48980
    """

    # TODO start
    filtered_features = polarity(feature_values, threshold)
    f = feature_values[filtered_features]  # features

    if len(f) == 0:
        gini_impurity = 1
        return gini_impurity

    l = labels[filtered_features]

    class1_members = np.logical_and(f, l == +1)
    class2_members = np.logical_and(f, l == -1)

    class1_length = sum(class1_members)  # length of c1 members
    class2_length = sum(class2_members)  # length of c2 members

    class_length = class1_length + class2_length  # total length of both classes

    pr1 = class1_length / class_length  # probability of class 1
    pr2 = class2_length / class_length  # probability of class 2

    gini_impurity = (pr1 * (1 - pr1)) + (pr2 * (1 - pr2))  # calculate gini impurity
    # TODO end

    return gini_impurity


def estimate_gini_impurity_expectation(feature_values, threshold, labels):
    """
        Compute the expectation of gini impurity given the feature values on one feature dimension and a threshold 
        feature_values: 1D numpy array, feature_values for samples on one feature dimension
        threshold: float
        labels: 1D numpy array, the label of samples, only +1 and -1. 
        Examples 
        ---------------
        >>> feature_values = np.array([1,2,3,4,5,6,7,8])
        >>> labels = np.array([+1,+1,+1,+1, -1,-1,-1,-1])
        >>> for threshold in range(0,9): 
        ...     estimate_gini_impurity_expectation(feature_values, threshold, labels)
        0.5
        0.4285714285714286
        0.3333333333333333
        0.1999999999999999
        0.0
        0.1999999999999999
        0.33333333333333337
        0.42857142857142866
        0.5
    """

    # TODO start
    left_gini = estimate_gini_impurity(feature_values, threshold, labels, op.le)
    right_gini = estimate_gini_impurity(feature_values, threshold, labels, op.gt)

    filtered_features = op.le(feature_values, threshold)

    number = len(feature_values[filtered_features])
    length = len(feature_values)
    pr1 = number/length

    expectation = left_gini * pr1 + right_gini * (1 - pr1)
    # TODO end

    return expectation


def midpoint(x):
    """
        Given a sequence of numbers, return the middle points between every two consecutive ones. 
        >>> x= np.array([1,2,3,4,5])
        >>> (x[1:] + x[:-1]) / 2
        array([1.5, 2.5, 3.5, 4.5])
    """

    result = (x[1:] + x[:-1]) / 2

    return result


def grid_search_split_midpoint(X, y):
    """
        Given a dataset, compute the gini impurity expectation for all pairs of features and thresholds. 
        Inputs
        ----------
            X: 2-D numpy array, axis 0 or row is a sample, and axis 1 or column is a feature
            y: 1-D numpy array, the labels, +1 or -1
        Returns
        ---------
            grid: 2-D numpy array, axis 0 or row is a threshold, and axis 1 or column is a feature
        Examples 
        -------------
        >>> np.random.seed(1) # fix random number generation starting point
        >>> X = np.random.randint(1, 10, (8,3)) # generate training samples
        >>> y = np.array([+1,+1,+1,+1, -1,-1,-1,-1])
        >>> grid, feature_id, bts = grid_search_split_midpoint(X, y)
        >>> print (grid)
        [[0.42857143 0.5        0.46666667]
         [0.46666667 0.5        0.46666667]
         [0.46666667 0.46666667 0.46666667]
         [0.375      0.5        0.46666667]
         [0.5        0.5        0.46666667]
         [0.5        0.5        0.5       ]
         [0.5        0.42857143 0.42857143]]
        >>> clf = skl.tree.DecisionTreeClassifier(max_depth=1)
        >>> clf = clf.fit(X,y)
        >>> print (clf.tree_.feature[0], clf.tree_.threshold[0], feature_id, bts)
        0 7.0 0 7.0
        >>> print(clf.tree_.feature[0] == feature_id)
        True
        >>> print( clf.tree_.threshold[0] == bts)
        True
        >>> # Another test case 
        >>> np.random.seed(2) # fix random number generation starting point
        >>> X = np.random.randint(1, 30, (8,3)) # generate training samples
        >>> grid, feature_id, bts = grid_search_split_midpoint(X, y)
        >>> print (grid)
        [[0.42857143 0.42857143 0.42857143]
         [0.5        0.5        0.33333333]
         [0.375      0.46666667 0.46666667]
         [0.375      0.5        0.5       ]
         [0.46666667 0.46666667 0.46666667]
         [0.33333333 0.5        0.5       ]
         [0.42857143 0.42857143 0.42857143]]
        >>> clf = clf.fit(X,y) # return the sklearn DT
        >>> print (clf.tree_.feature[0], clf.tree_.threshold[0], feature_id, bts)
        2 8.5 2 8.5
        >>> print(clf.tree_.feature[0] == feature_id)
        True
        >>> print( clf.tree_.threshold[0] == bts)
        True
        >>> # yet another test case 
        >>> np.random.seed(4) # fix random number generation starting point
        >>> X = np.random.randint(1, 100, (8,3)) # generate training samples
        >>> grid, feature_id, bts = grid_search_split_midpoint(X, y)
        >>> print (grid)
        [[0.42857143 0.42857143 0.42857143]
         [0.5        0.5        0.33333333]
         [0.46666667 0.46666667 0.375     ]
         [0.375      0.375      0.375     ]
         [0.46666667 0.2        0.46666667]
         [0.5        0.42857143 0.5       ]
         [0.42857143 0.42857143 0.42857143]]
        >>> clf = clf.fit(X,y) # return the sklearn DT
        >>> print (clf.tree_.feature[0], clf.tree_.threshold[0], feature_id, bts)
        1 47.5 1 47.5
        >>> print(clf.tree_.feature[0] == feature_id)
        True
        >>> print( clf.tree_.threshold[0] == bts)
        True
    """

    X_sorted = np.sort(X, axis=0)
    thresholds = np.apply_along_axis(midpoint, 0, X_sorted)

    # TODO start
    columns = X.shape[1]
    rows = X.shape[0]-1
    grid = [[0 for i in range(columns)] for j in range(rows)]

    for col in range(columns):
        for row in range(rows):
            grid[row][col] = estimate_gini_impurity_expectation(
                X[:, col], thresholds[row][col], y)

    arr = np.asarray(grid)
    ind = np.unravel_index(np.argmin(arr, axis=None), arr.shape)
    best_threshold = arr[ind]
    best_feature = ind[1]
    # TODO end

    return grid, best_feature, best_threshold


def you_rock(N, R, d):
    """
        N: int, number of samples, e.g., 1000. 
        R: int, maximum feature value, e.g., 100. 
        d: int, number of features, e.g., 3. 
    """
    np.random.seed()  # re-random the seed
    hits = 0
    for _ in range(N):
        X = np.random.randint(1, R, (8, d))  # generate training samples
        y = np.array([+1, +1, +1, +1, -1, -1, -1, -1])
        _, feature_id, bts = grid_search_split_midpoint(X, y)
        clf = tree.DecisionTreeClassifier(max_depth=1)
        clf = clf.fit(X, y)

        if clf.tree_.feature[0] == feature_id and clf.tree_.threshold[0] == bts:
            hits += 1
    print("your Decision tree is {:2.2%} consistent with Scikit-learn's result.".format(hits/N))


if __name__ == "__main__":
    import doctest
    doctest.testmod()
    you_rock(1000, 100, 3)
