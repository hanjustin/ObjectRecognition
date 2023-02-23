//
//  ObjectClassifier.swift
//  ObjectRecognition
//
//  Created by Justin Lee on 2/12/23.
//

import AVFoundation
import Vision

protocol ObjectClassifierDelegate: AnyObject {
    func didIdentifyNewObject(handle analysis: ImageClassificationAnalysisResult)
}

class ObjectClassifier {
    static let shared = ObjectClassifier()
    weak var delegate: ObjectClassifierDelegate?
    
    func handleNewImage(with pixelBuffer: CVImageBuffer, using model: VNCoreMLModel ) {
        do {
            let coreMLAnalysisRequest = VNCoreMLRequest(model: model, completionHandler: analysisCompletionHandler)
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
            try imageRequestHandler.perform([coreMLAnalysisRequest])
        } catch { print(error) }
    }
    
    private func analysisCompletionHandler(request: VNRequest, error: Error?) {
        guard
            let results = request.results as? [VNClassificationObservation],
            let firstObservation = results.first
        else { return }
        
        Task { @MainActor in
            let analysisResult = ImageClassificationAnalysisResult(VNData: firstObservation)
            self.delegate?.didIdentifyNewObject(handle: analysisResult)
        }
    }
}
