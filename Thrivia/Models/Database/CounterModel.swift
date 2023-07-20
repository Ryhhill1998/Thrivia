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
    
    func createCounter(userId: String, name: String, startDate: Date, counterSetter: @escaping (Counter) -> Void, counterExistsSetter: @escaping (Bool) -> Void, createDisplay: @escaping () -> Void) {
        // create counter doc in db
        var ref: DocumentReference? = nil
        
        ref = db.collection("counters").addDocument(data: [
            "name": name,
            "originalStartDate": startDate,
            "startDate": startDate,
            "edits": 0,
            "resets": 0
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                let counterId = ref!.documentID
                print("Document added with ID: \(counterId)")
                
                // add counter id to user doc
                self.db.collection("users").document(userId).setData([ "counterId": counterId ], merge: true)
                
                let counter = Counter(id: counterId, name: name, originalStart: startDate, start: startDate, edits: 0, resets: 0)
                counterSetter(counter)
                counterExistsSetter(true)
                createDisplay()
            }
        }
    }
    
    func editCounter(counterId: String, newName: String, newStartDate: Date, updateOriginalStart: Bool) {
        let docRef = db.collection("counters").document(counterId)
        
        var updatedData = [
            "name": newName,
            "originalStartDate": newStartDate,
            "startDate": newStartDate,
            "edits": FieldValue.increment(Int64(1)),
            "resets": 0
        ] as [String : Any]
        
        if !updateOriginalStart {
            updatedData.removeValue(forKey: "originalStartDate")
        }

        docRef.updateData(updatedData) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func resetCounter(counterId: String) {
        let docRef = db.collection("counters").document(counterId)

        docRef.updateData([
            "startDate": Date.now,
            "resets": FieldValue.increment(Int64(1))
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func getStoredCounter(userId: String, counterSetter: @escaping (Counter) -> Void, counterExistsSetter: @escaping (Bool) -> Void, createDisplay: @escaping () -> Void) {
        let userDocRef = db.collection("users").document(userId)
        
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                if let counterId = data?["counterId"] as? String {
                    let counterDocRef = self.db.collection("counters").document(counterId)
                    
                    counterDocRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let data = document.data()
                            
                            if let counter = self.createCounterObjectFromData(counterId: counterId, data: data) {
                                counterSetter(counter)
                                counterExistsSetter(true)
                                createDisplay()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func createCounterObjectFromData(counterId: String, data: [String : Any]?) -> Counter? {
        var counter: Counter?
        
        if let counterName = data?["name"] as? String,
           let originalCounterStartDate = (data?["originalStartDate"] as? Timestamp)?.dateValue(),
           let counterStartDate = (data?["startDate"] as? Timestamp)?.dateValue(),
           let counterEdits = data?["edits"] as? Int,
           let counterResets = data?["resets"] as? Int {
            counter = Counter(id: counterId, name: counterName, originalStart: originalCounterStartDate, start: counterStartDate, edits: counterEdits, resets: counterResets)
        }
        
        return counter
    }
}
