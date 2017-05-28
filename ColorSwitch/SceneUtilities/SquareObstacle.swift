//
//  SquareObstacle.swift
//  ColorSwitch
//
//  Created by Chayel Heinsen on 5/28/17.
//  Copyright © 2017 Chayel Heinsen. All rights reserved.
//

import SpriteKit

class SquareObstacle: Obstacle {
  var node: SKNode!
  
  func create() {
    let path = UIBezierPath(
      roundedRect: CGRect(x: -200, y: -200, width: 400, height: 40),
      cornerRadius: 20
    )
    
    node = obstacleByDuplicatingPath(path)
  }
}
