//
//  CardHelper.swift
//  CasualCasino
//
//  Created by Johnny Curran on 3/19/18.
//  Copyright © 2018 Johnny Curran. All rights reserved.
//

import UIKit

class CardHelper {
    // Class to return UIImageView for specified card
    func getImageForCard(card: Card, hidden: Bool = false) -> UIImageView {
        var assetLiteral: String
        if (hidden) {
            assetLiteral = "\(card.suit)Hidden"
        }
        else {
            assetLiteral = "\(card.suit)\(card.displayValue)"
        }
        let cardImgView = UIImageView(image: UIImage(imageLiteralResourceName: assetLiteral))
        
        return cardImgView
    }
}
