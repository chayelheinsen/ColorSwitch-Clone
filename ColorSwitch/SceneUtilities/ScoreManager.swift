//
//  ScoreManager.swift
//  ColorSwitch
//
//  Created by Chayel Heinsen on 5/28/17.
//  Copyright © 2017 Chayel Heinsen. All rights reserved.
//

import SpriteKit

struct ScoreManager {
  var score = 0 {
    didSet {
      label.text = String(score)
    }
  }
  let label = ScoreLabel(position: CGPoint(x: -350, y: -900))
  
  mutating func increment() {
    score += 1
  }
  
  mutating func reset() {
    score = 0
  }
}
