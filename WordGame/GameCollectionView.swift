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
        
        let buttonNewGame = UIButton(frame: CGRect(x: 250, y: 25, width: 150, height: 20))
        
        buttonNewGame.backgroundColor = .white
        //buttonEvent.layer.cornerRadius = 5
        buttonNewGame.setTitleColor(.black, for: .normal)
        buttonNewGame.setTitle("New game", for: .normal)
        buttonNewGame.addTarget(self, action: #selector(GameCollectionView.newGame(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonNewGame)
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
            return gamesInProgress.count
        }
        else if(section == 1)
        {
            return gamesEnded.count
        }
        else
        
        {
            return gamesWon.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        if(indexPath.section == 0)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath as IndexPath)
            cell.textLabel!.text = "Game \(gamesInProgress[indexPath.row].gameNumberGetSet)"
        }
        else if(indexPath.section == 1)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath as IndexPath)
            cell.textLabel!.text = "Game \(gamesEnded[indexPath.row].gameNumberGetSet)"
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath as IndexPath)
            cell.textLabel!.text = "Game \(gamesWon[indexPath.row].gameNumberGetSet)"
        }
        
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
            theControl?.viewProgGame(index: indexPath.row)
        }
        else if(indexPath.section == 1)
        {
            theControl?.viewEndGame(index: indexPath.row)
        }
        else{
            theControl?.viewWinGame(index: indexPath.row)
        }
        
        
    }
    
    @objc func newGame(sender: UIButton!)
    {
        gamesInProgress = (theControl?.newGame())!
        gameTable.reloadData()
        
    }
 
    func updateEnded(games: Array<GameView>) {
        gamesEnded = games
        if let index = gamesInProgress.index(of: games[games.count - 1]) {
            gamesInProgress.remove(at: index)
        }
        gameTable.reloadData()
        theControl?.leaveGame(game: gamesEnded[games.count - 1])
    }
    
    func updateWon(games: Array<GameView>) {
        gamesWon = games
        if let index = gamesInProgress.index(of: games[games.count - 1]) {
            gamesInProgress.remove(at: index)
        }
        gameTable.reloadData()
        theControl?.leaveGame(game: gamesWon[games.count - 1])
    }
    
    
}
