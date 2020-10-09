//
//  ViewController.swift
//  Concentration
//
//  Created by Mouhamed Sourang on 10/1/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    override func viewDidLoad() {
        theme = themes.randomElement()!
    }
    
    lazy var game =  Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    var theme  = [String]()
    
    
    @IBOutlet var ScoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = .white
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? .clear : .systemOrange
            }
        }
        
        ScoreLabel.text = "Score: \(game.score)"
    }
    
    var themes = [ ["👻","🎃","👿","🍭","🙀","👹"],
                   ["😭","😇","🥰","🥳","😂","🤓"] ,
                   ["🐱","🦋","🐽","🐔","🐻","🐙"] ,
                   ["🥒","🍉","🥬","🧀","🧅","🍔"],
                   ["🏀","🏈", "🎾","🏐","⚽️","🏓"],
                   ["🇨🇲","🇧🇫","🇦🇺","🇨🇨","🇷🇴","🇹🇴"],]
    
    
    var emoji =  [Int: String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil , theme.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(theme.count)))
            emoji[card.identifier] = theme.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    
    @IBAction func newGamePressed(_ sender: UIButton) {
        game.startNewGame()
        theme.removeAll()
        emoji.removeAll()
        theme = themes.randomElement()!
        updateViewFromModel()
        emoji.removeAll()
    }
    
}

