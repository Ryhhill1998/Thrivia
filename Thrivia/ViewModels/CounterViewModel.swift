//
//  CounterViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import Foundation

class CounterViewModel: ObservableObject {
    
    @Published var counter: Counter?
    @Published var counterName: String?
    
    @Published var timeUnits1 = "Days"
    @Published var timeUnits2 = "Hours"
    @Published var timeUnits3 = "Minutes"
    @Published var timeUnits4 = "Seconds"
    
    @Published var timeValue1 = 0
    @Published var timeValue2 = 0
    @Published var timeValue3 = 0
    @Published var timeValue4 = 0
    
    func generatePreview(name: String, startDate: Date) {
        counter = Counter(name: name, start: startDate)
        counterName = counter?.name
        
        updateTimeDisplay()
        if timeUnits4 == "Seconds" {
            timeValue4 = 0
        }
    }
    
    func createCounter(name: String, startDate: Date) {
        counter = Counter(name: name, start: startDate)
        counterName = counter?.name
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.updateTimeDisplay()
        }
    }
    
    func updateTimeDisplay() {
        let yearsPassed = getYearsPassed()
        let monthsPassed = getMonthsPassed()
        let weeksPassed = getWeeksPassed()
        let daysPassed = getDaysPassed()
        let hoursPassed = getHoursPassed()
        let minutesPassed = getMinutesPassed()
        let secondsPassed = getSecondsPassed()
        
        if yearsPassed > 0 {
            timeUnits1 = "Years"
            timeUnits2 = "Months"
            timeUnits3 = "Weeks"
            timeUnits4 = "Days"
            
            timeValue1 = yearsPassed
            timeValue2 = monthsPassed
            timeValue3 = weeksPassed
            timeValue4 = daysPassed
        } else if monthsPassed > 0 {
            timeUnits1 = "Months"
            timeUnits2 = "Weeks"
            timeUnits3 = "Days"
            timeUnits4 = "Hours"
            
            timeValue1 = monthsPassed
            timeValue2 = weeksPassed
            timeValue3 = daysPassed
            timeValue4 = hoursPassed
        } else if weeksPassed > 0 {
            timeUnits1 = "Weeks"
            timeUnits2 = "Days"
            timeUnits3 = "Hours"
            timeUnits4 = "Minutes"
            
            timeValue1 = weeksPassed
            timeValue2 = daysPassed
            timeValue3 = hoursPassed
            timeValue4 = minutesPassed
        } else {
            timeUnits1 = "Days"
            timeUnits2 = "Hours"
            timeUnits3 = "Minutes"
            timeUnits4 = "Seconds"
            
            timeValue1 = daysPassed
            timeValue2 = hoursPassed
            timeValue3 = minutesPassed
            timeValue4 = secondsPassed
        }
    }
    
    func getYearsPassed() -> Int {
        return counter?.getTimePassed(unitOfTime: Counter.UnitOfTime.years) ?? 0
    }
    
    func getMonthsPassed() -> Int {
        return (counter?.getTimePassed(unitOfTime: Counter.UnitOfTime.months) ?? 0) % 12
    }
    
    func getWeeksPassed() -> Int {
        return (counter?.getTimePassed(unitOfTime: Counter.UnitOfTime.weeks) ?? 0) % 4
    }
    
    func getDaysPassed() -> Int {
        return (counter?.getTimePassed(unitOfTime: Counter.UnitOfTime.days) ?? 0) % 7
    }
    
    func getHoursPassed() -> Int {
        return (counter?.getTimePassed(unitOfTime: Counter.UnitOfTime.hours) ?? 0) % 24
    }
    
    func getMinutesPassed() -> Int {
        return (counter?.getTimePassed(unitOfTime: Counter.UnitOfTime.minutes) ?? 0) % 60
    }
    
    func getSecondsPassed() -> Int {
        return (counter?.getTimePassed(unitOfTime: Counter.UnitOfTime.seconds) ?? 0) % 60
    }
}
