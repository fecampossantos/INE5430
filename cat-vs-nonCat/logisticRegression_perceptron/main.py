import numpy as np
import h5py as h5
from sklearn.metrics import confusion_matrix
from sklearn.metrics import ConfusionMatrixDisplay
import matplotlib.pyplot as plt

from functions import train_model, make_predictions

# this defines above what percentage of chance of being a cat is going to be considered a cat
PREDICTION_THRESHOLD = 0.65

LEARNING_RATE = 0.005
NUM_ITERATIONS = 2000
SHOW_PLOTS = True

float_formatter = "{:.2f}".format

# loads given datasets
print('Loading datasets...\n')
trainining_ds = h5.File('../datasets/train_catvnoncat.h5', "r")
testing_ds = h5.File('../datasets/test_catvnoncat.h5', "r")
print('Datasets loaded!\n')

print('Configuring datasets...\n')
Xtrain = np.array(
        trainining_ds["train_set_x"][:])  # train set features
Ytrain = np.array(
        trainining_ds["train_set_y"][:])  # train set labels

Xtest = np.array(
        testing_ds["test_set_x"][:])  # test set features
Ytest = np.array(testing_ds["test_set_y"][:])  # test set labels


Ytrain = Ytrain.reshape((1, Ytrain.shape[0]))
Ytest = Ytest.reshape((1, Ytest.shape[0]))
print('Datasets configures!\n')

# reshaping and standardizing the data
print('Reshaping and standardizing the data...\n')
train_set_x = Xtrain.reshape(Xtrain.shape[0], -1).T/255.
test_set_x = Xtest.reshape(Xtest.shape[0], -1).T/255.
print('Data reshaped and standardized!\n')

# TRAINING THE MODEL
print('Training the model using the configuration:')
print('\tLearning Rate:', LEARNING_RATE)
print('\tNumber of iterations:', NUM_ITERATIONS)

w, b, costs = train_model(train_set_x, Ytrain, NUM_ITERATIONS, LEARNING_RATE)
print('Model trained!\n')

print('Making predicitions!\n')
predictions = make_predictions(w, b, test_set_x, PREDICTION_THRESHOLD)
print('Predictions made!\n')

print("============================")
accuracy = float_formatter(100 - np.mean(np.abs(predictions - Ytest)) * 100)
print("Accuracy: {}%".format(accuracy))
print("============================")

if(SHOW_PLOTS):
  plt.figure()
  plt.plot(costs)
  plt.ylabel('cost')
  plt.xlabel('iterations')
  plt.title("Learning rate = " + str(LEARNING_RATE))

  test_confusion_matrix = confusion_matrix(Ytest[0], predictions[0])

  ConfusionMatrixDisplay(test_confusion_matrix).plot()
  plt.show()
