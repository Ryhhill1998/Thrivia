//
//  LoginScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI
import Firebase

struct LoginScreen: View {
    @EnvironmentObject private var authenticationViewModel: AuthenticationViewModel
    
    @State var emailFieldText: String = ""
    @State var passwordFieldText: String = ""
    @State var showPassword = false
    
    func login() {
        authenticationViewModel.loginUser(email: emailFieldText, password: passwordFieldText)
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 15.0) {
                AppIcon()
                
                FormField(fieldName: "Email", fieldText: $emailFieldText)
                
                if !showPassword {
                    SecurePasswordField(passwordFieldText: $passwordFieldText) {
                        showPassword = true
                    }
                } else {
                    PasswordField(passwordFieldText: $passwordFieldText) {
                        showPassword = false
                    }
                }
                
                if authenticationViewModel.fetchingAuthStatus {
                    ProgressButton(text: "Logging in", foregroundColour: Color("White"), backgroundColour: Color("Green"))
                } else {
                    ActionButton(text: "Login", fontColour: .white, backgroundColour: Color("Green"), action: login)
                }
                
                HStack(spacing: 5.0) {
                    LinkText(text: "Don't have an account?")
                    
                    NavigationLink {
                        RegisterScreen()
                            .environmentObject(authenticationViewModel)
                    } label: {
                        LinkButtonText(text: "Register")
                    }
                }
                
            }
        }
        .alert("Login failure", isPresented: $authenticationViewModel.errorExists, actions: {
            Button("Okay", role: .cancel) {}
        }, message: {
            Text(authenticationViewModel.error)
        })
        .onDisappear() {
            emailFieldText = ""
            passwordFieldText = ""
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
            .environmentObject(AuthenticationViewModel())
    }
}
