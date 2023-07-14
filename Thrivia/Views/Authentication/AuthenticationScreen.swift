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
                    
                    Spacer()
                    
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
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .accentColor(Color("Black"))
    }
}

struct AuthenticationScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationScreen() { _ in print("auth status updated") }
    }
}
