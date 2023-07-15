//
//  AuthenticationViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    var userModel: UserModel = UserModel()
    
    @Published var isAuthenticated: Bool = false
    @Published var authUser: User?
    
    func loginUser(email: String, password: String) {
        let user = userModel.loginUser(email: email, password: password)
        
        guard let unwrappedUser = user else { return }
        
        isAuthenticated = true
        authUser = unwrappedUser
    }
    
    func loginAsGuest() {
        isAuthenticated = true
        print("logging in as guest")
    }
    
    func registerUser(email: String, username: String, password: String, confirmPassword: String) {
        let user = userModel.registerUser(email: email, username: username, password: password, confirmPassword: confirmPassword)
        
        guard let unwrappedUser = user else { return }
        
        isAuthenticated = true
        authUser = unwrappedUser
    }
}
