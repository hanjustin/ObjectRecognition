![Swift Version](https://img.shields.io/badge/Swift-5.7+-Green) ![Xcode](https://img.shields.io/badge/Xcode-14.2-blue) ![Platform iOS](https://img.shields.io/badge/platform-iOS-lightgrey) ![Contact](https://img.shields.io/badge/contact-justin.lee.iosdev%40gmail.com-yellowgreen)

# Demo
<p align="center">
  <img alt="ObjectDetectionDemo" src="./Demo/ObjectDetectionDemo.gif">
</p>

# Description
This sample project app uses iPhone back camera for live capture, incorporate a Core ML model into Vision, and parse results as classified objects.

# Requirements
* Swift 5.7+
* Xcode 14.2+
* [Resnet50 ML model from Apple site](https://developer.apple.com/machine-learning/models/)

# Folder Structure
    ├── ObjectRecognition App
        ├── Model
            ├── ImageClassificationAnalysis
        ├── View
            ├── ContentView
            ├── CameraView
            ├── CameraViewController
        ├── ViewModel
            ├── ContentViewModel
        ├── Utility
            ├── CameraSessionManager
            ├── ImageClassifier
