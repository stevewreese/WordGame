//
//  Game.swift
//  WordGame
//
//  Created by Stephen Reese on 2/27/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import Foundation

class Game{
    private var dictionary : Array<String> = Array()
    private var wordsNotUsed : Array<String> = Array()
    var indexes: Array<Int> = Array()
    var board:[[String]] = Array(repeating: Array(repeating: "?", count: 9), count: 12)
    var direction:[String] = ["n", "ne", "e", "se", "s", "sw", "w", "nw"]
    var alphabet: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    var specialIndex:[[Int]] = Array(repeating: Array(repeating: 0, count: 2), count: 4)
    
    init(dic: Array<String>)
    {
        dictionary = dic
        makeBoard()
    }
    
    func makeBoard()
    {
        makeIndexes()
        for word in dictionary
        {
            var usedIndexes: Array<Int> = Array()
            var looking = true
            while(looking)
            {
                var lookingForIndex = true
                var indexSuccess = false
                var index = 0
                while(lookingForIndex)
                {
                    let Rand = Int(arc4random_uniform(UInt32(indexes.count)))
                    index = indexes[Rand]
                    if(!usedIndexes.contains(index))
                    {
                        lookingForIndex = false
                    }
                }
                let row = (index/9)
                let col = index%9

                indexSuccess = setWord(row: row, col: col, word: word)
    
                if(indexSuccess)
                {
                    looking = false
                }
                else{
                    usedIndexes.append(index)
                }
                if(usedIndexes.count >= indexes.count)
                {
                    looking = false
                    wordsNotUsed.append(word)
                }
            }
        }
        setLetters()
        setSpecialletters()

    }
    
    func makeIndexes()
    {
        var i = 0
        while(i < 108)
        {
            indexes.append(i)
            i = i + 1
        }
    }
    
    func setWord(row: Int, col: Int, word: String) -> Bool
    {
        var nextRow = row
        var nextCol = col
        var usedIndexes: Array<Int> = Array()
        var theIndexes:[[Int]] = Array(repeating: Array(repeating: 0, count: 2), count: word.count)
        var index = 0
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
        while(index < word.count)
        {
                var dicIndex = Int(arc4random_uniform(UInt32(8)))
                let middle = dicIndex - 1
                var goingUp = true
                while(true)
                {
                    var placedWord = false
                    var direct = direction[dicIndex]
                    switch(direct)
                    {
                    case "n" :
                        if((nextRow - 1) < 0)
                        {
                            placedWord = false
                        }
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
                    case "ne" :
                        if((nextRow - 1) < 0 || (nextCol + 1) > 8)
                        {
                            placedWord = false
                        }
                        else{
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
                    case "e" :
                        if((nextCol + 1) > 8)
                        {
                            placedWord = false
                        }
                        else
                        {
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
                    case "se" :
                        if((nextRow + 1) > 11 || (nextCol + 1) > 8)
                        {
                            placedWord = false
                        }
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
                    case "s" :
                        if((nextRow + 1) > 11)
                        {
                            placedWord = false
                        }
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
                    case "sw" :
                        if((nextRow + 1) > 11 || (nextCol - 1) < 0)
                        {
                            placedWord = false
                        }
                        else
                        {
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
                    case "w" :
                        if((nextCol - 1) < 0)
                        {
                            placedWord = false
                        }
                        else
                        {
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
                    case "nw" :
                        if((nextRow - 1) < 0 || (nextCol - 1) < 0)
                        {
                            placedWord = false
                        }
                        else{
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
  
    
    func setLetters()
    {
        for word in wordsNotUsed
        {
            for theChar in word
            {
                let Rand = Int(arc4random_uniform(UInt32(indexes.count)))
                let theIndex = indexes[Rand]
                let row = theIndex/9
                let col = theIndex%9
                board[row][col] = "\(theChar)"
                if let index = indexes.index(of: theIndex) {
                    indexes.remove(at: index)
                }
            }
            
            
            
        }
    }
    
    func setSpecialletters()
    {
        var i = 0
        while(i < 4)
        {
            let Rand = Int(arc4random_uniform(UInt32(indexes.count)))
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
    
    func changeBoard(buttons: Array<GameButton>)
    {
        for b in buttons
        {
            var x = b.xIndex
            var y = b.yIndex
            while(y > 0)
            {
                board[y][x] = board[y - 1][x]
                y = y - 1
            }
            board[0][x] = "?"
        }
    }

    
    
}
