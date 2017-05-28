//
//  Obstacle.swift
//  ColorSwitch
//
//  Created by Chayel Heinsen on 5/28/17.
//  Copyright © 2017 Chayel Heinsen. All rights reserved.
//

import SpriteKit

protocol Obstacle {
  var node: SKNode! { get set }
  func create()
}

extension Obstacle {
  var colors: [SKColor] {
    return [SKColor.yellow, SKColor.red, SKColor.blue, SKColor.purple]
  }
  
  func startRotating(clockwise: Bool) {
    startRotating(clockwise: clockwise, duration: 8)
  }
  
  func startRotating(duration: TimeInterval) {
    startRotating(clockwise: false, duration: duration)
  }
  
  func startRotating(clockwise: Bool = false, duration: TimeInterval = 8) {
    var rotationFactor: CGFloat = 2 * .pi / 2
    
    if clockwise {
      rotationFactor *= -1
    }
    
    let rotateAction = SKAction.rotate(byAngle: rotationFactor, duration: duration)
    node.run(SKAction.repeatForever(rotateAction), withKey: "RotateAction")
  }
  
  func stopRotating() {
    node.removeAction(forKey: "RotateAction")
  }
  
  func obstacleByDuplicatingPath(_ path: UIBezierPath, clockwise: Bool = true) -> SKNode {
    let container = SKNode()
    var rotationFactor: CGFloat = .pi / 2
    
    if !clockwise {
      rotationFactor *= -1
    }
    
    for i in 0...3 {
      let section = SKShapeNode(path: path.cgPath)
      section.fillColor = colors[i]
      section.strokeColor = colors[i]
      section.zRotation = rotationFactor * CGFloat(i)
      
      let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
      sectionBody.categoryBitMask = PhysicsCategory.obstacle
      sectionBody.collisionBitMask = 0
      sectionBody.contactTestBitMask = PhysicsCategory.player
      sectionBody.affectedByGravity = false
      section.physicsBody = sectionBody
      
      container.addChild(section)
    }
    
    return container
  }
}
