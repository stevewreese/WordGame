//
//  GameView.swift
//  WordGame
//
//  Created by Stephen Reese on 2/27/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit
import Foundation

class GameView: UIView
{
    //array of the game table
    var buttons: Array<GameButton> = Array()
    //array of picked letters
    var wordButtons: Array<GameButton> = Array()
    
    //the game data
    var theGame: Game? = nil
    //invisable board to record finger movement
    var board = UIView(frame: CGRect(x: 0, y: 0, width: 414, height: 736))
    //game won pop up message
    var gameWon = UIView(frame: CGRect(x: 0, y: 0, width: 414, height: 736))
    //button to end the game
    let buttonEnd = UIButton(frame: CGRect(x: 225, y: 25, width: 100, height: 20))
    //see the if the game is inprogress ended by player or won
    enum state {case progress, ended, won}
    private var theState = state.progress

    var getState: state{
        get{
            return theState
        }
    }

    private var gameNumber = 0
    var gameNumberGetSet: Int{
        set{
            gameNumber = newValue
        }
        get{
            return gameNumber
        }
    }
    
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
        self.backgroundColor = .lightGray
        
        //button to leave the game
        let buttonLeave = UIButton(frame: CGRect(x: 25, y: 25, width: 100, height: 20))
        
        buttonLeave.backgroundColor = .white
        buttonLeave.setTitleColor(.black, for: .normal)
        buttonLeave.setTitle("Leave game", for: .normal)
        buttonLeave.addTarget(self, action: #selector(GameView.leave(sender:)), for: .touchUpInside)
        
        board.addSubview(buttonLeave)
        
        buttonEnd.backgroundColor = .white
        buttonEnd.setTitleColor(.black, for: .normal)
        buttonEnd.setTitle("End game", for: .normal)
        buttonEnd.addTarget(self, action: #selector(GameView.end(sender:)), for: .touchUpInside)
        
        board.addSubview(buttonEnd)
        
        //draw the board
        makeBoard()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect)
    {
        //title of the game
        let rtZone = CGRect(x: 100, y: 50, width: 225, height: 40)
        let paragraphStyleZone = NSMutableParagraphStyle()
        paragraphStyleZone.alignment = .center
        
        let attributesZone = [NSAttributedStringKey.paragraphStyle  :  paragraphStyleZone,
                              NSAttributedStringKey.font            :   UIFont.systemFont(ofSize: 35.0),
                              NSAttributedStringKey.foregroundColor : UIColor.black,
                              ] as [NSAttributedStringKey : Any]
        
        let myTextZone = "Game \(gameNumber)"
        let attrStringZone = NSAttributedString(string: myTextZone,
                                                attributes: attributesZone)
        attrStringZone.draw(in: rtZone)
    }
    
    //event to leave the game when leave button is pressed
    @objc func leave(sender: UIButton!)
    {
        (theControl?.leaveGame(game: self))!

    }
    //event to leave the game when end game button is pressed only works is game is in progress
    @objc func end(sender: UIButton!)
    {
        if(theState == state.ended || theState == state.won)
        {
        }
        else
        {
            theGame?.setDate()
            theControl?.endGame(game: self)
            
        }
        
    }
    
    //event that fires when user win the game
    @objc func win(sender: UIButton!)
    {
        theGame?.setDate()
        gameWon.removeFromSuperview()
        theControl?.winGame(game: self)
    }
    //set the end state
    func endState()
    {
        theState = state.ended
        theGame?.gameState = "ended"
        buttonEnd.backgroundColor = .gray
    }
    //set the win state
    func winState()
    {
        theState = state.won
        theGame?.gameState = "won"
        buttonEnd.backgroundColor = .gray
        //buttonWon.backgroundColor = .gray
    }
    //draw the board
    func makeBoard()
    {
        //margins
        var x = 5.4
        //button size
        var y = 140.0
        //the indexes
        var i = 0
        var j = 0
        
        while(j < 12)
        {
            while(i < 9)
            {
                //cell to hold letters
                let button = GameButton(frame: CGRect(x: x, y: y, width: 40, height: 40))
                //set button positon
                button.setXandy(x: x, y: y)
                //set button index
                button.col = i
                button.row = j
                self.addSubview(button)
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
                //? means blank
                button.setTitle("?", for: .normal)
                buttons.append(button)
                x = x + 45.4
                
                i = i + 1
            }
            y = y + 45.4
            j = j + 1
            i = 0
            x = 5.4
        }
        self.addSubview(board)

        
    }
    //when the finger is moved acrosed the board
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        //only do acction if game is inprogress
        if(theState == state.progress)
        {
            //get the point of the finger
            let point: CGPoint = (touches.first?.location(in: board))!
            //check all the buttons
            for b in buttons
            {
                //if blank do nothing
                if(b.titleLabel?.text == "?")
                {
                    
                }
                else
                {
                    //get point of the button
                    let pointB = CGPoint(x: b.x, y: b.y)
                    //make sure the finger is with in the button
                    if((point.x >= pointB.x && point.x <= pointB.x + 40)&&(point.y >= pointB.y && point.y <= pointB.y + 40))
                    {
                        //if already entered check to dehighlight
                        if(b.entered)
                        {
                            //get buttons index of the collected buttons
                            let index = wordButtons.index(of: b)
                            //check ot make sure the index is the second to last
                            var indexEnd = wordButtons.count - 1
                            if(index == wordButtons.count - 2)
                            {
                                //remove all buttons after it
                                while(index! < indexEnd)
                                {
                                    wordButtons[indexEnd].backgroundColor = wordButtons[indexEnd].color
                                    wordButtons[indexEnd].entered = false
                                    wordButtons[indexEnd].added = false
                                    wordButtons.remove(at: indexEnd)
                                    indexEnd = indexEnd - 1
                                }
                            }
                            //if it is a valid word change color
                            if(theControl?.checkWord(buttons: wordButtons))!
                            {
                                for b1 in wordButtons
                                {
                                    b1.backgroundColor = .green
                                }
                            }
                            //highlight selected buttons
                            else
                            {
                                for b1 in wordButtons
                                {
                                    b1.backgroundColor = .cyan
                                }
                            }
                        }
                        else
                        {
                            //check to make sure the button is bordering the last button selected
                            if(borderingButton(button: b))
                            {
                                b.backgroundColor = .cyan
                                b.entered = true
                                //if not already in array add it
                                if(!b.added)
                                {
                                    b.added = true
                                    wordButtons.append(b)
                                }
                            }
                            //if it is a valid word change color
                            if(theControl?.checkWord(buttons: wordButtons))!
                            {
                                for b1 in wordButtons
                                {
                                    b1.backgroundColor = .green
                                }
                            }
                            //highlight selected buttons
                            else
                            {
                                for b1 in wordButtons
                                {
                                    b1.backgroundColor = .cyan
                                }
                            }
                        }
                    }
                    else
                    {
                        //if finger not within borader set excited flags
                        if(b.entered)
                        {
                            b.exited = true
                        }
                        if(!b.entered && b.exited)
                        {
                            b.exited = false
                        }
                    }
                }
            }
        }
        
    }
    
