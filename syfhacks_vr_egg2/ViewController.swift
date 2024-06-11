//
//  ViewController.swift
//  syfhacks_vr_egg2
//
//  Created by Shubham  More on 6/10/24.
//

import UIKit
import Metal
import MetalKit
import ARKit
import RealityKit

extension MTKView : RenderDestinationProvider {
}

class ViewController: UIViewController, MTKViewDelegate, ARSessionDelegate {
    
    var session: ARSession!
    var renderer: Renderer!
    var squareAnchor: ARAnchor?
    var squareEntity: ModelEntity?
    var cubeNode: SCNNode?
    
    /*
     Called after the controllers view is loaded in memory
     1. start a session to keep track of the devices position and relative orientation to the real world by camera
     2. Build an MTKView and draw
    */
    override func viewDidLoad() {
        super.viewDidLoad()
                
        session = ARSession()
        session.delegate = self
        
        if self.view is MTKView {
            let view = self.view as! MTKView
            view.device = MTLCreateSystemDefaultDevice()
            view.backgroundColor = UIColor.clear
            view.delegate = self
            // draw the stuff here
            renderer = Renderer(session: session, metalDevice: view.device!, renderDestination: view)
            renderer.drawRectResized(size: view.bounds.size)
        } else {
            print("self.view is not an MTKView")
            return
        }
//        if cameraMoveConditionIsMet() {
//            addSphereToScene()
//        }
//        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongePress(gestureRecognize:)))
//        view.addGestureRecognizer(holdGesture)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongPress(gestureRecognize:)))
        view.addGestureRecognizer(longPressGesture)
    }
    
//    @objc
//    func handleLongePress(gestureRecognize: UIT) {
//        if gestureRecognize.state == .began {
//            // wait for some time
//            let waitTime: TimeInterval = 0.001
//            DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
//                // Create anchor using the camera's current position
//                if let currentFrame = self.session.currentFrame {
//                    // Create a transform with a translation of 0.2 meters in front of the camera
//                    var translation = matrix_identity_float4x4
//                    translation.columns.3.z = -1.2
//                    let transform = simd_mul(currentFrame.camera.transform, translation)
//                    // Add a new anchor to the session
//                    let anchor = ARAnchor(transform: transform)
//                    self.session.add(anchor: anchor)
//                }
//            }
//        }
//    }
    
    @objc func handleLongPress(gestureRecognize: UITapGestureRecognizer) {
        // Only add the anchor when the long press begins
        if gestureRecognize.state == .began {
            // Wait for a specified time before adding the anchor
//            let waitTime: TimeInterval = 2.0 // Wait for 5 seconds
//            DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
                // Create anchor using the camera's current position
            if let currentFrame = self.session.currentFrame {
                // Create a transform with a translation of 1.2 meters in front of the camera
                var translation = matrix_identity_float4x4
                translation.columns.3.z = -0.2
                let transform = simd_mul(currentFrame.camera.transform, translation)
                
                // Add a new anchor to the session
                let anchor = ARAnchor(transform: transform)
                self.squareAnchor = anchor
                self.session.add(anchor: anchor)
                
                // Create a square entity (or any other model)
//                    let square = MeshResource.generatePlane(width: 0.1, height: 0.1)
//                    let material = SimpleMaterial(color: .blue, roughness: 0, isMetallic: true)
//                    let squareEntity = ModelEntity(mesh: square, materials: [material])
//                    self.squareEntity = squareEntity
                // Create a cube entity
                let cube = MeshResource.generateBox(size: 0.1) // 10cm cube
                let material = SimpleMaterial(color: .red, roughness: 0.5, isMetallic: false)
                let squareEntity = ModelEntity(mesh: cube, materials: [material])
                self.squareEntity = squareEntity
                
//                    let coin = MeshResource.generateCylinder(height: 0.2, radius: 0.5) // 5cm radius, 1cm height
//                    let material = SimpleMaterial(color: .yellow, roughness: 0.1, isMetallic: true)
//                    let squareEntity = ModelEntity(mesh: coin, materials: [material])
//                    self.squareEntity = squareEntity
                
                // Add the square entity to the scene
//                    let arView = self.view as! MTKView
//                    let anchorEntity = AnchorEntity(anchor: anchor)
//                    anchorEntity.addChild(squareEntity)
//                    arView.scene.addAnchor(anchorEntity)
                
                // Start periodic updates to move the square closer as the user moves closer
                self.startPeriodicUpdates()
            }
        }
    }
    
//    @objc func handleLongPress(gestureRecognize: UILongPressGestureRecognizer) {
//        // Only add the anchor when the long press begins
//        if gestureRecognize.state == .began {
//            // Wait for a specified time before adding the anchor
//            let waitTime: TimeInterval = 3.0 // Wait for 5 seconds
//            DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
//                // Create anchor using the camera's current position
//                if let currentFrame = self.session.currentFrame {
//                    // Create a transform with a translation of 1.2 meters in front of the camera
//                    // Step 3: Create a translation matrix
//                    var translation = matrix_identity_float4x4
//                    translation.columns.3.z = -1.2 // Move the cube 1.2 units in front of the camera
//
//                    // Step 4: Create a rotation matrix (45 degrees around the y-axis)
////                    let angle = (5 * Float.pi) / 4 // 45 degrees in radians
////                    var rotation = matrix_identity_float4x4
////                    rotation.columns.0.x = cos(angle)
////                    rotation.columns.0.z = sin(angle)
////                    rotation.columns.2.x = -sin(angle)
////                    rotation.columns.2.z = cos(angle)
//
//                    // Step 5: Combine the rotation and translation matrices
////                    let combinedTransform = simd_mul(translation, rotation)
//                    let combinedTransform = simd_mul(translation)
//
//
//                    // Step 6: Apply the combined transform to the cube node
////                    let transform = simd_mul(currentFrame.camera.transform, combinedTransform)
//                    
//                    // Add a new anchor to the session
//                    let anchor = ARAnchor(transform: transform)
//                    self.squareAnchor = anchor
//                    self.session.add(anchor: anchor)
//                    
//                    // Create a square entity (or any other model)
////                    let square = MeshResource.generatePlane(width: 0.1, height: 0.1)
////                    let material = SimpleMaterial(color: .blue, roughness: 0, isMetallic: true)
////                    let squareEntity = ModelEntity(mesh: square, materials: [material])
////                    self.squareEntity = squareEntity
//                    // Create a cube entity
//                    let square = MeshResource.generateBox(size: 0.1) // 10cm cube
//                    let material = SimpleMaterial(color: .red, roughness: 0.5, isMetallic: false)
//                    let squareEntity = ModelEntity(mesh: square, materials: [material])
//                    self.squareEntity = squareEntity
//                    
////                    let coin = MeshResource.generateCylinder(height: 0.2, radius: 0.5) // 5cm radius, 1cm height
////                    let material = SimpleMaterial(color: .yellow, roughness: 0.1, isMetallic: true)
////                    let squareEntity = ModelEntity(mesh: coin, materials: [material])
////                    self.squareEntity = squareEntity
//                    
//                    // Add the square entity to the scene
////                    let arView = self.view as! MTKView
////                    let anchorEntity = AnchorEntity(anchor: anchor)
////                    anchorEntity.addChild(squareEntity)
////                    arView.scene.addAnchor(anchorEntity)
//                    
//                    // Start periodic updates to move the square closer as the user moves closer
//                    self.startPeriodicUpdates()
//                }
//            }
//        }
//    }
    
