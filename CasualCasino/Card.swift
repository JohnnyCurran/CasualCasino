//
//  Card.swift
//  CasualCasino
//
//  Created by Johnny Curran on 10/18/17.
//  Copyright © 2017 Johnny Curran. All rights reserved.
//

import Foundation

class Card: NSObject {
    // MARK: Properties
    var suit: String
    static var cards = ["2": 2,
                 "3": 3,
                 "4": 4,
                 "5": 5,
                 "6": 6,
                 "7": 7,
                 "8": 8,
                 "9": 9,
                 "10": 10,
                 "J": 10,
                 "Q": 10,
                 "K": 10,
                 "A": 11,
                 ]
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
    
    init(suit: String, cardValue: Int) {
        self.suit = suit
        self.cardValue = cardValue
    }
    
}
