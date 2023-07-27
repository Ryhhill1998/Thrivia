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
    
    func getProfileData(userId: String, usernameSetter: @escaping (String) -> Void, emailSetter: @escaping (String) -> Void, iconColourSetter: @escaping (String) -> Void, fetchStatusSetter: @escaping (String) -> Void) {
        // connect to db and retrieve user data
        let docRef = db.collection("users").document(userId)

        docRef.getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
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
                
                fetchStatusSetter("idle")
            }
        }
    }
    
    func updateUserUsername(userId: String, newUsername: String, errorSetter: @escaping (String) -> Void, usernameSetter: @escaping (String) -> Void) {
        // check if username already in use
        db.collection("users").whereField("username", isEqualTo: newUsername)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let foundDocuments = querySnapshot!.documents
                    
                    if foundDocuments.isEmpty {
                        self.updateField(userId: userId, fieldName: "username", newFieldValue: newUsername, errorSetter: errorSetter, fieldSetter: usernameSetter)
                    } else {
                        errorSetter("The username is already in use by another account.")
                    }
                }
            }
    }
    
    func updateUserIconColour(userId: String, newIconColour: String, errorSetter: @escaping (String) -> Void, iconColourSetter: @escaping (String) -> Void) {
        updateField(userId: userId, fieldName: "iconColour", newFieldValue: newIconColour, errorSetter: errorSetter, fieldSetter: iconColourSetter)
    }
    
    func updateUserEmail(userId: String, newEmail: String, errorSetter: @escaping (String) -> Void, emailSetter: @escaping (String) -> Void) {
        Auth.auth().currentUser?.updateEmail(to: newEmail) { error in
            if let error = error {
                errorSetter(error.localizedDescription)
            } else {
                self.updateField(userId: userId, fieldName: "email", newFieldValue: newEmail, errorSetter: errorSetter, fieldSetter: emailSetter)
            }
        }
    }
    
    func updateUserPassword(userId: String, newPassword: String, errorSetter: @escaping (String) -> Void) {
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                errorSetter(error.localizedDescription)
            } else {
                print("password changed successfully")
            }
        }
    }
    
    private func updateField(userId: String, fieldName: String, newFieldValue: String, errorSetter: @escaping (String) -> Void, fieldSetter: @escaping (String) -> Void) {
        let docRef = db.collection("users").document(userId)

        docRef.updateData([
            fieldName: newFieldValue
        ]) { err in
            if let err = err {
                errorSetter(err.localizedDescription)
            } else {
                print("Document successfully updated")
                fieldSetter(newFieldValue)
            }
        }
    }
}
