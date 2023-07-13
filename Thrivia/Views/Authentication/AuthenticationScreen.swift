//
//  AuthenticationScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 11/07/2023.
//

import SwiftUI

struct AuthenticationScreen: View {
    
    let updateAuthStatus: (Bool) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(40)
                    
                    NavigationLink {
                        LoginScreen(updateAuthStatus: updateAuthStatus)
                    } label: {
                        ButtonAppearance(text: "Login", fontColour: .white, backgroundColour: Color("Green"))
                            .padding(.bottom)
                    }
                    
                    NavigationLink {
                        RegisterScreen(updateAuthStatus: updateAuthStatus)
                    } label: {
                        ButtonAppearance(text: "Register", fontColour: Color("DarkGreen"), backgroundColour: Color("LightGreen"))
                            .padding(.bottom)
                    }
                    
                    Text("OR")
                        .font(.custom("Montserrat", size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(Color("DarkGreen"))
                        .padding(.bottom)
                    
                    Button {
                        updateAuthStatus(true)
                    } label: {
                        Text("Login as guest")
                            .font(.custom("Montserrat", size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("DarkGreen"))
                            .underline()
                    }
                    .padding(.bottom)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

struct AuthenticationScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationScreen() { _ in print("auth status updated") }
    }
}
