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
        newPassword = ""
        confirmPassword = ""
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
                        Text("New password")
                            .foregroundColor(Color("Black"))
                            .font(.custom("Montserrat", size: 15))
                            .fontWeight(.semibold)
                        
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
                        Text("Confirm password")
                            .foregroundColor(Color("Black"))
                            .font(.custom("Montserrat", size: 15))
                            .fontWeight(.semibold)
                        
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
                
                if profileViewModel.fetchStatus == "pending" {
                    ProgressButton(text: "Saving", foregroundColour: Color("White"), backgroundColour: Color("Green"))
                } else if profileViewModel.fetchStatus == "idle" || profileViewModel.fetchStatus == "failure" {
                    ActionButton(text: "Save", fontColour: Color("White"), backgroundColour: Color("Green"), action: savePassword)
                } else {
                    HStack(spacing: 5.0) {
                        Text("Saved")
                            .font(.custom("Montserrat", size: 20))
                            .foregroundColor(Color("White"))
                            .bold()
                        
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(Color("White"))
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(Color("Green"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.top, 20.0)
        }
        .onDisappear() {
            profileViewModel.resetFetchStatus()
            profileViewModel.resetError()
        }
        .onChange(of: newPassword, perform: { newValue in
            profileViewModel.resetFetchStatus()
        })
        .alert(profileViewModel.errorTitle, isPresented: $profileViewModel.errorExists, actions: {
            Button("Okay", role: .cancel) {}
        }, message: {
            Text(profileViewModel.errorMessage)
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
