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
    
    func getProfileData(userId: String, usernameSetter: @escaping (String) -> Void, emailSetter: @escaping (String) -> Void, iconColourSetter: @escaping (String) -> Void, fetchStatusSetter: @escaping (Bool) -> Void, errorSetter: @escaping (String) -> Void) {
        // connect to db and retrieve user data
        let docRef = db.collection("users").document(userId)

        docRef.getDocument { (document, error) in
            if let error = error {
                errorSetter(error.localizedDescription)
            } else if let document = document, document.exists {
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
        
        fetchStatusSetter(false)
    }
    
    func updateUserUsername(userId: String, newUsername: String, fetchStatusSetter: @escaping (Bool) -> Void, errorSetter: @escaping (String) -> Void) {
        updateField(userId: userId, fieldName: "username", newFieldValue: newUsername, fetchStatusSetter: fetchStatusSetter, errorSetter: errorSetter)
    }
    
    func updateUserEmail(userId: String, newEmail: String, fetchStatusSetter: @escaping (Bool) -> Void, errorSetter: @escaping (String) -> Void) {
        updateField(userId: userId, fieldName: "email", newFieldValue: newEmail, fetchStatusSetter: fetchStatusSetter, errorSetter: errorSetter)
    }
    
    func updateUserPassword(userId: String, newPassword: String, fetchStatusSetter: @escaping (Bool) -> Void, errorSetter: @escaping (String) -> Void) {
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                errorSetter(error.localizedDescription)
            } else {
                print("password changed successfully")
            }
            
            fetchStatusSetter(false)
        }
    }
    
    private func updateField(userId: String, fieldName: String, newFieldValue: String, fetchStatusSetter: @escaping (Bool) -> Void, errorSetter: @escaping (String) -> Void) {
        let docRef = db.collection("users").document(userId)

        // Set the "capital" field of the city 'DC'
        docRef.updateData([
            fieldName: newFieldValue
        ]) { err in
            if let err = err {
                errorSetter(err.localizedDescription)
            } else {
                print("Document successfully updated")
            }
            
            fetchStatusSetter(false)
        }
    }
}
