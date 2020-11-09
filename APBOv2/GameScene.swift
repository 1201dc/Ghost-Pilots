//
//  GameScene.swift
//  APBOv2
//
//  Created by 90306670 on 10/20/20.
//  Copyright © 2020 Dhruv Chowdhary. All rights reserved.
//

import SpriteKit
import CoreMotion

let degreesToRadians = CGFloat.pi / 180
let radiansToDegrees = 180 / CGFloat.pi
let maxHealth = 100
let healthBarWidth: CGFloat = 40
let healthBarHeight: CGFloat = 4
let cannonCollisionRadius: CGFloat = 70
let playerCollisionRadius: CGFloat = 10
let shotCollisionRadius: CGFloat = 20
let playAgain = SKLabelNode(text: "Tap to Play Again")

enum CollisionType: UInt32 {
case player = 1
case shot = 2
case cannon = 4
case turretWeapon = 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
        let playerHealthBar = SKSpriteNode()
        let cannonHealthBar = SKSpriteNode()
        var playerHP = maxHealth
        var cannonHP = maxHealth
        let turnButton = SKSpriteNode(imageNamed: "button")
        let shootButton = SKSpriteNode(imageNamed: "button")
        let turretSprite = SKSpriteNode(imageNamed: "turretshooter")
        let cannonSprite = SKSpriteNode(imageNamed: "turretbase")
        let player = SKSpriteNode(imageNamed: "apbo")
        let shot = SKSpriteNode(imageNamed: "bullet")
        var lastUpdateTime: CFTimeInterval = 0
        var count = 0;
        var doubleTap = 0;
        var isPlayerAlive = true
        var playerShields = 3
        let thruster1 = SKEmitterNode(fileNamed: "Thrusters")

        let playAgain = SKLabelNode(text: "Tap to Play Again")
    
    override func didMove(to view: SKView) {
        size = view.bounds.size
        
        backgroundColor = SKColor(red: 14.0/255, green: 23.0/255, blue: 57.0/255, alpha: 1)
        
     
            
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        if let particles = SKEmitterNode(fileNamed: "Starfield") {
                particles.position = CGPoint(x: frame.midX, y: frame.midY)
        //      particles.advanceSimulationTime(60)
                particles.zPosition = -1
                addChild(particles)
        }
                
        
        
        
        
        
        player.name = "apbo"
        player.position.x = size.width/2
        player.position.y = size.height/2
        player.zPosition = 1
        addChild(player)
        
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
         player.physicsBody?.collisionBitMask = CollisionType.cannon.rawValue | CollisionType.turretWeapon.rawValue
         player.physicsBody?.contactTestBitMask = CollisionType.cannon.rawValue | CollisionType.turretWeapon.rawValue
         player.physicsBody?.isDynamic = false
                
        
        
        cannonSprite.position = CGPoint(x: size.width/2, y: size.height/2)
      
        cannonSprite.zPosition = 1
        
        cannonSprite.physicsBody?.categoryBitMask = CollisionType.cannon.rawValue
         cannonSprite.physicsBody?.collisionBitMask = CollisionType.player.rawValue | CollisionType.shot.rawValue
         cannonSprite.physicsBody?.contactTestBitMask = CollisionType.player.rawValue | CollisionType.shot.rawValue
         cannonSprite.physicsBody?.isDynamic = false
          addChild(cannonSprite)
                
        
        
        turretSprite.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(turretSprite)
        turretSprite.zPosition = 3
              
      
        turnButton.name = "btn"
        turnButton.size.height = 100
        turnButton.size.width = 100
        turnButton.zPosition = 2
        turnButton.position = CGPoint(x: self.frame.maxX-110,y: self.frame.minY+70)
        self.addChild(turnButton)
                
        shootButton.name = "shoot"
        shootButton.size.height = 100
        shootButton.size.width = 100
        shootButton.zPosition = 2
        shootButton.position = CGPoint(x: self.frame.minX+110 ,y: self.frame.minY+70)
        self.addChild(shootButton)
           
        
        
        
     //   thruster1?.position = player.position
       // thruster1?.zPosition = 1
        thruster1?.targetNode = self

        player.addChild(thruster1!)
       // addChild(thruster1!)

    
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size:player.texture!.size())
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.isDynamic = false
                
        
        addChild(cannonHealthBar)
               cannonHealthBar.position = CGPoint(
                 x: cannonSprite.position.x,
                 y: cannonSprite.position.y - cannonSprite.size.height/2 - 10
               )
               
