//
//  Concentration.swift
//  Concentration
//
//  Created by Mouhamed Sourang on 10/2/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation

struct Concentration
{
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var  foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var score = 0
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index): chosen index not in the cards" )
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard , matchIndex != index {
                if cards[index] == cards[matchIndex] {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                    score += 2
                }
                // flip the card that has been choosed even if there is no match
                if cards[index].beenFlipped {score += -1}
                cards[index].isFaceUp = true
                cards[index].beenFlipped = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    mutating func startNewGame() {
        indexOfOneAndOnlyFaceUpCard = nil
        score = 0
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].beenFlipped = false
        }
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0 , "Concentration.init(\(numberOfPairsOfCards)): you must choose at lease one card")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card , card]
        }
        cards.shuffle()
    }
}
