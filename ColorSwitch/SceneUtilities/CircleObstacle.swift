//
//  CircleObstacle.swift
//  ColorSwitch
//
//  Created by Chayel Heinsen on 5/28/17.
//  Copyright © 2017 Chayel Heinsen. All rights reserved.
//

import SpriteKit

class CircleObstacle: Obstacle {
  var node: SKNode!
  
  func create() {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: -200))
    path.addLine(to: CGPoint(x: 0, y: -160))
    path.addArc(
      withCenter: CGPoint.zero,
      radius: 160,
      startAngle: CGFloat(3.0 * .pi / 2),
      endAngle: CGFloat(0),
      clockwise: true
    )
    
    path.addLine(to: CGPoint(x: 200, y: 0))
    path.addArc(
      withCenter: CGPoint.zero,
      radius: 200,
      startAngle: CGFloat(0.0),
      endAngle: CGFloat(3.0 * .pi / 2),
      clockwise: false
    )
    
    node = obstacleByDuplicatingPath(path)
  }
}
