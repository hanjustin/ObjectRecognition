//
//  ImageClassifier.swift
//  ObjectRecognition
//
//  Created by Justin Lee on 2/12/23.
//

import AVFoundation
import Vision

protocol ImageClassifierDelegate: AnyObject {
    func didIdentifyNewObject(handle analysis: ImageClassificationAnalysis)
}

class ImageClassifier {
    static let shared = ImageClassifier()
    weak var delegate: ImageClassifierDelegate?
    
    var requests = [VNRequest]()
    
    private init() {
        setupVision()
    }
    
    func setupVision() {
        do {
            let visionModel = try VNCoreMLModel(for: Resnet50(configuration: MLModelConfiguration()).model)
            let objectRecognition = VNCoreMLRequest(model: visionModel) { (request, error) in
                guard
                    let results = request.results as? [VNClassificationObservation],
                    let firstObservation = results.first
                else { return }
                
                Task { @MainActor in
                    let analysis = ImageClassificationAnalysis(VNData: firstObservation)
                    self.delegate?.didIdentifyNewObject(handle: analysis)
                }
            }
            
            requests = [objectRecognition]
        } catch {
            // Download model from https://developer.apple.com/machine-learning/models/
            print("Error: Could not set up Vision")
            fatalError("Please make sure Restnet50 core ML model is in the project.")
        }
    }
    
    func gatherObservations(for pixelBuffer: CVImageBuffer) {
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        do {
            try imageRequestHandler.perform(requests)
        } catch { print(error) }
    }
}
