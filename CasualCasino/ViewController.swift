//
//  ViewController.swift
//  CasualCasino
//
//  Created by Johnny Curran on 10/13/17.
//  Copyright © 2017 Johnny Curran. All rights reserved.
//

import UIKit
import os.log

// TODO: Make Wager label on top of stack view buttons responsible for showing current wager amount
// TODO: Fix Stack view layout issue
// TODO: (Stretch) Space out dealer obtaining cards. Don't make games end so suddenly
// TODO: Move the dealers cards down further from top of screen
// TODO: Fix issue where deck runs out of cards (lol)
// TODO: Implement doubling down & splits
// TODO: Keep track of player statistics (wins/losses/total wagered/total lost)

class ViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var playerCardStackView: UIStackView!
    @IBOutlet weak var dealerCardStackView: UIStackView!
    @IBOutlet weak var wagerButtonsStackView: UIStackView!
    @IBOutlet weak var handValueLabel: UILabel!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var standButton: UIButton!
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var actionStateLabel: UILabel!
    @IBOutlet weak var wagerFive: UIButton!
    @IBOutlet weak var wagerTen: UIButton!
    @IBOutlet weak var wagerTwentyFive: UIButton!
    @IBOutlet weak var wagerFifty: UIButton!
    @IBOutlet weak var wagerOneHundred: UIButton!
    @IBOutlet weak var chipsLabel: UILabel!
    @IBOutlet weak var wagerStackViewLabel: UILabel!
    @IBOutlet weak var dealerLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    
    //MARK: Properties
    var game: Game = Game(playerHand: Hand(), dealerHand: Hand(), deck: Deck(numDecks: 5), player: Player(chipCount: 500))

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get Chip count
        if let savedChipCount = loadChipCount() {
            print("load worked")
            if (savedChipCount > 0) {
                game.player.chipCount = savedChipCount
            }
                // If player's got 0 chips, give him more
            else {
                print("no load. Setting player chip count to 500.")
                game.player.chipCount = 500
            }
        }
        wagerStackViewLabel.text = "Wager: 0"
        chipsLabel.text = "Chips: \(game.player.chipCount)"
    }
    
    // MARK: Button Actions
    
    // Increase wager amount
    @IBAction func increaseWager(_ sender: UIButton) {
        guard let wagerString = sender.currentTitle else {
            os_log("Button wager amount could not be verified.", log: OSLog.default, type: .error)
            return
        }
        let wagerAmount = UInt64(wagerString)!
        // if player has enough chips to make the wager
        if (game.player.chipCount >= wagerAmount) {
            game.player.chipCount -= wagerAmount
            game.wagerAmount += wagerAmount
        }
        wagerStackViewLabel.text = "Wager: \(game.wagerAmount)"
        chipsLabel.text = "Chips: \(game.player.chipCount)"
        if (hitButton.isHidden && game.wagerAmount > 0) {
            dealButton.isHidden = false
        }
    }
    
    // Player hits
    @IBAction func dealCard(_ sender: UIButton) {
        let cardDealt = game.dealCard(to: game.playerHand)
        sendCardToView(card: cardDealt, stackView: self.playerCardStackView)

        updatePlayerHandValueLabel()
    }

    // Player stands
    @IBAction func playerStand(_ sender: UIButton) {
        hitButton.isHidden = true
        // Deal out cards and update view
        let dealerCardsDealt = game.playerStand()
        for card in dealerCardsDealt {
            sendCardToView(card: card, stackView: self.dealerCardStackView)
        }
        guard let gameResult = game.determineGameResult() else {
            os_log("Game result nil. Terminating", log: OSLog.default, type: .error)
            return
        }
        endGame(result: gameResult)
    }

    // Start the game
    @IBAction func dealFlop(_ sender: UIButton) {
        // Deal first 2 cards
        sendCardToView(card: game.dealCard(to: game.playerHand), stackView: self.playerCardStackView)
        sendCardToView(card: game.dealCard(to: game.playerHand), stackView: self.playerCardStackView)
        // Deal dealer cards
        sendCardToView(card: game.dealCard(to: game.dealerHand), stackView: self.dealerCardStackView)
        sendCardToView(card: game.dealCard(to: game.dealerHand), stackView: self.dealerCardStackView, hidden: true)
        
        // Show & Hide buttons
        dealButton.isHidden = true
        hitButton.isHidden = false
        standButton.isHidden = false
        wagerButtonsStackView.isHidden = true
        
        // Update state
        actionStateLabel.text = "Hit or Stand"
        let dealerShows = game.dealerHand.cards[0].numericValue
        dealerLabel.text = "Dealer shows \(dealerShows)"
        updatePlayerHandValueLabel()

        let isBlackjack = game.isBlackjack()
        if (isBlackjack != nil) {
            endGame(result: isBlackjack!)
        }
    }
    
    // New game - Reset View & Model
    @IBAction func newGame(_ sender: UIButton) {
        // Reset Model
        game.resetHands()
        // Reset View
        wagerStackViewLabel.text = "Wager: 0"
        for cardView in playerCardStackView.arrangedSubviews as [UIView] {
            playerCardStackView.removeArrangedSubview(cardView)
            cardView.removeFromSuperview()
        }
        for cardView in dealerCardStackView.arrangedSubviews as [UIView] {
            dealerCardStackView.removeArrangedSubview(cardView)
            cardView.removeFromSuperview()
        }
        actionStateLabel.text = "Wager an amount to start"
        dealerLabel.text = "Dealer"
        handValueLabel.text = "Your Hand"
        dealButton.isHidden = true
        hitButton.isHidden = true
        standButton.isHidden = true
        wagerButtonsStackView.isHidden = false
        newGameButton.isHidden = true
    }

    // Replace hidden card with proper value
    private func showHiddenCard() {
        // Replace arranged subview with new subview
        let unhiddenCard = game.dealerHand.cards[1]
        let unhiddenCardView = createCardStackView(card: unhiddenCard)
        let hiddenCardView = dealerCardStackView.arrangedSubviews[1]
        dealerCardStackView.removeArrangedSubview(hiddenCardView)
        hiddenCardView.removeFromSuperview()
        dealerCardStackView.addArrangedSubview(unhiddenCardView)
    }
    
    private func updatePlayerHandValueLabel() {
        let (lowSum, highSum) = game.playerHand.handValue
        if (game.playerHand.numAces > 0 && highSum <= 21) {
            handValueLabel.text = "Your hand: \(lowSum) or \(highSum)"
        }
        else if (game.playerHand.numAces > 0 && highSum > 21) {
            handValueLabel.text = "Your hand: \(lowSum)"
        }
        else if (game.playerHand.numAces == 0) {
            handValueLabel.text = "Your hand: \(highSum)"
        }
        else {
            os_log("Something has gone horribly wrong. Ace counts & hand value labels failing.", log: OSLog.default, type: .error)
        }
        if (game.playerHand.isBusted) {
            // player busted!
            endGame(result: Game.GameResult.PlayerBust)
        }
    }
    
    // Create a stack view from a card object
    private func createCardStackView(card: Card, hidden: Bool = false) -> UIImageView {
        let cardHelper = CardHelper()
        let cardImgView = cardHelper.getImageForCard(card: card, hidden: hidden)
        
        return cardImgView
    }
    
    private func sendCardToView(card: Card, stackView: UIStackView, hidden: Bool = false) {
        let cardView = createCardStackView(card: card, hidden: hidden)
        UIView.animate(withDuration: 0.3) {
            stackView.addArrangedSubview(cardView)
        }
    }

    private func endGame(result: Game.GameResult) {
        switch(result) {
        // Player Results
        case .PlayerVictory:
            game.player.chipCount += 2 * game.wagerAmount
            actionStateLabel.text = "You win! You earn \(game.wagerAmount * 2) chips!"
        case .PlayerBlackjack:
            game.player.chipCount += 2 * game.wagerAmount
            actionStateLabel.text = "Blackjack! You earn \(game.wagerAmount * 2) chips!"
        case .PlayerBust:
            actionStateLabel.text = "You busted!"
        // Dealer results
        case .DealerVictory:
            actionStateLabel.text = "Dealer wins!"
        case .DealerBlackjack:
            actionStateLabel.text = "Dealer blackjack! Unlucky!"
        case .DealerBust:
            game.player.chipCount += 2 * game.wagerAmount
            actionStateLabel.text = "Dealer busted! You win \(game.wagerAmount * 2) chips!"
        case .Push:
            game.player.chipCount += game.wagerAmount
            actionStateLabel.text = "Game push!"
        }
        // Show end-game view
        showHiddenCard()
        updateChipCount()
        dealerLabel.text = "Dealer has \(game.dealerHand.highestAllowedValue)"
        chipsLabel.text = "Chips: \(game.player.chipCount)"
        newGameButton.isHidden = false
        hitButton.isHidden = true
        standButton.isHidden = true
        actionStateLabel.text = "\(actionStateLabel.text ?? "") Press new game to play again"
        // Replenish chips if necessary
        if (game.player.checkChips()) {
            // Show out of chips alert
            let alert = UIAlertController(title: "Out of chips!", message: "Your chip balance has hit 0. 500 chips have been credited to your balance", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"Out of Chips\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            chipsLabel.text = "Chips: 500"
        }
    }

    // MARK: Chip count & player statistic methods
    private func updateChipCount() {
        let chipCount = game.player.chipCount
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(chipCount, toFile: Player.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Chip count successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Chip count failed to save...", log: OSLog.default, type: .error)
        }
    }

    private func loadChipCount() -> UInt64? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Player.ArchiveURL.path) as? UInt64
    }
}

