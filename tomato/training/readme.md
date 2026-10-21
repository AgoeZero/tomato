# Tomato Leaf Disease Detection
A deep learning project for detecting diseases in tomato leaves using TensorFlow and Keras. This repository contains scripts for training a convolutional neural network (CNN) model and converting it to TensorFlow Lite format for edge deployment.

## Project Overview
This project implements an end-to-end pipeline for tomato leaf disease classification:
1. **train.py** – Trains a custom CNN model on a labeled dataset of tomato leaf images2. **convert.py** – Converts the trained Keras model to TensorFlow Lite format for mobile/edge device deployment
The model uses a lightweight CNN architecture optimized for inference on resource-constrained devices.

## Features
- **Custom CNN Architecture** – Efficient convolutional layers with global average pooling-
- **Image Normalization** – Automatic pixel scaling (0–1 range)-
- **TensorFlow Lite Export** – Deploy models on mobile and edge devices-
- **Configurable Parameters** – Easy adjustment of image size, batch size, epochs, and learning rate-
- **Multi-class Classification** – Supports any number of disease classes from your dataset

## Dataset
This project uses the **Tomato Leaf Disease Dataset** from Kaggle:
- **Source:** [Ashish Motwani - Tomato Dataset](https://www.kaggle.com/datasets/ashishmotwani/tomato)
- - **Description:** Contains labeled images of healthy and diseased tomato leaves
    
### Downloading the Dataset
1. Visit [Kaggle Tomato Dataset](https://www.kaggle.com/datasets/ashishmotwani/tomato)
2. Download the dataset (requires Kaggle account)
3. Extract the dataset to your local machine4. Use the extracted path as `DATASET_PATH` when running `train.py`
   
## Installation
1. **Clone the repository**:
   git clone https://github.com/agoezero/tomato.git
   cd tomato/tomato/training

Install dependencies

pip install -r requirements.txt

Verify installation:
bash

    python -c "import tensorflow; print(tensorflow.__version__)"

Usage
Training the Model

Train a new model on your dataset:
bash

python train.py /path/to/dataset output_model.keras

Arguments:

    DATASET_PATH – Path to your organized dataset directory
    MODEL_NAME – Output filename for the trained Keras model (e.g., model.keras)

Example:
bash

python train.py ./tomato_dataset my_model.keras

Output:

    Trained Keras model saved as .keras file
    Console output showing:
        Detected disease classes
        Model architecture summary
        Training progress (loss and accuracy per epoch)

Converting to TensorFlow Lite

Convert a trained Keras model to TensorFlow Lite format:
bash

python convert.py input_model.keras output_model.tflite

Arguments:

    MODEL – Path to the trained Keras model file
    OUTPUT – Output filename for the TensorFlow Lite model

Example:
bash

python convert.py my_model.keras my_model.tflite

Output:

    TensorFlow Lite model saved as .tflite file (smaller, optimized for inference)
    Console message confirming successful conversion

Model Architecture

The CNN consists of:
Layer	Output Shape	Purpose
Input	128×128×3	RGB image input
Rescaling	128×128×3	Normalize pixels to [0, 1]
Conv2D (16 filters, stride 2)	64×64×16	Feature extraction
Conv2D (32 filters, stride 2)	32×32×32	Feature extraction
Conv2D (64 filters, stride 2)	16×16×64	Feature extraction
GlobalAveragePooling2D	64	Spatial dimension reduction
Conv2D (128 filters, 1×1)	128	Dense-equivalent layer
Conv2D (NUM_CLASSES filters, 1×1)	NUM_CLASSES	Classification logits

Key Features:

    Lightweight – Suitable for mobile and edge devices
    Strided convolutions – Replace pooling for efficiency
    1×1 convolutions – Implement dense layers for interpretability
    No activation on output – Raw logits for SparseCategoricalCrossentropy loss

Training Configuration

Adjust these parameters in train.py to customize training:
python

IMAGE_SIZE = 128          
# Input image dimensions (pixels)
BATCH_SIZE = 16           
# Number of images per batch
EPOCHS = 40               
# Number of training epochs
LEARNING_RATE = 0.001     
# Adam optimizer learning rate

Requirements

See requirements.txt for complete dependencies. Core packages:

    TensorFlow ≥ 2.13.0 – Deep learning framework
    Keras – High-level API (included with TensorFlow)
    NumPy – Numerical computing

Workflow Example
bash

# 1. Train the model on the dataset
  python train.py ./tomato_dataset trained_model.keras
# 2. Convert to TensorFlow Lite for deployment
  python convert.py trained_model.keras model.tflite
# 3. Deploy model.tflite to mobile app or edge device

Output Files

    .keras file – Full Keras model with weights (training-ready)
    .tflite file – Optimized TensorFlow Lite model (inference-only)

Future Enhancements

    Quantization for further model compression
    Data augmentation for improved robustness
    Transfer learning with pre-trained backbones (MobileNetV2, EfficientNet)
    Real-time inference app (mobile/web)
    Model evaluation metrics (precision, recall, F1-score)

Funding

This project was supported by NLnet, an organization that supports open source Internet technology.
License



Notes

    The model uses SparseCategoricalCrossentropy loss, which expects integer class labels (0, 1, 2, ...).
    Training time depends on dataset size and hardware (GPU recommended).
    The .tflite model currently uses no quantization — you can enable post-training quantization in convert.py for additional compression.
