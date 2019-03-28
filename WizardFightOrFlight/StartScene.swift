//
//  StartScene.swift
//  FlappyBirds
//
//  Created by Jackson Warburton on 4/26/17.
//  Copyright © 2017 Jackson Warburton. All rights reserved.
//

import Foundation

import GameplayKit
import AVFoundation

class StartScene: SKScene, SKPhysicsContactDelegate {
    
    var backgroundMusic = AVAudioPlayer()
    
    override func didMove(to view: SKView) {
        
        AppDelegate.audioPlayer = backgroundMusic
        
        AppDelegate.startScene = self
        
        let path = Bundle.main.path(forResource: "music/Harp.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: url)
            backgroundMusic.play()
            backgroundMusic.volume = 3
            backgroundMusic.numberOfLoops = -1
            AppDelegate.audioUrl = url
        } catch {
            print("fail")
        }
        
        print(backgroundMusic.volume)
        
        self.physicsWorld.contactDelegate = self
        
        Score.getHighScore()
        
        self.backgroundColor = UIColor.black
        
        let backgroundTexture = SKTexture(imageNamed: "img/spellbookFight.png")
        
        let background = SKSpriteNode(texture: backgroundTexture)
        
        background.zPosition = -1
        
        background.size.height = self.frame.height
        
        background.size.width = self.frame.width * 3
        
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        self.addChild(background)
        
        let titleLabel = SKLabelNode(text: "Wizard Fight or Flight")
        
        titleLabel.fontSize = 50
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 200)

        self.addChild(titleLabel)
        
        let highScoreLabel = SKLabelNode(text: "High Score: \(Score.highScore)")
        
        highScoreLabel.fontSize = 60
        highScoreLabel.fontName = "AvenirNext-Bold"
        highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 200)
        
        self.addChild(highScoreLabel)
        
        let playLabel = SKLabelNode(text: "Tap to play")
        
        playLabel.fontSize = 60
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 300)
        
        self.addChild(playLabel)
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for _: AnyObject in touches {
            
            backgroundMusic.stop()
            
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition:SKTransition = SKTransition.doorsOpenHorizontal(withDuration: 2)
                // Present the scene
                view?.presentScene(scene, transition: transition)
            }
            
        }
    }
    
}
