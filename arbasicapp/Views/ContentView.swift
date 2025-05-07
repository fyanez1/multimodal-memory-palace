//
//  ContentView.swift
//
//

import SwiftUI

struct ContentView: View {
    @State private var showingAR = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors:
                                [Color("HomeBGColor"), .black]),
                           startPoint: .top, endPoint: .bottomTrailing)

            VStack {
                Spacer()

                Text("Multimodal Memory Palace")
                    .font(.title)

                Spacer()

                Button(action: showAR) {
                    Text("Show Memory Palace")
                        .font(.title2)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 60)
            }
        }
        .foregroundColor(.white)
        .fullScreenCover(isPresented: $showingAR) {
            ARContentView()
        }
    }

    private func showAR() {
        showingAR = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().ignoresSafeArea()
    }
}
