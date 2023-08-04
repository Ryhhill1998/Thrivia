//
//  RegisterScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI
import FirebaseAuth

struct RegisterScreen: View {
    @EnvironmentObject private var authenticationViewModel: AuthenticationViewModel
    
    @State var emailFieldText: String = ""
    @State var usernameFieldField: String = ""
    @State var passwordFieldText: String = ""
    @State var confirmPasswordFieldText: String = ""
    @State var showPassword = false
    @State var confirmPasswordBorderColour = Color.white
    
    func comparePasswords(password1: String, password2: String) {
        confirmPasswordBorderColour = authenticationViewModel.comparePasswords(password1: password1, password2: password2)
    }
    
    func registerClicked() {
        authenticationViewModel.registerUser(email: emailFieldText, username: usernameFieldField, password: passwordFieldText, confirmPassword: confirmPasswordFieldText)
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 15.0) {
                AppIcon()
                
                FormField(fieldName: "Email", fieldText: $emailFieldText)
                FormField(fieldName: "Username", fieldText: $usernameFieldField)
                
                if !showPassword {
                    SecurePasswordField(passwordFieldText: $passwordFieldText) { showPassword = true }
                    SecureConfirmPasswordField(confirmPasswordFieldText: $confirmPasswordFieldText, borderColour: confirmPasswordBorderColour)
                        .onChange(of: confirmPasswordFieldText) { comparePasswords(password1: $0, password2: passwordFieldText) }
                } else {
                    PasswordField(passwordFieldText: $passwordFieldText) { showPassword = false }
                    ConfirmPasswordField(confirmPasswordFieldText: $confirmPasswordFieldText, borderColour: confirmPasswordBorderColour)
                        .onChange(of: confirmPasswordFieldText) { comparePasswords(password1: $0, password2: passwordFieldText) }
                }
                
                if authenticationViewModel.fetchingAuthStatus {
                    ProgressButton(text: "Registering", foregroundColour: Color("White"), backgroundColour: Color("Green"))
                } else {
                    ActionButton(text: "Register", fontColour: .white, backgroundColour: Color("Green"), action: registerClicked)
                }
                
                HStack(spacing: 5.0) {
                    LinkText(text: "Already have an account?")
                    
                    NavigationLink {
                        LoginScreen()
                            .environmentObject(authenticationViewModel)
                    } label: {
                        LinkButtonText(text: "Login")
                    }
                }
            }
            
            InfoAlert(title: "Register failure", message: authenticationViewModel.error, presentationBind: $authenticationViewModel.errorExists)
        }
        .onDisappear() {
            emailFieldText = ""
            usernameFieldField = ""
            passwordFieldText = ""
            confirmPasswordFieldText = ""
        }
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegisterScreen()
            .environmentObject(AuthenticationViewModel())
    }
}
