//
//  Card.swift
//  Animated Set
//
//  Created by Mouhamed Sourang on 2/7/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import Foundation

struct SetCard: Equatable {
    
    private static var cards = [SetCard]()
    
    enum Shape: CaseIterable {case featureOne, featureTwo, featureThree}
    enum Color: CaseIterable {case featureOne, featureTwo, featureThree}
    enum Number: CaseIterable {case featureOne, featureTwo, featureThree}
    enum Shadding: CaseIterable {case featureOne, featureTwo, featureThree}
    
    // enum representing the four dimensions of a cards all 3 possible feature in those dimensions
    var shape: Shape
    var color: Color
    var number: Number
    var shadding: Shadding
    
    // create all 81 cards in a set game, using the 4 dimensions with all possible features
    static func createCard() -> [SetCard] {
        
        cards.removeAll()
        let shapes = [Shape.featureOne, Shape.featureTwo, Shape.featureThree]
        let colors = [Color.featureOne, Color.featureTwo, Color.featureThree]
        let numbers = [Number.featureOne, Number.featureTwo, Number.featureThree]
        let shaddings = [Shadding.featureOne, Shadding.featureTwo, Shadding.featureThree]
        
        for shape in shapes {
            for color in colors {
                for number in numbers {
                    for shadding in shaddings {
                        let card = SetCard(shape: shape, color: color, number: number, shadding: shadding)
                        cards.append(card)
                    }
                }
            }
        }
        return cards
    }
}

