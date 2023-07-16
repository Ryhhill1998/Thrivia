//
//  AuthenticationViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import Foundation
import Firebase

class AuthenticationViewModel: ObservableObject {
    var authenticationModel: AuthenticationModel = AuthenticationModel()
    
    @Published var isAuthenticated: Bool = false
    @Published var authUserId: String?
    
    init() {
        authenticationModel.listenForAuthStateChanges(setAuthState: setAuthState(userId:authState:))
    }
    
    func setAuthState(userId: String?, authState: Bool) {
        authUserId = userId
        isAuthenticated = authState
    }
    
    func loginUser(email: String, password: String) {
        authenticationModel.signInAuthUser(email: email, password: password)

//        isAuthenticated = true
    }
    
    func loginAsGuest() {
        isAuthenticated = true
        print("logging in as guest")
    }
    
    func registerUser(email: String, username: String, password: String) {
        authenticationModel.createAuthUser(email: email, username: username, password: password)
        
//        isAuthenticated = true
    }
    
    func logoutUser() {
        guard let userId = authUserId else { return }
        
        authenticationModel.logoutUser(userId: userId)
//        isAuthenticated = false
//        authUserId = nil
    }
    
    func deleteUserAccount() {
        guard let userId = authUserId else { return }
        
        authenticationModel.deleteUserAccount(userId: userId)
//        isAuthenticated = false
//        authUserId = nil
    }
}
