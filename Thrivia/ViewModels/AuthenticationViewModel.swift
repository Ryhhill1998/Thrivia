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
    @Published var fetchingAuthStatus = false
    @Published var error: String = ""
    @Published var errorExists = false
    
    init() {
        authenticationModel.listenForAuthStateChanges(setAuthState: setAuthState(userId:))
    }
    
    func setAuthState(userId: String?) {
        authUserId = userId
        setFetchingStatus(fetchingStatus: false)
    }
    
    func setFetchingStatus(fetchingStatus: Bool) {
        fetchingAuthStatus = fetchingStatus
    }
    
    func setError(error: String) {
        self.error = error
        errorExists = true
        setFetchingStatus(fetchingStatus: false)
    }
    
    func loginUser(email: String, password: String) {
        setFetchingStatus(fetchingStatus: true)
        authenticationModel.LoginAuthUser(email: email, password: password, errorSetter: setError(error:))
    }

    func registerUser(email: String, username: String, password: String) {
        setFetchingStatus(fetchingStatus: true)
        authenticationModel.registerUser(email: email, username: username, password: password, errorSetter: setError(error:))
    }
    
    func logoutUser() {
        guard let userId = authUserId else { return }
        
        authenticationModel.logoutUser(userId: userId, errorSetter: setError(error:))
    }
    
    func deleteUserAccount() {
        guard let userId = authUserId else { return }
        
        authenticationModel.deleteUserAccount(userId: userId)
    }
}
