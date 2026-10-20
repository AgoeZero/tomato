import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers

# ============================================================
# Configuration
# ============================================================

DATASET_PATH = "/home/john/Downloads/archive/train"

MODEL_NAME = "tomato_conv.keras"

IMAGE_SIZE = 128
BATCH_SIZE = 16
EPOCHS = 40
LEARNING_RATE = 0.001

# ============================================================
# Load dataset
# ============================================================

dataset = tf.keras.utils.image_dataset_from_directory(
    DATASET_PATH,
    image_size=(IMAGE_SIZE, IMAGE_SIZE),
    batch_size=BATCH_SIZE,
    shuffle=True
)

class_names = dataset.class_names

print("\nClasses:")
for i, name in enumerate(class_names):
    print(i, name)

NUM_CLASSES = len(class_names)

print("\nNumber of classes:", NUM_CLASSES)

# ============================================================
# Normalize pixels
# ============================================================

normalization = layers.Rescaling(
    1.0 / 255.0
)

# ============================================================
# Build model
# ============================================================

model = keras.Sequential([

    layers.Input(
        shape=(IMAGE_SIZE, IMAGE_SIZE, 3)
    ),

    normalization,

    # --------------------------------------------------------
    # 128x128x3 -> 64x64x16
    # --------------------------------------------------------

    layers.Conv2D(
        16,
        kernel_size=3,
        strides=2,
        padding="same",
        activation="relu"
    ),

    # --------------------------------------------------------
    # 64x64x16 -> 32x32x32
    # --------------------------------------------------------

    layers.Conv2D(
        32,
        kernel_size=3,
        strides=2,
        padding="same",
        activation="relu"
    ),

    # --------------------------------------------------------
    # 32x32x32 -> 16x16x64
    # --------------------------------------------------------

    layers.Conv2D(
        64,
        kernel_size=3,
        strides=2,
        padding="same",
        activation="relu"
    ),

    # --------------------------------------------------------
    # 16x16x64 -> 1x1x64
    # --------------------------------------------------------

    layers.GlobalAveragePooling2D(),

    # --------------------------------------------------------
    # 64 -> 1x1x64
    #
    # Required so we can use Conv2D.
    # --------------------------------------------------------

    layers.Reshape((1, 1, 64)),

    # --------------------------------------------------------
    # Equivalent of Dense(128, activation="relu")
    #
    # 1x1x64 -> 1x1x128
    # --------------------------------------------------------

    layers.Conv2D(
        128,
        kernel_size=1,
        activation="relu"
    ),

    # --------------------------------------------------------
    # Equivalent of Dense(NUM_CLASSES)
    #
    # 1x1x128 -> 1x1xNUM_CLASSES
    #
    # NO activation: these are logits.
    # --------------------------------------------------------

    layers.Conv2D(
        NUM_CLASSES,
        kernel_size=1,
        activation=None
    ),

    # --------------------------------------------------------
    # 1x1xNUM_CLASSES -> NUM_CLASSES
    # --------------------------------------------------------

    layers.Reshape((NUM_CLASSES,))
])

# ============================================================
# Display architecture
# ============================================================

print("\nModel:")
model.summary()

# ============================================================
# Compile
# ============================================================

model.compile(
    optimizer=keras.optimizers.Adam(
        learning_rate=LEARNING_RATE
    ),
    loss=keras.losses.SparseCategoricalCrossentropy(
        from_logits=True
    ),
    metrics=["accuracy"]
)

# ============================================================
# Train
# ============================================================

print("\nStarting training...\n")

model.fit(
    dataset,
    epochs=EPOCHS
)

# ============================================================
# Save
# ============================================================

model.save(MODEL_NAME)

print("\n========================================")
print("Training complete")
print("========================================")
print("Model saved:", MODEL_NAME)