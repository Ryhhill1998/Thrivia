//
//  RegisterScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct RegisterScreen: View {
    
    let updateAuthStatus: (Bool) -> Void
    
    func registerClicked() {
        updateAuthStatus(true)
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 15.0) {
                AppIcon()
                
                InputField(placeholder: "Email") { print($0) }
                
                InputField(placeholder: "Username") { print($0) }
                
                InputField(placeholder: "Password") { print($0) }
                
                InputField(placeholder: "Confirm password") { print($0) }
                
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
