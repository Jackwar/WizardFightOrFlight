//
//  GameScene.swift
//  FlappyBirds
//
//  Created by Jackson Warburton on 4/15/17.
//  Copyright © 2017 Jackson Warburton. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gapHeight: CGFloat?
    var wallOffset: CGFloat?
    var movementAmount: UInt32?
    
    var backgroundMusic = AVAudioPlayer()
    var sorlos = Sorlos()
    
    var makePipesTimer = Timer()
    var spawnMonsterTimer = Timer()
    
    var fireCooling = false
    
    var transition = false
    
    let destroyingGroup:UInt32 = 8
    let monsterGroup:UInt32 = 4
    let projectileGroup:UInt32 = 2
    let pipeGroup:UInt32 = 5
    let sorlosGroup: UInt32 = 1
    
    var pipeDifficultyTime = 3.0
    var pipeDifficulty = CGFloat(100)
    var monsterDifficulty = 5.0
    
    var parentNode = SKNode()
    
    var currentLevel: SwitchLevel!
    
    var switchLevels: [SwitchLevel] = []
    
    var columnCount = 0
    
    var columnsTop = Queue<Column>()
    var columnsBottom = Queue<Column>()
    
    override func didMove(to view: SKView) {
        
        AppDelegate.bossScene = nil
        AppDelegate.startScene = nil
        
        AppDelegate.gameScene = self
        
        initSwitchLevelsArray()
        
        Score.resetScore()
        
        Score.createLabel(scene: self)
        
        self.backgroundColor = UIColor.white
        
        self.physicsWorld.contactDelegate = self
        
        self.addChild(parentNode)
        
        OutterWalls.createWalls(scene: self)
        
        FireButton.createFireButton(scene: self)
        
        createSprites()
        
    }
    
    @objc func makeWalls() {
        
        Score.updateScore(update: 1)
        
        if (pipeDifficultyTime > 0.5) {
            pipeDifficultyTime -= 0.1
        }
        if (pipeDifficulty < 200) {
            pipeDifficulty += 6
        }
        
        makePipesTimer = Timer.scheduledTimer(timeInterval: pipeDifficultyTime, target: self, selector: #selector(GameScene.makeWalls), userInfo: nil, repeats: false)
        
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        let wallOffset = CGFloat(movementAmount) - self.frame.size.height / 4
        
        let moveWalls = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: TimeInterval(self.frame.size.width / pipeDifficulty))
        
        let removeWalls = SKAction.removeFromParent()
        
        if(columnCount < 5)
        {
            //Wall1
            let wall1Texture = SKTexture(imageNamed: currentLevel.pipe1)
            let wall1 = Column(texture: wall1Texture, columnType: ColumnType.TOP)
            let enqueueWallsTop = SKAction.run{
                self.columnsTop.enqueue(wall1)
            }
            
            let moveAndRemovePipesTop = SKAction.sequence([moveWalls, removeWalls, enqueueWallsTop])
            
            wall1.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + wall1.size.height / 2 + gapHeight! / 2 + wallOffset)
            wall1.run(moveAndRemovePipesTop)
            
            wall1.physicsBody = SKPhysicsBody(rectangleOf: wall1.size)
            wall1.physicsBody?.isDynamic = false
            
            wall1.physicsBody?.collisionBitMask = 1
            
            wall1.physicsBody?.contactTestBitMask = UInt32(3)
            wall1.physicsBody?.categoryBitMask = pipeGroup
            
            parentNode.addChild(wall1)
            
            //Wall2
            let wall2Texture = SKTexture(imageNamed: currentLevel.pipe2)
            let wall2 = Column(texture: wall2Texture, columnType: ColumnType.BOTTOM)
            let enqueueWallsBottom = SKAction.run{
                self.columnsBottom.enqueue(wall2)
            }
            
            let moveAndRemovePipesBottom = SKAction.sequence([moveWalls, removeWalls, enqueueWallsBottom])
            
            wall2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - wall2.size.height / 2 - gapHeight! / 2 + wallOffset)
            wall2.run(moveAndRemovePipesBottom)
            
            wall2.physicsBody = SKPhysicsBody(rectangleOf: wall2.size)
            wall2.physicsBody?.isDynamic = false
            
            wall2.physicsBody?.collisionBitMask = 1
            
            wall2.physicsBody?.contactTestBitMask = UInt32(3)
            wall2.physicsBody?.categoryBitMask = pipeGroup
            
            parentNode.addChild(wall2)
            
            columnCount += 1
        }
        else
        {
            let wall1 = columnsTop.dequeue()!
            let wall2 = columnsBottom.dequeue()!
            
            wall1.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + wall1.size.height / 2 + gapHeight! / 2 + wallOffset)
            wall2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - wall2.size.height / 2 - gapHeight! / 2 + wallOffset)
            
            let enqueueWallsTop = SKAction.run{
                self.columnsTop.enqueue(wall1)
            }
            let moveAndRemovePipesTop = SKAction.sequence([moveWalls, removeWalls, enqueueWallsTop])
            
            wall1.run(moveAndRemovePipesTop)
            
            let enqueueWallsBottom = SKAction.run{
                self.columnsBottom.enqueue(wall2)
            }
            
            let moveAndRemovePipesBottom = SKAction.sequence([moveWalls, removeWalls, enqueueWallsBottom])
            
            wall2.run(moveAndRemovePipesBottom)
            
            parentNode.addChild(wall1)
            parentNode.addChild(wall2)
            
        }
    }
    
    @objc func spawnMonster() {
        
        Monster.createMonster(scene: self, parentNode: parentNode)
        monsterDifficulty -= 0.1
        
        spawnMonsterTimer = Timer.scheduledTimer(timeInterval: monsterDifficulty, target: self, selector: #selector(GameScene.spawnMonster), userInfo: nil, repeats: false)
        
    }
    
    @objc func fireCooldown() {
        
        fireCooling = false
        
    }
    
    @objc func createSprites() {
        
        pipeDifficultyTime = 3.0
        pipeDifficulty = 100
        monsterDifficulty = 5.0
        
        sorlos.removeFromParent()
        
        transition = false
        
        randomLevel()
        
        backgroundMusic = currentLevel.changeMusic()
        backgroundMusic.play()
        backgroundMusic.numberOfLoops = -1
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -4)
        
        //Background
        
        Background.createBackground(scene: self, parentNode: parentNode, backgroundPath: currentLevel.background)
        
        //Sorlos
        
        sorlos = Sorlos()
        
        sorlos.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        self.addChild(sorlos)
        
        gapHeight = sorlos.size.height * 4
        
        makePipesTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(GameScene.makeWalls), userInfo: nil, repeats: false)
        
        spawnMonsterTimer = Timer.scheduledTimer(timeInterval: monsterDifficulty, target: self, selector: #selector(GameScene.spawnMonster), userInfo: nil, repeats: false)

        
    }
    
    func startTimersAtTime(pipeTime: TimeInterval, monsterTime: TimeInterval)
    {
        makePipesTimer = Timer.scheduledTimer(timeInterval: pipeTime, target: self, selector: #selector(GameScene.makeWalls), userInfo: nil, repeats: false)
        
        spawnMonsterTimer = Timer.scheduledTimer(timeInterval: monsterTime, target: self, selector: #selector(GameScene.spawnMonster), userInfo: nil, repeats: false)
    }

    
    func destroySprites() {
        
        transition = true
        
        makePipesTimer.invalidate()
        spawnMonsterTimer.invalidate()
        
        parentNode.removeAllChildren()
        
        let bossEncounterChance = Int(arc4random_uniform(UInt32(20 * switchLevels.count + 1)))
        
        columnsTop = Queue<Column>()
        columnsBottom = Queue<Column>()
        
        columnCount = 0
        
        if (bossEncounterChance < 20) {
            backgroundMusic.stop()
            
            if let scene = SKScene(fileNamed: "BossScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition:SKTransition = SKTransition.fade(with: UIColor.red, duration: 4)
                // Present the scene
                view?.presentScene(scene, transition: transition)
            }
            
        } else {
        
            _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.createSprites), userInfo: nil, repeats: false)
        }
        
    }
    
    func randomLevel() {
        
        if (switchLevels.count == 0) {
            //initSwitchLevelsArray()
        }
        
            let randomLevel = Int(arc4random_uniform(UInt32(switchLevels.count)))
        
            currentLevel = switchLevels[randomLevel]
        
            switchLevels.remove(at: randomLevel)
        
        
    }
    
    func initSwitchLevelsArray() {
        
        switchLevels.append(SwitchLevel(pipe1: "img/iceWall.png", pipe2: "img/iceWall.png", background: "img/snowy mountains.png", musicPath: "music/Snowfall.wav"))
        
        switchLevels.append(SwitchLevel(pipe1: "img/templeColumn.png", pipe2: "img/templeColumn.png", background: "img/SunsetTempleBackground.png", musicPath: "music/Riseofspirit.mp3"))
        
        switchLevels.append(SwitchLevel(pipe1: "img/lavaWall1.png", pipe2: "img/lavaWall2.png", background: "img/LavaBackground.png", musicPath: "music/AlaFlair.wav"))
        
        switchLevels.append(SwitchLevel(pipe1: "img/spaceWall.png", pipe2: "img/spaceWall.png", background: "img/Space.png", musicPath: "music/Journey.wav"))
        
        switchLevels.append(SwitchLevel(pipe1: "img/treeWall.png", pipe2: "img/treeWall.png", background: "img/forest.png", musicPath: "music/forestMusic.mp3"))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        if (contact.bodyA.categoryBitMask == destroyingGroup || contact.bodyB.categoryBitMask == destroyingGroup) {
            
            if (contact.bodyA.categoryBitMask == destroyingGroup) {
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }
        } else if (contact.bodyA.categoryBitMask == projectileGroup || contact.bodyB.categoryBitMask == projectileGroup) {
            
            if (contact.bodyA.categoryBitMask == monsterGroup && contact.bodyB.categoryBitMask == projectileGroup) {
                Monster.killMonster(monsterToKill: contact.bodyA.node as! SKSpriteNode)
                FireBall.explodeFireBall(explodingFireBall: contact.bodyB.node as! SKSpriteNode)
                Score.updateScore(update: 5)
            } else if (contact.bodyB.categoryBitMask == monsterGroup && contact.bodyA.categoryBitMask == projectileGroup) {
                Monster.killMonster(monsterToKill: contact.bodyB.node as! SKSpriteNode)
                FireBall.explodeFireBall(explodingFireBall: contact.bodyA.node as! SKSpriteNode)
                Score.updateScore(update: 5)
            } else if (contact.bodyA.categoryBitMask == pipeGroup && contact.bodyB.categoryBitMask == projectileGroup) {
                FireBall.explodeFireBall(explodingFireBall: contact.bodyB.node as! SKSpriteNode)
            } else if (contact.bodyB.categoryBitMask == pipeGroup && contact.bodyA.categoryBitMask == projectileGroup) {
                FireBall.explodeFireBall(explodingFireBall: contact.bodyA.node as! SKSpriteNode)
            }
            
        } else if (contact.bodyA.categoryBitMask == sorlosGroup || contact.bodyB.categoryBitMask == sorlosGroup) {
            
            if (contact.bodyA.categoryBitMask == monsterGroup || contact.bodyA.categoryBitMask == pipeGroup ||
                contact.bodyB.categoryBitMask == monsterGroup || contact.bodyB.categoryBitMask == pipeGroup) {
                
                sorlos.hit()
                
                destroySprites()
            }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

            for touch: AnyObject in touches {
            // Get the location of the touch in this scene
                let location = touch.location(in: self)
            // Check if the location of the touch is within the button's bounds
                if (FireButton.fireButton.contains(location) && !transition) {
                    if (!fireCooling) {
                        FireButton.pressButton()
                        sorlos.fire()
                        FireBall.createFireBallGameScene(scene: self, sorlos: sorlos, parentNode: parentNode)
                        fireCooling = true
                        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GameScene.fireCooldown), userInfo: nil, repeats: false)
                    }
                } else {
                    sorlos.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    sorlos.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 80))
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
        // Called before each frame is rendered
    }
}
