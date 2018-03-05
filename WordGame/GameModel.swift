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
    private var gamesEndIndex = 0
    private var gamesWinIndex = 0
    private var gameNumber = 1
    
    private var dictionary : Array<String> = Array()
    
    func newGame() -> Array<GameView>
    {
        let game = GameView(frame: UIScreen.main.bounds)
        game.gameIndex = gamesInProgressIndex
        game.gameNumberGetSet = gameNumber
        gamesInProgress.append(game)
        gamesInProgressIndex = gamesInProgressIndex + 1
        gameNumber = gameNumber + 1
        addWords()
        var gameBoard = Game(dic: dictionary)
        return gamesInProgress
        
    }
    //TODO: add inorder
    func endGame(game: GameView) -> Array<GameView>
    {
        game.endState()
        game.gameIndex = gamesEndIndex
        gamesEndIndex = gamesEndIndex + 1
        //gamesInProgress.remove(at: gamesInProgress.index(where: game))
        if let index = gamesInProgress.index(of: game) {
            gamesInProgress.remove(at: index)
        }
        gamesEnded.append(game)
        return gamesEnded
    }
    
    //TODO: add inorder
    func winGame(game: GameView) -> Array<GameView>
    {
        game.winState()
        game.gameIndex = gamesWinIndex
        gamesWinIndex = gamesWinIndex + 1
        //gamesInProgress.remove(at: gamesInProgress.index(where: game))
        if let index = gamesInProgress.index(of: game) {
            gamesInProgress.remove(at: index)
        }
        gamesWon.append(game)
        return gamesWon
    }
    
    func getProgGame(index: Int) -> GameView
    {
        return gamesInProgress[index]
    }
    
    func getEndGame(index: Int) -> GameView
    {
        return gamesEnded[index]
    }
    
    func getWinGame(index: Int) -> GameView
    {
        return gamesWon[index]
    }
    
    func addWords()
    {
        dictionary.append("unit")
        dictionary.append("test")
        dictionary.append("doomsday")
        dictionary.append("Steve")
        dictionary.append("Warhead")
        dictionary.append("BigWordToTest")
        dictionary.append("123456789")
        dictionary.append("GREAT")
        dictionary.append("GREAT")
        
    }
    
    
}
