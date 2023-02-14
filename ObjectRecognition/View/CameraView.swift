//
//  CameraView.swift
//  ObjectRecognition
//
//  Created by Justin Lee on 2/7/23.
//

import SwiftUI
import AVKit

protocol FrameHandler {
    func handleNewFrame(with imageBuffer: CVImageBuffer)
}

struct CameraView {
    private let frameHandler: FrameHandler
    private let camera: CameraSessionInterface
    
    init(camera: CameraSessionInterface ,frameHandler: FrameHandler) {
        self.camera = camera
        self.frameHandler = frameHandler
    }
}

extension CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CameraViewController
    
    func makeUIViewController(context: Context) -> CameraViewController {
        CameraViewController(camera: camera)
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(camera: camera, didGetNewFrame: frameHandler.handleNewFrame)
    }
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        let camera: CameraSessionInterface
        let didGetNewFrame: (CVImageBuffer) -> Void
        
        init(camera: CameraSessionInterface, didGetNewFrame: @escaping (CVImageBuffer) -> Void) {
            self.camera = camera
            self.didGetNewFrame = didGetNewFrame
            super.init()
            camera.dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            connection.videoOrientation = type(of: camera).videoOrientationFor(UIDevice.current.orientation)
            guard let pixelBuffer = sampleBuffer.imageBuffer else { return }
            didGetNewFrame(pixelBuffer)
        }
    }
}
