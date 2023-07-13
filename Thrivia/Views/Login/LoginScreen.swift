//
//  LoginScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct LoginScreen: View {
    
    let updateAuthStatus: (Bool) -> Void
    
    func loginClicked() {
        updateAuthStatus(true)
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack {
                Image("AppIconNoBg")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120.0, height: 120.0)
                    .padding(.bottom)
                
                InputField(placeholder: "Email or Username") { print($0) }
                    .padding(.bottom)
                
                InputField(placeholder: "Password") { print($0) }
                    .padding(.bottom)
                
                ActionButton(text: "Login", fontColour: .white, backgroundColour: Color("Green"), action: loginClicked)
                    .padding(.bottom)

                
                HStack(spacing: 5.0) {
                    Text("Don't have an account?")
                        .font(.custom("Montserrat", size: 15))
                    
                    NavigationLink {
                        RegisterScreen(updateAuthStatus: updateAuthStatus)
                    } label: {
                        Text("Register")
                            .font(.custom("Montserrat", size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(Color("DarkGreen"))
                    }

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
