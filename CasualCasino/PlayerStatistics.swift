//
//  PlayerStatistics.swift
//  CasualCasino
//
//  Created by Johnny Curran on 1/3/18.
//  Copyright © 2018 Johnny Curran. All rights reserved.
//

import Foundation

struct PlayerStatistics: Codable {
    var wins: Int
    var losses: Int
    var pushes: Int
    var winningPercentage: Double
    var refills: Int // Number of times player has hit 0 and needed their balance replenished
    var totalChipsWon: UInt64
    var totalChipsLost: UInt64
    var totalChipsWagered: UInt64
    var gamesPlayed: Int
    var numberOfBlackjacks: Int
    var highestWager: UInt64
    
    /*
    enum CodingKeys: String, CodingKey {
        case wins
        case losses
        case pushes
        case winningPercentage
        case refills
        case totalChipsWon
        case totalChipsLost
        case totalChipsWagered
        case gamesPlayed
        case numberOfBlackjacks
        case highestWager
    }
    */
}
