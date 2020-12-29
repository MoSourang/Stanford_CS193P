//
//  ViewController.swift
//  Set
//
//  Created by Mouhamed Sourang on 10/27/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    private var shape = String()
    private var color = UIColor()
    private var number = Int()
    private var shadding = (stroke: CGFloat() , alpha:CGFloat())
    var set = Set()
    private var startIndex = 12 {
        didSet {
            endIndex = startIndex + 2
        }
    }
    lazy private var endIndex = startIndex + 2
    private var numberOfCardInPlay = 12
    @IBOutlet var CardButtons: [UIButton]! {
        didSet {
            setUpCards()
            set.setUpGame()
            drawCards()
        }
    }
    @IBOutlet var dealMoreCardButton: UIButton!
    @IBOutlet var SetLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    // creating a visual representation of all the cards that are in play
    @objc private func drawCards() {
        for cardButton in set.cardsInPlay.indices {
            let card = set.cardsInPlay[cardButton]
            
            switch card.shape  {
            case .featureOne:
                shape = "▲"
            case .featureTwo:
                shape = "●"
            case .featureThree:
                shape = "■"
            }
            
            switch card.color {
            case .featureOne:
                color = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
            case .featureTwo:
                color = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            case .featureThree:
                color = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            }
            
            switch card.number {
            case .featureOne:
                number = 1
            case .featureTwo:
                number = 2
            case .featureThree:
                number = 3
            }
            
            switch card.shadding {
            case .featureOne:
                shadding.alpha = 1.0
                shadding.stroke = 0.0
            case .featureTwo:
                shadding.alpha = 0.20
                shadding.stroke = 0.0
            case .featureThree:
                shadding.alpha = 1.0
                shadding.stroke = 8.0
            }
            
            let attribute : [NSAttributedString.Key : Any] = [
                .foregroundColor : color.withAlphaComponent(shadding.alpha),
                .strokeWidth : shadding.stroke,
                .font : UIFont.systemFont(ofSize: 20.0)
            ]
            
            let attributedText = NSAttributedString(string: String(repeating: shape, count: number), attributes: attribute)
            CardButtons[cardButton].layer.cornerRadius = 8.0
            CardButtons[cardButton].setAttributedTitle(attributedText, for: .normal)
        }
    }
    
    @IBAction func ChooseCard(_ sender: UIButton) {
        guard let cardIndex = CardButtons.firstIndex(of: sender) else {return}
        
        // check if the card was choosen and deselct if so
        if set.selectedCards.contains(cardIndex) {
            set.removeCard(at: cardIndex)
            sender.layer.borderWidth = 0.0
            sender.layer.borderColor = .none
        } else {
            set.chooseCard(at: cardIndex)
            sender.layer.borderWidth = 3.0
            sender.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            // User selected 3 cards and there is no match
            if !set.ismatched && set.selectedCards.count == 0 {
                SetLabel.text = "Sorry that's not a Set 🙁"
                Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(refreshUI), userInfo: nil, repeats: false)
            } else if set.ismatched {
                SetLabel.text = "You found a match! 😃"
                Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(drawCards), userInfo: nil, repeats: false)
                Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(refreshUI), userInfo: nil, repeats: false)
            }
        }
    }
    
    // 3 cards are selected and the UI needs to be updated
    @objc func refreshUI() {
        for card in CardButtons {
            card.layer.borderWidth = 0.0
            card.layer.borderColor = .none
            SetLabel.text = "You can do this! 😉"
            // There is a match but there is no more cards in the deck
            if set.cardsDeck.count == 0 && set.ismatched {
                for card in set.cardsInPlay.indices {
                    if set.matchedCards.contains(card) {
                        CardButtons[card].backgroundColor = .clear
                        CardButtons[card].setAttributedTitle(NSAttributedString(string: ""), for: .normal)
                        CardButtons[card].isEnabled = false
                    }
                }
            }
        }
        
        scoreLabel.text = "Score: \(set.score)"
    }
    
    // adding more card to deck
    @IBAction func dealMoreCards(_ sender: UIButton) {
        set.dealMoreCard()
        for card in CardButtons[startIndex...endIndex] {
            card.isEnabled = true
            card.backgroundColor = .white
        }
        drawCards()
        startIndex += 3
        numberOfCardInPlay += 3
        if numberOfCardInPlay == 24 {
            sender.isEnabled = false
        }
    }
    
    func setUpCards() {
        for card in CardButtons[startIndex...23] {
            card.backgroundColor = .clear
            card.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
            card.isEnabled = false
            card.layer.cornerRadius = 8
        }
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        for card in CardButtons {card.isEnabled = true; card.backgroundColor = .white; card.layer.borderColor = nil; card.layer.borderWidth = 0.0}
        dealMoreCardButton.isEnabled = true
        startIndex = 12
        endIndex = startIndex + 2
        numberOfCardInPlay = 12
        set.setUpGame()
        setUpCards()
        SetLabel.text = "You can do this! 😉"
        scoreLabel.text = "Score: \(set.score)"
        drawCards()
    }
}

