//
//  ContentView.swift
//  ios
//
//  Created by jatin foujdar on 03/04/25.
//

import SwiftUI
import SceneKit

struct GameView: UIViewRepresentable {
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.backgroundColor = .black
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showPhysicsShapes]
        
        // Create and setup the game scene
        let gameScene = GameScene()
        sceneView.scene = gameScene
        
        // Add some sample 3D models for preview
        gameScene.add3DModel(named: "model1", at: SCNVector3(0, 2, 0))
        gameScene.add3DModel(named: "model2", at: SCNVector3(2, 2, 0))
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update the view if needed
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            GameView()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("3D Physics Game")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#Preview{
        ContentView()
            .preferredColorScheme(.dark)
}



