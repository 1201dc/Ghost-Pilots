import Foundation
import SpriteKit
import Firebase

public class SpaceshipBase {
    public var lastTimeUpdated: Float?
    public var shipSprite: SKNode
    public var playerID: String
    public var isLocal = false;
    public var position = (0.0,0.0)
    public var angle = 0 // In degrees
    public var shipLabel = SKLabelNode(text: "name")
    var unfiredBullets: [SKSpriteNode] =
        [SKSpriteNode(imageNamed: "bullet"),
         SKSpriteNode(imageNamed: "bullet"),
         SKSpriteNode(imageNamed: "bullet")]
    let thruster1 = SKEmitterNode(fileNamed: "Thrusters")
    var timeUntilNextBullet: Double = 0.8;
    
    var unfiredBulletsCount = 0
    public var unfiredBulletRotator = SKNode();
    
    public var posRef: DatabaseReference = DatabaseReference()
    public var shotsRef: DatabaseReference = DatabaseReference()
    
    init(shipSprite: SKNode, playerId: String) {
        self.shipSprite = shipSprite
        self.playerID = playerId
        shipLabel.text = playerId
        shipSprite.addChild(shipLabel)
        shipLabel.fontName = "AvenirNext-Bold"
        shipLabel.position = CGPoint(x: 0, y: 23)
        
        
        thruster1?.position = CGPoint(x: -30, y: 0)
        shipSprite.addChild(thruster1!)
        
        posRef = Database.database().reference().child("Games/\(Global.gameData.gameID)/Players/\(playerID)/Pos")
        shotsRef = Database.database().reference().child("Games/\(Global.gameData.gameID)/Players/\(playerID)/Shots")
        
        for s in unfiredBullets {
            s.alpha = 0
        }
    }

    
    func UpdateShip(deltaTime: Double){
        unfiredBulletRotator.zRotation -= CGFloat(Double.pi/35)
        UniqueUpdateShip(deltaTime: deltaTime)
        
        // For online only, but no control yet
        if unfiredBulletsCount < 3 {
            timeUntilNextBullet -= deltaTime;
        }
        
        if (timeUntilNextBullet < 0 && unfiredBulletsCount < 3) {
            unfiredBullets[unfiredBulletsCount].alpha = 1;
            unfiredBulletsCount += 1
            timeUntilNextBullet = 1.3
        }
    }
    // Only to be ovveridden
    func UniqueUpdateShip(deltaTime: Double){
        print("Error: UniqueUpdateShip Was not properly overrided")
        
    }
    
    public func Shoot(shotType: Int){
        print (Global.gameData.shipsToUpdate)
        switch shotType {
        case 0:
            if unfiredBulletsCount > 0 {
                let bullet = SKSpriteNode(imageNamed: "bullet")
                bullet.zRotation = shipSprite.zRotation
                if isLocal {
                    bullet.zRotation = shipSprite.childNode(withName: "player")!.zRotation
                }
                bullet.position = shipSprite.position
                Global.gameData.gameScene.liveBullets.append(bullet)
                Global.gameData.gameScene.addChild(bullet)
                self.unfiredBulletsCount -= 1
                unfiredBullets[unfiredBulletsCount].alpha = 0;
            }
        case 1:
            print("Triple Shot")
        case 2:
            print("Laser")
        case 3:
            print("Mine")
        default:
            print("Error, LocalSpaceship given an invalid powerup number")
        }
        let thruster = SKEmitterNode(fileNamed: "Thrusters")
        thruster!.position = CGPoint(x: -30, y: 0)
        //thruster!.targetNode = self.scene
        // Idk if the above line is nessasary
        shipSprite.addChild(thruster!)
    }
    
}
