//
//  GameCollectionView.swift
//  WordGame
// the Game colletion view to show all the game inprogess won or ended
//  Created by Stephen Reese on 2/27/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit

class GameCollectionView: UIView, UITableViewDelegate, UITableViewDataSource
{
    
    
    //list of created Gameviews
    var gamesInProgress : Array<GameView> = Array() //games currently in progress
    var gamesEnded : Array<GameView> = Array() //games ended prematurely
    var gamesWon : Array<GameView> = Array() //games won by the player
    
    //teh table to show the games
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

        //set the table
        gameTable = UITableView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        gameTable.register(UITableViewCell.self, forCellReuseIdentifier: "GameCell")
        gameTable.dataSource = self
        gameTable.delegate = self
        
        addSubview(gameTable)
        
        //button to make a new game
        let buttonNewGame = UIButton(frame: CGRect(x: 250, y: 25, width: 150, height: 20))
        
        buttonNewGame.backgroundColor = .white
        buttonNewGame.setTitleColor(.black, for: .normal)
        buttonNewGame.setTitle("New game", for: .normal)
        buttonNewGame.addTarget(self, action: #selector(GameCollectionView.newGame(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonNewGame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //set the section 3 section for games in progress, game ended and games won
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //set the number of cells in the section
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
    
    //set the cell contents
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        //graphica view of the the games progress
        var gameProg = UIView(frame: CGRect(x: 200, y: 20, width: 196, height: 5))
        var score = 0
        gameProg.backgroundColor = .red
        if(indexPath.section == 0)
        {
            //the game score
            score = 98 - gamesInProgress[indexPath.row].getScore()
            //graphica view of the the games progress
            var gameProgGreen = UIView(frame: CGRect(x: 200, y: 20, width: score * 2, height: 5))
            gameProgGreen.backgroundColor = .green
            cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath as IndexPath)
            cell.textLabel!.text = "Game \(gamesInProgress[indexPath.row].gameNumberGetSet) Score: \(score)/98"
            cell.addSubview(gameProg)
            cell.addSubview(gameProgGreen)
        }
        else if(indexPath.section == 1)
        {
            score = 98 - gamesEnded[indexPath.row].getScore()
            //graphica view of the the games progress
            var gameProgGreen = UIView(frame: CGRect(x: 200, y: 20, width: score * 2, height: 5))
            gameProgGreen.backgroundColor = .green
            cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath as IndexPath)
            cell.textLabel!.text = "Game \(gamesEnded[indexPath.row].gameNumberGetSet) Score: \(score)/98"
            cell.addSubview(gameProg)
            cell.addSubview(gameProgGreen)
        }
        else{
            score = 98 - gamesWon[indexPath.row].getScore()
            //graphica view of the the games progress
            var gameProgGreen = UIView(frame: CGRect(x: 200, y: 20, width: score * 2, height: 5))
            gameProgGreen.backgroundColor = .green
            cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath as IndexPath)
            cell.textLabel!.text = "Game \(gamesWon[indexPath.row].gameNumberGetSet) Score: \(score)/98"
            cell.addSubview(gameProg)
            cell.addSubview(gameProgGreen)
        }
        
        return cell!
    }
    
    //add title for the sections
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
    
    //event when the new game button is press make a new game and show it in view
    @objc func newGame(sender: UIButton!)
    {
        gamesInProgress = (theControl?.newGame())!
        gameTable.reloadData()
        
    }
    //up date the lists fot game ended and game in progress when a game is ended
    func updateEnded(games: Array<GameView>, gamesProg: Array<GameView>) {
        gamesEnded = games
        gamesInProgress = gamesProg
        gameTable.reloadData()
        theControl?.leaveGame(game: gamesEnded[games.count - 1])
    }
    //up date the lists for games won and game in progress when a game is won
    func updateWon(games: Array<GameView>, gamesProg: Array<GameView>) {
        gamesWon = games
        gamesInProgress = gamesProg
        gameTable.reloadData()
        theControl?.leaveGame(game: gamesWon[games.count - 1])
    }
    //update table view
    func reload()
    {
        gameTable.reloadData()
    }
    
    
}
