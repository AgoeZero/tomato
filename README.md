# Tomato Leaf Disease Detector

A tomato leaf disease classification application written in Scheme using [LambdaNative](https://github.com/bkmgit/lambdanative).

## About

Tomato Leaf Disease Detector is an experimental image-classification application that uses a lightweight convolutional neural network (CNN) to identify tomato leaf diseases represented in its training dataset.

The project includes a model-training and conversion pipeline, plus an Android application designed to run inference locally on the device. The application is intended to explore offline machine learning for agriculture and resource-constrained devices.

## Features

- Classifies tomato leaf images into disease categories represented in the training dataset.
- Uses a custom-trained, lightweight CNN.
- Runs image classification locally, without requiring a continuous internet connection.
- Converts the trained model for lightweight inference with TinyMaix.
- Supports mobile and other resource-constrained devices.

## Model training and conversion

The workflow is:

1. Train a CNN using labelled tomato leaf images organized by disease class.
2. Convert the trained model to TensorFlow Lite format.
3. Convert and optimize the model for deployment with TinyMaix.
4. Integrate the model into the LambdaNative application for on-device classification.

The CNN uses three convolutional layers with strided convolutions, global average pooling, and 1×1 convolutional layers for classification.

## Project structure

| File | Description |
|---|---|
| `train.py` | Builds and trains a lightweight CNN using a dataset organized into disease-class directories. |
| `convert.py` | Converts the trained Keras model to TensorFlow Lite format. |

## Download

[Download Tomato Leaf Disease Detector for Android (APK)](https://github.com/AgoeZero/tomato/actions/runs/44742868535/artifacts/14632820982)

This link points to a specific GitHub Actions artifact and may expire. For a link that stays consistent across builds, publish the APK as a GitHub Release asset.

## Technology stack

- **Scheme and LambdaNative:** Application development
- **C:** Native application and inference integration
- **Python:** Model training and conversion utilities
- **TensorFlow / Keras:** Model development and training
- **TensorFlow Lite:** Model conversion and optimization
- **TinyMaix:** Lightweight neural-network inference

## Third-party software

### DemoCamera

Portions of this project are based on DemoCamera, originally developed at the University of British Columbia.

### TinyMaix

This project uses the [TinyMaix library](https://github.com/xxradar/TinyMaix) by Lieff Lee and contributors. TinyMaix is distributed under the Apache License 2.0. See [`LICENSE-THIRDPARTY`](LICENSE-THIRDPARTY) for licensing information.

## Funding

This project is funded through the [NGI Mobifree Fund](https://nlnet.nl/mobifree), established by [NLnet](https://nlnet.nl/) with financial support from the European Commission’s [Next Generation Internet](https://ngi.eu) program. Learn more on the [NLnet project page](https://nlnet.nl/project/F-Droid-LambdaNative).

[![NLnet Foundation logo](https://nlnet.nl/logo/banner.png)](https://nlnet.nl/)

## Disclaimer

This application is intended for educational and experimental research purposes. Its predictions are based on the categories represented in its training dataset and should not be considered a substitute for professional agricultural advice or laboratory diagnosis.

## License

See the repository’s license file for licensing information.
