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
        print("user id: \(userId)")
        
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
    
    //    func createCounterDoc(name: String, startDate: Date) async -> String {
    //        // create counter doc in db
    //        do {
    //            let docRef = try await db.collection("counters").addDocument(data: [
    //                "name": name,
    //                "startDate": startDate
    //            ])
    //        }
    //
    //        var ref: DocumentReference? = nil
    //
    //        ref = db.collection("counters").addDocument(data: [
    //            "name": name,
    //            "startDate": startDate
    //        ]) { err in
    //            if let err = err {
    //                print("Error adding document: \(err)")
    //            } else {
    //                let counterId = ref!.documentID
    //                print("Document added with ID: \(counterId)")
    //            }
    //        }
    //    }
}
