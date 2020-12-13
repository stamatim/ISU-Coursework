# The function implementating SMO is taken from
# https://github.com/LasseRegin/SVM-w-SMO/blob/master/SVM.py

import numpy as np
import sklearn as skl
from sklearn import datasets
from sklearn import utils
import sklearn.datasets as datasets
import sklearn.utils as utils
from sklearn import model_selection as ms
import sklearn.svm as svm

from sklearn.metrics import confusion_matrix, accuracy_score


def study_C_fix_split(C_range):
    """
    Examples 
    -----------
    >>> study_C_fix_split([1,10,100,1000])
    10
    >>> study_C_fix_split([10**p for p in range(-5,5)])
    10
    """
    best_C = 0  # placeholder

    # load the data
    data = skl.datasets.load_breast_cancer()
    X, y = data["data"], data["target"]

    # prepare the training and testing data
    X_train, X_test, y_train, y_test = ms.train_test_split(X, y, test_size=0.2, random_state=1)

    # TODO start
    score_count = 0
    for margin in C_range: 
        from sklearn.svm import SVC
        classifier = svm.SVC(kernel = 'linear', random_state = 1, C = margin) # support vector classification
        classifier.fit(X_train, y_train) # fit svm model according to training data

        y_pred = classifier.predict(X_test) # perform classification

        score = accuracy_score(y_test, y_pred)
        if score > score_count:
            score_count = score
            best_C = margin
    ## TODO end

    return best_C


def study_C_gridCV(C_range):
    """
    C_range: 1-D list of floats or integers 
    Examples
    --------------
    >>> study_C_gridCV([1,2,3,4,5])
    2
    >>> study_C_gridCV(np.array([0.1, 1, 10]))
    10.0
    """
    best_C = 0  # placeholder

    # load the data
    data = skl.datasets.load_breast_cancer()
    X, y = data["data"], data["target"]

    # shuffle the data
    X, y = skl.utils.shuffle(X, y, random_state=1)

    model = svm.SVC(kernel='linear', random_state=1)

    paras = {'C': C_range}

    # TODO start
    accuracy = 0
    for margin in paras['C']:
        model = svm.SVC(kernel = 'linear', random_state = 1, C = margin)
        accuracies = ms.cross_val_score(estimator = model, X = X, y = y, cv = 5)
        mean_accuracy = accuracies.mean()

        if mean_accuracy > accuracy:
            accuracy = mean_accuracy
            best_C = margin
    # TODO end

    return best_C


def study_C_and_sigma_gridCV(C_range, sigma_range):
    """
    Examples 
    ------------
    >>> study_C_and_sigma_gridCV([0.1, 0.5, 1, 3, 9, 100], np.array([0.1, 1, 10]))
    (0.1, 0.1)
    >>> study_C_and_sigma_gridCV([10**p for p in range(-5, 5, 1)], [10**p for p in range(-5, 5, 1)])
    (1000, 1e-05)
    """
    best_C, best_sigma = 0, 0  # placeholders

    # load the data
    data = skl.datasets.load_breast_cancer()
    X, y = data["data"], data["target"]

    # shuffle the data
    X, y = skl.utils.shuffle(X, y, random_state=1)

    # TODO start
    parameters = {'C': C_range, 'gamma': sigma_range}
    svc = svm.SVC(kernel = 'rbf', random_state = 1)
    classifier = ms.GridSearchCV(svc, parameters)
    classifier.fit(X, y)

    best_C = classifier.best_params_['C']
    best_sigma = classifier.best_params_['gamma']
    # TODO end

    return best_C, best_sigma


if __name__ == "__main__":
    import doctest
    # doctest.testmod()
    doctest.run_docstring_examples(study_C_and_sigma_gridCV, globals())
