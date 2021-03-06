//
//  Category.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/3/20.
//

import Foundation

enum Category : CustomStringConvertible {
    case mindfulWork, mindfulPlay, mindlessWork, mindlessPlay
    
    func toInt() -> Int {
        switch self {
        case .mindfulWork:
            return 0
        case .mindfulPlay:
            return 1
        case .mindlessWork:
            return 2
        case .mindlessPlay:
            return 3
        }
    }
    
    var description : String {
        switch self {
        case .mindfulWork: return "Mindful Work"
        case .mindfulPlay: return "Mindful Play"
        case .mindlessWork: return "Mindless Work"
        case .mindlessPlay: return "Mindless Play"
        }
    }
}
