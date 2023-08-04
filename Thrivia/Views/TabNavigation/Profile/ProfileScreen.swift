//
//  ProfileScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct ProfileScreen: View {
    
    @EnvironmentObject private var authenticationViewModel: AuthenticationViewModel
    @StateObject var profileViewModel = ProfileViewModel()
    
    let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    @State var showDeleteAccountAlert = false
    
    func logoutUser() {
        authenticationViewModel.logoutUser()
    }
    
    func deleteUserAccount() {
        authenticationViewModel.deleteUserAccount()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                VStack(spacing: 25.0) {
                    ZStack {
                        UserIcon(size: "xLarge", borderColour: .white, backgroundColour: profileViewModel.iconColour, name: profileViewModel.username)
                        EditIconColourLink(currentColour: profileViewModel.iconColourString)
                    }
                    
                    VStack(spacing: 15.0) {
                        EditFieldLink(fieldType: "username", currentValue: profileViewModel.username)
                        
                        LineSeparator()
                        
                        EditFieldLink(fieldType: "email", currentValue: profileViewModel.email)
                        
                        LineSeparator()
                        
                        NavigationLink {
                            EditPassword()
                        } label: {
                            AccountDetailField(fieldName: "Password", fieldValue: profileViewModel.password)
                        }
                    }
                    .padding()
                    .background(Color("White"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    VStack(spacing: 15.0) {
                        ActionButton(text: "Logout", fontColour: Color("White"), backgroundColour: Color("Green")) {
                            logoutUser()
                        }
                        
                        ActionButton(text: "Delete account", fontColour: Color("DarkGreen"), backgroundColour: Color("LightGreen")) {
                            showDeleteAccountAlert = true
                        }
                        
                        InfoAlert(title: "Delete failure", message: authenticationViewModel.error, presentationBind: $authenticationViewModel.errorExists)
                        
                        ConfirmationAlert(title: "Delete account", message: "Are you sure you want to delete your account", confirmButtonText: "Delete", presentationBind: $showDeleteAccountAlert, action: deleteUserAccount)
                    }
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .environmentObject(profileViewModel)
        .accentColor(Color("Black"))
        .onAppear() {
            profileViewModel.setUserId(userId: userId)
            profileViewModel.getProfileData()
        }
    }
}

struct EditFieldLink: View {
    
    let fieldType: String
    let currentValue: String
    
    var body: some View {
        NavigationLink {
            EditField(fieldType: fieldType, currentFieldValue: currentValue)
        } label: {
            AccountDetailField(fieldName: fieldType.capitalized, fieldValue: currentValue)
        }
    }
}

struct EditIconColourLink: View {
    
    let currentColour: String
    
    var body: some View {
        NavigationLink {
            EditIconColour(selectedColour: currentColour)
        } label: {
            Image(systemName: "square.and.pencil")
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .background(Color("LightGreen"))
                .cornerRadius(15)
                .overlay {
                    Circle()
                        .stroke(.white, lineWidth: 4)
                }
        }
        .offset(x: 35.35, y: 35.35)
    }
}
