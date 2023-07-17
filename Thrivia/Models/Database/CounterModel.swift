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
    
    func createCounter(userId: String, name: String, startDate: Date) {
        // create counter doc in db
        var ref: DocumentReference? = nil
        
        ref = db.collection("counters").addDocument(data: [
            "name": name,
            "startDate": startDate
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                let counterId = ref!.documentID
                print("Document added with ID: \(counterId)")

                // add counter id to user doc
                self.db.collection("users").document(userId).setData([ "counterId": counterId ], merge: true)
            }
        }
    }
    
    func setCounter(userId: String, counterSetter: @escaping (Counter) -> Void, counterExistsSetter: @escaping (Bool) -> Void, createDisplay: @escaping () -> Void) {
        let userDocRef = db.collection("users").document(userId)

        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let counterId = data?["counterId"] as? String ?? ""
                
                let counterDocRef = self.db.collection("counters").document(counterId)

                counterDocRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        
                        if let counterName = data?["name"] as? String, let counterStartDate = data?["startDate"] as? Timestamp {
                            let counter = Counter(name: counterName, start: counterStartDate.dateValue())
                            counterSetter(counter)
                            counterExistsSetter(true)
                            createDisplay()
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}
