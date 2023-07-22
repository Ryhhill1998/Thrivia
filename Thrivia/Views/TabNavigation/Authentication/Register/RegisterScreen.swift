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
        var colour: Color
        
        if password1.isEmpty || password2.isEmpty {
            colour = .white
        } else if password1 == password2 {
            colour = .green
        } else {
            colour = .red
        }
        
        confirmPasswordBorderColour = colour
    }
    
    func registerClicked() {
        if emailFieldText.isEmpty || usernameFieldField.isEmpty || passwordFieldText.isEmpty || confirmPasswordFieldText.isEmpty { return }
        
        if passwordFieldText != confirmPasswordFieldText { return }
        
        authenticationViewModel.registerUser(email: emailFieldText, username: usernameFieldField, password: passwordFieldText)
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 15.0) {
                AppIcon()
                
                TextField("Email", text: $emailFieldText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.white)
                    .cornerRadius(10)
                    .font(.custom("Montserrat", size: 18))
                    .fontWeight(.medium)
                    .foregroundColor(Color("Black"))
                    .padding(.horizontal)
                
                TextField("Username", text: $usernameFieldField)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.white)
                    .cornerRadius(10)
                    .font(.custom("Montserrat", size: 18))
                    .fontWeight(.medium)
                    .foregroundColor(Color("Black"))
                    .padding(.horizontal)
                
                if !showPassword {
                    HStack {
                        SecureField("Password", text: $passwordFieldText)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .font(.custom("Montserrat", size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(Color("Black"))
                            .onChange(of: passwordFieldText) { comparePasswords(password1: $0, password2: confirmPasswordFieldText) }
                        
                        Button {
                            showPassword = true
                        } label: {
                            Image(systemName: "eye.fill")
                        }
                        .padding(.horizontal, 20)
                        .foregroundColor(Color("Green"))
                        
                    }
                    .background(Color("White"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                } else {
                    HStack {
                        TextField("Password", text: $passwordFieldText)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .font(.custom("Montserrat", size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(Color("Black"))
                            .onChange(of: passwordFieldText) { comparePasswords(password1: $0, password2: confirmPasswordFieldText) }
                        
                        Button {
                            showPassword = false
                        } label: {
                            Image(systemName: "eye.slash.fill")
                        }
                        .padding(.horizontal, 20)
                        .foregroundColor(Color("Green"))
                        
                    }
                    .background(Color("White"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                if !showPassword {
                    SecureField("Confirm password", text: $confirmPasswordFieldText)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .font(.custom("Montserrat", size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(Color("Black"))
                        .background(Color("White"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(confirmPasswordBorderColour, lineWidth: 3)
                        )
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .onChange(of: confirmPasswordFieldText) { comparePasswords(password1: $0, password2: passwordFieldText) }
                } else {
                    TextField("Confirm password", text: $confirmPasswordFieldText)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .font(.custom("Montserrat", size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(Color("Black"))
                        .background(Color("White"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(confirmPasswordBorderColour, lineWidth: 3)
                        )
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .onChange(of: confirmPasswordFieldText) { comparePasswords(password1: $0, password2: passwordFieldText) }
                }
                
                if authenticationViewModel.fetchingAuthStatus {
                    ProgressButton(text: "Registering", foregroundColour: Color("White"), backgroundColour: Color("Green"))
                } else {
                    ActionButton(text: "Register", fontColour: .white, backgroundColour: Color("Green"), action: registerClicked)
                }
                
                HStack(spacing: 5.0) {
                    Text("Already have an account?")
                        .font(.custom("Montserrat", size: 15))
                        .foregroundColor(Color("Black"))
                    
                    NavigationLink {
                        LoginScreen()
                    } label: {
                        Text("Login")
                            .font(.custom("Montserrat", size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(Color("Black"))
                    }
                }
                .alert("Register failure", isPresented: $authenticationViewModel.errorExists, actions: {
                    Button("Okay", role: .cancel) {}
                }, message: {
                    Text(authenticationViewModel.error ?? "none")
                })
            }
        }
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegisterScreen()
            .environmentObject(AuthenticationViewModel())
    }
}
