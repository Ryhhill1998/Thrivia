//
//  ProfileViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import Foundation

class ProfileViewModel: ObservableObject {
    var user: User
    @Published var username: String
    @Published var email: String
    @Published var password: String
    
    init() {
        user = User(username: "ZigzagZebra24", email: "zigzagzebra24@outlook.com", password: "12345678")
        
        username = user.username
        email = user.email
        password = user.password
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
        password = user.password
    }
}
