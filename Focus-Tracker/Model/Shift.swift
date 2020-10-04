//
//  Shift.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/2/20.
//

import Foundation

class Shift: NSObject, Codable, NSCoding {
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
    
    required init(activity: String, start: Date, end: Date) {
        self.activity = activity
        self.start = start
        self.end = end
        
        super.init()
    }

    //MARK: - NSCoding -
    required init(coder aDecoder: NSCoder) {
        activity = aDecoder.decodeObject(forKey: "activity") as! String
        start = aDecoder.decodeObject(forKey: "start") as! Date
        end = aDecoder.decodeObject(forKey: "end") as! Date
    }

    func encode(with coder: NSCoder) {
        coder.encode(activity, forKey: "activity")
        coder.encode(start, forKey: "start")
        coder.encode(end, forKey: "end")
    }
}
