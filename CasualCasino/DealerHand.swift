//
//  DealerHand.swift
//  CasualCasino
//
//  Created by Johnny Curran on 12/26/17.
//  Copyright © 2017 Johnny Curran. All rights reserved.
//

import UIKit

class DealerHand: Hand {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cards = []
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.cards = []
    }
    
    override func didAddSubview(_ subview: UIView) {
        print("Subview Added!")
    }
}
