//
//  ImageClassificationAnalysisResult.swift
//  ObjectRecognition
//
//  Created by Justin Lee on 2/12/23.
//

import Foundation
import Vision

struct ImageClassificationAnalysisResult {
    var identifier: String
    var confidence: Float
    
    init(VNData data: VNClassificationObservation) {
        self.identifier = data.identifier
        self.confidence = data.confidence
    }
}