    //when finger first touched down on button
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        //only do acction if game is inprogress
        if(theState == state.progress)
        {
            // Get the point to which the finger touched
            let point: CGPoint = (touches.first?.location(in: board))!
            //check all the buttons
            for b in buttons
            {
                //if blank do nothing
                if(b.titleLabel?.text == "?")
                {
                    
                }
                else
                {
                    //get loaction of button
                    let pointB = CGPoint(x: b.x, y: b.y)
                    //check to make sure finger is within borders
                    if(point.x >= pointB.x && point.x <= pointB.x + 40)
                    {
                        if(point.y >= pointB.y && point.y <= pointB.y + 40)
                        {
                            //if within borders change color and add to array
                            b.backgroundColor = .cyan
                            b.entered = true
                            if(!b.added)
                            {
                                b.added = true
                                wordButtons.append(b)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    //when funger is lifted up
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //only do acction if game is inprogress
        super.touchesEnded(touches, with: event)
        if(theState == state.progress){
            //check if word is valid
            let validWord = theControl?.checkWord(buttons: wordButtons)
            //reset flags of all buttons
            for b1 in wordButtons
            {
                b1.added = false
                b1.entered = false
                b1.backgroundColor = b1.color
            }
            //if word is valid update board
            if(validWord)!
            {
                //update Game
                theGame?.changeBoard(buttons: wordButtons, fullList: buttons)
                //update board
                populateBoard()
                //if score is 0 then user wins
                if(theGame?.score == 0)
                {
                    //set state
                    winState()
                    //set pop up message
                    gameWon.backgroundColor = .white
                    let label = UILabel(frame: CGRect(x: 150, y: 300, width: 225, height: 40))
                    label.text = "Game Won!"
                    gameWon.addSubview(label)
                    //button to dismiss game
                    let buttonDismiss = UIButton(frame: CGRect(x: 50, y: 400, width: 100, height: 20))
                    buttonDismiss.backgroundColor = .gray
                    buttonDismiss.setTitleColor(.black, for: .normal)
                    buttonDismiss.setTitle("OK", for: .normal)
                    buttonDismiss.addTarget(self, action: #selector(GameView.win(sender:)), for: .touchUpInside)
                    gameWon.addSubview(buttonDismiss)
                    addSubview(gameWon)
                }
                //save game
                theControl?.save()
            }
            // remove the letters from the array
            wordButtons.removeAll()
        }
    }
    //set the leeters of the buttons
    func populateBoard()
    {
        var i = 0
        while(i < 12)
        {
            var j = 0
            while(j < 9)
            {
                //the sepecial character flag
                var isRed = false
                //check for special characters
                for theSpecInd in (theGame?.specialIndex)!
                {
                    //set background of special characters
                    if(theSpecInd[0] == i && theSpecInd[1] == j)
                    {
                        buttons[i*9 + j].backgroundColor = .red
                        buttons[i*9 + j].color = .red
                        isRed = true
                    }
                }
                //set letter
                buttons[i*9 + j].setTitle(theGame?.board[i][j], for: .normal)
                //if not red anymore set to white
                if(!isRed)
                {
                    buttons[i*9 + j].backgroundColor = .white
                    buttons[i*9 + j].color = .white
                }
                //set background of blank button
                if(buttons[i*9 + j].titleLabel?.text == "?")
                {
                    buttons[i*9 + j].setTitleColor(.lightGray, for: .normal)
                    buttons[i*9 + j].backgroundColor = .lightGray
                }
                else{
                    buttons[i*9 + j].setTitleColor(.black, for: .normal)
                    buttons[i*9 + j].backgroundColor = .white
                }
                j = j + 1
            }
            i = i + 1
        }
        
    }
    //if the passed button is next to the last button selected return true
    func borderingButton(button: GameButton) -> Bool
    {
        if(button.row == wordButtons.last?.row && button.col + 1 == wordButtons.last?.col)
        {
            return true
        }
        else if(button.row == wordButtons.last?.row && button.col - 1 == wordButtons.last?.col)
        {
            return true
        }
        else if(button.row + 1 == wordButtons.last?.row && button.col == wordButtons.last?.col)
        {
            return true
        }
        else if(button.row - 1 == wordButtons.last?.row  && button.col == wordButtons.last?.col)
        {
            return true
        }
        else if(button.row + 1 == wordButtons.last?.row && button.col - 1 == wordButtons.last?.col)
        {
            return true
        }
        else if(button.row + 1 == wordButtons.last?.row && button.col + 1 == wordButtons.last?.col)
        {
            return true
        }
        else if(button.row - 1 == wordButtons.last?.row && button.col - 1 == wordButtons.last?.col)
        {
            return true
        }
        else if(button.row - 1 == wordButtons.last?.row  && button.col + 1 == wordButtons.last?.col)
        {
            return true
        }
        else
        {
            return false
        }
    }
    //get the score of the game
    func getScore() ->Int
    {
        return (theGame?.score)!
    }
    
    func getIndex() -> Int{
        return (theGame?.index)!
    }
    
    func setIndex(index: Int){
        theGame?.index = index
    }
    
    func indexPlueOne(){
        theGame?.index = (theGame?.index)! + 1
    }
    

    
    
    
}
