//
//  GameButton.swift
//  WordGame
//
//  Created by Stephen Reese on 3/2/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit

class GameButton: UIButton {
    
    var x = 0.0
    var y = 0.0
    var entered = false
    var exited = false
    var added = false
    
    func setXandy(x: Double, y: Double)
    {
        self.x = x
        self.y = y
    }
}
