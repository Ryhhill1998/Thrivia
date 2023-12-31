//
//  AuthenticationScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 11/07/2023.
//

import SwiftUI

struct AuthenticationScreen: View {
    
    @EnvironmentObject private var authenticationViewModel: AuthenticationViewModel
    
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
                    
                    VStack(spacing: 15.0) {
                        NavigationLink {
                            LoginScreen()
                                .environmentObject(authenticationViewModel)
                        } label: {
                            ButtonAppearance(text: "Login", fontColour: .white, backgroundColour: Color("Green"))
                        }
                        
                        NavigationLink {
                            RegisterScreen()
                                .environmentObject(authenticationViewModel)
                        } label: {
                            ButtonAppearance(text: "Register", fontColour: Color("DarkGreen"), backgroundColour: Color("LightGreen"))
                        }
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
        AuthenticationScreen()
            .environmentObject(AuthenticationViewModel())
    }
}
