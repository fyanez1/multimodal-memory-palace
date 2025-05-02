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
                AudioManager.shared.playAudio()
            }
        }
    }
}
