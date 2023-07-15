//
//  ProfileViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user = User(username: "ZigzagZebra24", email: "zigzagzebra24@outlook.com", password: "12345678")
    
    func updateUserUsername(newUsername: String) {
        user.updateUsername(newUsername: newUsername)
    }
    
    func updateUserEmail(newEmail: String) {
        user.updateEmail(newEmail: newEmail)
    }
    
    func updateUserPassword(newPassword: String) {
        user.updatePassword(newPassword: newPassword)
    }
}
