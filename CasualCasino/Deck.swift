//
//  Deck.swift
//  CasualCasino
//
//  Created by Johnny Curran on 12/7/17.
//  Copyright © 2017 Johnny Curran. All rights reserved.
//

import Foundation

class Deck {
    static var suits: [String] = ["Hearts", "Clubs", "Diamonds", "Spades"]
    static var cards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    
    var deck: [Card]
    init() {
        var deck: [Card] = []
        // New deck
        for suit in Deck.suits {
            for card in Deck.cards {
                deck.append(Card(suit: suit, cardString: card))
            }
        }
        self.deck = deck
    }

}
