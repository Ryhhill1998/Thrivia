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
    
    @Published var username = ""
    @Published var email = ""
    @Published var password = "**********"
    @Published var iconColour = Color("DefaultIconColour")
    
    init(userId: String) {
        self.userId = userId
        
        if username.isEmpty && email.isEmpty && iconColour == Color("DefaultIconColour") {
            profileModel.getProfileData(userId: userId, usernameSetter: setUsername(username:), emailSetter: setEmail(email:), iconColourSetter: setIconColour(iconColour:))
        }
    }
    
    func setUsername(username: String) {
        self.username = username
    }
    
    func setEmail(email: String) {
        self.email = email
    }
    
    func setIconColour(iconColour: String) {
        self.iconColour = Color(iconColour)
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
