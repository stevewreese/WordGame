//
//  GameControl.swift
//  WordGame
//  the contorl of the word game
//  Created by Stephen Reese on 2/27/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import Foundation

//delegates of the control
protocol ControlDelegate: class
{
    func makeNewGame()
    
}

class GameControl
{
    weak var delegate: ControlDelegate? = nil
}
