//
//  StudyDay.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/2/20.
//

import Foundation

//enum Category {
//    case mindfulWork(Int), mindfulPlay(Int), mindlessWork(Int), mindlessPlay(Int)
//}

struct CategoryInfo {
    var mindfulWork: Time
    var mindfulPlay: Time
    var mindlessWork: Time
    var mindlessPlay: Time
    
    static var example: CategoryInfo {
        CategoryInfo(mindfulWork: Time.randomExample, mindfulPlay: Time.randomExample, mindlessWork: Time.randomExample, mindlessPlay: Time.randomExample)
    }
}

struct StudyDay {
    private let date: Date
    var dayHours: HourRange
    var workHours: HourRange
    var categories: CategoryInfo
    
    // TODO: Make computed property return day using date
    var dayString: String {
        return "Today"
    }
    
    init(date: Date, dayHours: HourRange, workHours: HourRange, categories: CategoryInfo) {
        self.date = date
        self.dayHours = dayHours
        self.workHours = workHours
        self.categories = categories
    }
    
    static var example: StudyDay {
        StudyDay(date: Date(), dayHours: HourRange.exampleDayRange, workHours: HourRange.exampleWorkRange, categories: CategoryInfo.example)
    }
}
