import numpy as np
import tensorflow as tf
from PIL import Image

MODEL = "tomato_conv.keras"
IMAGE = "/tmp/tinymaix_resized.ppm"
# Load model
model = tf.keras.models.load_model(MODEL)

print("Model loaded")
print("Input shape:", model.input_shape)
print("Output shape:", model.output_shape)

# Load exactly the same image
img = Image.open(IMAGE).convert("RGB")

print("Original image:", img.size)

# Resize exactly like TinyMaix
#img = img.resize((128, 128))

# Convert to float32 and divide by 255
x = np.asarray(img, dtype=np.float32) / 255.0

# Add batch dimension
x = np.expand_dims(x, axis=0)

print("Input shape:", x.shape)

print("\nFirst 10 RGB pixels:")
for i in range(10):
    print(i, x[0, i // 128, i % 128])

# Run model
output = model.predict(x, verbose=0)[0]

print("\nRaw Keras output:")
for i, value in enumerate(output):
    print(f"{i:2d}: {value:.6f}")

# Softmax
probabilities = tf.nn.softmax(output).numpy()

print("\nProbabilities:")
for i, p in enumerate(probabilities):
    print(f"{i:2d}: {p:.9f} ({p*100:.6f}%)")

prediction = np.argmax(output)

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

print("\n========================================")
print("PREDICTION")
print("========================================")
print("Class index:", prediction)
print("Class:", classes[prediction])
print(f"Confidence: {probabilities[prediction] * 100:.6f}%")