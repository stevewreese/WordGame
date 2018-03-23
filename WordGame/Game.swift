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
    
    var score = 98
    
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
                    let direct = direction[dicIndex]
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
    
    func changeBoard(buttons: Array<GameButton>, fullList: Array<GameButton>)
    {
        var buttonList: Array<GameButton> = Array()
        for b in buttons
        {
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
                //print("\(b2.titleLabel?.text)")
                score = score - 1
            }
            
        }
        
        
    }

    
    
}
