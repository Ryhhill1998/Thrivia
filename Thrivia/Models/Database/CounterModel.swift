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
        
        storeCounterInUserDefaults(counter: counter)
        
        return counter
    }
    
    private func storeCounterInUserDefaults(counter: Counter) {
        let defaults = UserDefaults.standard
        
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(counter)

            // Write/Set Data
            defaults.set(data, forKey: "counter")
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    func editCounter(newName: String, newStartDate: Date, updateOriginalStart: Bool) -> Counter? {
        var editedCounter: Counter?
        
        if var counter = retrieveCounterFromUserDefaults() {
            counter.name = newName
            counter.start = newStartDate
            
            if updateOriginalStart {
                counter.originalStart = newStartDate
            }
            
            counter.edits += 1
            
            storeCounterInUserDefaults(counter: counter)
            
            editedCounter = counter
        }
        
        return editedCounter
    }
    
    func resetCounter() -> Counter? {
        var resetCounter: Counter?
        
        if var counter = retrieveCounterFromUserDefaults() {
            counter.start = Date.now
            counter.resets += 1
            
            storeCounterInUserDefaults(counter: counter)
            
            resetCounter = counter
        }
        
        return resetCounter
    }
    
    func getStoredCounter() -> Counter? {
        return retrieveCounterFromUserDefaults()
    }
    
    private func retrieveCounterFromUserDefaults() -> Counter? {
        var counter: Counter?
        
        if let data = UserDefaults.standard.data(forKey: "counter") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                counter = try decoder.decode(Counter.self, from: data)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        
        return counter
    }
}
