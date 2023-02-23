//
//  ObjectRecognitionApp.swift
//  ObjectRecognition
//
//  Created by Justin Lee on 2/7/23.
//

import SwiftUI

@main
struct ObjectRecognitionApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            let viewModel = ContentViewModel(camera: CameraSessionManager.shared,
                                             classifier: ObjectClassifier.shared,
                                             mlModel: ModelLibrary.resnet50)
            ContentView(viewModel: viewModel)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                UIApplication.shared.isIdleTimerDisabled = true
            }
        }
    }
}
