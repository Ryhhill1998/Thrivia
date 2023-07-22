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
    @Published var fetchingData = false
    @Published var error = ""
    @Published var errorExists = false
    
    func getProfileData() {
        guard let userId = userId else { return }
        
        setFetchingData(fetchingData: true)
        
        profileModel.getProfileData(userId: userId, usernameSetter: setUsername(username:), emailSetter: setEmail(email:), iconColourSetter: setIconColour(iconColour:), fetchStatusSetter: setFetchingData(fetchingData:), errorSetter: setError(error:))
    }
    
    func setFetchingData(fetchingData: Bool) {
        self.fetchingData = fetchingData
    }
    
    func setError(error: String) {
        self.error = error
        errorExists = true
        setFetchingData(fetchingData: false)
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
        
        setFetchingData(fetchingData: true)
        
        profileModel.updateUserUsername(userId: userId, newUsername: newUsername, fetchStatusSetter: setFetchingData(fetchingData:), errorSetter: setError(error:), usernameSetter: setUsername(username:))
    }

    func updateUserEmail(newEmail: String) {
        guard let userId = userId else { return }
        
        setFetchingData(fetchingData: true)
        
        profileModel.updateUserEmail(userId: userId, newEmail: newEmail, fetchStatusSetter: setFetchingData(fetchingData:), errorSetter: setError(error:), emailSetter: setEmail(email:))
    }

    func updateUserPassword(newPassword: String) {
        guard let userId = userId else { return }
        
        setFetchingData(fetchingData: true)
        
        profileModel.updateUserPassword(userId: userId, newPassword: newPassword, fetchStatusSetter: setFetchingData(fetchingData:), errorSetter: setError(error:))
    }
}
