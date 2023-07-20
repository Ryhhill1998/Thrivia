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
        // connect to db and change user username
    }
    
    func updateUserEmail(userId: String, newEmail: String) {
        // connect to db and change user email
    }
    
    func updateUserPassword(userId: String, newPassword: String) {
        // connect to db and change user password
    }
}
