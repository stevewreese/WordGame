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
   
    
    var gameCollections : Array<GameView> = Array()
    var gameCollector = GameCollectionView(frame: UIScreen.main.bounds)
    var theControl = GameControl()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        theControl.delegate = self
        gameCollector.setControl = theControl
        addSubview(gameCollector)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeNewGame() {
        let game = GameView(frame: UIScreen.main.bounds)
        game.gameIndex = 0
        game.setControl = theControl
        gameCollections.append(game)
        gameCollector.removeFromSuperview()
        self.addSubview(game)
        
    }
}
