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
    
    @Published var authUserId: String?
    
    init() {
        authenticationModel.listenForAuthStateChanges(setAuthState: setAuthState(userId:))
    }
    
    func setAuthState(userId: String?) {
        authUserId = userId
    }
    
    func loginUser(email: String, password: String) {
        authenticationModel.signInAuthUser(email: email, password: password)
    }

    func registerUser(email: String, username: String, password: String) {
        authenticationModel.createAuthUser(email: email, username: username, password: password)
    }
    
    func logoutUser() {
        guard let userId = authUserId else { return }
        
        authenticationModel.logoutUser(userId: userId)
    }
    
    func deleteUserAccount() {
        guard let userId = authUserId else { return }
        
        authenticationModel.deleteUserAccount(userId: userId)
    }
}
