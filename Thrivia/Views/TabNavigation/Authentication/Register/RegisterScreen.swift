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
    
    let updateAuthStatus: (Bool) -> Void
    @State var emailFieldText: String = ""
    @State var usernameFieldField: String = ""
    @State var passwordFieldText: String = ""
    @State var confirmPasswordFieldText: String = ""
    
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
                
                TextField("Password", text: $passwordFieldText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.white)
                    .cornerRadius(10)
                    .font(.custom("Montserrat", size: 18))
                    .fontWeight(.medium)
                    .foregroundColor(Color("Black"))
                    .padding(.horizontal)
                
                TextField("Confirm password", text: $confirmPasswordFieldText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.white)
                    .cornerRadius(10)
                    .font(.custom("Montserrat", size: 18))
                    .fontWeight(.medium)
                    .foregroundColor(Color("Black"))
                    .padding(.horizontal)
                
                ActionButton(text: "Register", fontColour: .white, backgroundColour: Color("Green"), action: registerClicked)
                
                
                HStack(spacing: 5.0) {
                    Text("Already have an account?")
                        .font(.custom("Montserrat", size: 15))
                        .foregroundColor(Color("Black"))
                    
                    NavigationLink {
                        LoginScreen(updateAuthStatus: updateAuthStatus)
                    } label: {
                        Text("Login")
                            .font(.custom("Montserrat", size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(Color("Black"))
                    }
                }
            }
        }
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegisterScreen() { _ in print("auth status updated") }
    }
}
