//
//  ARContentView.swift
//
//

import SwiftUI
import AVFoundation

extension Notification.Name {
    static let imageGenerated = Notification.Name("imageGenerated")
    static let audioGenerated = Notification.Name("audioGenerated")
}

struct ARContentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var sceneScaleIndex = 1
    @State private var selectedModelIndex: Int? = nil
    @State private var generatedImage: UIImage? = nil
    @State private var imageGenerationProgress: String = ""
    @State private var audioGenerationProgress: String = ""
    @State private var imagePromptText: String = ""
    @State private var audioPromptText: String = ""

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
                    
                    // Image Generation 
                    VStack(spacing: 10) {
                        if !imageGenerationProgress.isEmpty {
                            Text(imageGenerationProgress)
                                .foregroundColor(.white)
                                .padding(.top, 10)
                        }
                        
                        HStack {
                            TextField("Enter image prompt", text: $imagePromptText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                            Button("Generate Image") {
                                generateImage()
                                selectedModelIndex = 999
                                ModelSelection.shared.selectedIndex = 999
                            }
                            .padding()
                            .background(.purple)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                        }
                    }
                    
                    // Audio Generation
                    VStack(spacing: 10) {
                        if !audioGenerationProgress.isEmpty {
                            Text(audioGenerationProgress)
                                .foregroundColor(.white)
                                .padding(.top, 10)
                        }
                        
                        HStack {
                            TextField("Enter audio prompt", text: $audioPromptText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                            Button("Generate Audio") {
                                generateAudio()
                            }
                            .padding()
                            .background(.blue)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                        }
                    }
                }
                .padding(40)
            }
            .onReceive(NotificationCenter.default.publisher(for: .imageGenerated)) { notif in
            }
            .onReceive(NotificationCenter.default.publisher(for: .audioGenerated)) { notif in
            }
    }

    private func scaleChange() {
        sceneScaleIndex = sceneScaleIndex == AppConfig.sceneScales.count - 1
                            ? 0 : sceneScaleIndex + 1
    }
    
    func generateImage() {
        guard let url = URL(string: "http://10.29.214.204:8080/generate-image") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let json: [String: String] = ["prompt": imagePromptText]
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)

        imageGenerationProgress = "Starting..."

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 300
        config.timeoutIntervalForResource = 300
        let session = URLSession(configuration: config)

        session.dataTask(with: request) { data, response, error in
            if let data = data {
                let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = docsDir.appendingPathComponent("generated.png")
                try? data.write(to: fileURL)

                DispatchQueue.main.async {
                    imageGenerationProgress = "Image done!"
                    NotificationCenter.default.post(name: .imageGenerated, object: fileURL)
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    imageGenerationProgress = "Error: \(error.localizedDescription)"
                }
            }
        }.resume()

        imageGenerationProgress = "Generating image..."
    }
    
    func generateAudio() {
        guard let url = URL(string: "http://10.29.214.204:8080/generate-audio") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let json: [String: Any] = [
            "prompt": audioPromptText,
            "audio_length_in_s": 5.0,
            "num_inference_steps": 50
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)

        audioGenerationProgress = "Starting..."

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 300
        config.timeoutIntervalForResource = 300
        let session = URLSession(configuration: config)

        session.dataTask(with: request) { data, response, error in
            if let data = data {
                let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = docsDir.appendingPathComponent("generated.wav")
                try? data.write(to: fileURL)

                DispatchQueue.main.async {
                    audioGenerationProgress = "Audio done!"
                    NotificationCenter.default.post(name: .audioGenerated, object: fileURL)
                    
                    // Store the audio path globally so it can be accessed for playback
                    AudioManager.shared.audioURL = fileURL
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    audioGenerationProgress = "Error: \(error.localizedDescription)"
                }
            }
        }.resume()

        audioGenerationProgress = "Generating audio..."
    }
}

class AudioManager {
    static let shared = AudioManager()
    var audioURL: URL?
}


struct ARContentView_Previews: PreviewProvider {
    static var previews: some View {
        ARContentView()
    }
}
