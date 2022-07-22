# Cat-vs-NonCat

## Logistic Regression

---

### Running the application

1. You should have python and pip installed on your computer
2. On your terminal, access the `cat-vs-nonCat\logisticRegression_perceptron` directory
3. run `pip install -r requirements.txt` to install the necessary packages
4. run `python3 main.py` to run the app

### Parameters

Some configuration parameters are defined as

```python()
PREDICTION_THRESHOLD = 0.65
LEARNING_RATE = 0.005
NUM_ITERATIONS = 2000
SHOW_PLOTS = True
```

Where:

1. `PREDICTION_THRESHOLD` means "above what percentage of being a cat will it assume it is a cat?"
2. `LEARNING_RATE` is the learning rate
3. `NUM_ITERATIONS` is the number of iterations
4. `SHOW_PLOTS` will define if plots will be shown
