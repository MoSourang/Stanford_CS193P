//
//  ViewController.swift
//  Concentration
//
//  Created by Mouhamed Sourang on 10/1/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController
{
    override func viewDidLoad() {
        if theme == nil {
            theme =  ["🇨🇲","🇧🇫","🇦🇺","🇨🇨","🇷🇴","🇹🇴"]
        }
    }
    
    private lazy var game =  Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    var theme: [String]?
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    
    @IBOutlet private var ScoreLabel: UILabel!
    @IBOutlet private  var cardButtons: [UIButton]! {
        didSet {
            cardButtons.forEach {$0.layer.cornerRadius = 6.0 }
        }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    private func updateViewFromModel() {
        guard theme != nil else {return}
        guard cardButtons != nil else {return}
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = .white
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? .clear : .lightGray
            }
        }
        
        ScoreLabel.text = "Score: \(game.score)"
        
    }
    
    var chossenTheme: [String]! {
        didSet {
            theme = chossenTheme
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    private var themes = [ ["👻","🎃","👿","🍭","🙀","👹"],
                           ["😭","😇","🥰","🥳","😂","🤓"] ,
                           ["🐱","🦋","🐽","🐔","🐻","🐙"] ,
                           ["🥒","🍉","🥬","🧀","🧅","🍔"],
                           ["🏀","🏈", "🎾","🏐","⚽️","🏓"],
                           ["🇨🇲","🇧🇫","🇦🇺","🇨🇨","🇷🇴","🇹🇴"],]
    
    
    private var emoji =  [Card: String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil , theme!.count > 0 {
            let randomIndex = theme!.count.arc4random
            emoji[card] = theme!.remove(at: randomIndex)
        }
        return emoji[card] ?? "?"
    }
    
    
    @IBAction private func newGamePressed(_ sender: UIButton) {
        guard theme != nil else {return}
        game.startNewGame()
        theme!.removeAll()
        emoji.removeAll()
        theme = themes.randomElement()!
        updateViewFromModel()
        emoji.removeAll()
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}
