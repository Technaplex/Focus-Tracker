//
//  DayInterval.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/1/20.
//

import Foundation


struct HourRange: Codable {
    enum HourType: String, Codable {
        case dayHours
        case workHours // work day should be a time range within a regular day
    }
    
    let type: HourType
    let start: Time
    let end: Time
    
    static let exampleDayRange = HourRange(type: .dayHours, start: Time(hour: 8, minute: 0), end: Time(hour: 21, minute: 0))
    static let exampleWorkRange = HourRange(type: .workHours, start: Time(hour: 9, minute: 0), end: Time(hour: 16, minute: 0))
}

struct Time: Codable {
    let hour: Int
    let minute: Int
}
