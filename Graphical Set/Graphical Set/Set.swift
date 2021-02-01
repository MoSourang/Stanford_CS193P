//
//  Set.swift
//  Graphical Set
//
//  Created by Mouhamed Sourang on 1/20/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import Foundation

struct Set {
    
    // The current deck of cards to play from
    private(set) var cardsDeck = [Card]()
    // The cards that are in play and being displayed in the UI
    private(set) var cardsInPlay  =  [Card]()
    // The index of the cards currently selected
    private(set) var selectedCards = [Int]()
    // The index of cards that have been matched
    private(set) var matchedCards = [Int]()
    // variable tracking the match status
    private(set) var ismatched = Bool()
    // variable traking the score
    private(set) var score = Int()
    private var startTime = TimeInterval()
    private var endTime = TimeInterval()
    
    // method to add cards and determine if there is match
    mutating func chooseCard(at cardIndex: Int) {
        
        if selectedCards.count == 0 {startTime = getCurrentTime()}
        if selectedCards.count == 2 {endTime = getCurrentTime()}
        selectedCards.append(cardIndex)
        
        // selected a card but there is not enough selected card to match with
        if selectedCards.count <= 2 {
            ismatched = false
        } else {
            // 3 cards are selected and the model needs to determine if there is a match
            var cardShape = [Card.Shape]()
            var cardColor = [Card.Color]()
            var cardNumber = [Card.Number]()
            var cardShadding = [Card.Shadding]()
            
            for card in selectedCards {
                cardShape.append(cardsInPlay[card].shape)
                cardColor.append(cardsInPlay[card].color)
                cardNumber.append(cardsInPlay[card].number)
                cardShadding.append(cardsInPlay[card].shadding)
            }
            // Method to determine if the 3 selected cards are a match
            if cardShape.ismatch(array: cardShape) && cardColor.ismatch(array: cardColor) && cardNumber.ismatch(array: cardNumber) && cardShadding.ismatch(array: cardShadding) {
                ismatched = true
                if cardsDeck.count >= 3 {replaceCards()} else {hideCards()}
                getScore()
            } else {
                ismatched = false
                selectedCards.removeAll()
                getScore()
            }
        }
    }
    
    // Replacing matched cards with new cards fromt the deck
    mutating func replaceCards() {
        for selectedCard in selectedCards {
            cardsInPlay[selectedCard] = cardsDeck.remove(at: 0)
        }
        selectedCards.removeAll()
    }
    
    // Hidding matched cards from the UI, when the deck is empty
    mutating func hideCards() {
        for card in selectedCards {
            matchedCards.append(card)
        }
        selectedCards.removeAll()
    }
    
    // removing card when it is deselected
    mutating func removeCard(at cardIndex: Int) {
        if let removeIndex = selectedCards.firstIndex(of: cardIndex) {
            selectedCards.remove(at: removeIndex)
        }
    }
    
    // Dealing more cards by request
    mutating func dealMoreCard() {
        if cardsDeck.count >= 3 {
            for _ in 1...3 {
                cardsInPlay.append(cardsDeck.remove(at: 0))
            }
        }
    }
    
    func getCurrentTime() -> TimeInterval {
        let date = Date()
        return date.timeIntervalSince1970
    }
    
    mutating func shuffleCards() {
        cardsInPlay.shuffle()
    }
    
    mutating func getScore() {
        let timeElapsed = endTime - startTime
        if ismatched {
            if timeElapsed <= 60 {
                score = 5
            } else if timeElapsed <= 120 {
                score = 3
            } else {
                score = 1
            }
        } else {
            score -= 3
        }
    }
    
    mutating func setUpGame() {
        cardsDeck.removeAll()
        cardsInPlay.removeAll()
        selectedCards.removeAll()
        matchedCards.removeAll()
        ismatched = false
        score = 0
        cardsDeck = Card.createCard()
        print(cardsDeck.count - 69)
        
        for card in 1...(cardsDeck.count - 69) {
            cardsInPlay.append(cardsDeck.remove(at: card))
        }
    }
}

extension Array {
    func ismatch<T>(array: [T]) -> Bool {
        var match = false
        if String("\(array[0])") == String("\(array[1])") && String("\(array[1])") == String("\(array[2])")  {
            match = true
        } else if String("\(array[0])") != String("\(array[1])") && String("\(array[1])") != String("\(array[2])") && String("\(array[0])") != String("\(array[2])")  {
            match = true
        }
        return match
    }
}

extension TimeInterval {
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
}


