//
//  CameraSessionManager.swift
//  ObjectRecognition
//
//  Created by Justin Lee on 2/11/23.
//

import AVFoundation
import UIKit
import Vision

protocol CameraSessionInterface {
    var captureSession: AVCaptureSession { get }
    var dataOutput: AVCaptureVideoDataOutput { get }
    
    static func videoOrientationFor(_ deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation
    
    func startRunning() async
}

extension CameraSessionInterface {
    static func videoOrientationFor(_ deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        switch deviceOrientation {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeRight
        case .landscapeRight: return .landscapeLeft
        default: return .portrait
        }
    }
}

class CameraSessionManager {
    static let shared = CameraSessionManager()
    
    static func videoOrientationFor(_ deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        switch deviceOrientation {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeRight
        case .landscapeRight: return .landscapeLeft
        default: return .portrait
        }
    }
    
    var requests = [VNRequest]()
    let dataOutput = AVCaptureVideoDataOutput()
    let captureSession = AVCaptureSession()
    
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    
    private init() { }
    
    func configureSession() {
        sessionQueue.async { [unowned self] in
            guard
                let captureDevice = AVCaptureDevice.default(for: .video),
                let inputDevice = try? AVCaptureDeviceInput(device: captureDevice)
            else { fatalError("Failed AV session configuration") }
            
            captureSession.beginConfiguration()
            captureSession.addInput(inputDevice)
            captureSession.addOutput(dataOutput)
            captureSession.commitConfiguration()

            captureSession.startRunning()
        }
    }
    
    func requestCameraAuthorizationIfNeeded() async {
        guard AVCaptureDevice.authorizationStatus(for: .video) != .authorized else { return }
        
        sessionQueue.suspend()
        await AVCaptureDevice.requestAccess(for: .video)
        sessionQueue.resume()
    }
}

extension CameraSessionManager: CameraSessionInterface {
    func startRunning() async {
        await requestCameraAuthorizationIfNeeded()
        configureSession()
    }
}
