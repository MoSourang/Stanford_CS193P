//
//  Set.swift
//  Animated Set
//
//  Created by Mouhamed Sourang on 2/7/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import Foundation

struct Set {
    
    // The current deck of cards to play from
    private(set) var cardsDeck = [SetCard]()
    // The cards that are in play and being displayed in the UI
    private(set) var cardsInPlay  =  [SetCard]()
    // The index of the cards currently selected
    private(set) var selectedCards = [SetCard]()
    // The index of cards that have been matched
    private(set) var matchedCards = [Int]()
    // variable tracking the match status
    private(set) var ismatched = Bool()
    // variable traking the score
    private(set) var score = Int()
    // last 3 cards that were dealt
    private(set) var lastThreeDealtCards = [Int]()
    private(set) var lastThreeMatchedCards = [Int]()
    private var startTime = TimeInterval()
    private var endTime = TimeInterval()
    
    // method to add cards and determine if there is match
    mutating func chooseCard(at cardIndex: Int) {
        getGameTime()
        let selectCard = cardsInPlay[cardIndex]
        selectedCards.append(selectCard)
        
        // selected a card but there is not enough selected card to match with
        if selectedCards.count <= 2 {
            ismatched = false
        } else {
            // 3 cards are selected and the model needs to determine if there is a match
            var cardShape = [SetCard.Shape]()
            var cardColor = [SetCard.Color]()
            var cardNumber = [SetCard.Number]()
            var cardShadding = [SetCard.Shadding]()
            
            for card in selectedCards {
                guard let selectedCardIndex = cardsInPlay.firstIndex(of: card) else {return}
                cardShape.append(cardsInPlay[selectedCardIndex].shape)
                cardColor.append(cardsInPlay[selectedCardIndex].color)
                cardNumber.append(cardsInPlay[selectedCardIndex].number)
                cardShadding.append(cardsInPlay[selectedCardIndex].shadding)
            }
            // Method to determine if the 3 selected cards are a match
            if cardShape.ismatch(array: cardShape) && cardColor.ismatch(array: cardColor) && cardNumber.ismatch(array: cardNumber) && cardShadding.ismatch(array: cardShadding) {
                ismatched = true
                getScore()
                if cardsDeck.count >= 3 {replaceCards()} else {removeCards()}
                getScore()
            } else {
                ismatched = false
                getScore()
                selectedCards.removeAll()
            }
        }
    }
    
    // Replacing matched cards with new cards from the deck
    mutating func replaceCards() {
        lastThreeMatchedCards.removeAll()
        for selectedCard in selectedCards {
            guard let indexOfCard = cardsInPlay.firstIndex(of: selectedCard) else {return}
            lastThreeMatchedCards.append(indexOfCard)
            cardsInPlay[indexOfCard] = cardsDeck.remove(at: 0)
        }
        selectedCards.removeAll()
    }
    
    // removing card when deck is empty
    mutating func removeCards() {
        for selectedCard in selectedCards {
            cardsInPlay.removeAll(where: {$0 == selectedCard})
        }
        lastThreeMatchedCards.removeAll()
        selectedCards.removeAll()
    }
    
    // unselecting cards
    mutating func unSelectCard(_ card: SetCard) {
        if let removeIndex = selectedCards.firstIndex(of: card) {
            selectedCards.remove(at: removeIndex)
        }
    }
    
    // Dealing more cards by request
    mutating func dealMoreCard() {
        lastThreeDealtCards.removeAll()
        if cardsDeck.count >= 3 {
            for _ in 1...3 {
                let NewCardToAdd = cardsDeck.remove(at: 0)
                cardsInPlay.append(NewCardToAdd)
                lastThreeDealtCards.append(cardsInPlay.lastIndex(of: NewCardToAdd)!)
            }
        }
    }
    
    mutating func getGameTime() {
        if selectedCards.count == 0 {startTime = getCurrentTime()}
        if selectedCards.count == 2 {endTime = getCurrentTime()}
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
                score += 5
            } else if timeElapsed <= 120 {
                score += 3
            } else {
                score += 1
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
        cardsDeck = SetCard.createCard()
        
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



