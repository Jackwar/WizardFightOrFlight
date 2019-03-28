//
//  FireButton.swift
//  FlappyBirds
//
//  Created by Jackson Warburton on 4/26/17.
//  Copyright © 2017 Jackson Warburton. All rights reserved.
//

import Foundation
import GameKit

class FireButton {
    
    static var fireButton = SKSpriteNode()
    
    static let buttonPressed = SKTexture(imageNamed: "img/buttonPressed.png")
    static let buttonUnPressed = SKTexture(imageNamed: "img/buttonUnPressed.png")
    
    static func createFireButton(scene: SKScene) {
        
        fireButton = SKSpriteNode(texture: buttonUnPressed)
        
        fireButton.position = CGPoint(x: scene.frame.minX + 100, y: scene.frame.minY + 100)
        
        fireButton.zPosition = 20
        
        scene.addChild(fireButton)
        
    }
    
    static func pressButton() {
        
        fireButton.texture = buttonPressed
        
    }
    
    
    static func depressButton() {
        
        fireButton.texture = buttonUnPressed
        
    }
}
