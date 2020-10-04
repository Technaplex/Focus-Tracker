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
    
    func hash() -> [Int] {
        let n = type == .dayHours ? 0 : 1
        
        return [n, start.hour, start.minute, start.second, end.hour, end.minute, end.second]
    }
    
    static func from_hash(_ hash: [Int]) -> HourRange {
        HourRange(type: hash[0] == 0 ? .dayHours : .workHours, start: Time(hour: hash[1], minute: hash[2], second: hash[3]), end: Time(hour: hash[4], minute: hash[5], second: hash[6]))
    }
    
    static let exampleDayRange = HourRange(type: .dayHours, start: Time.exampleEight, end: Time.exampleTwentyOne)
    static let exampleWorkRange = HourRange(type: .workHours, start: Time.exampleNine, end: Time.exampleSixteen)
}
