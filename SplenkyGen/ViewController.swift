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
            let scene = GameScene().build {
                $0.scaleMode = .resizeFill
                $0.size = skView.bounds.size
            }
            
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

