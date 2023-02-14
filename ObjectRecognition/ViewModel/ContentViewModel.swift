//
//  ContentViewModel.swift
//  ObjectRecognition
//
//  Created by Justin Lee on 2/11/23.
//

import Foundation
import Vision

class ContentViewModel: ObservableObject, FrameHandler {
    @Published private(set) var analysis: ImageClassificationAnalysis?
    
    var resultDisplayText: String {
        identifierText + "\n" + confidenceText
    }
    
    var identifierText: String {
        guard let analysis else { return UIConstants.defaultText }
        let eachPossibleIdentifierInNewLine = analysis.identifier.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.joined(separator: "\n")
        
        return eachPossibleIdentifierInNewLine
    }
    
    var confidenceText: String {
        let percentage = String(format: "%.3f", (analysis?.confidence ?? 0) * 100)
        return "Confidence: \(percentage) %"
    }
    
    init() {
        ImageClassifier.shared.delegate = self
    }
    
    func handleNewFrame(with pixelBuffer: CVImageBuffer) {
        ImageClassifier.shared.gatherObservations(for: pixelBuffer)
    }
    
    private func handleNewAnalysis() {
        
    }
}

extension ContentViewModel: ImageClassifierDelegate {
    func didIdentifyNewObject(handle newAnalysis: ImageClassificationAnalysis) {
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
