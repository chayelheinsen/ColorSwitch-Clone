//
//  Player.swift
//  ColorSwitch
//
//  Created by Chayel Heinsen on 5/28/17.
//  Copyright © 2017 Chayel Heinsen. All rights reserved.
//

import SpriteKit

class Player: SKShapeNode {
  static let recommenedRadius: CGFloat = 40
  
  override init() {
    super.init()
    
    let playerBody = SKPhysicsBody(circleOfRadius: 30)
    playerBody.mass = 1.5
    playerBody.categoryBitMask = PhysicsCategory.player
    playerBody.collisionBitMask = 4
    self.physicsBody = playerBody
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func jump() {
    physicsBody?.velocity.dy = 800
  }
  
  func cancelVelocity() {
    physicsBody?.velocity.dy = 0
  }
}
