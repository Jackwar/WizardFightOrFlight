//
//  BossScene.swift
//  FlappyBirds
//
//  Created by Jackson Warburton on 4/25/17.
//  Copyright © 2017 Jackson Warburton. All rights reserved.
//

import Foundation

import GameplayKit
import AVFoundation

class BossScene: SKScene, SKPhysicsContactDelegate {

    var superSorlosFire = Timer()
    var superSorlosFiring = Timer()
    
    var backgroundMusic = AVAudioPlayer()
    var background = SKSpriteNode()
    var superSorlos = SuperSorlos()
    var sorlos = Sorlos()

    var iFoundYou = SKLabelNode()
    var fireCooling = false
    var parentNode = SKNode()
    
    let destroyingGroup:UInt32 = 8
    let projectileGroup: UInt32 = 2
    let superSorlosGroup:UInt32 = 4
    let sorlosGroup: UInt32 = 1
    
    var gameOver = false
    var newGameAllowed = false
    
    var sorlosLives = 3
    var superSorlosLives = 20
    
    var xSorlosPosition = CGFloat()
    
    override func didMove(to view: SKView) {
        
        AppDelegate.gameScene = nil
        AppDelegate.bossScene = self
        
        self.physicsWorld.contactDelegate = self
        
        let path = Bundle.main.path(forResource: "music/fight.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
    
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: url)
            backgroundMusic.play()
            backgroundMusic.numberOfLoops = -1
            AppDelegate.audioUrl = url
            AppDelegate.audioPlayer = backgroundMusic
        } catch {
            print("fail")
        }
    
        iFoundYou.text = "I found you!"
        
