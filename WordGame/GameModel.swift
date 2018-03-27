//
//  GameModel.swift
//  WordGame
//
//  Created by Stephen Reese on 2/27/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit
import Foundation
//struct to pass the list to the table collections
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
    //file path of the dictionary
    let documentsPath: String = Bundle.main.path(forResource: "Dictionary", ofType: "txt")!
    var textView: String = ""
    //lists to hold all the game views to show in the colleciton view
    var gamesInProgress : Array<GameView> = Array()
    var gamesEnded : Array<GameView> = Array()
    var gamesWon : Array<GameView> = Array()
    //the number to give to individual names
    private var gameNumber = 0
    //array for the dictionary
    private var dictionary : Array<String> = Array()
    //array for the letters selected
    private var wordsPicked : Array<String> = Array()
    
    init()
    {
        getDictionary()
    }
    //pull words from txt file
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
            }
        }

    }
    //function to call whne new game is made
    func newGame() -> Array<GameView>
    {
        //add one to the game number
        gameNumber = gameNumber + 1
        //make new gameview
        let game = GameView(frame: UIScreen.main.bounds)
        //set the game number
        game.gameNumberGetSet = gameNumber
        //add random word to game board
        addWords()
        //make a game board
        let gameBoard = Game(dic: wordsPicked)
        //set the game board to the game view
        game.theGame = gameBoard
        //populate te letter to the board
        game.populateBoard()
        //move all game up inthe list
        for g in gamesInProgress{
            g.indexPlueOne()
        }
        //add new game to top of list
        game.setIndex(index: 0)
        gamesInProgress.insert(game, at: 0)
        //give new game to viewholder
        return gamesInProgress
        
    }
    //move the game to gamesended list
    func endGame(game: GameView) -> gameEnd
    {
        //change the state
        game.endState()
        //remove from the games in progress list
        if let index = gamesInProgress.index(of: game) {
            gamesInProgress.remove(at: index)
        }
        //add to begining of games ended
        for g in gamesEnded{
            g.indexPlueOne()
        }
        game.setIndex(index: 0)
        gamesEnded.insert(game, at: 0)
        //give the two lists to the view holder to give to the game collection
        var gameStruct: gameEnd = gameEnd(gameList: gamesEnded, gamePList: gamesInProgress)
        return gameStruct
    }
    
    //move the game to games won list
    func winGame(game: GameView) -> gameEnd
    {
        //change the state
        game.winState()
        //remove from the games in progress list
        if let index = gamesInProgress.index(of: game) {
            gamesInProgress.remove(at: index)
        }
        //add to begining of games won
        for g in gamesWon{
            g.indexPlueOne()
        }
        game.setIndex(index: 0)
        gamesWon.insert(game, at: 0)
        //give the two lists to the view holder to give to the game collection
        var gameStruct: gameEnd = gameEnd(gameList: gamesWon, gamePList: gamesInProgress)
        return gameStruct
    }
    //get certain game in progress by index
    func getProgGame(index: Int) -> GameView
    {
        return gamesInProgress[index]
    }
    //get certain game ended by index
    func getEndGame(index: Int) -> GameView
    {
        return gamesEnded[index]
    }
    //get certain game won by index
    func getWinGame(index: Int) -> GameView
    {
        return gamesWon[index]
    }
    //pick words from diction to add to the game
    func addWords()
    {
        //reset array
        wordsPicked.removeAll()
        //make sure all the word add up to 94 letters
        var wordCount = 0
        while(wordCount < 94)
        {
            //get random new word from dicitonary
            let Rand = Int(arc4random_uniform(UInt32(dictionary.count - 1)))
            let newWord = dictionary[Rand]
            //make sure it does make the word count bigger thatn 94
            if(wordCount + newWord.count > 94)
            {
                //pick new word
            }
            //make sure that woard doesn't make so only one letter is left
            else if(wordCount + newWord.count == 93)
            {
                //pick new word
            }
            else
            {
                //make sure the word hasn't alrady been picked
                if(wordsPicked.contains(newWord))
                {
                    //pick new word
                }
                else
                {
                    wordsPicked.append(newWord)
                    wordCount = wordCount + newWord.count
                }
            }
            
            
            
        }

        
    }
    //make sure the words selected hasn't already been picked
    func checkWord(buttons: Array<GameButton>) -> Bool
    {
        //lines 203 -210 make a word by add letters in order or in backwards order
        var forwardWord = ""
        var backwardWord = ""
        for b in buttons
        {
            forwardWord = forwardWord + (b.titleLabel?.text)!
            backwardWord = (b.titleLabel?.text)! + backwardWord
        }
        //see if word is formed in order
        if(dictionary.contains(forwardWord))
        {
            return true
        }
        //see if word is formed in backwards order
        else if(dictionary.contains(backwardWord))
        {
            return true
        }
        return false
    }
    //load the game from tha json file and add it to the corresponding list
    func addGamesStart(newGame: aGame)
    {
        //make a new game view
        let game = GameView(frame: UIScreen.main.bounds)
        //set game number
        game.gameNumberGetSet = newGame.gameNum
        //set the gameboard to the gameview
        game.theGame = newGame.theGame
        game.populateBoard()
        //if game is inprogress
        if(newGame.theGame.gameState == "progress")
        {
            var i = 0
            var inserted = false
            //insert is in the correct order
            while(i < gamesInProgress.count)
            {
                if(gamesInProgress[i].getIndex() > game.getIndex())
                {
                    gamesInProgress.insert(game, at: i)
                    i = gamesInProgress.count
                    inserted = true
                }
                i = i + 1
            }
            if(!inserted)
            {
                gamesInProgress.append(game)
            }
        }
            //if game is ended
        else if (newGame.theGame.gameState == "ended")
        {
            game.endState()
            var i = 0
            var inserted = false
            
            while(i < gamesEnded.count)
            {
                if(gamesEnded[i].getIndex() > game.getIndex())
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
            
        }
            //if the game is won
        else{
            game.winState()
            var i = 0
            var inserted = false
            
            while(i < gamesWon.count)
            {
                if(gamesWon[i].getIndex() > game.getIndex())
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
        }
        //set the right game number
        if(gameNumber <= newGame.gameNum)
        {
            gameNumber = newGame.gameNum
        }
        
    }
    //give all the list to the view holder to give to the game collection
    func gameCollectionLoad() -> gameList
    {
        var theLists: gameList = gameList(gameEndList: gamesEnded, gamePList: gamesInProgress, won: gamesWon)
        return theLists
    }
    //change the order of the following gameview to the front of the list
    func changeOrder(game: GameView) -> Array<GameView>
    {
        var theIndex = 0
        //remove from last order
        if let index = gamesInProgress.index(of: game) {
            gamesInProgress.remove(at: index)
            theIndex = index
        }
        //put it to the beginning
        game.setIndex(index: 0)
        gamesInProgress.insert(game, at: 0)
        var i = 1
        while(i <= theIndex){
            gamesInProgress[i].setIndex(index: i)
            i = i + 1
        }
        //give to view holder
        return gamesInProgress
    }
    
    
}
