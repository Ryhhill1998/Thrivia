//
//  Counter.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import Foundation

struct Counter {
    var name: String
    var startDate: Date
    var startTime: Date
    var edits = 0
    var resets = 0
    
    // properties computed using startDate
    var startDay: Int {
        return Calendar.current.component(.day, from: startDate)
    }
    
    var startMonth: Int {
        return Calendar.current.component(.month, from: startDate)
    }
    
    var startYear: Int {
        return Calendar.current.component(.year, from: startDate)
    }
    
    // properties computed using startTime
    var startHour: Int {
        return Calendar.current.component(.hour, from: startDate)
    }
    
    var startMinute: Int {
        return Calendar.current.component(.minute, from: startDate)
    }
    
    var startSecond: Int {
        return Calendar.current.component(.second, from: startDate)
    }
}
