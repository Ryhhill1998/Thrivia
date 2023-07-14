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
    
    @Published var timeDisplaysAvailable: Int = 4
    
    func createCounter(name: String, startDate: Date, startTime: Date) {
        counter = Counter(name: name, startDate: startDate, startTime: startTime)
        counterName = counter?.name
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            print("Timer fired!")
            self.daysPassed = self.getDaysPassed()
            self.hoursPassed = self.getHoursPassed()
            self.minutesPassed = self.getMinutesPassed()
            self.secondsPassed = self.getSecondsPassed()
        }
    }
    
    func getDaysPassed() -> Int {
        return counter?.getTimePassed(unitOfTime: "days") ?? 0
    }
    
    func getHoursPassed() -> Int {
        return counter?.getTimePassed(unitOfTime: "hours") ?? 0 % 24
    }
    
    func getMinutesPassed() -> Int {
        return counter?.getTimePassed(unitOfTime: "minutes") ?? 0 % 60
    }
    
    func getSecondsPassed() -> Int {
        return counter?.getTimePassed(unitOfTime: "seconds") ?? 0 % 60
    }
}
