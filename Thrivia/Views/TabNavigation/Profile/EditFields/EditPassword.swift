//
//  EditPassword.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 22/07/2023.
//

import SwiftUI

struct EditPassword: View {
    
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @State var newPassword = ""
    @State var confirmPassword = ""
    
    @State var showPassword = false
    
    func savePassword() {
        profileViewModel.updateUserPassword(newPassword: newPassword)
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
                
                ActionButton(text: "Save", fontColour: Color("White"), backgroundColour: Color("Green")) {
                    print("hello")
                }
                
                Spacer()
            }
            .padding(.top, 20.0)
        }
    }
}

struct EditPassword_Previews: PreviewProvider {
    static var previews: some View {
        EditPassword()
            .environmentObject(ProfileViewModel())
    }
}
