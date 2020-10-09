//
//  Concentration.swift
//  Concentration
//
//  Created by Mouhamed Sourang on 10/2/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation

class Concentration
{
    var cards = [Card]()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    var score = 0
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard , matchIndex != index {
                if cards[index].identifier == cards[matchIndex].identifier {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                    score += 2
                }
                // flip the card that has been choosed even if there is no match
                if cards[index].beenFlipped {score += -1}
                cards[index].isFaceUp = true
                cards[index].beenFlipped = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // flipdown all the cards
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                // flip up the cards that has been selected
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
                
            }
        }
    }
    
    func startNewGame() {
        indexOfOneAndOnlyFaceUpCard = nil
        score = 0
        
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card , card]
        }
        cards.shuffle()
    }
}
