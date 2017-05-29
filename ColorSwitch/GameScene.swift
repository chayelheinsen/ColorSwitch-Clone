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
  var changers = [ColorChanger]()
  let obstacleSpacing: CGFloat = 800
  var obstacleOffestCounter: CGFloat = 0
  var scoreManager = ScoreManager()
  
  override func didMove(to view: SKView) {
    setupGame()
    
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
    
    if player.position.y > obstacleSpacing * (obstacleOffestCounter - 2) {
      scoreManager.increment()
      addObstacles(1)
      removeInvisibleObstacles()
    }
    
    let playerPositionInCamera = cameraNode.convert(player.position, from: self)
    
    if playerPositionInCamera.y > 0 && !cameraNode.hasActions() {
      cameraNode.position.y = player.position.y
    }
    
    if playerPositionInCamera.y < -size.height / 2 {
      restart()
    }
  }
  
  private func setupGame() {
    addPlayer()
    addObstacles(3)
    setupScore()
  }
  
  private func addPlayer() {
    player = Player(circleOfRadius: Player.recommenedRadius)
    player!.position = CGPoint(x: size.width / 2, y: 200)
    changePlayerColor()
    addChild(player!)
  }
  
  private func setupScore() {
    
    if !cameraNode.contains(scoreManager.label) {
      cameraNode.addChild(scoreManager.label)
    }
  }
  
  /*
   Recursively creates obstacles.
   */
  private func addObstacles(_ count: Int) {
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
    
    addColorChanger()
    
    addObstacles(count - 1)
  }
  
  private func addCircleObstacle() {
    let obstacle = CircleObstacle()
    createObstacle(obstacle)
  }
  
  private func addSquareObstacle() {
    let obstacle = SquareObstacle()
    createObstacle(obstacle)
  }
  
  private func createObstacle(_ obstacle: Obstacle) {
    obstacle.create()
    obstacles.append(obstacle)
    obstacleOffestCounter += 1
    obstacle.node.position = CGPoint(x: size.width / 2, y: obstacleSpacing * obstacleOffestCounter)
    obstacle.startRotating()
    addChild(obstacle.node)
  }
  
  private func addColorChanger() {
    guard let lastObstacleNode = obstacles.last?.node else { return }
    
    let colorChanger = ColorChanger(circleOfRadius: ColorChanger.recommenedRadius)
    changers.append(colorChanger)
    colorChanger.position = CGPoint(
      x: size.width / 2,
      y: obstacleSpacing / 2 + lastObstacleNode.position.y
    )
    addChild(colorChanger)
  }
  
  fileprivate func changePlayerColor(_ colorChanger: ColorChanger? = nil) {
    guard let player = player else { return }
    
    let choice = Int(arc4random_uniform(4))
    let beforeColor = player.fillColor
    var color: UIColor
    
    switch choice {
    case 0:
      color = .yellow
    case 1:
      color = .blue
    case 2:
      color = .red
    case 3:
      color = .purple
    default:
      color = .blue
    }
    
    player.fillColor = color
    player.strokeColor = color
    
    if let colorChanger = colorChanger {
      colorChanger.removeFromParent()
    }
    
    if color == beforeColor {
      changePlayerColor()
    }
  }
  
  private func removeInvisibleObstacles() {
    guard let obstacle = obstacles.first,
      obstacles.count > 5 else { return }
    
    obstacle.stopRotating()
    obstacle.node.removeFromParent()
    obstacles.removeFirst()
  }
  
  fileprivate func restart() {
    player?.cancelVelocity()
    player?.removeFromParent()
    
    scoreManager.reset()
    
    for obstacle in obstacles {
      obstacle.stopRotating()
      obstacle.node.removeFromParent()
    }
    
    for changer in changers {
      changer.removeFromParent()
    }
    
    obstacles.removeAll()
    changers.removeAll()
    obstacleOffestCounter = 0
    
    cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    
    setupGame()
  }
}

extension GameScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    
    if let nodeA = contact.bodyA.node as? SKShapeNode,
       let nodeB = contact.bodyB.node as? SKShapeNode {
      
      if contact.bodyA.categoryBitMask == PhysicsCategory.obstacle ||
         contact.bodyB.categoryBitMask == PhysicsCategory.obstacle {
        
        if nodeA.fillColor != nodeB.fillColor {
          restart()
        }
      } else if let nodeA = nodeA as? ColorChanger {
        changePlayerColor(nodeA)
      } else if let nodeB = nodeB as? ColorChanger {
        changePlayerColor(nodeB)
      }
    }
  }
}
