//
//  CounterModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 16/07/2023.
//

import SwiftUI
import FirebaseFirestore

class CounterModel {
    
    private let db = Firestore.firestore()
    
    func createCounter(name: String, startDate: Date) -> Counter {
        let counter = Counter(name: name, start: startDate)
        
        Utilities.storeCounterInUserDefaults(counter: counter)
        
        return counter
    }
    
    func editCounter(newName: String, newStartDate: Date, updateOriginalStart: Bool) -> Counter? {
        var editedCounter: Counter?
        
        if var counter = Utilities.retrieveCounterFromUserDefaults() {
            counter.edit(newName: newName, newStart: newStartDate, updateOriginalStart: updateOriginalStart)
            
            Utilities.storeCounterInUserDefaults(counter: counter)
            
            editedCounter = counter
        }
        
        return editedCounter
    }
    
    func resetCounter() -> Counter? {
        var resetCounter: Counter?
        
        if var counter = Utilities.retrieveCounterFromUserDefaults() {
            counter.reset()
            
            Utilities.storeCounterInUserDefaults(counter: counter)
            
            resetCounter = counter
        }
        
        return resetCounter
    }
    
    func getStoredCounter() -> Counter? {
        return Utilities.retrieveCounterFromUserDefaults()
    }
}
