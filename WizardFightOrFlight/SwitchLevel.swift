//
//  SwitchLevel.swift
//  FlappyBirds
//
//  Created by Jackson Warburton on 4/24/17.
//  Copyright © 2017 Jackson Warburton. All rights reserved.
//

import Foundation
import AVFoundation

struct SwitchLevel {
    
    let pipe1: String
    let pipe2: String
    let background: String
    let musicPath: String
    
    init(pipe1: String, pipe2: String, background: String, musicPath: String) {
        
        self.pipe1 = pipe1
        self.pipe2 = pipe2
        self.background = background
        self.musicPath = musicPath
        
    }
    
    func changeMusic() -> AVAudioPlayer {
        
        var backgroundMusic = AVAudioPlayer()
        
        let path = Bundle.main.path(forResource: musicPath, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: url)
            AppDelegate.audioPlayer = backgroundMusic
            AppDelegate.audioUrl = url
        } catch {
            print("fail")
        }
        
        return backgroundMusic
    }
    
}
