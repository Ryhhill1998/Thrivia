//
//  AuthenticationViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    var authenticationModel: AuthenticationModel = AuthenticationModel()
    
    @Published var isAuthenticated: Bool = false
    @Published var authUserId: String?
    
    func loginUser(email: String, password: String) {
        let userId = authenticationModel.loginUser(email: email, password: password)
        
        guard let unwrappedUserId = userId else { return }
        
        isAuthenticated = true
        authUserId = unwrappedUserId
    }
    
    func loginAsGuest() {
        isAuthenticated = true
        print("logging in as guest")
    }
    
    func registerUser(email: String, username: String, password: String, confirmPassword: String) {
        let userId = authenticationModel.registerUser(email: email, username: username, password: password, confirmPassword: confirmPassword)
        
        guard let unwrappedUserId = userId else { return }
        
        isAuthenticated = true
        authUserId = unwrappedUserId
    }
    
    func logoutUser() {
        guard let userId = authUserId else { return }
        
        authenticationModel.logoutUser(userId: userId)
        isAuthenticated = false
        authUserId = nil
    }
    
    func deleteUserAccount() {
        guard let userId = authUserId else { return }
        
        authenticationModel.deleteUserAccount(userId: userId)
        isAuthenticated = false
        authUserId = nil
    }
}
