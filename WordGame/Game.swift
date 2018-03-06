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
    var board:[[String]] = Array(repeating: Array(repeating: "", count: 9), count: 12)
    var direction:[String] = ["n", "ne", "e", "se", "s", "sw", "w", "nw"]
    
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
                    var Rand = Int(arc4random_uniform(UInt32(indexes.count)))
                    index = indexes[Rand]
                    if(!usedIndexes.contains(index))
                    {
                        lookingForIndex = false
                    }
                }
                var row = (index/9)
                var col = index%9
                var lookingForDirection = true
                var dicIndex = Int(arc4random_uniform(UInt32(8)))
                var middle = dicIndex - 1
                var goingUp = true
                while(lookingForDirection)
                {
                    
                    indexSuccess = setWord(direction: direction[dicIndex], row: row, col: col, word: word)
                    lookingForDirection = !indexSuccess
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
                        lookingForDirection = false
                    }
    
                }
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
    
    func setWord(direction: String, row: Int, col: Int, word: String) -> Bool
    {
        var nextRow = row
        var nextCol = col
        var theIndexes:[[Int]] = Array(repeating: Array(repeating: 0, count: 2), count: word.count)
        switch(direction)
        {
            case "n" :
                //if word is too big to go north on the board pick new direction
                if(row + 1 < word.count)
                {
                    return false
                }
                var i = 0
                //see if word can be placed
                while(i < word.count)
                {
                    //if a letter is alreading in that place pick a new direction
                    if(board[nextRow][nextCol] == "")
                    {
                        theIndexes[i][0] = nextRow
                        theIndexes[i][1] = nextCol
                        nextRow = nextRow - 1
                    }
                    else
                    {
                        return false
                    }
                    i = i + 1
                }
                //place the letters
                var j = 0
                for aChar in word
                {
                    board[theIndexes[j][0]][theIndexes[j][1]] = "\(aChar)"
                    //remove possible index from the list of indexes
                    var aIndex = theIndexes[j][0] * 9 + theIndexes[j][1]
                    if let index = indexes.index(of: aIndex) {
                        indexes.remove(at: index)
                    }
                    j = j + 1
                }
                return true
                break
        case "ne" :
            //if word is too big to go north on the board pick new direction
            if(row + 1 < word.count || (9 - col) < word.count)
            {
                return false
            }
            var i = 0
            //see if word can be placed
            while(i < word.count)
            {
                //if a letter is alreading in that place pick a new direction
                if(board[nextRow][nextCol] == "")
                {
                    theIndexes[i][0] = nextRow
                    theIndexes[i][1] = nextCol
                    nextRow = nextRow - 1
                    nextCol = nextCol + 1
                }
                else
                {
                    return false
                }
                i = i + 1
            }
            //place the letters
            var j = 0
            for aChar in word
            {
                board[theIndexes[j][0]][theIndexes[j][1]] = "\(aChar)"
                //remove possible index from the list of indexes
                var aIndex = theIndexes[j][0] * 9 + theIndexes[j][1]
                if let index = indexes.index(of: aIndex) {
                    indexes.remove(at: index)
                }
                j = j + 1
            }
            return true
            break
        case "e" :
            //if word is too big to go north on the board pick new direction
            if((9 - col) < word.count)
            {
                return false
            }
            var i = 0
            //see if word can be placed
            while(i < word.count)
            {
                //if a letter is alreading in that place pick a new direction
                if(board[nextRow][nextCol] == "")
                {
                    theIndexes[i][0] = nextRow
                    theIndexes[i][1] = nextCol
                    nextCol = nextCol + 1
                }
                else
                {
                    return false
                }
                i = i + 1
            }
            //place the letters
            var j = 0
            for aChar in word
            {
                board[theIndexes[j][0]][theIndexes[j][1]] = "\(aChar)"
                //remove possible index from the list of indexes
                var aIndex = theIndexes[j][0] * 9 + theIndexes[j][1]
                if let index = indexes.index(of: aIndex) {
                    indexes.remove(at: index)
                }
                j = j + 1
            }
            return true
            break
        case "se" :
            //if word is too big to go Sout east on the board pick new direction
            if((12 - row) < word.count || (9 - col) < word.count)
            {
                return false
            }
            var i = 0
            //see if word can be placed
            while(i < word.count)
            {
                //if a letter is alreading in that place pick a new direction
                if(board[nextRow][nextCol] == "")
                {
                    theIndexes[i][0] = nextRow
                    theIndexes[i][1] = nextCol
                    nextRow = nextRow + 1
                    nextCol = nextCol + 1
                }
                else
                {
                    return false
                }
                i = i + 1
            }
            //place the letters
            var j = 0
            for aChar in word
            {
                board[theIndexes[j][0]][theIndexes[j][1]] = "\(aChar)"
                //remove possible index from the list of indexes
                var aIndex = theIndexes[j][0] * 9 + theIndexes[j][1]
                if let index = indexes.index(of: aIndex) {
                    indexes.remove(at: index)
                }
                j = j + 1
            }
            return true
        case "s" :
            //if word is too big to go South on the board pick new direction
            if((12 - row) < word.count)
            {
                return false
            }
            var i = 0
            //see if word can be placed
            while(i < word.count)
            {
                //if a letter is alreading in that place pick a new direction
                if(board[nextRow][nextCol] == "")
                {
                    theIndexes[i][0] = nextRow
                    theIndexes[i][1] = nextCol
                    nextRow = nextRow + 1
                }
                else
                {
                    return false
                }
                i = i + 1
            }
            //place the letters
            var j = 0
            for aChar in word
            {
                board[theIndexes[j][0]][theIndexes[j][1]] = "\(aChar)"
                //remove possible index from the list of indexes
                var aIndex = theIndexes[j][0] * 9 + theIndexes[j][1]
                if let index = indexes.index(of: aIndex) {
                    indexes.remove(at: index)
                }
                j = j + 1
            }
            return true
        case "sw" :
            //if word is too big to go South west on the board pick new direction
            if((row + 1) < word.count || (col + 1) < word.count)
            {
                return false
            }
            var i = 0
            //see if word can be placed
            while(i < word.count)
            {
                //if a letter is alreading in that place pick a new direction
                if(board[nextRow][nextCol] == "")
                {
                    theIndexes[i][0] = nextRow
                    theIndexes[i][1] = nextCol
                    nextRow = nextRow - 1
                    nextCol = nextCol - 1
                }
                else
                {
                    return false
                }
                i = i + 1
            }
            //place the letters
            var j = 0
            for aChar in word
            {
                board[theIndexes[j][0]][theIndexes[j][1]] = "\(aChar)"
                //remove possible index from the list of indexes
                var aIndex = theIndexes[j][0] * 9 + theIndexes[j][1]
                if let index = indexes.index(of: aIndex) {
                    indexes.remove(at: index)
                }
                j = j + 1
            }
            return true
        case "w" :
            //if word is too big to go Sout east on the board pick new direction
            if((col + 1) < word.count)
            {
                return false
            }
            var i = 0
            //see if word can be placed
            while(i < word.count)
            {
                //if a letter is alreading in that place pick a new direction
                if(board[nextRow][nextCol] == "")
                {
                    theIndexes[i][0] = nextRow
                    theIndexes[i][1] = nextCol
                    nextCol = nextCol - 1
                }
                else
                {
                    return false
                }
                i = i + 1
            }
            //place the letters
            var j = 0
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
            return true
        case "nw" :
            //if word is too big to go north west on the board pick new direction
            if((row + 1) < word.count || (col + 1) < word.count)
            {
                return false
            }
            var i = 0
            //see if word can be placed
            while(i < word.count)
            {
                //if a letter is alreading in that place pick a new direction
                if(board[nextRow][nextCol] == "")
                {
                    theIndexes[i][0] = nextRow
                    theIndexes[i][1] = nextCol
                    nextRow = nextRow - 1
                    nextCol = nextCol - 1
                }
                else
                {
                    return false
                }
                i = i + 1
            }
            //place the letters
            var j = 0
            for aChar in word
            {
                board[theIndexes[j][0]][theIndexes[j][1]] = "\(aChar)"
                //remove possible index from the list of indexes
                var aIndex = theIndexes[j][0] * 9 + theIndexes[j][1]
                if let index = indexes.index(of: aIndex) {
                    indexes.remove(at: index)
                }
                j = j + 1
            }
            return true
            default:
                return false
        }
    }
    
    func setLetters()
    {
        for word in wordsNotUsed
        {
            for theChar in word
            {
                var Rand = Int(arc4random_uniform(UInt32(indexes.count)))
                var theIndex = indexes[Rand]
                var row = theIndex/9
                var col = theIndex%9
                board[row][col] = "\(theChar)"
                if let index = indexes.index(of: theIndex) {
                    indexes.remove(at: index)
                }
            }
            
            
            
        }
    }
    
    
}
