//
//  ARView.swift
//  Coconut
//
//  Created by sh on 9/16/21.
//

import Foundation
import ARKit
import SwiftUI

struct ARView: UIViewRepresentable {
    let arDelegate:ChatViewModel
    
    func makeUIView(context: Context) -> some UIView {
        let arView = ARSCNView(frame: .zero)
        arDelegate.setARView(arView)
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
