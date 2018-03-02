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
   
    
    var gameCollector = GameCollectionView(frame: UIScreen.main.bounds)
    var theModel = GameModel()
    var theControl: GameControl? = nil
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        theControl = GameControl(model : theModel)
        theControl?.delegate = self
        gameCollector.setControl = theControl!
        addSubview(gameCollector)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeNewGame(game: GameView) {
        game.setControl = theControl!
        gameCollector.removeFromSuperview()
        self.addSubview(game)
        
    }
    
    func leavegame(game: GameView)
    {
        game.removeFromSuperview()
        self.addSubview(gameCollector)
    }
}
