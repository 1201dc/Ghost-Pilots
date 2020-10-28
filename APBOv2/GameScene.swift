//
//  GameScene.swift
//  APBOv2
//
//  Created by 90306670 on 10/20/20.
//  Copyright © 2020 Dhruv Chowdhary. All rights reserved.
//

import SpriteKit
import CoreMotion

enum CollisionType: UInt32 {
case player = 1
case playerWeapon = 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let turnButton = SKSpriteNode(imageNamed: "button")
    let motionManager = CMMotionManager()
    let player = SKSpriteNode(imageNamed: "apbo")
    var count = 0;
    
       var isPlayerAlive = true
    override func didMove(to view: SKView) {
            physicsWorld.gravity = .zero
            physicsWorld.contactDelegate = self
            if let particles = SKEmitterNode(fileNamed: "Starfield") {
                particles.position = CGPoint(x: 500, y: 100)
        //      particles.advanceSimulationTime(60)
                particles.zPosition = -1
                addChild(particles)
                
                player.name = "apbo"
                player.position.x = size.width/2
                player.position.y = size.height/2
              
                player.zPosition = 1
                addChild(player)
                
                turnButton.name = "btn"
                turnButton.size.height = 100
                turnButton.size.width = 100
                turnButton.position = CGPoint(x: self.frame.maxX*0.9,y: self.frame.midY)
                self.addChild(turnButton)
                
                
           
    
player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
       player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.isDynamic = false
               
        
      //  let moveRight = SKAction.moveBy(x: 50, y:0, duration:5.0)
 
     //   let endless = SKAction.repeatForever(moveRight)
      //  player.run(endless)
 
    }
}
 let rotate = SKAction.rotate(byAngle: -1, duration: 0.5)
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)

     if let name = touchedNode.name {
            if name == "btn" {
                player.zRotation=player.zRotation-0.8
    //        let rotate = SKAction.rotate(byAngle: -1, duration: 0.5)
   //         let rotateEndless = SKAction.repeatForever(rotate)
  //      player.run(rotateEndless)
                count=1;
            }
       } else {
               count=0;
       }
    }
 
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

   /*     if count==1 {
            let rotate = SKAction.rotate(byAngle: 1, duration: 0.5)
            let rotateEndless = SKAction.repeatForever(rotate)
                player.run(rotateEndless)
        }
*/
            
            
        }
    
    override func update(_ currentTime: TimeInterval) {
        player.position = CGPoint(x:player.position.x + cos(player.zRotation) * 2.5 ,y:player.position.y + sin(player.zRotation) * 2.5)
       
        
        if player.position.y < frame.minY + 40 {
            player.position.y = frame.minY + 40
        } else if player.position.y > frame.maxY-40 {
            player.position.y = frame.maxY - 40
        }
        
        if player.position.x < frame.minX + 40 {
            player.position.x = frame.minX + 40
        } else if player.position.x > frame.maxX-40 {
            player.position.x = frame.maxX - 40 //hi
        }
        


    }
    
    
func movement() {
   

}

}
