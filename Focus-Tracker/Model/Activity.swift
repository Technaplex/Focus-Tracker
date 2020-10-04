//
//  Activity.swift
//  Focus-Tracker
//
//  Created by Bryan Li on 10/3/20.
//

import Foundation

struct Activity {

    var id: String
    var sessId: String
    var name: String
    var duration: TimeInterval
    var dict: [String : Any]{
        return ["id": id,
                "sessId": sessId,
                "name": name,
                "duration": duration]
    }
    init?(_ data: [String: Any]) {

        guard let id = data["id"] as? String,
            let sessId = data["sessId"] as? String,
            let name = data["name"] as? String,
            let duration = data["duration"] as? TimeInterval else {
                return nil
        }

        self.id = id
        self.sessId = sessId
        self.name = name
        self.duration = duration
    }

}
