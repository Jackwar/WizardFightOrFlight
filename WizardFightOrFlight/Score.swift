//
//  Score.swift
//  FlappyBirds
//
//  Created by Jackson Warburton on 4/26/17.
//  Copyright © 2017 Jackson Warburton. All rights reserved.
//

import Foundation
import GameKit

final class Score {
    
    static var scoreLabel = SKLabelNode()
    static var highScoreLabel = SKLabelNode()
    static var score = 0
    static var highScore = 0
    
    static func createLabel(scene: SKScene) {
        
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        
        scoreLabel.fontColor = UIColor.orange
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = CGFloat(30)
        scoreLabel.position = CGPoint(x: scene.frame.minX + 75, y: scene.frame.maxY - 50)
        scoreLabel.zPosition = 50
        
        highScoreLabel = SKLabelNode(text: "High Score: \(highScore)")
        
        highScoreLabel.fontColor = UIColor.orange
        highScoreLabel.fontName = "Helvetica"
        highScoreLabel.fontSize = CGFloat(30)
        highScoreLabel.position = CGPoint(x: scene.frame.maxX - 150, y: scene.frame.maxY - 50)
        highScoreLabel.zPosition = 50
        
        scene.addChild(scoreLabel)
        scene.addChild(highScoreLabel)
    }
    
    static func updateScore(update: Int) {
        
        score += update
        scoreLabel.text = "Score: \(score)"
        
    }
    
    static func getHighScore() {
        
        highScore = UserDefaults.standard.integer(forKey: "highScore")
        
    }
    
    static func setHighScore() {
        
        highScore = score
        UserDefaults.standard.set(highScore, forKey: "highScore")
        
    }
    
    static func resetScore() {
        
        score = 0
        
    }
    
}
