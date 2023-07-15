//
//  ProfileScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct ProfileScreen: View {
    
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    let updateAuthStatus: (Bool) -> Void
    
    func logOutUser() {
        print("logging out user")
        updateAuthStatus(false)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                VStack(spacing: 25.0) {
                    UserIconWithOverlay(size: "xLarge", borderColour: .white, backgroundColour: .purple, name: profileViewModel.username, overlayImage: Image(systemName: "square.and.pencil"), overlayColour: Color("LightGreen"))
                    
                    VStack(spacing: 15.0) {
                        AccountDetailField(fieldName: "Username", fieldValue: profileViewModel.username)
                        
                        LineSeparator()
                        
                        AccountDetailField(fieldName: "Email", fieldValue: profileViewModel.email)
                        
                        LineSeparator()
                        
                        AccountDetailField(fieldName: "Password", fieldValue: profileViewModel.password)
                    }
                    .padding()
                    .background(Color("White"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    VStack(spacing: 15.0) {
                        ActionButton(text: "Logout", fontColour: Color("White"), backgroundColour: Color("Green")) {
                            logOutUser()
                        }
                        
                        ActionButton(text: "Delete account", fontColour: Color("DarkGreen"), backgroundColour: Color("LightGreen")) {
                            print("deleting user account")
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen() { _ in print("auth status updated") }
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
