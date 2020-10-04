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
