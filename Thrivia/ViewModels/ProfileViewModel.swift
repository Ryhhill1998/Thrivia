//
//  ProfileViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    private var profileModel = ProfileModel()
    
    private var userId: String?
    
    @Published var username = ""
    @Published var email = ""
    @Published var password = "**********"
    @Published var iconColour = Color("DefaultIconColour")
    @Published var iconColourString = "DefaultIconColour"
    @Published var fetchStatus = "idle"
    @Published var updateSaved = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    @Published var errorExists = false
    
    func setUserId(userId: String) {
        self.userId = userId
    }
    
    func getProfileData() {
        guard let userId = userId else { return }
        
        setFetchStatus(fetchStatus: "pending")
        
        profileModel.getProfileData(userId: userId, usernameSetter: setUsername(username:), emailSetter: setEmail(email:), iconColourSetter: setIconColour(iconColour:), fetchStatusSetter: setFetchStatus(fetchStatus:))
    }
    
    func setFetchStatus(fetchStatus: String) {
        self.fetchStatus = fetchStatus
    }
    
    func resetFetchStatus() {
        setFetchStatus(fetchStatus: "idle")
    }
    
    func setError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        errorExists = true
        setFetchStatus(fetchStatus: "failure")
    }
    
    func resetError() {
        errorTitle = ""
        errorMessage = ""
        errorExists = false
    }
    
    func setIconColourChangeError(message: String) {
        setError(title: "Change Failure", message: message)
    }
    
    func setEmailChangeError(message: String) {
        setError(title: "Change Failure", message: message)
    }
    
    func setUsernameChangeError(message: String) {
        setError(title: "Change Failure", message: message)
    }
    
    func setPasswordChangeError(message: String) {
        setError(title: "Change Failure", message: message)
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
        
        // don't update if it is the same value
        if newUsername == username {
            setUsernameChangeError(message: "Please enter a different username to your current one.")
            return
        }
        
        if newUsername.isEmpty {
            setUsernameChangeError(message: "Username cannot be empty.")
        } else {
            setFetchStatus(fetchStatus: "pending")
            profileModel.updateUserUsername(userId: userId, newUsername: newUsername, errorSetter: setUsernameChangeError(message:), usernameSetter: setUsername(username:))
        }
    }

    func updateUserEmail(newEmail: String) {
        guard let userId = userId else { return }
        
        // don't update if it is the same value
        if newEmail == email {
            setEmailChangeError(message: "Please enter a different email to your current one.")
            return
        }
        
        if newEmail.isEmpty {
            setEmailChangeError(message: "Email cannot be empty.")
        } else {
            setFetchStatus(fetchStatus: "pending")
            profileModel.updateUserEmail(userId: userId, newEmail: newEmail, errorSetter: setEmailChangeError(message:), emailSetter: setEmail(email:))
        }
    }

    func updateUserPassword(newPassword: String, confirmPassword: String) {
        guard let userId = userId else { return }
        
        if newPassword.isEmpty || confirmPassword.isEmpty {
            setPasswordChangeError(message: "Fields cannot be empty.")
        } else if newPassword != confirmPassword {
            setPasswordChangeError(message: "Passwords must match.")
        } else if newPassword.count < 6 {
            setPasswordChangeError(message: "Password must be 6 or more characters.")
        } else {
            setFetchStatus(fetchStatus: "pending")
            profileModel.updateUserPassword(userId: userId, newPassword: newPassword, errorSetter: setPasswordChangeError(message:))
        }
    }
    
    func updateUserIconColour(newIconColour: String) {
        guard let userId = userId else { return }
        
        // don't update if it is the same value
        if newIconColour == iconColourString {
            setIconColourChangeError(message: "Please select a different icon colour to your current one.")
            return
        }
        
        setFetchStatus(fetchStatus: "pending")
        
        profileModel.updateUserIconColour(userId: userId, newIconColour: newIconColour, errorSetter: setIconColourChangeError(message:), iconColourSetter: setIconColour(iconColour:))
    }
}
