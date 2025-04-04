import SceneKit
import AVFoundation

class GameScene: SCNScene {
    private var cameraNode: SCNNode!
    private var soundManager: SoundManager!
    private var hapticManager: HapticManager!
    
    override init() {
        super.init()
        setupScene()
        setupPhysics()
        setupCamera()
        setupLighting()
        soundManager = SoundManager()
        hapticManager = HapticManager()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScene() {
        // Set up the scene's background
        background.contents = UIColor.black
        
        // Set up physics world
        physicsWorld.gravity = SCNVector3(0, -9.8, 0)
        physicsWorld.contactDelegate = self
    }
    
    private func setupCamera() {
        // Create and add camera
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 5, 10)
        cameraNode.eulerAngles = SCNVector3(-0.3, 0, 0)
        rootNode.addChildNode(cameraNode)
    }
    
    private func setupLighting() {
        // Add ambient light
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 100
        rootNode.addChildNode(ambientLight)
        
        // Add directional light
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.intensity = 800
        directionalLight.position = SCNVector3(0, 10, 10)
        directionalLight.eulerAngles = SCNVector3(-0.5, 0, 0)
        rootNode.addChildNode(directionalLight)
    }
    
    private func setupPhysics() {
        // Create a ground plane
        let groundGeometry = SCNPlane(width: 20, height: 20)
        groundGeometry.firstMaterial?.diffuse.contents = UIColor.gray
        let groundNode = SCNNode(geometry: groundGeometry)
        groundNode.eulerAngles = SCNVector3(-Float.pi/2, 0, 0)
        groundNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: groundGeometry))
        rootNode.addChildNode(groundNode)
    }
    
    func add3DModel(named modelName: String, at position: SCNVector3) {
        // Load 3D model from .dae or .scn file
        if let modelScene = SCNScene(named: modelName) {
            let modelNode = modelScene.rootNode.childNodes.first!
            modelNode.position = position
            modelNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            rootNode.addChildNode(modelNode)
        }
    }
}

extension GameScene: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        // Handle collisions
        hapticManager.playImpact()
        soundManager.playCollisionSound()
    }
} 