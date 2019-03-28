//
//  Column.swift
//  FlappyBirds
//
//  Created by Jackson Warburton on 3/27/19.
//  Copyright © 2019 Jackson Warburton. All rights reserved.
//

import Foundation
import SpriteKit

class Column: SKSpriteNode
{
    let columnType: ColumnType?
    
    init(texture: SKTexture, columnType: ColumnType)
    {
        self.columnType = columnType
        
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        columnType = nil
        super.init(coder: aDecoder)
    }
}
