//
//  ViewHolder.swift
//  WordGame
//  this holds either the collectionGameview or the GAMe view and contains the logis to switch between them.
//  Created by Stephen Reese on 2/27/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit

class ViewHolder: UIView
{
    var gameCollections : Array<GameView> = Array()
    var gameCollector = GameCollectionView(frame: UIScreen.main.bounds)
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addSubview(gameCollector)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
