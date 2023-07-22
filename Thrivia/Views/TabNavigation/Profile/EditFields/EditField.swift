//
//  EditEmail.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 22/07/2023.
//

import SwiftUI

struct EditField: View {
    
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    let fieldType: String
    let currentFieldValue: String
    var placeholder: String {
        if fieldType == "email" {
            return "Enail address"
        } else {
            return "Username"
        }
    }
    
    @State var newFieldValue = ""
    
    func saveField() {
        if newFieldValue.isEmpty {
            profileViewModel.setError(error: "New \(fieldType) cannot be empty.")
        } else if fieldType == "email" {
            profileViewModel.updateUserEmail(newEmail: newFieldValue)
        } else {
            profileViewModel.updateUserUsername(newUsername: newFieldValue)
            newFieldValue = ""
        }
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 15.0) {
                VStack(spacing: 15.0) {
                    HStack {
                        Text("Current \(fieldType)")
                            .foregroundColor(Color("Black"))
                            .font(.custom("Montserrat", size: 15))
                            .fontWeight(.semibold)
                        
                        Text(currentFieldValue)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(Color("Black"))
                            .font(.custom("Montserrat", size: 15))
                    }
                    
                    LineSeparator()
                    
                    HStack {
                        Text("New \(fieldType)")
                            .foregroundColor(Color("Black"))
                            .font(.custom("Montserrat", size: 15))
                            .fontWeight(.semibold)
                        
                        TextField(placeholder, text: $newFieldValue)
                            .multilineTextAlignment(.trailing)
                            .font(.custom("Montserrat", size: 15))
                            .fontWeight(.medium)
                            .foregroundColor(Color("Black"))
                    }
                }
                .padding()
                .background(Color("White"))
                .cornerRadius(10)
                .padding(.horizontal)
                
                if profileViewModel.fetchStatus == "pending" {
                    ProgressButton(text: "Saving", foregroundColour: Color("White"), backgroundColour: Color("Green"))
                } else if profileViewModel.fetchStatus == "idle" || profileViewModel.fetchStatus == "failure" {
                    ActionButton(text: "Save", fontColour: Color("White"), backgroundColour: Color("Green"), action: saveField)
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
        .alert("Update failure", isPresented: $profileViewModel.errorExists, actions: {
            Button("Okay", role: .cancel) {}
        }, message: {
            Text(profileViewModel.error)
        })
        .toolbar(.hidden, for: .tabBar)
    }
}

struct EditEmail_Previews: PreviewProvider {
    static var previews: some View {
        EditField(fieldType: "username", currentFieldValue: "ZigzagZebra24@mail.com")
            .environmentObject(ProfileViewModel())
    }
}
