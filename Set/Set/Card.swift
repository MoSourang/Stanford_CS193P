//
//  Card.swift
//  Set
//
//  Created by Mouhamed Sourang on 10/27/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation

struct Card: Equatable {
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.shape == rhs.shape || lhs.color == rhs.color ||
            lhs.number == rhs.number || lhs.shadding == rhs.shadding
    }
    
    private static var cards = [Card]()
    
    enum Shape: CaseIterable {case featureOne, featureTwo, featureThree}
    enum Color: CaseIterable {case featureOne, featureTwo, featureThree}
    enum Number: CaseIterable {case featureOne, featureTwo, featureThree}
    enum Shadding: CaseIterable {case featureOne, featureTwo, featureThree}
    
    // enum representing the four dimensions of a cards all 3 possible feature in those dimensions
    let shape: Shape
    let color: Color
    let number: Number
    let shadding: Shadding
    
    // create all 81 cards in a set game, using the 4 dimensions with all possible features
    static func createCard() -> [Card] {
        
        cards.removeAll()
        let shapes = [Shape.featureOne, Shape.featureTwo, Shape.featureThree]
        let colors = [Color.featureOne, Color.featureTwo, Color.featureThree]
        let numbers = [Number.featureOne, Number.featureTwo, Number.featureThree]
        let shaddings = [Shadding.featureOne, Shadding.featureTwo, Shadding.featureThree]
        
        for shape in shapes {
            for color in colors {
                for number in numbers {
                    for shadding in shaddings {
                        let card = Card(shape: shape, color: color, number: number, shadding: shadding)
                        cards.append(card)
                    }
                }
            }
        }
        return cards.shuffled()
    }
}
