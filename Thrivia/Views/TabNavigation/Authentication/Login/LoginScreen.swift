//
//  LoginScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct LoginScreen: View {
    
    let updateAuthStatus: (Bool) -> Void
    
    func login() {
        updateAuthStatus(true)
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 15.0) {
                AppIcon()
                
                InputField(placeholder: "Email") { print($0) }
                
                InputField(placeholder: "Password") { print($0) }
                
                ActionButton(text: "Login", fontColour: .white, backgroundColour: Color("Green"), action: login)

                
                HStack(spacing: 5.0) {
                    Text("Don't have an account?")
                        .font(.custom("Montserrat", size: 15))
                        .foregroundColor(Color("Black"))
                    
                    NavigationLink {
                        RegisterScreen(updateAuthStatus: updateAuthStatus)
                    } label: {
                        Text("Register")
                            .font(.custom("Montserrat", size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Black"))
                    }
                }
                
                Text("OR")
                    .font(.custom("Montserrat", size: 16))
                    .fontWeight(.regular)
                    .foregroundColor(Color("Black"))
                    .padding(.vertical)
                
                Button {
                    updateAuthStatus(true)
                } label: {
                    Text("Login as guest")
                        .font(.custom("Montserrat", size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(Color("Black"))
                }
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen() { _ in print("auth status updated") }
    }
}
