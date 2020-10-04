//
//  Activity.swift
//  Focus-Tracker
//
//  Created by Bryan Li on 10/3/20.
//

import Foundation

struct Activity {
    var id: String
    var name: String
    var start: Date
    var end: Date
    
    
    // Let me know if we do actually want duration
    // var duration: TimeInterval
}

extension Activity {
    enum Keys {
        static let id = "id"
        static let name = "name"
        static let start = "start"
        static let end = "end"
    }
    
    // May be used during communication with FireStoreManager
    func toDict() -> [String: Any] {
        return [Activity.Keys.id: id,
                Activity.Keys.name: name,
                Activity.Keys.start: start,
                Activity.Keys.end: end]
    }
    
    init?(_ data: [String: Any]) {

        guard let id = data[Activity.Keys.id] as? String,
            let name = data[Activity.Keys.name] as? String,
            let start = data[Activity.Keys.start] as? Date,
            let end = data[Activity.Keys.end] as? Date else {
                return nil
        }

        self.id = id
        self.name = name
        self.start = start
        self.end = end
    }
}
