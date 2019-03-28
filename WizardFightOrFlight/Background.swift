//
//  Background.swift
//  FlappyBirds
//
//  Created by Jackson Warburton on 4/26/17.
//  Copyright © 2017 Jackson Warburton. All rights reserved.
//

import Foundation
import GameKit

class Background {
    
    static func createBackground(scene: SKScene, parentNode: SKNode, backgroundPath: String) {
        
        let backgroundTexture = SKTexture(imageNamed: backgroundPath)
        
        let moveBackground = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 9)
        
        let replaceBackground = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
        
        let moveBackgroundForever = SKAction.repeatForever(SKAction.sequence([moveBackground, replaceBackground]))
        
        for i:CGFloat in stride(from: 0, to: 4, by: 1) {
            
            let background = SKSpriteNode(texture: backgroundTexture)
            
            background.zPosition = -1
            
            background.position = CGPoint(x: -backgroundTexture.size().width + backgroundTexture.size().width * i, y: scene.frame.midY)
            
            background.size.height = scene.frame.height
            
            background.run(moveBackgroundForever)
            
            parentNode.addChild(background)
            
        }
    
    }
    
}
