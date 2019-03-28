//
//  SuperFireBall.swift
//  FlappyBirds
//
//  Created by Jackson Warburton on 4/25/17.
//  Copyright © 2017 Jackson Warburton. All rights reserved.
//

import Foundation
import GameKit

class SuperFireBall {
    
    static var fireBall = SKSpriteNode()
    static var fireBallCreated = SKTexture()
    static var fireBall1 = SKTexture()
    static var fireBall2 = SKTexture()
    static var fireBall3 = SKTexture()
    
    static var explosion1 = SKTexture()
    static var explosion2 = SKTexture()
    static var explosion3 = SKTexture()
    static var explosion4 = SKTexture()
    static var explosion5 = SKTexture()
    static var explosion6 = SKTexture()
    static var explosion7 = SKTexture()
    static var explosion8 = SKTexture()
    static var explosion9 = SKTexture()
    static var explosion10 = SKTexture()
    static var explosion11 = SKTexture()
    static var explosion12 = SKTexture()
    
    static var destroyingGroup = 8
    static let monsterGroup:UInt32 = 4
    static let projectileGroup:UInt32 = 2
    static let pipeGroup:UInt32 = 5
    static let sorlosGroup: UInt32 = 1
    
    static func createFireBall(scene: SKScene, sorlos: SKSpriteNode) {
        
        fireBallCreated = SKTexture(imageNamed: "img/superSorlosFireBallCreation.png")
        fireBall1 = SKTexture(imageNamed: "img/superSorlosFireBall1.png")
        fireBall2 = SKTexture(imageNamed: "img/superSorlosFireBall2.png")
        fireBall3 = SKTexture(imageNamed: "img/superSorlosFireBall3.png")
        
        explosion1 = SKTexture(imageNamed: "img/Explosion1.png")
        explosion2 = SKTexture(imageNamed: "img/Explosion2.png")
        explosion3 = SKTexture(imageNamed: "img/Explosion3.png")
        explosion4 = SKTexture(imageNamed: "img/Explosion4.png")
        explosion5 = SKTexture(imageNamed: "img/Explosion5.png")
        explosion6 = SKTexture(imageNamed: "img/Explosion6.png")
        explosion7 = SKTexture(imageNamed: "img/Explosion7.png")
        explosion8 = SKTexture(imageNamed: "img/Explosion8.png")
        explosion9 = SKTexture(imageNamed: "img/Explosion9.png")
        explosion10 = SKTexture(imageNamed: "img/Explosion10.png")
        explosion11 = SKTexture(imageNamed: "img/Explosion11.png")
        explosion12 = SKTexture(imageNamed: "img/Explosion12.png")
        
        fireBall = SKSpriteNode(texture: fireBallCreated)
        fireBall.size = fireBall1.size()
        
        let fireCreation = SKAction.animate(with: [fireBallCreated], timePerFrame: 0.1, resize: true, restore: true)
        
        let fireAnimation = SKAction.animate(with: [fireBall1, fireBall2, fireBall3], timePerFrame: 0.1, resize: true, restore: true)
        
        let fireAnimationForever = SKAction.repeatForever(fireAnimation)
        
        let fireSequence = SKAction.sequence([fireCreation, fireAnimationForever])
        
        fireBall.setScale(CGFloat(2.5))
        
        fireBall.physicsBody = SKPhysicsBody(circleOfRadius: fireBall.size.height / 2)
        
        fireBall.physicsBody?.isDynamic = true
        
        fireBall.physicsBody?.affectedByGravity = false
        
        fireBall.position = CGPoint(x: sorlos.frame.minX - 100, y: sorlos.frame.midY + 10)
        
        fireBall.run(fireSequence)
        
        //fireBall.physicsBody?.collisionBitMask = 1
        
        fireBall.physicsBody?.categoryBitMask = UInt32(2)
        
        fireBall.physicsBody?.contactTestBitMask = UInt32(11)
        
        scene.addChild(fireBall)
        
        fireBall.physicsBody?.applyImpulse(CGVector(dx: -30, dy: 0))
        
    }
    
    static func explodeFireBall(explodingFireBall: SKSpriteNode) {
        
        explodingFireBall.setScale(CGFloat(1))
        
        explodingFireBall.physicsBody?.categoryBitMask = 0
        
        let explodeFireBallAnimations = SKAction.animate(with: [explosion1, explosion2, explosion3, explosion4, explosion5, explosion6, explosion7, explosion8, explosion9, explosion10, explosion11, explosion12], timePerFrame: 0.05, resize: true, restore: true)
        
        let destroyFireBall = SKAction.removeFromParent()
        
        let explodeFireBallSequence = SKAction.sequence([explodeFireBallAnimations, destroyFireBall])
        
        explodingFireBall.run(explodeFireBallSequence)
        
    }
}
