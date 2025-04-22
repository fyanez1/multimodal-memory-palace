//
//  ARContentView.swift
//  arbasicapp
//
//  Created by Yasuhito Nagatomo on 2023/01/09.
//

import SwiftUI

struct ARContentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var sceneScaleIndex = 1
    @State private var selectedModelIndex: Int? = nil

    private var sceneScale: SIMD3<Float> {
        AppConfig.sceneScales[sceneScaleIndex]
    }

    var body: some View {
        ARContainerView(sceneScale: sceneScale)
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: dismiss.callAsFunction) {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 40))
                        }
                    }

                    Text("Tap a plane to place models.")
                        .foregroundColor(.white)
                        .padding()
                        .background(.white.opacity(0.3))
                        .cornerRadius(10)

                    Spacer()

                    HStack {
                        Spacer()

                        Button(action: scaleChange, label: {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.system(size: 50))
                                .padding()
                        })
                    }
                    
                    HStack {
                        Button("Guitar") {
                            selectedModelIndex = 3
                            ModelSelection.shared.selectedIndex = 3
                        }
                        .padding()
                        .background(.red)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        
                        Button("Car") {
                            selectedModelIndex = 2
                            ModelSelection.shared.selectedIndex = 2
                        }
                        .padding()
                        .background(.blue)
                        .cornerRadius(8)
                        .foregroundColor(.white)

                        Button("Plane") {
                            selectedModelIndex = 1
                            ModelSelection.shared.selectedIndex = 1
                        }
                        .padding()
                        .background(.green)
                        .cornerRadius(8)
                        .foregroundColor(.white)

                        Button("Robot") {
                            selectedModelIndex = 0
                            ModelSelection.shared.selectedIndex = 0
                        }
                        .padding()
                        .background(.red)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    }
                }
                .padding(40)
            }
    }

    private func scaleChange() {
        sceneScaleIndex = sceneScaleIndex == AppConfig.sceneScales.count - 1
                            ? 0 : sceneScaleIndex + 1
    }
}

struct ARContentView_Previews: PreviewProvider {
    static var previews: some View {
        ARContentView()
    }
}
