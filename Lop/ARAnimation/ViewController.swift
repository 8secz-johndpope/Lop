//
//  File.swift
//  Lop Dancing
//
//  Created by Joao Flores on 09/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var animations = [String: CAAnimation]()
    var idle:Bool = true
    
    var changeDance = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        
        // Load the DAE animations
        loadAnimations()
    }
    
    func loadAnimations () {
        // Load the character in the idle animation
        let idleScene = SCNScene(named: "art.scnassets/dance-11.scn")!
        
        // This node will be parent of all the animation models
        let node = SCNNode()
        
        // Add all the child nodes to the parent node
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        // Set up some properties
        node.position = SCNVector3(0, -1, -0.7)
        node.scale = SCNVector3(0.03, 0.03, 0.03)
        
        // Add the node to the scene
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = touches.first!.location(in: sceneView)
        
        // Let's test if a 3D Object was touch
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        
        let hitResults: [SCNHitTestResult]  = sceneView.hitTest(location, options: hitTestOptions)
        
        if hitResults.first != nil {
            
            for x in sceneView.scene.rootNode.childNodes {
                x.removeFromParentNode()
            }
            
            changeDance = changeDance + 1
            
            if(changeDance == 11) { changeDance = 1 }
            
            print(changeDance)
            let idleScene = SCNScene(named: "art.scnassets/dance-\(changeDance).scn")!
            let node = SCNNode()
            
            for child in idleScene.rootNode.childNodes {
                node.addChildNode(child)
            }
            
            node.position = SCNVector3(0, -1, -0.7)
            node.scale = SCNVector3(0.03, 0.03, 0.03)
            
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
