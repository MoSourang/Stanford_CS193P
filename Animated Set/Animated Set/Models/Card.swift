//
//  Card.swift
//  Concentration
//
//  Created by Mouhamed Sourang on 10/2/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation

struct Card: Hashable
{
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    var beenFlipped = false
    
    private static var indentifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        indentifierFactory += 1
        return indentifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
