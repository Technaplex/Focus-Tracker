//
//  Session.swift
//  Focus-Tracker
//
//  Created by Bryan Li on 10/3/20.
//

import Foundation
import Firebase

struct Session {

    var id: String
    var date: Date
    var timeStart: Date
    var timeEnd: Date
    var interrupts: Int
    var dict: [String : Any]{
        return ["id": id,
                "date": date,
                "timeStart": timeStart,
                "timeEnd": timeEnd]
    }
    init?(_ data: [String: Any], fs: Bool = false) {
        guard let id = data["id"] as? String,
            let date = fs ? (data["date"] as? Timestamp)?.dateValue() : data["date"] as? Date,
            let timeStart = fs ? (data["timeStart"] as? Timestamp)?.dateValue() : data["timeStart"] as? Date,
            let timeEnd = fs ? (data["timeEnd"] as? Timestamp)?.dateValue() : data["timeEnd"] as? Date,
            let interrupts = data["interrupts"] as? String else {
                return nil
        }

        self.id = id
        self.date = date
        self.timeStart = timeStart
        self.timeEnd = timeEnd
    }
}
