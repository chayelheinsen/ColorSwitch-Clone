//
//  ColorChanger.swift
//  ColorSwitch
//
//  Created by Chayel Heinsen on 5/29/17.
//  Copyright © 2017 Chayel Heinsen. All rights reserved.
//

import SpriteKit

class ColorChanger: SKShapeNode {
  static let recommenedRadius: CGFloat = 20
  
  override init() {
    super.init()
    
    fillColor = .gray
    strokeColor = fillColor
    
    let changerBody = SKPhysicsBody(circleOfRadius: 15)
    changerBody.mass = 1.5
    changerBody.categoryBitMask = PhysicsCategory.colorChanger
    changerBody.collisionBitMask = 0
    changerBody.contactTestBitMask = PhysicsCategory.player
    changerBody.affectedByGravity = false
    self.physicsBody = changerBody
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
