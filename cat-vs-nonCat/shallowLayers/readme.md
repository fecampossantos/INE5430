# Cat-vs-NonCat

## Shallow Layers

---

### Running the application

1. You should have python and pip installed on your computer
2. On your terminal, access the `cat-vs-nonCat\shallowLayers` directory
3. run `pip install -r requirements.txt` to install the necessary packages
4. run `python3 main.py` to run the app

### Output

The console will output the following:

```console
_________________________________________________________________
 Layer (type)                Output Shape              Param #
=================================================================
 flatten (Flatten)           (209, 12288)              0

 dense (Dense)               (209, 400)                4915600

 dense_1 (Dense)             (209, 2)                  802

=================================================================
Total params: 4,916,402
Trainable params: 4,916,402
Non-trainable params: 0
_________________________________________________________________

Number of training data: 146
2/2 [==============================] - 0s 6ms/step

Accuracy: 0.7600
```

- accuracy may differ, I believe that the free memory on the computer at the time the app is running interfers with the results.

The app will also create some windows with graphs. Here are some examples:

// TODO add images
