//
//  ProfileViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    var profileModel = ProfileModel()
    
    var userId: String
    
    @Published var username: String
    @Published var email: String
    @Published var password: String
    @Published var iconColour: Color
    
    init(userId: String) {
        self.userId = userId
        
        username = profileModel.getUserUsername(userId: userId)
        email = profileModel.getUserEmail(userId: userId)
        password = "**********"
        iconColour = profileModel.getUserIconColour(userId: userId)
    }
    
    func updateUserUsername(newUsername: String) {
        profileModel.updateUserUsername(userId: userId, newUsername: newUsername)
        username = newUsername
    }

    func updateUserEmail(newEmail: String) {
        profileModel.updateUserEmail(userId: userId, newEmail: email)
        email = newEmail
    }

    func updateUserPassword(newPassword: String) {
        profileModel.updateUserPassword(userId: userId, newPassword: newPassword)
    }
}
