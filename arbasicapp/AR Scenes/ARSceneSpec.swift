//
//  ARSceneSpec.swift
//  arbasicapp
//
//  Created by Yasuhito Nagatomo on 2023/01/08.
//

import Foundation

final class ARSceneSpec {
    struct AnimationParam {
        let center: SIMD3<Float>
        let radius: Float // [m]
        let angularVelocity: Float // [radian/sec]
    }
    struct ModelSpec {
        let fileName: String
        let soundFileName: String?
        let animationParam: AnimationParam
        let scale: SIMD3<Float>
    }
    static let models: [ModelSpec] = [
        ModelSpec(fileName: "toy_robot_vintage",
                  soundFileName: "robotSound.mp3",
                  animationParam: AnimationParam(center: .zero,
                                 radius: 0.1,
                                 angularVelocity: Float.pi / 6.0),
                  scale: SIMD3<Float>(0.005, 0.005, 0.005)
                 ),
        ModelSpec(fileName: "toy_biplane",
                  soundFileName: "planeSound.mp3",
                  animationParam: AnimationParam(center: SIMD3<Float>(-0.2, 0.25, -0.1),
                                 radius: 0.1,
                                 angularVelocity: Float.pi / 5.0),
                  scale: SIMD3<Float>(0.005, 0.005, 0.005)),
    
        ModelSpec(fileName: "toy_car",
                  soundFileName: "carSound.mp3",
                  animationParam: AnimationParam(center: SIMD3<Float>(0.1, 0, 0.1),
                                 radius: 0.1,
                                 angularVelocity: -Float.pi / 4.0),
                  scale: SIMD3<Float>(0.005, 0.005, 0.005)),
        ModelSpec(fileName: "Classic_guitar",
                  soundFileName: "bossa-nova-eletric-guitar-loop-258055.mp3",
                  animationParam: AnimationParam(center: .zero,
                                 radius: 0.0,
                                 angularVelocity: Float.pi / 0.0),
                  scale: SIMD3<Float>(0.0003, 0.0003, 0.0003))
    ]
    static let position: SIMD3<Float> = .zero
}
