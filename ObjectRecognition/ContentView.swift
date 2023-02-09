//
//  ContentView.swift
//  ObjectRecognition
//
//  Created by Justin Lee on 2/7/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            CameraView()
                .ignoresSafeArea(.all)
            HStack {
                Text("Hello WORLD")
                    .padding()
                    .foregroundColor(.red)
                    .background(.white)
                    
                Spacer()
            }
            .padding()
        }
    }
}
