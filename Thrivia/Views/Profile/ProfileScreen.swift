//
//  ProfileScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct ProfileScreen: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                VStack(spacing: 30.0) {
                    UserIconWithOverlay(size: "xLarge", borderColour: .white, backgroundColour: .purple, name: "ZigzagZebra24", overlayImage: Image(systemName: "plus"), overlayColour: Color("LightGreen"))
                    
                    VStack(spacing: 15.0) {
                        AccountDetailField(fieldName: "Username", fieldValue: "ZigzagZebra24")
                        
                        LineSeparator()
                        
                        AccountDetailField(fieldName: "Email", fieldValue: "zigzagzebra24@outlook.com")
                        
                        LineSeparator()
                        
                        AccountDetailField(fieldName: "Password", fieldValue: "**********")
                    }
                    .padding()
                    .background(Color("White"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    VStack(spacing: 15.0) {
                        ActionButton(text: "Logout", fontColour: Color("White"), backgroundColour: Color("Green")) {
                            print("logging out user")
                        }
                        
                        ActionButton(text: "Delete account", fontColour: Color("DarkGreen"), backgroundColour: Color("LightGreen")) {
                            print("deleting user account")
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 20.0)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}

struct AccountDetailField: View {
    
    let fieldName: String
    let fieldValue: String
    
    var body: some View {
        HStack {
            Text(fieldName)
                .foregroundColor(Color("Black"))
                .font(.custom("Montserrat", size: 18))
                .fontWeight(.semibold)
            
            Text(fieldValue)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(Color("Black"))
                .font(.custom("Montserrat", size: 15))
            
            Button {
                print("edit mode")
            } label: {
                Image(systemName: "chevron.right")
            }
        }
    }
}
