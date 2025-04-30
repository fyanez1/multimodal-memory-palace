//
//  ARContentView.swift
//  arbasicapp
//
//  Created by Yasuhito Nagatomo on 2023/01/09.
//

import SwiftUI

extension Notification.Name {
    static let imageGenerated = Notification.Name("imageGenerated")
}

struct ARContentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var sceneScaleIndex = 1
    @State private var selectedModelIndex: Int? = nil
    @State private var generatedImage: UIImage? = nil

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
                    if let image = generatedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(12)
                            .padding()
                    }
                }
                .padding(40)
            }
            .onReceive(NotificationCenter.default.publisher(for: .imageGenerated)) { notif in
                if let url = notif.object as? URL,
                   let imgData = try? Data(contentsOf: url) {
                    generatedImage = UIImage(data: imgData)
                }
            }
    }

    private func scaleChange() {
        sceneScaleIndex = sceneScaleIndex == AppConfig.sceneScales.count - 1
                            ? 0 : sceneScaleIndex + 1
    }
    
    func generateImage() {
//        guard let url = URL(string: "http://18.29.252.208:8080/generate-image") else { return }
        guard let url = URL(string: "http://10.29.214.204:8080/generate-image") else { return }

        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let json: [String: String] = ["prompt": "apple"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        
        // new code
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 300  // 5 minutes
        config.timeoutIntervalForResource = 300
        let session = URLSession(configuration: config)
        //

//        URLSession.shared.dataTask(with: request) { data, response, error in
        session.dataTask(with: request) { data, response, error in
            if let data = data {
                let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = docsDir.appendingPathComponent("generated.png")
                try? data.write(to: fileURL)

                DispatchQueue.main.async {
                    // Store it in UserDefaults or an @State variable to show in the UI
                    // Here we notify via NotificationCenter (alternative: use ObservableObject)
                    NotificationCenter.default.post(name: .imageGenerated, object: fileURL)
                }
            }
        }.resume()
    }

}

struct ARContentView_Previews: PreviewProvider {
    static var previews: some View {
        ARContentView()
    }
}
