//
//  ProfileModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 16/07/2023.
//

import SwiftUI

class ProfileModel {
    func getUserUsername(userId: String) -> String {
        // connect to db and retrieve user username
        return "ZigzagZebra24"
    }
    
    func getUserEmail(userId: String) -> String {
        // connect to db and retrieve user email
        return "ZigzagZebra24@outlook.com"
    }
    
    func getUserIconColour(userId: String) -> Color {
        // connect to db and retrieve user icon colour
        return Color(uiColor: UIColor(red: 0.57, green: 0.13, blue: 0.50, alpha: 1.00))
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
