//
//  GameModel.swift
//  WordGame
//
//  Created by Stephen Reese on 2/27/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit

class GameModel
{
    var gamesInProgress : Array<GameView> = Array()
    var gamesEnded : Array<GameView> = Array()
    var gamesWon : Array<GameView> = Array()
    private var gamesInProgressIndex = 0
    private var gameNumber = 0
    
    func newGame() -> Array<GameView>
    {
        let game = GameView(frame: UIScreen.main.bounds)
        game.gameIndex = gamesInProgressIndex
        game.gameNumberGetSet = gameNumber
        gamesInProgress.append(game)
        gamesInProgressIndex = gamesInProgressIndex + 1
        gameNumber = gameNumber + 1
        return gamesInProgress
        
    }
    
}
