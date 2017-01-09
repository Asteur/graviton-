//
//  SceneControlViewController.swift
//  Graviton
//
//  Created by Sihao Lu on 1/8/17.
//  Copyright © 2017 Ben Lu. All rights reserved.
//

import UIKit
import SceneKit

class SceneControlViewController: UIViewController, SCNSceneRendererDelegate {

    var cameraController: CameraControlling?
    
    lazy var pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
    
    lazy var doubleTap: UITapGestureRecognizer = {
        let gr = UITapGestureRecognizer(target: self, action: #selector(recenter(sender:)))
        gr.numberOfTapsRequired = 2
        return gr
    }()
    
    lazy var zoom: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(zoom(sender:)))
    
    lazy var rotationGR: UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotate(sender:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(doubleTap)
        view.addGestureRecognizer(pan)
        view.addGestureRecognizer(zoom)
        view.addGestureRecognizer(rotationGR)
    }
    
    func recenter(sender: UIGestureRecognizer) {
        slideVelocity = CGPoint()
        referenceSlideVelocity = CGPoint()
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        cameraController?.resetCamera()
        SCNTransaction.commit()
    }
    
    private var previousScale: Double?
    func zoom(sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            previousScale = cameraController?.scale
            sender.scale = CGFloat((cameraController?.scale ?? 1) / (previousScale ?? 1))
        case .changed:
            cameraController?.scale = previousScale! * Double(sender.scale)
            sender.scale = CGFloat((cameraController?.scale ?? 1) / (previousScale ?? 1))
        case .ended:
            cameraController?.scale = previousScale! * Double(sender.scale)
            sender.scale = CGFloat((cameraController?.scale ?? 1) / (previousScale ?? 1))
            previousScale = nil
        default:
            break
        }
    }
    
    private var slideVelocity: CGPoint = CGPoint()
    private var referenceSlideVelocity: CGPoint = CGPoint()
    private var slidingStopTimestamp: TimeInterval?
    
    func pan(sender: UIPanGestureRecognizer) {
        slideVelocity = sender.velocity(in: view).cap(to: viewSlideVelocityCap)
        referenceSlideVelocity = slideVelocity
        slidingStopTimestamp = nil
    }
    
    private var previousRotation: SCNVector4?
    func rotate(sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .began:
            previousRotation = cameraController?.cameraNode.rotation
        case .ended:
            previousRotation = nil
        default:
            break
        }
    }
    
    var viewSlideDivisor: CGFloat = 5000
    var viewSlideVelocityCap: CGFloat = 800
    var viewSlideInertiaDuration: TimeInterval = 1
    
    // http://stackoverflow.com/questions/25654772/rotate-scncamera-node-looking-at-an-object-around-an-imaginary-sphere
    private func handleCameraPan(atTime time: TimeInterval) {
        guard let cameraNode = cameraController?.cameraNode else {
            return
        }
        let oldRot: SCNQuaternion = cameraNode.rotation
        var rot: GLKQuaternion = GLKQuaternionMakeWithAngleAndAxis(oldRot.w, oldRot.x, oldRot.y, oldRot.z)
        let rotX: GLKQuaternion = GLKQuaternionMakeWithAngleAndAxis(Float(-slideVelocity.x / viewSlideDivisor), 0, 1, 0)
        let rotY: GLKQuaternion = GLKQuaternionMakeWithAngleAndAxis(Float(-slideVelocity.y / viewSlideDivisor), 1, 0, 0)
        let netRot: GLKQuaternion = GLKQuaternionMultiply(rotX, rotY)
        rot = GLKQuaternionMultiply(rot, netRot)
        
        let axis = GLKQuaternionAxis(rot)
        let angle = GLKQuaternionAngle(rot)
        cameraNode.rotation = SCNVector4Make(axis.x, axis.y, axis.z, angle)

        // dampen velocity
        if slidingStopTimestamp == nil {
            slidingStopTimestamp = time
        } else {
            let p = min((time - slidingStopTimestamp!) / viewSlideInertiaDuration, 1) - 1
            let factor: CGFloat = CGFloat(-p * p * p)
            slideVelocity = CGPoint(x: referenceSlideVelocity.x * factor, y: referenceSlideVelocity.y * factor)
        }
    }
    
    private func handleCameraRotation(atTime time: TimeInterval) {
        guard let cameraNode = cameraController?.cameraNode, let oldRot = previousRotation else {
            return
        }
        var rot: GLKQuaternion = GLKQuaternionMakeWithAngleAndAxis(oldRot.w, oldRot.x, oldRot.y, oldRot.z)
        let rotZ: GLKQuaternion = GLKQuaternionMakeWithAngleAndAxis(Float(rotationGR.rotation), 0, 0, 1)
        rot = GLKQuaternionMultiply(rot, rotZ)
        
        let axis = GLKQuaternionAxis(rot)
        let angle = GLKQuaternionAngle(rot)
        cameraNode.rotation = SCNVector4Make(axis.x, axis.y, axis.z, angle)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        handleCameraPan(atTime: time)
        handleCameraRotation(atTime: time)
    }
}

extension CGPoint {
    func cap(to p: CGFloat) -> CGPoint {
        return CGPoint(x: x > 0 ? min(x, p) : max(x, -p), y: y > 0 ? min(y, p) : max(y, -p))
    }
}
