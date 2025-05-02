//
//  EntityExtensions.swift
//  arbasicapp
//
//  Created by Fabian Yanez-Laguna on 5/1/25.
//

import RealityKit
import UIKit
import AVFoundation

extension Entity {
    // Add tap gesture handler to entity
    func addTapListener(arView: ARView) {
        let tapGesture = UITapGestureRecognizer(target: nil, action: nil)
        arView.addGestureRecognizer(tapGesture)
        
        tapGesture.addTarget(self, action: #selector(handleTap(_:)))
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let arView = recognizer.view as? ARView else { return }
        
        let tapLocation = recognizer.location(in: arView)
        
        // Perform ray cast from tap location
        if let entity = arView.entity(at: tapLocation) {
            // If this is the entity that was tapped
            if entity.id == self.id {
                // Play the audio
//                AudioManager.shared.playAudio()
                if let audioURL = AudioManager.shared.audioURL {
                    let resource = try? AudioFileResource.load(contentsOf: audioURL,
                                                               inputMode: .spatial,
                                                               loadingStrategy: .preload,
                                                               shouldLoop: true)  // ✅ Enable looping
                    if let resource = resource {
                        let audioEntity = ModelEntity()
                        audioEntity.position = [0, 0, 0]  // Local position relative to image entity

                        let controller = audioEntity.prepareAudio(resource)
                        controller.gain = -6
                        controller.play()

                        entity.addChild(audioEntity)  // Attach audio to the image entity
                    }
                }


            }
        }
    }
}
