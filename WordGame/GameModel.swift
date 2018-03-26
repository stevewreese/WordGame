//
//  GameModel.swift
//  WordGame
//
//  Created by Stephen Reese on 2/27/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit
import Foundation

struct gameEnd {
    var gameEndList: Array<GameView>? = nil
    var gameProgList: Array<GameView>? = nil
    
    init(gameList: Array<GameView>, gamePList: Array<GameView>)
    {
        gameEndList = gameList
        gameProgList = gamePList
    }
    
}

struct gameList {
    var gameEndList: Array<GameView>? = nil
    var gameProgList: Array<GameView>? = nil
    var gameWinList: Array<GameView>? = nil
    
    init(gameEndList: Array<GameView>, gamePList: Array<GameView>, won: Array<GameView>)
    {
        self.gameEndList = gameEndList
        self.gameProgList = gamePList
        self.gameWinList = won
    }
}

class GameModel
{
    let documentsPath: String = Bundle.main.path(forResource: "Dictionary", ofType: "txt")!
    var textView: String = ""
    
    var gamesInProgress : Array<GameView> = Array()
    var gamesEnded : Array<GameView> = Array()
    var gamesWon : Array<GameView> = Array()
    private var gamesInProgressIndex = 0
    private var gamesEndIndex = 0
    private var gamesWinIndex = 0
    private var gameNumber = 0
    
    private var dictionary : Array<String> = Array()
    private var wordsPicked : Array<String> = Array()
    
    init()
    {
        //filePath = documentsPath + "/Dictionary.txt"
        getDictionary()
    }
    
    func getDictionary()
    {
        if let path = Bundle.main.path(forResource: "Dictionary", ofType: "txt"){
            let fm = FileManager()
            let exists = fm.fileExists(atPath: path)
            if(exists){
                let c = fm.contents(atPath: path)
                let cString = NSString(data: c!, encoding: String.Encoding.utf8.rawValue)
                let ret = cString! as String
                let dict = ret.components(separatedBy: "\n")
                for word in dict{
                    dictionary.append(word)
                }
                //print(dictionary.count)
            }
        }

    }
    
    func newGame() -> Array<GameView>
    {
        gameNumber = gameNumber + 1
        let game = GameView(frame: UIScreen.main.bounds)
        game.gameNumberGetSet = gameNumber
        addWords()
        let gameBoard = Game(dic: wordsPicked)
        game.theGame = gameBoard
        game.populateBoard()
        gamesInProgress.append(game)
        
        return gamesInProgress
        
    }
    //TODO: add inorder
    func endGame(game: GameView) -> gameEnd
    {
        game.endState()

        gamesEndIndex = gamesEndIndex + 1
        //gamesInProgress.remove(at: gamesInProgress.index(where: game))
        if let index = gamesInProgress.index(of: game) {
            gamesInProgress.remove(at: index)
        }
        var i = 0
        var inserted = false
        while(i < gamesEnded.count)
        {
            if(gamesEnded[i].gameNumberGetSet > game.gameNumberGetSet)
            {
                gamesEnded.insert(game, at: i)
                i = gamesEnded.count
                inserted = true
            }
            i = i + 1
        }
        if(!inserted)
        {
            gamesEnded.append(game)
        }
        var gameStruct: gameEnd = gameEnd(gameList: gamesEnded, gamePList: gamesInProgress)
        return gameStruct
    }
    
    //TODO: add inorder
    func winGame(game: GameView) -> gameEnd
    {
        game.winState()
        gamesWinIndex = gamesWinIndex + 1
        //gamesInProgress.remove(at: gamesInProgress.index(where: game))
        if let index = gamesInProgress.index(of: game) {
            gamesInProgress.remove(at: index)
        }
        var i = 0
        var inserted = false
        while(i < gamesWon.count)
        {
            if(gamesWon[i].gameNumberGetSet > game.gameNumberGetSet)
            {
                gamesWon.insert(game, at: i)
                i = gamesWon.count
                inserted = true
            }
            i = i + 1
        }
        if(!inserted)
        {
            gamesWon.append(game)
        }
        var gameStruct: gameEnd = gameEnd(gameList: gamesWon, gamePList: gamesInProgress)
        return gameStruct
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
        /*wordsPicked.removeAll()
        var testWord = "0123456789"
        wordsPicked.append(testWord)*/
        wordsPicked.removeAll()
        var wordCount = 0
        while(wordCount < 94)
        {
            let Rand = Int(arc4random_uniform(UInt32(dictionary.count)))
            let newWord = dictionary[Rand]
            if(wordCount + newWord.count > 94)
            {
                //pick new word
            }
            else if(wordCount + newWord.count == 93)
            {
                //pick new word
            }
            else
            {
                if(wordsPicked.contains(newWord))
                {
                    //pick new word
                }
                else
                {
                    wordsPicked.append(newWord)
                    wordCount = wordCount + newWord.count
                    //print(newWord)
                }
            }
            
            
            
        }

        
    }
    
    func checkWord(buttons: Array<GameButton>) -> Bool
    {
        var forwardWord = ""
        var backwardWord = ""
        for b in buttons
        {
            forwardWord = forwardWord + (b.titleLabel?.text)!
            backwardWord = (b.titleLabel?.text)! + backwardWord
        }
        if(dictionary.contains(forwardWord))
        {
            return true
        }
        else if(dictionary.contains(backwardWord))
        {
            return true
        }
        return false
    }
    
    func addGamesStart(newGame: aGame)
    {
        let game = GameView(frame: UIScreen.main.bounds)
        game.gameNumberGetSet = newGame.gameNum
        game.theGame = newGame.theGame
        game.populateBoard()
        if(newGame.theGame.gameState == "progress")
        {
            
            gamesInProgress.append(game)
        }
        else if (newGame.theGame.gameState == "ended")
        {
            game.endState()
            gamesEnded.append(game)
        }
        else{
            game.winState()
            gamesWon.append(game)
        }
        if(gameNumber < newGame.gameNum)
        {
            gameNumber = newGame.gameNum
        }
        
    }
    
    func gameCollectionLoad() -> gameList
    {
        var theLists: gameList = gameList(gameEndList: gamesEnded, gamePList: gamesInProgress, won: gamesWon)
        return theLists
    }
    
    
}
