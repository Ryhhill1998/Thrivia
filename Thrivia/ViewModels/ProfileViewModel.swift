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
    @Published var iconColourString = "DefaultIconColour"
    @Published var fetchStatus = "idle"
    @Published var updateSaved = false
    @Published var error = ""
    @Published var errorExists = false
    
    func getProfileData() {
        guard let userId = userId else { return }
        
        setFetchStatus(fetchStatus: "pending")
        
        profileModel.getProfileData(userId: userId, usernameSetter: setUsername(username:), emailSetter: setEmail(email:), iconColourSetter: setIconColour(iconColour:), errorSetter: setError(error:), fetchStatusSetter: setFetchStatus(fetchStatus:))
    }
    
    func setFetchStatus(fetchStatus: String) {
        self.fetchStatus = fetchStatus
    }
    
    func setError(error: String) {
        self.error = error
        errorExists = true
        setFetchStatus(fetchStatus: "failure")
    }
    
    func setUsername(username: String) {
        self.username = username
        setFetchStatus(fetchStatus: "success")
    }
    
    func setEmail(email: String) {
        self.email = email
        setFetchStatus(fetchStatus: "success")
    }
    
    func setIconColour(iconColour: String) {
        self.iconColour = Color(iconColour)
        iconColourString = iconColour
        setFetchStatus(fetchStatus: "success")
    }
    
    func updateUserUsername(newUsername: String) {
        guard let userId = userId else { return }
        
        setFetchStatus(fetchStatus: "pending")
        
        profileModel.updateUserUsername(userId: userId, newUsername: newUsername, errorSetter: setError(error:), usernameSetter: setUsername(username:))
    }

    func updateUserEmail(newEmail: String) {
        guard let userId = userId else { return }
        
        setFetchStatus(fetchStatus: "pending")
        
        profileModel.updateUserEmail(userId: userId, newEmail: newEmail, errorSetter: setError(error:), emailSetter: setEmail(email:))
    }

    func updateUserPassword(newPassword: String) {
        guard let userId = userId else { return }
        
        setFetchStatus(fetchStatus: "pending")
        
        profileModel.updateUserPassword(userId: userId, newPassword: newPassword, errorSetter: setError(error:))
    }
    
    func updateUserIconColour(newIconColour: String) {
        guard let userId = userId else { return }
        
        setFetchStatus(fetchStatus: "pending")
        
        profileModel.updateUserIconColour(userId: userId, newIconColour: newIconColour, errorSetter: setError(error:), iconColourSetter: setIconColour(iconColour:))
    }
}
