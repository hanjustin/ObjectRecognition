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
    private let camera: CameraSessionInterface
    
    init(camera: CameraSessionInterface) {
        self.camera = camera
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePreviewLayer()
        Task {
            await camera.startRunning()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let connection = previewLayer.connection, connection.isVideoOrientationSupported else { return }
        updatePreviewLayer(for: size, and: UIDevice.current.orientation)
    }
    
    private func initializePreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: camera.captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
    }
    
    private func updatePreviewLayer(for newSize: CGSize, and newOrientation: UIDeviceOrientation) {
        previewLayer.frame = CGRect(origin: .zero, size: newSize)
        previewLayer.connection?.videoOrientation = CameraSessionManager.videoOrientationFor(newOrientation)
    }
}
