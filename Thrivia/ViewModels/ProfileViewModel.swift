//
//  ProfileViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    var user: User
    @Published var username: String
    @Published var email: String
    @Published var password: String
    @Published var iconColour: Color
    
    init() {
        user = User(username: "ZigzagZebra24", email: "zigzagzebra24@outlook.com", password: "12345678", iconColour: Color(uiColor: UIColor(red: 0.57, green: 0.13, blue: 0.50, alpha: 1.00)))
        
        username = user.username
        email = user.email
        password = user.getPassword()
        iconColour = user.iconColour
    }
    
    func logOutUser() {
        print("logging out user")
    }
    
    func deleteUserAccount() {
        print("deleting user account")
    }
    
    func updateUserUsername(newUsername: String) {
        user.updateUsername(newUsername: newUsername)
        username = user.username
    }
    
    func updateUserEmail(newEmail: String) {
        user.updateEmail(newEmail: newEmail)
        email = user.email
    }
    
    func updateUserPassword(newPassword: String) {
        user.updatePassword(newPassword: newPassword)
        password = user.getPassword()
    }
}
