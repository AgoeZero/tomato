Tomato Classifier App written in Scheme (LambdaNative)

Project Description

Tomato Leaf Disease Detector is a deep learning application designed to automatically classify diseases in tomato leaves using a lightweight convolutional neural network (CNN). The project provides an end-to-end pipeline for training a custom disease detection model and deploying it to mobile and edge devices.
What It Does

The project enables users to:

    Train a custom CNN model on a labeled dataset of tomato leaf images to learn disease patterns
    Convert the trained model to TensorFlow Lite format for efficient deployment on resource-constrained devices like smartphones and IoT devices

Key Components

    train.py – A training script that builds and trains a lightweight CNN architecture optimized for image classification. It processes a dataset organized by disease class and outputs a trained Keras model.
    convert.py – A conversion utility that transforms the trained Keras model into TensorFlow Lite format, reducing model size and enabling fast inference on edge devices.

Model Architecture

The CNN uses an efficient design with 3 convolutional layers (with strided convolutions for downsampling), global average pooling, and 1×1 convolutional layers acting as dense layers. This architecture is lightweight yet powerful enough for multi-class disease classification.
Use Case

The application is ideal for agricultural applications where farmers or agronomists need to quickly identify tomato leaf diseases in the field using mobile apps or offline devices. It supports any number of disease classes from the training dataset, making it flexible for different disease detection scenarios.
Technology Stack

Built with TensorFlow and Keras for training, the project leverages modern deep learning frameworks while maintaining simplicity and efficiency.

## Third-Party Software

### DemoCamera
Portions of this project are based on `DemoCamera`, originally
developed at the University of British Columbia.

### TinyMaix
This project uses the TinyMaix library by Lieff Lee and contributors.

TinyMaix is distributed under the [Apache License 2.0](LICENSE-THIRDPARTY).
