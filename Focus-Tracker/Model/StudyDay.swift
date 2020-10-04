//
//  StudyDay.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/2/20.
//

import Foundation

// Maybe this shoudl be reworked
struct CategoryInfo: Hashable {
    var mindfulWork: Duration
    var mindfulPlay: Duration
    var mindlessWork: Duration
    var mindlessPlay: Duration
    
    static var example: CategoryInfo {
        CategoryInfo(mindfulWork: Duration.randomExample, mindfulPlay: Duration.randomExample, mindlessWork: Duration.randomExample, mindlessPlay: Duration.randomExample)
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
    
    var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    var dayHoursString: String {
        return "Day:  \(dayHours.toString())"
    }
    
    var workHoursString: String {
        return "Work: \(workHours.toString())"
    }

    
    var mindfulPlayString: String {
        return categories.mindfulPlay.toString()
    }
    
    var mindfulWorkString: String {
        return categories.mindfulWork.toString()
    }
    
    var mindlessPlayString: String {
        return categories.mindlessPlay.toString()
    }
    
    var mindlessWorkString: String {
        return categories.mindlessWork.toString()
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
