//
//  Session.swift
//  Focus-Tracker
//
//  Created by Bryan Li on 10/3/20.
//

import Foundation
import Firebase


struct Session {
    var id: UUID
    var date: Date
    var start: Date
    var end: Date
    var interrupts: Int
    var activities: [Activity] = []
    var category: Category
}

extension Session {
    // Let me know Bryan if this is not what we actually want
    private var activitiesDict: [String: [String: Any]] {
        activities.reduce(into: [String: [String: Any]]()) {
            $0[$1.id.uuidString] = $1.toDict()
        }
    }
    
    enum Keys {
        static let id = "id"
        static let date = "date"
        static let start = "start"
        static let end = "end"
        static let interrupts = "interrupts"
        static let activities = "activities"
        static let category = "category"
    }
    
    func toDict() -> [String: Any] {
        return [Session.Keys.id: id,
                Session.Keys.date: date,
                Session.Keys.start: start,
                Session.Keys.end: end,
                Session.Keys.interrupts: interrupts,
                Session.Keys.activities: activitiesDict,
                Session.Keys.category: category]
    }
    
    init?(_ data: [String: Any]) {
        //as? [Activity] likely causes failures but method is currently unused
        guard let id = data[Session.Keys.id] as? UUID,
            let date = (data[Session.Keys.date] as? Timestamp)?.dateValue(),
            let start = (data[Session.Keys.start] as? Timestamp)?.dateValue(),
            let end = (data[Session.Keys.start] as? Timestamp)?.dateValue(),
            let interrupts = data[Session.Keys.interrupts] as? Int,
            let activities = data[Session.Keys.activities] as? [Activity],
            let category = data[Session.Keys.category] as? Category else {
                return nil
        }

        self.id = id
        self.date = date
        self.start = start
        self.end = end
        self.interrupts = interrupts
        self.activities = activities
        self.category = category
    }
}
