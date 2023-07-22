//
//  ProfileViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    var profileModel = ProfileModel()
    
    var userId: String?
    
    @Published var username = ""
    @Published var email = ""
    @Published var password = "**********"
    @Published var iconColour = Color("DefaultIconColour")
    
    func getProfileData() {
        guard let userId = userId else { return }
        
        profileModel.getProfileData(userId: userId, usernameSetter: setUsername(username:), emailSetter: setEmail(email:), iconColourSetter: setIconColour(iconColour:))
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
        guard let userId = userId else { return }
        
        profileModel.updateUserUsername(userId: userId, newUsername: newUsername)
        username = newUsername
    }

    func updateUserEmail(newEmail: String) {
        guard let userId = userId else { return }
        
        profileModel.updateUserEmail(userId: userId, newEmail: email)
        email = newEmail
    }

    func updateUserPassword(newPassword: String) {
        guard let userId = userId else { return }
        
        profileModel.updateUserPassword(userId: userId, newPassword: newPassword)
    }
}
