//
//  Counter.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import Foundation

struct Counter {
    
    enum UnitOfTime {
        case years, months, weeks, days, hours, minutes, seconds
    }
    
    let calendar = Calendar.current
    
    var name: String
    var start: Date
    var edits = 0
    var resets = 0
    
    func getTimePassed(unitOfTime: UnitOfTime) -> Int {
        let now = Date.now
        
        switch unitOfTime {
        case UnitOfTime.years:
            return calendar.dateComponents([.year], from: start, to: now).year ?? 0
        case UnitOfTime.months:
            return calendar.dateComponents([.month], from: start, to: now).month ?? 0
        case UnitOfTime.weeks:
            return calendar.dateComponents([.weekOfYear], from: start, to: now).weekOfYear ?? 0
        case UnitOfTime.days:
            return calendar.dateComponents([.day], from: start, to: now).day ?? 0
        case UnitOfTime.hours:
            return calendar.dateComponents([.hour], from: start, to: now).hour ?? 0
        case UnitOfTime.minutes:
            return calendar.dateComponents([.minute], from: start, to: now).minute ?? 0
        case UnitOfTime.seconds:
            return calendar.dateComponents([.second], from: start, to: now).second ?? 0
        }
    }
    
    mutating func edit(newName: String, newStart: Date) {
        name = newName
        start = newStart
        edits += 1
    }
    
    mutating func reset() {
        start = Date.now
        resets += 1
    }
}
