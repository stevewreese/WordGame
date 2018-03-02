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
    func makeNewGame(game: GameView)
    func leavegame(game: GameView)
    
}

class GameControl
{
    weak var delegate: ControlDelegate? = nil
    var theModel : GameModel? = nil
    
    init(model : GameModel)
    {
        theModel = model
    }
    
    func newGame() -> Array<GameView>
    {
        let inProgrees = theModel?.newGame()
        delegate?.makeNewGame(game: inProgrees![(inProgrees?.count)! - 1])
        
        return inProgrees!
        
    }
    
    func leaveGame(game: GameView)
    {
        delegate?.leavegame(game: game)
    }
}