    // Start periodic updates to move the square closer
    func startPeriodicUpdates() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.updateSquarePosition()
        }
    }
    
    // Update the square position based on the user's current distance
    func updateSquarePosition() {
        guard let currentFrame = session.currentFrame, let squareAnchor = squareAnchor else { return }
        
        let cameraTransform = currentFrame.camera.transform
        let anchorPosition = squareAnchor.transform.columns.3
        let cameraPosition = cameraTransform.columns.3
        
        let distance = simd_distance(anchorPosition, cameraPosition)
        
        // If the distance is less than a threshold, stop updating
        if distance < 0.1 {
            showNotification()
            return
        }
        
        // Update the square's position to be closer to the camera
//        var newTranslation = matrix_identity_float4x4
//        newTranslation.columns.3.z = -max(0.1, distance - 0.1)
//        let newTransform = simd_mul(cameraTransform, newTranslation)
//        let newAnchor = ARAnchor(transform: newTransform)
//        
//        // Remove the old anchor and add the new one
//        session.remove(anchor: squareAnchor)
//        session.add(anchor: newAnchor)
//        
//        self.squareAnchor = newAnchor
    }
    
    // Show a notification when the user "touches" the square
    func showNotification() {
        let alert = UIAlertController(title: "Notification", message: "You Recieved a 10% Discount on Maison Merrer Soda", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            // Remove the cube entity from the scene
//            if let anchor = self.squareAnchor {
//                self.session.remove(anchor: anchor)
//                self.squareAnchor = nil
//            }
//            self.squareEntity = nil
//        }))
        present(alert, animated: true, completion: nil)
    }
    
//    @objc
//    func handleTap(gestureRecognize: UITapGestureRecognizer) {
//        // Create anchor using the camera's current position
//        if let currentFrame = session.currentFrame {
//            // Create a transform with a translation of 0.2 meters in front of the camera
//            var translation = matrix_identity_float4x4
//            translation.columns.3.z = -1.2
//            let transform = simd_mul(currentFrame.camera.transform, translation)
//            // Add a new anchor to the session
//            let anchor = ARAnchor(transform: transform)
//            session.add(anchor: anchor)
//        }
//    }
    
//    let sphere = MeshResource.generateSphere(radius: 10)
//    let material = SimpleMaterial(color: .red, roughness: 0, isMetallic: true)
//    let sphereEntity = ModelEntity(mesh: sphere, materials: [material])
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause()
    }
    
    // MARK: - MTKViewDelegate
    
    // Called whenever view changes orientation or layout is changed
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        renderer.drawRectResized(size: size)
    }
    
    // Called whenever the view needs to render
    func draw(in view: MTKView) {
        renderer.update()
    }
    
    // MARK: - ARSessionDelegate
    
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
