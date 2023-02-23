//
//  ImageAnalysisResultView.swift
//  ObjectRecognition
//
//  Created by Justin Lee on 2/23/23.
//

import SwiftUI

struct ImageAnalysisResultView: View {
    @ObservedObject var viewModel: ContentViewModel
    
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
