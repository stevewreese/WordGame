//
//  GameButton.swift
//  WordGame hold info for the indivdual tiles
//
//  Created by Stephen Reese on 3/2/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit

class GameButton: UIButton {
    //position on board
    var x = 0.0
    var y = 0.0
    //index of the array
    var row = 0
    var col = 0
    //flags to indicate leeter selection behavior
    var entered = false
    var exited = false
    var added = false
    //base color for when not selected
    var color: UIColor = .white
    //set the postion on the board
    func setXandy(x: Double, y: Double)
    {
        self.x = x
        self.y = y
    }
}
