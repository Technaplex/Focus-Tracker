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
        static let defaultDayHours = "defaultDayHours"
        static let defaultWorkHours = "defaultWorkHours"
        static let defaultBreakSessionGoal = "defaultBreakSessionGoal"
        static let defaultWorkSessionGoal = "defaultWorkSessionGoal"
    }
    
    static func registerDefaults() {
        let defaults: [String: Any] = [Key.defaultDayHours: encodeCodable(for: HourRange.exampleDayRange)!,
                                        Key.defaultWorkHours: encodeCodable(for: HourRange.exampleWorkRange)!,
                                        Key.defaultWorkSessionGoal: 30,
                                        Key.defaultBreakSessionGoal: 30]
        AppSettings.store.register(defaults: defaults)
    }
    
    var defaultDayHours: HourRange {
        get {
            return AppSettings.codable(for: Key.defaultDayHours) ?? HourRange.exampleDayRange
        }
        set {
            AppSettings.setCodable(for: Key.defaultDayHours, newValue)
        }
    }
    
    var defaultWorkHours: HourRange {
        get {
            return AppSettings.codable(for: Key.defaultWorkHours) ?? HourRange.exampleWorkRange
        }
        set {
            AppSettings.setCodable(for: Key.defaultWorkHours, newValue)
        }
    }
    
    var defaultWorkSessionGoal: Int {
        get {
            return AppSettings.int(for: Key.defaultWorkSessionGoal)
        }
        set {
            AppSettings.setInt(for: Key.defaultWorkSessionGoal, newValue)
        }
    }
    
    var defaultBreakSessionGoal: Int {
        get {
            return AppSettings.int(for: Key.defaultBreakSessionGoal)
        }
        set {
            AppSettings.setInt(for: Key.defaultBreakSessionGoal, newValue)
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
