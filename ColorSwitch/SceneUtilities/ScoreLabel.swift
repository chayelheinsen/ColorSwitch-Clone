//
//  ScoreLabel.swift
//  ColorSwitch
//
//  Created by Chayel Heinsen on 5/28/17.
//  Copyright © 2017 Chayel Heinsen. All rights reserved.
//

import SpriteKit

class ScoreLabel: SKLabelNode {
  convenience init(position: CGPoint) {
    self.init()
    self.fontColor = .white
    self.fontSize = 150
    self.position = position
    self.text = "0"
  }
}
