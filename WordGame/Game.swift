//
//  Game.swift
//  WordGame
//  represents the game data
//  Created by Stephen Reese on 2/27/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import Foundation

class Game: Codable{
    //dictionary of words added
    private var dictionary : Array<String> = Array()
    //words that weren't set regularly
    private var wordsNotUsed : Array<String> = Array()
    //list of the indexes
    var indexes: Array<Int> = Array()
    //the 2d array representing the board
    var board:[[String]] = Array(repeating: Array(repeating: "?", count: 9), count: 12)
    //the direction the letter is added
    var direction:[String] = ["n", "ne", "e", "se", "s", "sw", "w", "nw"]
    var alphabet: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    //indexes of the special letters
    var specialIndex:[[Int]] = Array(repeating: Array(repeating: 0, count: 2), count: 4)
    //the state of the game
    var gameState = "progress"
    //score of the game
    var score = 98
    var index = 0;
    //on init set dictionary and populate the board
    init(dic: Array<String>)
    {
        dictionary = dic
        makeBoard()
    }
    //set the words and letters
    func makeBoard()
    {
        //populate Indexes array
        makeIndexes()
        //take the words in the dictionary
        for word in dictionary
        {
            //empty array tobe used for all the index that haven't been set but can't be used
            var usedIndexes: Array<Int> = Array()
            //flag to run loop
            var looking = true
            while(looking)
            {
                var lookingForIndex = true
                //flag to see if settign word is successful
                var indexSuccess = false
                var index = 0
                //randomlly find an index
                while(lookingForIndex)
                {
                    let Rand = Int(arc4random_uniform(UInt32(indexes.count)))
                    index = indexes[Rand]
                    if(!usedIndexes.contains(index))
                    {
                        lookingForIndex = false
                    }
                }
                //get row and col of the index
                let row = (index/9)
                let col = index%9
                
                //try to set the word if successful return true is not return false
                indexSuccess = setWord(row: row, col: col, word: word)
                //if successful stop lookin
                if(indexSuccess)
                {
                    looking = false
                }
                else{ //if unsuccessful set the index to used indexes
                    usedIndexes.append(index)
                }
                //if all indexes are exhuasted then stop looking
                if(usedIndexes.count >= indexes.count)
                {
                    looking = false
                    wordsNotUsed.append(word)
                }
            }
        }
        //set letters of word not set
        setLetters()
        //get special letters
        setSpecialletters()

    }
    //populate indexes array
    func makeIndexes()
    {
        var i = 0
        while(i < 108)
        {
            indexes.append(i)
            i = i + 1
        }
    }
    //try to set the word if successful return true is not return false
    func setWord(row: Int, col: Int, word: String) -> Bool
    {
        var nextRow = row
        var nextCol = col
        var usedIndexes: Array<Int> = Array()
        //make an array of pssible indexes
        var theIndexes:[[Int]] = Array(repeating: Array(repeating: 0, count: 2), count: word.count)
        var index = 0
        //see if index has already been set
        if(board[nextRow][nextCol] == "?")
        {
            theIndexes[index][0] = nextRow
            theIndexes[index][1] = nextCol
            usedIndexes.append(nextRow*9 + nextCol)
            
        }
        else
        {
            return false
        }
        index = index + 1
        //randomly set a bordering tile
        while(index < word.count)
        {
                //randomly pick a direction
                var dicIndex = Int(arc4random_uniform(UInt32(8)))
                let middle = dicIndex - 1
                var goingUp = true
                while(true)
                {
                    var placedWord = false
                    //set direction
                    let direct = direction[dicIndex]
                    switch(direct)
                    {
                        //if north of letter
                    case "n" :
                        if((nextRow - 1) < 0)
                        {
                            placedWord = false
                        }
                        //if letter on set in that direction set it
                        else{
                            if(board[nextRow - 1][nextCol] == "?" && !usedIndexes.contains((nextRow - 1)*9 + nextCol))
                            {
                                nextRow = nextRow - 1
                                theIndexes[index][0] = nextRow
                                theIndexes[index][1] = nextCol
                                usedIndexes.append(nextRow*9 + nextCol)
                                placedWord = true
                            }
                            else
                            {
                                placedWord = false
                            }
                        }
   
                        
                        break
                        //if northeast of letter
                    case "ne" :
                        if((nextRow - 1) < 0 || (nextCol + 1) > 8)
                        {
                            placedWord = false
                        }
                        else{//if letter on set in that direction set it
                            if(board[nextRow - 1][nextCol + 1] == "?" && !usedIndexes.contains((nextRow - 1)*9 + nextCol + 1))
                            {
                                nextRow = nextRow - 1
                                nextCol = nextCol + 1
                                theIndexes[index][0] = nextRow
                                theIndexes[index][1] = nextCol
                                usedIndexes.append(nextRow*9 + nextCol)
                                placedWord = true
                            }
                            else
                            {
                                placedWord = false
                            }
                        }
                        
                        
                        break
                        //if east of letter
                    case "e" :
                        if((nextCol + 1) > 8)
                        {
                            placedWord = false
                        }
                        else
                        {//if letter on set in that direction set it
                            if(board[nextRow][nextCol + 1] == "?" && !usedIndexes.contains((nextRow)*9 + nextCol + 1))
                            {
                                nextCol = nextCol + 1
                                theIndexes[index][0] = nextRow
                                theIndexes[index][1] = nextCol
                                usedIndexes.append(nextRow*9 + nextCol)
                                placedWord = true
                            }
                            else
                            {
                                placedWord = false
                            }
                        }
                        
                        
                        break
                        //if southeast of letter
                    case "se" :
                        if((nextRow + 1) > 11 || (nextCol + 1) > 8)
                        {
                            placedWord = false
                        }//if letter on set in that direction set it
                        else{
                            if(board[nextRow + 1][nextCol + 1] == "?" && !usedIndexes.contains((nextRow + 1)*9 + nextCol + 1))
                            {
                                nextRow = nextRow + 1
                                nextCol = nextCol + 1
                                theIndexes[index][0] = nextRow
                                theIndexes[index][1] = nextCol
                                usedIndexes.append(nextRow*9 + nextCol)
                                placedWord = true
                            }
                            else
                            {
                                placedWord = false
                            }
                        }
                        
                        
                        break
                        //if south of letter
                    case "s" :
                        if((nextRow + 1) > 11)
                        {
                            placedWord = false
                        }//if letter on set in that direction set it
                        else{
                            if(board[nextRow + 1][nextCol] == "?" && !usedIndexes.contains((nextRow + 1)*9 + nextCol))
                            {
                                nextRow = nextRow + 1
                                theIndexes[index][0] = nextRow
                                theIndexes[index][1] = nextCol
                                usedIndexes.append(nextRow*9 + nextCol)
                                placedWord = true
                            }
                            else
                            {
                                placedWord = false
                            }
                        }
                        
                        
                        break
                        //if southwest of letter
                    case "sw" :
                        if((nextRow + 1) > 11 || (nextCol - 1) < 0)
                        {
                            placedWord = false
                        }
                        else
                        {//if letter on set in that direction set it
                            if(board[nextRow + 1][nextCol - 1] == "?" && !usedIndexes.contains((nextRow + 1)*9 + nextCol - 1))
                            {
                                nextRow = nextRow + 1
                                nextCol = nextCol - 1
                                theIndexes[index][0] = nextRow
                                theIndexes[index][1] = nextCol
                                usedIndexes.append(nextRow*9 + nextCol)
                                placedWord = true
                            }
                            else
                            {
                                placedWord = false
                            }
                        }
                        
                        
                        break
                        //if of west
                    case "w" :
                        if((nextCol - 1) < 0)
                        {
                            placedWord = false
                        }
                        else
                        {//if letter on set in that direction set it
                            if(board[nextRow][nextCol - 1] == "?" && !usedIndexes.contains((nextRow)*9 + nextCol - 1))
                            {
                                nextCol = nextCol - 1
                                theIndexes[index][0] = nextRow
                                theIndexes[index][1] = nextCol
                                usedIndexes.append(nextRow*9 + nextCol)
                                placedWord = true
                            }
                            else
                            {
                                placedWord = false
                            }
                        }
                        
                        
                        break
                        //if northwest of letter
                    case "nw" :
                        if((nextRow - 1) < 0 || (nextCol - 1) < 0)
                        {
                            placedWord = false
                        }
                        else{//if letter on set in that direction set it
                            if(board[nextRow - 1][nextCol - 1] == "?" && !usedIndexes.contains((nextRow - 1)*9 + nextCol - 1))
                            {
                                nextRow = nextRow - 1
                                nextCol = nextCol - 1
                                theIndexes[index][0] = nextRow
                                theIndexes[index][1] = nextCol
                                usedIndexes.append(nextRow*9 + nextCol)
                                placedWord = true
                            }
                            else
                            {
                                placedWord = false
                            }
                        }
                        
                        
                        break
                    default:
                        return false
                    }
                    //if not successful pick next clockwise direction
                    if(!placedWord)
                    {
                        if(goingUp)
                        {
                            dicIndex = dicIndex + 1
                        }
                        else{
                            dicIndex = dicIndex - 1
                        }
                        if(dicIndex > 7)
                        {
                            goingUp = false
                            dicIndex = middle
                        }
                        //if no direction work set letter failed
                        if(dicIndex < 0)
                        {
                            return false
                        }
                    }
                    else
                    {
                        break
                    }
                    
                }
            index = index + 1
            }
        var j = 0;
        //populate the board
        for aChar in word
        {
            board[theIndexes[j][0]][theIndexes[j][1]] = "\(aChar)"
            //remove possible index from the list of indexes
            let aIndex = theIndexes[j][0] * 9 + theIndexes[j][1]
            if let index = indexes.index(of: aIndex) {
                indexes.remove(at: index)
            }
            j = j + 1
        }
        return true;
            
    }
  
