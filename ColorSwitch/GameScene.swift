//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Chayel Heinsen on 5/28/17.
//  Copyright © 2017 Chayel Heinsen. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  let cameraNode = SKCameraNode()
  var player: Player? = nil
  var obstacles = [Obstacle]()
  let obstacleSpacing: CGFloat = 800
  
  override func didMove(to view: SKView) {
    setupPlayerAndObstacles()
    
    // Make gravity stronger
    physicsWorld.gravity.dy = -22
    
    // Specify the ledge at the bottom of the screen
    let ledge = SKNode()
    ledge.position = CGPoint(x: size.width / 2, y: 160)
    let ledgeBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 10))
    ledgeBody.isDynamic = false
    ledgeBody.categoryBitMask = PhysicsCategory.edge
    ledge.physicsBody = ledgeBody
    addChild(ledge)
    
    physicsWorld.contactDelegate = self
    
    addChild(cameraNode)
    camera = cameraNode
    cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    player?.jump()
  }
  
  override func update(_ currentTime: TimeInterval) {
    guard let player = player else { return }
    
    if player.position.y > obstacleSpacing * CGFloat(obstacles.count - 2) {
      // TODO: Update score
      addObstacles(1)
    }
    
    let playerPositionInCamera = cameraNode.convert(player.position, from: self)
    
    if playerPositionInCamera.y > 0 && !cameraNode.hasActions() {
      cameraNode.position.y = player.position.y
    }
    
    if playerPositionInCamera.y < -size.height / 2 {
      dieAndRestart()
    }
  }
  
  private func setupPlayerAndObstacles() {
    addPlayer()
    addObstacles(3)
  }
  
  private func addPlayer() {
    player = Player(circleOfRadius: Player.recommenedRadius)
    player!.position = CGPoint(x: size.width / 2, y: 200)
    player!.fillColor = .blue
    player!.strokeColor = player!.fillColor
    addChild(player!)
  }
  
  /*
   Recursively creates obstacles.
   */
  func addObstacles(_ count: Int) {
    guard count > 0 else { return }
    
    let choice = Int(arc4random_uniform(2))
    
    switch choice {
    case 0:
      addCircleObstacle()
    case 1:
      addSquareObstacle()
    default:
      print("something went wrong")
    }
    
    addObstacles(count - 1)
  }

  private func addCircleObstacle() {
    let obstacle = CircleObstacle()
    obstacle.create()
    obstacles.append(obstacle)
    obstacle.node.position = CGPoint(x: size.width / 2, y: obstacleSpacing * CGFloat(obstacles.count))
    obstacle.startRotating(clockwise: false, duration: 2)
    addChild(obstacle.node)
  }
  
  private func addSquareObstacle() {
    let obstacle = SquareObstacle()
    obstacle.create()
    obstacles.append(obstacle)
    obstacle.node.position = CGPoint(x: size.width / 2, y: obstacleSpacing * CGFloat(obstacles.count))
    obstacle.startRotating(clockwise: false, duration: 2)
    addChild(obstacle.node)
  }
  
  fileprivate func dieAndRestart() {
    player?.cancelVelocity()
    player?.removeFromParent()
    
    for obstacle in obstacles {
      obstacle.stopRotating()
      obstacle.node.removeFromParent()
    }
    
    obstacles.removeAll()
    cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    
    setupPlayerAndObstacles()
  }
}

extension GameScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    
    if let nodeA = contact.bodyA.node as? SKShapeNode,
      let nodeB = contact.bodyB.node as? SKShapeNode {
      
      if nodeA.fillColor != nodeB.fillColor {
        dieAndRestart()
      }
    }
  }
}
