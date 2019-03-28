//
//  Monster.swift
//  FlappyBirds
//
//  Created by Jackson Warburton on 4/23/17.
//  Copyright © 2017 Jackson Warburton. All rights reserved.
//

import Foundation
import GameKit

class Monster {
    
    static var monster = SKSpriteNode()
    static var monsterMove1 = SKTexture()
    static var monsterMove2 = SKTexture()
    static var monsterMove3 = SKTexture()
    static var monsterMove4 = SKTexture()
    static var monsterMove5 = SKTexture()
    static var monsterDeath1 = SKTexture()
    static var monsterDeath2 = SKTexture()
    static var monsterDeath3 = SKTexture()
    static var monsterDeath4 = SKTexture()
    static var monsterDeath5 = SKTexture()
    static var monsterDeath6 = SKTexture()
    static var monsterDeath7 = SKTexture()
    static var monsterDeath8 = SKTexture()
    
    static var destroyingGroup = 8
    static let monsterGroup:UInt32 = 4
    static let projectileGroup:UInt32 = 2
    static let pipeGroup:UInt32 = 5
    static let sorlosGroup: UInt32 = 1
    
    static func createMonster(scene: SKScene, parentNode: SKNode) {
        
        monsterMove1 = SKTexture(imageNamed: "img/monster1.png")
        monsterMove2 = SKTexture(imageNamed: "img/monster2.png")
        monsterMove3 = SKTexture(imageNamed: "img/monster3.png")
        monsterMove4 = SKTexture(imageNamed: "img/monster4.png")
        monsterMove5 = SKTexture(imageNamed: "img/monster5.png")
        
        monsterDeath1 = SKTexture(imageNamed: "img/monsterDeath1.png")
        monsterDeath2 = SKTexture(imageNamed: "img/monsterDeath2.png")
        monsterDeath3 = SKTexture(imageNamed: "img/monsterDeath3.png")
        monsterDeath4 = SKTexture(imageNamed: "img/monsterDeath4.png")
        monsterDeath5 = SKTexture(imageNamed: "img/monsterDeath5.png")
        monsterDeath6 = SKTexture(imageNamed: "img/monsterDeath6.png")
        monsterDeath7 = SKTexture(imageNamed: "img/monsterDeath7.png")
        monsterDeath8 = SKTexture(imageNamed: "img/monsterDeath8.png")
        
        monster = SKSpriteNode(texture: monsterMove1)
        
        let moveMonster = SKAction.animate(with: [monsterMove1, monsterMove2, monsterMove3, monsterMove4, monsterMove5], timePerFrame: 0.1, resize: true, restore: true)
        
        let moveMonsterForever = SKAction.repeatForever(moveMonster)
        
        monster.setScale(CGFloat(2))
        
        monster.physicsBody = SKPhysicsBody(circleOfRadius: monster.size.height / 2)
        
        monster.physicsBody?.isDynamic = true
        
        monster.physicsBody?.affectedByGravity = false
        
        let y = Int(scene.frame.maxY) - 100
        
        let movementAmount = Int(arc4random_uniform(UInt32(y * 2))) - y
        
        monster.position = CGPoint(x: scene.frame.maxX + 200, y: CGFloat(movementAmount))
        
        monster.run(moveMonsterForever)
        
        monster.physicsBody?.collisionBitMask = 2
        
        monster.physicsBody?.categoryBitMask = monsterGroup
        
        monster.physicsBody?.contactTestBitMask = UInt32(11)
        
        monster.zPosition = 15
        
        parentNode.addChild(monster)
        
        monster.physicsBody?.applyImpulse(CGVector(dx: -30, dy: 0))
    }
    
    static func killMonster(monsterToKill: SKSpriteNode) {
        
        monsterToKill.physicsBody?.categoryBitMask = 0
        
        monsterToKill.physicsBody?.isDynamic = false
        
        let killMonsterAnimations = SKAction.animate(with: [monsterDeath1, monsterDeath2, monsterDeath3, monsterDeath4, monsterDeath5, monsterDeath6, monsterDeath7, monsterDeath8], timePerFrame: 0.1, resize: true, restore: true)
        
        let killMonster = SKAction.removeFromParent()
        
        let killMonsterSequence = SKAction.sequence([killMonsterAnimations, killMonster])
        
        monsterToKill.run(killMonsterSequence)
    }
    
}
