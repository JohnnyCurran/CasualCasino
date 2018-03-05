//
//  Hand.swift
//  CasualCasino
//
//  Created by Johnny Curran on 12/7/17.
//  Copyright © 2017 Johnny Curran. All rights reserved.
//

import UIKit

class Hand: UIStackView {
    // MARK: Properties
    var cards: [Card]

    var handValue: (Int, Int) {
        get {
            var lowSum: Int = 0
            var highSum: Int = 0
            for card in cards {
                highSum += card.numericValue
            }
            lowSum = highSum
            for _ in 0..<numAces {
                lowSum -= 10
            }
            return (lowSum, highSum)
        }
    }
    
    var highestAllowedValue: Int {
        get {
            let (lowVal, highVal) = self.handValue
            if (highVal > 21) {
                return lowVal
            }
            else {
                return highVal
            }
        }
    }
    
    var isSoft: Bool {
        get {
            return numAces > 0
        }
    }

    var numAces: Int {
        get {
            var aceCount: Int = 0
            for card in cards {
                if (card.numericValue == 11) {
                    aceCount += 1
                }
            }
            return aceCount
        }
    }
    
    var isBusted: Bool {
        get {
            let (lowSum, _) = self.handValue
            if (lowSum > 21) {
                return true
            }
            else {
                return false
            }
        }
    }

    override init(frame: CGRect) {
        self.cards = []
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        self.cards = []
        super.init(coder: coder)
    }

}