    //set letter of word unsuccessfully set
    func setLetters()
    {
        for word in wordsNotUsed
        {
            for theChar in word
            {
                //pick random index not used
                let Rand = Int(arc4random_uniform(UInt32(indexes.count)))
                let theIndex = indexes[Rand]
                let row = theIndex/9
                let col = theIndex%9
                //set it
                board[row][col] = "\(theChar)"
                //remove index
                if let index = indexes.index(of: theIndex) {
                    indexes.remove(at: index)
                }
            }
            
            
            
        }
    }
    //pick special letters
    func setSpecialletters()
    {
        var i = 0
        while(i < 4)
        {
            let Rand = Int(arc4random_uniform(UInt32(indexes.count - 1)))
            let theIndex = indexes[Rand]
            let RandABC = Int(arc4random_uniform(26))
            let theChar = "\(alphabet[RandABC])"
            let row = theIndex/9
            let col = theIndex%9
            board[row][col] = "\(theChar)"
            specialIndex[i][0] = row
            specialIndex[i][1] = col
            if let index = indexes.index(of: theIndex) {
                indexes.remove(at: index)
            }
            i = i + 1
        }
    }
    //see if a tile next to the selected tile is blank or not
    func checkBlank(buttonsList: Array<GameButton>, button: GameButton) -> Int
    {
        if(button.col - 1 >= 0)
        {
            if(board[button.row][button.col - 1] == "?")
            {
                checkforRed(button: button)
                return button.row * 9 + button.col - 1
            }
            
        }
        if(button.col + 1 < 9)
        {
            if(board[button.row][button.col + 1] == "?")
            {
                checkforRed(button: button)
                return button.row * 9 + button.col + 1
            }
            
        }
        if(button.row - 1 >= 0)
        {
            if(board[button.row - 1][button.col] == "?")
            {
                checkforRed(button: button)
                return (button.row - 1) * 9 + button.col
            }
            
        }
        if(button.row + 1 < 12)
        {
            if(board[button.row + 1][button.col] == "?")
            {
                checkforRed(button: button)
                return (button.row + 1) * 9 + button.col
            }
            
        }
        return -1
    }
    //see if tile is a special tile
    func checkforRed(button: GameButton) -> Int
    {
        var i = 0
        var result = -1
        while(i < specialIndex.count)
        {
            if(specialIndex[i][1] == button.col && specialIndex[i][0] == button.row)
            {
                result = button.row * 9
                specialIndex[i][1] = -1
                specialIndex[i][0] = -1
            }
            else if(specialIndex[i][1] == button.col && specialIndex[i][0] < button.row)
            {
                specialIndex[i][0] = specialIndex[i][0] + 1
            }
            i = i + 1
        }
        return result
        
    }
    //update board base on selected word
    func changeBoard(buttons: Array<GameButton>, fullList: Array<GameButton>)
    {
        //buttons to change
        var buttonList: Array<GameButton> = Array()
        for b in buttons
        {
            //check for red if red then remove row
            let redRow = checkforRed(button: b)
            if(redRow != -1)
            {
                var redCol = 0
                while(redCol < 9)
                {
                    checkforRed(button: fullList[redRow + redCol])
                    if(!buttonList.contains(fullList[redRow + redCol]))
                    {
                        if(buttonList.count == 0)
                        {
                            buttonList.append(fullList[redRow + redCol])
                        }
                        else{
                            var i = 0
                            var inserted = false
                            while(i < buttonList.count)
                            {
                                if(buttonList[i].row > fullList[redRow + redCol].row)
                                {
                                    buttonList.insert(fullList[redRow + redCol], at: i)
                                    i = buttonList.count
                                    inserted = true
                                }
                                i = i + 1
                            }
                            if(!inserted)
                            {
                                buttonList.append(fullList[redRow + redCol])
                            }
                            
                        }
                    }
                    redCol = redCol + 1
                }
            }
            //check for blank
            let blankindex: Int = checkBlank(buttonsList: buttons, button: b)
            if(blankindex != -1)
            {
                if(!buttonList.contains(fullList[blankindex]))
                {
                    if(buttonList.count == 0)
                    {
                        buttonList.append(fullList[blankindex])
                    }
                    else{
                        var i = 0
                        var inserted = false
                        while(i < buttonList.count)
                        {
                            if(buttonList[i].row > fullList[blankindex].row)
                            {
                                buttonList.insert(fullList[blankindex], at: i)
                                i = buttonList.count
                                inserted = true
                            }
                            i = i + 1
                        }
                        if(!inserted)
                        {
                            buttonList.append(fullList[blankindex])
                        }
                        
                    }
                }
                
            }
            if(buttonList.count == 0)
            {
                buttonList.append(b)
            }
            else{
                if(!buttonList.contains(b))
                {
                    var i = 0
                    var inserted = false
                    while(i < buttonList.count)
                    {
                        if(buttonList[i].row > b.row)
                        {
                            buttonList.insert(b, at: i)
                            i = buttonList.count
                            inserted = true
                        }
                        i = i + 1
                    }
                    if(!inserted)
                    {
                        buttonList.append(b)
                    }
                }
                
            }
            
        }
        //now update board
        for b2 in buttonList
        {
             var col = b2.col
             var row = b2.row
             while(row > 0)
             {
                board[row][col] = board[row - 1][col]
                row = row - 1
             }
             board[0][col] = "?"
            if(b2.titleLabel?.text != "?")
            {
                score = score - 1
            }
            
        }
        
    }
    

    
    
}
