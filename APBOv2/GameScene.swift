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
    
     
    let motionManager = CMMotionManager()
    let player = SKSpriteNode(imageNamed: "apbo")
    
       var isPlayerAlive = true
    override func didMove(to view: SKView) {
            physicsWorld.gravity = .zero
            physicsWorld.contactDelegate = self
            if let particles = SKEmitterNode(fileNamed: "Starfield") {
                particles.position = CGPoint(x: 500, y: 100)
        //        particles.advanceSimulationTime(60)
                particles.zPosition = -1
                addChild(particles)
    player.name = "apbo"
    player.position = CGPoint(x: size.width/2, y: size.height/2)
    player.zPosition = 1
    addChild(player)

    
player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
       player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.isDynamic = false
               
        
        let moveRight = SKAction.moveBy(x: 50, y:0, duration:3.0)
 
        let endless = SKAction.repeatForever(moveRight)
        player.run(endless)
 
    }
}

func movement() {
   

}

}
