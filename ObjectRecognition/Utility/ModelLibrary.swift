//
//  ModelLibrary.swift
//  ObjectRecognition
//
//  Created by Justin Lee on 2/23/23.
//

import Vision

final class ModelLibrary {
    // TODO: - Add different ML models and allow users to select which one to use.
    
    static let resnet50 = {
        do {
            return try VNCoreMLModel(for: Resnet50(configuration: MLModelConfiguration()).model)
        } catch {
            // Download model from https://developer.apple.com/machine-learning/models/
            print("Error: Could not set up Restnet50 core ML model")
            fatalError("Please make sure Restnet50 core ML model is in the project.")
        }
    }()
}
