import numpy as np
import matplotlib.pyplot as pplot
import h5py as h5
import cv2 as computer_vision

from PIL import Image


def load_datasets():
    trainining_ds = h5.File('files/train_catvnoncat.h5', "r")
    training_originX = np.array(
        trainining_ds["train_set_x"][:])  # train set features
    training_originY = np.array(
        trainining_ds["train_set_y"][:])  # train set labels

    testing_ds = h5.File('files/test_catvnoncat.h5', "r")
    testing_originX = np.array(
        testing_ds["test_set_x"][:])  # test set features
    testing_originY = np.array(testing_ds["test_set_y"][:])  # test set labels

    classes = np.array(testing_ds["list_classes"][:])  # the list of classes

    training_originY = training_originY.reshape((1, training_originY.shape[0]))
    testing_originY = testing_originY.reshape((1, testing_originY.shape[0]))

    return training_originX, training_originY, testing_originX, testing_originY, classes


def sigmoid(x):
    return 1 / (1 + np.exp(-x))


def hiperbolic_tan(x):
    return (np.exp(x) - np.exp(-x))/(np.exp(x) + np.exp(-x))


def initialize_with_zeros(dim):
    """ This function creates a vector of zeros of shape (dim, 1) for w and initializes b to 0. """
    w = np.zeros((dim, 1))
    b = 0

    assert(w.shape == (dim, 1))
    assert(isinstance(b, float) or isinstance(b, int))

    return w, b


def propagate(w, b, X, Y):
    """ Implement the cost function and its gradient for the propagation """

    m = X.shape[1]

    # FORWARD PROPAGATION (FROM X TO COST)

    # Activation
    A = sigmoid(np.dot(w.T, X) + b)
    # A = hiperbolic_tan(np.dot(w.T, X) + b)                                                                      # Activation
    cost = -(1/m) * np.sum(np.multiply(Y, np.log(A)) +
                           np.multiply(1 - Y, np.log(1-A)))                  # cost

    # BACKWARD PROPAGATION (TO FIND GRAD)

    dw = (1/m) * np.dot(X, (A - Y).T)
    db = (1/m) * np.sum(A - Y)

    assert(dw.shape == w.shape)
    assert(db.dtype == float)
    cost = np.squeeze(cost)
    assert(cost.shape == ())

    grads = {"dw": dw,
             "db": db}

    return grads, cost


def optimize(w, b, X, Y, num_iterations, learning_rate, print_cost=False):
    """ This function optimizes w and b by running a gradient descent algorithm """

    costs = []

    for i in range(num_iterations):

        # Cost and gradient calculation

        grads, cost = propagate(w, b, X, Y)

        # Retrieve derivatives from grads
        dw = grads["dw"]
        db = grads["db"]

        # update rule
        w = w - (learning_rate * dw)
        b = b - (learning_rate * db)

        # Record the costs
        if i % 100 == 0:
            costs.append(cost)

        # Print the cost every 100 training iterations
        if print_cost and i % 100 == 0:
            print("Cost after iteration %i: %f" % (i, cost))

    params = {"w": w,
              "b": b}

    grads = {"dw": dw,
             "db": db}

    return params, grads, costs


flag_to_present_perc = False


def predict(w, b, X):
    ''' Predict whether the label is 0 or 1 using learned logistic regression parameters (w, b) '''

    m = X.shape[1]
    Y_prediction = np.zeros((1, m))
    w = w.reshape(X.shape[0], 1)

    # Compute vector "A" predicting the probabilities of a cat being present in the picture

    A = sigmoid(np.dot(w.T, X) + b)
    # A = hiperbolic_tan(np.dot(w.T, X) + b)

    for i in range(A.shape[1]):

        # Convert probabilities A[0,i] to actual predictions p[0,i]

        Y_prediction[0, i] = 1 if A[0, i] > 0.65 else 0
        if(flag_to_present_perc):
            print("Prediction % = " + str(A[0, i]))

    assert(Y_prediction.shape == (1, m))

    return Y_prediction


def model(X_train, Y_train, X_test, Y_test, num_iterations=2000, learning_rate=0.5, print_cost=False):
    """ Builds the logistic regression model by calling the function you've implemented previously """

    # initialize parameters with zeros
    w, b = initialize_with_zeros(X_train.shape[0])

    # Gradient descent
    parameters, grads, costs = optimize(
        w, b, X_train, Y_train, num_iterations, learning_rate, print_cost)

    # Retrieve parameters w and b from dictionary
    w = parameters["w"]
    b = parameters["b"]

    # Predict test/train set examples
    Y_prediction_test = predict(w, b, X_test)
    Y_prediction_train = predict(w, b, X_train)

    # Print train/test Errors
    print("train accuracy: {} %".format(
        100 - np.mean(np.abs(Y_prediction_train - Y_train)) * 100))
    print("test accuracy: {} %".format(
        100 - np.mean(np.abs(Y_prediction_test - Y_test)) * 100))

    d = {"costs": costs,
         "Y_prediction_test": Y_prediction_test,
         "Y_prediction_train": Y_prediction_train,
         "w": w,
         "b": b,
         "learning_rate": learning_rate,
         "num_iterations": num_iterations}

    return d


def create_graph():
    costs = np.squeeze(d['costs'])
    pplot.plot(costs)
    pplot.ylabel('cost')
    pplot.xlabel('iterations (per hundreds)')
    pplot.title("Learning rate =" + str(d["learning_rate"]))
    pplot.show()
