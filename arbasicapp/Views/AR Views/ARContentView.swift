////
////  ARContentView.swift
////  arbasicapp
////
////  Created by Yasuhito Nagatomo on 2023/01/09.
////
//
//import SwiftUI
//
//extension Notification.Name {
//    static let imageGenerated = Notification.Name("imageGenerated")
//}
//
//struct ARContentView: View {
//    @Environment(\.dismiss) var dismiss
//    @State private var sceneScaleIndex = 1
//    @State private var selectedModelIndex: Int? = nil
//    @State private var generatedImage: UIImage? = nil
//    @State private var generationProgress: String = ""
//    @State private var promptText: String = ""
//
//    private var sceneScale: SIMD3<Float> {
//        AppConfig.sceneScales[sceneScaleIndex]
//    }
//
//    var body: some View {
//        ARContainerView(sceneScale: sceneScale)
//            .overlay {
//                VStack {
//                    HStack {
//                        Spacer()
//                        Button(action: dismiss.callAsFunction) {
//                            Image(systemName: "xmark.circle")
//                                .font(.system(size: 40))
//                        }
//                    }
//
//                    Text("Tap a plane to place models.")
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(.white.opacity(0.3))
//                        .cornerRadius(10)
//
//                    Spacer()
//
//                    HStack {
//                        Spacer()
//
//                        Button(action: scaleChange, label: {
//                            Image(systemName: "plus.magnifyingglass")
//                                .font(.system(size: 50))
//                                .padding()
//                        })
//                    }
//                    
//                    if !generationProgress.isEmpty {
//                        Text(generationProgress)
//                            .foregroundColor(.white)
//                            .padding(.top, 10)
//                    }
//                    
//                    HStack {
//                        TextField("Enter prompt", text: $promptText)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding()
//
//                        Button("Generate Image") {
//                            generateImage()
//                            selectedModelIndex = 999
//                            ModelSelection.shared.selectedIndex = 999
//                        }
//                        .padding()
//                        .background(.purple)
//                        .cornerRadius(8)
//                        .foregroundColor(.white)
//                    }
//
//                }
//                .padding(40)
//            }
//            .onReceive(NotificationCenter.default.publisher(for: .imageGenerated)) { notif in
////                if let url = notif.object as? URL,
////                   let imgData = try? Data(contentsOf: url) {
////                    generatedImage = UIImage(data: imgData)
////                }
//            }
//    }
//
//    private func scaleChange() {
//        sceneScaleIndex = sceneScaleIndex == AppConfig.sceneScales.count - 1
//                            ? 0 : sceneScaleIndex + 1
//    }
//    
////    func generateImage() {
////        guard let url = URL(string: "http://10.29.214.204:8080/generate-image") else { return }
////
////        
////        var request = URLRequest(url: url)
////        request.httpMethod = "POST"
////        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////
////        let json: [String: String] = ["prompt": "apple"]
////        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
////        
////        
////        // new code
////        let config = URLSessionConfiguration.default
////        config.timeoutIntervalForRequest = 300  // 5 minutes
////        config.timeoutIntervalForResource = 300
////        let session = URLSession(configuration: config)
////        //
////
//////        URLSession.shared.dataTask(with: request) { data, response, error in
////        session.dataTask(with: request) { data, response, error in
////            if let data = data {
////                let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
////                let fileURL = docsDir.appendingPathComponent("generated.png")
////                try? data.write(to: fileURL)
////
////                DispatchQueue.main.async {
////                    // Store it in UserDefaults or an @State variable to show in the UI
////                    // Here we notify via NotificationCenter (alternative: use ObservableObject)
////                    NotificationCenter.default.post(name: .imageGenerated, object: fileURL)
////                }
////            }
////        }.resume()
////    }
//    func generateImage() {
//        guard let url = URL(string: "http://10.29.214.204:8080/generate-image") else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let json: [String: String] = ["prompt": promptText]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
//
//        generationProgress = "Starting..."
//
//        let config = URLSessionConfiguration.default
//        config.timeoutIntervalForRequest = 300
//        config.timeoutIntervalForResource = 300
//        let session = URLSession(configuration: config)
//
//        session.dataTask(with: request) { data, response, error in
//            if let data = data {
//                let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                let fileURL = docsDir.appendingPathComponent("generated.png")
//                try? data.write(to: fileURL)
//
//                DispatchQueue.main.async {
//                    generationProgress = "Done!"
//                    NotificationCenter.default.post(name: .imageGenerated, object: fileURL)
//                }
//            } else if let error = error {
//                DispatchQueue.main.async {
//                    generationProgress = "Error: \(error.localizedDescription)"
//                }
//            }
//        }.resume()
//
//        generationProgress = "Generating..."
//    }
//
//
//}
//
//struct ARContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ARContentView()
//    }
//}


//
//  ARContentView.swift
//  arbasicapp
//
//  Created by Yasuhito Nagatomo on 2023/01/09.
//
//
//  ARContentView.swift
//  arbasicapp
//
//  Created by Yasuhito Nagatomo on 2023/01/09.
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
                    
                    // Image Generation Section
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
                    
                    // Audio Generation Section
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
                // This is kept empty as in original code
            }
            .onReceive(NotificationCenter.default.publisher(for: .audioGenerated)) { notif in
                // This is for future use if needed
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

// Singleton to manage the audio URL
//class AudioManager {
//    static let shared = AudioManager()
//    var audioURL: URL?
//    var audioPlayer: AVAudioPlayer?
//    
//    func playAudio() {
//        guard let url = audioURL else { return }
//        
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//            audioPlayer?.prepareToPlay()
//            audioPlayer?.play()
//        } catch {
//            print("Could not play audio: \(error.localizedDescription)")
//        }
//    }
//}

class AudioManager {
    static let shared = AudioManager()
    var audioURL: URL?
}


struct ARContentView_Previews: PreviewProvider {
    static var previews: some View {
        ARContentView()
    }
}
