//
//  Player.swift
//  CasualCasino
//
//  Created by Johnny Curran on 12/27/17.
//  Copyright © 2017 Johnny Curran. All rights reserved.
//

import UIKit
import os.log

class Player: NSObject, NSCoding {
    // MARK: Properties
    var chipCount: UInt64
    
    // MARK: Player Statistics
    //var wins: Int
    //var losses: Int
    //var pushes: Int
    //var winningPercentage: Double
    //var refills: Int // Number of times player has hit 0 and needed their balance replenished
    //var totalChipsWon: UInt64
    //var totalChipsLost: UInt64
    //var totalChipsWagered: UInt64
    //var gamesPlayed: Int
    //var numberOfBlackjacks: Int
    //var highestWager: UInt64
    //var highestChipsHeld: UInt64 // Greatest number of chips player has held at any given time
    
    
    // MARK: Methods
    func checkChips() -> Bool {
        if (self.chipCount == 0) {
            self.chipCount = 500
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("PlayerInformation")
    
    struct PropertyKey {
        static let chipCount = "chipCount"
        //static let wins = "wins"
        //static let losses = "losses"
        //static let pushes = "pushes"
        //static let winningPercentage = "winningPercentage"
        //static let refills = "refills"
        //static let totalChipsWon = "totalChipsWon"
        //static let totalChipsLost = "totalChipsLost"
        //static let totalChipsWagered = "totalChipsWagered"
        //static let gamesPlayed = "gamesPlayed"
        //static let numberOfBlackjacks = "numberOfBlackjacks"
        //static let highestWager = "highestWager"
        //static let highestChipsHeld = "highestChipsHeld"
    }
    
    init(chipCount: UInt64) {
        self.chipCount = chipCount
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(chipCount, forKey: "chipCount")
    }
    
    // Decode chips count, stats, and init player
    required convenience init?(coder aDecoder: NSCoder) {
        guard let chipCount = aDecoder.decodeObject(forKey: "chipCount") as? UInt64 else {
            os_log("Could not retrieve stored chip count", log: OSLog.default, type: .error)
            return nil
        }
        self.init(chipCount: chipCount)
        /*
        guard let wins = aDecoder.decodeObject(forKey: "wins") as? Int else {
            os_log("Could not retrieve stored wins", log: OSLog.default, type: .error)
            return nil
        }
        guard let losses = aDecoder.decodeObject(forKey: "losses") as? Int else {
            os_log("Could not retrieve stored losses", log: OSLog.default, type: .error)
            return nil
        }
        guard let pushes = aDecoder.decodeObject(forKey: "pushes") as? Int else {
            os_log("Could not retrieve stored pushes", log: OSLog.default, type: .error)
            return nil
        }
        guard let winningPercentage = aDecoder.decodeObject(forKey: "winningPercentage") as? Double else {
            os_log("Could not retrieve stored winning percentage", log: OSLog.default, type: .error)
            return nil
        }
        guard let refills = aDecoder.decodeObject(forKey: "refills") as? Int else {
            os_log("Could not retrieve stored refills", log: OSLog.default, type: .error)
            return nil
        }
        guard let totalChipsWon = aDecoder.decodeObject(forKey: "totalChipsWon") as? UInt64 else {
            os_log("Could not retrieve stored total chips won", log: OSLog.default, type: .error)
            return nil
        }
        guard let totalChipsLost = aDecoder.decodeObject(forKey: "totalChipsLost") as? UInt64 else {
            os_log("Could not retrieve stored total chips lost", log: OSLog.default, type: .error)
            return nil
        }
        guard let totalChipsWagered = aDecoder.decodeObject(forKey: "totalChipsWagered") as? UInt64 else {
            os_log("Could not retrieve stored total chips wagered", log: OSLog.default, type: .error)
            return nil
        }
        guard let gamesPlayed = aDecoder.decodeObject(forKey: "gamesPlayed") as? Int else {
            os_log("Could not retrieve stored games played", log: OSLog.default, type: .error)
            return nil
        }
        guard let numberOfBlackjacks = aDecoder.decodeObject(forKey: "numberOfBlackjacks") as? Int else {
            os_log("Could not retrieve stored number of blackjacks", log: OSLog.default, type: .error)
            return nil
        }
        guard let highestWager = aDecoder.decodeObject(forKey: "highestWager") as? UInt64 else {
            os_log("Could not retrieve stored highest wager", log: OSLog.default, type: .error)
            return nil
        }
        guard let highestChipsHeld = aDecoder.decodeObject(forKey: "highestChipsHeld") as? UInt64 else {
            os_log("Could not retrieve stored highest chips held", log: OSLog.default, type: .error)
            return nil
        }
        self.init(chipCount: chipCount, wins: wins, losses: losses, pushes: pushes, winningPercentage: winningPercentage, refills: refills, totalChipsWon: totalChipsWon, totalChipsLost: totalChipsLost, totalChipsWagered: totalChipsWagered, gamesPlayed: gamesPlayed, numberOfBlackjacks: numberOfBlackjacks, highestWager: highestWager, highestChipsHeld: highestChipsHeld)
        */
    }
}
