//
//  Card.swift
//  Concentration
//
//  Created by Mouhamed Sourang on 10/2/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation

struct Card
{
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    var beenFlipped = false
    
    static var indentifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        indentifierFactory += 1
        return indentifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
