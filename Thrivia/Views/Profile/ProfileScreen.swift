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
    
    @State var showDeleteAccountAlert = false
    
    func logOutUser() {
        profileViewModel.logOutUser()
        updateAuthStatus(false)
    }
    
    func deleteUserAccount() {
        profileViewModel.deleteUserAccount()
        updateAuthStatus(false)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                VStack(spacing: 25.0) {
                    UserIconWithOverlay(size: "xLarge", borderColour: .white, backgroundColour: profileViewModel.iconColour, name: profileViewModel.username, overlayImage: Image(systemName: "square.and.pencil"), overlayColour: Color("LightGreen"))
                    
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
                            showDeleteAccountAlert = true
                        }
                        .alert("Delete Account", isPresented: $showDeleteAccountAlert, actions: {
                            Button("Delete", role: .destructive) {
                                deleteUserAccount()
                            }
                            
                            Button("Cancel", role: .cancel) {}
                        }, message: {
                            Text("Are you sure you want to delete your account")
                        })
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
