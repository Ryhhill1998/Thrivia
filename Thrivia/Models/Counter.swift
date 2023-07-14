//
//  Counter.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import Foundation

struct Counter {
    let calendar = Calendar.current
    
    var name: String
    var startDate: Date
    var startTime: Date
    var edits = 0
    var resets = 0
    
    func getTimePassed(unitOfTime: String) -> Int {
        let now = Date.now
        var timePassed: Int
        
        switch unitOfTime {
        case "years":
            timePassed = calendar.dateComponents([.year], from: startDate, to: now).year ?? 0
        case "months":
            timePassed = calendar.dateComponents([.month], from: startDate, to: now).month ?? 0
        case "weeks":
            timePassed = calendar.dateComponents([.weekOfYear], from: startDate, to: now).weekOfYear ?? 0
        case "days":
            timePassed = calendar.dateComponents([.day], from: startDate, to: now).day ?? 0
        case "hours":
            timePassed = calendar.dateComponents([.hour], from: startDate, to: now).hour ?? 0
        case "minutes":
            timePassed = calendar.dateComponents([.minute], from: startDate, to: now).minute ?? 0
        case "seconds":
            timePassed = calendar.dateComponents([.second], from: startDate, to: now).second ?? 0
        default:
            timePassed = 0
        }
        
        return timePassed
    }
}