        iFoundYou.fontSize = 100
        iFoundYou.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 200)
        iFoundYou.fontColor = UIColor.red
        
        self.addChild(iFoundYou)
        
        _ = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(BossScene.removeLabel), userInfo: nil, repeats: false)
        
        Score.createLabel(scene: self)
        
        FireButton.createFireButton(scene: self)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -4)
        
        parentNode = SKNode()
        
        self.addChild(parentNode)
        
        Background.createBackground(scene: self, parentNode: parentNode, backgroundPath: "img/back.png")
        
        sorlos.position = CGPoint(x: CGFloat(self.frame.minX + 100), y: CGFloat(self.frame.midY))
        
        sorlos.physicsBody?.categoryBitMask = sorlosGroup
        sorlos.physicsBody?.collisionBitMask = projectileGroup
        
        xSorlosPosition = sorlos.position.x

        self.addChild(sorlos)
        
        superSorlos = SuperSorlos()
        
        superSorlos.position = CGPoint(x: CGFloat(self.frame.maxX - 100), y: CGFloat(self.frame.midY))
        
        self.addChild(superSorlos)
        
        OutterWalls.createWalls(scene: self)

        _ = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(BossScene.superSorlosStartFiring), userInfo: nil, repeats: false)

        
    
    }
    
    @objc func fire() {
        superSorlos.fire()
        
        SuperFireBall.createFireBall(scene: self, sorlos: superSorlos)
    }
    
    @objc func randomFlyAround() {
        
        let y = Int(self.frame.maxY) - 100
        
        let randomY = Int(arc4random_uniform(UInt32(y * 2))) - y
        
        let animation = SKAction.moveTo(y: CGFloat(randomY), duration: 0.1)
        
        superSorlos.run(animation)
        
    }
    
    @objc func removeLabel() {
        
        let animation = SKAction.fadeOut(withDuration: 1)
        
        let destroyLabel = SKAction.removeFromParent()
        
        let animationSequence = SKAction.sequence([animation, destroyLabel])
        
        iFoundYou.run(animationSequence)
        
        
        
    }
    
    @objc func fireCooldown() {
        
        fireCooling = false
        
    }
    
    @objc func allowNewGame() {
        
        newGameAllowed = true
        
    }
    
    func endGame() {
        
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(BossScene.allowNewGame), userInfo: nil, repeats: false)
        
        gameOver = true
        
        superSorlosFire.invalidate()
        superSorlosFiring.invalidate()
        
        let path = Bundle.main.path(forResource: "music/NoMoreMagic.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: url)
            backgroundMusic.play()
            backgroundMusic.numberOfLoops = -1
            AppDelegate.audioUrl = url
            AppDelegate.audioPlayer = backgroundMusic
        } catch {
            print("fail")
        }
        
        self.removeAllChildren()
        
        self.backgroundColor = UIColor.black
        
        let gameOverBackgroundTexture = SKTexture(imageNamed: "img/spellbookNoSorlos.png")
        
        let background = SKSpriteNode(texture: gameOverBackgroundTexture)
        
        background.zPosition = -1
        
        background.size.height = self.frame.height
        
        background.size.width = self.frame.width * 3
        
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        self.addChild(background)
        
        
        let gameOverLabel = SKLabelNode(text: "Game Over")
        
        gameOverLabel.fontSize = 100
        gameOverLabel.fontName = "AvenirNext-Bold"
        gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 200)

        var finalScoreLabel = SKLabelNode()
        
        if (Score.score > Score.highScore) {
            
            finalScoreLabel = SKLabelNode(text: "New High Score: \(Score.score)")
            
            finalScoreLabel.fontSize = 60
            finalScoreLabel.fontName = "AvenirNext-Bold"
            finalScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 200)
            
            Score.setHighScore()
            
        } else {
        
            finalScoreLabel = SKLabelNode(text: "Final Score: \(Score.score)")
        
            finalScoreLabel.fontSize = 60
            finalScoreLabel.fontName = "AvenirNext-Bold"
            finalScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 200)
            
            let highScoreLabel = SKLabelNode(text: "High Score: \(Score.highScore)")
            highScoreLabel.fontSize = 60
            highScoreLabel.fontName = "AvenirNext-Bold"
            highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 300)
            
            self.addChild(highScoreLabel)
            
        }

        
        let tryAgainLabel = SKLabelNode(text: "Tap to play again")
        
        tryAgainLabel.fontSize = 60
        tryAgainLabel.fontName = "AvenirNext-Bold"
        tryAgainLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 400)

        
        self.addChild(gameOverLabel)
        self.addChild(finalScoreLabel)
        self.addChild(tryAgainLabel)
        
    }
    
    @objc func superSorlosStartFiring() {
        
        superSorlosFire = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(BossScene.randomFlyAround), userInfo: nil, repeats: true)
        
        superSorlosFiring = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(BossScene.fire), userInfo: nil, repeats: true)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if (contact.bodyA.categoryBitMask == destroyingGroup || contact.bodyB.categoryBitMask == destroyingGroup) {
    
            if (contact.bodyA.categoryBitMask == destroyingGroup) {
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }
        } else if (contact.bodyA.categoryBitMask == sorlosGroup || contact.bodyB.categoryBitMask == sorlosGroup) {
    
            if (contact.bodyA.categoryBitMask == projectileGroup && contact.bodyB.categoryBitMask == sorlosGroup) {
                
                SuperFireBall.explodeFireBall(explodingFireBall: contact.bodyA.node as! SKSpriteNode)
                
                sorlosLives -= 1
                
                if (sorlosLives == 0) {
                    sorlos.removeFromParent()
                    endGame()
                }
                
            } else if (contact.bodyB.categoryBitMask == projectileGroup && contact.bodyA.categoryBitMask == sorlosGroup) {
                
                SuperFireBall.explodeFireBall(explodingFireBall: contact.bodyB.node as! SKSpriteNode)
                
                sorlosLives -= 1
                
                if (sorlosLives == 0) {
                    sorlos.removeFromParent()
                    endGame()
                }

            }
            
        } else if (contact.bodyA.categoryBitMask == superSorlosGroup || contact.bodyB.categoryBitMask == superSorlosGroup) {
            
            if (contact.bodyA.categoryBitMask == projectileGroup && contact.bodyB.categoryBitMask == superSorlosGroup) {
                
                Score.updateScore(update: 10)
                
                SuperFireBall.explodeFireBall(explodingFireBall: contact.bodyA.node as! SKSpriteNode)
                
                superSorlosLives -= 1
                
                if (superSorlosLives == 0) {
                    superSorlos.removeFromParent()
                    Score.updateScore(update: 1000000)
                    endGame()
                }
                
            } else if (contact.bodyB.categoryBitMask == projectileGroup && contact.bodyA.categoryBitMask == superSorlosGroup) {
                
                Score.updateScore(update: 10)
                
                SuperFireBall.explodeFireBall(explodingFireBall: contact.bodyB.node as! SKSpriteNode)
                
                superSorlosLives -= 1
                
                if (superSorlosLives == 0) {
                    superSorlos.removeFromParent()
                    Score.updateScore(update: 1000000)
                    endGame()
                }
                
            }
            
        } else if (contact.bodyA.categoryBitMask == projectileGroup && contact.bodyB.categoryBitMask == projectileGroup) {
            
            SuperFireBall.explodeFireBall(explodingFireBall: contact.bodyA.node as! SKSpriteNode)
            SuperFireBall.explodeFireBall(explodingFireBall: contact.bodyB.node as! SKSpriteNode)
            
            Score.updateScore(update: 5)
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            if (!gameOver) {
                let location = touch.location(in: self)
            // Check if the location of the touch is within the button's bounds
                if (FireButton.fireButton.contains(location)) {
                    if (!fireCooling) {
                        FireButton.pressButton()
                        sorlos.fire()
                        FireBall.createFireBallBossScene(scene: self, sorlos: sorlos, parentNode: parentNode)
                            fireCooling = true
                        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(BossScene.fireCooldown), userInfo: nil, repeats: false)
                    }
                } else {
                    sorlos.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    sorlos.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 80))
                }
            } else if(newGameAllowed) {
                
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.location(in: self)
            // Check if the location of the touch is within the button's bounds
            if FireButton.fireButton.contains(location) {
                FireButton.depressButton()
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        sorlos.position = CGPoint(x: xSorlosPosition, y: sorlos.position.y)
        
    }
}
