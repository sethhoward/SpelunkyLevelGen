//
//  ViewController.swift
//  SplenkyGen
//
//  Created by Seth Howard on 6/4/17.
//  Copyright © 2017 Seth Howard. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.frame = CGRect(origin: CGPoint(), size: CGSize(width: 1280, height: 1024))
        
        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene()
                // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
            scene.size = skView.bounds.size
                
                // Present the scene
                view.presentScene(scene)
            
//            let foo = SKSpriteNode(color: .cyan, size: CGSize(width: 128, height: 128))
//            foo.anchorPoint = CGPoint()
//            foo.position = CGPoint(x: 0, y: 0)
//            scene.addChild(foo)
                
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

