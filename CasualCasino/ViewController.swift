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
// TODO: Add ability to double down
// TODO: Fix Stack view layout issue
// TODO: (Stretch) Space out dealer obtaining cards. Don't make games end so suddenly
// TODO: Move the dealers cards down further from top of screen
// TODO: Fix issue where deck runs out of cards (lol)
// TODO: Check for blackjack off the flop

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
    @IBOutlet weak var wagerLabel: UILabel!
    @IBOutlet weak var chipsLabel: UILabel!
    @IBOutlet weak var wagerStackViewLabel: UILabel!
    @IBOutlet weak var dealerLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    
    //MARK: Properties
    var currentWager: UInt64 = 0
    var playerHand: Hand = Hand()
    var dealerHand: Hand = Hand()
    var deck: Deck = Deck()
    var player: Player = Player(chipCount: 500)

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Obtain chip count
        if let savedChipCount = loadChipCount() {
            print("load worked")
            if (savedChipCount > 0) {
                player.chipCount = savedChipCount
            }
                // If player's got 0 chips, give him more
            else {
                player.chipCount = 500
            }
        }
        wagerLabel.text = "Wager: 0"
        chipsLabel.text = "Chips: \(player.chipCount)"
        for card in deck.deck {
            print("\(card.displayValue) of \(card.suit)")
        }
    }
    
    // MARK: Button Actions
    
    // Player hits
    @IBAction func dealCard(_ sender: UIButton) {
        dealCard(to: "Player")
        // Check hand value and bust if > 21
        let (lowSum, _) = playerHand.handValue
        if (lowSum > 21) {
            actionStateLabel.text = "Busted!"
            dealButton.isHidden = true
            endGame(result: "lose")
        }
    }

    // Increase wager amount
    @IBAction func increaseWager(_ sender: UIButton) {
        guard let wagerString = sender.currentTitle else {
            os_log("Button wager amount could not be verified.", log: OSLog.default, type: .error)
            return
        }
        let wagerAmount = UInt64(wagerString)!
        // if player has enough chips to make the wager
        if (player.chipCount >= wagerAmount) {
            player.chipCount -= wagerAmount
            currentWager += wagerAmount
        }
        wagerLabel.text = "Wager: \(currentWager)"
        chipsLabel.text = "Chips: \(player.chipCount)"
        if (hitButton.isHidden && currentWager > 0) {
            dealButton.isHidden = false
        }
    }
    
    // Player stands
    @IBAction func playerStand(_ sender: UIButton) {
        let (lowSum, _) = dealerHand.handValue
        hitButton.isHidden = true
        // to hit on soft 17, use lowSum
        // to stand on soft 17, use highSum
        if (lowSum < 17) {
            dealCard(to: "Dealer")
            playerStand(sender)
        }
        else {
            compareHands()
        }
    }
    
    // Start the game
    @IBAction func dealFlop(_ sender: UIButton) {
        // Deal first 2 cards
        dealCard(to: "Player")
        dealCard(to: "Player")
        // Deal dealer card
        dealCard(to: "Dealer")
        // Hide deal button
        dealButton.isHidden = true
        // Show action buttons
        hitButton.isHidden = false
        standButton.isHidden = false
        // Update state
        actionStateLabel.text = "Hit or Stand"
        let (_, dealerHighSum) = dealerHand.handValue
        dealerLabel.text = "Dealer shows \(dealerHighSum)"
        // Hide wager buttons
        wagerButtonsStackView.isHidden = true
        wagerStackViewLabel.isHidden = true
    }
    
    // New game
    @IBAction func newGame(_ sender: UIButton) {
        resetView()
        resetModel()
    }
    
    // MARK: Custom methods
    
    // Create new card stack view
    // NOTE: Put a horizontal stack view on the view controller w/ an outlet so it's easy to add the vertical
    // card stack views to it
    func randomCardView(to stack: String) -> Card {
        let cardView = UIStackView()
        cardView.axis = .vertical
        //cardView.alignment = .leading
        cardView.alignment = .center
        cardView.distribution = .fillProportionally
        cardView.contentMode = .center
        
        let card = cardFromDeck()
        // Display labels for card
        let cardValue = UILabel()
        cardValue.text = card.displayValue
        cardValue.textAlignment = .center
        
        let cardSuit = UILabel()
        cardSuit.text = card.suit
        cardSuit.textAlignment = .center
        
        cardView.addArrangedSubview(cardValue)
        cardView.addArrangedSubview(cardSuit)
        
        // Add card View to horizontal stack view
        if (stack == "Player") {
            playerCardStackView.addArrangedSubview(cardView)
        }
        else {
            dealerCardStackView.addArrangedSubview(cardView)
        }
        
        return card
    }

    // MARK: Card Methods
    func dealCard(to hand: String) {
        let card = randomCardView(to: hand)
        // Add dealt card to correct hand
        if (hand == "Dealer") {
            dealerHand.cards.append(card)
        }
        else if (hand == "Player") {
            playerHand.cards.append(card)
        }
        let (lowSum, highSum) = playerHand.handValue
        if (playerHand.numAces > 0 && highSum < 21) {
            handValueLabel.text = "Your hand: \(lowSum) or \(highSum)"
        }
        else if (playerHand.numAces > 0 && highSum > 21) {
            handValueLabel.text = "Your hand: \(lowSum)"
        }
        else if (playerHand.numAces == 0) {
            handValueLabel.text = "Your hand: \(highSum)"
        }
        else {
            os_log("Something has gone horribly wrong. Ace counts & hand value labels failing.", log: OSLog.default, type: .error)
        }
        let (dealerLowSum, dealerHighSum) = dealerHand.handValue
        if (dealerHighSum > 21) {
            dealerLabel.text = "Dealer shows: \(dealerLowSum)"
        }
        else {
            dealerLabel.text = "Dealer shows: \(dealerHighSum)"
        }
    }
    
    // TODO: If player plays too long, game will crash b/c deck runs out of cards
    // Fix this issue
    func cardFromDeck() -> Card {
        let cardIndex: Int = Int(arc4random_uniform(UInt32(deck.deck.count - 1)))
        return deck.deck.remove(at: cardIndex)
    }
    
    // MARK: Game State Methods
    func compareHands() {
        var playerHandValue: Int
        var dealerHandValue: Int
        let (playerLowSum, playerHighSum) = playerHand.handValue
        let (dealerLowSum, dealerHighSum) = dealerHand.handValue
        
        // Take highest hand values that are not over 21
        if (playerHighSum > 21) {
            playerHandValue = playerLowSum
        }
        else {
            playerHandValue = playerHighSum
        }
        if (dealerHighSum > 21) {
            dealerHandValue = dealerLowSum
        }
        else {
            dealerHandValue = dealerHighSum
        }
        // Player wins
        // Determine if player or dealer wins
        print("Player hand value: \(playerHandValue) \n Dealer hand value: \(dealerHandValue)")
        if (playerHandValue > dealerHandValue || dealerHandValue > 21) {
            actionStateLabel.text = "You win \(2 * currentWager) chips!"
            endGame(result: "win")
        }
        else if (playerHandValue < dealerHandValue) {
            actionStateLabel.text = "Dealer wins!"
            endGame(result: "false")
        }
        else if (playerHandValue == dealerHandValue) {
            actionStateLabel.text = "Game push!"
            endGame(result: "push")
        }
    }

    // Reset game view - wager to 0, hide wagers, hit/stand, show deal button, clear stack views
    func resetView() {
        wagerLabel.text = "Wager: 0"
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
        wagerStackViewLabel.isHidden = false
        wagerButtonsStackView.isHidden = false
        newGameButton.isHidden = true
    }
    
    func endGame(result: String) {
        // TODO: Reset views, models
        // TODO: Credit or Debit chips from player
        // False case unnecessary because wager gets reset to 0 and chips are already removed from balance
        if (result == "win") {
            player.chipCount += 2 * currentWager
        }
        else if (result == "push") {
            player.chipCount += currentWager
        }
        // if loss, no action. chips already removed from chip balance
        // Show reset game thing
        resetModel()
        endGameView()
    }
    
    // Set game state to end game - freeze actions and show 'reset' button
    func endGameView() {
        chipsLabel.text = "Chips: \(player.chipCount)"
        newGameButton.isHidden = false
        hitButton.isHidden = true
        standButton.isHidden = true
        actionStateLabel.text = "\(actionStateLabel.text ?? "") Press new game to play again"
    }
    
    // Empty hands and wagers
    func resetModel() {
        currentWager = 0
        playerHand.cards = []
        dealerHand.cards = []
        if (player.chipCount == 0) {
            // Show out of chips alert
            let alert = UIAlertController(title: "Out of chips!", message: "Your chip balance has hit 0. 500 chips have been credited to your balance", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"Out of Chips\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            player.chipCount = 500
            chipsLabel.text = "Chips: 500"
        }
        updateChipCount()
    }
    
    // MARK: Player methods
    private func updateChipCount() {
        let chipCount = player.chipCount
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
