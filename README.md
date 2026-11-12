
# Tomato Classifier App

A tomato leaf disease classification application written in Scheme using [LambdaNative](https://github.com/bkmgit/lambdanative).

## Project Description

**Tomato Leaf Disease Detector** is a deep learning application designed to automatically identify and classify diseases in tomato leaves using a lightweight Convolutional Neural Network (CNN).

The project provides an end-to-end pipeline for training a custom disease classification model and deploying it to mobile and resource-constrained edge devices.

## Features

The project provides the following capabilities:

- **Disease Classification:** Train a custom CNN model using a labelled dataset of tomato leaf images to recognize different disease patterns.
- **Model Conversion:** Convert trained models to TensorFlow Lite format for efficient deployment.
- **Edge Deployment:** Support lightweight inference on resource-constrained devices, including smartphones and IoT devices.
- **Flexible Classification:** Support multiple disease classes based on the structure of the training dataset.

## Project Structure

| File | Description |
|---|---|
| `train.py` | Builds and trains a lightweight CNN architecture using a dataset organized into disease-class directories. Outputs a trained Keras model. |
| `convert.py` | Converts the trained Keras model into TensorFlow Lite format for efficient deployment on edge devices. |

## Model Architecture

The classification model uses a lightweight CNN architecture designed to balance accuracy and computational efficiency.

Its main components include:

- Three convolutional layers with strided convolutions for spatial downsampling.
- Global Average Pooling to reduce the number of parameters.
- 1×1 convolutional layers that serve as fully connected layers for classification.

This architecture provides an efficient solution for multi-class tomato leaf disease classification, particularly on devices with limited computational resources.

## Use Cases

The application is intended for agricultural use cases where farmers, agricultural extension officers, and agronomists need to identify tomato leaf diseases quickly in the field.

By deploying the classifier on mobile and offline-capable devices, users can perform disease classification without requiring a continuous internet connection.

## Technology Stack

- **Scheme:** Application development using LambdaNative.
- **C:** Native application and inference integration.
- **Python:** Model training and conversion utilities.
- **TensorFlow / Keras:** Deep learning model development and training.
- **TensorFlow Lite:** Model conversion and optimized inference.
- **TinyMaix:** Lightweight neural network inference on embedded and resource-constrained devices.

## Third-Party Software

### DemoCamera

Portions of this project are based on `DemoCamera`, originally developed at the University of British Columbia.

### TinyMaix

This project uses the [TinyMaix](https://github.com/sipeed/TinyMaix) library.

TinyMaix is distributed under the Apache License 2.0. See [`LICENSE-THIRDPARTY`](LICENSE-THIRDPARTY) for licensing information.

## Funding

This project is funded through
[NGI Mobifree Fund](https://nlnet.nl/mobifree), a fund established by
[NLnet](https://nlnet.nl) with financial support from the European
Commission's [Next Generation Internet](https://ngi.eu) program. Learn
more at the [NLnet project page](https://nlnet.nl/project/F-Droid-LambdaNative).

[<img src="https://nlnet.nl/logo/banner.png" alt="NLnet foundation logo"
width="20%" />](https://nlnet.nl)

