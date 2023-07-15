//
//  User.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

struct User {
    var username: String
    var email: String
    var password: String
    var iconColour: Color
    
    func getPassword() -> String {
        return "**********"
    }
    
    mutating func updateUsername(newUsername: String) {
        username = newUsername
    }
    
    mutating func updateEmail(newEmail: String) {
        email = newEmail
    }
    
    mutating func updatePassword(newPassword: String) {
        password = newPassword
    }
}
