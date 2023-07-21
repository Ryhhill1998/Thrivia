//
//  Counter.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import Foundation

struct Counter: Codable {
    
    enum UnitOfTime {
        case years, months, weeks, days, hours, minutes, seconds
    }
    
    let id: String
    var name: String
    var originalStart: Date
    var start: Date
    var edits = 0
    var resets = 0
    
    init(name: String, start: Date) {
        self.init(id: UUID().uuidString, name: name, originalStart: start, start: start, edits: 0, resets: 0)
    }
    
    init(id: String, name: String, originalStart: Date, start: Date, edits: Int, resets: Int) {
        self.id = id
        self.name = name
        self.originalStart = originalStart
        self.start = start
        self.edits = edits
        self.resets = resets
    }
    
    func getTimePassed(unitOfTime: UnitOfTime) -> Int {
        let now = Date.now
        let calendar = Calendar.current
        
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
    
    mutating func edit(newName: String, newStart: Date, updateOriginalStart: Bool) {
        name = newName
        start = newStart
        if updateOriginalStart {
            originalStart = start
        }
        edits += 1
    }
    
    mutating func reset() {
        start = Date.now
        resets += 1
    }
}
