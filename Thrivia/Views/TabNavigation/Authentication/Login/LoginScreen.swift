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
    
    func login() {
        if emailFieldText.isEmpty || passwordFieldText.isEmpty { return }
        
        authenticationViewModel.loginUser(email: emailFieldText, password: passwordFieldText)
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
                
                TextField("Password", text: $passwordFieldText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.white)
                    .cornerRadius(10)
                    .font(.custom("Montserrat", size: 18))
                    .fontWeight(.medium)
                    .foregroundColor(Color("Black"))
                    .padding(.horizontal)
                
                ActionButton(text: "Login", fontColour: .white, backgroundColour: Color("Green"), action: login)

                
                HStack(spacing: 5.0) {
                    Text("Don't have an account?")
                        .font(.custom("Montserrat", size: 15))
                        .foregroundColor(Color("Black"))
                    
                    NavigationLink {
                        RegisterScreen()
                            .environmentObject(authenticationViewModel)
                    } label: {
                        Text("Register")
                            .font(.custom("Montserrat", size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Black"))
                    }
                }
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
