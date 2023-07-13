//
//  RegisterScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct RegisterScreen: View {
    
    @State var ready = false
    
    func registerClicked() {
        ready = true
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
                
                InputField(placeholder: "Email") { print($0) }
                    .padding(.bottom)
                
                InputField(placeholder: "Username") { print($0) }
                    .padding(.bottom)
                
                InputField(placeholder: "Password") { print($0) }
                    .padding(.bottom)
                
                InputField(placeholder: "Confirm password") { print($0) }
                    .padding(.bottom)
                
                ActionButton(text: "Register", fontColour: .white, backgroundColour: Color("Green"), action: registerClicked)
                    .padding(.bottom)
                
                
                HStack(spacing: 5.0) {
                    Text("Already have an account?")
                        .font(.custom("Montserrat", size: 15))
                    
                    Button {
                        print("guest")
                    } label: {
                        Text("Login")
                            .font(.custom("Montserrat", size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(Color("DarkGreen"))
                    }
                }
            }
            .navigationDestination(isPresented: $ready) {
                ProgressScreen()
            }
        }
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegisterScreen()
    }
}
