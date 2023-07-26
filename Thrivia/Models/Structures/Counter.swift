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
    
    var timePassedComponents: DateComponents?
    
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
    
    func getTimePassedComponents() -> DateComponents {
        let now = Date.now
        let calendar = Calendar.current
        
        return calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: start, to: now)
    }
    
    mutating func getTimePassed(unitOfTime: UnitOfTime) -> Int {
        timePassedComponents = getTimePassedComponents()
        
        let timePassedComponents = timePassedComponents!
        
        switch unitOfTime {
        case UnitOfTime.years:
            return timePassedComponents.year ?? 0
        case UnitOfTime.months:
            return timePassedComponents.month ?? 0
        case UnitOfTime.weeks:
            return timePassedComponents.weekOfYear ?? 0
        case UnitOfTime.days:
            return timePassedComponents.day ?? 0
        case UnitOfTime.hours:
            return timePassedComponents.hour ?? 0
        case UnitOfTime.minutes:
            return timePassedComponents.minute ?? 0
        case UnitOfTime.seconds:
            return timePassedComponents.second ?? 0
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
