//
//  Game.swift
//  CasualCasino
//
//  Created by Johnny Curran on 2/23/18.
//  Copyright © 2018 Johnny Curran. All rights reserved.
//

// Class to handle game functions - compare hands, wins, losses, etc.

import Foundation

class Game {
    var playerHand: Hand
    var dealerHand: Hand
    var wagerAmount: UInt64
    var deck: Deck
    var player: Player

    enum GameResult {
        case PlayerVictory
        case PlayerBlackjack
        case PlayerBust
        case DealerVictory
        case DealerBlackjack
        case DealerBust
        case Push
    }
    
    public func isBlackjack() -> GameResult? {
        let (_, playerValue) = self.playerHand.handValue
        let (_, dealerValue) = self.dealerHand.handValue
        
        if (playerValue == 21 && dealerValue == 21) {
            return GameResult.Push
        }
        else if (playerValue == 21) {
            return GameResult.PlayerBlackjack
        }
        else if (dealerValue == 21) {
            return GameResult.DealerBlackjack
        }
        else {
            print("No blackjack")
            return nil
        }
    }

    public func determineGameResult() -> GameResult? {
        let playerHandValue: Int = self.playerHand.highestAllowedValue
        let dealerHandValue: Int = self.dealerHand.highestAllowedValue

        // Determine winner of game
        if (playerHand.isBusted) {
            return GameResult.PlayerBust
        }
        else if (dealerHand.isBusted) {
            return GameResult.DealerBust
        }
        else if (playerHandValue > dealerHandValue) {
            return GameResult.PlayerVictory
        }
        else if (playerHandValue < dealerHandValue) {
            return GameResult.DealerVictory
        }
        else if (playerHandValue == dealerHandValue) {
            return GameResult.Push
        }
        else {
            print("This shouldn't happen. Something has gone terribly wrong.")
            return nil
        }
    }
    
    public func dealCard(to hand: Hand) -> Card {
        let newCard: Card = deck.deal()
        hand.cards.append(newCard)
        checkDeckCount()
        return newCard
    }
    
    public func playerStand() -> [Card] {
        var cardsDealt: [Card] = []
        // to hit on soft 17, use lowSum
        // to stand on soft 17, use highSum
        var (lowSum, _) = self.dealerHand.handValue
        while (lowSum < 17) {
            let card = dealCard(to: self.dealerHand)
            cardsDealt.append(card)
            // Sum must be updated every time b/c sum is a constant
            let (sum, _) = dealerHand.handValue
            lowSum = sum
        }
        return cardsDealt
    }
    
    // Double down
    public func doubleDown() -> Card {
        // Deal one more card to player
        let card = dealCard(to: self.playerHand)
        // Double wager amount
        self.wagerAmount *= 2
        return card
    }
    
    public func resetHands() {
        self.playerHand = Hand()
        self.dealerHand = Hand()
        self.wagerAmount = 0
    }

    private func checkDeckCount() {
        if (self.deck.cards.count < 52) {
            // Replace deck when card count runs low
            self.deck = Deck(numDecks: 5)
        }
    }

    init(playerHand: Hand, dealerHand: Hand, deck: Deck, player: Player) {
        self.playerHand = playerHand
        self.dealerHand = dealerHand
        self.deck = deck
        self.player = player
        self.wagerAmount = 0
    }
}
