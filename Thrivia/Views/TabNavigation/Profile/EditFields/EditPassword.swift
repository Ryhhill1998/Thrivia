//
//  EditPassword.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 22/07/2023.
//

import SwiftUI

struct EditPassword: View {
    
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var newPassword = ""
    @State var confirmPassword = ""
    
    @State var showPassword = false
    
    func savePassword() {
        profileViewModel.updateUserPassword(newPassword: newPassword, confirmPassword: confirmPassword)
    }
    
    func backPressed() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 15.0) {
                VStack(spacing: 15.0) {
                    HStack {
                        FieldLabel(label: "New password")
                        
                        if !showPassword {
                            SecureField("Password", text: $newPassword)
                                .multilineTextAlignment(.trailing)
                                .font(.custom("Montserrat", size: 15))
                                .fontWeight(.medium)
                                .foregroundColor(Color("Black"))
                            
                            Button {
                                showPassword = true
                            } label: {
                                Image(systemName: "eye.fill")
                            }
                            .foregroundColor(Color("Green"))
                        } else {
                            TextField("Password", text: $newPassword)
                                .multilineTextAlignment(.trailing)
                                .font(.custom("Montserrat", size: 15))
                                .fontWeight(.medium)
                                .foregroundColor(Color("Black"))
                            
                            Button {
                                showPassword = false
                            } label: {
                                Image(systemName: "eye.slash.fill")
                            }
                            .foregroundColor(Color("Green"))
                        }
                    }
                    
                    LineSeparator()
                    
                    HStack {
                        FieldLabel(label: "Confirm password")
                        
                        if !showPassword {
                            SecureField("Confirm password", text: $confirmPassword)
                                .multilineTextAlignment(.trailing)
                                .font(.custom("Montserrat", size: 15))
                                .fontWeight(.medium)
                                .foregroundColor(Color("Black"))
                        } else {
                            TextField("Confirm password", text: $confirmPassword)
                                .multilineTextAlignment(.trailing)
                                .font(.custom("Montserrat", size: 15))
                                .fontWeight(.medium)
                                .foregroundColor(Color("Black"))
                        }
                    }
                }
                .padding()
                .background(Color("White"))
                .cornerRadius(10)
                .padding(.horizontal)
                
                SaveButton(fetchStatus: profileViewModel.fetchStatus, action: savePassword)
                
                Spacer()
            }
            .padding(.top, 20.0)
            
            InfoAlert(title: profileViewModel.errorTitle, message: profileViewModel.errorMessage, presentationBind: $profileViewModel.errorExists)
        }
        .onDisappear() {
            profileViewModel.resetFetchStatus()
            profileViewModel.resetError()
        }
        .onChange(of: newPassword, perform: { newValue in
            if !newValue.isEmpty {
                profileViewModel.resetFetchStatus()
            }
        })
        .onChange(of: confirmPassword, perform: { newValue in
            if !newValue.isEmpty {
                profileViewModel.resetFetchStatus()
            }
        })
        .onChange(of: profileViewModel.fetchStatus, perform: { newValue in
            if newValue == "success" {
                newPassword = ""
                confirmPassword = ""
            }
        })
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    backPressed()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("Black"))
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Edit Password")
                    .bold()
            }
        }
        .toolbar(.visible, for: .navigationBar)
    }
}

struct EditPassword_Previews: PreviewProvider {
    static var previews: some View {
        EditPassword()
            .environmentObject(ProfileViewModel())
    }
}
