//
//  Sorlos.swift
//  FlappyBirds
//
//  Created by Jackson Warburton on 4/23/17.
//  Copyright © 2017 Jackson Warburton. All rights reserved.
//

import Foundation
import GameplayKit

class Sorlos: SKSpriteNode {
    
    var sorlosTexture = SKTexture()
    var sorlosTexture2 = SKTexture()
    var sorlosFire1 = SKTexture()
    var sorlosFire2 = SKTexture()
    var sorlosFire3 = SKTexture()
    var sorlosFire4 = SKTexture()
    var sorlosFire5 = SKTexture()
    var sorlosHit = SKTexture()
    var flyAnimation = SKAction()
    var makeSorlosFly = SKAction()
    
    var destroyingGroup = 8
    let monsterGroup:UInt32 = 4
    let projectileGroup:UInt32 = 2
    let pipeGroup:UInt32 = 5
    let sorlosGroup: UInt32 = 1
    
    init() {
        
        sorlosTexture = SKTexture(imageNamed: "img/sorlosFlyingOne.png")
        sorlosTexture2 = SKTexture(imageNamed: "img/sorlosFlyingTwo.png")
        
        sorlosHit = SKTexture(imageNamed: "img/sorlosHit.png")
        
        sorlosFire1 = SKTexture(imageNamed: "img/sorlosfire1.png")
        sorlosFire2 = SKTexture(imageNamed: "img/sorlosfire2.png")
        sorlosFire3 = SKTexture(imageNamed: "img/sorlosfire3.png")
        sorlosFire4 = SKTexture(imageNamed: "img/sorlosfire4.png")
        sorlosFire5 = SKTexture(imageNamed: "img/sorlosfire5.png")
        
        super.init(texture: sorlosTexture, color: SKColor.clear, size: sorlosTexture.size())
        
        flyAnimation = SKAction.animate(with: [sorlosTexture, sorlosTexture2], timePerFrame: 0.8, resize: true, restore: true)
        
        makeSorlosFly = SKAction.repeatForever(flyAnimation)
        
        self.texture = sorlosTexture
        
        self.run(makeSorlosFly)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2)
        
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = sorlosGroup
        
        self.physicsBody?.contactTestBitMask = UInt32(5)
        
        self.zPosition = 10
        
        self.setScale(CGFloat(1.5))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fire() {
        
        let fireAnimation = SKAction.animate(with: [sorlosFire1, sorlosFire2, sorlosFire3, sorlosFire4, sorlosFire5], timePerFrame: 0.1, resize: true, restore: true)
        
        let fireSequence = SKAction.sequence([fireAnimation, makeSorlosFly])
        
        self.run(fireSequence)
    }
    
    func hit() {
        
        let hitAnimation = SKAction.animate(with: [sorlosHit], timePerFrame: 10, resize: true, restore: true)
        
        self.physicsBody?.isDynamic = false
        
        self.color = UIColor.black
        
        self.run(hitAnimation)
    }
    
}

