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

    var handValue: Int {
        get {
            var sum: Int = 0
            let aces = numAces()
            for card in cards {
                sum += card.numericValue
            }
            if (sum > 21 && aces > 0) {
                return sum - (aces * 2)
            }
            return sum
        }
    }
    
    func numAces() -> Int {
        var aceCount: Int = 0
        for card in cards {
            if (card.numericValue == 11) {
                aceCount += 1
            }
        }
        return aceCount
    }

    override init(frame: CGRect) {
        self.cards = []
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        self.cards = []
        super.init(coder: coder)
    }
    
    override func didAddSubview(_ subview: UIView) {
        print("Subview Added!")
    }
}
