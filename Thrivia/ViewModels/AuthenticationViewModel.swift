//
//  AuthenticationViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI
import Firebase

class AuthenticationViewModel: ObservableObject {
    var authenticationModel: AuthenticationModel = AuthenticationModel()
    
    @Published var authUserId: String?
    @Published var fetchingAuthStatus = false
    @Published var error: String = ""
    @Published var errorExists = false
    @Published var activityStatus = false
    
    init() {
        authenticationModel.listenForAuthStateChanges(setAuthState: setAuthState(userId:))
        
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { _ in
            if let userId = self.authUserId {
                self.authenticationModel.updateUserActivityStatusInDB(userId: userId, activityStatus: false)
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
            if let userId = self.authUserId {
                self.authenticationModel.loadSavedActivityStatus(userId: userId)
            }
        }
    }
    
    func setAuthState(userId: String?) {
        authUserId = userId
        setFetchingStatus(fetchingStatus: false)
        getActivityStatus()
    }
    
    func setFetchingStatus(fetchingStatus: Bool) {
        fetchingAuthStatus = fetchingStatus
    }
    
    func setError(error: String) {
        self.error = error
        errorExists = true
        setFetchingStatus(fetchingStatus: false)
    }
    
    func getActivityStatus() {
        if let userId = authUserId {
            authenticationModel.getUserActivityStatus(userId: userId, activityStatusSetter: setActivityStatus(activityStatus:))
        }
    }
    
    func setActivityStatus(activityStatus: Bool) {
        self.activityStatus = activityStatus
    }
    
    func updateUserActivityStatus(activityStatus: Bool) {
        if let userId = authUserId {
            authenticationModel.saveUserActivityStatus(userId: userId, activityStatus: activityStatus)
        }
    }
    
    func loginUser(email: String, password: String) {
        if email.isEmpty || password.isEmpty {
            setError(error: "All fields must be completed.")
        } else if password.count < 6 {
            setError(error: "All passwords must contain 6 or more characters.")
        } else {
            setFetchingStatus(fetchingStatus: true)
            authenticationModel.LoginAuthUser(email: email, password: password, errorSetter: setError(error:))
        }
    }
    
    func registerUser(email: String, username: String, password: String, confirmPassword: String) {
        if email.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            setError(error: "All fields must be completed.")
        } else if password != confirmPassword {
            setError(error: "Passwords do not match.")
        } else if password.count < 6 {
            setError(error: "All passwords must contain 6 or more characters.")
        } else {
            setFetchingStatus(fetchingStatus: true)
            authenticationModel.registerUser(email: email, username: username, password: password, errorSetter: setError(error:))
        }
    }
    
    func comparePasswords(password1: String, password2: String) -> Color {
        var colour: Color
        
        if password1.isEmpty || password2.isEmpty {
            colour = .white
        } else if password1 == password2 {
            colour = .green
        } else {
            colour = .red
        }
        
        return colour
    }
    
    func logoutUser() {
        guard let userId = authUserId else { return }
        
        authenticationModel.logoutUser(userId: userId, errorSetter: setError(error:))
    }
    
    func deleteUserAccount() {
        guard let userId = authUserId else { return }
        
        authenticationModel.deleteUserAccount(userId: userId, errorSetter: setError(error:))
    }
}
