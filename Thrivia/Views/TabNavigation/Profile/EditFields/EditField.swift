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
        if fieldType == "email" {
            profileViewModel.updateUserEmail(newEmail: newFieldValue)
        } else {
            profileViewModel.updateUserUsername(newUsername: newFieldValue)
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
                
                ActionButton(text: "Save", fontColour: Color("White"), backgroundColour: Color("Green")) {
                    print("hello")
                }
                
                Spacer()
            }
            .padding(.top, 20.0)
        }
    }
}

struct EditEmail_Previews: PreviewProvider {
    static var previews: some View {
        EditField(fieldType: "username", currentFieldValue: "ZigzagZebra24@mail.com")
            .environmentObject(ProfileViewModel())
    }
}
