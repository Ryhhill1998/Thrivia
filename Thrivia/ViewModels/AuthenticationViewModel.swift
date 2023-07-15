//
//  AuthenticationViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    var userModel: UserModel = UserModel()
    
    func loginUser(email: String, password: String) {
        let authUser = userModel.loginUser(email: email, password: password)
        
        if authUser != nil {
            isAuthenticated = true
        }
    }
    
    func loginAsGuest() {
        isAuthenticated = true
        print("logging in as guest")
    }
    
    func registerUser(email: String, username: String, password: String, confirmPassword: String) {
        let authUser = userModel.registerUser(email: email, username: username, password: password, confirmPassword: confirmPassword)
        
        if authUser != nil {
            isAuthenticated = true
        }
    }
}
