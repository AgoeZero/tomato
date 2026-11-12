import numpy as np
import tensorflow as tf
from PIL import Image

MODEL = "tomato32.tflite"
IMAGE = "/tmp/tinymaix_resized.ppm"

classes = [
    "Bacterial Spot",
    "Early Blight",
    "Late Blight",
    "Leaf Mold",
    "Septoria Leaf Spot",
    "Spider Mites",
    "Target Spot",
    "Yellow Leaf Curl Virus",
    "Mosaic Virus",
    "Healthy",
    "Powdery Mildew"
]

# Load TFLite model
interpreter = tf.lite.Interpreter(model_path=MODEL)
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

print("Input:")
print(input_details)

print("\nOutput:")
print(output_details)

# Load exact TinyMaix image
img = Image.open(IMAGE).convert("RGB")

x = np.asarray(img, dtype=np.float32) / 255.0
x = np.expand_dims(x, axis=0)

print("\nInput shape:", x.shape)

print("\nFirst 10 pixels:")
for i in range(10):
    print(i, x[0, i // 128, i % 128])

# Set input
interpreter.set_tensor(
    input_details[0]["index"],
    x
)

# Run
interpreter.invoke()

output = interpreter.get_tensor(
    output_details[0]["index"]
)[0]

print("\n========================================")
print("TFLITE OUTPUT")
print("========================================")

for i, value in enumerate(output):
    print(f"{i:2d} {classes[i]:25s} {value:.6f}")

# Softmax
exp = np.exp(output - np.max(output))
prob = exp / np.sum(exp)

prediction = np.argmax(output)

print("\nPrediction:", classes[prediction])
print(f"Confidence: {prob[prediction] * 100:.6f}%")