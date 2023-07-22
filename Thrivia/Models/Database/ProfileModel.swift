//
//  ProfileModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 16/07/2023.
//

import SwiftUI
import Firebase

class ProfileModel {
    
    private let db = Firestore.firestore()
    
    func getProfileData(userId: String, usernameSetter: @escaping (String) -> Void, emailSetter: @escaping (String) -> Void, iconColourSetter: @escaping (String) -> Void) {
        // connect to db and retrieve user data
        let docRef = db.collection("users").document(userId)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                if let username = data?["username"] as? String {
                    usernameSetter(username)
                }
                
                if let email = data?["email"] as? String {
                    emailSetter(email)
                }
                
                if let iconColour = data?["iconColour"] as? String {
                    iconColourSetter(iconColour)
                }
            }
        }
    }
    
    func updateUserUsername(userId: String, newUsername: String) {
        updateField(userId: userId, fieldName: "username", newFieldValue: newUsername)
    }
    
    func updateUserEmail(userId: String, newEmail: String) {
        updateField(userId: userId, fieldName: "email", newFieldValue: newEmail)
    }
    
    func updateUserPassword(userId: String, newPassword: String) {
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("password changed successfully")
            }
        }
    }
    
    private func updateField(userId: String, fieldName: String, newFieldValue: String) {
        let docRef = db.collection("users").document(userId)

        // Set the "capital" field of the city 'DC'
        docRef.updateData([
            fieldName: newFieldValue
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
