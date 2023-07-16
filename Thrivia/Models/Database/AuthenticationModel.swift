//
//  UserModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

class AuthenticationModel {
    func createUser(id: String, username: String, email: String, password: String) -> String {
        return id
    }
    
    func loginUser(email: String, password: String) -> String? {
        // use Firebase auth to validate credentials and return user object
        
        let userId = UUID().uuidString // actually retrieve from user object
        
        // retrieve user details from database
        
        // create auth user object from database details for use in UI
        return createUser(id: userId, username: "ZigzagZebra24", email: "zigzagzebra24@outlook.com", password: "12345678")
    }
    
    func registerUser(email: String, username: String, password: String, confirmPassword: String) -> String? {
        if password == confirmPassword {
            // use Firebase auth to validate credentials and return user object

            let userId = UUID().uuidString // actually retrieve from user object

            // store user details in database

            // create auth user object from database details for use in UI
            return createUser(id: userId, username: username, email: email, password: password)
        } else {
            return nil
        }
    }
    
    func logoutUser(userId: String) {
        // connect to db and logout
    }
    
    func deleteUserAccount(userId: String) {
        // connect to db and delete account
    }
}