               updateHealthBar(cannonHealthBar, withHealthPoints: cannonHP)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { (timer) in
        self.player.zRotation = self.player.zRotation + CGFloat(self.direction);
                
    }
}
    let rotate = SKAction.rotate(byAngle: -1, duration: 0.5)
    var direction = 0.0
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)

     if let name = touchedNode.name {
            if name == "btn" {
                let fadeAlpha = SKAction.fadeAlpha(to: 0.8 , duration: 0.1)
                turnButton.run(fadeAlpha)
                count=1;
                direction = 0.1
                if (doubleTap==1) {
                    self.player.zRotation = self.player.zRotation + 1.0;
                    let movement = SKAction.moveBy(x: 50 * cos(player.zRotation), y: 50 * sin(player.zRotation), duration: 0.2)
                               player.run(movement)
                } else {
                    doubleTap = 1;
                }
            }
       } else {
               count=0;
       }
        if let name = touchedNode.name {
        if name == "shoot" {
            
            let fadeAlpha = SKAction.fadeAlpha(to: 0.8 , duration: 0.1)
            shootButton.run(fadeAlpha)
           
            let shot = SKSpriteNode(imageNamed: "bullet")
            
            shot.name = "bullet"
                  shot.position = player.position
                  shot.zPosition = 1
                  shot.physicsBody = SKPhysicsBody(rectangleOf: shot.size)
                  shot.physicsBody?.categoryBitMask = CollisionType.shot.rawValue
                  shot.physicsBody?.collisionBitMask = CollisionType.cannon.rawValue | CollisionType.turretWeapon.rawValue
                  shot.physicsBody?.contactTestBitMask = CollisionType.cannon.rawValue | CollisionType.turretWeapon.rawValue
                  addChild(shot)
                     
            
                   
                   
                       
            let movement = SKAction.moveBy(x: 700 * cos(player.zRotation), y: 700 * sin(player.zRotation), duration: 1.26)
                   
                   
                       let sequence = SKAction.sequence([movement, .removeFromParent()])
                       shot.run(sequence)
            }
        }
    }
 
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if count==1 {
            direction = 0
            let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
                self.doubleTap = 0;
            }
        }
        let fadeAlpha = SKAction.fadeAlpha(to: 1.0 , duration: 0.1)
        turnButton.run(fadeAlpha)
        shootButton.run(fadeAlpha)
            
            
        }
    
    override func update(_ currentTime: TimeInterval) {
        
        let deltaTime = max(1.0/30, currentTime - lastUpdateTime)
        lastUpdateTime = currentTime
        
        updatePlayer(deltaTime)
        updateTurret(deltaTime)
        checkShipCannonCollision()
        checkShotCannonCollision()
        
    }
    
    func updatePlayer(_ dt: CFTimeInterval) {
        
        player.position = CGPoint(x:player.position.x + cos(player.zRotation) * 2.5 ,y:player.position.y + sin(player.zRotation) * 2.5)
       
        
        if player.position.y < frame.minY + 35 {
            player.position.y = frame.minY + 35
        } else if player.position.y > frame.maxY-35 {
            player.position.y = frame.maxY - 35
        }
        
        if player.position.x < frame.minX + 80 {
            player.position.x = frame.minX + 80
        } else if player.position.x > frame.maxX-80 {
            player.position.x = frame.maxX - 80

                    }
        
        
      //  thruster1?.position = CGPoint(x:player.position.x + 25 , y:player.position.y - 25 )
    
      //  thruster1?.zRotation = player.zRotation
        
    
    }
    
    
    func updateTurret(_ dt: CFTimeInterval) {
      let deltaX = player.position.x - turretSprite.position.x
      let deltaY = player.position.y - turretSprite.position.y
      let angle = atan2(deltaY, deltaX)
      
      turretSprite.zRotation = angle - 270 * degreesToRadians
    }
    
    func updateHealthBar(_ node: SKSpriteNode, withHealthPoints hp: Int) {
      let barSize = CGSize(width: healthBarWidth, height: healthBarHeight);
      
      let fillColor = UIColor(red: 113.0/255, green: 202.0/255, blue: 53.0/255, alpha:1)
      let borderColor = UIColor(red: 35.0/255, green: 28.0/255, blue: 40.0/255, alpha:1)
      
      // create drawing context
      UIGraphicsBeginImageContextWithOptions(barSize, false, 0)
      guard let context = UIGraphicsGetCurrentContext() else { return }
      
      // draw the outline for the health bar
      borderColor.setStroke()
      let borderRect = CGRect(origin: CGPoint.zero, size: barSize)
      context.stroke(borderRect, width: 1)
      
      // draw the health bar with a colored rectangle
      fillColor.setFill()
      let barWidth = (barSize.width - 1) * CGFloat(hp) / CGFloat(maxHealth)
      let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: barSize.height - 1)
      context.fill(barRect)
      
      // extract image
      guard let spriteImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
      UIGraphicsEndImageContext()
      
      // set sprite texture and size
      node.texture = SKTexture(image: spriteImage)
      node.size = barSize
    }
    
    func checkShipCannonCollision() {
       let deltaX = player.position.x - turretSprite.position.x
       let deltaY = player.position.y - turretSprite.position.y
       
       let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
       guard distance <= cannonCollisionRadius + playerCollisionRadius else { return }
      
       
       let offsetDistance = cannonCollisionRadius + playerCollisionRadius - distance
       let offsetX = deltaX / distance * offsetDistance
       let offsetY = deltaY / distance * offsetDistance
       player.position = CGPoint(
         x: player.position.x + offsetX,
         y: player.position.y + offsetY
       )
       
    

       updateHealthBar(cannonHealthBar, withHealthPoints: cannonHP)
  
     }
    func checkShotCannonCollision() {
         let deltaX = shot.position.x - turretSprite.position.x
         let deltaY = shot.position.y - turretSprite.position.y
         
         let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
         guard distance <= cannonCollisionRadius + shotCollisionRadius else { return }
        
         
         let offsetDistance = cannonCollisionRadius + shotCollisionRadius - distance
         let offsetX = deltaX / distance * offsetDistance
         let offsetY = deltaY / distance * offsetDistance
         shot.position = CGPoint(
           x: shot.position.x + offsetX,
           y: shot.position.y + offsetY
         )
   
         cannonHP = max(0, cannonHP - 20)

         updateHealthBar(cannonHealthBar, withHealthPoints: cannonHP)
        
          shot.removeFromParent()
    
       }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        let sortedNodes = [nodeA, nodeB].sorted { $0.name ?? "" < $1.name ?? "" }
        
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]
        
        if secondNode.name == "player" {
            guard isPlayerAlive else { return }
            
            if let explosion = SKEmitterNode(fileNamed: "Explosion") {
                explosion.position = firstNode.position
                addChild(explosion)
            }
            
            playerShields -= 1
            if playerShields == 0 {
                gameOver()
                secondNode.removeFromParent()
            }
            
            firstNode.removeFromParent()
        } else if let enemy = firstNode as? EnemyNode {
            enemy.shields -= 1
            
            if enemy.shields == 0 {
                enemy.removeFromParent()
            }

            secondNode.removeFromParent()
        } else {
            firstNode.removeFromParent()
            secondNode.removeFromParent()
        }
    }
    
    func gameOver() {
        isPlayerAlive = false
        playAgain.position = CGPoint(x: frame.midX, y: frame.midY - 140)
        playAgain.fontColor = UIColor.white
        playAgain.fontSize = 60
        addChild(playAgain)
        
        if let explosion = SKEmitterNode(fileNamed: "Explosion") {
            explosion.position = player.position
            addChild(explosion)
        }
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
            addChild(gameOver)
    }

}
