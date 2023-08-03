//
//  PasswordField.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 03/08/2023.
//

import SwiftUI

struct PasswordField: View {
    
    @Binding var passwordFieldText: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            TextField("Password", text: $passwordFieldText)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .font(.custom("Montserrat", size: 18))
                .fontWeight(.medium)
                .foregroundColor(Color("Black"))
            
            Button {
                action()
            } label: {
                Image(systemName: "eye.slash.fill")
            }
            .padding(.horizontal, 20)
            .foregroundColor(Color("Green"))
            
        }
        .background(Color("White"))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
