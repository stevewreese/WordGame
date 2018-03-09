//
//  GameView.swift
//  WordGame
//
//  Created by Stephen Reese on 2/27/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit

class GameView: UIView
{
    var buttons: Array<GameButton> = Array()
    var wordButtons: Array<GameButton> = Array()

    var theGame: Game? = nil
    
    
    var board = UIView(frame: CGRect(x: 0, y: 0, width: 414, height: 736))
    let buttonEnd = UIButton(frame: CGRect(x: 225, y: 25, width: 100, height: 20))
    let buttonWon = UIButton(frame: CGRect(x: 125, y: 25, width: 100, height: 20))
    //see the if the game is inprogress ended by player or won
    enum state {case progress, ended, won}
    enum direction{case notSet, n, ne, e, se, s, sw, w, nw}
    var theDirection = direction.notSet
    private var theState = state.progress
    var lastPoint: CGPoint = CGPoint(x: -1000, y: -1000)
    
    
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
        
        buttonWon.backgroundColor = .white
        //buttonEvent.layer.cornerRadius = 5
        buttonWon.setTitleColor(.black, for: .normal)
        buttonWon.setTitle("Win game", for: .normal)
        buttonWon.addTarget(self, action: #selector(GameView.win(sender:)), for: .touchUpInside)
        
        board.addSubview(buttonWon)
        
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
        if(theState == state.ended || theState == state.won)
        {
        }
        else
        {
            theControl?.winGame(game: self)
        }
        
    }
    
    func endState()
    {
        theState = state.ended
        buttonEnd.backgroundColor = .gray
        buttonWon.backgroundColor = .gray
    }
    
    func winState()
    {
        theState = state.won
        buttonEnd.backgroundColor = .gray
        buttonWon.backgroundColor = .gray
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
                self.addSubview(button)
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
                //button.addTarget(self, action: #selector(GameView.select(sender:)), for: .touchDown)
                //button.addTarget(self, action: #selector(GameView.select(sender:)), for: .touchDragEnter)
                //let tapGesture = UITapGestureRecognizer(target: button, action: Selector("drag"))
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
            
            
            // bug of missed highlighted buttons
            let point: CGPoint = (touches.first?.location(in: board))!
            for b in buttons
            {
                if(b.backgroundColor == .blue)
                {
                    
                }
                else
                {
                    let pointB = CGPoint(x: b.x, y: b.y)
                    if(theDirection == direction.notSet)
                    {
                        if(wordButtons.count == 2)
                        {
                            if(wordButtons[0].x < wordButtons[1].x && wordButtons[0].y == wordButtons[1].y)
                            {
                                theDirection = direction.e
                            }
                            else if(wordButtons[0].x > wordButtons[1].x && wordButtons[0].y == wordButtons[1].y)
                            {
                                theDirection = direction.w
                            }
                            else if(wordButtons[0].x == wordButtons[1].x && wordButtons[0].y < wordButtons[1].y)
                            {
                                theDirection = direction.n
                            }
                            else if(wordButtons[0].x == wordButtons[1].x && wordButtons[0].y > wordButtons[1].y)
                            {
                                theDirection = direction.s
                            }
                            else if(wordButtons[0].x == wordButtons[1].x - 45.4 && wordButtons[0].y == wordButtons[1].y - 45.4)
                            {
                                theDirection = direction.ne
                            }
                            else if(wordButtons[0].x == wordButtons[1].x + 45.4 && wordButtons[0].y == wordButtons[1].y - 45.4)
                            {
                                theDirection = direction.nw
                            }
                            else if(wordButtons[0].x == wordButtons[1].x - 45.4 && wordButtons[0].y == wordButtons[1].y + 45.4)
                            {
                                theDirection = direction.se
                            }
                            else if(wordButtons[0].x == wordButtons[1].x + 45.4 && wordButtons[0].y == wordButtons[1].y + 45.4)
                            {
                                theDirection = direction.sw
                            }
                        }
                    }
                    if((point.x >= pointB.x && point.x <= pointB.x + 40)&&(point.y >= pointB.y && point.y <= pointB.y + 40))
                    {
                        if(b.exited)
                        {
                            b.backgroundColor = .white
                            b.entered = false
                            b.added = false
                            if let index = wordButtons.index(of: b) {
                                wordButtons.remove(at: index)
                            }
                        }
                        else{
                            if(theDirection != direction.notSet)
                            {
                                var fingerDirection = direction.notSet
                                if(wordButtons[wordButtons.count - 1].x < b.x && wordButtons[wordButtons.count - 1].y == b.y)
                                {
                                    fingerDirection = direction.e
                                }
                                else if(wordButtons[wordButtons.count - 1].x > b.x && wordButtons[wordButtons.count - 1].y == b.y)
                                {
                                    fingerDirection = direction.w
                                }
                                else if(wordButtons[wordButtons.count - 1].x == b.x && wordButtons[wordButtons.count - 1].y < b.y)
                                {
                                    fingerDirection = direction.n
                                }
                                else if(wordButtons[wordButtons.count - 1].x == b.x && wordButtons[wordButtons.count - 1].y > b.y)
                                {
                                    fingerDirection = direction.s
                                }
                                else if(wordButtons[wordButtons.count - 1].x  == b.x - 45.4 && wordButtons[wordButtons.count - 1].y == b.y - 45.4)
                                {
                                    fingerDirection = direction.ne
                                }
                                else if(wordButtons[wordButtons.count - 1].x == b.x + 45.4 && wordButtons[wordButtons.count - 1].y == b.y - 45.4)
                                {
                                    fingerDirection = direction.nw
                                }
                                else if(wordButtons[wordButtons.count - 1].x == b.x - 45.4 && wordButtons[wordButtons.count - 1].y == b.y + 45.4)
                                {
                                    fingerDirection = direction.se
                                }
                                else if(wordButtons[wordButtons.count - 1].x  == b.x + 45.4 && wordButtons[wordButtons.count - 1].y == b.y + 45.4)
                                {
                                    fingerDirection = direction.sw
                                }
                                
                                if(fingerDirection == theDirection)
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
                            else
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
                if(b.backgroundColor == .blue)
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
            var validWord = theControl?.checkWord(buttons: wordButtons, game: theGame!)
            for b1 in wordButtons
            {
                b1.added = false
                if(validWord)!
                {
                    b1.backgroundColor = .blue
                }
                else{
                    b1.backgroundColor = .white
                }
            }
            wordButtons.removeAll()
            theDirection = direction.notSet
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
                for theSpecInd in (theGame?.specialIndex)!
                {
                    if(theSpecInd[0] == i && theSpecInd[1] == j)
                    {
                        buttons[i*9 + j].backgroundColor = .red
                    }
                }
                buttons[i*9 + j].setTitle(theGame?.board[i][j], for: .normal)
                j = j + 1
            }
            i = i + 1
        }
    }
}
