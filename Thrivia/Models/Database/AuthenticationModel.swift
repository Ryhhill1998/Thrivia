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
    private let db = Firestore.firestore()
    
    func listenForAuthStateChanges(setAuthState: @escaping (String?) -> Void) {
        auth.addStateDidChangeListener { auth, user in
            let userId = user?.uid
            setAuthState(userId)
        }
    }
    
    func createAuthUser(email: String, username: String, password: String) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let authError = error {
                print(authError.localizedDescription)
            } else {
                let userId = authResult?.user.uid
                print(userId ?? "none")
                
                // create new user doc in database
                if let unwrappedUserId = userId {
                    self.createUserDoc(userId: unwrappedUserId, email: email, username: username)
                }
            }
        }
    }
    
    private func createUserDoc(userId: String, email: String, username: String) {
        let randomIconColour = "IconColour\(Int.random(in: 1...6))"
        
        db.collection("users").document(userId).setData([
            "email": email,
            "username": username,
            "iconColour": randomIconColour
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
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
