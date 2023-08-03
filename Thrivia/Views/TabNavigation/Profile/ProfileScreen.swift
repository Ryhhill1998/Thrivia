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
                        
                        NavigationLink {
                            EditIconColour(selectedColour: profileViewModel.iconColourString)
                                .environmentObject(profileViewModel)
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
                    
                    VStack(spacing: 15.0) {
                        NavigationLink {
                            EditField(fieldType: "username", currentFieldValue: profileViewModel.username)
                                .environmentObject(profileViewModel)
                        } label: {
                            AccountDetailField(fieldName: "Username", fieldValue: profileViewModel.username)
                        }

                        
                        LineSeparator()
                        
                        NavigationLink {
                            EditField(fieldType: "email", currentFieldValue: profileViewModel.email)
                                .environmentObject(profileViewModel)
                        } label: {
                            AccountDetailField(fieldName: "Email", fieldValue: profileViewModel.email)
                        }
                        
                        LineSeparator()
                        
                        NavigationLink {
                            EditPassword()
                                .environmentObject(profileViewModel)
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
                        .alert("Delete Account", isPresented: $showDeleteAccountAlert, actions: {
                            Button("Delete", role: .destructive) {
                                deleteUserAccount()
                            }
                            
                            Button("Cancel", role: .cancel) {}
                        }, message: {
                            Text("Are you sure you want to delete your account")
                        })
                        .alert("Delete failure", isPresented: $authenticationViewModel.errorExists, actions: {
                            Button("OK", role: .cancel) {}
                        }, message: {
                            Text(authenticationViewModel.error)
                        })
                    }
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .accentColor(Color("Black"))
        .onAppear() {
            profileViewModel.setUserId(userId: userId)
            profileViewModel.getProfileData()
        }
    }
}
