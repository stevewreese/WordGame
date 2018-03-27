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
    //delegate to make a game
    func makeNewGame(game: GameView)
    //delegate to leave the game
    func leavegame(game: GameView)
    //deligate to add a game on start up
    func addGame(game: GameView)
    //update ended array list
    func updateEnded(games: Array<GameView>, gamesProg: Array<GameView>)
    //update games won array list
    func updateWon(games: Array<GameView>, gamesProg: Array<GameView>)
    //update games in progress array list
    func updateProg(gamesProg: Array<GameView>)
    //deligate to dave the game
    func save()
    
}

class GameControl
{
    weak var delegate: ControlDelegate? = nil
    var theModel : GameModel? = nil
    //set model on start up
    init(model : GameModel)
    {
        theModel = model
    }
    //function to call when new game is made
    func newGame() -> Array<GameView>
    {
        let inProgrees = theModel?.newGame()
        delegate?.makeNewGame(game: inProgrees![0])
        
        return inProgrees!
        
    }
    //function to call when leaving a game
    func leaveGame(game: GameView)
    {
        delegate?.leavegame(game: game)
    }
    
    //fucntion to call end the game
    func endGame(game: GameView)
    {
        let endgame = theModel?.endGame(game: game)
        delegate?.updateEnded(games: (endgame?.gameEndList)!, gamesProg: (endgame?.gameProgList)!)
        //delegate?.leavegame(game: endgame![(endgame?.count)! - 1])
        
    }
    //to call when you need to a view a curtain game in progress
    func viewProgGame(index: Int)
    {
        delegate?.addGame(game: (theModel?.getProgGame(index: index))!)
    }
    //to call when you need to a view a curtain game intaht has been ended
    func viewEndGame(index: Int)
    {
        let theGame: GameView = (theModel?.getEndGame(index: index))!
        delegate?.addGame(game: theGame)
    }
    //to call when you need to a view a curtain game that have been won
    func viewWinGame(index: Int)
    {
        let theGame: GameView = (theModel?.getWinGame(index: index))!
        delegate?.addGame(game: theGame)
    }
    //function to call when the game is won
    func winGame(game: GameView)
    {
        let wingame = theModel?.winGame(game: game)
        delegate?.updateWon(games: wingame!.gameEndList!, gamesProg: wingame!.gameProgList!)
    }
    //funciton to check if the word is in the dictionary
    func checkWord(buttons: Array<GameButton>) -> Bool
    {
        return theModel!.checkWord(buttons: buttons)
    }
    //funciton to call at the begining of the game to tell the model to populate the arrays
    func addGamesStart(game: aGame)
    {
        theModel?.addGamesStart(newGame: game)
    }
    //gives the view holder all the list that populatio the table
    func gameCollectionLoad() -> gameList
    {
        let theGame: gameList = (theModel?.gameCollectionLoad)!()
        return theGame
    }
    //fucniton to call when saving
    func save()
    {
        delegate?.save()
    }
    //function to call to change the order of a game in progress
    func changeOrder(game: GameView)
    {
        delegate?.updateProg(gamesProg: (theModel?.changeOrder(game: game))!)
    }
}
