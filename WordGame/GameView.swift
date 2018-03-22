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
    var buttons: Array<GameButton> = Array()
    var wordButtons: Array<GameButton> = Array()

    var theGame: Game? = nil
    
    var board = UIView(frame: CGRect(x: 0, y: 0, width: 414, height: 736))
    var gameWon = UIView(frame: CGRect(x: 0, y: 0, width: 414, height: 736))
    let buttonEnd = UIButton(frame: CGRect(x: 225, y: 25, width: 100, height: 20))
    //let buttonWon = UIButton(frame: CGRect(x: 125, y: 25, width: 100, height: 20))
    //see the if the game is inprogress ended by player or won
    enum state {case progress, ended, won}
    enum direction{case notSet, n, ne, e, se, s, sw, w, nw}
    var theDirection = direction.notSet
    private var theState = state.progress

    var getState: state{
        get{
            return theState
        }
    }
    //index in the array
    private var index = -1
    var gameIndex: Int{
        set{
            index = newValue
        }
        get{
            return index
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
        
        let buttonLeave = UIButton(frame: CGRect(x: 25, y: 25, width: 100, height: 20))
        
        buttonLeave.backgroundColor = .white
        //buttonEvent.layer.cornerRadius = 5
        buttonLeave.setTitleColor(.black, for: .normal)
        buttonLeave.setTitle("Leave game", for: .normal)
        buttonLeave.addTarget(self, action: #selector(GameView.leave(sender:)), for: .touchUpInside)
        
        board.addSubview(buttonLeave)
        
        
        
        buttonEnd.backgroundColor = .white
        //buttonEvent.layer.cornerRadius = 5
        buttonEnd.setTitleColor(.black, for: .normal)
        buttonEnd.setTitle("End game", for: .normal)
        buttonEnd.addTarget(self, action: #selector(GameView.end(sender:)), for: .touchUpInside)
        
        board.addSubview(buttonEnd)
        
        /*buttonWon.backgroundColor = .white
        //buttonEvent.layer.cornerRadius = 5
        buttonWon.setTitleColor(.black, for: .normal)
        buttonWon.setTitle("Win game", for: .normal)
        buttonWon.addTarget(self, action: #selector(GameView.win(sender:)), for: .touchUpInside)
        
        board.addSubview(buttonWon)*/
        
        makeBoard()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect)
    {
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
    
    @objc func leave(sender: UIButton!)
    {
        (theControl?.leaveGame(game: self))!

    }
    
    @objc func select(sender: UIButton!)
    {
        sender.backgroundColor = .cyan
        
    }
    
    @objc func end(sender: UIButton!)
    {
        if(theState == state.ended || theState == state.won)
        {
        }
        else
        {
            theControl?.endGame(game: self)
        }
        
    }
    
    @objc func win(sender: UIButton!)
    {

        gameWon.removeFromSuperview()
        theControl?.winGame(game: self)

        
    }
    
    func endState()
    {
        theState = state.ended
        buttonEnd.backgroundColor = .gray
        //buttonWon.backgroundColor = .gray
    }
    
    func winState()
    {
        theState = state.won
        buttonEnd.backgroundColor = .gray
        //buttonWon.backgroundColor = .gray
    }
    
    func makeBoard()
    {
        var x = 5.4
        var y = 140.0
        var i = 0
        var j = 0
        
        while(j < 12)
        {
            while(i < 9)
            {
                let button = GameButton(frame: CGRect(x: x, y: y, width: 40, height: 40))
                button.setXandy(x: x, y: y)
                button.col = i
                button.row = j
                self.addSubview(button)
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
                button.setTitle(" ", for: .normal)
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if(theState == state.progress)
        {
            
            let point: CGPoint = (touches.first?.location(in: board))!
            for b in buttons
            {
                if(b.titleLabel?.text == "?")
                {
                    
                }
                else
                {
                    let pointB = CGPoint(x: b.x, y: b.y)
             
                    if((point.x >= pointB.x && point.x <= pointB.x + 40)&&(point.y >= pointB.y && point.y <= pointB.y + 40))
                    {
                        if(b.entered)
                        {
                            let index = wordButtons.index(of: b)
                            var indexEnd = wordButtons.count - 1
                            if(index == wordButtons.count - 2)
                            {
                                while(index! < indexEnd)
                                {
                                    wordButtons[indexEnd].backgroundColor = wordButtons[indexEnd].color
                                    wordButtons[indexEnd].entered = false
                                    wordButtons[indexEnd].added = false
                                    wordButtons.remove(at: indexEnd)
                                    indexEnd = indexEnd - 1
                                }
                            }
                            if(theControl?.checkWord(buttons: wordButtons))!
                            {
                                for b1 in wordButtons
                                {
                                    b1.backgroundColor = .green
                                }
                            }
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
                            
                            if(borderingButton(button: b))
                            {
                                b.backgroundColor = .cyan
                                b.entered = true
                                if(!b.added)
                                {
                                    b.added = true
                                    wordButtons.append(b)
                                }
                            }
                            
                            if(theControl?.checkWord(buttons: wordButtons))!
                            {
                                for b1 in wordButtons
                                {
                                    b1.backgroundColor = .green
                                }
                            }
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
    
    //bug
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if(theState == state.progress)
        {
            // Get the point to which the finger moved
            let point: CGPoint = (touches.first?.location(in: board))!
            for b in buttons
            {
                if(b.titleLabel?.text == "?")
                {
                    
                }
                else
                {
                    let pointB = CGPoint(x: b.x, y: b.y)
                    if(point.x >= pointB.x && point.x <= pointB.x + 40)
                    {
                        if(point.y >= pointB.y && point.y <= pointB.y + 40)
                        {
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        if(theState == state.progress)
        {
            // Get the point to which the finger moved
            let point: CGPoint = (touches.first?.location(in: board))!
            for b in buttons
            {
                let pointB = CGPoint(x: b.x, y: b.y)
                if(point.x >= pointB.x && point.x <= pointB.x + 40)
                {
                    if(point.y >= pointB.y && point.y <= pointB.y + 40)
                    {
                        if(b.entered == true)
                        {
                            b.exited = true
                        }
                        if(b.entered == false && b.exited == true)
                        {
                            b.exited = false
                        }
                        
                    }
                }
                
            }
            let validWord = theControl?.checkWord(buttons: wordButtons)
            for b1 in wordButtons
            {
                b1.added = false
                b1.entered = false
                b1.backgroundColor = b1.color
            }
            if(validWord)!
            {
                theGame?.changeBoard(buttons: wordButtons, fullList: buttons)
                populateBoard()
                if(theGame?.score == 0)
                {
                    print("Game Won")
                    gameWon.backgroundColor = .white
                    var label = UILabel(frame: CGRect(x: 150, y: 300, width: 225, height: 40))
                    label.text = "Game Won!"
                    gameWon.addSubview(label)
                    let buttonDismiss = UIButton(frame: CGRect(x: 50, y: 400, width: 100, height: 20))
                    buttonDismiss.backgroundColor = .gray
                    //buttonEvent.layer.cornerRadius = 5
                    buttonDismiss.setTitleColor(.black, for: .normal)
                    buttonDismiss.setTitle("OK", for: .normal)
                    buttonDismiss.addTarget(self, action: #selector(GameView.win(sender:)), for: .touchUpInside)
                    gameWon.addSubview(buttonDismiss)
                    addSubview(gameWon)
                    theState = state.won
                    
                }
            }
            
            wordButtons.removeAll()
        }


    }
    
    func populateBoard()
    {
        var i = 0
        
        while(i < 12)
        {
            var j = 0
            while(j < 9)
            {
                var isRed = false
                for theSpecInd in (theGame?.specialIndex)!
                {
                    if(theSpecInd[0] == i && theSpecInd[1] == j)
                    {
                        buttons[i*9 + j].backgroundColor = .red
                        buttons[i*9 + j].color = .red
                        isRed = true
                    }
                }
                buttons[i*9 + j].setTitle(theGame?.board[i][j], for: .normal)
                if(!isRed)
                {
                    buttons[i*9 + j].backgroundColor = .white
                    buttons[i*9 + j].color = .white
                }
                
                j = j + 1
            }
            i = i + 1
        }
        
    }
    
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
    
    func getScore() ->Int
    {
        return (theGame?.score)!
    }
    
}
