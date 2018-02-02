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
    static var cards: [String] = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    
    var deck: [Card]
    
    // Create a new, un-shuffled deck
    init() {
        var deck: [Card] = []
        // New deck
        for (index, _) in Deck.cards.enumerated() {
            for suit in Deck.suits {
                deck.append(Card(suit: suit, cardValue: index + 2))
            }
        }
        //deck.shuffle()
        self.deck = deck
    }
    
    // Init deck with amount of cards equivalent to n decks
    init(numDecks: Int) {
        var deck: [Card] = []
        for _ in 0..<numDecks {
            for (index, _) in Deck.cards.enumerated() {
                for suit in Deck.suits {
                    deck.append(Card(suit: suit, cardValue: index + 2))
                }
            }
        }
        deck.shuffle()
        self.deck = deck
    }
    
    // Methods
    func deal() -> Card {
        return self.deck.removeLast()
    }
    
    func shuffleDeck() {
        self.deck.shuffle()
    }
}
