//
//  HistoryViewModel.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/3/20.
//

import Foundation

struct HistoryViewModel {
    var favorites = [StudyDay.example]
    var all = [StudyDay.example, StudyDay.example]
    
    init(history: [StudyDay]) {
        favorites = [history[0]]
        all = history
    }
}
