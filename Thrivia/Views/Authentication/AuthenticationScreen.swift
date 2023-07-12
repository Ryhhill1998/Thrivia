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
                
                ActionButton(text: "Login", fontColour: .white, backgroundColour: Color("Green"))
                    .padding(.bottom)
                
                ActionButton(text: "Register", fontColour: Color("DarkGreen"), backgroundColour: Color("LightGreen"))
                    .padding(.bottom)
                
                Text("OR")
                    .font(.custom("Montserrat", size: 18))
                    .fontWeight(.medium)
                    .foregroundColor(Color("DarkGreen"))
                    .padding(.bottom)
                
                Button {
                    print("guest")
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
}

struct AuthenticationScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationScreen()
    }
}
