//
//  StudyDay.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/2/20.
//

import Foundation

enum Category {
    case mindfulWork(Time), mindfulPlay(Time), mindlessWork(Time), mindlessPlay(Time)
}

// Maybe this shoudl be reworked
struct CategoryInfo: Hashable {
    var mindfulWork: Time
    var mindfulPlay: Time
    var mindlessWork: Time
    var mindlessPlay: Time
    
    static var example: CategoryInfo {
        CategoryInfo(mindfulWork: Time.randomExample, mindfulPlay: Time.randomExample, mindlessWork: Time.randomExample, mindlessPlay: Time.randomExample)
    }
}

// This is basically a ViewModel
struct StudyDay: Hashable {
    static func == (lhs: StudyDay, rhs: StudyDay) -> Bool {
        lhs.date == rhs.date && lhs.user == rhs.user
    }
    
    private let date: Date
    private let user: User
    private var dayHours: HourRange
    private var workHours: HourRange
    private var categories: CategoryInfo
    
    // TODO: Make computed property return day using date
    var dayString: String {
        return "Today"
    }
    
    var dayHoursString: String {
        return dayHours.toString()
    }
    
    var workHoursString: String {
        return workHours.toString()
    }
    
    
    // TODO: Rework to show using CategoryInfo or Category enum or however we implement
    var mindfulPlayString: String {
        return "12:12"
    }
    
    var mindfulWorkString: String {
        return "12:12"
    }
    
    var mindlessPlayString: String {
        return "12:12"
    }
    
    var mindlessWorkString: String {
        return "12:12"
    }
    
    init(date: Date, dayHours: HourRange, workHours: HourRange, categories: CategoryInfo) {
        self.date = date
        self.dayHours = dayHours
        self.workHours = workHours
        self.categories = categories
        self.user = AppSettings.shared.activeUser
    }
    
    static var example: StudyDay {
        StudyDay(date: Date(), dayHours: HourRange.exampleDayRange, workHours: HourRange.exampleWorkRange, categories: CategoryInfo.example)
    }
}
