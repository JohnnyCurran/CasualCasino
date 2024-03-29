//
//  Card.swift
//  CasualCasino
//
//  Created by Johnny Curran on 10/18/17.
//  Copyright © 2017 Johnny Curran. All rights reserved.
//

import UIKit

class Card: NSObject {
    // MARK: Properties
    var suit: String
    var cardImage: UIImage?

    // Card type: 2 - 14 (2 through Ace)
    var cardValue: Int
    var numericValue: Int {
        get {
            if (cardValue) == 14 {
                // Ace
                return 11
            }
            else if (cardValue) > 10 {
                // Face
                return 10
            }
            else {
                // Numeric
                return cardValue
            }
        }
    }
    // display String
    var displayValue: String {
        get {
            switch(cardValue) {
            case 11:
                return "Jack"
            case 12:
                return "Queen"
            case 13:
                return "King"
            case 14:
                return "Ace"
            default:
                return String(cardValue)
            }
        }
    }
    init?(cardValue: Int) {
        // card value must be between 2 and 14 (2 through Ace)
        guard (cardValue >= 2 && cardValue <= 14) else {
            return nil
        }
        self.suit = "Hearts"
        self.cardValue = cardValue
    }
    
    init?(suit: String, cardValue: Int) {
        // card value must be between 2 and 14 (2 through Ace)
        guard (cardValue >= 2 && cardValue <= 14) else {
            return nil
        }
        guard !suit.isEmpty else {
            return nil
        }
        self.suit = suit
        self.cardValue = cardValue
    }
}
