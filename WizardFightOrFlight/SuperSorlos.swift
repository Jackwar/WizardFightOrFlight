//
//  SuperSorlos.swift
//  FlappyBirds
//
//  Created by Jackson Warburton on 4/25/17.
//  Copyright © 2017 Jackson Warburton. All rights reserved.
//

import Foundation
import GameplayKit

class SuperSorlos: SKSpriteNode {
    
    var superSorlosTexture = SKTexture()
    var superSorlosFire1 = SKTexture()
    var superSorlosFire2 = SKTexture()
    var superSorlosFire3 = SKTexture()
    var superSorlosFire4 = SKTexture()
    var superSorlosFire5 = SKTexture()
    var superSorlosDeath = SKTexture()
    
    var destroyingGroup = 8
    let monsterGroup:UInt32 = 4
    let projectileGroup:UInt32 = 2
    let pipeGroup:UInt32 = 5
    let sorlosGroup: UInt32 = 1
    
    init() {
        
        superSorlosTexture = SKTexture(imageNamed: "img/superSorlosStill.png")
        
        superSorlosDeath = SKTexture(imageNamed: "img/superSorlosDeath.png")
        
        superSorlosFire1 = SKTexture(imageNamed: "img/superSorlosFiring1.png")
        superSorlosFire2 = SKTexture(imageNamed: "img/superSorlosFiring2.png")
        superSorlosFire3 = SKTexture(imageNamed: "img/superSorlosFiring3.png")
        superSorlosFire4 = SKTexture(imageNamed: "img/superSorlosFiring4.png")
        superSorlosFire5 = SKTexture(imageNamed: "img/superSorlosFiring5.png")
        
        super.init(texture: superSorlosTexture, color: SKColor.clear, size: superSorlosTexture.size())
        
        self.texture = superSorlosTexture
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2)
        
        self.physicsBody?.isDynamic = false
        
        self.physicsBody?.categoryBitMask = UInt32(4)
        
        self.physicsBody?.contactTestBitMask = UInt32(2)
        
        self.zPosition = 10
        
        self.setScale(CGFloat(2.0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func fire() {
        
        let fireAnimation = SKAction.animate(with: [superSorlosFire1, superSorlosFire2, superSorlosFire3, superSorlosFire4, superSorlosFire5], timePerFrame: 0.1, resize: true, restore: true)
        
        //let fireSequence = SKAction.sequence([fireAnimation, makeSuperSorlosFly])
        
        self.run(fireAnimation)
    }
    
}
