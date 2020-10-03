//
//  DayInterval.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/1/20.
//

import Foundation


struct HourRange: Codable, Hashable {
    enum HourType: String, Codable {
        case dayHours
        case workHours // work day should be a time range within a regular day
    }
    
    let type: HourType
    var start: Time
    var end: Time
    
    func toString() -> String {
        // TODO: Care about seconds?
        return "\(start.toString()) - \(end.toString())"
    }
    
    static let exampleDayRange = HourRange(type: .dayHours, start: Time.exampleEight, end: Time.exampleTwentyOne)
    static let exampleWorkRange = HourRange(type: .workHours, start: Time.exampleNine, end: Time.exampleSixteen)
}

struct Time: Codable, Hashable {
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
    
    static var randomExample: Time {
        return Time(hour: Int.random(in: 1...12), minute: Int.random(in: 1...59))
    }
    
    static let exampleEight = Time(hour: 8, minute: 0)
    static let exampleNine = Time(hour: 9, minute: 0)
    static let exampleSixteen = Time(hour: 16, minute: 0)
    static let exampleTwentyOne = Time(hour: 21, minute: 0)
}

// I put inits in extension so I don't have to redeclare the default init
extension Time {
    init(hour: Int, minute: Int) {
        self.init(hour: hour, minute: minute, second: 0)
    }
    
    init(hour: Int) {
        self.init(hour: hour, minute: 0)
    }
}
