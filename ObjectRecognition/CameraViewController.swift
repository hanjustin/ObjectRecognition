//
//  CameraViewController.swift
//  ObjectRecognition
//
//  Created by Justin Lee on 2/7/23.
//

import UIKit
import AVKit
import Vision

class CameraViewController: UIViewController {
    
    private var previewLayer = AVCaptureVideoPreviewLayer()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private lazy var lazyPreviewLayer = {
        return AVCaptureVideoPreviewLayer()
    }()
    
    let captureSession = AVCaptureSession()
    var requests = [VNRequest]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVision()
        
        // TODO: - Refactor by having CameraManager to manage AVsession & use actor instead of GCD
        
        Task {
            var isVideoAuthorized = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
            sessionQueue.suspend()
            if !isVideoAuthorized {
                isVideoAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            sessionQueue.resume()
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
            previewLayer.frame = view.frame
            configureSession()
        }
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
            }
            
            self.requests = [objectRecognition]
        } catch { print("Error: Could not set up Vision") }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            previewLayer.frame = CGRect(origin: .zero, size: size)
            guard let connection = previewLayer.connection, connection.isVideoOrientationSupported else { return }
            connection.videoOrientation = videoOrientationFor(UIDevice.current.orientation)
        })
    }
    
    private func videoOrientationFor(_ deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        switch deviceOrientation {
        case .portrait: return AVCaptureVideoOrientation.portrait
        case .portraitUpsideDown: return AVCaptureVideoOrientation.portraitUpsideDown
        case .landscapeLeft: return AVCaptureVideoOrientation.landscapeRight
        case .landscapeRight: return AVCaptureVideoOrientation.landscapeLeft
        default: return .portrait
        }
    }
    
    func configureSession() {
        sessionQueue.async { [unowned self] in
            guard
                let captureDevice = AVCaptureDevice.default(for: .video),
                let inputDevice = try? AVCaptureDeviceInput(device: captureDevice)
            else { fatalError("Failed AV session configuration") }
            
            captureSession.beginConfiguration()
            captureSession.addInput(inputDevice)
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            captureSession.addOutput(dataOutput)
            captureSession.commitConfiguration()
            
            captureSession.startRunning()
        }
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = videoOrientationFor(UIDevice.current.orientation) // Set video orientation for object recognition
        
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        do {
            // VIDEOQUEUE
            try imageRequestHandler.perform(self.requests)
        } catch { print(error) }
    }
}


func printCurrentThread() {
    let cName = __dispatch_queue_get_label(nil)
    let name = String(cString: cName, encoding: .utf8)
    print(name)
}
