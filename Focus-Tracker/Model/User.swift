//
//  User.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/3/20.
//

import Foundation

struct User: Codable, Hashable {
    let id: UUID
    
    init() {
        id = UUID()
    }
}
