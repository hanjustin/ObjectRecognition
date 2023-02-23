//
//  ContentView.swift
//  ObjectRecognition
//
//  Created by Justin Lee on 2/7/23.
//

import SwiftUI

struct ContentView: View {
    let viewModel: ContentViewModel
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            CameraView(camera: viewModel.camera, frameHandler: viewModel)
                .ignoresSafeArea(.all)
            ImageAnalysisResultView(viewModel: viewModel)
        }
    }
}
