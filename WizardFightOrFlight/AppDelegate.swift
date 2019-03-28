//
//  AppDelegate.swift
//  FlappyBirds
//
//  Created by Jackson Warburton on 4/15/17.
//  Copyright © 2017 Jackson Warburton. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var gameScene: GameScene?
    static var bossScene: BossScene?
    static var startScene: StartScene?
    
    static var audioPlayer: AVAudioPlayer?
    
    static var pipeTime: TimeInterval?
    static var monsterTime: TimeInterval?
    
    /*static var pipeDifficulty: Double?
    static var monsterDifficulty: Double?*/
    
    static var audioUrl: URL?

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        AppDelegate.gameScene?.backgroundMusic.stop()
        
        if(AppDelegate.gameScene != nil)
        {
            let makePipesTimer = AppDelegate.gameScene?.makePipesTimer
        
            if(makePipesTimer!.isValid)
            {
                let pipeDate = AppDelegate.gameScene?.makePipesTimer.fireDate
                AppDelegate.pipeTime = pipeDate?.timeIntervalSinceNow
                let monsterDate = AppDelegate.gameScene?.spawnMonsterTimer.fireDate
                AppDelegate.monsterTime = monsterDate?.timeIntervalSinceNow
                
                if(AppDelegate.pipeTime! > 0)
                {
                    AppDelegate.gameScene?.makePipesTimer.invalidate()
                }
                if(AppDelegate.monsterTime! > 0)
                {
                    AppDelegate.gameScene?.spawnMonsterTimer.invalidate()
                }
            }
        }
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if(AppDelegate.audioUrl != nil)
        {
            if(AppDelegate.audioPlayer != nil)
            {
                do {
                    AppDelegate.audioPlayer = try AVAudioPlayer(contentsOf: AppDelegate.audioUrl!)
                    AppDelegate.audioPlayer?.play()
                    AppDelegate.audioPlayer?.numberOfLoops = -1
                } catch {
                    print("fail")
                }
            }
        }
        
        if(AppDelegate.gameScene != nil)
        {
            AppDelegate.gameScene?.startTimersAtTime(pipeTime: AppDelegate.pipeTime!, monsterTime: AppDelegate.monsterTime!)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

