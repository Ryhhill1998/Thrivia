//
//  AuthenticationScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 11/07/2023.
//

import SwiftUI

struct AuthenticationScreen: View {
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(40)
                
                ActionButtonView(text: "Login", fontColour: .white, backgroundColour: Color("Green"))
                    .padding(.bottom, 20.0)
                
                ActionButtonView(text: "Register", fontColour: Color("DarkGreen"), backgroundColour: Color("LightGreen"))
                    .padding(.bottom, 20.0)
                
                Text("OR")
                    .font(.system(size: 17))
                    .fontWeight(.regular)
                    .foregroundColor(Color("DarkGreen"))
                    .padding(.bottom, 20.0)
                
                Button {
                    print("guest")
                } label: {
                    Text("Login as guest")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color("DarkGreen"))
                        .underline()
                }
                .padding(.bottom, 20.0)
            }
        }
    }
}

struct AuthenticationScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationScreen()
    }
}

struct ActionButtonView: View {
    
    let text: String
    let fontColour: Color
    let backgroundColour: Color
    
    var body: some View {
        Button {
            print("logging in")
        } label: {
            Text(text)
                .font(.system(size: 25))
                .padding()
                .bold()
        }
        .foregroundColor(fontColour)
        .frame(maxWidth: .infinity)
        .background(backgroundColour)
        .cornerRadius(10)
        .padding(.horizontal, 20.0)
    }
}
