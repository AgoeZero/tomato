import sys
import tensorflow as tf

MODEL = sys.argv[1]
OUTPUT = sys.argv[2]

model = tf.keras.models.load_model(MODEL)

converter = tf.lite.TFLiteConverter.from_keras_model(model)

# Don't quantize yet.
converter.optimizations = []

tflite_model = converter.convert()

with open(OUTPUT, "wb") as f:
    f.write(tflite_model)

print("Saved:", OUTPUT)
