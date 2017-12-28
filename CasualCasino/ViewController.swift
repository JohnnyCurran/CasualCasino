//
//  ViewController.swift
//  CasualCasino
//
//  Created by Johnny Curran on 10/13/17.
//  Copyright © 2017 Johnny Curran. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var playerCardStackView: UIStackView!
    @IBOutlet weak var dealerCardStackView: Hand!
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
    }
    
    // MARK: Button Actions
    
    // Player hits
    @IBAction func dealCard(_ sender: UIButton) {
        dealCard(to: "Player")
        // Hide wagers
        wagerButtonsStackView.isHidden = true
        wagerStackViewLabel.isHidden = true
        // Check hand value and bust if > 21
        if (playerHand.handValue > 21) {
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
        hitButton.isHidden = true
        while (dealerHand.handValue < 17) {
            dealCard(to: "Dealer")
        }
        compareHands()
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
        dealerLabel.text = "Dealer shows"
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
        //let cardFrame = playerCardStackView.frame
        //let cardView = UIStackView(frame: CGRect(x: cardFrame.origin.x, y: cardFrame.origin.y, width: 50, height: 100))
        let cardView = UIStackView()
        cardView.axis = .vertical
        cardView.alignment = .leading
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
        handValueLabel.text = "Your hand: \(playerHand.handValue)"
        dealerLabel.text = "Dealer shows: \(dealerHand.handValue)"
    }
    
    func cardFromDeck() -> Card {
        let cardIndex: Int = Int(arc4random_uniform(UInt32(deck.deck.count - 1)))
        return deck.deck.remove(at: cardIndex)
    }
    
    // MARK: Game State Methods
    func compareHands() {
        // Determine if player or dealer wins
        if (playerHand.handValue > dealerHand.handValue || dealerHand.handValue > 21) {
            actionStateLabel.text = "You win!"
            endGame(result: "win")
        }
        else if (playerHand.handValue < dealerHand.handValue) {
            actionStateLabel.text = "Dealer wins!"
            endGame(result: "false")
        }
        else if (playerHand.handValue == dealerHand.handValue) {
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
        actionStateLabel.text = "\(actionStateLabel.text ?? "") Press New Game to Begin"
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
