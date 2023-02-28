//
//  ContentViewModel.swift
//  ObjectRecognition
//
//  Created by Justin Lee on 2/11/23.
//

import Foundation
import Vision

class ContentViewModel: ObservableObject, FrameHandler {
    @Published private(set) var analysis: ImageClassificationAnalysisResult?
    private let classifier: ObjectClassifier
    let camera: CameraSessionInterface
    var mlModel: VNCoreMLModel
    
    var resultDisplayText: String {
        identifierText + "\n" + confidenceText
    }
    
    var identifierText: String {
        guard let analysis else { return UIConstants.defaultText }
        let eachPossibleIdentifierInNewLine =
            analysis.identifier
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .joined(separator: "\n")
        return eachPossibleIdentifierInNewLine
    }
    
    var confidenceText: String {
        let percentage = String(format: "%.3f", (analysis?.confidence ?? 0) * 100)
        return "Confidence: \(percentage) %"
    }
    
    init(camera: CameraSessionInterface, classifier: ObjectClassifier, mlModel: VNCoreMLModel) {
        self.camera = camera
        self.classifier = classifier
        self.mlModel = mlModel
        classifier.delegate = self
    }
    
    func handleNewFrame(with pixelBuffer: CVImageBuffer) {
        classifier.handleNewImage(with: pixelBuffer, using: mlModel)
    }
}

extension ContentViewModel: ObjectClassifierDelegate {
    func didIdentifyNewObject(handle newAnalysis: ImageClassificationAnalysisResult) {
        let isSameIdentification = newAnalysis.identifier == (analysis?.identifier ?? "")
        let hasLowerConfidence = newAnalysis.confidence < (analysis?.confidence ?? -Float.greatestFiniteMagnitude)
        let isNoise = isSameIdentification && hasLowerConfidence
        
        if isNoise == false {
            analysis = newAnalysis
        }
    }
    
    private enum UIConstants {
        static let defaultText = "Waiting on camera. Please check camera authorization."
    }
}
