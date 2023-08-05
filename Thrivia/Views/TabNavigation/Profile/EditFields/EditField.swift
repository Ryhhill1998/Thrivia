//
//  EditEmail.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 22/07/2023.
//

import SwiftUI

struct EditField: View {
    
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
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
        if fieldType == "email" {
            profileViewModel.updateUserEmail(newEmail: newFieldValue)
        } else {
            profileViewModel.updateUserUsername(newUsername: newFieldValue)
        }
    }
    
    func backPressed() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 15.0) {
                VStack(spacing: 15.0) {
                    FieldDisplay(fieldType: fieldType, currentValue: currentFieldValue)
                    
                    LineSeparator()
                    
                    FieldInput(fieldType: fieldType, placeholder: placeholder, fieldValue: $newFieldValue)
                }
                .padding()
                .background(Color("White"))
                .cornerRadius(10)
                .padding(.horizontal)
                
                SaveButton(fetchStatus: profileViewModel.fetchStatus, action: saveField)
                
                Spacer()
            }
            .padding(.top, 20.0)
            
            InfoAlert(title: profileViewModel.errorTitle, message: profileViewModel.errorMessage, presentationBind: $profileViewModel.errorExists)
        }
        .onDisappear() {
            profileViewModel.resetFetchStatus()
            profileViewModel.resetError()
        }
        .onChange(of: newFieldValue, perform: { newValue in
            if !newValue.isEmpty {
                profileViewModel.resetFetchStatus()
            }
        })
        .onChange(of: profileViewModel.fetchStatus, perform: { newValue in
            if newValue == "success" {
                newFieldValue = ""
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
                Text("Edit \(fieldType.capitalized)")
                    .bold()
            }
        }
        .toolbar(.visible, for: .navigationBar)
    }
}

struct EditEmail_Previews: PreviewProvider {
    static var previews: some View {
        EditField(fieldType: "email", currentFieldValue: "ZigzagZebra24@mail.com")
            .environmentObject(ProfileViewModel())
    }
}

struct FieldDisplay: View {
    
    let fieldType: String
    let currentValue: String
    
    var body: some View {
        HStack {
            FieldLabel(label: "Current \(fieldType)")
            
            Text(currentValue)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(Color("Black"))
                .font(.custom("Montserrat", size: 15))
        }
    }
}
