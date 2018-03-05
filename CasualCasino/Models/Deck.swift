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
    
    var cards: [Card]
    
    // Create a new, un-shuffled deck
    init() {
        var deck: [Card] = []
        // New deck
        for (index, _) in Deck.cards.enumerated() {
            for suit in Deck.suits {
                deck.append(Card(suit: suit, cardValue: index + 2)!)
            }
        }
        deck.shuffle()
        self.cards = deck
    }
    
    // Init deck with amount of cards equivalent to n decks
    init(numDecks: Int) {
        var deck: [Card] = []
        for _ in 0..<numDecks {
            for (index, _) in Deck.cards.enumerated() {
                for suit in Deck.suits {
                    let newCard = Card(suit: suit, cardValue: index + 2)
                    deck.append(newCard!)
                }
            }
        }
        deck.shuffle()
        self.cards = deck
    }
    
    // Methods
    func deal() -> Card {
        return self.cards.removeLast()
    }
    
    func dealBlackJack() -> [Card] {
        return [Card(cardValue: 14)!, Card(cardValue: 10)!]
    }
    
    func shuffleDeck() {
        self.cards.shuffle()
    }
}
