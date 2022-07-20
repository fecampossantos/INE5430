import numpy as np
import cv2 as computer_vision

from PIL import Image

from functions import load_datasets, predict, model, create_graph


# Loading the data (cat/non-cat)
training_originX, train_set_y, testing_originX, test_set_y, classes = load_datasets()


m_train = training_originX.shape[0]
m_test = testing_originX.shape[0]
num_px = training_originX.shape[1]

# reshaping images of shape (num_px, num_px, 3) to (num_px * num_px * 3, 1)
train_set_x_flatten = training_originX.reshape(training_originX.shape[0], -1).T
test_set_x_flatten = testing_originX.reshape(testing_originX.shape[0], -1).T

# standardizing the dataset
train_set_x = train_set_x_flatten/255.
test_set_x = test_set_x_flatten/255.


# TRAINING THE MODEL

d = model(train_set_x, train_set_y, test_set_x, test_set_y,
          num_iterations=2000, learning_rate=0.005, print_cost=True)


# Testing with own images

images = ["fan.jpg", "cat.jpg", "flower.jpg", "moon.jpg", "another-cat.jpg"]
for my_image in images:
    flag_to_present_perc = True

    fname = "images/" + my_image
    image = np.array(computer_vision.imread(fname))
    image = image/255.
    my_image = computer_vision.resize(image, dsize=(
        num_px, num_px)).reshape((1, num_px*num_px*3)).T
    my_predicted_image = predict(d["w"], d["b"], my_image)

    computer_vision.imshow("", computer_vision.resize(image, dsize=(500, 500)))
    computer_vision.waitKey(0)
    print("y = " + str(np.squeeze(my_predicted_image)) + ", your algorithm predicts a \"" +
          classes[int(np.squeeze(my_predicted_image)), ].decode("utf-8") + "\" picture.")
