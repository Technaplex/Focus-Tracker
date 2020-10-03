//
//  AppSettings.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/1/20.
//

import Foundation

final class AppSettings {
    static let shared = AppSettings()
    private init() {}
    
    static var store: UserDefaults = {
        let appIdentifierPrefix = Bundle.main.object(forInfoDictionaryKey: "AppIdentifierPrefix") as! String
        let suiteName = "\(appIdentifierPrefix)group.\(Bundle.main.bundleIdentifier!)"
        return UserDefaults(suiteName: suiteName)!
    }()
    
    struct Key {
        static let dayHours = "dayHours"
        static let workHours = "workHours"
        static let playSessionGoal = "playSessionGoal"
        static let workSessionGoal = "workSessionGoal"
        static let timerStartDate = "timerStartDate"
        static let currentUser = "currentUser"
    }
    
    static func registerDefaults() {
        let defaults: [String: Any] = [Key.dayHours: encodeCodable(for: HourRange.exampleDayRange)!,
                                        Key.workHours: encodeCodable(for: HourRange.exampleWorkRange)!,
                                        Key.workSessionGoal: 30,
                                        Key.playSessionGoal: 30,
                                        Key.currentUser: encodeCodable(for: User())!]
        AppSettings.store.register(defaults: defaults)
    }
    
    var dayHours: HourRange {
        get {
            return AppSettings.codable(for: Key.dayHours)!
        }
        set {
            AppSettings.setCodable(for: Key.dayHours, newValue)
        }
    }
    
    var workHours: HourRange {
        get {
            return AppSettings.codable(for: Key.workHours)!
        }
        set {
            AppSettings.setCodable(for: Key.workHours, newValue)
        }
    }
    
    var workSessionGoal: Int {
        get {
            return AppSettings.int(for: Key.workSessionGoal)
        }
        set {
            AppSettings.setInt(for: Key.workSessionGoal, newValue)
        }
    }
    
    var playSessionGoal: Int {
        get {
            return AppSettings.int(for: Key.playSessionGoal)
        }
        set {
            AppSettings.setInt(for: Key.playSessionGoal, newValue)
        }
    }
    
    var timerStartDate: Date? {
        get {
            return AppSettings.codable(for: Key.timerStartDate)
        }
        set {
            AppSettings.setCodable(for: Key.timerStartDate, newValue)
        }
    }
    
    // This should be retrieved from Firebase rather than user defaults
    var activeUser: User {
        get {
            return AppSettings.codable(for: Key.currentUser)!
        }
        set {
            AppSettings.setCodable(for: Key.currentUser, newValue)
        }
    }
}

private extension AppSettings {
    static func string(for key: String) -> String? {
        return AppSettings.store.string(forKey: key)
    }
    
    static func setString(for key: String, _ value: String?) {
        AppSettings.store.set(value, forKey: key)
    }

    static func bool(for key: String) -> Bool {
        return AppSettings.store.bool(forKey: key)
    }

    static func setBool(for key: String, _ flag: Bool) {
        AppSettings.store.set(flag, forKey: key)
    }
    
    static func int(for key: String) -> Int {
        return AppSettings.store.integer(forKey: key)
    }

    static func setInt(for key: String, _ value: Int) {
        AppSettings.store.set(value, forKey: key)
    }
    static func encodeCodable<T: Codable>(for value: T) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(value)
    }
    
    static func decodeCodable<T: Codable>(for value: Data) -> T? {
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: value)
    }
    
    static func codable<T: Codable>(for key: String) -> T? {
        if let savedCodable = AppSettings.store.object(forKey: key) as? Data {
            return decodeCodable(for: savedCodable)
        }
        return nil
    }
    
    static func setCodable<T: Codable>(for key: String, _ value: T) {
        AppSettings.store.set(encodeCodable(for: value), forKey: key)
    }
}