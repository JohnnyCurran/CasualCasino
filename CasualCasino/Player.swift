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
    var chipCount: UInt64 = 500
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("chips")
    
    struct PropertyKey {
        static let chipCount = "chipCount"
    }
    
    init(chipCount: UInt64) {
        self.chipCount = chipCount
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(chipCount, forKey: "chipCount")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let chipCount = aDecoder.decodeObject(forKey: "chipCount") as? UInt64 else {
            os_log("Could not retrieve stored chip count", log: OSLog.default, type: .error)
            return nil
        }
        self.init(chipCount: chipCount)
    }
}
