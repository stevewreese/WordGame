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
    func addGame(game: GameView)
    func updateEnded(games: Array<GameView>)
    func updateWon(games: Array<GameView>)
    
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
    
    //fucntion to end the game
    func endGame(game: GameView)
    {
        let endgame = theModel?.endGame(game: game)
        delegate?.updateEnded(games: endgame!)
        //delegate?.leavegame(game: endgame![(endgame?.count)! - 1])
        
    }
    
    func viewProgGame(index: Int)
    {
        delegate?.addGame(game: (theModel?.getProgGame(index: index))!)
    }
    
    func viewEndGame(index: Int)
    {
        let theGame: GameView = (theModel?.getEndGame(index: index))!
        delegate?.addGame(game: theGame)
    }
    
    func viewWinGame(index: Int)
    {
        let theGame: GameView = (theModel?.getWinGame(index: index))!
        delegate?.addGame(game: theGame)
    }
    
    func winGame(game: GameView)
    {
        let wingame = theModel?.winGame(game: game)
        delegate?.updateWon(games: wingame!)
    }
}
