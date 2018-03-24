//
//  ViewHolder.swift
//  WordGame
//  this holds either the collectionGameview or the GAMe view and contains the logis to switch between them.
//  Created by Stephen Reese on 2/27/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit
import Foundation

struct aGame: Codable{
    let gameNum: Int
    var theGame: Game
    
}

class ViewHolder: UIView, ControlDelegate
{
    //the view for the cellection of games
    var gameCollector = GameCollectionView(frame: UIScreen.main.bounds)
    //teh model to be used
    var theModel = GameModel()
    var theControl: GameControl? = nil
    private static var theGames: [aGame] = []
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        //the control to be used give it the model
        theControl = GameControl(model : theModel)
        //set the delegate
        theControl?.delegate = self
        //set the control fro the gamecollections
        gameCollector.setControl = theControl!
        do{
            ViewHolder.theGames = try! ViewHolder.loadData()
        }
        catch{
            
        }
        for game in ViewHolder.theGames{
            theControl?.addGamesStart(game: game)
        }
        let theList: gameList = (theControl?.gameCollectionLoad())!
        for game in theList.gameProgList!
        {
            game.setControl = theControl!
        }
        gameCollector.gamesInProgress = theList.gameProgList!
        for game in theList.gameEndList!
        {
            game.setControl = theControl!
        }
        gameCollector.gamesEnded = theList.gameEndList!
        for game in theList.gameWinList!
        {
            game.setControl = theControl!
        }
        gameCollector.gamesWon = theList.gameWinList!
        gameCollector.reload()
        
        //add game collection to view
        addSubview(gameCollector)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static let entriesEncoder: JSONEncoder = {
        let entriesEncoder = JSONEncoder()
        
        return entriesEncoder
    }()
    
    private static func saveData() {
        do{
            let fileURL: URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("wordgame.json", isDirectory: false)
            let encodedDataset: Data = try! entriesEncoder.encode(theGames)
            try encodedDataset.write(to: fileURL, options: [.atomic, .completeFileProtection])
            print(fileURL.absoluteString)
            print(String(data: encodedDataset, encoding: .utf8) ?? "")
        }
        catch{
            
        }
        
        

    }
    
    private static func loadData() throws -> [aGame] {
        var loadedData: [aGame] = []
        
        do {
            let fileURL: URL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("wordgame.json", isDirectory: false)
            let encodedDataset: Data = try Data(contentsOf: fileURL, options: [])
            loadedData = try JSONDecoder().decode([aGame].self, from: encodedDataset)
        }
        catch{
            
        }
        return loadedData
    }
    
    //delegate to be called when new game is made
    func makeNewGame(game: GameView) {
        //set the controler of the GAme View
        game.setControl = theControl!
        let newgame = aGame.init(gameNum: game.gameNumberGetSet, theGame: game.theGame!)
        ViewHolder.theGames.append(newgame)
        ViewHolder.saveData()
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
        ViewHolder.saveData()
        gameCollector.updateEnded(games: games, gamesProg: gamesProg)
    }
    
    //when player wins the game this delegate is called and the gaem collection view is updated
    func updateWon(games: Array<GameView>, gamesProg: Array<GameView>)
    {
        ViewHolder.saveData()
        gameCollector.updateWon(games: games, gamesProg: gamesProg)
    }
    
    func save()
    {
        ViewHolder.saveData()
    }
}
