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
    var buttons: Array<UIButton> = Array()
    
    let buttonEnd = UIButton(frame: CGRect(x: 225, y: 25, width: 100, height: 20))
    let buttonWon = UIButton(frame: CGRect(x: 125, y: 25, width: 100, height: 20))
    //see the if the game is inprogress ended by player or won
    enum state {case progress, ended, won}
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
        self.backgroundColor = .white
        
        let buttonLeave = UIButton(frame: CGRect(x: 25, y: 25, width: 100, height: 20))
        
        buttonLeave.backgroundColor = .white
        //buttonEvent.layer.cornerRadius = 5
        buttonLeave.setTitleColor(.black, for: .normal)
        buttonLeave.setTitle("Leave game", for: .normal)
        buttonLeave.addTarget(self, action: #selector(GameView.leave(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonLeave)
        
        
        
        buttonEnd.backgroundColor = .white
        //buttonEvent.layer.cornerRadius = 5
        buttonEnd.setTitleColor(.black, for: .normal)
        buttonEnd.setTitle("End game", for: .normal)
        buttonEnd.addTarget(self, action: #selector(GameView.end(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonEnd)
        
        buttonWon.backgroundColor = .white
        //buttonEvent.layer.cornerRadius = 5
        buttonWon.setTitleColor(.black, for: .normal)
        buttonWon.setTitle("Win game", for: .normal)
        buttonWon.addTarget(self, action: #selector(GameView.win(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonWon)
        
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
                let button = UIButton(frame: CGRect(x: x, y: y, width: 40, height: 40))
                self.addSubview(button)
                button.backgroundColor = .black
                button.setTitleColor(.white, for: .normal)
                button.addTarget(self, action: #selector(GameView.select(sender:)), for: .touchDown)
                button.addTarget(self, action: #selector(GameView.select(sender:)), for: .touchDragEnter)
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

        
    }
}
