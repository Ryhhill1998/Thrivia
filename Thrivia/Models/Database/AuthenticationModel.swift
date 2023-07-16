//
//  UserModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class AuthenticationModel {
    func createAuthUserWithEmailAndPassword(email: String, password: String) -> String? {
        var userId: String?
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let authError = error {
                print(authError.localizedDescription)
            } else {
                userId = authResult?.user.uid
            }
        }
        
        return userId
    }
    
    func signInAuthUserWithEmailAndPassword(email: String, password: String) -> String? {
        var userId: String?
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let authError = error {
                print(authError.localizedDescription)
            } else {
                userId = authResult?.user.uid
            }
        }
        
        return userId
    }
    
    func loginUser(email: String, password: String) -> String? {
        // use Firebase auth to validate credentials and return user object
        guard let userId = signInAuthUserWithEmailAndPassword(email: email, password: password) else { return nil }
        
        // retrieve user details from database
        
        // create auth user object from database details for use in UI
        return userId
    }
    
    func registerUser(email: String, username: String, password: String, confirmPassword: String) -> String? {
        if password == confirmPassword {
            // use Firebase auth to validate credentials and return user object
            guard let userId = createAuthUserWithEmailAndPassword(email: email, password: password) else { return nil }

            // store user details in database

            // create auth user object from database details for use in UI
            return userId
        } else {
            print("passwords don't match")
            return nil
        }
    }
    
    func logoutUser(userId: String) {
        let firebaseAuth = Auth.auth()
        
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func deleteUserAccount(userId: String) {
        // connect to db and delete account
    }
}
