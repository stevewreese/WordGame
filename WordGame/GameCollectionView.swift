//
//  GameCollectionView.swift
//  WordGame
//
//  Created by Stephen Reese on 2/27/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit

class GameCollectionView: UIView, UITableViewDelegate, UITableViewDataSource
{
    //list of created Gameviews
    var gamesInProgress : Array<GameView> = Array()
    var gamesEnded : Array<GameView> = Array()
    var gamesWon : Array<GameView> = Array()
    
    var gameTable : UITableView!
    
    //get the sidth and height of phone
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    //the contol
    private var theControl: GameControl? = nil
    
    var setControl: GameControl
    {
        set{
            theControl = newValue
        }
        get{
            return theControl!
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        gameTable = UITableView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        gameTable.register(UITableViewCell.self, forCellReuseIdentifier: "GameCell")
        gameTable.dataSource = self
        gameTable.delegate = self
        
        addSubview(gameTable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return gamesInProgress.count + 1
        }
        else if(section == 1)
        {
            return gamesEnded.count + 1
        }
        else
        
        {
            return gamesWon.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "----"
        return cell!
    }
    
    //add title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0)
        {
            return "Games in Progress"
        }
        else if(section == 1)
        {
            return "Games Ended"
        }
        else
        {
            return "Games Won"
        }
    }
    
    //touch the row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if(indexPath.section == 0)
        {
            
        }
    }
    
    
}
