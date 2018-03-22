//
//  ViewHolder.swift
//  WordGame
//  this holds either the collectionGameview or the GAMe view and contains the logis to switch between them.
//  Created by Stephen Reese on 2/27/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit

class ViewHolder: UIView, ControlDelegate
{
    //the view for the cellection of games
    var gameCollector = GameCollectionView(frame: UIScreen.main.bounds)
    //teh model to be used
    var theModel = GameModel()
    var theControl: GameControl? = nil
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        //the control to be used give it the model
        theControl = GameControl(model : theModel)
        //set the delegate
        theControl?.delegate = self
        //set the control fro the gamecollections
        gameCollector.setControl = theControl!
        //add game collection to view
        addSubview(gameCollector)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //delegate to be called when new game is made
    func makeNewGame(game: GameView) {
        //set the controler of the GAme View
        game.setControl = theControl!
        //remove gamecontrol and show the game
        gameCollector.removeFromSuperview()
        self.addSubview(game)
        
    }
    
    //deligate the is called when palyer leaves the game wether by leaving, ending or winning the game
    func leavegame(game: GameView)
    {
        game.removeFromSuperview()
        gameCollector.reload()
        self.addSubview(gameCollector)
    }
    
    //when the play click on a game in the game collection view shows the coresponding  game
    func addGame(game: GameView)
    {
        gameCollector.removeFromSuperview()
        self.addSubview(game)
    }
    
    //when player end the game prematurely this delegat is called and the gaem collection view is updated
    func updateEnded(games: Array<GameView>, gamesProg: Array<GameView>)
    {
        gameCollector.updateEnded(games: games, gamesProg: gamesProg)
    }
    
    //when player wins the game this delegate is called and the gaem collection view is updated
    func updateWon(games: Array<GameView>, gamesProg: Array<GameView>)
    {
        gameCollector.updateWon(games: games, gamesProg: gamesProg)
    }
}
