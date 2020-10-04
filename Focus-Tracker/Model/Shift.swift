//
//  Shift.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/2/20.
//

import Foundation

struct Shift: Codable {
    var activity: String
    var start: Date
    var end: Date //Maybe add a did(will?)Set check to ensure end is after start
    
    //Maybe unnecessary
    var range: DateInterval {
        DateInterval(start: start, end: end)
    }
    
    var elapsedTimeString: String {
        return timedeltaToString(Int(end.timeIntervalSince(start)))
    }
}
