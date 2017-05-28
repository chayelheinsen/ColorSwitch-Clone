//
//  GameViewController.swift
//  ColorSwitch
//
//  Created by Chayel Heinsen on 5/28/17.
//  Copyright © 2017 Chayel Heinsen. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let scene = GameScene(size: CGSize(width: 1536, height: 2048))
    let skView = self.view as! SKView
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.ignoresSiblingOrder = true
    scene.scaleMode = .aspectFill
    skView.presentScene(scene)
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
