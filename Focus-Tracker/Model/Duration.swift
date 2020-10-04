//
//  Duration.swift
//  Focus-Tracker
//
//  Created by Liam DeVoe on 10/3/20.
//

import Foundation

struct Duration: Codable, Hashable {
    let hour: Int
    let minute: Int
    let second: Int // Maybe make optional?
    
    func toPrettyString() -> String {
        // TODO: Care about seconds?
        return "\(hour) hours, \(minute) minutes"
    }
    
    func toString() -> String {
        // TODO: Care about seconds?
        return String(format: "%02d:%02d", hour, minute)
    }
    
    static var randomExample: Duration {
        return Duration(hour: Int.random(in: 1...12), minute: Int.random(in: 1...59))
    }
    
    static let exampleEight = Time(hour: 8, minute: 0)
    static let exampleNine = Time(hour: 9, minute: 0)
    static let exampleSixteen = Time(hour: 16, minute: 0)
    static let exampleTwentyOne = Time(hour: 21, minute: 0)
}

// I put inits in extension so I don't have to redeclare the default init
extension Duration {
    init(hour: Int, minute: Int) {
        self.init(hour: hour, minute: minute, second: 0)
    }
    
    init(hour: Int) {
        self.init(hour: hour, minute: 0)
    }
}
