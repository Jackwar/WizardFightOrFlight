//
//  OutterWalls.swift
//  FlappyBirds
//
//  Created by Jackson Warburton on 4/26/17.
//  Copyright © 2017 Jackson Warburton. All rights reserved.
//

import Foundation
import GameKit

class OutterWalls {
    
    static let destroyingGroup = UInt32(8)
    
    static func createWalls(scene: SKScene) {
    
        let ground = SKNode()
        ground.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: scene.frame.minX, y: scene.frame.minY), to: CGPoint(x: scene.frame.maxX, y: scene.frame.minY))
        ground.physicsBody?.restitution = 1.0
        scene.addChild(ground)
        
        let ceiling = SKNode()
        ceiling.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: scene.frame.minX, y: scene.frame.maxY), to: CGPoint(x: scene.frame.maxX, y: scene.frame.maxY))
        scene.addChild(ceiling)
        
        let leftWall = SKNode()
        leftWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: scene.frame.minX - 100, y: scene.frame.maxY), to: CGPoint(x: scene.frame.minX - 100, y: scene.frame.minY))
        
        leftWall.physicsBody?.categoryBitMask = destroyingGroup
        leftWall.physicsBody?.contactTestBitMask = UInt32(6)
        
        scene.addChild(leftWall)
        
        let rightWall = SKNode()
        rightWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: scene.frame.maxX + 250, y: scene.frame.maxY), to: CGPoint(x: scene.frame.maxX + 250, y: scene.frame.minY))
        
        rightWall.physicsBody?.categoryBitMask = destroyingGroup
        rightWall.physicsBody?.contactTestBitMask = UInt32(6)
        
        scene.addChild(rightWall)
    
    }
    
}
