//
//  ARContainerView.swift
//
//

import SwiftUI

struct ARContainerView: UIViewControllerRepresentable {
    let sceneScale: SIMD3<Float>

    func makeUIViewController(context: Context) -> ARViewController {
        let arVC = ARViewController()
        arVC.setup()
        return arVC
    }

    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {
        uiViewController.update(sceneScale: sceneScale)
    }
}

struct ARContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ARContainerView(sceneScale: .one)
    }
}
