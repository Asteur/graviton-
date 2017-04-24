//
//  ObserverViewController.swift
//  Graviton
//
//  Created by Sihao Lu on 1/7/17.
//  Copyright © 2017 Ben Lu. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit
import Orbits
import StarryNight
import SpaceTime
import MathUtil
import CoreImage
import CoreMedia

class ObserverViewController: SceneController, UINavigationControllerDelegate, SnapshotSupport, SKSceneDelegate {
    
    private lazy var obsScene = ObserverScene()
    private var scnView: SCNView {
        return self.view as! SCNView
    }
    
    var currentSnapshot: UIImage {
        return scnView.snapshot()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
        EphemerisManager.default.subscribe(obsScene, mode: .interval(10))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentTransparentNavigationBar()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func handleCameraPan(atTime time: TimeInterval) {
        super.handleCameraPan(atTime: time)
        let factor = CGFloat(ObserverScene.defaultFov / obsScene.fov)
        viewSlideDivisor = factor * 25000
    }
    
    func menuButtonTapped() {
        scnView.pause(nil)
        let menuController = ObserverMenuController(style: .plain)
        print(CACurrentMediaTime())
        menuController.backgroundImage = scnView.snapshot()
        print(CACurrentMediaTime())
        menuController.menu = Menu.main
        navigationController?.pushViewController(menuController, animated: true)
    }
    
    private func setupViewElements() {
        navigationController?.delegate = self
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu_icon_menu"), style: .plain, target: self, action: #selector(menuButtonTapped))
        navigationItem.rightBarButtonItem = barButtonItem
        navigationController?.navigationBar.tintColor = Constants.Menu.tintColor
        scnView.delegate = self
        scnView.antialiasingMode = .multisampling2X
        scnView.scene = obsScene
        scnView.pointOfView = obsScene.cameraNode
        cameraController = obsScene
        scnView.isPlaying = true
        scnView.backgroundColor = UIColor.black
        viewSlideVelocityCap = 500
        cameraInversion = [.invertX, .invertY]
    }
    
    // MARK: - Scene Renderer Delegate
    
    override func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        super.renderer(renderer, didRenderScene: scene, atTime: time)
        EphemerisManager.default.requestEphemeris(at: JulianDate.now(), forObject: obsScene)
    }
    
    // MARK: - Navigation Controller Delegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            scnView.play(nil)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let pushTransition = PushOverlayTransition(from: fromVC, to: toVC, operation: operation)
        return pushTransition
    }
}
