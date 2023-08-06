//
//  CounterViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import Foundation

class CounterViewModel: ObservableObject {
    
    private var counterModel = CounterModel()
    
    private var counter: Counter?
    
    @Published var counterNotCreated = true
    
    @Published var counterName = ""
    
    @Published var timeUnits1 = "Days"
    @Published var timeUnits2 = "Hours"
    @Published var timeUnits3 = "Minutes"
    @Published var timeUnits4 = "Seconds"
    
    @Published var timeValue1 = 0
    @Published var timeValue2 = 0
    @Published var timeValue3 = 0
    @Published var timeValue4 = 0
    
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    @Published var errorExists = false
    
    func loadCounter() {
        counter = counterModel.getStoredCounter()
        updateCounterCreationStatus()
    }
    
    private func resetError() {
        errorExists = false
        errorTitle = ""
        errorMessage = ""
    }
    
    private func setError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        errorExists = true
    }
    
    private func updateCounterCreationStatus() {
        if counter != nil {
            counterName = counter!.getName()
            counterNotCreated = false
            createTimerDisplay()
            resetError()
        }
    }
    
    func generatePreview(name: String, startDate: Date) {
        counter = Counter(name: name, start: startDate)
        
        updateTimeDisplay()
        
        if timeUnits4 == "Seconds" {
            timeValue4 = 0
        }
    }
    
    func createCounter(name: String, startDate: Date) -> Bool {
        if name.isEmpty {
            setError(title: "Creation failure", message: "Counter name cannot be empty.")
            return false
        } else if name.count > 20 {
            setError(title: "Creation failure", message: "Counter name must include 20 characters or fewer.")
            return false
        } else {
            // create counter object and store in User Defaults
            counter = counterModel.createCounter(name: name, startDate: startDate)
            updateCounterCreationStatus()
            return true
        }
    }
    
    private func createTimerDisplay() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.updateTimeDisplay()
        }
    }
    
    func editCounter(newName: String, newStart: Date) -> Bool {
        if newName.isEmpty {
            setError(title: "Creation failure", message: "Counter name cannot be empty.")
            return false
        } else if newName.count > 20 {
            setError(title: "Save failure", message: "Counter name must include 20 characters or fewer.")
            return false
        } else {
            let updateOriginalStart = newStart < getCounterOriginalStart()
            counter = counterModel.editCounter(newName: newName, newStartDate: newStart, updateOriginalStart: updateOriginalStart)
            updateCounterCreationStatus()
            return true
        }
    }
    
    func resetCounter() {
        counter = counterModel.resetCounter()
    }
    
    func getCounterStart() -> Date {
        return counter?.getStart() ?? Date.now
    }
    
    func getCounterOriginalStart() -> Date {
        return counter?.getOriginalStart() ?? Date.now
    }
    
    private func formatDate(date: Date) -> String {
        return date.formatted(date: .long, time: .omitted)
    }
    
    func getFormattedOriginalStartDate() -> String {
        return formatDate(date: getCounterOriginalStart())
    }
    
    func getFormattedRunStartDate() -> String {
        return formatDate(date: getCounterStart())
    }
    
    private func getPlural(time: String, quantity: Int) -> String {
        return "\(time)\(quantity != 1 ? "s" : "")"
    }
    
    private func calculateDaysInMonth(date: Date) -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    private func getUpdatedWeeksAndDaysPassed(daysPassed: Int, weeksPassed: Int) -> [Int] {
        var updatedDaysPassed = daysPassed
        var updatedWeeksPassed = weeksPassed
        
        // get date of current month
        let dateNow = Calendar.current.dateComponents([.day], from: Date.now).day!
        // get date of start date month
        let start = counter?.getStart() ?? Date.now
        let startDate = Calendar.current.dateComponents([.day], from: start).day!
        
        // check if start date is greater than current date and that start date is not equal to 31
        if startDate > dateNow && startDate != 31 {
            // get the number of days in start month
            let daysInMonth = calculateDaysInMonth(date: start)
            
            // check if number of days is not equal to 30
            if daysInMonth != 30 {
                // get difference between 30 and days in month (can be negative or positive)
                let difference = daysInMonth - 30
                
                // adjust weeks passed and days passed accordingly
                if difference > 0 && daysPassed + difference >= 7 {
                    updatedDaysPassed = (daysPassed + difference) % 7
                    updatedWeeksPassed += 1
                } else if daysPassed + difference < 0 {
                    updatedDaysPassed += (7 + difference)
                    updatedWeeksPassed -= 1
                } else {
                    updatedDaysPassed += difference
                }
            }
        }
        
        return [updatedDaysPassed, updatedWeeksPassed]
    }
    
    private func updateTimeDisplay() {
        let yearsPassed = getYearsPassed()
        let monthsPassed = getMonthsPassed()
        var weeksPassed = getWeeksPassed()
        var daysPassed = getDaysPassed()
        let hoursPassed = getHoursPassed()
        let minutesPassed = getMinutesPassed()
        let secondsPassed = getSecondsPassed()
        
        let updatedTimes = getUpdatedWeeksAndDaysPassed(daysPassed: daysPassed, weeksPassed: weeksPassed)
        daysPassed = updatedTimes[0]
        weeksPassed = updatedTimes[1]
        
        if yearsPassed > 0 {
            timeUnits1 = getPlural(time: "Year", quantity: yearsPassed)
            timeUnits2 = getPlural(time: "Month", quantity: monthsPassed)
            timeUnits3 = getPlural(time: "Week", quantity: weeksPassed)
            timeUnits4 = getPlural(time: "Day", quantity: daysPassed)
            
            timeValue1 = yearsPassed
            timeValue2 = monthsPassed
            timeValue3 = weeksPassed
            timeValue4 = daysPassed
        } else if monthsPassed > 0 {
            timeUnits1 = getPlural(time: "Month", quantity: monthsPassed)
            timeUnits2 = getPlural(time: "Week", quantity: weeksPassed)
            timeUnits3 = getPlural(time: "Day", quantity: daysPassed)
            timeUnits4 = getPlural(time: "Hour", quantity: hoursPassed)
            
            timeValue1 = monthsPassed
            timeValue2 = weeksPassed
            timeValue3 = daysPassed
            timeValue4 = hoursPassed
        } else if weeksPassed > 0 {
            timeUnits1 = getPlural(time: "Week", quantity: weeksPassed)
            timeUnits2 = getPlural(time: "Day", quantity: daysPassed)
            timeUnits3 = getPlural(time: "Hour", quantity: hoursPassed)
            timeUnits4 = getPlural(time: "Minute", quantity: minutesPassed)
            
            timeValue1 = weeksPassed
            timeValue2 = daysPassed
            timeValue3 = hoursPassed
            timeValue4 = minutesPassed
        } else {
            timeUnits1 = getPlural(time: "Day", quantity: daysPassed)
            timeUnits2 = getPlural(time: "Hour", quantity: hoursPassed)
            timeUnits3 = getPlural(time: "Minute", quantity: minutesPassed)
            timeUnits4 = getPlural(time: "Second", quantity: secondsPassed)
            
            timeValue1 = daysPassed
            timeValue2 = hoursPassed
            timeValue3 = minutesPassed
            timeValue4 = secondsPassed
        }
    }
    
    private func getYearsPassed() -> Int {
        return counter?.getTimePassed(unitOfTime: Counter.UnitOfTime.years) ?? 0
    }
    
    private func getMonthsPassed() -> Int {
        return counter?.getTimePassed(unitOfTime: Counter.UnitOfTime.months) ?? 0
    }
    
    private func getWeeksPassed() -> Int {
        return counter?.getTimePassed(unitOfTime: Counter.UnitOfTime.weeks) ?? 0
    }
    
    private func getDaysPassed() -> Int {
        return counter?.getTimePassed(unitOfTime: Counter.UnitOfTime.days) ?? 0
    }
    
    private func getHoursPassed() -> Int {
        return counter?.getTimePassed(unitOfTime: Counter.UnitOfTime.hours) ?? 0
    }
    
    private func getMinutesPassed() -> Int {
        return counter?.getTimePassed(unitOfTime: Counter.UnitOfTime.minutes) ?? 0
    }
    
    private func getSecondsPassed() -> Int {
        return counter?.getTimePassed(unitOfTime: Counter.UnitOfTime.seconds) ?? 0
    }
}
