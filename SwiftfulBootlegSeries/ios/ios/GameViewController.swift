import UIKit
import SceneKit

class GameViewController: UIViewController {
    private var sceneView: SCNView!
    private var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
        setupGameScene()
        setupGestures()
    }
    
    private func setupSceneView() {
        sceneView = SCNView(frame: view.bounds)
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sceneView.backgroundColor = .black
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showPhysicsShapes]
        view.addSubview(sceneView)
    }
    
    private func setupGameScene() {
        gameScene = GameScene()
        sceneView.scene = gameScene
        
        // Add some sample 3D models
        gameScene.add3DModel(named: "model1", at: SCNVector3(0, 2, 0))
        gameScene.add3DModel(named: "model2", at: SCNVector3(2, 2, 0))
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        sceneView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)
        
        if let hitNode = hitResults.first?.node {
            // Apply force to the tapped object
            let force = SCNVector3(0, 5, 0)
            hitNode.physicsBody?.applyForce(force, asImpulse: true)
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)
        
        if let hitNode = hitResults.first?.node {
            let translation = gesture.translation(in: sceneView)
            let force = SCNVector3(Float(translation.x) * 0.1, 0, Float(translation.y) * 0.1)
            hitNode.physicsBody?.applyForce(force, asImpulse: true)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
} 