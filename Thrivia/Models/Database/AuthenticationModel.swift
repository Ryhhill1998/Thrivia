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
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    func createAuthUser(email: String, username: String, password: String) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let authError = error {
                print(authError.localizedDescription)
            } else {
                let userId = authResult?.user.uid
                print(userId ?? "none")
            }
        }
    }
    
    func signInAuthUser(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let authError = error {
                print(authError.localizedDescription)
            } else {
                let userId = authResult?.user.uid
                print(userId ?? "none")
            }
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
