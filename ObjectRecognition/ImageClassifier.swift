//
//  ImageClassifier.swift
//  ObjectRecognition
//
//  Created by Justin Lee on 2/12/23.
//

import AVFoundation
import Vision

protocol ImageClassifierDelegate: AnyObject {
    func identifiedNewObjectWith(classification: String, confidence: Float)
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
                
                // VIDEO QUEUE
                print(firstObservation.identifier, firstObservation.confidence)
                Task { @MainActor in
                    self.delegate?.identifiedNewObjectWith(classification: firstObservation.identifier, confidence: firstObservation.confidence)
                }
            }
            
            self.requests = [objectRecognition]
        } catch {
            print("Error: Could not set up Vision")
            
        }
    }
    
    func gatherObservations(pixelBuffer: CVImageBuffer) {
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        do {
            try imageRequestHandler.perform(requests)
        } catch { print(error) }
    }
}
