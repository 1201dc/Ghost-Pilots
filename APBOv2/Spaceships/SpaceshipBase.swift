import Foundation
import SpriteKit
import Firebase

class SpaceshipBase {
    public var lastTimeUpdated: Float?
    public var shipSprite: SKSpriteNode
    public var playerID: String
    public var position = (0.0,0.0)
    public var angle = 0 // In degrees
    
    init(shipSprite: SKSpriteNode, playerId: String) {
        self.shipSprite = shipSprite
        self.playerID = playerId
    }

    // Only to be ovveridden
    func UpdateShip(deltaTime: Float, inputs: [InputType]){
        print("Error: UpdateShip Was not properly overrided")
    }
    
    
}


enum InputType {
    // Refers to button positions
    case Rotate, Shoot, Ghost
}