//
//  ContentView.swift
//  ObjectRecognition
//
//  Created by Justin Lee on 2/7/23.
//

import SwiftUI

struct ContentView: View {
    let viewModel = ContentViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            CameraView(camera: CameraSessionManager.shared, frameHandler: viewModel)
                .ignoresSafeArea(.all)
            ImageAnalysisResultView(viewModel: viewModel)
        }
    }
}

struct ImageAnalysisResultView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        HStack {
            Group {
                Text(viewModel.identifierText).bold() +
                Text("\n") +
                Text(viewModel.confidenceText)
            }
            .padding()
            .foregroundColor(.black)
            .background(.white)
            
            Spacer()
        }
        .padding()
    }
}
