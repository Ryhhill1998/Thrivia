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
    @Published var daysPassed: Int = 0
    @Published var hoursPassed: Int = 0
    @Published var minutesPassed: Int = 0
    @Published var secondsPassed: Int = 0
    
    @Published var timeDisplays = [Time(unit: "days", value: 0), Time(unit: "hours", value: 0), Time(unit: "minutes", value: 0), Time(unit: "seconds", value: 0)]
    
    func generatePreview(name: String, startDate: Date) {
        counter = Counter(name: name, start: startDate)
        counterName = counter?.name
        
        updateTimeDisplay()
        print("preview updated")
    }
    
    func createCounter(name: String, startDate: Date) {
        counter = Counter(name: name, start: startDate)
        counterName = counter?.name
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.updateTimeDisplay()
        }
    }
    
    func updateTimeDisplay() {
        timeDisplays = []
        
        let yearsPassed = getYearsPassed()
        let monthsPassed = getMonthsPassed()
        let weeksPassed = getWeeksPassed()
        let daysPassed = getDaysPassed()
        let hoursPassed = getHoursPassed()
        let minutesPassed = getMinutesPassed()
        let secondsPassed = getSecondsPassed()
        
        if yearsPassed > 0 {
            timeDisplays.append(Time(unit: "years", value: yearsPassed))
            timeDisplays.append(Time(unit: "months", value: monthsPassed))
            timeDisplays.append(Time(unit: "weeks", value: weeksPassed))
            timeDisplays.append(Time(unit: "days", value: daysPassed))
        } else if monthsPassed > 0 {
            timeDisplays.append(Time(unit: "months", value: monthsPassed))
            timeDisplays.append(Time(unit: "weeks", value: weeksPassed))
            timeDisplays.append(Time(unit: "days", value: daysPassed))
            timeDisplays.append(Time(unit: "hours", value: hoursPassed))
        } else if weeksPassed > 0 {
            timeDisplays.append(Time(unit: "weeks", value: weeksPassed))
            timeDisplays.append(Time(unit: "days", value: daysPassed))
            timeDisplays.append(Time(unit: "hours", value: hoursPassed))
            timeDisplays.append(Time(unit: "minutes", value: minutesPassed))
        } else {
            timeDisplays.append(Time(unit: "days", value: daysPassed))
            timeDisplays.append(Time(unit: "hours", value: hoursPassed))
            timeDisplays.append(Time(unit: "minutes", value: minutesPassed))
            timeDisplays.append(Time(unit: "seconds", value: secondsPassed))
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
